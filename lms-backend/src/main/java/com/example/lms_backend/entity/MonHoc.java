// com.example.lms_backend.entity.MonHoc.java
package com.example.lms_backend.entity;

import java.util.List;

import jakarta.persistence.Column; // Import List
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
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

    // --- THÊM ĐOẠN NÀY ---
    // mappedBy phải trùng tên với biến "monHocInfo" bên file LopHoc
    @OneToMany(mappedBy = "monHocInfo", fetch = FetchType.LAZY)
    private List<LopHoc> danhSachLop;

    // Getter cho danh sách lớp
    public List<LopHoc> getDanhSachLop() { return danhSachLop; }
    public void setDanhSachLop(List<LopHoc> danhSachLop) { this.danhSachLop = danhSachLop; }
    // ---------------------

    // Getter Setter cũ giữ nguyên...
    public String getMaMonHoc() { return maMonHoc; }
    public void setMaMonHoc(String maMonHoc) { this.maMonHoc = maMonHoc; }
    public String getTenMonHoc() { return tenMonHoc; }
    public void setTenMonHoc(String tenMonHoc) { this.tenMonHoc = tenMonHoc; }
    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
}