package com.example.lms_backend.controller;

import java.io.ByteArrayInputStream;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.lms_backend.dto.LopHocDTO;
import com.example.lms_backend.service.LopHocService;
import com.example.lms_backend.dto.ApiResponse;

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
        @RequestParam(required = false, defaultValue = "TEN_AZ") String sort,
        @RequestParam(required = true) String maNguoiDung
    ) {
        List<LopHocDTO> list = lopHocService.timKiemVaSapXep(search, sort, maNguoiDung);
        return ResponseEntity.ok(list);
    }

    // API Xuất Excel (Đã nâng cấp để bắt lỗi)
    @GetMapping("/export")
    public ResponseEntity<?> exportExcel( // Đổi thành <?> để linh hoạt trả về lỗi
        @RequestParam(required = false, defaultValue = "") String search,
        @RequestParam(required = false, defaultValue = "TEN_AZ") String sort,
        @RequestParam(required = true) String maNguoiDung
    ) {
        try {
            // Gọi Service lấy dữ liệu
            ByteArrayInputStream in = lopHocService.exportLopHocToExcel(search, sort, maNguoiDung);

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

    // --- API LẤY DANH SÁCH MÔN HỌC ---
    @GetMapping("/monhoc-list")
    public ResponseEntity<?> getMonHocList() {
        try {
            List<Object[]> list = lopHocService.layDanhSachMonHoc();
            return ResponseEntity.ok(list);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Lỗi Server: " + e.getMessage());
        }
    }

    // --- API LẤY DANH SÁCH GIẢNG VIÊN ---
    @GetMapping("/giangvien-list")
    public ResponseEntity<?> getGiangVienList() {
        try {
            List<Object[]> list = lopHocService.layDanhSachGiangVien();
            return ResponseEntity.ok(list);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Lỗi Server: " + e.getMessage());
        }
    }

    // --- API THÊM LỚP HỌC ---
    @PostMapping("/add")
    public ResponseEntity<?> themLopHoc(@RequestBody Map<String, String> request) {
        try {
            String maLopHoc = request.get("maLopHoc");
            String maMonHoc = request.get("maMonHoc");
            String maNguoiDay = request.get("maNguoiDay");

            lopHocService.themLopHoc(maLopHoc, maMonHoc, maNguoiDay);
            return ResponseEntity.ok(new ApiResponse("success", "Thêm lớp học thành công!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse("error", e.getMessage()));
        }
    }

    // --- API SỬA LỚP HỌC ---
    @PutMapping("/update/{maLopHoc}")
    public ResponseEntity<?> suaLopHoc(@PathVariable String maLopHoc, @RequestBody Map<String, String> request) {
        try {
            String maMonHoc = request.get("maMonHoc");
            String maNguoiDay = request.get("maNguoiDay");
            // Note: maKhaoSat sẽ bị bỏ qua, service sẽ luôn giữ nguyên giá trị cũ từ database

            lopHocService.suaLopHoc(maLopHoc, maMonHoc, maNguoiDay);
            return ResponseEntity.ok(new ApiResponse("success", "Sửa lớp học thành công!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse("error", e.getMessage()));
        }
    }

    // --- API XÓA LỚP HỌC ---
    @DeleteMapping("/delete/{maLopHoc}")
    public ResponseEntity<?> xoaLopHoc(@PathVariable String maLopHoc) {
        try {
            lopHocService.xoaLopHoc(maLopHoc);
            return ResponseEntity.ok(new ApiResponse("success", "Xóa lớp học thành công!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse("error", e.getMessage()));
        }
    }
}