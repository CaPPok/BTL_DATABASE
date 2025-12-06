package com.example.lms_backend.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "NguoiDung", schema = "Management")
public class NguoiDung {
    @Id
    @Column(name = "MaNguoiDung")
    private String maNguoiDung;

    @Column(name = "Email")
    private String email;

    @Column(name = "MatKhau")
    private String matKhau;

    @Column(name = "HoTen")
    private String hoTen;

    public NguoiDung() {}

    public String getMaNguoiDung() { return maNguoiDung; }
    public void setMaNguoiDung(String maNguoiDung) { this.maNguoiDung = maNguoiDung; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getMatKhau() { return matKhau; }
    public void setMatKhau(String matKhau) { this.matKhau = matKhau; }
    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }
}