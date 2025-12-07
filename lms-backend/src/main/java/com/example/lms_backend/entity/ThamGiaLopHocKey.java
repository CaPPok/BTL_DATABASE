package com.example.lms_backend.entity;

import java.io.Serializable;
import java.util.Objects;

public class ThamGiaLopHocKey implements Serializable {
    private String maNguoiDung;
    private String maLopHoc;

    // Constructor rỗng
    public ThamGiaLopHocKey() {}

    public ThamGiaLopHocKey(String maNguoiDung, String maLopHoc) {
        this.maNguoiDung = maNguoiDung;
        this.maLopHoc = maLopHoc;
    }

    // Bắt buộc phải có equals và hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ThamGiaLopHocKey that = (ThamGiaLopHocKey) o;
        return Objects.equals(maNguoiDung, that.maNguoiDung) &&
               Objects.equals(maLopHoc, that.maLopHoc);
    }

    @Override
    public int hashCode() {
        return Objects.hash(maNguoiDung, maLopHoc);
    }
}