USE LMS_DB;
GO

-- HÀM 1: LẤY EMAIL
CREATE OR ALTER FUNCTION Management.f_LayDanhSachEmailLop (@MaLopHoc VARCHAR(20))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Management.LopHoc WHERE MaLopHoc = @MaLopHoc)
        RETURN N'Lỗi: Lớp học không tồn tại';

    DECLARE @DanhSachEmail NVARCHAR(MAX) = '';
    DECLARE @Email NVARCHAR(100);

    DECLARE cursor_Email CURSOR FOR
        SELECT DISTINCT ND.Email
        FROM Management.ThamGia TG
        JOIN Management.SinhVien SV ON TG.MaNguoiDungSinhVien = SV.MaNguoiDung
        JOIN Management.NguoiDung ND ON SV.MaNguoiDung = ND.MaNguoiDung
        JOIN Forum.Nhom N ON TG.MaNhom = N.MaNhom
        JOIN Forum.DienDan D ON N.MaDienDan = D.MaDienDan
        WHERE D.MaLopHoc = @MaLopHoc;

    OPEN cursor_Email;
    FETCH NEXT FROM cursor_Email INTO @Email;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @DanhSachEmail = '' SET @DanhSachEmail = @Email;
        ELSE SET @DanhSachEmail = @DanhSachEmail + '; ' + @Email;
        FETCH NEXT FROM cursor_Email INTO @Email;
    END

    CLOSE cursor_Email;
    DEALLOCATE cursor_Email;

    IF @DanhSachEmail = '' RETURN N'Lớp chưa có sinh viên.';
    RETURN @DanhSachEmail;
END;
GO

-- HÀM 2: ĐỘ TÍCH CỰC
CREATE OR ALTER FUNCTION Management.f_DanhGiaTichCuc (@MaSinhVien VARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Management.SinhVien WHERE MaNguoiDung = @MaSinhVien)
        RETURN N'Lỗi: Sinh viên không tồn tại';

    DECLARE @SoNhom INT = 0;
    DECLARE @TempID INT;

    DECLARE cursor_HoatDong CURSOR FOR
        SELECT MaNhom FROM Management.ThamGia WHERE MaNguoiDungSinhVien = @MaSinhVien;

    OPEN cursor_HoatDong;
    FETCH NEXT FROM cursor_HoatDong INTO @TempID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @SoNhom = @SoNhom + 1;
        FETCH NEXT FROM cursor_HoatDong INTO @TempID;
    END

    CLOSE cursor_HoatDong;
    DEALLOCATE cursor_HoatDong;

    IF @SoNhom >= 5 RETURN N'Rất tích cực (' + CAST(@SoNhom AS NVARCHAR) + N' nhóm)';
    IF @SoNhom >= 1 RETURN N'Tích cực (' + CAST(@SoNhom AS NVARCHAR) + N' nhóm)';
    
    RETURN N'Chưa tham gia hoạt động';
END;
GO