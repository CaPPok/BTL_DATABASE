package com.example.lms_backend.dto;

public class DashboardStatDTO {
    private String maMonHoc;
    private String tenMonHoc;
    private int tongSoBai;
    private int soBaiDaLam;
    private Double diemTrungBinh;
    private Double diemCaoNhat;

    // Constructor rỗng (Bắt buộc để tạo object rỗng trước khi set dữ liệu)
    public DashboardStatDTO() {
    }

    // Constructor đầy đủ (Tùy chọn)
    public DashboardStatDTO(String maMonHoc, String tenMonHoc, int tongSoBai, int soBaiDaLam, Double diemTrungBinh, Double diemCaoNhat) {
        this.maMonHoc = maMonHoc;
        this.tenMonHoc = tenMonHoc;
        this.tongSoBai = tongSoBai;
        this.soBaiDaLam = soBaiDaLam;
        this.diemTrungBinh = diemTrungBinh;
        this.diemCaoNhat = diemCaoNhat;
    }

    // --- GETTER & SETTER ---
    public String getMaMonHoc() { return maMonHoc; }
    public void setMaMonHoc(String maMonHoc) { this.maMonHoc = maMonHoc; }

    public String getTenMonHoc() { return tenMonHoc; }
    public void setTenMonHoc(String tenMonHoc) { this.tenMonHoc = tenMonHoc; }

    public int getTongSoBai() { return tongSoBai; }
    public void setTongSoBai(int tongSoBai) { this.tongSoBai = tongSoBai; }

    public int getSoBaiDaLam() { return soBaiDaLam; }
    public void setSoBaiDaLam(int soBaiDaLam) { this.soBaiDaLam = soBaiDaLam; }

    public Double getDiemTrungBinh() { return diemTrungBinh; }
    public void setDiemTrungBinh(Double diemTrungBinh) { this.diemTrungBinh = diemTrungBinh; }

    public Double getDiemCaoNhat() { return diemCaoNhat; }
    public void setDiemCaoNhat(Double diemCaoNhat) { this.diemCaoNhat = diemCaoNhat; }
}