package com.example.lms_backend.controller;

import java.io.ByteArrayInputStream;
// import java.io.IOException; // Bỏ dòng này vì ta sẽ bắt Exception chung
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.lms_backend.dto.LopHocDTO;
import com.example.lms_backend.service.LopHocService;

@RestController
@RequestMapping("/api/lophoc")
@CrossOrigin(origins = "http://localhost:3000")
public class LopHocController {

    @Autowired
    private LopHocService lopHocService;

    // API tìm kiếm (Giữ nguyên)
    @GetMapping("/tim-kiem")
    public ResponseEntity<?> timKiemKhoaHoc(
        @RequestParam(required = false, defaultValue = "") String search,
        @RequestParam(required = false, defaultValue = "TEN_AZ") String sort
    ) {
        List<LopHocDTO> list = lopHocService.timKiemVaSapXep(search, sort);
        return ResponseEntity.ok(list);
    }

    // API Xuất Excel (Đã nâng cấp để bắt lỗi)
    @GetMapping("/export")
    public ResponseEntity<?> exportExcel( // Đổi thành <?> để linh hoạt trả về lỗi
            @RequestParam(required = false, defaultValue = "") String search,
            @RequestParam(required = false, defaultValue = "TEN_AZ") String sort
    ) {
        try {
            // Gọi Service lấy dữ liệu
            ByteArrayInputStream in = lopHocService.exportLopHocToExcel(search, sort);

            HttpHeaders headers = new HttpHeaders();
            headers.add("Content-Disposition", "attachment; filename=DanhSachKhoaHoc.xlsx");

            return ResponseEntity
                    .ok()
                    .headers(headers)
                    .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                    .body(new InputStreamResource(in));

        } catch (Exception e) { 
            // Bắt "Exception" thay vì "IOException" để tóm được cả lỗi SQL hay NullPointer
            
            // --- IN LỖI RA CONSOLE ĐỂ BẠN ĐỌC ---
            System.err.println("======================================");
            System.err.println("LỖI KHI XUẤT EXCEL: " + e.getMessage());
            e.printStackTrace(); 
            System.err.println("======================================");
            
            // Trả về lỗi cho Postman/Trình duyệt thấy
            return ResponseEntity.internalServerError().body("Lỗi Server: " + e.getMessage());
        }
    }
}