package com.example.lms_backend.dto;

public class LoginResponse {
    private String maNguoiDung;
    private String hoTen;
    private String role;

    public LoginResponse(String maNguoiDung, String hoTen, String role) {
        this.maNguoiDung = maNguoiDung;
        this.hoTen = hoTen;
        this.role = role;
    }
    
    // GETTER
    public String getMaNguoiDung() {
        return maNguoiDung;
    }

    public String getHoTen() {
        return hoTen;
    }

    public String getRole() {
        return role;
    }

    // SETTER
    public void setMaNguoiDung(String maNguoiDung) {
        this.maNguoiDung = maNguoiDung;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public void setRole(String role) {
        this.role = role;
    }
}