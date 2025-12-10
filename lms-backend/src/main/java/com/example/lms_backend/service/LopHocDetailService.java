package com.example.lms_backend.service;

import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.StreamUtils;

import com.example.lms_backend.dto.ClassDetailDTO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Service
public class LopHocDetailService {

    @PersistenceContext
    private EntityManager entityManager;

    @Value("classpath:sql/get_class_header.sql")
    private Resource headerSql;

    @Value("classpath:sql/get_class_content.sql")
    private Resource contentSql;

    public ClassDetailDTO getClassDetail(String maLopHoc) {
        try {
            // 1. LẤY HEADER
            String sqlHeader = StreamUtils.copyToString(headerSql.getInputStream(), StandardCharsets.UTF_8);
            Query qHeader = entityManager.createNativeQuery(sqlHeader);
            qHeader.setParameter("maLopHoc", maLopHoc);
            
            Object[] headerRow = (Object[]) qHeader.getSingleResult();
            ClassDetailDTO result = new ClassDetailDTO(
                (String) headerRow[0], // MaLop
                (String) headerRow[1], // TenMon
                (String) headerRow[2],  // TenGV
                (String) headerRow[3]  // MaNguoiDung của Giảng viên
            );
            // Set MaKhaoSat từ headerRow[4]
            String maKhaoSat = (String) headerRow[4];
            result.setMaKhaoSat(maKhaoSat);

            // FETCH FULL SURVEY DATA IF EXISTS
            if (maKhaoSat != null && !maKhaoSat.trim().isEmpty()) {
                try {
                    String sqlKhaoSat = "SELECT TenKhaoSat, TenKhaoSat AS MaKhaoSat, MoTa, ThoigianBatDau, ThoiGianKetThuc " +
                                       "FROM Survey.KhaoSat WHERE TenKhaoSat = :tenKhaoSat";
                    Query qKhaoSat = entityManager.createNativeQuery(sqlKhaoSat);
                    qKhaoSat.setParameter("tenKhaoSat", maKhaoSat);
                    
                    Object[] khaoSatRow = (Object[]) qKhaoSat.getSingleResult();
                    if (khaoSatRow != null) {
                        ClassDetailDTO.KhaoSatDTO khaoSatDTO = new ClassDetailDTO.KhaoSatDTO(
                            (String) khaoSatRow[1],  // MaKhaoSat (TenKhaoSat)
                            (String) khaoSatRow[0],  // TenKhaoSat
                            (String) khaoSatRow[2],  // MoTa
                            khaoSatRow[3] != null ? khaoSatRow[3].toString() : null,  // ThoigianBatDau
                            khaoSatRow[4] != null ? khaoSatRow[4].toString() : null   // ThoiGianKetThuc
                        );
                        result.setKhaoSat(khaoSatDTO);
                    }
                } catch (Exception e) {
                    // If survey not found, just continue without it
                    System.err.println("Không tìm thấy khảo sát: " + maKhaoSat);
                }
            }

            // 2. LẤY NỘI DUNG (MỤC & TÀI LIỆU)
            String sqlContent = StreamUtils.copyToString(contentSql.getInputStream(), StandardCharsets.UTF_8);
            Query qContent = entityManager.createNativeQuery(sqlContent);
            qContent.setParameter("maLopHoc", maLopHoc);
            
            @SuppressWarnings("unchecked")
            List<Object[]> rows = qContent.getResultList();

            // 3. XỬ LÝ GOM NHÓM (Mapping từ SQL phẳng sang Tree DTO)
            Map<Integer, ClassDetailDTO.MucTaiLieuDTO> mucMap = new LinkedHashMap<>();

            for (Object[] row : rows) {
                Integer maMuc = (Integer) row[0];
                String tenMuc = (String) row[1];
                String moTaMuc = (String) row[2];
                
                // Nếu mục chưa có trong map thì tạo mới
                mucMap.putIfAbsent(maMuc, new ClassDetailDTO.MucTaiLieuDTO(maMuc, tenMuc, moTaMuc));

                // Nếu có tài liệu (row[2] không null) thì add vào mục
                if (row[2] != null) {
                    Integer maTL = (Integer) row[3];
                    String tenTL = (String) row[4];
                    String loaiTL = (String) row[5];
                    String moTaTL = (String) row[6];
                    String link = (String) row[7];
                    
                    mucMap.get(maMuc).addTaiLieu(new ClassDetailDTO.TaiLieuDTO(maTL, tenTL, loaiTL, moTaTL, link));
                }
            }

            // Add tất cả mục vào kết quả
            result.getDanhSachMuc().addAll(mucMap.values());
            
            return result;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi lấy chi tiết lớp học: " + e.getMessage());
        }
    }
}