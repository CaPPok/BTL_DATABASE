USE LMS_DB;
GO


DECLARE @MaLopHoc VARCHAR(50);
SELECT TOP 1 @MaLopHoc = MaLopHoc FROM Management.LopHoc;

DECLARE @MaGV VARCHAR(50) = (SELECT TOP 1 MaNguoiDay FROM Management.LopHoc WHERE MaLopHoc = @MaLopHoc);

IF NOT EXISTS (SELECT 1 FROM Forum.DienDan WHERE MaLopHoc = @MaLopHoc)
BEGIN
    INSERT INTO Forum.DienDan (TenDienDan, MaLopHoc, MaNguoiTao) VALUES (N'Diễn đàn chung', @MaLopHoc, @MaGV);
END
DECLARE @MaDienDan INT = (SELECT TOP 1 MaDienDan FROM Forum.DienDan WHERE MaLopHoc = @MaLopHoc);

DECLARE @NextMaNhom INT;
SELECT @NextMaNhom = ISNULL(MAX(MaNhom), 0) + 1 FROM Forum.Nhom WHERE MaDienDan = @MaDienDan;

INSERT INTO Forum.Nhom (MaDienDan, MaNhom, MaNguoiTao) VALUES (@MaDienDan, @NextMaNhom, @MaGV);

IF NOT EXISTS (SELECT 1 FROM Management.ThamGia WHERE MaNguoiDungSinhVien = 'huy.lugiaHCMUT2' AND MaDienDan = @MaDienDan AND MaNhom = @NextMaNhom)
    INSERT INTO Management.ThamGia (MaNguoiDungSinhVien, MaDienDan, MaNhom) VALUES ('huy.lugiaHCMUT2', @MaDienDan, @NextMaNhom);

IF NOT EXISTS (SELECT 1 FROM Management.ThamGia WHERE MaNguoiDungSinhVien = 'hiep.lehoangGG' AND MaDienDan = @MaDienDan AND MaNhom = @NextMaNhom)
    INSERT INTO Management.ThamGia (MaNguoiDungSinhVien, MaDienDan, MaNhom) VALUES ('hiep.lehoangGG', @MaDienDan, @NextMaNhom);

IF NOT EXISTS (SELECT 1 FROM Management.ThamGia WHERE MaNguoiDungSinhVien = 'duy.luhoangBK1' AND MaDienDan = @MaDienDan AND MaNhom = @NextMaNhom)
    INSERT INTO Management.ThamGia (MaNguoiDungSinhVien, MaDienDan, MaNhom) VALUES ('duy.luhoangBK1', @MaDienDan, @NextMaNhom);

-----------------------------------------------------------------------
-- TEST FUNCTION 1: f_LayDanhSachEmailLop
-----------------------------------------------------------------------
PRINT '--------------------------------------------------';
PRINT 'TEST FUNCTION 1: f_LayDanhSachEmailLop';
PRINT '--------------------------------------------------';

-- Case 1: Lớp tồn tại và có sinh viên tham gia diễn đàn
PRINT N'Case 1: Lớp hợp lệ có sinh viên';
SELECT Management.f_LayDanhSachEmailLop(@MaLopHoc) AS [Case1_HasEmails];

-- Case 2: Lớp không tồn tại
PRINT N'Case 2: Lớp không tồn tại';
SELECT Management.f_LayDanhSachEmailLop('CLASS_NOT_EXIST') AS [Case2_Error];

-- Case 3: Lớp tồn tại nhưng chưa có sinh viên nào tham gia diễn đàn
INSERT INTO Management.LopHoc (MaLopHoc, MaMonHoc, MaNguoiDay) VALUES ('TEST_EMPTY_CLASS', 'CO2013', @MaGV);

SELECT Management.f_LayDanhSachEmailLop('TEST_EMPTY_CLASS') AS [Case3_EmptyClass];

DELETE FROM Management.LopHoc WHERE MaLopHoc = 'TEST_EMPTY_CLASS';


-----------------------------------------------------------------------
-- TEST FUNCTION 2: f_DanhGiaTichCuc
-----------------------------------------------------------------------
PRINT '--------------------------------------------------';
PRINT 'TEST FUNCTION 2: f_DanhGiaTichCuc';
PRINT '--------------------------------------------------';

-- Case 1: Sinh viên không tồn tại 
PRINT N'Case 1: Sinh viên không tồn tại';
SELECT Management.f_DanhGiaTichCuc('unknown.user') AS [Case1_Error];

-- Case 2: Chưa tham gia nhóm nào 
PRINT N'Case 2: Chưa tham gia nhóm nào';
SELECT Management.f_DanhGiaTichCuc('huy.hoangtheCS2') AS [Case2_ZeroActivity];

-- Case 3: Tham gia từ 1 đến 4 nhóm 
PRINT N'Case 3: Tích cực (1-4 nhóm)';
SELECT Management.f_DanhGiaTichCuc('huy.lugiaHCMUT2') AS [Case3_Active];


DECLARE @i INT = 1;
WHILE @i <= 5
BEGIN
    INSERT INTO Forum.Nhom (MaDienDan, MaNhom, MaNguoiTao) VALUES (@MaDienDan, @NextMaNhom + @i, @MaGV);
    INSERT INTO Management.ThamGia (MaNguoiDungSinhVien, MaDienDan, MaNhom) VALUES ('hiep.lehoangGG', @MaDienDan, @NextMaNhom + @i);
    SET @i = @i + 1;
END

-- B2: Test function
PRINT N'Case 4: Rất tích cực (>= 5 nhóm)';
SELECT Management.f_DanhGiaTichCuc('hiep.lehoangGG') AS [Case4_VeryActive];
