package com.example.lms_backend.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.Map;

import com.example.lms_backend.dto.ClassDetailDTO;
import com.example.lms_backend.dto.ApiResponse;
import com.example.lms_backend.service.LopHocDetailService;
import com.example.lms_backend.service.LopHocService;

@RestController
@RequestMapping("/api/lophoc")
@CrossOrigin(origins = "http://localhost:3000")
public class LopHocDetailController {

    @Autowired
    private LopHocDetailService detailService;

    @Autowired
    private LopHocService lopHocService;

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

    // API: POST /api/lophoc/{maLopHoc}/create-khao-sat
    @PostMapping("/{maLopHoc}/create-khao-sat")
    public ResponseEntity<?> createSurvey(@PathVariable String maLopHoc, @RequestBody Map<String, Object> request) {
        try {
            String tenKhaoSat = (String) request.get("tenKhaoSat");
            String moTa = (String) request.get("moTa");
            String thoigianBatDauStr = (String) request.get("thoigianBatDau");
            String thoiGianKetThucStr = (String) request.get("thoiGianKetThuc");

            // Parse LocalDateTime from string
            java.time.LocalDateTime thoigianBatDau = java.time.LocalDateTime.parse(thoigianBatDauStr);
            java.time.LocalDateTime thoiGianKetThuc = java.time.LocalDateTime.parse(thoiGianKetThucStr);

            // Create survey and link to class
            lopHocService.createSurveyAndLinkClass(maLopHoc, tenKhaoSat, moTa, thoigianBatDau, thoiGianKetThuc);

            // Get updated class detail
            ClassDetailDTO updatedData = detailService.getClassDetail(maLopHoc);

            // Return as Map with status and data
            Map<String, Object> response = new java.util.HashMap<>();
            response.put("status", "success");
            response.put("message", "Tạo khảo sát thành công!");
            response.put("data", updatedData);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse("error", "Lỗi: " + e.getMessage()));
        }
    }
}