package com.example.lms_backend.dto;

public class LopHocDTO {
    private String maLopHoc;
    private String tenMon;       // Đã gộp tên + mã môn (Ví dụ: "Lập trình Web (CO3001)")
    private String tenGiangVien;
    private String maGV;
    private String maMonHoc;

    public LopHocDTO(String maLopHoc, String tenMon, String tenGiangVien, String maGV, String maMonHoc) {
        this.maLopHoc = maLopHoc;
        this.tenMon = tenMon;
        this.tenGiangVien = tenGiangVien;
        this.maGV = maGV;
        this.maMonHoc = maMonHoc;
    }

    // --- Getter & Setter (Bạn tự generate nhé) ---
    public String getMaLopHoc() { return maLopHoc; }
    public String getTenMon() { return tenMon; }
    public String getTenGiangVien() { return tenGiangVien; }
    public String getMaGV() { return maGV; }
    public String getMaMonHoc() { return maMonHoc; }
}