package com.example.lms_backend.service;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.StreamUtils;

import com.example.lms_backend.entity.LopHoc;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Service
public class LopHocService {

    @PersistenceContext
    private EntityManager entityManager;

    // 1. Trỏ tới file SQL vừa tạo
    @Value("classpath:sql/LopHoc.sql")
    private Resource findLopByUserSql;

    // Hàm lấy danh sách lớp theo sinh viên
    public List<LopHoc> getLopHocBySinhVien(String maNguoiDung) {
        try {
            String sql = StreamUtils.copyToString(findLopByUserSql.getInputStream(), StandardCharsets.UTF_8);

            Query query = entityManager.createNativeQuery(sql, LopHoc.class);
            query.setParameter("maNguoiDung", maNguoiDung);

            @SuppressWarnings("unchecked")
            List<LopHoc> result = query.getResultList();
            
            // 3. Trả về biến đó
            return result;

        } catch (IOException e) {
            throw new RuntimeException("Không đọc được file SQL 'LopHoc.sql'. Kiểm tra lại thư mục resources/sql!", e);
        }
    }
}