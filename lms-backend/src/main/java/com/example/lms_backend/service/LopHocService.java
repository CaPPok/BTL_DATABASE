package com.example.lms_backend.service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.StreamUtils;

import com.example.lms_backend.dto.LopHocDTO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Service
public class LopHocService {

    @PersistenceContext
    private EntityManager entityManager;

    @Value("classpath:sql/LopHoc.sql")
    private Resource searchSqlResource;

    // --- 1. HÀM TÌM KIẾM & SẮP XẾP (Dùng cho cả API tìm kiếm và API xuất Excel) ---
    public List<LopHocDTO> timKiemVaSapXep(String keyword, String sortType, String maNguoiDung) {
        String inputKey = (keyword == null) ? "" : keyword;
        String inputSort = (sortType == null || sortType.isEmpty()) ? "TEN_AZ" : sortType;

        try {
            // Gọi Stored Procedure
           String sql = "EXEC Management.sp_TimKiemKhoaHoc_LocThongMinh @TuKhoaInput = :tuKhoa, @KieuSapXep = :kieuSapXep, @MSSSV = :maSinhVien";
    
            Query query = entityManager.createNativeQuery(sql);
            query.setParameter("maNguoiDung", maNguoiDung);
            query.setParameter("tuKhoa", inputKey);
            query.setParameter("kieuSapXep", inputSort);

            @SuppressWarnings("unchecked")
            List<Object[]> results = query.getResultList();
            List<LopHocDTO> dtos = new ArrayList<>();

            for (Object[] row : results) {
                // SỬA QUAN TRỌNG: Kiểm tra null và dùng toString() để tránh lỗi ép kiểu
                String maLop = row[0] != null ? row[0].toString() : "";
                String tenMon = row[1] != null ? row[1].toString() : "";
                String tenGV = row[2] != null ? row[2].toString() : "";
                String maGV = row[3] != null ? row[3].toString() : "";
                String maMon = row[4] != null ? row[4].toString() : "";

                dtos.add(new LopHocDTO(maLop, tenMon, tenGV, maGV, maMon));
            }
            return dtos;
            
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>(); // Trả về rỗng nếu lỗi SQL để không sập app
        }
    }

    // --- 2. HÀM XUẤT EXCEL ---
    public ByteArrayInputStream exportLopHocToExcel(String keyword, String sortType, String maNguoiDung) throws IOException {
        // Lấy dữ liệu từ hàm trên
        List<LopHocDTO> danhSach = timKiemVaSapXep(keyword, sortType, maNguoiDung);

        // Khởi tạo Workbook (File Excel)
        try (Workbook workbook = new XSSFWorkbook(); 
             ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            
            Sheet sheet = workbook.createSheet("Danh sách khóa học");

            // Tạo Header
            Row headerRow = sheet.createRow(0);
            String[] columns = {"STT", "Mã Lớp", "Tên Môn Học", "Mã Môn", "Giảng Viên", "Mã GV"};
            
            // Style in đậm cho Header
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerStyle);
            }

            // Ghi dữ liệu
            int rowIdx = 1;
            for (LopHocDTO lop : danhSach) {
                Row row = sheet.createRow(rowIdx++);

                row.createCell(0).setCellValue(rowIdx - 1); // STT
                row.createCell(1).setCellValue(lop.getMaLopHoc());
                row.createCell(2).setCellValue(lop.getTenMon());
                row.createCell(3).setCellValue(lop.getMaMonHoc());
                row.createCell(4).setCellValue(lop.getTenGiangVien());
                row.createCell(5).setCellValue(lop.getMaGV());
            }

            // Tự động giãn cột
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
            return new ByteArrayInputStream(out.toByteArray());
        }
    }
}