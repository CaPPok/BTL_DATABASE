package com.example.lms_backend.service;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.StreamUtils;

import com.example.lms_backend.dto.LoginResponse;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Service
public class AuthService {

    @PersistenceContext
    private EntityManager entityManager;

    @Value("classpath:sql/login.sql")
    private Resource loginSqlResource;

    public LoginResponse login(String maNguoiDung, String matKhauInput) {
        try {
            // 1. Đọc file SQL
            String sql = StreamUtils.copyToString(loginSqlResource.getInputStream(), StandardCharsets.UTF_8);

            // 2. Chạy Query Native
            Query query = entityManager.createNativeQuery(sql);
            query.setParameter("maNguoiDung", maNguoiDung);

            // 3. Lấy kết quả dưới dạng Mảng Object (Object[]) vì ta select nhiều cột tùy chỉnh
            // Thêm dòng này để tắt cảnh báo vàng
            @SuppressWarnings("unchecked") 
            List<Object[]> results = query.getResultList();

            if (results.isEmpty()) {
                throw new RuntimeException("Tài khoản không tồn tại!");
            }

            // 4. Map dữ liệu từ SQL sang biến
            Object[] row = results.get(0);
            String dbMaNguoiDung = (String) row[0];
            String dbHoTen = (String) row[1];
            String dbMatKhau = ((String) row[2]).trim();
            String dbRole = (String) row[3]; // Cột Role do CASE WHEN tạo ra

            // 5. Kiểm tra mật khẩu
            if (!dbMatKhau.equals(matKhauInput)) {
                throw new RuntimeException("Sai mật khẩu!");
            }

            // 6. Trả về DTO
            return new LoginResponse(dbMaNguoiDung, dbHoTen, dbRole);

        } catch (IOException e) {
            throw new RuntimeException("Lỗi đọc file SQL: " + e.getMessage());
        }
    }
}