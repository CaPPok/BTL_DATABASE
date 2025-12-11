------------------------------------------------
-- 1. MANAGEMENT
------------------------------------------------
use LMS_DB;
go
-- Người dùng
INSERT INTO Management.NguoiDung (MaNguoiDung, Email, MatKhau, HoTen, GioiTinh) VALUES
('duy.levanVNET', 'duy.levanVNET@hcmut.edu.vn', '123456', N'Lê Văn Duy', 0),
('bao.nguyenthegiabao01', 'bao.nguyenthegiabao01@hcmut.edu.vn', '123456', N'Nguyễn Thế Gia Bảo', 0),
('hiep.luhoangLHH', 'hiep.luhoangLHH@hcmut.edu.vn', '123456', N'Lữ Hoàng Hiệp', 0),
('hoang.nguyenlelu99', 'hoang.nguyenlelu99@hcmut.edu.vn', '123456', N'Nguyễn Lê Lữ Hoàng', 1),
('bao.nguyenhoang111', 'bao.nguyenhoang111@hcmut.edu.vn', '123456', N'Nguyễn Hoàng Bảo', 1),
('huy.lugiaHCMUT2', 'huy.lugiaHCMUT2@hcmut.edu.vn', '123456', N'Lữ Gia Huy', 1),
('hiep.lehoangGG', 'hiep.lehoangGG@hcmut.edu.vn', '123456', N'Lê Hoàng Hiệp', 1),
('duy.nguyenthe001', 'duy.nguyenthe001@hcmut.edu.vn', '123456', N'Nguyễn Thế Duy', 1),
('hiep.nguyenvan123', 'hiep.nguyenvan123@hcmut.edu.vn', '123456', N'Nguyễn Văn Hiệp', 0),
('huy.hoangtheCS2', 'huy.hoangtheCS2@hcmut.edu.vn', '123456', N'Hoàng Thế Huy', 0),
('bao.legia251', 'bao.legia251@hcmut.edu.vn', '123456', N'Lê Gia Bảo', 0),
('duy.luhoangBK1', 'duy.luhoangBK1@hcmut.edu.vn', '123456', N'Lữ Hoàng Duy', 0),
('hoi.banhphuK23', 'hoi.banhphuK23@hcmut.edu.vn', '123456', N'Bành Phú Hội', 0);

-- Điện thoại người dùng
INSERT INTO Management.DienThoaiNguoiDung (MaNguoiDung, SoDienThoai) VALUES
('duy.levanVNET', '0812345678'),
('bao.nguyenthegiabao01', '0812345679'),
('hiep.luhoangLHH', '0812345610'),
('hoang.nguyenlelu99', '0812345611'),
('bao.nguyenhoang111', '0812345612'),
('huy.lugiaHCMUT2', '0812345613'),
('hiep.lehoangGG', '0812345614'),
('duy.nguyenthe001', '0812345615'),
('hiep.nguyenvan123', '0812345616'),
('huy.hoangtheCS2', '0812345617'),
('bao.legia251', '0812345618'),
('duy.luhoangBK1', '0812345619'),
('hoi.banhphuK23', '0812345620');

-- Giảng viên
INSERT INTO Management.GiangVien (MaNguoiDung, MaSoCanBo) VALUES
('duy.levanVNET', 'CB001'), ('bao.nguyenthegiabao01', 'CB002'), ('hiep.luhoangLHH', 'CB003'), 
('hoang.nguyenlelu99', 'CB004'), ('bao.nguyenhoang111', 'CB005');

-- Sinh viên
INSERT INTO Management.SinhVien (MaNguoiDung, MaSoSinhVien) VALUES
('huy.lugiaHCMUT2', '2300001'), ('hiep.lehoangGG', '2300002'), ('duy.nguyenthe001', '2300003'), ('hiep.nguyenvan123', '2300004'),
('huy.hoangtheCS2', '2300005'), ('bao.legia251', '2300006'), ('duy.luhoangBK1', '2300007'), ('hoi.banhphuK23', '2300008');

-- Bằng cấp
INSERT INTO Management.BangCap (MaNguoiDung, ChungChiBangCap) VALUES
('duy.levanVNET', 'BC101'), 
('duy.levanVNET', 'BC102'), 
('bao.nguyenthegiabao01', 'BC201'), 
('hiep.luhoangLHH', 'BC301'), 
('hiep.luhoangLHH', 'BC302'), 
('hiep.luhoangLHH', 'BC303'), 
('hoang.nguyenlelu99', 'BC401'),
('hoang.nguyenlelu99', 'BC402'), 
('bao.nguyenhoang111', 'BC501');

-- Môn học
INSERT INTO Management.MonHoc (MaMonHoc, TenMonHoc, MoTa) VALUES
('CO2013', N'Hệ cơ sở Dữ liệu', N'Cung cấp kiến thức nền tảng về mô hình dữ liệu quan hệ, kỹ năng thiết kế và truy vấn cơ sở dữ liệu bằng ngôn ngữ SQL'),
('CO3001',N'Công nghệ phần mềm', N'Trang bị kiến thức về quy trình phát triển phần mềm chuyên nghiệp, từ khâu thu thập yêu cầu, phân tích, thiết kế đến kiểm thử và bảo trì hệ thống'),
('CO2003',N'Cấu trúc Dữ liệu và Giải Thuật', N'Nghiên cứu các phương pháp tổ chức dữ liệu hiệu quả và phân tích các thuật toán tối ưu để giải quyết vấn đề phức tạp trong lập trình'),
('CO3093',N'Mạng máy tính', N'Tìm hiểu về kiến trúc mạng, mô hình tham chiếu OSI, bộ giao thức TCP/IP và nguyên lý hoạt động của các hệ thống truyền thông hiện đại'),
('CO2039',N'Lập trình nâng cao', N'Đi sâu vào các kỹ thuật lập trình hướng đối tượng phức tạp, xử lý đa luồng, lập trình giao diện và xây dựng ứng dụng phần mềm hoàn chỉnh'),
('CO2007',N'Kiến trúc máy tính', N'Khám phá tổ chức phần cứng máy tính, tập lệnh Assembly, bộ vi xử lý và mối tương quan giữa phần cứng với hiệu năng của hệ thống phần mềm'),
('CO1027',N'Kỹ thuật lập trình', N'Rèn luyện tư duy logic, kỹ năng giải quyết bài toán thông qua lập trình và các phương pháp tổ chức mã nguồn khoa học, dễ bảo trì'),
('MT1005',N'Giải tích 2', N'Cung cấp kiến thức toán học nâng cao về chuỗi số, phép tính vi phân và tích phân của hàm nhiều biến ứng dụng trong kỹ thuật');

-- Lớp học
INSERT INTO Management.LopHoc (MaLopHoc, MaKhaoSat, MaMonHoc, MaNguoiDay) VALUES
('HK251_CO2013_L01', NULL, 'CO2013', 'duy.levanVNET'),
('HK251_CO3001_L01', NULL, 'CO3001', 'bao.nguyenthegiabao01'),
('HK241_CO2003_L01', NULL, 'CO2003', 'bao.nguyenthegiabao01'),
('HK241_CO2003_L02', NULL, 'CO2003', 'duy.levanVNET'),
('HK251_CO3093_L01', NULL, 'CO3093', 'hoang.nguyenlelu99'),
('HK242_CO2039_L01', NULL, 'CO2039', 'hoang.nguyenlelu99'),
('HK241_CO2007_L01', NULL, 'CO2007', 'hiep.luhoangLHH'),
('HK241_CO2007_L02', NULL, 'CO2007', 'bao.nguyenhoang111'),
('HK241_CO2007_L03', NULL, 'CO2007', 'bao.nguyenhoang111'),
('HK232_CO1027_L01', NULL, 'CO1027', 'hiep.luhoangLHH'),
('HK232_MT1005_L01', NULL, 'MT1005', 'bao.nguyenhoang111'),
('HK232_MT1005_L02', NULL, 'MT1005', 'duy.levanVNET');

-- Tham gia lớp học
INSERT INTO Management.ThamGiaLopHoc (MaNguoiDung, MaLopHoc) VALUES
-- Sinh viên: huy.lugiaHCMUT2
('huy.lugiaHCMUT2', 'HK251_CO2013_L01'), 
('huy.lugiaHCMUT2', 'HK251_CO3001_L01'), 
('huy.lugiaHCMUT2', 'HK241_CO2003_L01'), 
('huy.lugiaHCMUT2', 'HK251_CO3093_L01'), 
('huy.lugiaHCMUT2', 'HK242_CO2039_L01'),
('huy.lugiaHCMUT2', 'HK241_CO2007_L03'), 
('huy.lugiaHCMUT2', 'HK232_CO1027_L01'),
('huy.lugiaHCMUT2', 'HK232_MT1005_L02'),
-- Sinh viên: hiep.lehoangGG
('hiep.lehoangGG', 'HK251_CO2013_L01'),
('hiep.lehoangGG', 'HK251_CO3001_L01'),
('hiep.lehoangGG', 'HK241_CO2003_L02'), 
('hiep.lehoangGG', 'HK251_CO3093_L01'),
('hiep.lehoangGG', 'HK242_CO2039_L01'),
('hiep.lehoangGG', 'HK241_CO2007_L01'), 
('hiep.lehoangGG', 'HK232_CO1027_L01'),
-- Sinh viên: duy.nguyenthe001
('duy.nguyenthe001', 'HK251_CO3001_L01'),
('duy.nguyenthe001', 'HK241_CO2003_L01'), 
('duy.nguyenthe001', 'HK251_CO3093_L01'),
('duy.nguyenthe001', 'HK241_CO2007_L02'), 
('duy.nguyenthe001', 'HK232_CO1027_L01'),
('duy.nguyenthe001', 'HK232_MT1005_L01'),
-- Sinh viên: hiep.nguyenvan123 
('hiep.nguyenvan123', 'HK251_CO2013_L01'),
('hiep.nguyenvan123', 'HK251_CO3001_L01'),
('hiep.nguyenvan123', 'HK241_CO2003_L02'),
('hiep.nguyenvan123', 'HK251_CO3093_L01'),
('hiep.nguyenvan123', 'HK242_CO2039_L01'),
('hiep.nguyenvan123', 'HK241_CO2007_L02'),
('hiep.nguyenvan123', 'HK232_CO1027_L01'),
('hiep.nguyenvan123', 'HK232_MT1005_L01'),
-- Sinh viên: huy.hoangtheCS2
('huy.hoangtheCS2', 'HK251_CO2013_L01'),
('huy.hoangtheCS2', 'HK241_CO2003_L01'),
('huy.hoangtheCS2', 'HK251_CO3093_L01'),
('huy.hoangtheCS2', 'HK242_CO2039_L01'),
('huy.hoangtheCS2', 'HK241_CO2007_L03'),
('huy.hoangtheCS2', 'HK232_CO1027_L01'),
('huy.hoangtheCS2', 'HK232_MT1005_L02'),
-- Sinh viên: bao.legia251
('bao.legia251', 'HK251_CO2013_L01'),
('bao.legia251', 'HK251_CO3001_L01'),
('bao.legia251', 'HK241_CO2003_L02'), 
('bao.legia251', 'HK242_CO2039_L01'),
('bao.legia251', 'HK241_CO2007_L01'), 
('bao.legia251', 'HK232_MT1005_L01'),
-- Sinh viên: duy.luhoangBK1
('duy.luhoangBK1', 'HK251_CO2013_L01'),
('duy.luhoangBK1', 'HK251_CO3001_L01'),
('duy.luhoangBK1', 'HK241_CO2003_L01'), 
('duy.luhoangBK1', 'HK251_CO3093_L01'),
('duy.luhoangBK1', 'HK242_CO2039_L01'),
('duy.luhoangBK1', 'HK241_CO2007_L02'), 
('duy.luhoangBK1', 'HK232_CO1027_L01'),
('duy.luhoangBK1', 'HK232_MT1005_L01'),
-- Sinh viên: hoi.banhphuK23
('hoi.banhphuK23', 'HK251_CO2013_L01'),
('hoi.banhphuK23', 'HK251_CO3001_L01'),
('hoi.banhphuK23', 'HK251_CO3093_L01'),
('hoi.banhphuK23', 'HK242_CO2039_L01'),
('hoi.banhphuK23', 'HK241_CO2007_L03'),
('hoi.banhphuK23', 'HK232_CO1027_L01'),
('hoi.banhphuK23', 'HK232_MT1005_L02');

-- Mục tài liệu
INSERT INTO Management.MucTaiLieu (MaLopHoc, MaMuc, TenMuc, MoTa) VALUES
-- HK251_CO2013_L01
('HK251_CO2013_L01',1, N'Bài giảng', N'Đây là bài giảng về môn Hệ cơ sở dữ liệu'),
('HK251_CO2013_L01',2, N'Link tham khảo', N'Đây là link tham khảo về môn Hệ cơ sở dữ liệu'),
-- HK251_CO3001_L01
('HK251_CO3001_L01',1, N'Bài giảng', N'Đây là bài giảng về môn Công nghệ phần mềm'),
('HK251_CO3001_L01',2, N'Tài liệu tham khảo', N'Đây là tài liệu tham khảo về môn Công nghệ phần mềm'),
-- HK241_CO2003_L01
('HK241_CO2003_L01',1, N'Bài giảng', N'Đây là bài giảng về môn Cấu trúc Dữ liệu và Giải Thuật'),
('HK241_CO2003_L01',2, N'Video hướng dẫn', N'Đây là video về môn Cấu trúc Dữ liệu và Giải Thuật'),
-- HK241_CO2003_L02
('HK241_CO2003_L02',1, N'Bài giảng', N'Đây là bài giảng về môn Cấu trúc Dữ liệu và Giải Thuật'),
('HK241_CO2003_L02',2, N'Video hướng dẫn', N'Đây là video về môn Cấu trúc Dữ liệu và Giải Thuật'),
-- HK251_CO3093_L01
('HK251_CO3093_L01',1, N'Bài giảng', N'Đây là bài giảng về môn Mạng máy tính'),
-- HK242_CO2039_L01
('HK242_CO2039_L01',1, N'Bài giảng', N'Đây là bài giảng về môn Lập trình nâng cao'),
-- HK241_CO2007_L01
('HK241_CO2007_L01',1, N'Bài giảng', N'Đây là bài giảng về môn Kiến trúc máy tính'),
-- HK241_CO2007_L02
('HK241_CO2007_L02',1, N'Bài giảng', N'Đây là bài giảng về môn Kiến trúc máy tính'),
-- HK241_CO2007_L03
('HK241_CO2007_L03',1, N'Bài giảng', N'Đây là bài giảng về môn Kiến trúc máy tính'),
-- HK232_CO1027_L01
('HK232_CO1027_L01',1, N'Bài giảng', N'Đây là bài giảng về môn Kỹ thuật lập trình'),
-- HK232_MT1005_L01
('HK232_MT1005_L01',1, N'Bài giảng', N'Đây là bài giảng về môn Giải tích 2'),
-- HK232_MT1005_L02
('HK232_MT1005_L02',1, N'Bài giảng', N'Đây là bài giảng về môn Giải tích 2');

-- Tài liệu môn học
INSERT INTO Management.TaiLieuMonHoc (TenMonHoc, TenTaiLieu, MoTaTaiLieu , LoaiTaiLieu, MaNguoiTao) VALUES
-- Hệ cơ sở dữ liệu
(N'Hệ cơ sở Dữ liệu', N'1 DatabaseSystem Overview', N'Tổng quan về Hệ cơ sở dữ liệu', N'tài liệu dạng tệp', 'duy.levanVNET'),
(N'Hệ cơ sở Dữ liệu', N'2 EntityRelationship Model', N'Các thực thể và mối quan hệ',N'tài liệu dạng tệp', 'duy.levanVNET'),
(N'Hệ cơ sở Dữ liệu', N'Example SQL', N'Xem trước khi bắt đầu buổi học',N'link tham khảo', 'duy.levanVNET'),
(N'Hệ cơ sở Dữ liệu', N'Example EERD', N'Xem trước khi bắt đầu buổi học',N'link tham khảo', 'duy.levanVNET'),
-- Công nghệ phần mềm
(N'Công nghệ phần mềm', N'01_Ch1 Introduction', N'Tổng quan về Công nghệ phần mềm', N'tài liệu dạng tệp', 'bao.nguyenthegiabao01'),
(N'Công nghệ phần mềm', N'02_Ch2 Software Processes', N'Chương 2', N'tài liệu dạng tệp', 'bao.nguyenthegiabao01'),
(N'Công nghệ phần mềm', N'03_Ch3_4 Requirements Engineering', N'Chương 3 và 4', N'tài liệu dạng tệp', 'bao.nguyenthegiabao01'),
(N'Công nghệ phần mềm', N'04_Ch5 System Modeling', N'Chương 5', N'tài liệu dạng tệp', 'bao.nguyenthegiabao01'),
(N'Công nghệ phần mềm', N'Class Diagram Guide', N'Hướng dẫn cách vẽ class diagram',N'link tham khảo', 'bao.nguyenthegiabao01'),
(N'Công nghệ phần mềm', N'Sequence Diagram Guide', N'Hướng dẫn cách vẽ sequence diagram',N'link tham khảo', 'bao.nguyenthegiabao01'),
(N'Công nghệ phần mềm', N'Activity Diagram Guide', N'Hướng dẫn cách vẽ activity diagram',N'link tham khảo', 'bao.nguyenthegiabao01'),
-- Cấu trúc dữ liệu và giải thuật
(N'Cấu trúc Dữ liệu và Giải Thuật', N'00 Introduction', N'Tổng quan về Câu trúc Dữ liệu và Giải Thuật', N'tài liệu dạng tệp', 'bao.nguyenthegiabao01'),
(N'Cấu trúc Dữ liệu và Giải Thuật', N'List-part1', N'Cấu trúc danh sách', N'tài liệu dạng tệp', 'bao.nguyenthegiabao01'),
(N'Cấu trúc Dữ liệu và Giải Thuật', N'Sorting part 1', N'Các thuật toán về sắp xếp phần 1', N'video bài giảng', 'bao.nguyenthegiabao01'),
(N'Cấu trúc Dữ liệu và Giải Thuật', N'Sorting part 2', N'Các thuật toán về sắp xếp phần 2', N'video bài giảng', 'bao.nguyenthegiabao01'),
(N'Cấu trúc Dữ liệu và Giải Thuật', N'Sorting part 3', N'Các thuật toán về sắp xếp phần 3', N'video bài giảng', 'bao.nguyenthegiabao01'),
(N'Cấu trúc Dữ liệu và Giải Thuật', N'Sorting part 4', N'Các thuật toán về sắp xếp phần 4', N'video bài giảng', 'bao.nguyenthegiabao01'),
(N'Cấu trúc Dữ liệu và Giải Thuật', N'Sorting part 5', N'Các thuật toán về sắp xếp phần 5', N'video bài giảng', 'bao.nguyenthegiabao01');

-- Sở hữu (Liên kết Lớp - Mục - Tài liệu)
INSERT INTO Management.SoHuu (MaLopHoc, MaMuc, MaTaiLieu) VALUES
---- HK251_CO2013_L01
-- HK251_CO2013_L01 -> Bài giảng
('HK251_CO2013_L01', 1, 1),
('HK251_CO2013_L01', 1, 2),
-- HK251_CO2013_L01 -> Link tham khảo
('HK251_CO2013_L01', 2, 3),
('HK251_CO2013_L01', 2, 4),

---- HK251_CO3001_L01
-- HK251_CO3001_L01 -> Bài giảng
('HK251_CO3001_L01', 1, 5),
('HK251_CO3001_L01', 1, 6),
('HK251_CO3001_L01', 1, 7),
('HK251_CO3001_L01', 1, 8),
-- HK251_CO3001_L01 -> Link tham khảo
('HK251_CO3001_L01', 2, 9),
('HK251_CO3001_L01', 2, 10),
('HK251_CO3001_L01', 2, 11),

---- HK241_CO2003_L01
-- HK241_CO2003_L01 -> Bài giảng
('HK241_CO2003_L01', 1, 12),
('HK241_CO2003_L01', 1, 13),
-- HK241_CO2003_L01 -> Video hướng dẫn
('HK241_CO2003_L01', 2, 14),
('HK241_CO2003_L01', 2, 15),
('HK241_CO2003_L01', 2, 16),
('HK241_CO2003_L01', 2, 17),
('HK241_CO2003_L01', 2, 18),

---- HK241_CO2003_L02
-- HK241_CO2003_L02 -> Bài giảng
('HK241_CO2003_L02', 1, 12),
('HK241_CO2003_L02', 1, 13),
-- HK241_CO2003_L02 -> Video hướng dẫn
('HK241_CO2003_L02', 2, 14),
('HK241_CO2003_L02', 2, 15),
('HK241_CO2003_L02', 2, 16),
('HK241_CO2003_L02', 2, 17),
('HK241_CO2003_L02', 2, 18);

-- Tài liệu dạng tệp
INSERT INTO Management.TaiLieuDangTep (MaTaiLieu, LoaiTep, DuongDanFile) VALUES
(1, N'pdf', N'mod_resource/content/0/1_DatabaseSystem_Overview.pdf'),
(2, N'pdf', N'mod_resource/content/0/2A_EntityRelationship%20Model.pdf'),
(5, N'pdf', N'mod_resource/content/1/01_Ch1%20Introduction_2025.pdf'),
(6, N'pdf', N'mod_resource/content/1/02_Ch2%20Software%20Processes.pdf'),
(7, N'pdf', N'mod_resource/content/1/03_Ch3_4%20Requirements%20Engineering.pdf'),
(8, N'pdf', N'mod_resource/content/1/06_Ch6%20System%20Modeling_2025.pdf'),
(12, N'pdf', N'mod_resource/content/1/DSA___Chapter_1__Introduction_in_recursion_and_complexity_of_algorithms.pdf'),
(13, N'pdf', N'mod_resource/content/1/Lists_P_1_.pdf');

-- Link tham khảo
INSERT INTO Management.LinkThamKhao (MaTaiLieu, DuongDanWeb) VALUES
(3, N'https://www.w3schools.com/sql/sql_examples.asp'),
(4, N'https://www.geeksforgeeks.org/dbms/introduction-of-er-model/'),
(9, N'https://www.geeksforgeeks.org/system-design/unified-modeling-language-uml-class-diagrams/'),
(10, N'https://www.geeksforgeeks.org/system-design/unified-modeling-language-uml-sequence-diagrams/'),
(11, N'https://www.geeksforgeeks.org/system-design/unified-modeling-language-uml-activity-diagrams/');

-- Video bài giảng
INSERT INTO Management.VideoBaiGiang (MaTaiLieu, DuongDanFileVideo) VALUES
(14, N'https://www.youtube.com/watch?v=RiGCVzw7pl8&t=2s'),
(15, N'https://www.youtube.com/watch?v=RiGCVzw7pl8&t=2s'),
(16, N'https://www.youtube.com/watch?v=RiGCVzw7pl8&t=2s'),
(17, N'https://www.youtube.com/watch?v=RiGCVzw7pl8&t=2s'),
(18, N'https://www.youtube.com/watch?v=RiGCVzw7pl8&t=2s');

------------------------------------------------
-- 2. TESTING: Kiểm tra
------------------------------------------------

INSERT INTO Testing.BaiKiemTra (MaLopHoc,MaBaiKiemTra, TenBaiKiemTra, GhiChu,SoLanThu, ThoiLuongLamBai, HeSo, ThoiGianBatDau, ThoiGianKetThuc, MaNguoiTao) VALUES
-- HK251_CO2013_L01
('HK251_CO2013_L01', 1	,N'Quiz 1', N'Sinh viên đọc kỹ yêu cầu'							, 2, 10, 0.1,'2025-12-5'	, '2025-12-7'	,'duy.levanVNET'),
('HK251_CO2013_L01', 2	,N'Quiz 2', N'Sinh viên đọc kỹ yêu cầu'							, 1, 40, 0.1,'2025-11-20'	, '2025-12-7'	,'duy.levanVNET'),

-- HK251_CO3001_L01
('HK251_CO3001_L01', 1	,N'Quiz 1', N'Kiểm tra chương 1'							, 2, 15, 0.2,'2025-10-6'	, '2025-12-1'	,'bao.nguyenthegiabao01'),
('HK251_CO3001_L01', 2	,N'Quiz 2', N'Kiểm tra chương 2'							, 2, 15, 0.2,'2025-11-14'	, '2025-12-14'	,'bao.nguyenthegiabao01'),
('HK251_CO3001_L01', 3	,N'Quiz 3', N'Kiểm tra chương 3'							, 2, 15, 0.1,'2025-12-1'	, '2025-12-30'	,'bao.nguyenthegiabao01'),

--HK242_CO2039_L01	hoang.nguyenlelu99
('HK242_CO2039_L01', 1	,N'Quiz Review'	, N'Review buổi học'								, 4, 10, 0.1,'2025-9-12'	, '2025-9-13'	,'hoang.nguyenlelu99'),
('HK242_CO2039_L01', 2	,N'Quiz ôn tập'	, N'Ôn tập nội dung thi CK'							, 4, 30, 0,'2025-12-1'	, '2025-12-12'	,'hoang.nguyenlelu99'),

--HK241_CO2007_L01	hiep.luhoangLHH
('HK241_CO2007_L01', 1	,N'Quiz C1'	, N'Kiểm tra tự luận'									, 1, 15, 0.1,'2025-11-15'	, '2025-12-1'	,'hiep.luhoangLHH');


INSERT INTO Testing.CauHoi(LoaiCauHoi,NoiDungCauHoi,DiemToiDa) VALUES
(0, N'EERD là gì?',1),
(0, N'EERD viết tắt là?',1),
(0, N'Hình vẽ EERD nào sau đây là đún?',1),
(0, N'Có mấy bước mapping?',1),
(0, N'Chọn bảng ánh xạ đúng nhất',1),
(1, N'Liệt kê ít nhất 10 ràng buộc ngữ ngĩa',10),
(1, N'Liệt kê những thực thể có trong ERD',10);


INSERT INTO Testing.CauHoiLKBaiKT(MaCauHoi,MaBaiKiemTra, MaLopHoc) VALUES
-- HK251_CO2013_L01
(1,1,'HK251_CO2013_L01'),
(2,1,'HK251_CO2013_L01'),
(3,2,'HK251_CO2013_L01'),
(4,2,'HK251_CO2013_L01'),
-- HK251_CO3001_L01
(1,1,'HK251_CO3001_L01'),
(2,1,'HK251_CO3001_L01'),
(3,2,'HK251_CO3001_L01'),
(4,2,'HK251_CO3001_L01'),
(5,3,'HK251_CO3001_L01'),
--HK242_CO2039_L01	
(1,1,'HK242_CO2039_L01'),
(4,1,'HK242_CO2039_L01'),
(6,2,'HK242_CO2039_L01'),
--HK241_CO2007_L01
(7,1,'HK241_CO2007_L01');

INSERT INTO Testing.TuLuan(MaCauHoi,GoiYTraLoi) VALUES
(6,N'Làm dư không bị trừ điểm'),
(7,N'Xác định tuần tự như ví dụ đã học');

INSERT INTO Testing.TracNghiem(MaCauHoi) VALUES
(1), (2), (3), (4), (5);

INSERT INTO Testing.DapAn(MaCauHoi,MaDapAn,NoiDung,TinhDungSai) VALUES
--Dap an cua cau EERD là gì? Câu D đúng
(1,1,'A',0),
(1,2,'B',0),
(1,3,'C',0),
(1,4,'D',1),
--Tương tự các câu sau
(2,1,'A',1),
(2,2,'B',0),
(2,3,'C',0),
(2,4,'D',0),
--Tương tự các câu sau
(3,1,'A',1),
(3,2,'B',0),
(3,3,'C',0),
(3,4,'D',0),
--Tương tự các câu sau
(4,1,'A',0),
(4,2,'B',1),
(4,3,'C',0),
(4,4,'D',0),
--Tương tự các câu sau
(5,1,'A',0),
(5,2,'B',0),
(5,3,'C',1),
(5,4,'D',0);


INSERT INTO Testing.LanThu(MaLopHoc,MaBaiKiemTra,MaLanThu,ThoiGianBatDau,ThoiGianKetThuc,MaNguoiLam) VALUES
-- HK251_CO2013_L01 huy.lugiaHCMUT2   hiep.lehoangGG hiep.nguyenvan123  huy.hoangtheCS2 bao.legia251  duy.luhoangBK1 hoi.banhphuK23
('HK251_CO2013_L01', 1,1, '2025-12-5 9:23:00','2025-12-5 9:33:00', 'huy.lugiaHCMUT2' ),
('HK251_CO2013_L01', 1,2, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'huy.lugiaHCMUT2' ),
('HK251_CO2013_L01', 1,3, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'huy.hoangtheCS2' ),
('HK251_CO2013_L01', 1,4, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'hiep.lehoangGG' ),
('HK251_CO2013_L01', 1,5, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'hiep.nguyenvan123' ),
('HK251_CO2013_L01', 1,6, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'bao.legia251' ),
('HK251_CO2013_L01', 1,7, '2025-12-5 9:23:00','2025-12-5 9:33:00', 'bao.legia251' ),
('HK251_CO2013_L01', 1,8, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'hoi.banhphuK23' ),

-- HK251_CO2013_L01 Bài 2
('HK251_CO2013_L01', 2,1, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'huy.hoangtheCS2' ),
('HK251_CO2013_L01', 2,2, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'bao.legia251' ),
('HK251_CO2013_L01', 2,3, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'duy.luhoangBK1' ),
('HK251_CO2013_L01', 2,4, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'hoi.banhphuK23' ),
-- HK251_CO3001_L01 huy.lugiaHCMUT2 hiep.lehoangGG   duy.nguyenthe001  hiep.nguyenvan123  bao.legia251 duy.luhoangBK1 hoi.banhphuK23
('HK251_CO3001_L01', 1,1, '2025-11-30 9:35:00','2025-12-5 9:45:00', 'huy.lugiaHCMUT2' ),
('HK251_CO3001_L01', 1,2, '2025-11-30 9:35:00','2025-12-5 9:45:00', 'hiep.lehoangGG' ),
('HK251_CO3001_L01', 1,3, '2025-11-30 9:35:00','2025-12-5 9:45:00', 'duy.nguyenthe001' ),
('HK251_CO3001_L01', 1,4, '2025-11-30 9:35:00','2025-12-5 9:45:00', 'hiep.nguyenvan123' ),
('HK251_CO3001_L01', 1,5, '2025-11-30 9:35:00','2025-12-5 9:45:00', 'bao.legia251' ),
('HK251_CO3001_L01', 1,6, '2025-11-30 9:35:00','2025-12-5 9:45:00', 'duy.luhoangBK1' ),
('HK251_CO3001_L01', 1,7, '2025-11-30 9:35:00','2025-12-5 9:45:00', 'hoi.banhphuK23' ),

('HK251_CO3001_L01', 2,1, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'huy.lugiaHCMUT2' ),
('HK251_CO3001_L01', 2,2, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'bao.legia251' ),
('HK251_CO3001_L01', 2,3, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'duy.luhoangBK1' ),
('HK251_CO3001_L01', 2,4, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'hoi.banhphuK23' ),


('HK251_CO3001_L01', 3,1, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'hoi.banhphuK23' ),
('HK251_CO3001_L01', 3,2, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'hoi.banhphuK23' ),
('HK251_CO3001_L01', 3,3, '2025-12-5 9:35:00','2025-12-5 9:45:00', 'hoi.banhphuK23' ),

--HK242_CO2039_L01	Ko đứa nào làm

--HK241_CO2007_L01	-- huy.lugiaHCMUT2  hiep.lehoangGG  duy.nguyenthe001  hiep.nguyenvan123 huy.hoangtheCS2   bao.legia251  duy.luhoangBK1   hoi.banhphuK23
('HK241_CO2007_L01', 1,1, '2025-11-30 9:35:00','2025-11-30 9:45:00', 'huy.lugiaHCMUT2' ),
('HK241_CO2007_L01', 1,2, '2025-11-30 9:35:00','2025-11-30 9:45:00', 'bao.legia251' ),
('HK241_CO2007_L01', 1,3, '2025-11-30 9:35:00','2025-11-30 9:45:00', 'duy.luhoangBK1' );


INSERT INTO Testing.CauTraLoi(MaLopHoc,MaBaiKiemTra,MaLanThu,MaCauHoi,MaCauTraLoi,Diem) VALUES
-- HK251_CO2013_L01 Quiz 1 có 2 câu hỏi 1,2
('HK251_CO2013_L01', 1,1, 1,1,0),
('HK251_CO2013_L01', 1,1, 2,1,0),
('HK251_CO2013_L01', 1,2, 1,2,1 ),
('HK251_CO2013_L01', 1,2, 2,2,1 ),


('HK251_CO2013_L01', 1,3,1,1,1),
('HK251_CO2013_L01', 1,3,2,1,1),
('HK251_CO2013_L01', 1,4,1,1,1),
('HK251_CO2013_L01', 1,4,2,1,1),
('HK251_CO2013_L01', 1,5,1,1,1),
('HK251_CO2013_L01', 1,5,2,1,1),
('HK251_CO2013_L01', 1,6,1,1,1),
('HK251_CO2013_L01', 1,6,2,1,1),
('HK251_CO2013_L01', 1,7,1,1,1),
('HK251_CO2013_L01', 1,7,2,1,1),
('HK251_CO2013_L01', 1,8,1,1,1),
('HK251_CO2013_L01', 1,8,2,1,1),

-- HK251_CO2013_L01 Quiz 2 có 2 câu hỏi 3,4
('HK251_CO2013_L01', 2,1, 3,1,1),
('HK251_CO2013_L01', 2,1, 4,1,1),
('HK251_CO2013_L01', 2,2, 3,1,1),
('HK251_CO2013_L01', 2,2, 4,1,1),
('HK251_CO2013_L01', 2,3, 3,1,1),
('HK251_CO2013_L01', 2,3, 4,1,1),
('HK251_CO2013_L01', 2,4, 3,1,1),
('HK251_CO2013_L01', 2,4, 4,1,1),


-- HK251_CO3001_L01 Quiz 1 có 2 câu 1,2

('HK251_CO3001_L01', 1,1, 1,1,1),
('HK251_CO3001_L01', 1,1, 2,1,1),
('HK251_CO3001_L01', 1,2, 1,1,1),
('HK251_CO3001_L01', 1,2, 2,1,1),
('HK251_CO3001_L01', 1,3, 1,1,1),
('HK251_CO3001_L01', 1,3, 2,1,1),
('HK251_CO3001_L01', 1,4, 1,1,1),
('HK251_CO3001_L01', 1,4, 2,1,1),
('HK251_CO3001_L01', 1,5, 1,1,1),
('HK251_CO3001_L01', 1,5, 2,1,1),
('HK251_CO3001_L01', 1,6, 1,1,1),
('HK251_CO3001_L01', 1,6, 2,1,1),
('HK251_CO3001_L01', 1,7, 1,1,1),
('HK251_CO3001_L01', 1,7, 2,1,1),

-- HK251_CO3001_L01 Quiz 2 có 2 câu 3,4 

('HK251_CO3001_L01', 2,1, 3,1,1),
('HK251_CO3001_L01', 2,1, 4,1,1),
('HK251_CO3001_L01', 2,2, 3,1,1),
('HK251_CO3001_L01', 2,2, 4,1,1),
('HK251_CO3001_L01', 2,3, 3,1,1),
('HK251_CO3001_L01', 2,3, 4,1,1),
('HK251_CO3001_L01', 2,4, 3,1,1),
('HK251_CO3001_L01', 2,4, 4,1,1),

-- HK251_CO3001_L01 Quiz 3 có 1 câu  5

('HK251_CO3001_L01', 3,1, 5,1,0 ),
('HK251_CO3001_L01', 3,1, 5,2,0 ),
('HK251_CO3001_L01', 3,1, 5,3,1 ),
--HK242_CO2039_L01	Ko đứa nào làm

--HK241_CO2007_L01	-- huy.lugiaHCMUT2  hiep.lehoangGG  duy.nguyenthe001  hiep.nguyenvan123 huy.hoangtheCS2   bao.legia251  duy.luhoangBK1   hoi.banhphuK23
--Quiz 1 có câu 7
('HK241_CO2007_L01', 1,1, 7,1,10),
('HK241_CO2007_L01', 1,2, 7,1,8),
('HK241_CO2007_L01', 1,3, 7,1,0);

INSERT INTO Testing.CauTraLoiChiTiet(MaLopHoc,MaBaiKiemTra,MaLanThu,MaCauHoi,MaCauTraLoi,MaDapAn) VALUES
-- HK251_CO2013_L01 Quiz 1 có 2 câu hỏi 1,2 (D,A)
('HK251_CO2013_L01', 1,1, 1,1,1),
('HK251_CO2013_L01', 1,1, 2,1,4),
('HK251_CO2013_L01', 1,2, 1,2,4 ),
('HK251_CO2013_L01', 1,2, 2,2,1 ),

('HK251_CO2013_L01', 1,3,1,1,4),
('HK251_CO2013_L01', 1,3,2,1,1),
('HK251_CO2013_L01', 1,4,1,1,4),
('HK251_CO2013_L01', 1,4,2,1,1),
('HK251_CO2013_L01', 1,5,1,1,4),
('HK251_CO2013_L01', 1,5,2,1,1),
('HK251_CO2013_L01', 1,6,1,1,4),
('HK251_CO2013_L01', 1,6,2,1,1),
('HK251_CO2013_L01', 1,7,1,1,4),
('HK251_CO2013_L01', 1,7,2,1,1),
('HK251_CO2013_L01', 1,8,1,1,4),
('HK251_CO2013_L01', 1,8,2,1,1),

-- HK251_CO2013_L01 Quiz 2 có 2 câu hỏi 3,4
('HK251_CO2013_L01', 2,1, 3,1,1),
('HK251_CO2013_L01', 2,1, 4,1,2),
('HK251_CO2013_L01', 2,2, 3,1,1),
('HK251_CO2013_L01', 2,2, 4,1,2),
('HK251_CO2013_L01', 2,3, 3,1,1),
('HK251_CO2013_L01', 2,3, 4,1,2),
('HK251_CO2013_L01', 2,4, 3,1,1),
('HK251_CO2013_L01', 2,4, 4,1,2),

-- HK251_CO3001_L01 Quiz 1 có 2 câu 1,2

('HK251_CO3001_L01', 1,1, 1,1,4),
('HK251_CO3001_L01', 1,1, 2,1,1),
('HK251_CO3001_L01', 1,2, 1,1,4),
('HK251_CO3001_L01', 1,2, 2,1,1),
('HK251_CO3001_L01', 1,3, 1,1,4),
('HK251_CO3001_L01', 1,3, 2,1,1),
('HK251_CO3001_L01', 1,4, 1,1,4),
('HK251_CO3001_L01', 1,4, 2,1,1),
('HK251_CO3001_L01', 1,5, 1,1,4),
('HK251_CO3001_L01', 1,5, 2,1,1),
('HK251_CO3001_L01', 1,6, 1,1,4),
('HK251_CO3001_L01', 1,6, 2,1,1),
('HK251_CO3001_L01', 1,7, 1,1,4),
('HK251_CO3001_L01', 1,7, 2,1,1),

-- HK251_CO3001_L01 Quiz 2 có 2 câu 3,4 (A,B)

('HK251_CO3001_L01', 2,1, 3,1,1),
('HK251_CO3001_L01', 2,1, 4,1,2),
('HK251_CO3001_L01', 2,2, 3,1,1),
('HK251_CO3001_L01', 2,2, 4,1,2),
('HK251_CO3001_L01', 2,3, 3,1,1),
('HK251_CO3001_L01', 2,3, 4,1,2),
('HK251_CO3001_L01', 2,4, 3,1,1),
('HK251_CO3001_L01', 2,4, 4,1,2),

-- HK251_CO3001_L01 Quiz 3 có 1 câu  5(C)

('HK251_CO3001_L01', 3,1, 5,1,1 ),
('HK251_CO3001_L01', 3,1, 5,2,2 ),
('HK251_CO3001_L01', 3,1, 5,3,3 );
--HK242_CO2039_L01	Ko đứa nào làm


------------------------------------------------
-- 3. FORUM: Diễn đàn
------------------------------------------------
-- Diễn đàn
INSERT INTO Forum.DienDan (TenDienDan, MaLopHoc, MaNguoiTao) VALUES
(N'Assignment 1 - Forum', 'HK251_CO2013_L01', 'duy.levanVNET'),
(N'Forum CNPM', 'HK251_CO3001_L01', 'bao.nguyenthegiabao01'),
(N'Coding Helper', 'HK241_CO2003_L01', 'bao.nguyenthegiabao01'),
(N'Questions', 'HK251_CO3093_L01', 'hoang.nguyenlelu99'),
(N'Forum QnA', 'HK242_CO2039_L01', 'hoang.nguyenlelu99');

-- Nhóm
INSERT INTO Forum.Nhom (MaDienDan, MaNhom, MaNguoiTao) VALUES
-- HK251_CO2013_L01
(1, 1, 'duy.levanVNET'),
(1, 2, 'duy.levanVNET'),
-- HK251_CO3001_L01
(2, 1, 'bao.nguyenthegiabao01'),
(2, 2, 'bao.nguyenthegiabao01'),
-- HK241_CO2003_L01
(3, 1, 'bao.nguyenthegiabao01'),
-- HK251_CO3093_L01
(4, 1, 'hoang.nguyenlelu99'),
-- HK242_CO2039_L01
(5, 1, 'hoang.nguyenlelu99');

-- Bảng Tham gia (Sinh viên tham gia diễn đàn/nhóm)
INSERT INTO Management.ThamGia (MaNguoiDungSinhVien, MaDienDan, MaNhom) VALUES
-- HK251_CO2013_L01 - Nhóm 1
('huy.lugiaHCMUT2', 1, 1),
('hiep.lehoangGG', 1, 1),
-- HK251_CO2013_L01 - Nhóm 2
('duy.nguyenthe001', 1, 2),
('hiep.lehoangGG', 1, 2),
-- HK251_CO3001_L01 - Nhóm 1
('hoi.banhphuK23', 2, 1),
('huy.lugiaHCMUT2', 2, 1),
-- HK251_CO3001_L01 - Nhóm 2
('hiep.lehoangGG', 2, 1);

-- Chủ đề thảo luận
INSERT INTO Forum.ChuDeThaoLuan (MaNguoiTaoChuDe, MaDienDan, MaNhom, MaChuDe, TenChuDe, ThoiGianKhoiTao) VALUES
-- HK251_CO2013_L01 - Nhóm 1
('huy.lugiaHCMUT2', 1, 1, 1, N'Thắc mắc về thiết kế ERD', '2025-12-01'),
-- HK251_CO2013_L01 - Nhóm 2
('hiep.lehoangGG', 1, 2, 1, N'Thắc mắc về mapping', '2025-12-02'),
-- HK251_CO3001_L01 - Nhóm 1
('hoi.banhphuK23', 2, 1, 1, N'Mô tả Class Diagram', '2025-11-25'),
('huy.lugiaHCMUT2', 2, 1, 2, N'Cách lựa chọn mô hình', '2025-11-26'),
-- HK251_CO3001_L01 - Nhóm 2
('hiep.lehoangGG', 2, 2, 1, N'Giải đáp về UI mockup', '2025-11-27');

-- Phản hồi
INSERT INTO Forum.PhanHoi (MaNguoiTaoChuDe, MaDienDan, MaNhom, MaChuDe, MaNguoiPhanHoi, MaPhanHoi, ThoiGianKhoiTao, VanBan, DuongDanHinhAnh, MaTraLoiPhanHoi) VALUES
-- HK251_CO2013_L01 - Nhóm 1 - Chủ đề 1
('huy.lugiaHCMUT2', 1, 1, 1, N'huy.lugiaHCMUT2', 1, '2025-12-01', N'Mình đang vẽ ERD, cho mình hỏi sinh viên có cần nối quan hệ với khoa không?', NULL, NULL),
('huy.lugiaHCMUT2', 1, 1, 1, 'hiep.lehoangGG', 2, '2025-12-01', N'Có nha bạn, mối quan hệ 1-N, một khoa quản lý nhiều sinh viên.', NULL, 1),
-- HK251_CO2013_L01 - Nhóm 2 - Chủ đề 1
('hiep.lehoangGG', 1, 2, 1, 'hiep.lehoangGG', 3, '2025-12-02', N'Mọi người cho mình hỏi khi map từ ERD sang lược đồ quan hệ thì thuộc tính đa trị xử lý sao?', NULL, NULL),
('hiep.lehoangGG', 1, 2, 1, 'duy.nguyenthe001', 4, '2025-12-02', N'Tách thành bảng riêng và lấy khóa chính của bảng cha làm khóa ngoại nhé.', NULL, 3),
-- HK251_CO3001_L01 - Nhóm 1 - Chủ đề 1
('hoi.banhphuK23', 2, 1, 1, 'hoi.banhphuK23', 5, '2025-11-25', N'Class Diagram có cần vẽ chi tiết getter/setter không ạ?', NULL, NULL),
('hoi.banhphuK23', 2, 1, 1, 'huy.lugiaHCMUT2', 6, '2025-11-25', N'Không cần đâu, chỉ cần ghi tên thuộc tính và phương thức chính thôi.', NULL, 5),
-- HK251_CO3001_L01 - Nhóm 1 - Chủ đề 2
('huy.lugiaHCMUT2', 2, 1, 2, 'huy.lugiaHCMUT2', 7, '2025-11-26', N'Dự án Web bán hàng thì nên dùng mô hình Thác nước (Waterfall) hay Agile nhỉ?', NULL, NULL),
('huy.lugiaHCMUT2', 2, 1, 2, 'hoi.banhphuK23', 8, '2025-11-26', N'Nên dùng Agile (Scrum) nhé, vì yêu cầu của khách hàng thay đổi liên tục.', NULL, 7),
-- HK251_CO3001_L01 - Nhóm 2 - Chủ đề 1
('hiep.lehoangGG', 2, 2, 1, 'hiep.lehoangGG', 9, '2025-11-27', N'Mình dùng figma để làm mockup cho UI được không ạ?', NULL, NULL);

------------------------------------------------
-- 4. SURVEY: Khảo sát
------------------------------------------------
INSERT INTO Survey.KhaoSat (TenKhaoSat, MoTa, ThoigianBatDau, ThoiGianKetThuc) VALUES
(N'Khảo sát Hệ cơ sở Dữ liệu HK251_CO2013_L01 Lê Văn Duy', N'Khảo sát ý kiến, nhận xét của sinh viên về lớp học nhằm hỗ trợ cải thiện công tác giảng dạy', '2025-10-01', '2025-10-15'),
(N'Khảo sát Công nghệ phần mềm HK251_CO3001_L01 Nguyễn Thế Gia Bảo', N'Khảo sát ý kiến, nhận xét của sinh viên về lớp học nhằm hỗ trợ cải thiện công tác giảng dạy', '2025-10-01', '2025-10-15'),
(N'Khảo sát Cấu trúc Dữ liệu và Giải Thuật HK241_CO2003_L01 Nguyễn Thế Gia Bảo', N'Khảo sát ý kiến, nhận xét của sinh viên về lớp học nhằm hỗ trợ cải thiện công tác giảng dạy', '2025-10-01', '2025-10-15'),
(N'Khảo sát Mạng máy tính HK251_CO3093_L01 Nguyễn Lê Lữ Hoàng', N'Khảo sát ý kiến, nhận xét của sinh viên về lớp học nhằm hỗ trợ cải thiện công tác giảng dạy', '2025-10-01', '2025-10-15'),
(N'Khảo sát Lập trình nâng cao HK242_CO2039_L01 Nguyễn Lê Lữ Hoàng', N'Khảo sát ý kiến, nhận xét của sinh viên về lớp học nhằm hỗ trợ cải thiện công tác giảng dạy', '2025-10-01', '2025-10-15'),
(N'Khảo sát Kiến trúc máy tính HK241_CO2007_L01 Lữ Hoàng Hiệp', N'Khảo sát ý kiến, nhận xét của sinh viên về lớp học nhằm hỗ trợ cải thiện công tác giảng dạy', '2025-10-01', '2025-10-15'),
(N'Khảo sát Kỹ thuật lập trình HK232_CO1027_L01 Lữ Hoàng Hiệp', N'Khảo sát ý kiến, nhận xét của sinh viên về lớp học nhằm hỗ trợ cải thiện công tác giảng dạy', '2025-10-01', '2025-10-15'),
(N'Khảo sát Giải tích 2 HK232_MT1005_L01 Nguyễn Hoàng Bảo', N'Khảo sát ý kiến, nhận xét của sinh viên về lớp học nhằm hỗ trợ cải thiện công tác giảng dạy', '2025-10-01', '2025-10-15');
 
UPDATE L
SET L.MaKhaoSat = K.TenKhaoSat
FROM Management.LopHoc L
JOIN Management.NguoiDung GV ON L.MaNguoiDay = GV.MaNguoiDung
JOIN Survey.KhaoSat K 
    ON K.TenKhaoSat LIKE N'%' + L.MaMonHoc + N'%'
    AND K.TenKhaoSat LIKE N'%' + GV.HoTen + N'%'
WHERE L.MaKhaoSat IS NULL;
------------------------------------------------
-- 5. EXERCISE: Bài tập
------------------------------------------------
-- Submission
INSERT INTO Exercise.Submission (TenSubmission, MoTa, ThoiGianBatDau, ThoiGianKetThuc, HeSo, MaLopHoc, MaNguoiTao) VALUES
-- HK251_CO3001_L01
(N'Project #1', N'Nơi nộp báo cáo cho giai đoạn một của bài tập lớn', N'2025-09-18 12:00:00.0000000', N'2025-10-05 23:59:00.0000000', 0, N'HK251_CO3001_L01', N'bao.nguyenthegiabao01'),
(N'Project #2', N'Nơi nộp báo cáo cho giai đoạn hai của bài tập lớn', N'2025-09-18 12:00:00.0000000', N'2025-11-02 23:59:00.0000000', 0, N'HK251_CO3001_L01', N'bao.nguyenthegiabao01'),
(N'Project #3', N'Nơi nộp báo cáo cho giai đoạn ba của bài tập lớn', N'2025-09-18 12:00:00.0000000', N'2025-11-16 23:59:00.0000000', 0, N'HK251_CO3001_L01', N'bao.nguyenthegiabao01'),
(N'Nộp Slide & Video - Deadline 12.12.2025', N'Nơi nộp slide và video trình bày bài tập lớn của các nhóm', N'2025-11-12 12:00:00.0000000', N'2025-11-16 23:59:00.0000000', 0.1, N'HK251_CO3001_L01', N'bao.nguyenthegiabao01'),
(N'Assignment - Final Submission_Project 4', N'Nơi nộp báo cáo đầy đủ của bài tập lớn', N'2025-11-25 12:00:00.0000000', N'2025-11-30 23:00:00.0000000', 0.3, N'HK251_CO3001_L01', N'bao.nguyenthegiabao01'),
-- HK251_CO3093_L01
(N'Submit_Assignment', N'Nơi nộp báo cáo và bài làm bài tập lớn', N'2025-10-31 12:00:00.0000000', N'2025-11-14 07:00:00.0000000', 0, N'HK251_CO3093_L01', N'hoang.nguyenlelu99'),
(N'Nộp báo cáo BTL', N'Các nhóm nộp lại toàn bộ các báo cáo đã chỉnh sửa theo góp ý của thầy, các báo cáo có đầy đủ thành viên nhóm và chỉ nhóm trưởng đại diện nộp bài', N'2025-11-17 00:00:00.0000000', N'2025-11-24 00:00:00.0000000', 0.3, N'HK251_CO3093_L01', N'hoang.nguyenlelu99');

-- DinhDangTapTin
INSERT INTO Exercise.DinhDangTapTin (MaSubmission, DinhDangTapTin) VALUES
-- HK251_CO3001_L01
(1, N'pdf'),
(2, N'pdf'),
(3, N'pdf'),
(4, N'mp4'),
(4, N'mov'),
(4, N'mkv'),
(4, N'pptx'),
(4, N'ppt'),
(4, N'pdf'),
(5, N'pdf'),
-- HK251_CO3093_L01
(6, N'zip'),
(7, N'pdf');

-- DinhDangTapTinDinhKem
INSERT INTO Exercise.DuongDanTapTinDinhKem (MaSubmission, DuongDanTapTinDinhKem) VALUES
-- HK251_CO3001_L01
(1, N'https://lms.hcmut.edu.vn/pluginfile.php/1301001/mod_assign/introattachment/0/Project_Phase1_Requirements.pdf'),
(2, N'https://lms.hcmut.edu.vn/pluginfile.php/1301002/mod_assign/introattachment/0/Project_Phase2_Design_Spec.pdf'),
(3, N'https://lms.hcmut.edu.vn/pluginfile.php/1301003/mod_assign/introattachment/0/Project_Phase3_Implementation.pdf'),
(5, N'https://lms.hcmut.edu.vn/pluginfile.php/1301020/mod_assign/introattachment/0/Final_Report_Format_Guideline.pdf'),
-- HK251_CO3093_L01
(6, N'https://lms.hcmut.edu.vn/pluginfile.php/1302055/mod_assign/introattachment/0/CO3093_Assignment_Specification_v2.pdf'),
(7, N'https://lms.hcmut.edu.vn/pluginfile.php/1302060/mod_assign/introattachment/0/Feedback_Correction_Checklist.docx');

-- NopBai
INSERT INTO Exercise.NopBai (MaNguoiDung, MaSubmission, ThoiGianNopBai) VALUES
-- HK251_CO3001_L01
('huy.lugiaHCMUT2', 1, '2025-10-06 08:00:00'),
('bao.legia251', 1, '2025-10-04 15:30:00'),
('duy.nguyenthe001', 2, '2025-11-01 10:00:00'),
('hiep.lehoangGG', 3, '2025-11-16 23:58:00'),
('duy.luhoangBK1', 3, '2025-11-17 08:30:00'),
('hoi.banhphuK23', 5, '2025-11-30 20:00:00'),
-- HK251_CO3093_L01
('huy.hoangtheCS2', 6, '2025-11-13 21:00:00'),
('hiep.nguyenvan123', 6, '2025-11-14 07:15:00'),
('duy.luhoangBK1', 7, '2025-11-23 22:30:00');

-- DuongDanTapTinBaiLam
INSERT INTO Exercise.DuongDanTapTinBaiLam (MaNguoiDung, MaSubmission, DuongDanTapTinBaiLam) VALUES
-- HK251_CO3001_L01
('huy.lugiaHCMUT2', 1, N'https://lms.hcmut.edu.vn/pluginfile.php/1301001/assignsubmission_file/submission_files/1874001/2300001_LugianHuy_Report.pdf'),
('huy.lugiaHCMUT2', 1, N'https://lms.hcmut.edu.vn/pluginfile.php/1301001/assignsubmission_file/submission_files/1874001/2300001_LugianHuy_GiaiTrinh.pdf'),
('bao.legia251', 1, N'https://lms.hcmut.edu.vn/pluginfile.php/1301001/assignsubmission_file/submission_files/1874002/2300006_LeGiaBao_Phase1.pdf'),
('duy.nguyenthe001', 2, N'https://lms.hcmut.edu.vn/pluginfile.php/1301002/assignsubmission_file/submission_files/1874005/2300003_NguyenTheDuy_Design.pdf'),
('hiep.lehoangGG', 3, N'https://lms.hcmut.edu.vn/pluginfile.php/1301003/assignsubmission_file/submission_files/1874010/2300002_LeHoangHiep_Phase3_Final.pdf'),
('duy.luhoangBK1', 3, N'https://lms.hcmut.edu.vn/pluginfile.php/1301003/assignsubmission_file/submission_files/1874012/2300007_LuHoangDuy_LateSubmission.pdf'),
('hoi.banhphuK23', 5, N'https://lms.hcmut.edu.vn/pluginfile.php/1301020/assignsubmission_file/submission_files/1874025/2300008_BanhPhuHoi_FinalReport_v2.pdf'),
-- HK251_CO3093_L01
('huy.hoangtheCS2', 6, N'https://lms.hcmut.edu.vn/pluginfile.php/1302055/assignsubmission_file/submission_files/1885001/2300005_HoangTheHuy.zip'),
('hiep.nguyenvan123', 6, N'https://lms.hcmut.edu.vn/pluginfile.php/1302055/assignsubmission_file/submission_files/1885003/2300004_NguyenVanHiep.zip'),
('duy.luhoangBK1', 7, N'https://lms.hcmut.edu.vn/pluginfile.php/1302060/assignsubmission_file/submission_files/1885010/2300007_LuHoangDuy_FixedFeedback.pdf');

--  CauHoikhaoSat
INSERT INTO Survey.CauHoiKhaoSat (NoiDungCauHoi, LuaChon, MaKhaoSat) VALUES
(N'Giảng viên có truyền đạt kiến thức rõ ràng, dễ hiểu không?', N'Rất tốt;Tốt;Khá;Trung bình;Yếu', N'Khảo sát Hệ cơ sở Dữ liệu HK251_CO2013_L01 Lê Văn Duy'),
(N'Tài liệu môn học có đáp ứng đủ nhu cầu ôn tập không?', N'Đầy đủ;Tạm ổn;Thiếu nhiều;Không có', N'Khảo sát Hệ cơ sở Dữ liệu HK251_CO2013_L01 Lê Văn Duy'),
(N'Bạn có góp ý gì để cải thiện môn học này không?', NULL, N'Khảo sát Hệ cơ sở Dữ liệu HK251_CO2013_L01 Lê Văn Duy'),

(N'Nội dung bài tập lớn có phù hợp với kiến thức đã học?', N'Hoàn toàn phù hợp;Hơi khó;Quá sức;Không liên quan', N'Khảo sát Công nghệ phần mềm HK251_CO3001_L01 Nguyễn Thế Gia Bảo'),
(N'Sự hỗ trợ của giảng viên trong quá trình làm đồ án?', N'Rất nhiệt tình;Bình thường;Ít hỗ trợ', N'Khảo sát Công nghệ phần mềm HK251_CO3001_L01 Nguyễn Thế Gia Bảo'),
(N'Đề xuất của bạn về cách tổ chức làm việc nhóm?', NULL, N'Khảo sát Công nghệ phần mềm HK251_CO3001_L01 Nguyễn Thế Gia Bảo'),

(N'Tốc độ giảng dạy của giảng viên như thế nào?', N'Quá nhanh;Hơi nhanh;Vừa phải;Hơi chậm;Quá chậm', N'Khảo sát Cấu trúc Dữ liệu và Giải Thuật HK241_CO2003_L01 Nguyễn Thế Gia Bảo'),
(N'Chất lượng video bài giảng (nếu có)?', N'Hình ảnh/Âm thanh tốt;Chấp nhận được;Kém', N'Khảo sát Cấu trúc Dữ liệu và Giải Thuật HK241_CO2003_L01 Nguyễn Thế Gia Bảo');

-- TraLoiKhaoSat
INSERT INTO Survey.TraLoi (MaNguoiDung, MaCauHoiKhaoSat, NoiDungTraLoi) VALUES
('huy.lugiaHCMUT2', (SELECT MaCauHoiKhaoSat FROM Survey.CauHoiKhaoSat WHERE NoiDungCauHoi LIKE N'%truyền đạt%' AND MaKhaoSat = N'Khảo sát Hệ cơ sở Dữ liệu HK251_CO2013_L01 Lê Văn Duy'), N'Rất tốt'),
('huy.lugiaHCMUT2', (SELECT MaCauHoiKhaoSat FROM Survey.CauHoiKhaoSat WHERE NoiDungCauHoi LIKE N'%Tài liệu môn học%' AND MaKhaoSat = N'Khảo sát Hệ cơ sở Dữ liệu HK251_CO2013_L01 Lê Văn Duy'), N'Đầy đủ'),
('huy.lugiaHCMUT2', (SELECT MaCauHoiKhaoSat FROM Survey.CauHoiKhaoSat WHERE NoiDungCauHoi LIKE N'%góp ý gì%' AND MaKhaoSat = N'Khảo sát Hệ cơ sở Dữ liệu HK251_CO2013_L01 Lê Văn Duy'), N'Nên bổ sung thêm bài tập thực hành SQL nâng cao.'),
('hiep.lehoangGG', (SELECT MaCauHoiKhaoSat FROM Survey.CauHoiKhaoSat WHERE NoiDungCauHoi LIKE N'%truyền đạt%' AND MaKhaoSat = N'Khảo sát Hệ cơ sở Dữ liệu HK251_CO2013_L01 Lê Văn Duy'), N'Khá'),
('hiep.lehoangGG', (SELECT MaCauHoiKhaoSat FROM Survey.CauHoiKhaoSat WHERE NoiDungCauHoi LIKE N'%Tài liệu môn học%' AND MaKhaoSat = N'Khảo sát Hệ cơ sở Dữ liệu HK251_CO2013_L01 Lê Văn Duy'), N'Tạm ổn'),
('bao.legia251', (SELECT MaCauHoiKhaoSat FROM Survey.CauHoiKhaoSat WHERE NoiDungCauHoi LIKE N'%bài tập lớn%' AND MaKhaoSat = N'Khảo sát Công nghệ phần mềm HK251_CO3001_L01 Nguyễn Thế Gia Bảo'), N'Hơi khó'),
('bao.legia251', (SELECT MaCauHoiKhaoSat FROM Survey.CauHoiKhaoSat WHERE NoiDungCauHoi LIKE N'%hỗ trợ của giảng viên%' AND MaKhaoSat = N'Khảo sát Công nghệ phần mềm HK251_CO3001_L01 Nguyễn Thế Gia Bảo'), N'Rất nhiệt tình'),
('bao.legia251', (SELECT MaCauHoiKhaoSat FROM Survey.CauHoiKhaoSat WHERE NoiDungCauHoi LIKE N'%Đề xuất%' AND MaKhaoSat = N'Khảo sát Công nghệ phần mềm HK251_CO3001_L01 Nguyễn Thế Gia Bảo'), N'Nên cho phép sinh viên tự chọn nhóm thay vì random.'),
('duy.nguyenthe001', (SELECT MaCauHoiKhaoSat FROM Survey.CauHoiKhaoSat WHERE NoiDungCauHoi LIKE N'%bài tập lớn%' AND MaKhaoSat = N'Khảo sát Công nghệ phần mềm HK251_CO3001_L01 Nguyễn Thế Gia Bảo'), N'Hoàn toàn phù hợp'),
('duy.nguyenthe001', (SELECT MaCauHoiKhaoSat FROM Survey.CauHoiKhaoSat WHERE NoiDungCauHoi LIKE N'%hỗ trợ của giảng viên%' AND MaKhaoSat = N'Khảo sát Công nghệ phần mềm HK251_CO3001_L01 Nguyễn Thế Gia Bảo'), N'Bình thường'),
('huy.lugiaHCMUT2', (SELECT MaCauHoiKhaoSat FROM Survey.CauHoiKhaoSat WHERE NoiDungCauHoi LIKE N'%Tốc độ giảng dạy%' AND MaKhaoSat = N'Khảo sát Cấu trúc Dữ liệu và Giải Thuật HK241_CO2003_L01 Nguyễn Thế Gia Bảo'), N'Vừa phải'),
('huy.lugiaHCMUT2', (SELECT MaCauHoiKhaoSat FROM Survey.CauHoiKhaoSat WHERE NoiDungCauHoi LIKE N'%Chất lượng video%' AND MaKhaoSat = N'Khảo sát Cấu trúc Dữ liệu và Giải Thuật HK241_CO2003_L01 Nguyễn Thế Gia Bảo'), N'Hình ảnh/Âm thanh tốt');