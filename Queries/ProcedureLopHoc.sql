use LMS_DB;
go
-----------------------------------------------------------------------
-- Procedure Insert                                                  --
-----------------------------------------------------------------------
create or alter procedure Management.PR_InsertLopHoc
    @MaLopHoc        varchar(20),
    @MaMonHoc        varchar(6),
    @MaNguoiDay      varchar(50)
as
begin try
    -- Check mã lớp học
    if @MaLopHoc is null
    begin
        throw 50001, N'[Error]: Mã lớp học không được phép NULL!', 1
    end
    if exists(select 1 from Management.LopHoc where MaLopHoc = @MaLopHoc)
    begin
        throw 50001, N'[Error]: Đã tồn tại mã lớp học này trong cơ sở dữ liệu!', 2
    end
    -- Check Mã môn
    if @MaMonHoc is null
    begin
        throw 50002, N'[Error]: Mã môn học không được phép NULL!', 1
    end
    if not exists(select 1 from Management.MonHoc where MaMonHoc = @MaMonHoc)
    begin
        throw 50002, N'[Error]: Mã môn học này không tồn tại trong sơ sở dữ liệu!', 2
    end
    -- Check người dạy
    if @MaNguoiDay is null
    begin
        throw 50003, N'[Error]: Mã người dạy không được phép NULL!', 1
    end
    if not exists(select 1 from Management.GiangVien where MaNguoiDung = @MaNguoiDay)
    begin
        throw 50003, N'[Error]: Mã người dạy này không tồn tại hoặc không là giảng viên!', 2
    end
    -- Insert vào bảng Lớp học
    insert into Management.LopHoc
    values (@MaLopHoc, null, @MaMonHoc, @MaNguoiDay);
    print N'[Notify]: Thêm lớp học thành công!';
end try
begin catch
    throw;
end catch
go
-----------------------------------------------------------------------
-- Procedure Update                                                  --
-----------------------------------------------------------------------
create or alter procedure Management.PR_UpdateLopHoc
    @MaLopHoc        varchar(20),
    @MaKhaoSat       nvarchar(250),
    @MaMonHoc        varchar(6),
    @MaNguoiDay      varchar(50)
as
begin try
    -- Check mã lớp học
    if @MaLopHoc is null
    begin
        throw 50001, N'[Error]: Mã lớp học không được phép NULL!', 1
    end
    if not exists(select 1 from Management.LopHoc where MaLopHoc = @MaLopHoc)
    begin
        throw 50001, N'[Error]: Mã lớp học này không tồn tại trong cơ sở dữ liệu!', 3
    end
    -- Check mã khảo sát
    if not exists(select 1 from Survey.KhaoSat where TenKhaoSat = @MaKhaoSat)
    begin
        throw 50004, N'[Error]: Mã khảo sát không tồn tại trong cơ sở dữ liệu!', 1
    end
    -- Check mã môn
    if @MaMonHoc is null
    begin
        throw 50002, N'[Error]: Mã môn học không được phép NULL!', 1
    end
    if not exists(select 1 from Management.MonHoc where MaMonHoc = @MaMonHoc)
    begin
        throw 50002, N'[Error]: Mã môn học này không tồn tại trong sơ sở dữ liệu!', 2
    end
    -- Check người dạy
    if @MaNguoiDay is null
    begin
        throw 50003, N'[Error]: Mã người dạy không được phép NULL!', 1
    end
    if not exists(select 1 from Management.GiangVien where MaNguoiDung = @MaNguoiDay)
    begin
        throw 50003, N'[Error]: Mã người dạy này không tồn tại hoặc không là giảng viên!', 2
    end
    -- Update thông tin Lớp học
    update Management.LopHoc
    set MaKhaoSat = @MaKhaoSat,
        MaMonHoc = @MaMonHoc,
        MaNguoiDay = @MaNguoiDay
    where MaLopHoc = @MaLopHoc;
    print N'[Notify]: Cập nhật thông tin lớp học thành công!';
end try
begin catch
    throw;
end catch
go
-----------------------------------------------------------------------
-- Procedure Delete                                                  --
-----------------------------------------------------------------------
create or alter procedure Management.PR_DeleteLopHoc
    @MaLopHoc        varchar(20)
as
begin
    begin try
        -- Check mã lớp học
        if @MaLopHoc is null
        begin
            throw 50001, N'[Error]: Mã lớp học không được phép NULL!', 1;
        end
        if not exists(select 1 from Management.LopHoc where MaLopHoc = @MaLopHoc)
        begin
            throw 50001, N'[Error]: Mã lớp học này không tồn tại trong cơ sở dữ liệu!', 3;
        end
        -- Check trạng thái lớp học
        if exists(select 1 from Management.ThamGiaLopHoc where MaLopHoc = @MaLopHoc)
        begin
            throw 50005, N'[Error]: Lớp học đang có sinh viên nên không thể xoá!', 1;
        end
        if exists(select 1 from Testing.BaiKiemTra where MaLopHoc = @MaLopHoc)
        begin
            throw 50005, N'[Error]: Lớp học đang có các bài kiểm tra nên không thể xoá!', 2;
        end
        if exists(select 1 from Exercise.Submission where MaLopHoc = @MaLopHoc)
        begin
            throw 50005, N'[Error]: Lớp học đang có các bài tập nên không thể xoá!', 3;
        end
        if exists(select 1 from Forum.DienDan where MaLopHoc = @MaLopHoc)
        begin
            throw 50005, N'[Error]: Lớp học đang chứa các diễn đàn nên không thể xoá!', 4;
        end
        if exists(select 1 from Management.MucTaiLieu where MaLopHoc = @MaLopHoc)
        begin
            throw 50005, N'[Error]: Lớp học đang có các tài liệu nên không thể xoá!', 5;
        end
        -- Delete Lớp học
        delete from Management.LopHoc
        where MaLopHoc = @MaLopHoc;
        print N'[Notify]: Xoá lớp học thành công!';
    end try
    begin catch
        throw;
    end catch
end
-----------------------------------------------------------------------
-- Test Procedure                                                    --
-----------------------------------------------------------------------
