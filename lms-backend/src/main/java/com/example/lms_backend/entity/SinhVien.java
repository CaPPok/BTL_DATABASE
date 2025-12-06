package com.example.lms_backend.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "SinhVien", schema = "Management")
public class SinhVien {

    @Id
    @Column(name = "MaNguoiDung")
    private String maNguoiDung;

    @OneToOne(fetch = FetchType.LAZY)
    @MapsId // Copy ID từ NguoiDung sang SinhVien
    @JoinColumn(name = "MaNguoiDung") 
    private NguoiDung nguoiDung;

    @Column(name = "MaSoSinhVien", unique = true)
    private String maSoSinhVien;

    // 1. Constructor rỗng (Bắt buộc cho JPA)
    public SinhVien() {
    }

    // 2. Constructor đầy đủ (Để tạo mới cho nhanh)
    public SinhVien(NguoiDung nguoiDung, String maSoSinhVien) {
        this.nguoiDung = nguoiDung;
        this.maSoSinhVien = maSoSinhVien;
        // Không cần set maNguoiDung thủ công, @MapsId sẽ tự lấy từ object nguoiDung
    }

    // 3. Getter và Setter
    public String getMaNguoiDung() {
        return maNguoiDung;
    }

    public void setMaNguoiDung(String maNguoiDung) {
        this.maNguoiDung = maNguoiDung;
    }

    public NguoiDung getNguoiDung() {
        return nguoiDung;
    }

    public void setNguoiDung(NguoiDung nguoiDung) {
        this.nguoiDung = nguoiDung;
    }

    public String getMaSoSinhVien() {
        return maSoSinhVien;
    }

    public void setMaSoSinhVien(String maSoSinhVien) {
        this.maSoSinhVien = maSoSinhVien;
    }
}