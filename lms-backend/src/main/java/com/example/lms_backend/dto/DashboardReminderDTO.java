package com.example.lms_backend.dto;

import java.util.Date;

public class DashboardReminderDTO {
    private String tenBaiKiemTra;
    private String tenMonHoc;
    private Date hanChotNopBai;
    private int soGioConLai;
    private String trangThai;

    // Constructor rỗng
    public DashboardReminderDTO() {
    }

    // Constructor đầy đủ
    public DashboardReminderDTO(String tenBaiKiemTra, String tenMonHoc, Date hanChotNopBai, int soGioConLai, String trangThai) {
        this.tenBaiKiemTra = tenBaiKiemTra;
        this.tenMonHoc = tenMonHoc;
        this.hanChotNopBai = hanChotNopBai;
        this.soGioConLai = soGioConLai;
        this.trangThai = trangThai;
    }

    // --- GETTER & SETTER ---
    public String getTenBaiKiemTra() { return tenBaiKiemTra; }
    public void setTenBaiKiemTra(String tenBaiKiemTra) { this.tenBaiKiemTra = tenBaiKiemTra; }

    public String getTenMonHoc() { return tenMonHoc; }
    public void setTenMonHoc(String tenMonHoc) { this.tenMonHoc = tenMonHoc; }

    public Date getHanChotNopBai() { return hanChotNopBai; }
    public void setHanChotNopBai(Date hanChotNopBai) { this.hanChotNopBai = hanChotNopBai; }

    public int getSoGioConLai() { return soGioConLai; }
    public void setSoGioConLai(int soGioConLai) { this.soGioConLai = soGioConLai; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
}