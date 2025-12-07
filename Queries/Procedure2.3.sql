USE DoAn_LMS;
GO
CREATE OR ALTER PROCEDURE Management.sp_TimKiemKhoaHoc_LocThongMinh
    @TuKhoaInput NVARCHAR(200) = NULL, -- Input
    @KieuSapXep  VARCHAR(20)   = 'TEN_ZA' -- Input từ menu sắp xếp ('TEN_AZ', 'TEN_ZA', 'MOI_NHAT')
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
    JOIN Management.MonHoc MH ON LH.MaMonHoc = MH.MaMonHoc
    JOIN Management.GiangVien GV ON LH.MaNguoiDay = GV.MaNguoiDung
    JOIN Management.NguoiDung ND ON GV.MaNguoiDung = ND.MaNguoiDung

    WHERE 

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

EXEC Management.sp_TimKiemKhoaHoc_LocThongMinh @TuKhoaInput = N'232', @KieuSapXep = 'MOI_NHAT';

use DoAn_LMS
go

CREATE OR ALTER PROCEDURE Testing.sp_ThongKeQuiz
    @Input_MSSV NVARCHAR(200) = NULL,
    @Input_TrangThai TINYINT = NULL      -- 0: chưa làm, 1: hoàn thành, 2: overdue
AS
BEGIN
    SET NOCOUNT ON;

    -- Làm sạch tham số
    SET @Input_MSSV = LTRIM(RTRIM(ISNULL(@Input_MSSV, '')));

    SELECT 
        Quiz.TenBaiKiemTra,
        Quiz.MaLopHoc,
        Quiz.TrangThai
 
    FROM Testing.BaiKiemTra AS Quiz
    JOIN Management.LopHoc AS LH 
        ON Quiz.MaLopHoc = LH.MaLopHoc
    JOIN Management.ThamGiaLopHoc AS TG 
        ON TG.MaLopHoc = LH.MaLopHoc
    JOIN Management.SinhVien AS SV 
        ON SV.MaNguoiDung = TG.MaNguoiDung
    WHERE
        -- Lọc MSSV
        (
            @Input_MSSV = '' 
            OR EXISTS (
                SELECT 1 
                FROM STRING_SPLIT(@Input_MSSV, ' ') AS S
                WHERE S.value <> ''
                  AND SV.MaSoSinhVien = S.value
            )
        )
        -- Lọc trạng thái
        AND (
            @Input_TrangThai IS NULL
            OR Quiz.TrangThai = @Input_TrangThai
        )
    ORDER BY 
        Quiz.ThoiGianKetThuc ASC;
END;
GO
EXEC Testing.sp_ThongKeQuiz @Input_MSSV= N'1', @Input_TrangThai= 0;

