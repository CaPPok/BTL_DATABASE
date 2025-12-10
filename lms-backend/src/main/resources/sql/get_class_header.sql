SELECT 
    L.MaLopHoc,
    MH.TenMonHoc,
    ND.HoTen AS TenGiangVien,
    L.MaNguoiDay AS MaGiangVien,
    L.MaKhaoSat
FROM Management.LopHoc L
LEFT JOIN Management.MonHoc MH ON L.MaMonHoc = MH.MaMonHoc
LEFT JOIN Management.GiangVien GV ON L.MaNguoiDay = GV.MaNguoiDung
LEFT JOIN Management.NguoiDung ND ON GV.MaNguoiDung = ND.MaNguoiDung
WHERE L.MaLopHoc = :maLopHoc