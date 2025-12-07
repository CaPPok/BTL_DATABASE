SELECT 
    N.MaNguoiDung, 
    N.HoTen, 
    N.MatKhau,
    CASE 
        WHEN S.MaNguoiDung IS NOT NULL THEN 'SinhVien'
        WHEN G.MaNguoiDung IS NOT NULL THEN 'GiangVien'
        ELSE 'Unknown' 
    END AS Role
FROM Management.NguoiDung N
LEFT JOIN Management.SinhVien S ON N.MaNguoiDung = S.MaNguoiDung
LEFT JOIN Management.GiangVien G ON N.MaNguoiDung = G.MaNguoiDung
WHERE N.MaNguoiDung = :maNguoiDung 
AND N.TrangThaiHoatDong = 1