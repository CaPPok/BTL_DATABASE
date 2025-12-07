package com.example.lms_backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

@Entity
@Table(name = "ThamGiaLopHoc", schema = "Management")
@IdClass(ThamGiaLopHocKey.class) // Báo cho JPA biết khóa chính nằm ở class kia
public class ThamGiaLopHoc {

    @Id
    @Column(name = "MaNguoiDung")
    private String maNguoiDung;

    @Id
    @Column(name = "MaLopHoc")
    private String maLopHoc;

    // Getter & Setter
    public String getMaNguoiDung() { return maNguoiDung; }
    public void setMaNguoiDung(String maNguoiDung) { this.maNguoiDung = maNguoiDung; }
    public String getMaLopHoc() { return maLopHoc; }
    public void setMaLopHoc(String maLopHoc) { this.maLopHoc = maLopHoc; }
}