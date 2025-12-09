package com.example.lms_backend.controller;

// --- QUAN TRỌNG: PHẦN IMPORT BẠN ĐANG THIẾU ---
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.lms_backend.service.DashboardService;
import com.example.lms_backend.dto.DashboardResponse;
// -----------------------------------------------

@RestController
@RequestMapping("/api/dashboard")
@CrossOrigin(origins = "http://localhost:3000")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    // API: GET /api/dashboard/{userId}
    @GetMapping("/{userId}")
    public ResponseEntity<DashboardResponse> getDashboard(@PathVariable String userId) {
        try {
            DashboardResponse data = dashboardService.getDashboardData(userId);
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
}