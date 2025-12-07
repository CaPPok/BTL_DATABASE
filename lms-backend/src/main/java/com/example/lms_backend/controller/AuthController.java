package com.example.lms_backend.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.lms_backend.dto.LoginRequest;
import com.example.lms_backend.dto.LoginResponse;
import com.example.lms_backend.service.AuthService;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://localhost:3000") // Cho phép Next.js gọi vào
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/Login")
    public ResponseEntity<?> login(@RequestBody LoginRequest req) {
        try {
            // Gọi logic bên Service (đã bao gồm check pass và lấy role)
            LoginResponse response = authService.login(req.getMaNguoiDung(), req.getMatKhau());
            
            // Trả về 200 OK kèm data
            return ResponseEntity.ok(response);

        } catch (RuntimeException e) {
            // Nếu lỗi (sai pass, không tồn tại user) -> Trả về 401
            return ResponseEntity.status(401).body(e.getMessage());
        }
    }
}