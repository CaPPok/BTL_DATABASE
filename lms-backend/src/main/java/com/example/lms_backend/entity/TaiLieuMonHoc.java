package com.example.lms_backend.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "TaiLieuMonHoc", schema = "Management")
public class TaiLieuMonHoc {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaTaiLieu")
    private Integer maTaiLieu;

    @Column(name = "TenTaiLieu")
    private String tenTaiLieu;

    @Column(name = "LoaiTaiLieu")
    private String loaiTaiLieu; // 'pdf', 'video', 'link'...

    // Getter & Setter (Cậu tự generate nhé)
    public Integer getMaTaiLieu() { return maTaiLieu; }
    public void setMaTaiLieu(Integer maTaiLieu) { this.maTaiLieu = maTaiLieu; }
    public String getTenTaiLieu() { return tenTaiLieu; }
    public void setTenTaiLieu(String tenTaiLieu) { this.tenTaiLieu = tenTaiLieu; }
    public String getLoaiTaiLieu() { return loaiTaiLieu; }
    public void setLoaiTaiLieu(String loaiTaiLieu) { this.loaiTaiLieu = loaiTaiLieu; }
}