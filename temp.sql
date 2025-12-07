use LMS_DB;
go
SELECT 
    Management.NguoiDung.MaNguoiDung, 
    Management.NguoiDung.HoTen, 
    Management.NguoiDung.MatKhau,
    CASE 
        WHEN Management.SinhVien.MaNguoiDung IS NOT NULL THEN 'SinhVien'
        WHEN Management.GiangVien.MaNguoiDung IS NOT NULL THEN 'GiangVien'
        ELSE 'Unknown' 
    END AS Role
WHERE Management.NguoiDung.MaNguoiDung = :maNguoiDung 
AND Management.NguoiDung.TrangThaiHoatDong = 1