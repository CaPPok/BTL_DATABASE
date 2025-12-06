package com.example.lms_backend.repository;

import com.example.lms_backend.entity.NguoiDung;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.Optional;

public interface NguoiDungRepository extends JpaRepository<NguoiDung, String> {

    @Query(value = """
    SELECT 
        ND.MaNguoiDung as maNguoiDung,
        ND.HoTen as hoTen,
        CASE 
            WHEN SV.MaNguoiDung IS NOT NULL THEN 'SinhVien'
            WHEN GV.MaNguoiDung IS NOT NULL THEN 'GiangVien'
            ELSE 'UNKNOWN' 
        END AS role
    FROM Management.NguoiDung ND
    LEFT JOIN Management.SinhVien SV ON ND.MaNguoiDung = SV.MaNguoiDung
    LEFT JOIN Management.GiangVien GV ON ND.MaNguoiDung = GV.MaNguoiDung
    WHERE ND.MaNguoiDung = :maNguoiDung AND ND.MatKhau = :matKhau
    """, nativeQuery = true)
    Optional<ILoginResult> checkLogin(@Param("maNguoiDung") String maNguoiDung, @Param("matKhau") String matKhau);
}
