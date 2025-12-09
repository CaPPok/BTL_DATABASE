SELECT 
    L.MaLopHoc,
    MH.TenMonHoc,
    ND.HoTen AS TenGiangVien,
    L.MaNguoiDay AS MaGV,
    L.MaMonHoc
FROM Management.LopHoc L
-- 1. JOIN ĐỂ LỌC SINH VIÊN (QUAN TRỌNG NHẤT)
JOIN Management.ThamGiaLopHoc TG ON L.MaLopHoc = TG.MaLopHoc
-- 2. Join lấy thông tin hiển thị
LEFT JOIN Management.MonHoc MH ON L.MaMonHoc = MH.MaMonHoc
LEFT JOIN Management.GiangVien GV ON L.MaNguoiDay = GV.MaNguoiDung
LEFT JOIN Management.NguoiDung ND ON GV.MaNguoiDung = ND.MaNguoiDung
WHERE 
    TG.MaNguoiDung = :maNguoiDung
    AND (
        :tuKhoa IS NULL 
        OR :tuKhoa = '' 
        OR L.MaLopHoc LIKE CONCAT('%', :tuKhoa, '%') 
        OR MH.TenMonHoc LIKE CONCAT('%', :tuKhoa, '%')
        OR ND.HoTen LIKE CONCAT('%', :tuKhoa, '%')
    )
ORDER BY 
    CASE WHEN :kieuSapXep = 'TEN_AZ' THEN MH.TenMonHoc END ASC,
    CASE WHEN :kieuSapXep = 'TEN_ZA' THEN MH.TenMonHoc END DESC,
    CASE WHEN :kieuSapXep = 'MOI_NHAT' THEN L.MaLopHoc END DESC