package com.example.lms_backend.dto;

import java.util.ArrayList;
import java.util.List;

public class ClassDetailDTO {
    // 1. Thông tin Header
    private String maLopHoc;
    private String tenMonHoc;
    private String tenGiangVien;
    private String maNguoiDung;
    private String maKhaoSat; // Thêm field khảo sát
    private KhaoSatDTO khaoSat; // Object khảo sát đầy đủ
    
    // 2. Danh sách các mục (Sections)
    private List<MucTaiLieuDTO> danhSachMuc = new ArrayList<>();

    public ClassDetailDTO(String maLopHoc, String tenMonHoc, String tenGiangVien, String maNguoiDung) {
        this.maLopHoc = maLopHoc;
        this.tenMonHoc = tenMonHoc;
        this.tenGiangVien = tenGiangVien;
        this.maNguoiDung = maNguoiDung;
        this.maKhaoSat = null;
        this.khaoSat = null;
    }

    // --- Inner Class: Khảo Sát ---
    public static class KhaoSatDTO {
        private String maKhaoSat;
        private String tenKhaoSat;
        private String moTa;
        private String thoigianBatDau;
        private String thoiGianKetThuc;

        public KhaoSatDTO(String maKhaoSat, String tenKhaoSat, String moTa, String thoigianBatDau, String thoiGianKetThuc) {
            this.maKhaoSat = maKhaoSat;
            this.tenKhaoSat = tenKhaoSat;
            this.moTa = moTa;
            this.thoigianBatDau = thoigianBatDau;
            this.thoiGianKetThuc = thoiGianKetThuc;
        }

        // Getter
        public String getMaKhaoSat() { return maKhaoSat; }
        public String getTenKhaoSat() { return tenKhaoSat; }
        public String getMoTa() { return moTa; }
        public String getThoigianBatDau() { return thoigianBatDau; }
        public String getThoiGianKetThuc() { return thoiGianKetThuc; }
    }

    // --- Inner Class: Mục Tài Liệu ---
    public static class MucTaiLieuDTO {
        private Integer maMuc;
        private String tenMuc;
        private String moTa;
        private List<TaiLieuDTO> taiLieus = new ArrayList<>();

        public MucTaiLieuDTO(Integer maMuc, String tenMuc, String moTa) {
            this.maMuc = maMuc;
            this.tenMuc = tenMuc;
            this.moTa = moTa;
        }
        
        // Getter Setter & Add method
        public String getMoTa() { return moTa; }
        public Integer getMaMuc() { return maMuc; }
        public String getTenMuc() { return tenMuc; }
        public List<TaiLieuDTO> getTaiLieus() { return taiLieus; }
        public void addTaiLieu(TaiLieuDTO tl) { this.taiLieus.add(tl); }
    }

    // --- Inner Class: Tài Liệu ---
    public static class TaiLieuDTO {
        private Integer maTaiLieu;
        private String tenTaiLieu;
        private String loaiTaiLieu; // pdf, link, video
        private String moTa;
        private String linkLienKet; // Link download hoặc link web

        public TaiLieuDTO(Integer maTaiLieu, String tenTaiLieu, String loaiTaiLieu, String moTa, String linkLienKet) {
            this.maTaiLieu = maTaiLieu;
            this.tenTaiLieu = tenTaiLieu;
            this.loaiTaiLieu = loaiTaiLieu;
            this.moTa = moTa;
            this.linkLienKet = linkLienKet;
        }
        
        // Getter Setter
        public String getMoTa() { return moTa; }
        public Integer getMaTaiLieu() { return maTaiLieu; }
        public String getTenTaiLieu() { return tenTaiLieu; }
        public String getLoaiTaiLieu() { return loaiTaiLieu; }
        public String getLinkLienKet() { return linkLienKet; }
    }

    // Getter Setter cho ClassDetailDTO
    public String getMaNguoiDung() { return maNguoiDung; }
    public String getMaLopHoc() { return maLopHoc; }
    public String getTenMonHoc() { return tenMonHoc; }
    public String getTenGiangVien() { return tenGiangVien; }
    public String getMaKhaoSat() { return maKhaoSat; }
    public void setMaKhaoSat(String maKhaoSat) { this.maKhaoSat = maKhaoSat; }
    public KhaoSatDTO getKhaoSat() { return khaoSat; }
    public void setKhaoSat(KhaoSatDTO khaoSat) { this.khaoSat = khaoSat; }
    public List<MucTaiLieuDTO> getDanhSachMuc() { return danhSachMuc; }
    public void addMuc(MucTaiLieuDTO muc) { this.danhSachMuc.add(muc); }
}