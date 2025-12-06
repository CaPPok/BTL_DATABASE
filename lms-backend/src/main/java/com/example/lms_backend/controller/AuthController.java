package com.example.lms_backend.controller;

import com.example.lms_backend.dto.*;
import com.example.lms_backend.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://localhost:3000") // Cho phép Next.js gọi vào
public class AuthController {

    @Autowired
    private NguoiDungRepository repo;

    @PostMapping("/Login")
    public ResponseEntity<?> login(@RequestBody LoginRequest req) {
        // Gọi query database
        var result = repo.checkLogin(req.getMaNguoiDung(), req.getMatKhau());

        if (result.isPresent()) {
            ILoginResult user = result.get();
            // Trả về thông tin kèm Role
            return ResponseEntity.ok(new LoginResponse(
                user.getMaNguoiDung(), 
                user.getHoTen(), 
                user.getRole()
            ));
        } else {
            return ResponseEntity.status(401).body("Sai email hoặc mật khẩu");
        }
    }
}