-- Ràng buộc ngữ nghĩa
use LMS_DB;
go
------------------------------------------------
-- 1. Thời gian bắt đầu cho đến khi kết thúc một khảo sát kéo dài tối thiểu 1 tuần
------------------------------------------------
ALTER TABLE Survey.KhaoSat
ADD CONSTRAINT CK_ThoiGian_KhaoSat
CHECK (DATEDIFF(DAY, ThoigianBatDau, ThoiGianKetThuc) >= 7);
GO

------------------------------------------------
-- 2. Loại tài liệu của tài liệu môn học chỉ được phép là một trong ba giá trị: ’tài liệu dạng tệp’, ’link tham khảo’, hoặc ’video bài giảng’
------------------------------------------------
ALTER TABLE Management.TaiLieuMonHoc
ADD CONSTRAINT CK_LoaiTaiLieu 
CHECK (LoaiTaiLieu IN (N'tài liệu dạng tệp', N'link tham khảo', N'video bài giảng'));
GO

------------------------------------------------
-- 3. Người dùng chỉ thảo luận trong nhóm mình thuộc về
------------------------------------------------
-- Trigger cho bảng Chủ Đề Thảo Luận
CREATE TRIGGER CheckQuyenTaoChuDe
ON Forum.ChuDeThaoLuan
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        LEFT JOIN Management.ThamGia tg 
            ON i.MaNguoiTaoChuDe = tg.MaNguoiDungSinhVien 
            AND i.MaNhom = tg.MaNhom 
            AND i.MaDienDan = tg.MaDienDan
        WHERE tg.MaNguoiDungSinhVien IS NULL
    )
    BEGIN
        RAISERROR (N'Lỗi: Bạn không thuộc nhóm này nên không thể tạo chủ đề!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger cho bảng Phản Hồi
CREATE TRIGGER CheckQuyenPhanHoi
ON Forum.PhanHoi
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        LEFT JOIN Management.ThamGia tg 
            ON i.MaNguoiPhanHoi = tg.MaNguoiDungSinhVien 
            AND i.MaNhom = tg.MaNhom 
            AND i.MaDienDan = tg.MaDienDan
        WHERE tg.MaNguoiDungSinhVien IS NULL
    )
    BEGIN
        RAISERROR (N'Lỗi: Bạn không thuộc nhóm này nên không thể gửi phản hồi!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

------------------------------------------------
-- 4. Giảng viên chỉ chấm các câu trả lời cho câu hỏi dạng tự luận và chấm cho lần làm cuối cùng của sinh viên trong bài kiểm tra.
------------------------------------------------
CREATE TRIGGER CheckChamDiem
ON Testing.CauTraLoi
AFTER UPDATE
AS
BEGIN
    -- Chỉ kiểm tra nếu có update cột Diem
    IF UPDATE(Diem)
    BEGIN
        -- Kiểm tra loại câu hỏi (phải là tự luận)
        IF EXISTS (
            SELECT 1 FROM inserted i
            JOIN Testing.CauHoi ch ON i.MaCauHoi = ch.MaCauHoi
            WHERE ch.LoaiCauHoi <> 0 -- Không phải tự luận
        )
        BEGIN
            RAISERROR (N'Lỗi: Chỉ được chấm điểm câu hỏi tự luận!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Kiểm tra có phải lần thử cuối cùng không
        IF EXISTS (
            SELECT 1 FROM inserted i
            WHERE i.MaLanThu < (
                SELECT MAX(MaLanThu) 
                FROM Testing.LanThu lt 
                WHERE lt.MaLopHoc = i.MaLopHoc 
                  AND lt.MaBaiKiemTra = i.MaBaiKiemTra 
                  AND lt.MaNguoiLam = (SELECT MaNguoiLam FROM Testing.LanThu WHERE MaLanThu = i.MaLanThu)
            )
        )
        BEGIN
            RAISERROR (N'Lỗi: Chỉ được chấm điểm cho lần làm bài cuối cùng!', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;
GO

------------------------------------------------
-- 5. Tổng hệ số điểm của tất cả Submission và Bài kiểm tra không được vượt quá 100%.
------------------------------------------------
CREATE TRIGGER CheckHeSo_Submission
ON Exercise.Submission
AFTER INSERT, UPDATE
AS
BEGIN
    IF UPDATE(HeSo) OR UPDATE(MaLopHoc)
    BEGIN
        DECLARE @MaLopHoc INT;
        DECLARE @TongHeSo INT;

        -- Lấy MaLopHoc từ dòng vừa thao tác
        SELECT TOP 1 @MaLopHoc = MaLopHoc FROM inserted;

        -- Tính tổng hệ số bên Bài Kiểm Tra
        DECLARE @TongExam INT = 0;
        SELECT @TongExam = ISNULL(SUM(HeSo), 0) 
        FROM Testing.BaiKiemTra 
        WHERE MaLopHoc = @MaLopHoc;

        -- Tính tổng hệ số bên Submission
        DECLARE @TongSub INT = 0;
        SELECT @TongSub = ISNULL(SUM(HeSo), 0) 
        FROM Exercise.Submission 
        WHERE MaLopHoc = @MaLopHoc;

        -- Cộng lại và kiểm tra
        SET @TongHeSo = @TongExam + @TongSub;

        IF @TongHeSo > 100
        BEGIN
            RAISERROR (N'Lỗi: Tổng hệ số (Bài tập + Kiểm tra) của lớp học này là %d%%, vượt quá giới hạn 100%!', 16, 1, @TongHeSo);
            ROLLBACK TRANSACTION;
        END
    END
END;
GO

CREATE TRIGGER CheckHeSo_BaiKiemTra
ON Testing.BaiKiemTra
AFTER INSERT, UPDATE
AS
BEGIN
    IF UPDATE(HeSo) OR UPDATE(MaLopHoc)
    BEGIN
        DECLARE @MaLopHoc INT;
        DECLARE @TongHeSo INT;

        SELECT TOP 1 @MaLopHoc = MaLopHoc FROM inserted;

        -- Tính tổng hệ số bên Bài Kiểm Tra (Bảng này đã chứa dòng vừa insert/update)
        DECLARE @TongExam INT = 0;
        SELECT @TongExam = ISNULL(SUM(HeSo), 0) 
        FROM Testing.BaiKiemTra 
        WHERE MaLopHoc = @MaLopHoc;

        -- Tính tổng hệ số bên Submission
        DECLARE @TongSub INT = 0;
        SELECT @TongSub = ISNULL(SUM(HeSo), 0) 
        FROM Exercise.Submission 
        WHERE MaLopHoc = @MaLopHoc;

        -- Cộng lại và kiểm tra
        SET @TongHeSo = @TongExam + @TongSub;

        IF @TongHeSo > 100
        BEGIN
            RAISERROR (N'Lỗi: Tổng hệ số (Bài tập + Kiểm tra) của lớp học này là %d%%, vượt quá giới hạn 100%!', 16, 1, @TongHeSo);
            ROLLBACK TRANSACTION;
        END
    END
END;
GO

------------------------------------------------
-- 6. Khi sinh viên nộp bài, định dạng tệp tin của họ phải khớp với danh sách Định dạng tập tin mà Submission đó cho phép.
------------------------------------------------
CREATE TRIGGER CheckDinhDangFile
ON Exercise.DuongDanTapTinBaiLam
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN Exercise.DinhDangTapTin ddt ON i.MaSubmission = ddt.MaSubmission
        -- Kiểm tra đuôi file
        WHERE i.DuongDanTapTinBaiLam NOT LIKE '%' + ddt.DinhDangTapTin
    )
    BEGIN
        RAISERROR (N'Lỗi: Định dạng file nộp không khớp với yêu cầu!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

------------------------------------------------
-- 7. Submission có thể được chỉnh sửa sau thời gian kết thúc đã quy định trước đó, nhưng sẽ tính là nộp trễ.
------------------------------------------------
CREATE TRIGGER CheckNopTre
ON Exercise.NopBai
AFTER INSERT
AS
BEGIN
    UPDATE Exercise.Submission
    SET TrangThaiBaiNop = 2 -- 2: Nộp trễ
    FROM Exercise.Submission s
    JOIN inserted i ON s.MaSubmission = i.MaSubmission
    WHERE GETDATE() > s.ThoiGianKetThuc;
END;
GO