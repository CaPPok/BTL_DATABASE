-- Ràng buộc dữ liệu
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