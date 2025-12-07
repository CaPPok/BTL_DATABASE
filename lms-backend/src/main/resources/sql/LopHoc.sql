SELECT L.* FROM Management.LopHoc L
JOIN Management.ThamGiaLopHoc T ON L.MaLopHoc = T.MaLopHoc
WHERE T.MaNguoiDung = :maNguoiDung