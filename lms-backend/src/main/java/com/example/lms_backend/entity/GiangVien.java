package com.example.lms_backend.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "GiangVien", schema = "Management")
public class GiangVien {

    @Id
    @Column(name = "MaNguoiDung")
    private String maNguoiDung;

    @OneToOne(fetch = FetchType.LAZY)
    @MapsId // Copy ID từ NguoiDung sang GiangVien
    @JoinColumn(name = "MaNguoiDung") 
    private NguoiDung nguoiDung;

    @Column(name = "MaSoCanBo", unique = true)
    private String maSoCanBo;


    // 1. Constructor rỗng (Bắt buộc cho JPA)
    public GiangVien() {
    }

    // 2. Constructor đầy đủ (Để tạo mới cho nhanh)
    public GiangVien(NguoiDung nguoiDung, String maSoCanBo) {
        this.nguoiDung = nguoiDung;
        this.maSoCanBo = maSoCanBo;
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

    public String getMaSoCanBo() {
        return maSoCanBo;
    }

    public void setMaSoCanBo(String maSoCanBo) {
        this.maSoCanBo = maSoCanBo;
    }
}