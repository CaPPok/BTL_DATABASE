package com.example.lms_backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "LopHoc", schema = "Management") 
public class LopHoc {
    
    @Id
    @Column(name = "MaLopHoc") 
    private String maLopHoc;

    @Column(name = "MaKhaoSat")
    private String maKhaoSat; 

    @Column(name = "MaMonHoc")
    private String maMonHoc;      
    
    @Column(name = "MaNguoiDay")
    private String maNguoiDay;  

    public String getMaLopHoc() { return maLopHoc; }
    public void setMaLopHoc(String maLopHoc) { this.maLopHoc = maLopHoc; }

    public String getMaKhaoSat() { return maKhaoSat; }
    public void setMaKhaoSat(String maKhaoSat) { this.maKhaoSat = maKhaoSat; }

    public String getMaNguoiDay() { return maNguoiDay; }
    public void setMaNguoiDay(String maNguoiDay) { this.maNguoiDay = maNguoiDay; }

    public String getMaMonHoc() { return maMonHoc; }
    public void setMaMonHoc(String maMonHoc) { this.maMonHoc = maMonHoc; }
}
