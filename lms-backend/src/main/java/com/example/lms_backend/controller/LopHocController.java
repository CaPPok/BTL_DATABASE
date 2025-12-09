package com.example.lms_backend.controller;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.lms_backend.dto.LopHocDTO;
import com.example.lms_backend.entity.LopHoc;
import com.example.lms_backend.service.LopHocService;

@RestController
@RequestMapping("/api/lophoc")
@CrossOrigin(origins = "http://localhost:3000")
public class LopHocController {

    @Autowired
    private LopHocService lopHocService; // Gọi Service

    // API lấy lớp của sinh viên
    @GetMapping("/tim-kiem") // Hoặc giữ nguyên URL cũ tùy bạn
    public ResponseEntity<?> timKiemKhoaHoc(
        @RequestParam(required = false, defaultValue = "") String search,
        @RequestParam(required = false, defaultValue = "TEN_AZ") String sort
    ) {
        List<LopHocDTO> list = lopHocService.timKiemVaSapXep(search, sort);
        return ResponseEntity.ok(list);
    }
    @GetMapping("/export")
    public ResponseEntity<InputStreamResource> exportExcel(
            @RequestParam(required = false, defaultValue = "") String search,
            @RequestParam(required = false, defaultValue = "TEN_AZ") String sort
    ) {
        try {
            ByteArrayInputStream in = lopHocService.exportLopHocToExcel(search, sort);

            HttpHeaders headers = new HttpHeaders();
            headers.add("Content-Disposition", "attachment; filename=DanhSachKhoaHoc.xlsx");

            return ResponseEntity
                    .ok()
                    .headers(headers)
                    .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                    .body(new InputStreamResource(in));
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
}