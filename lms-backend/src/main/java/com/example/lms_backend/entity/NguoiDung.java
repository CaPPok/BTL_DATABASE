package com.example.lms_backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "NguoiDung", schema = "Management")
public class NguoiDung {
    @Id
    @Column(name = "MaNguoiDung")
    private String maNguoiDung;

    @Column(name = "Email")
    private String email;

    @Column(name = "GioiTinh")
    private Boolean gioiTinh;

    @Column(name = "MatKhau")
    private String matKhau;

    @Column(name = "HoTen")
    private String hoTen;

    @Column(name = "TrangThaiHoatDong")
    private Boolean trangThaiHoatDong;
    
    public NguoiDung() {}

    public String getMaNguoiDung() { return maNguoiDung; }
    public void setMaNguoiDung(String maNguoiDung) { this.maNguoiDung = maNguoiDung; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Boolean getGioiTinh() { return gioiTinh; }
    public void setGioiTinh(Boolean gioiTinh) { this.gioiTinh = gioiTinh; }

    public String getMatKhau() { return matKhau; }
    public void setMatKhau(String matKhau) { this.matKhau = matKhau; }

    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }

    public Boolean getTrangThaiHoatDong() { return trangThaiHoatDong; }
    public void setTrangThaiHoatDong(Boolean trangThaiHoatDong) { this.trangThaiHoatDong = trangThaiHoatDong; }
}