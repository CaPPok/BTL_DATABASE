// com.example.lms_backend.entity.LopHoc.java
package com.example.lms_backend.entity;

import com.fasterxml.jackson.annotation.JsonIgnore; // Import này quan trọng

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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

    // --- THÊM ĐOẠN NÀY ---
    @ManyToOne
    @JoinColumn(name = "MaMonHoc", insertable = false, updatable = false)
    @JsonIgnore // Ngắt vòng lặp vô tận khi chuyển sang JSON
    private MonHoc monHocInfo;
    // ---------------------

    // Getter Setter cũ giữ nguyên...
    public String getMaLopHoc() { return maLopHoc; }
    public void setMaLopHoc(String maLopHoc) { this.maLopHoc = maLopHoc; }
    public String getMaKhaoSat() { return maKhaoSat; }
    public void setMaKhaoSat(String maKhaoSat) { this.maKhaoSat = maKhaoSat; }
    public String getMaNguoiDay() { return maNguoiDay; }
    public void setMaNguoiDay(String maNguoiDay) { this.maNguoiDay = maNguoiDay; }
    public String getMaMonHoc() { return maMonHoc; }
    public void setMaMonHoc(String maMonHoc) { this.maMonHoc = maMonHoc; }
}