USE LMS_DB;
GO
CREATE OR ALTER PROCEDURE Management.sp_TimKiemKhoaHoc_LocThongMinh
    @TuKhoaInput NVARCHAR(200) = NULL, -- Input
    @KieuSapXep  VARCHAR(20)   = 'TEN_ZA', -- Input từ menu sắp xếp ('TEN_AZ', 'TEN_ZA', 'MOI_NHAT')
    @MaNguoiDungSV         VARCHAR(20)   =  NULL
AS
BEGIN
  --Xóa khoảng trắng thừa 2 đầu và đưa về chuỗi rỗng nếu NULL
    SET @TuKhoaInput = LTRIM(RTRIM(ISNULL(@TuKhoaInput, '')));

    SELECT 
        LH.MaLopHoc,
        MH.TenMonHoc + N' (' + CAST(MH.MaMonHoc AS NVARCHAR(20)) + N') '  AS TenMon,
        ND.HoTen AS TenGiangVien,
        GV.MaSoCanBo AS MaGV,
        MH.MaMonHoc

    FROM Management.LopHoc LH
    JOIN Management.ThamGiaLopHoc TG ON TG.MaLopHoc = LH.MaLopHoc
    JOIN Management.MonHoc MH ON LH.MaMonHoc = MH.MaMonHoc
    JOIN Management.GiangVien GV ON LH.MaNguoiDay = GV.MaNguoiDung
    JOIN Management.NguoiDung ND ON GV.MaNguoiDung = ND.MaNguoiDung

    WHERE 
        (@MaNguoiDungSV = '' OR TG.MaNguoiDung = @MaNguoiDungSV)
        AND
        (
            @TuKhoaInput = '' 
            OR
            (
         
                SELECT COUNT(*) 
                FROM STRING_SPLIT(@TuKhoaInput, ' ') AS TuDon
                WHERE TuDon.value <> ''
                AND (
  
                    (MH.TenMonHoc LIKE N'%' + TuDon.value + N'%') OR 
                    (ND.HoTen LIKE N'%' + TuDon.value + N'%') OR 
                    (GV.MaSoCanBo LIKE N'%' + TuDon.value + N'%') OR 
                    (CAST(LH.MaLopHoc AS NVARCHAR(20)) LIKE N'%' + TuDon.value + N'%') OR
                    (CAST(MH.MaMonHoc AS NVARCHAR(20)) LIKE N'%' + TuDon.value + N'%')
                )
            ) 
            = 
   
            (SELECT COUNT(*) FROM STRING_SPLIT(@TuKhoaInput, ' ') WHERE value <> '')
        )

    ORDER BY 

        CASE WHEN @KieuSapXep = 'TEN_AZ' THEN MH.TenMonHoc END ASC,

        CASE WHEN @KieuSapXep = 'TEN_ZA' THEN MH.TenMonHoc END DESC,

        CASE WHEN @KieuSapXep = 'MOI_NHAT' THEN LH.MaLopHoc END DESC,

        MH.TenMonHoc ASC;
END;
GO

EXEC Management.sp_TimKiemKhoaHoc_LocThongMinh @TuKhoaInput = N'', @KieuSapXep = 'MOI_NHAT', @MaNguoiDungSV='hoi.banhphuK23';

USE LMS_DB;
GO

CREATE OR ALTER PROCEDURE Testing.sp_ThongKeDashboard_TongHop
    @Input_ID NVARCHAR(50) -- Có thể nhập MSSV hoặc MaNguoiDung
AS
BEGIN
    SET NOCOUNT ON;

    -- =============================================
    -- BƯỚC 1: XÁC ĐỊNH MÃ NGƯỜI DÙNG (MaNguoiDung)
    -- =============================================
    DECLARE @MaNguoiDung VARCHAR(50) = NULL;

    -- Ưu tiên tìm theo MSSV trước
    SELECT @MaNguoiDung = MaNguoiDung 
    FROM Management.SinhVien 
    WHERE MaSoSinhVien = @Input_ID;

    -- Nếu không tìm thấy theo MSSV, thử tìm theo MaNguoiDung trực tiếp
    IF @MaNguoiDung IS NULL
    BEGIN
        SELECT @MaNguoiDung = MaNguoiDung 
        FROM Management.NguoiDung 
        WHERE MaNguoiDung = @Input_ID;
    END

    IF @MaNguoiDung IS NULL 
    BEGIN
        PRINT N'Không tìm thấy thông tin sinh viên/người dùng.';
        RETURN;
    END

    -- =============================================
    -- BƯỚC 2: TÍNH ĐIỂM VÀ LƯU VÀO BẢNG TẠM (#DiemSoChiTiet)
    -- =============================================
    -- Dùng SELECT ... INTO ... để tạo và đổ dữ liệu vào bảng tạm
    SELECT 
        LT.MaLopHoc, 
        LT.MaBaiKiemTra,
        MAX(DiemTong.TongDiem) AS DiemCaoNhatCuaBaiQuiz
    INTO #DiemSoChiTiet -- <--- TẠO BẢNG TẠM TẠI ĐÂY
    FROM Testing.LanThu LT
    LEFT JOIN (
        SELECT MaLopHoc, MaBaiKiemTra, MaLanThu, SUM(Diem) AS TongDiem
        FROM Testing.CauTraLoi
        GROUP BY MaLopHoc, MaBaiKiemTra, MaLanThu
    ) DiemTong ON LT.MaLopHoc = DiemTong.MaLopHoc 
               AND LT.MaBaiKiemTra = DiemTong.MaBaiKiemTra 
               AND LT.MaLanThu = DiemTong.MaLanThu
    WHERE LT.MaNguoiLam = @MaNguoiDung
    GROUP BY LT.MaLopHoc, LT.MaBaiKiemTra;

    -- =============================================
    -- BƯỚC 3: TRẢ VỀ KẾT QUẢ 1 - THỐNG KÊ THEO MÔN HỌC
    -- (Dùng JOIN với bảng tạm #DiemSoChiTiet)
    -- =============================================
    SELECT 
        MH.MaMonHoc,
        MH.TenMonHoc,
        COUNT(Q.MaBaiKiemTra) AS TongSoBaiKiemTra,
        SUM(CASE WHEN DS.MaBaiKiemTra IS NOT NULL THEN 1 ELSE 0 END) AS SoBaiDaLam,
        AVG(ISNULL(DS.DiemCaoNhatCuaBaiQuiz, 0)) AS DiemTrungBinhMon,
        MAX(ISNULL(DS.DiemCaoNhatCuaBaiQuiz, 0)) AS DiemCaoNhatMon
    FROM Management.ThamGiaLopHoc TG
    JOIN Management.LopHoc LH ON TG.MaLopHoc = LH.MaLopHoc
    JOIN Management.MonHoc MH ON LH.MaMonHoc = MH.MaMonHoc
    JOIN Testing.BaiKiemTra Q ON Q.MaLopHoc = LH.MaLopHoc
    LEFT JOIN #DiemSoChiTiet DS ON Q.MaLopHoc = DS.MaLopHoc AND Q.MaBaiKiemTra = DS.MaBaiKiemTra -- <--- Dùng bảng tạm
    WHERE TG.MaNguoiDung = @MaNguoiDung
    GROUP BY MH.MaMonHoc, MH.TenMonHoc
    HAVING COUNT(Q.MaBaiKiemTra) > 0
    ORDER BY MH.TenMonHoc;

    -- =============================================
    -- BƯỚC 4: TRẢ VỀ KẾT QUẢ 2 - DANH SÁCH "NHẮC NHỞ"
    -- (Vẫn dùng được bảng tạm #DiemSoChiTiet lần nữa)
    -- =============================================
    SELECT 
        Q.TenBaiKiemTra,
        MH.TenMonHoc,
        Q.ThoiGianKetThuc AS HanChotNopBai,
        DATEDIFF(HOUR, GETDATE(), Q.ThoiGianKetThuc) AS SoGioConLai,
        N'Chưa làm' AS TrangThai
    FROM Management.ThamGiaLopHoc TG
    JOIN Management.LopHoc LH ON TG.MaLopHoc = LH.MaLopHoc
    JOIN Management.MonHoc MH ON LH.MaMonHoc = MH.MaMonHoc
    JOIN Testing.BaiKiemTra Q ON Q.MaLopHoc = LH.MaLopHoc
    LEFT JOIN #DiemSoChiTiet DS ON Q.MaLopHoc = DS.MaLopHoc AND Q.MaBaiKiemTra = DS.MaBaiKiemTra -- <--- Dùng lại bảng tạm
    WHERE TG.MaNguoiDung = @MaNguoiDung
      AND DS.MaBaiKiemTra IS NULL       -- Chưa có điểm => Chưa làm
      AND Q.ThoiGianKetThuc > GETDATE() -- Còn hạn
    ORDER BY Q.ThoiGianKetThuc ASC;

    -- =============================================
    -- BƯỚC 5: DỌN DẸP
    -- =============================================
    DROP TABLE IF EXISTS #DiemSoChiTiet;

END;
GO

EXEC Testing.sp_ThongKeDashboard_TongHop @Input_ID=2300001;
--Sử dụng mã người dùng
EXEC Testing.sp_ThongKeDashboard_TongHop @Input_ID='duy.nguyenthe001';
--Sử dùng mã sinh viên của duy.nguyenthe001
EXEC Testing.sp_ThongKeDashboard_TongHop @Input_ID=2300003;
--Sử dụng sinh viên khác
EXEC Testing.sp_ThongKeDashboard_TongHop @Input_ID='hiep.lehoangGG';