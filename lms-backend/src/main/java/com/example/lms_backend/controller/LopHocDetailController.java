package com.example.lms_backend.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.lms_backend.dto.ClassDetailDTO;
import com.example.lms_backend.service.LopHocDetailService;

@RestController
@RequestMapping("/api/lophoc")
@CrossOrigin(origins = "http://localhost:3000")
public class LopHocDetailController {

    @Autowired
    private LopHocDetailService detailService;

    // API: /api/lophoc/detail/HK251_CO2013_L01
    @GetMapping("/detail/{maLopHoc}")
    public ResponseEntity<?> getClassDetail(@PathVariable String maLopHoc) {
        try {
            ClassDetailDTO data = detailService.getClassDetail(maLopHoc);
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi: " + e.getMessage());
        }
    }
}