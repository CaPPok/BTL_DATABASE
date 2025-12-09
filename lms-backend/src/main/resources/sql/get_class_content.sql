SELECT 
    M.MaMuc,
    M.TenMuc,
    M.MoTa AS MoTaMuc,          
    TL.MaTaiLieu,
    TL.TenTaiLieu,
    TL.LoaiTaiLieu,
    TL.MoTaTaiLieu,      
    COALESCE(F.DuongDanFile, L.DuongDanWeb, V.DuongDanFileVideo, '') AS LinkLienKet
FROM Management.MucTaiLieu M
LEFT JOIN Management.SoHuu SH ON M.MaLopHoc = SH.MaLopHoc AND M.MaMuc = SH.MaMuc
LEFT JOIN Management.TaiLieuMonHoc TL ON SH.MaTaiLieu = TL.MaTaiLieu
LEFT JOIN Management.TaiLieuDangTep F ON TL.MaTaiLieu = F.MaTaiLieu
LEFT JOIN Management.LinkThamKhao L ON TL.MaTaiLieu = L.MaTaiLieu
LEFT JOIN Management.VideoBaiGiang V ON TL.MaTaiLieu = V.MaTaiLieu
WHERE M.MaLopHoc = :maLopHoc
ORDER BY M.MaMuc ASC, TL.MaTaiLieu ASC