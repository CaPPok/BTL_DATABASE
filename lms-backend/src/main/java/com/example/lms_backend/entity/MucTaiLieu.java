package com.example.lms_backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "MucTaiLieu", schema = "Management") 
public class MucTaiLieu {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaMuc")
    private Integer maMuc;

    @Column(name = "MaLopHoc") 
    private String maLopHoc;

    @Column(name = "TenMuc")
    private String tenMuc;      
    
    @Column(name = "MoTa")
    private String moTa;  

    public String getMaLopHoc() { return maLopHoc; }
    public void setMaLopHoc(String maLopHoc) { this.maLopHoc = maLopHoc; }

    public Integer getMaMuc() { return maMuc; }
    public void setMaMuc(Integer maMuc) { this.maMuc = maMuc; }

    public String getTenMuc() { return tenMuc; }
    public void setTenMuc(String tenMuc) { this.tenMuc = tenMuc; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
}
