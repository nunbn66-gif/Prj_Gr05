/*
    DATABASE: Prj_Gr05
    PROJECT: Web tao CV ca nhan - De 1
    PLATFORM: Microsoft SQL Server

    Cac bang:
      1. SinhVien  : Thong tin ca nhan cua sinh vien
      2. HoSoCV    : Ho so CV, mau CV dang chon va trang thai ban nhap
      3. HocVan    : Cac muc hoc van thuoc mot ho so CV
      4. KyNang    : Cac ky nang thuoc mot ho so CV
      5. DuAn      : Cac du an thuoc mot ho so CV

    MaMauCV duoc luu trong HoSoCV. Hai ma mau duoc de xuat:
      - Template1
      - Template2
    Hai mau co the duoc dinh nghia trong source code, khong can bang MauCV rieng.

    Script co the chay lai: cac bang da ton tai se khong bi xoa,
    du lieu mau se khong bi chen trung neu chay lai script.
*/

/* 1. Tao database neu chua ton tai */
IF DB_ID(N'Prj_Gr05') IS NULL
BEGIN
    CREATE DATABASE Prj_Gr05;
END
GO

USE Prj_Gr05;
GO

/* 2. Bang SinhVien */
IF OBJECT_ID(N'dbo.SinhVien', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.SinhVien
    (
        MaSV          INT IDENTITY(1,1) NOT NULL,
        HoTen         NVARCHAR(100) NOT NULL,
        Email         NVARCHAR(254) NOT NULL,
        SoDienThoai   VARCHAR(20) NULL,
        GioiThieu     NVARCHAR(1000) NULL,
        NgayTao       DATETIME2(0) NOT NULL
            CONSTRAINT DF_SinhVien_NgayTao DEFAULT (SYSDATETIME()),

        CONSTRAINT PK_SinhVien PRIMARY KEY (MaSV)
    );
END
GO

/* 3. Bang HoSoCV */
IF OBJECT_ID(N'dbo.HoSoCV', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.HoSoCV
    (
        MaHoSoCV     INT IDENTITY(1,1) NOT NULL,
        MaSV         INT NOT NULL,
        TenCV        NVARCHAR(150) NOT NULL,
        MaMauCV      VARCHAR(30) NOT NULL
            CONSTRAINT DF_HoSoCV_MaMauCV DEFAULT ('Template1'),
        TrangThai    BIT NOT NULL
            CONSTRAINT DF_HoSoCV_TrangThai DEFAULT (1), -- 1: dang hoat dong/ban nhap, 0: ngung hoat dong
        NgayTao      DATETIME2(0) NOT NULL
            CONSTRAINT DF_HoSoCV_NgayTao DEFAULT (SYSDATETIME()),
        NgayCapNhat  DATETIME2(0) NULL,

        CONSTRAINT PK_HoSoCV PRIMARY KEY (MaHoSoCV),
        CONSTRAINT FK_HoSoCV_SinhVien FOREIGN KEY (MaSV)
            REFERENCES dbo.SinhVien(MaSV)
            ON DELETE CASCADE
    );

    CREATE INDEX IX_HoSoCV_MaSV ON dbo.HoSoCV(MaSV);
END
GO

/* 4. Bang HocVan */
IF OBJECT_ID(N'dbo.HocVan', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.HocVan
    (
        MaHocVan      INT IDENTITY(1,1) NOT NULL,
        MaHoSoCV      INT NOT NULL,
        TenTruong     NVARCHAR(200) NOT NULL,
        ChuyenNganh   NVARCHAR(150) NULL,
        BangCap       NVARCHAR(100) NULL,
        NgayBatDau    DATE NULL,
        NgayKetThuc   DATE NULL,
        MoTa          NVARCHAR(500) NULL,
        ThuTu         INT NOT NULL
            CONSTRAINT DF_HocVan_ThuTu DEFAULT (0),

        CONSTRAINT PK_HocVan PRIMARY KEY (MaHocVan),
        CONSTRAINT FK_HocVan_HoSoCV FOREIGN KEY (MaHoSoCV)
            REFERENCES dbo.HoSoCV(MaHoSoCV)
            ON DELETE CASCADE,
        CONSTRAINT CK_HocVan_Ngay
            CHECK (NgayBatDau IS NULL OR NgayKetThuc IS NULL OR NgayKetThuc >= NgayBatDau)
    );

    CREATE INDEX IX_HocVan_MaHoSoCV ON dbo.HocVan(MaHoSoCV);
END
GO

/* 5. Bang KyNang */
IF OBJECT_ID(N'dbo.KyNang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.KyNang
    (
        MaKyNang    INT IDENTITY(1,1) NOT NULL,
        MaHoSoCV    INT NOT NULL,
        TenKyNang   NVARCHAR(100) NOT NULL,
        MucDo       NVARCHAR(50) NULL,
        MoTa        NVARCHAR(300) NULL,
        ThuTu       INT NOT NULL
            CONSTRAINT DF_KyNang_ThuTu DEFAULT (0),

        CONSTRAINT PK_KyNang PRIMARY KEY (MaKyNang),
        CONSTRAINT FK_KyNang_HoSoCV FOREIGN KEY (MaHoSoCV)
            REFERENCES dbo.HoSoCV(MaHoSoCV)
            ON DELETE CASCADE
    );

    CREATE INDEX IX_KyNang_MaHoSoCV ON dbo.KyNang(MaHoSoCV);
END
GO

/* 6. Bang DuAn */
IF OBJECT_ID(N'dbo.DuAn', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DuAn
    (
        MaDuAn       INT IDENTITY(1,1) NOT NULL,
        MaHoSoCV     INT NOT NULL,
        TenDuAn      NVARCHAR(200) NOT NULL,
        MoTa         NVARCHAR(1000) NULL,
        CongNghe     NVARCHAR(300) NULL,
        VaiTro       NVARCHAR(150) NULL,
        LienKet      NVARCHAR(500) NULL,
        NgayBatDau   DATE NULL,
        NgayKetThuc  DATE NULL,
        ThuTu        INT NOT NULL
            CONSTRAINT DF_DuAn_ThuTu DEFAULT (0),

        CONSTRAINT PK_DuAn PRIMARY KEY (MaDuAn),
        CONSTRAINT FK_DuAn_HoSoCV FOREIGN KEY (MaHoSoCV)
            REFERENCES dbo.HoSoCV(MaHoSoCV)
            ON DELETE CASCADE,
        CONSTRAINT CK_DuAn_Ngay
            CHECK (NgayBatDau IS NULL OR NgayKetThuc IS NULL OR NgayKetThuc >= NgayBatDau)
    );

    CREATE INDEX IX_DuAn_MaHoSoCV ON dbo.DuAn(MaHoSoCV);
END
GO

/* 7. Them du lieu mau (khong chen trung khi chay lai) */
DECLARE @MaSV INT;
DECLARE @MaHoSoCV INT;

/* Sinh vien mau */
SELECT @MaSV = MaSV
FROM dbo.SinhVien
WHERE Email = N'cv.demo@example.com';

IF @MaSV IS NULL
BEGIN
    INSERT INTO dbo.SinhVien (HoTen, Email, SoDienThoai, GioiThieu)
    VALUES
    (
        N'Nguyễn Văn A',
        N'cv.demo@example.com',
        '0987654321',
        N'Sinh vien Cong nghe thong tin, co kien thuc ve lap trinh C# va co so du lieu SQL Server. Mong muon tim kiem co hoi thuc tap de phat trien ky nang.'
    );

    SET @MaSV = CONVERT(INT, SCOPE_IDENTITY());
END;

/* Ho so CV mau */
SELECT @MaHoSoCV = MaHoSoCV
FROM dbo.HoSoCV
WHERE MaSV = @MaSV AND TenCV = N'CV mẫu - Nguyễn Văn A';

IF @MaHoSoCV IS NULL
BEGIN
    INSERT INTO dbo.HoSoCV (MaSV, TenCV, MaMauCV, TrangThai)
    VALUES (@MaSV, N'CV mẫu - Nguyễn Văn A', 'Template1', 1);

    SET @MaHoSoCV = CONVERT(INT, SCOPE_IDENTITY());
END;

/* Hoc van mau */
IF NOT EXISTS
(
    SELECT 1 FROM dbo.HocVan
    WHERE MaHoSoCV = @MaHoSoCV
      AND TenTruong = N'Đại học Nguyễn Trãi'
      AND ChuyenNganh = N'Công nghệ thông tin'
)
BEGIN
    INSERT INTO dbo.HocVan
        (MaHoSoCV, TenTruong, ChuyenNganh, BangCap, NgayBatDau, NgayKetThuc, MoTa, ThuTu)
    VALUES
        (@MaHoSoCV, N'Đại học Nguyễn Trãi', N'Công nghệ thông tin', N'Đại học',
         '2023-09-05', NULL, N'Đang theo học chuyên ngành Công nghệ thông tin.', 1);
END;

/* Ky nang mau */
IF NOT EXISTS (SELECT 1 FROM dbo.KyNang WHERE MaHoSoCV = @MaHoSoCV AND TenKyNang = N'C#')
BEGIN
    INSERT INTO dbo.KyNang (MaHoSoCV, TenKyNang, MucDo, MoTa, ThuTu)
    VALUES (@MaHoSoCV, N'C#', N'Khá', N'Lập trình hướng đối tượng và ASP.NET Core MVC.', 1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.KyNang WHERE MaHoSoCV = @MaHoSoCV AND TenKyNang = N'SQL Server')
BEGIN
    INSERT INTO dbo.KyNang (MaHoSoCV, TenKyNang, MucDo, MoTa, ThuTu)
    VALUES (@MaHoSoCV, N'SQL Server', N'Khá', N'Thiết kế bảng, khóa và truy vấn dữ liệu.', 2);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.KyNang WHERE MaHoSoCV = @MaHoSoCV AND TenKyNang = N'HTML/CSS')
BEGIN
    INSERT INTO dbo.KyNang (MaHoSoCV, TenKyNang, MucDo, MoTa, ThuTu)
    VALUES (@MaHoSoCV, N'HTML/CSS', N'Trung bình', N'Xây dựng giao diện web cơ bản.', 3);
END;

/* Du an mau 1 */
IF NOT EXISTS (SELECT 1 FROM dbo.DuAn WHERE MaHoSoCV = @MaHoSoCV AND TenDuAn = N'Website bán hàng')
BEGIN
    INSERT INTO dbo.DuAn
        (MaHoSoCV, TenDuAn, MoTa, CongNghe, VaiTro, LienKet, NgayBatDau, NgayKetThuc, ThuTu)
    VALUES
        (@MaHoSoCV, N'Website bán hàng',
         N'Xây dựng website bán hàng với các chức năng xem sản phẩm, quản lý giỏ hàng và đặt hàng.',
         N'PHP, MySQL, HTML, CSS', N'Backend Developer', NULL,
         '2025-03-01', '2025-05-30', 1);
END;

/* Du an mau 2 */
IF NOT EXISTS (SELECT 1 FROM dbo.DuAn WHERE MaHoSoCV = @MaHoSoCV AND TenDuAn = N'Quản lý sinh viên')
BEGIN
    INSERT INTO dbo.DuAn
        (MaHoSoCV, TenDuAn, MoTa, CongNghe, VaiTro, LienKet, NgayBatDau, NgayKetThuc, ThuTu)
    VALUES
        (@MaHoSoCV, N'Quản lý sinh viên',
         N'Xây dựng ứng dụng quản lý thông tin sinh viên, lớp học và kết quả học tập.',
         N'C#, SQL Server, ASP.NET Core MVC', N'Developer', NULL,
         '2025-06-01', '2025-08-15', 2);
END;
GO

/* 8. Truy van kiem tra du lieu mau */
SELECT
    sv.MaSV,
    sv.HoTen,
    sv.Email,
    cv.MaHoSoCV,
    cv.TenCV,
    cv.MaMauCV,
    cv.TrangThai
FROM dbo.SinhVien AS sv
INNER JOIN dbo.HoSoCV AS cv ON cv.MaSV = sv.MaSV
WHERE sv.Email = N'cv.demo@example.com';

SELECT * FROM dbo.HocVan WHERE MaHoSoCV IN
(
    SELECT MaHoSoCV FROM dbo.HoSoCV
    WHERE TenCV = N'CV mẫu - Nguyễn Văn A'
);

SELECT * FROM dbo.KyNang WHERE MaHoSoCV IN
(
    SELECT MaHoSoCV FROM dbo.HoSoCV
    WHERE TenCV = N'CV mẫu - Nguyễn Văn A'
);

SELECT * FROM dbo.DuAn WHERE MaHoSoCV IN
(
    SELECT MaHoSoCV FROM dbo.HoSoCV
    WHERE TenCV = N'CV mẫu - Nguyễn Văn A'
)
ORDER BY ThuTu;
GO
