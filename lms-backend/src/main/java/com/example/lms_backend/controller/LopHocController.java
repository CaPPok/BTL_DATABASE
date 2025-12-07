package com.example.lms_backend.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.lms_backend.entity.LopHoc;
import com.example.lms_backend.service.LopHocService;

@RestController
@RequestMapping("/api/lophoc")
@CrossOrigin(origins = "http://localhost:3000")
public class LopHocController {

    @Autowired
    private LopHocService lopHocService; // Gọi Service

    // API lấy lớp của sinh viên
    @GetMapping("/SinhVien/{maNguoiDung}")
    public ResponseEntity<List<LopHoc>> getLopBySinhVien(@PathVariable String maNguoiDung) {
        // Gọi hàm trong Service -> Service đọc file SQL -> Trả về List<LopHoc>
        List<LopHoc> list = lopHocService.getLopHocBySinhVien(maNguoiDung);
        return ResponseEntity.ok(list);
    }
}