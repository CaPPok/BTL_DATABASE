use LMS_DB;
go

CREATE TRIGGER trg_DapAn_CheckDungSai
ON Testing.DapAn
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Lưu danh sách câu hỏi bị ảnh hưởng vào table variable
    DECLARE @Affected TABLE (MaCauHoi INT);

    INSERT INTO @Affected (MaCauHoi)
    SELECT DISTINCT MaCauHoi FROM inserted
    UNION
    SELECT DISTINCT MaCauHoi FROM deleted;

    -- Kiểm tra câu hỏi trắc nghiệm không có đáp án đúng
    IF EXISTS (
        SELECT 1
        FROM @Affected A
        JOIN Testing.TracNghiem TN ON A.MaCauHoi = TN.MaCauHoi
        LEFT JOIN Testing.DapAn DA 
            ON A.MaCauHoi = DA.MaCauHoi AND DA.TinhDungSai = 1
        GROUP BY A.MaCauHoi
        HAVING SUM(CASE WHEN DA.TinhDungSai = 1 THEN 1 ELSE 0 END) = 0
    )
    BEGIN
        THROW 51001, N'Mỗi câu hỏi trắc nghiệm phải có ít nhất 1 đáp án đúng!', 1;
    END
END;
GO

CREATE TRIGGER trg_CauTraLoiChiTiet_TinhDiem
ON Testing.CauTraLoiChiTiet
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Affected TABLE (
        MaLopHoc VARCHAR(20),
        MaBaiKiemTra INT,
        MaLanThu INT,
        MaCauHoi INT,
        MaCauTraLoi INT
    );

    INSERT INTO @Affected
    SELECT DISTINCT MaLopHoc, MaBaiKiemTra, MaLanThu, MaCauHoi, MaCauTraLoi
    FROM inserted
    UNION
    SELECT DISTINCT MaLopHoc, MaBaiKiemTra, MaLanThu, MaCauHoi, MaCauTraLoi
    FROM deleted;

    UPDATE CTL
    SET CTL.Diem =
        CASE 
            WHEN CH.LoaiCauHoi = 0 THEN 
                CASE WHEN Score.TotalScore < 0 THEN 0 ELSE Score.TotalScore END
            ELSE CTL.Diem
        END
    FROM Testing.CauTraLoi CTL
    INNER JOIN @Affected A ON 
        CTL.MaLopHoc     = A.MaLopHoc AND
        CTL.MaBaiKiemTra = A.MaBaiKiemTra AND
        CTL.MaLanThu     = A.MaLanThu AND
        CTL.MaCauHoi     = A.MaCauHoi AND
        CTL.MaCauTraLoi  = A.MaCauTraLoi
    INNER JOIN Testing.CauHoi CH ON CH.MaCauHoi = CTL.MaCauHoi

    OUTER APPLY (
        SELECT COUNT(*) AS SoDung
        FROM Testing.DapAn 
        WHERE MaCauHoi = CTL.MaCauHoi 
          AND TinhDungSai = 1
    ) DapAnDung

    OUTER APPLY (
        SELECT SUM(PointValue) AS TotalScore
        FROM (
            SELECT 
                CASE 
                    WHEN DA.TinhDungSai = 1 AND CTCT.MaDapAn IS NOT NULL THEN  
                        CH.DiemToiDa * 1.0 / NULLIF(DapAnDung.SoDung, 0)

                    WHEN DA.TinhDungSai = 0 AND CTCT.MaDapAn IS NOT NULL THEN  
                        - CH.DiemToiDa * 1.0 / NULLIF(DapAnDung.SoDung, 0)

                    ELSE 0
                END AS PointValue
            FROM Testing.DapAn DA
            LEFT JOIN Testing.CauTraLoiChiTiet CTCT ON
                CTCT.MaLopHoc     = CTL.MaLopHoc AND
                CTCT.MaBaiKiemTra = CTL.MaBaiKiemTra AND
                CTCT.MaLanThu     = CTL.MaLanThu AND
                CTCT.MaCauHoi     = CTL.MaCauHoi AND
                CTCT.MaCauTraLoi  = CTL.MaCauTraLoi AND
                CTCT.MaDapAn      = DA.MaDapAn
            WHERE DA.MaCauHoi = CTL.MaCauHoi
        ) X
    ) Score;

END;
GO

CREATE TRIGGER trg_DapAn_UpdateScores
ON Testing.DapAn
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Affected TABLE (MaCauHoi INT);

    INSERT INTO @Affected (MaCauHoi)
    SELECT DISTINCT MaCauHoi FROM inserted
    UNION
    SELECT DISTINCT MaCauHoi FROM deleted;

    IF EXISTS (
        SELECT 1
        FROM @Affected A
        JOIN Testing.TracNghiem TN ON A.MaCauHoi = TN.MaCauHoi
        LEFT JOIN Testing.DapAn DA 
            ON A.MaCauHoi = DA.MaCauHoi AND DA.TinhDungSai = 1
        GROUP BY A.MaCauHoi
        HAVING SUM(CASE WHEN DA.TinhDungSai = 1 THEN 1 ELSE 0 END) = 0
    )
    BEGIN
        THROW 51001, N'Mỗi câu hỏi trắc nghiệm phải có ít nhất 1 đáp án đúng!', 1;
    END

    ;WITH AffectedCauTraLoi AS (
        SELECT DISTINCT CTL.MaLopHoc, CTL.MaBaiKiemTra, CTL.MaLanThu, CTL.MaCauHoi, CTL.MaCauTraLoi
        FROM Testing.CauTraLoi CTL
        JOIN @Affected A ON CTL.MaCauHoi = A.MaCauHoi
    )
    UPDATE CTL
    SET CTL.Diem =
        CASE 
            WHEN CH.LoaiCauHoi = 0 THEN 
                CASE WHEN Score.TotalScore < 0 THEN 0 ELSE Score.TotalScore END
            ELSE CTL.Diem
        END
    FROM Testing.CauTraLoi CTL
    JOIN AffectedCauTraLoi A ON 
        CTL.MaLopHoc     = A.MaLopHoc AND
        CTL.MaBaiKiemTra = A.MaBaiKiemTra AND
        CTL.MaLanThu     = A.MaLanThu AND
        CTL.MaCauHoi     = A.MaCauHoi AND
        CTL.MaCauTraLoi  = A.MaCauTraLoi
    JOIN Testing.CauHoi CH ON CH.MaCauHoi = CTL.MaCauHoi

    OUTER APPLY (
        SELECT COUNT(*) AS SoDung
        FROM Testing.DapAn 
        WHERE MaCauHoi = CTL.MaCauHoi 
          AND TinhDungSai = 1
    ) DapAnDung

    OUTER APPLY (
        SELECT SUM(PointValue) AS TotalScore
        FROM (
            SELECT 
                CASE 
                    WHEN DA.TinhDungSai = 1 AND CTCT.MaDapAn IS NOT NULL THEN  
                        CH.DiemToiDa * 1.0 / NULLIF(DapAnDung.SoDung, 0)

                    WHEN DA.TinhDungSai = 0 AND CTCT.MaDapAn IS NOT NULL THEN  
                        - CH.DiemToiDa * 1.0 / NULLIF(DapAnDung.SoDung, 0)

                    ELSE 0
                END AS PointValue
            FROM Testing.DapAn DA
            LEFT JOIN Testing.CauTraLoiChiTiet CTCT ON
                CTCT.MaLopHoc     = CTL.MaLopHoc AND
                CTCT.MaBaiKiemTra = CTL.MaBaiKiemTra AND
                CTCT.MaLanThu     = CTL.MaLanThu AND
                CTCT.MaCauHoi     = CTL.MaCauHoi AND
                CTCT.MaCauTraLoi  = CTL.MaCauTraLoi AND
                CTCT.MaDapAn      = DA.MaDapAn
            WHERE DA.MaCauHoi = CTL.MaCauHoi
        ) X
    ) Score;

END;
GO

CREATE TRIGGER trg_CauHoi_UpdateScores
ON Testing.CauHoi
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH AffectedQuestions AS (
        SELECT DISTINCT MaCauHoi FROM inserted
        UNION
        SELECT DISTINCT MaCauHoi FROM deleted
    )

    , AffectedCauTraLoi AS (
        SELECT DISTINCT CTL.MaLopHoc, CTL.MaBaiKiemTra, CTL.MaLanThu, CTL.MaCauHoi, CTL.MaCauTraLoi
        FROM Testing.CauTraLoi CTL
        JOIN AffectedQuestions AQ ON CTL.MaCauHoi = AQ.MaCauHoi
    )

    UPDATE CTL
    SET CTL.Diem =
        CASE 
            WHEN CH.LoaiCauHoi = 0 THEN 
                CASE WHEN Score.TotalScore < 0 THEN 0 ELSE Score.TotalScore END
            ELSE CTL.Diem
        END
    FROM Testing.CauTraLoi CTL
    JOIN AffectedCauTraLoi A ON 
        CTL.MaLopHoc     = A.MaLopHoc AND
        CTL.MaBaiKiemTra = A.MaBaiKiemTra AND
        CTL.MaLanThu     = A.MaLanThu AND
        CTL.MaCauHoi     = A.MaCauHoi AND
        CTL.MaCauTraLoi  = A.MaCauTraLoi
    JOIN Testing.CauHoi CH ON CH.MaCauHoi = CTL.MaCauHoi

    OUTER APPLY (
        SELECT COUNT(*) AS SoDung
        FROM Testing.DapAn 
        WHERE MaCauHoi = CTL.MaCauHoi 
          AND TinhDungSai = 1
    ) DapAnDung

    OUTER APPLY (
        SELECT SUM(PointValue) AS TotalScore
        FROM (
            SELECT 
                CASE 
                    WHEN DA.TinhDungSai = 1 AND CTCT.MaDapAn IS NOT NULL THEN  
                        CH.DiemToiDa * 1.0 / NULLIF(DapAnDung.SoDung, 0)

                    WHEN DA.TinhDungSai = 0 AND CTCT.MaDapAn IS NOT NULL THEN  
                        - CH.DiemToiDa * 1.0 / NULLIF(DapAnDung.SoDung, 0)

                    ELSE 0
                END AS PointValue
            FROM Testing.DapAn DA
            LEFT JOIN Testing.CauTraLoiChiTiet CTCT ON
                CTCT.MaLopHoc     = CTL.MaLopHoc AND
                CTCT.MaBaiKiemTra = CTL.MaBaiKiemTra AND
                CTCT.MaLanThu     = CTL.MaLanThu AND
                CTCT.MaCauHoi     = CTL.MaCauHoi AND
                CTCT.MaCauTraLoi  = CTL.MaCauTraLoi AND
                CTCT.MaDapAn      = DA.MaDapAn
            WHERE DA.MaCauHoi = CTL.MaCauHoi
        ) X
    ) Score;
END;
GO



ALTER TABLE Testing.LanThu ADD TongDiem FLOAT DEFAULT 0;
GO

CREATE TRIGGER trg_CauTraLoi_UpdateTongDiem
ON Testing.CauTraLoi
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy các lần thử bị ảnh hưởng
    ;WITH Affected AS (
        SELECT DISTINCT MaLopHoc, MaBaiKiemTra, MaLanThu FROM inserted
        UNION
        SELECT DISTINCT MaLopHoc, MaBaiKiemTra, MaLanThu FROM deleted
    )
    UPDATE LT
    SET TongDiem = ISNULL(CT.SumDiem, 0)
    FROM Testing.LanThu LT
    JOIN Affected A ON 
         LT.MaLopHoc = A.MaLopHoc AND 
         LT.MaBaiKiemTra = A.MaBaiKiemTra AND
         LT.MaLanThu = A.MaLanThu
    OUTER APPLY (
        SELECT SUM(Diem) AS SumDiem
        FROM Testing.CauTraLoi CT
        WHERE CT.MaLopHoc = LT.MaLopHoc 
          AND CT.MaBaiKiemTra = LT.MaBaiKiemTra
          AND CT.MaLanThu = LT.MaLanThu
    ) CT;
END;
GO


ALTER TABLE Testing.BaiKiemTra ADD TrungBinhDiem FLOAT DEFAULT 0;
GO

CREATE TRIGGER trg_LanThu_UpdateTrungBinhDiem
ON Testing.LanThu
AFTER INSERT, UPDATE
AS
BEGIN
    -- Lấy bài kiểm tra bị ảnh hưởng
    ;WITH Affected AS (
        SELECT DISTINCT MaLopHoc, MaBaiKiemTra FROM inserted
        UNION
        SELECT DISTINCT MaLopHoc, MaBaiKiemTra FROM deleted
    )
    UPDATE BKT
    SET TrungBinhDiem = ISNULL(AVGData.AvgDiem, 0)
    FROM Testing.BaiKiemTra BKT
    JOIN Affected A ON 
        BKT.MaLopHoc = A.MaLopHoc AND 
        BKT.MaBaiKiemTra = A.MaBaiKiemTra
    OUTER APPLY (
        SELECT AVG(TongDiem) AS AvgDiem
        FROM Testing.LanThu LT
        WHERE LT.MaLopHoc = BKT.MaLopHoc
          AND LT.MaBaiKiemTra = BKT.MaBaiKiemTra
    ) AVGData;
END;
GO

