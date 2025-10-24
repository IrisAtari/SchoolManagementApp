-- 1) Tạo database
IF EXISTS(SELECT * FROM sys.databases WHERE name = N'SchoolManagementDB')
BEGIN
    PRINT 'Database already exists. Skipping create.'
END
ELSE
BEGIN
    CREATE DATABASE SchoolManagementDB;
    PRINT 'Database created: SchoolManagementDB';
END
GO

USE SchoolManagementDB;
GO

-- 2) Schema: tables

-- Roles / Users
IF OBJECT_ID('dbo.Roles','U') IS NOT NULL DROP TABLE dbo.Roles;
IF OBJECT_ID('dbo.Users','U') IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID('dbo.UserRoles','U') IS NOT NULL DROP TABLE dbo.UserRoles;

CREATE TABLE dbo.Roles
(
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(500) NULL
);

CREATE TABLE dbo.Users
(
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(200) NOT NULL,    -- lưu hash (không lưu plaintext)
    DisplayName NVARCHAR(200) NULL,
    Email NVARCHAR(200) NULL,
    IsActive BIT NOT NULL DEFAULT(1),
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.UserRoles
(
    UserRoleId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    RoleId INT NOT NULL,
    AssignedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_UserRoles_User FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId) ON DELETE CASCADE,
    CONSTRAINT FK_UserRoles_Role FOREIGN KEY (RoleId) REFERENCES dbo.Roles(RoleId) ON DELETE CASCADE
);

-- Lecture halls
IF OBJECT_ID('dbo.LectureHalls','U') IS NOT NULL DROP TABLE dbo.LectureHalls;
CREATE TABLE dbo.LectureHalls
(
    LectureHallId INT IDENTITY(1,1) PRIMARY KEY,
    Code NVARCHAR(50) NOT NULL UNIQUE,
    Name NVARCHAR(200) NOT NULL,
    Capacity INT NULL,
    Status NVARCHAR(50) NULL,  -- e.g. 'Trống', 'Đang sử dụng', 'Bảo trì'
    Note NVARCHAR(1000) NULL
);

-- Devices
IF OBJECT_ID('dbo.Devices','U') IS NOT NULL DROP TABLE dbo.Devices;
CREATE TABLE dbo.Devices
(
    DeviceId INT IDENTITY(1,1) PRIMARY KEY,
    DeviceCode NVARCHAR(50) NOT NULL UNIQUE,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000) NULL,
    Type NVARCHAR(100) NULL,
    Status NVARCHAR(50) NULL,  -- 'Hoạt động','Bảo trì','Hỏng','Kho'
    Location NVARCHAR(200) NULL, -- có thể là LectureHall.Code hoặc chữ khác
    LectureHallId INT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Devices_LectureHall FOREIGN KEY (LectureHallId) REFERENCES dbo.LectureHalls(LectureHallId) ON DELETE SET NULL
);

-- Bookings (Đặt phòng / sự kiện)
IF OBJECT_ID('dbo.Bookings','U') IS NOT NULL DROP TABLE dbo.Bookings;
CREATE TABLE dbo.Bookings
(
    BookingId INT IDENTITY(1,1) PRIMARY KEY,
    LectureHallId INT NOT NULL,
    RequestedByUserId INT NOT NULL,
    Title NVARCHAR(300) NULL,
    StartAt DATETIME2 NOT NULL,
    EndAt DATETIME2 NOT NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Pending', -- Pending, Approved, Rejected, Cancelled
    Notes NVARCHAR(1000) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Bookings_LectureHall FOREIGN KEY (LectureHallId) REFERENCES dbo.LectureHalls(LectureHallId) ON DELETE CASCADE,
    CONSTRAINT FK_Bookings_User FOREIGN KEY (RequestedByUserId) REFERENCES dbo.Users(UserId) ON DELETE SET NULL
);

-- Equipment Reports (Báo hỏng thiết bị)
IF OBJECT_ID('dbo.EquipmentReports','U') IS NOT NULL DROP TABLE dbo.EquipmentReports;
CREATE TABLE dbo.EquipmentReports
(
    ReportId INT IDENTITY(1,1) PRIMARY KEY,
    DeviceId INT NULL,
    ReportedByUserId INT NULL,
    ReportDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Description NVARCHAR(2000) NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Open', -- Open, InProgress, Resolved, Closed
    CONSTRAINT FK_Reports_Device FOREIGN KEY (DeviceId) REFERENCES dbo.Devices(DeviceId) ON DELETE SET NULL,
    CONSTRAINT FK_Reports_User FOREIGN KEY (ReportedByUserId) REFERENCES dbo.Users(UserId) ON DELETE SET NULL
);

-- 3) Indexes: thêm index cho cột hay tìm kiếm
CREATE INDEX IX_Devices_Status ON dbo.Devices(Status);
CREATE INDEX IX_Devices_DeviceCode ON dbo.Devices(DeviceCode);
CREATE INDEX IX_LectureHalls_Code ON dbo.LectureHalls(Code);
CREATE INDEX IX_Bookings_Status ON dbo.Bookings(Status);
CREATE INDEX IX_EquipmentReports_Status ON dbo.EquipmentReports(Status);

-- 4) Seed một vài dữ liệu mẫu
INSERT INTO dbo.Roles (RoleName, Description) VALUES
(N'Admin', N'Quản trị hệ thống'),
(N'GiảngVien', N'Giảng viên'),
(N'SinhVien', N'Sinh viên');

INSERT INTO dbo.Users (Username, PasswordHash, DisplayName, Email)
VALUES
('admin', 'HASHED_PASSWORD_PLACEHOLDER', 'Administrator', 'admin@local'),
('gv01', 'HASHED_PASSWORD_PLACEHOLDER', 'Nguyễn Văn A', 'gv01@local'),
('sv01', 'HASHED_PASSWORD_PLACEHOLDER', 'Sinh viên B', 'sv01@local');

-- gán role admin cho user admin (UserId 1)
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (1, 1);

INSERT INTO dbo.LectureHalls (Code, Name, Capacity, Status)
VALUES
('A101','Phòng học lớn A101',120,'Trống'),
('B202','Phòng máy B202',60,'Đang sử dụng'),
('C303','Phòng lab C303',40,'Bảo trì');

INSERT INTO dbo.Devices (DeviceCode, Name, Description, Type, Status, Location, LectureHallId)
VALUES
('D-002','Máy tính PC-01','Ổ cứng 500GB','Máy tính','Hoạt động','P203', 2),
('D-010','Router Cisco R1','Firmware cũ','Router','Bảo trì','Server Room', NULL),
('D-011','Bảng tương tác','Màn hình vỡ','Thiết bị trình chiếu','Hỏng','P102', 3);

-- 5) Stored procedures cơ bản xuất CSV / lấy filter / thêm sửa xóa thiết bị

-- Lấy devices với filter (status + search keyword)
IF OBJECT_ID('dbo.usp_GetDevices','P') IS NOT NULL DROP PROCEDURE dbo.usp_GetDevices;
GO
CREATE PROCEDURE dbo.usp_GetDevices
    @Status NVARCHAR(50) = NULL,
    @Keyword NVARCHAR(400) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DeviceId, DeviceCode, Name, Description, Type, Status, Location, LectureHallId, CreatedAt
    FROM dbo.Devices
    WHERE (@Status IS NULL OR @Status = '' OR @Status = 'Tất cả' OR Status = @Status)
      AND (
            @Keyword IS NULL OR @Keyword = ''
            OR DeviceCode LIKE '%' + @Keyword + '%'
            OR Name LIKE '%' + @Keyword + '%'
            OR Type LIKE '%' + @Keyword + '%'
            OR Description LIKE '%' + @Keyword + '%'
          )
    ORDER BY CreatedAt DESC;
END
GO

-- Thêm thiết bị
IF OBJECT_ID('dbo.usp_AddDevice','P') IS NOT NULL DROP PROCEDURE dbo.usp_AddDevice;
GO
CREATE PROCEDURE dbo.usp_AddDevice
    @DeviceCode NVARCHAR(50),
    @Name NVARCHAR(200),
    @Description NVARCHAR(1000) = NULL,
    @Type NVARCHAR(100) = NULL,
    @Status NVARCHAR(50) = NULL,
    @Location NVARCHAR(200) = NULL,
    @LectureHallId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Devices (DeviceCode, Name, Description, Type, Status, Location, LectureHallId)
    VALUES (@DeviceCode, @Name, @Description, @Type, @Status, @Location, @LectureHallId);

    SELECT SCOPE_IDENTITY() AS NewDeviceId;
END
GO

-- Update device
IF OBJECT_ID('dbo.usp_UpdateDevice','P') IS NOT NULL DROP PROCEDURE dbo.usp_UpdateDevice;
GO
CREATE PROCEDURE dbo.usp_UpdateDevice
    @DeviceId INT,
    @DeviceCode NVARCHAR(50),
    @Name NVARCHAR(200),
    @Description NVARCHAR(1000) = NULL,
    @Type NVARCHAR(100) = NULL,
    @Status NVARCHAR(50) = NULL,
    @Location NVARCHAR(200) = NULL,
    @LectureHallId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Devices
    SET DeviceCode = @DeviceCode,
        Name = @Name,
        Description = @Description,
        Type = @Type,
        Status = @Status,
        Location = @Location,
        LectureHallId = @LectureHallId
    WHERE DeviceId = @DeviceId;
END
GO

-- Delete device
IF OBJECT_ID('dbo.usp_DeleteDevice','P') IS NOT NULL DROP PROCEDURE dbo.usp_DeleteDevice;
GO
CREATE PROCEDURE dbo.usp_DeleteDevice
    @DeviceId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Devices WHERE DeviceId = @DeviceId;
END
GO

-- 6) View: show rooms with count of devices
IF OBJECT_ID('dbo.vw_LectureHallSummary','V') IS NOT NULL DROP VIEW dbo.vw_LectureHallSummary;
GO
CREATE VIEW dbo.vw_LectureHallSummary
AS
SELECT lh.LectureHallId, lh.Code, lh.Name, lh.Capacity, lh.Status,
       COUNT(d.DeviceId) AS DeviceCount
FROM dbo.LectureHalls lh
LEFT JOIN dbo.Devices d ON d.LectureHallId = lh.LectureHallId
GROUP BY lh.LectureHallId, lh.Code, lh.Name, lh.Capacity, lh.Status;
GO

-- Done
PRINT 'Schema + seed + procs created';
GO
