package com.example.lms_backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "MonHoc", schema = "Management") 
public class MonHoc {
    
    @Id
    @Column(name = "MaMonHoc") 
    private String maMonHoc;

    @Column(name = "TenMonHoc")
    private String tenMonHoc; 

    @Column(name = "MoTa")
    private String moTa;      
    
    public String getMaMonHoc() { return maMonHoc; }
    public void setMaMonHoc(String maMonHoc) { this.maMonHoc = maMonHoc; }

    public String getTenMonHoc() { return tenMonHoc; }
    public void setTenMonHoc(String tenMonHoc) { this.tenMonHoc = tenMonHoc; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
}