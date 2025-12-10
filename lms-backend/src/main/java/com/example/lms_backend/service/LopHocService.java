package com.example.lms_backend.service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

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
import org.springframework.transaction.annotation.Transactional;


import com.example.lms_backend.dto.LopHocDTO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Service
public class LopHocService {

    @PersistenceContext
    private EntityManager entityManager;

    // --- 1. HÀM TÌM KIẾM & SẮP XẾP (Dùng cho cả API tìm kiếm và API xuất Excel) ---
    public List<LopHocDTO> timKiemVaSapXep(String keyword, String sortType, String maNguoiDung) {
        String inputKey = (keyword == null) ? "" : keyword;
        String inputSort = (sortType == null || sortType.isEmpty()) ? "TEN_AZ" : sortType;

        try {
            // Kiểm tra xem người dùng là sinh viên hay giảng viên
            String checkRoleSql = "SELECT COUNT(*) FROM Management.SinhVien WHERE MaNguoiDung = :maNguoiDung";
            Query checkQuery = entityManager.createNativeQuery(checkRoleSql);
            checkQuery.setParameter("maNguoiDung", maNguoiDung);
            int isSinhVien = ((Number) checkQuery.getSingleResult()).intValue();
            
            String sql;
            Query query;
            
            if (isSinhVien > 0) {
                // Là Sinh viên - dùng procedure cũ (qua ThamGiaLopHoc)
                sql = "EXEC Management.sp_TimKiemKhoaHoc_LocThongMinh @TuKhoaInput = :tuKhoa, @KieuSapXep = :kieuSapXep, @MaNguoiDungSV = :MaNguoiDungSV";
                query = entityManager.createNativeQuery(sql);
                query.setParameter("MaNguoiDungSV", maNguoiDung);
            } else {
                // Là Giảng viên - lấy lớp mà giảng viên đó dạy
                sql = "SELECT " +
                      "LH.MaLopHoc, " +
                      "MH.TenMonHoc + ' (' + CAST(MH.MaMonHoc AS NVARCHAR(20)) + ') ' AS TenMon, " +
                      "ND.HoTen AS TenGiangVien, " +
                      "GV.MaSoCanBo AS MaGV, " +
                      "MH.MaMonHoc " +
                      "FROM Management.LopHoc LH " +
                      "JOIN Management.MonHoc MH ON LH.MaMonHoc = MH.MaMonHoc " +
                      "JOIN Management.GiangVien GV ON LH.MaNguoiDay = GV.MaNguoiDung " +
                      "JOIN Management.NguoiDung ND ON GV.MaNguoiDung = ND.MaNguoiDung " +
                      "WHERE LH.MaNguoiDay = :maNguoiDay " +
                      "AND (:tuKhoa = '' OR " +
                      "(SELECT COUNT(*) FROM STRING_SPLIT(:tuKhoa, ' ') AS TuDon " +
                      "WHERE TuDon.value <> '' AND (" +
                      "MH.TenMonHoc LIKE '%' + TuDon.value + '%' OR " +
                      "ND.HoTen LIKE '%' + TuDon.value + '%' OR " +
                      "GV.MaSoCanBo LIKE '%' + TuDon.value + '%' OR " +
                      "CAST(LH.MaLopHoc AS NVARCHAR(20)) LIKE '%' + TuDon.value + '%' OR " +
                      "CAST(MH.MaMonHoc AS NVARCHAR(20)) LIKE '%' + TuDon.value + '%')) = " +
                      "(SELECT COUNT(*) FROM STRING_SPLIT(:tuKhoa, ' ') WHERE value <> '')) " +
                      "ORDER BY " +
                      "CASE WHEN :kieuSapXep = 'TEN_AZ' THEN MH.TenMonHoc END ASC, " +
                      "CASE WHEN :kieuSapXep = 'TEN_ZA' THEN MH.TenMonHoc END DESC, " +
                      "CASE WHEN :kieuSapXep = 'MOI_NHAT' THEN LH.MaLopHoc END DESC, " +
                      "MH.TenMonHoc ASC";
                query = entityManager.createNativeQuery(sql);
                query.setParameter("maNguoiDay", maNguoiDung);
            }
            
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

    // --- 3. HÀM THÊM LỚP HỌC (Gọi Procedure PR_InsertLopHoc) ---
    @Transactional
    public void themLopHoc(String maLopHoc, String maMonHoc, String maNguoiDay) {
        try {
            String sql = "EXEC Management.PR_InsertLopHoc @MaLopHoc = :maLopHoc, @MaMonHoc = :maMonHoc, @MaNguoiDay = :maNguoiDay";
            Query query = entityManager.createNativeQuery(sql);
            query.setParameter("maLopHoc", maLopHoc);
            query.setParameter("maMonHoc", maMonHoc);
            query.setParameter("maNguoiDay", maNguoiDay);
            query.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi thêm lớp học: " + e.getMessage(), e);
        }
    }

    // --- 4. HÀM SỬA LỚP HỌC (Gọi Procedure PR_UpdateLopHoc) ---
    @Transactional
    public void suaLopHoc(String maLopHoc, String maMonHoc, String maNguoiDay) {
        try {
            String sql = "EXEC Management.PR_UpdateLopHoc @MaLopHoc = :maLopHoc, @MaKhaoSat = NULL, @MaMonHoc = :maMonHoc, @MaNguoiDay = :maNguoiDay";
            Query query = entityManager.createNativeQuery(sql);
            query.setParameter("maLopHoc", maLopHoc);
            query.setParameter("maMonHoc", maMonHoc);
            query.setParameter("maNguoiDay", maNguoiDay);
            query.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi sửa lớp học: " + e.getMessage(), e);
        }
    }

    // --- 5. HÀM XÓA LỚP HỌC (Gọi Procedure PR_DeleteLopHoc) ---
    @Transactional
    public void xoaLopHoc(String maLopHoc) {
        try {
            String sql = "EXEC Management.PR_DeleteLopHoc @MaLopHoc = :maLopHoc";
            Query query = entityManager.createNativeQuery(sql);
            query.setParameter("maLopHoc", maLopHoc);
            query.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi xóa lớp học: " + e.getMessage(), e);
        }
    }

    // --- 6. HÀM LẤY DANH SÁCH MÔN HỌC VÀ GIẢNG VIÊN (Hỗ trợ Form Thêm/Sửa) ---
    public List<Object[]> layDanhSachMonHoc() {
        try {
            String sql = "SELECT MaMonHoc, TenMonHoc FROM Management.MonHoc ORDER BY TenMonHoc";
            Query query = entityManager.createNativeQuery(sql);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Object[]> layDanhSachGiangVien() {
        try {
            String sql = "SELECT MaNguoiDung, HoTen FROM Management.GiangVien ORDER BY HoTen";
            Query query = entityManager.createNativeQuery(sql);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}