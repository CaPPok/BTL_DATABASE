-----------------------------------------------------------------------
-- TẠO BẢNG DỮ LIỆU
-----------------------------------------------------------------------
use LMS_DB;
go
-----------------------------------------------------------------------
-- 1. Schema Management: Chứa bảng Người dùng, Lớp học, Môn học
-----------------------------------------------------------------------
exec('create schema Management');

-- Bảng Người dùng
create table Management.NguoiDung(
	MaNguoiDung			varchar(50)	    primary key,
	Email				varchar(100)   not null,
	GioiTinh			bit            default 0,   -- 0: Nam, 1: Nữ 
	MatKhau				varchar(20)    not null,
	HoTen				nvarchar(50),
	TrangThaiHoatDong	bit				default 1   -- 0: Offline, 1: Online
);

-- Bảng Điện thoại người dùng
create table Management.DienThoaiNguoiDung(
    MaNguoiDung     varchar(50),
    SoDienThoai		varchar(11),
    primary key (MaNguoiDung, SoDienThoai)
);

-- Bảng Sinh viên
create table Management.SinhVien(
	MaNguoiDung     varchar(50) 	primary key,
    MaSoSinhVien    varchar(7)      unique
);

-- Bảng Giảng viên
create table Management.GiangVien(
    MaNguoiDung     varchar(50)		primary key,
    MaSoCanBo       varchar(7)	    unique
);

-- Bảng Bằng cấp
create table Management.BangCap(
    MaNguoiDung     varchar(50),
    ChungChiBangCap nvarchar(7),
    primary key (MaNguoiDung, ChungChiBangCap)
);

-- Bảng Môn học
create table Management.MonHoc(
    MaMonHoc        varchar(6)      primary key,
    TenMonHoc       nvarchar(50),
    MoTa            nvarchar(max)
);

-- Bảng Lớp học
create table Management.LopHoc(
    MaLopHoc        varchar(20)     primary key,
    MaKhaoSat       nvarchar(250),  -- Link tới Survey.KhaoSat(TenKhaoSat)
    MaMonHoc        varchar(6)      not null,
    MaNguoiDay      varchar(50)
);

-- Bảng Tham gia lớp học (của sinh viên)
create table Management.ThamGiaLopHoc(
    MaNguoiDung     varchar(50),
    MaLopHoc        varchar(20), 
    primary key (MaNguoiDung, MaLopHoc)
);

-- Bảng Tham gia (Sinh viên tham gia diễn đàn/nhóm)
create table Management.ThamGia(
    MaNguoiDungSinhVien varchar(50),
    MaDienDan           int,
    MaNhom              int,
    primary key (MaNguoiDungSinhVien, MaDienDan, MaNhom)
);

-- Bảng Mục tài liệu
create table Management.MucTaiLieu(
    MaLopHoc    varchar(20),
    MaMuc       int,
    TenMuc      nvarchar(250),
    MoTa        nvarchar(max),
    primary key (MaLopHoc, MaMuc)
 );

 -- Bảng Tài liệu môn học
 create table Management.TaiLieuMonHoc(
    MaTaiLieu       int         identity primary key,
    TenTaiLieu      nvarchar(max),
    TenMonHoc       nvarchar(50),
    MoTaTaiLieu     nvarchar(max),
    LoaiTaiLieu     nvarchar(50),
    MaNguoiTao      varchar(50)
);

-- Bảng Sở hữu (Liên kết Lớp - Mục - Tài liệu)
create table Management.SoHuu(
    MaLopHoc    varchar(20),
    MaMuc       int,
    MaTaiLieu   int,
    primary key (MaLopHoc, MaMuc, MaTaiLieu)
);

-- Bảng Tài liệu dạng tệp
create table Management.TaiLieuDangTep(
    MaTaiLieu       int         primary key, 
    LoaiTep         nvarchar(50), 
    DuongDanFile    nvarchar(max)
);

-- Bảng Link tham khảo
create table Management.LinkThamKhao(
    MaTaiLieu       int         primary key, 
    DuongDanWeb     nvarchar(max)
);

-- Bảng Video bài giảng
create table Management.VideoBaiGiang(
    MaTaiLieu           int     primary key, 
    DuongDanFileVideo   nvarchar(max)
);

-----------------------------------------------------------------------
-- 2. Schema Testing: Hệ thống bài kiểm tra
-----------------------------------------------------------------------
exec('create schema Testing');

-- Bảng Bài kiểm tra
create table Testing.BaiKiemTra(
    MaLopHoc        varchar(20),
    MaBaiKiemTra    int,
    TenBaiKiemTra   nvarchar(250),
    GhiChu          nvarchar(max),
    SoLanThu        int,
    ThoiLuongLamBai int, 
    HeSo            float,
    ThoiGianBatDau  datetime2      default getdate(),
    ThoiGianKetThuc datetime2,
    MaNguoiTao      varchar(50),
    primary key (MaLopHoc, MaBaiKiemTra)
);

-- Bảng Câu hỏi
create table Testing.CauHoi(
    MaCauHoi        int identity primary key,
    LoaiCauHoi      bit, -- 0: TracNghiem, 1: TuLuan
    NoiDungCauHoi   nvarchar(max),
    DiemToiDa       float,
);

-- Bảng Câu hỏi liên kết tới Bài kiểm tra
create table Testing.CauHoiLKBaiKT(
    MaCauHoi        int,
    MaBaiKiemTra    int,
    MaLopHoc        varchar(20),
    primary key (MaCauHoi, MaBaiKiemTra, MaLopHoc)
);

-- Bảng Tự luận
create table Testing.TuLuan(
    MaCauHoi    int             primary key, 
    GoiYTraLoi  nvarchar(max)
);

-- Bảng Trắc nghiệm
create table Testing.TracNghiem(
    MaCauHoi    int primary key
);

-- Bảng Đáp án
create table Testing.DapAn(
    MaCauHoi    int, 
    MaDapAn     int,
    NoiDung     nvarchar(max), 
    TinhDungSai bit, 
    primary key(MaCauHoi, MaDapAn)
);

-- Bảng Lần thử (Sinh viên làm bài)
create table Testing.LanThu(
    MaLopHoc        varchar(20),
    MaBaiKiemTra    int,
    MaLanThu        int,
    ThoiGianBatDau  datetime2,  
    ThoiGianKetThuc datetime2,
    MaNguoiLam      varchar(50),
    primary key (MaLopHoc, MaBaiKiemTra, MaLanThu)
);

-- Bảng Câu trả lời
create table Testing.CauTraLoi(
     MaLopHoc        varchar(20),
     MaBaiKiemTra    int,
     MaLanThu        int,
     MaCauHoi        int,
     MaCauTraLoi     int,
     Diem            float,
     NoiDung         nvarchar(max),
     MaNguoiCham     varchar(50),
     primary key (MaLopHoc, MaBaiKiemTra, MaLanThu, MaCauHoi, MaCauTraLoi)
);

create table Testing.CauTraLoiChiTiet(
    MaLopHoc      varchar(20),
    MaBaiKiemTra  int,
    MaLanThu      int,
    MaCauHoi      int,
    MaCauTraLoi   int,
    MaDapAn       int,  -- đáp án sinh viên chọn
    PRIMARY KEY (MaLopHoc, MaBaiKiemTra, MaLanThu, MaCauHoi, MaCauTraLoi, MaDapAn)
);

-----------------------------------------------------------------------
-- 3. Schema Forum: Diễn đàn thảo luận
-----------------------------------------------------------------------
exec('create schema Forum');

-- Bảng Diễn đàn
create table Forum.DienDan(
    MaDienDan       int             identity,
    TenDienDan      nvarchar(250),
    MaLopHoc        varchar(20),
    MaNguoiTao      varchar(50),
    constraint PK_DienDan primary key (MaDienDan)
);

-- Bảng Nhóm
create table Forum.Nhom(
    MaDienDan       int,
    MaNhom          int,
    MaNguoiTao      varchar(50),
    constraint PK_Nhom primary key (MaDienDan, MaNhom)
);

-- Bảng Chủ đề thảo luận
create table Forum.ChuDeThaoLuan(
    MaNguoiTaoChuDe varchar(50),
    MaDienDan       int,
    MaNhom          int,
    MaChuDe         int,
    TenChuDe        nvarchar(250),
    ThoiGianKhoiTao datetime2       default getdate(),
    constraint PK_ChuDeThaoLuan primary key (MaNguoiTaoChuDe, MaDienDan, MaNhom, MaChuDe)
);

-- Bảng Phản hồi
create table Forum.PhanHoi(
    MaNguoiTaoChuDe varchar(50),
    MaDienDan       int,
    MaNhom          int,
    MaChuDe         int,
    MaNguoiPhanHoi  varchar(50),
    MaPhanHoi       int,
    ThoiGianKhoiTao datetime2       default getdate(),
    VanBan          nvarchar(max),
    DuongDanHinhAnh nvarchar(max),
    MaTraLoiPhanHoi int,
    constraint PK_PhanHoi primary key (MaNguoiTaoChuDe, MaDienDan, MaNhom, MaChuDe, MaNguoiPhanHoi, MaPhanHoi),
    constraint UQ unique (MaPhanHoi)
);

-----------------------------------------------------------------------
-- 4. Schema Survey: Khảo sát
-----------------------------------------------------------------------
exec('create schema Survey');

-- Bảng Khảo sát
create table Survey.KhaoSat(
    TenKhaoSat      nvarchar(250),
    MoTa            nvarchar(250),
    ThoigianBatDau  datetime2,
    ThoiGianKetThuc datetime2,
    constraint PK_KhaoSat primary key (TenKhaoSat)
);

-- Bảng Câu hỏi khảo sát
create table Survey.CauHoiKhaoSat(
    MaCauHoiKhaoSat int     identity,
    NoiDungCauHoi   nvarchar(max),
    LuaChon         nvarchar(max),
    MaKhaoSat       nvarchar(250),
    constraint PK_CauHoiKhaoSat primary key (MaCauHoiKhaoSat)
);

-- Bảng Trả lời
create table Survey.TraLoi(
    MaNguoiDung     varchar(50),
    MaCauHoiKhaoSat int,
    NoiDungTraLoi   nvarchar(max),
    constraint PK_TraLoi primary key (MaNguoiDung, MaCauHoiKhaoSat)
);

-----------------------------------------------------------------------
-- 5. Schema Exercise: Nộp bài tập
-----------------------------------------------------------------------
exec('create schema Exercise');

-- Bảng Submission
create table Exercise.Submission(
    MaSubmission       int             identity    primary key,
    TenSubmission      nvarchar(250)   NOT NULL,
    MoTa               nvarchar(max),
    ThoiGianBatDau     datetime2       default getdate(),
    ThoiGianKetThuc    datetime2,
    HeSo               float             default 0,
    MaLopHoc           varchar(20),
    MaNguoiTao         varchar(50)
);

-- Bảng Định dạng tập tin
create table Exercise.DinhDangTapTin(
    MaSubmission    int, 
    DinhDangTapTin  nvarchar(50), 
    primary key(MaSubmission, DinhDangTapTin)
);  

-- Bảng Đường dẫn tập tin đính kèm
create table Exercise.DuongDanTapTinDinhKem(
    MaSubmission            int, 
    DuongDanTapTinDinhKem   nvarchar(300), 
    primary key(MaSubmission, DuongDanTapTinDinhKem)
);

-- Bảng Đường dẫn tập tin bài làm
create table Exercise.DuongDanTapTinBaiLam(
    MaNguoiDung             varchar(50), 
    MaSubmission            int, 
    DuongDanTapTinBaiLam    nvarchar(300), 
    primary key(MaNguoiDung, MaSubmission, DuongDanTapTinBaiLam)
);

-- Bảng Nộp bài
create table Exercise.NopBai(
    MaNguoiDung     varchar(50),
    MaSubmission    int,
    ThoiGianNopBai  datetime2   default getdate(),
    primary key (MaNguoiDung, MaSubmission)
);

-----------------------------------------------------------------------
-- THÊM KHÓA NGOẠI
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- 1. LIÊN KẾT SCHEMA MANAGEMENT
-----------------------------------------------------------------------

-- Điện thoại -> Người dùng
IF OBJECT_ID('Management.FK_DienThoai_NguoiDung', 'F') IS NOT NULL ALTER TABLE Management.DienThoaiNguoiDung DROP CONSTRAINT FK_DienThoai_NguoiDung;
ALTER TABLE Management.DienThoaiNguoiDung ADD CONSTRAINT FK_DienThoai_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES Management.NguoiDung(MaNguoiDung);

-- Sinh Viên -> Người dùng
IF OBJECT_ID('Management.FK_SinhVien_NguoiDung', 'F') IS NOT NULL ALTER TABLE Management.SinhVien DROP CONSTRAINT FK_SinhVien_NguoiDung;
ALTER TABLE Management.SinhVien ADD CONSTRAINT FK_SinhVien_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES Management.NguoiDung(MaNguoiDung);

-- Giảng Viên -> Người dùng
IF OBJECT_ID('Management.FK_GiangVien_NguoiDung', 'F') IS NOT NULL ALTER TABLE Management.GiangVien DROP CONSTRAINT FK_GiangVien_NguoiDung;
ALTER TABLE Management.GiangVien ADD CONSTRAINT FK_GiangVien_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES Management.NguoiDung(MaNguoiDung);

-- Bằng cấp -> Người dùng
IF OBJECT_ID('Management.FK_BangCap_NguoiDung', 'F') IS NOT NULL ALTER TABLE Management.BangCap DROP CONSTRAINT FK_BangCap_NguoiDung;
ALTER TABLE Management.BangCap ADD CONSTRAINT FK_BangCap_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES Management.GiangVien(MaNguoiDung);

-- Lớp học -> Môn học
IF OBJECT_ID('Management.FK_LopHoc_MonHoc', 'F') IS NOT NULL ALTER TABLE Management.LopHoc DROP CONSTRAINT FK_LopHoc_MonHoc;
ALTER TABLE Management.LopHoc ADD CONSTRAINT FK_LopHoc_MonHoc FOREIGN KEY (MaMonHoc) REFERENCES Management.MonHoc(MaMonHoc);

-- Lớp học -> Giảng viên (Người dạy)
IF OBJECT_ID('Management.FK_LopHoc_GiangVien', 'F') IS NOT NULL ALTER TABLE Management.LopHoc DROP CONSTRAINT FK_LopHoc_GiangVien;
ALTER TABLE Management.LopHoc ADD CONSTRAINT FK_LopHoc_GiangVien FOREIGN KEY (MaNguoiDay) REFERENCES Management.GiangVien(MaNguoiDung);

-- Lớp học -> Khảo sát (Liên kết qua TenKhaoSat)
IF OBJECT_ID('Management.FK_LopHoc_KhaoSat', 'F') IS NOT NULL ALTER TABLE Management.LopHoc DROP CONSTRAINT FK_LopHoc_KhaoSat;
ALTER TABLE Management.LopHoc ADD CONSTRAINT FK_LopHoc_KhaoSat FOREIGN KEY (MaKhaoSat) REFERENCES Survey.KhaoSat(TenKhaoSat);

-- Tham Gia -> Sinh Viên
IF OBJECT_ID('Management.FK_ThamGia_SinhVien', 'F') IS NOT NULL ALTER TABLE Management.ThamGia DROP CONSTRAINT FK_ThamGia_SinhVien;
ALTER TABLE Management.ThamGia ADD CONSTRAINT FK_ThamGia_SinhVien FOREIGN KEY (MaNguoiDungSinhVien) REFERENCES Management.SinhVien(MaNguoiDung);

-- Mục tài liệu -> Lớp học
IF OBJECT_ID('Management.FK_MucTaiLieu_LopHoc', 'F') IS NOT NULL ALTER TABLE Management.MucTaiLieu DROP CONSTRAINT FK_MucTaiLieu_LopHoc;
ALTER TABLE Management.MucTaiLieu ADD CONSTRAINT FK_MucTaiLieu_LopHoc FOREIGN KEY (MaLopHoc) REFERENCES Management.LopHoc(MaLopHoc);

-- Tài liệu môn học -> Giảng viên (Người tạo)
IF OBJECT_ID('Management.FK_TaiLieu_NguoiTao', 'F') IS NOT NULL ALTER TABLE Management.TaiLieuMonHoc DROP CONSTRAINT FK_TaiLieu_NguoiTao;
ALTER TABLE Management.TaiLieuMonHoc ADD CONSTRAINT FK_TaiLieu_NguoiTao FOREIGN KEY (MaNguoiTao) REFERENCES Management.GiangVien(MaNguoiDung);

-- Sở hữu -> Mục tài liệu & Tài liệu môn học
IF OBJECT_ID('Management.FK_SoHuu_Muc', 'F') IS NOT NULL ALTER TABLE Management.SoHuu DROP CONSTRAINT FK_SoHuu_Muc;
ALTER TABLE Management.SoHuu ADD CONSTRAINT FK_SoHuu_Muc FOREIGN KEY (MaLopHoc, MaMuc) REFERENCES Management.MucTaiLieu(MaLopHoc, MaMuc);

IF OBJECT_ID('Management.FK_SoHuu_TaiLieu', 'F') IS NOT NULL ALTER TABLE Management.SoHuu DROP CONSTRAINT FK_SoHuu_TaiLieu;
ALTER TABLE Management.SoHuu ADD CONSTRAINT FK_SoHuu_TaiLieu FOREIGN KEY (MaTaiLieu) REFERENCES Management.TaiLieuMonHoc(MaTaiLieu);

-- Các bảng con của Tài liệu (Kế thừa)
IF OBJECT_ID('Management.FK_TLFile_TL', 'F') IS NOT NULL ALTER TABLE Management.TaiLieuDangTep DROP CONSTRAINT FK_TLFile_TL;
ALTER TABLE Management.TaiLieuDangTep ADD CONSTRAINT FK_TLFile_TL FOREIGN KEY (MaTaiLieu) REFERENCES Management.TaiLieuMonHoc(MaTaiLieu);

IF OBJECT_ID('Management.FK_TLLink_TL', 'F') IS NOT NULL ALTER TABLE Management.LinkThamKhao DROP CONSTRAINT FK_TLLink_TL;
ALTER TABLE Management.LinkThamKhao ADD CONSTRAINT FK_TLLink_TL FOREIGN KEY (MaTaiLieu) REFERENCES Management.TaiLieuMonHoc(MaTaiLieu);

IF OBJECT_ID('Management.FK_TLVideo_TL', 'F') IS NOT NULL ALTER TABLE Management.VideoBaiGiang DROP CONSTRAINT FK_TLVideo_TL;
ALTER TABLE Management.VideoBaiGiang ADD CONSTRAINT FK_TLVideo_TL FOREIGN KEY (MaTaiLieu) REFERENCES Management.TaiLieuMonHoc(MaTaiLieu);
GO

-----------------------------------------------------------------------
-- 2. LIÊN KẾT SCHEMA TESTING
-----------------------------------------------------------------------

-- Bài kiểm tra -> Lớp học & Giảng viên
IF OBJECT_ID('Testing.FK_BaiKiemTra_LopHoc', 'F') IS NOT NULL ALTER TABLE Testing.BaiKiemTra DROP CONSTRAINT FK_BaiKiemTra_LopHoc;
ALTER TABLE Testing.BaiKiemTra ADD CONSTRAINT FK_BaiKiemTra_LopHoc FOREIGN KEY (MaLopHoc) REFERENCES Management.LopHoc(MaLopHoc);

IF OBJECT_ID('Testing.FK_BaiKiemTra_NguoiTao', 'F') IS NOT NULL ALTER TABLE Testing.BaiKiemTra DROP CONSTRAINT FK_BaiKiemTra_NguoiTao;
ALTER TABLE Testing.BaiKiemTra ADD CONSTRAINT FK_BaiKiemTra_NguoiTao FOREIGN KEY (MaNguoiTao) REFERENCES Management.GiangVien(MaNguoiDung);

-- Các loại câu hỏi
IF OBJECT_ID('Testing.FK_TuLuan_CauHoi', 'F') IS NOT NULL ALTER TABLE Testing.TuLuan DROP CONSTRAINT FK_TuLuan_CauHoi;
ALTER TABLE Testing.TuLuan ADD CONSTRAINT FK_TuLuan_CauHoi FOREIGN KEY (MaCauHoi) REFERENCES Testing.CauHoi(MaCauHoi);

IF OBJECT_ID('Testing.FK_TracNghiem_CauHoi', 'F') IS NOT NULL ALTER TABLE Testing.TracNghiem DROP CONSTRAINT FK_TracNghiem_CauHoi;
ALTER TABLE Testing.TracNghiem ADD CONSTRAINT FK_TracNghiem_CauHoi FOREIGN KEY (MaCauHoi) REFERENCES Testing.CauHoi(MaCauHoi);

-- Đáp án -> Trắc nghiệm
IF OBJECT_ID('Testing.FK_DapAn_TracNghiem', 'F') IS NOT NULL ALTER TABLE Testing.DapAn DROP CONSTRAINT FK_DapAn_TracNghiem;
ALTER TABLE Testing.DapAn ADD CONSTRAINT FK_DapAn_TracNghiem FOREIGN KEY (MaCauHoi) REFERENCES Testing.TracNghiem(MaCauHoi);

-- Lần thử -> Bài kiểm tra & Sinh viên
IF OBJECT_ID('Testing.FK_LanThu_BaiKiemTra', 'F') IS NOT NULL ALTER TABLE Testing.LanThu DROP CONSTRAINT FK_LanThu_BaiKiemTra;
ALTER TABLE Testing.LanThu ADD CONSTRAINT FK_LanThu_BaiKiemTra FOREIGN KEY (MaLopHoc, MaBaiKiemTra) REFERENCES Testing.BaiKiemTra(MaLopHoc, MaBaiKiemTra);

IF OBJECT_ID('Testing.FK_LanThu_SinhVien', 'F') IS NOT NULL ALTER TABLE Testing.LanThu DROP CONSTRAINT FK_LanThu_SinhVien;
ALTER TABLE Testing.LanThu ADD CONSTRAINT FK_LanThu_SinhVien FOREIGN KEY (MaNguoiLam) REFERENCES Management.SinhVien(MaNguoiDung);

-- Câu trả lời -> Lần thử & Câu hỏi & Người chấm
IF OBJECT_ID('Testing.FK_CauTraLoi_LanThu', 'F') IS NOT NULL ALTER TABLE Testing.CauTraLoi DROP CONSTRAINT FK_CauTraLoi_LanThu;
ALTER TABLE Testing.CauTraLoi ADD CONSTRAINT FK_CauTraLoi_LanThu FOREIGN KEY (MaLopHoc, MaBaiKiemTra, MaLanThu) REFERENCES Testing.LanThu(MaLopHoc, MaBaiKiemTra, MaLanThu);

IF OBJECT_ID('Testing.FK_CauTraLoi_CauHoi', 'F') IS NOT NULL ALTER TABLE Testing.CauTraLoi DROP CONSTRAINT FK_CauTraLoi_CauHoi;
ALTER TABLE Testing.CauTraLoi ADD CONSTRAINT FK_CauTraLoi_CauHoi FOREIGN KEY (MaCauHoi) REFERENCES Testing.CauHoi(MaCauHoi);

IF OBJECT_ID('Testing.FK_CauTraLoi_NguoiCham', 'F') IS NOT NULL ALTER TABLE Testing.CauTraLoi DROP CONSTRAINT FK_CauTraLoi_NguoiCham;
ALTER TABLE Testing.CauTraLoi ADD CONSTRAINT FK_CauTraLoi_NguoiCham FOREIGN KEY (MaNguoiCham) REFERENCES Management.GiangVien(MaNguoiDung);
GO

IF OBJECT_ID('Testing.FK_CauTraLoiChiTiet_CauTraLoi', 'F') IS NOT NULL ALTER TABLE Testing.CauTraLoiChiTiet DROP CONSTRAINT FK_CauTraLoiChiTiet_CauTraLoi;
ALTER TABLE Testing.CauTraLoiChiTiet 
ADD CONSTRAINT FK_CauTraLoiChiTiet_CauTraLoi 
FOREIGN KEY (MaLopHoc, MaBaiKiemTra, MaLanThu, MaCauHoi, MaCauTraLoi)
REFERENCES Testing.CauTraLoi(MaLopHoc, MaBaiKiemTra, MaLanThu, MaCauHoi, MaCauTraLoi);
GO

-----------------------------------------------------------------------
-- 3. LIÊN KẾT SCHEMA FORUM
-----------------------------------------------------------------------

-- Diễn đàn -> Lớp học & Giảng viên
IF OBJECT_ID('Forum.FK_DienDan_LopHoc', 'F') IS NOT NULL ALTER TABLE Forum.DienDan DROP CONSTRAINT FK_DienDan_LopHoc;
ALTER TABLE Forum.DienDan ADD CONSTRAINT FK_DienDan_LopHoc FOREIGN KEY (MaLopHoc) REFERENCES Management.LopHoc(MaLopHoc);

IF OBJECT_ID('Forum.FK_DienDan_NguoiTao', 'F') IS NOT NULL ALTER TABLE Forum.DienDan DROP CONSTRAINT FK_DienDan_NguoiTao;
ALTER TABLE Forum.DienDan ADD CONSTRAINT FK_DienDan_NguoiTao FOREIGN KEY (MaNguoiTao) REFERENCES Management.GiangVien(MaNguoiDung);

-- Nhóm -> Diễn đàn & Người tạo
IF OBJECT_ID('Forum.FK_Nhom_DienDan', 'F') IS NOT NULL ALTER TABLE Forum.Nhom DROP CONSTRAINT FK_Nhom_DienDan;
ALTER TABLE Forum.Nhom ADD CONSTRAINT FK_Nhom_DienDan FOREIGN KEY (MaDienDan) REFERENCES Forum.DienDan(MaDienDan);

IF OBJECT_ID('Forum.FK_Nhom_NguoiTao', 'F') IS NOT NULL ALTER TABLE Forum.Nhom DROP CONSTRAINT FK_Nhom_NguoiTao;
ALTER TABLE Forum.Nhom ADD CONSTRAINT FK_Nhom_NguoiTao FOREIGN KEY (MaNguoiTao) REFERENCES Management.GiangVien(MaNguoiDung);

-- Tham Gia (Link ngược từ Management sang Forum.Nhom)
IF OBJECT_ID('Management.FK_ThamGia_Nhom', 'F') IS NOT NULL ALTER TABLE Management.ThamGia DROP CONSTRAINT FK_ThamGia_Nhom;
ALTER TABLE Management.ThamGia ADD CONSTRAINT FK_ThamGia_Nhom FOREIGN KEY (MaDienDan, MaNhom) REFERENCES Forum.Nhom(MaDienDan, MaNhom);

-- Chủ đề thảo luận -> Nhóm & Người tạo
IF OBJECT_ID('Forum.FK_ChuDe_Nhom', 'F') IS NOT NULL ALTER TABLE Forum.ChuDeThaoLuan DROP CONSTRAINT FK_ChuDe_Nhom;
ALTER TABLE Forum.ChuDeThaoLuan ADD CONSTRAINT FK_ChuDe_Nhom FOREIGN KEY (MaDienDan, MaNhom) REFERENCES Forum.Nhom(MaDienDan, MaNhom);

IF OBJECT_ID('Forum.FK_ChuDe_NguoiTao', 'F') IS NOT NULL ALTER TABLE Forum.ChuDeThaoLuan DROP CONSTRAINT FK_ChuDe_NguoiTao;
ALTER TABLE Forum.ChuDeThaoLuan ADD CONSTRAINT FK_ChuDe_NguoiTao FOREIGN KEY (MaNguoiTaoChuDe) REFERENCES Management.NguoiDung(MaNguoiDung);

-- Phản hồi -> Chủ đề & Người phản hồi
IF OBJECT_ID('Forum.FK_PhanHoi_ChuDe', 'F') IS NOT NULL ALTER TABLE Forum.PhanHoi DROP CONSTRAINT FK_PhanHoi_ChuDe;
ALTER TABLE Forum.PhanHoi ADD CONSTRAINT FK_PhanHoi_ChuDe FOREIGN KEY (MaNguoiTaoChuDe, MaDienDan, MaNhom, MaChuDe) REFERENCES Forum.ChuDeThaoLuan(MaNguoiTaoChuDe, MaDienDan, MaNhom, MaChuDe);

IF OBJECT_ID('Forum.FK_PhanHoi_NguoiTraLoi', 'F') IS NOT NULL ALTER TABLE Forum.PhanHoi DROP CONSTRAINT FK_PhanHoi_NguoiTraLoi;
ALTER TABLE Forum.PhanHoi ADD CONSTRAINT FK_PhanHoi_NguoiTraLoi FOREIGN KEY (MaNguoiPhanHoi) REFERENCES Management.NguoiDung(MaNguoiDung);
GO

-- Phản hồi -> Phản hồi khác
IF OBJECT_ID('Forum.FK_PhanHoi_PhanHoiKhac', 'F') IS NOT NULL ALTER TABLE Forum.PhanHoi DROP CONSTRAINT FK_PhanHoi_PhanHoiKhac;
ALTER TABLE Forum.PhanHoi ADD CONSTRAINT FK_PhanHoi_PhanHoiKhac FOREIGN KEY (MaTraLoiPhanHoi) REFERENCES Forum.PhanHoi(MaPhanHoi);
GO
-----------------------------------------------------------------------
-- 4. LIÊN KẾT SCHEMA SURVEY
-----------------------------------------------------------------------

-- Câu hỏi khảo sát -> Khảo sát
IF OBJECT_ID('Survey.FK_CauHoiKS_KhaoSat', 'F') IS NOT NULL ALTER TABLE Survey.CauHoiKhaoSat DROP CONSTRAINT FK_CauHoiKS_KhaoSat;
ALTER TABLE Survey.CauHoiKhaoSat ADD CONSTRAINT FK_CauHoiKS_KhaoSat FOREIGN KEY (MaKhaoSat) REFERENCES Survey.KhaoSat(TenKhaoSat);

-- Trả lời -> Người dùng & Câu hỏi khảo sát
IF OBJECT_ID('Survey.FK_TraLoi_NguoiDung', 'F') IS NOT NULL ALTER TABLE Survey.TraLoi DROP CONSTRAINT FK_TraLoi_NguoiDung;
ALTER TABLE Survey.TraLoi ADD CONSTRAINT FK_TraLoi_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES Management.SinhVien(MaNguoiDung);

IF OBJECT_ID('Survey.FK_TraLoi_CauHoi', 'F') IS NOT NULL ALTER TABLE Survey.TraLoi DROP CONSTRAINT FK_TraLoi_CauHoi;
ALTER TABLE Survey.TraLoi ADD CONSTRAINT FK_TraLoi_CauHoi FOREIGN KEY (MaCauHoiKhaoSat) REFERENCES Survey.CauHoiKhaoSat(MaCauHoiKhaoSat);
GO

-----------------------------------------------------------------------
-- 5. LIÊN KẾT SCHEMA EXERCISE
-----------------------------------------------------------------------

-- Submission -> Lớp học & Người tạo
IF OBJECT_ID('Exercise.FK_Submission_LopHoc', 'F') IS NOT NULL ALTER TABLE Exercise.Submission DROP CONSTRAINT FK_Submission_LopHoc;
ALTER TABLE Exercise.Submission ADD CONSTRAINT FK_Submission_LopHoc FOREIGN KEY (MaLopHoc) REFERENCES Management.LopHoc(MaLopHoc);

IF OBJECT_ID('Exercise.FK_Submission_NguoiTao', 'F') IS NOT NULL ALTER TABLE Exercise.Submission DROP CONSTRAINT FK_Submission_NguoiTao;
ALTER TABLE Exercise.Submission ADD CONSTRAINT FK_Submission_NguoiTao FOREIGN KEY (MaNguoiTao) REFERENCES Management.GiangVien(MaNguoiDung);

-- Nộp bài -> Sinh viên & Submission
IF OBJECT_ID('Exercise.FK_NopBai_SinhVien', 'F') IS NOT NULL ALTER TABLE Exercise.NopBai DROP CONSTRAINT FK_NopBai_SinhVien;
ALTER TABLE Exercise.NopBai ADD CONSTRAINT FK_NopBai_SinhVien FOREIGN KEY (MaNguoiDung) REFERENCES Management.SinhVien(MaNguoiDung);

IF OBJECT_ID('Exercise.FK_NopBai_Submission', 'F') IS NOT NULL ALTER TABLE Exercise.NopBai DROP CONSTRAINT FK_NopBai_Submission;
ALTER TABLE Exercise.NopBai ADD CONSTRAINT FK_NopBai_Submission FOREIGN KEY (MaSubmission) REFERENCES Exercise.Submission(MaSubmission);

-- Định dạng & Đường dẫn -> Submission
IF OBJECT_ID('Exercise.FK_DinhDang_Sub', 'F') IS NOT NULL ALTER TABLE Exercise.DinhDangTapTin DROP CONSTRAINT FK_DinhDang_Sub;
ALTER TABLE Exercise.DinhDangTapTin ADD CONSTRAINT FK_DinhDang_Sub FOREIGN KEY (MaSubmission) REFERENCES Exercise.Submission(MaSubmission);

IF OBJECT_ID('Exercise.FK_FileDeBai_Sub', 'F') IS NOT NULL ALTER TABLE Exercise.DuongDanTapTinDinhKem DROP CONSTRAINT FK_FileDeBai_Sub;
ALTER TABLE Exercise.DuongDanTapTinDinhKem ADD CONSTRAINT FK_FileDeBai_Sub FOREIGN KEY (MaSubmission) REFERENCES Exercise.Submission(MaSubmission);

-- Đường dẫn bài làm -> Nộp bài (Khóa phức hợp)
IF OBJECT_ID('Exercise.FK_FileBaiLam_NopBai', 'F') IS NOT NULL ALTER TABLE Exercise.DuongDanTapTinBaiLam DROP CONSTRAINT FK_FileBaiLam_NopBai;
ALTER TABLE Exercise.DuongDanTapTinBaiLam ADD CONSTRAINT FK_FileBaiLam_NopBai FOREIGN KEY (MaNguoiDung, MaSubmission) REFERENCES Exercise.NopBai(MaNguoiDung, MaSubmission);
GO