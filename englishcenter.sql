CREATE DATABASE EnglishCenter;
GO
USE EnglishCenter;
GO
/*BẢNG học sinh*/
CREATE TABLE STUDENT(
	student_ID int PRIMARY KEY,
	student_name nvarchar(300) NOT NULL,
	student_dob date NOT NULL,
	student_gender tinyint NOT NULL,
	student_phoneNumber varchar(10) NOT NULL UNIQUE,
	identification varchar(12) NOT NULL UNIQUE,
);
GO

/*Kiểm tra mã định danh là số hay không(đúng trả về 1) và chiều dài nó đúng bằng 12*/
ALTER TABLE STUDENT ADD CONSTRAINT chk_studentIdentify 
CHECK (ISNUMERIC(identification) = 1 AND LEN(identification) = 12);
/*Ràng buộc kiểm tra số điện thoại là số hay không bằng TRY CAST(nếu không chuyển sang số được sẽ trả về NULL) */
ALTER TABLE STUDENT ADD  CONSTRAINT chk_studentPhoneNumber CHECK  ((TRY_CAST(student_phoneNumber AS int) IS NOT NULL));
GO
/*Bảng giáo viên*/
CREATE TABLE TEACHER(
	teacher_ID int PRIMARY KEY,
	teacher_name nvarchar(300) NOT NULL,
	teacher_dob date NOT NULL,
	gender tinyint NOT NULL,
	teacher_phoneNumber varchar(10) NOT NULL UNIQUE,
	teacher_address nvarchar(500) NOT NULL ,
	identification varchar(12) NOT NULL UNIQUE,
	email varchar(200) NOT NULL UNIQUE
);
GO
/*Tương tự như bảng học sinh */
ALTER TABLE TEACHER ADD CONSTRAINT chk_teacherIdentify CHECK ((isnumeric(identification)=(1)));
ALTER TABLE TEACHER ADD CONSTRAINT chk_teacherPhoneNumber CHECK  ((TRY_CAST(teacher_phoneNumber AS int) IS NOT NULL));
/*Bảng phòng*/
CREATE TABLE ROOM(
	room_ID int PRIMARY KEY,
	number_of_seats int NOT NULL
);
GO
/*Bảng khóa học*/
CREATE TABLE COURSE(
	course_ID varchar(10) PRIMARY KEY,
	course_name nvarchar(100) NOT NULL
);
GO
/*Bảng lớp học*/
CREATE TABLE CLASS(
	class_ID int PRIMARY KEY,
	clname nvarchar(100) NOT NULL,
	totalDay int NOT NULL,
	fee float NOT NULL,
	course_ID varchar(10) NULL,
	FOREIGN KEY(course_ID) REFERENCES COURSE (course_ID)
);
GO
/*Kiểm tra học phí lớn hơn 0*/ 
ALTER TABLE CLASS ADD CONSTRAINT chk_fee CHECK (fee>0);
/*Kiểm tra ngày học lớn hơn 0*/
ALTER TABLE CLASS ADD CONSTRAINT chk_totalDay CHECK (totalDay>0);

/*Bảng ca học*/
CREATE TABLE STUDY_SHIFT(
	shift_ID tinyint PRIMARY KEY,
	time_start time NOT NULL,
	time_end time NOT NULL
);
GO
/*Bảng nhóm học*/
CREATE TABLE STUDY_GROUP(
	group_ID int PRIMARY KEY,
	minStudent tinyint NOT NULL,
	maxStudent tinyint NOT NULL,
	dayStart date NOT NULL,
	dayEnd date NOT NULL,
	grStatus int NOT NULL,
	totalStudent tinyint NOT NULL,
	teacher_ID int NOT NULL,
	class_ID int NOT NULL,
	room_ID int NULL,
	shift_ID tinyint NULL,
	FOREIGN KEY(teacher_ID) REFERENCES TEACHER (teacher_ID),
	FOREIGN KEY(class_ID) REFERENCES CLASS (class_ID),
	FOREIGN KEY(room_ID) REFERENCES ROOM (room_ID),
	FOREIGN KEY(shift_ID) REFERENCES STUDY_SHIFT (shift_ID)
);
GO
/*Bảng danh sách lớp học*/
CREATE TABLE GROUP_LIST(
	student_ID int PRIMARY KEY,
	group_ID int NOT NULL,
	payment_state tinyint NOT NULL,
	firstScore int NULL,
	lastScore int NULL,
	FOREIGN KEY (student_ID) REFERENCES STUDENT (student_ID),
	FOREIGN KEY (group_ID) REFERENCES STUDY_GROUP(group_id)
);
GO
/*Đặt giá trị mặc định cho điểm đầu vào,ra*/
/*Đặt tình trạng thanh toán mặc định là 0*/
ALTER TABLE GROUP_LIST ADD  DEFAULT ((0)) FOR payment_state
/*Kiểm tra điểm được nhập vào có hợp lệ không*/
ALTER TABLE GROUP_LIST ADD CONSTRAINT chk_fScore CHECK(firstScore >=0 AND firstScore <=990);
ALTER TABLE GROUP_LIST ADD CONSTRAINT chk_lScore CHECK(lastScore >=0 AND lastScore <=990);
/*Bảng ngày học*/
GO
CREATE TABLE SCHOOL_DAYS(
	school_day date PRIMARY KEY,
);
GO
/*Bảng thứ trong tuần*/
CREATE TABLE WEEKDAY(
	weekday_ID tinyint PRIMARY KEY
);
GO
/*Bảng thông báo*/
CREATE TABLE NOTIFICATION(
	notification_ID int PRIMARY KEY,
	title nvarchar(max) NOT NULL,
	content nvarchar(max) NOT NULL,
	daytime_send datetime NOT NULL DEFAULT (getdate()),
	group_ID int NOT NULL,
	FOREIGN KEY(group_ID) REFERENCES STUDY_GROUP (group_ID)
);
GO
/*Bảng điểm danh sinh ra từ mối qua hệ ba ngôi: học sinh,nhóm học,ngày học*/
CREATE TABLE ATTENDANCE(
    student_ID int,
    group_ID int,
    school_day date,
    present tinyint NOT NULL,
    PRIMARY KEY (student_ID, group_ID, school_day),
    FOREIGN KEY (student_ID) REFERENCES STUDENT (student_ID),
    FOREIGN KEY (group_ID) REFERENCES STUDY_GROUP (group_ID),
    FOREIGN KEY (school_day) REFERENCES School_DAYS (school_day)
);
GO
/*Bảng sinh ra từ mối quan hệ nhiều nhiều: ngày học và nhóm học*/
CREATE TABLE STUDY_ON(
	weekday_ID tinyint,
	group_ID int,
	PRIMARY KEY (weekday_ID,group_ID),
	FOREIGN KEY (weekday_ID) REFERENCES WEEKDAY (weekday_ID),
	FOREIGN KEY (group_ID) REFERENCES STUDY_GROUP (group_ID)
);
GO
/*Bảng sinh ra từ mối quan hệ nhiều nhiều: thông báo và nhóm học*/
CREATE TABLE NOTIFY(
	notification_ID int ,
	group_ID int,
	PRIMARY KEY (notification_ID,group_ID),
	FOREIGN KEY (notification_ID) REFERENCES NOTIFICATION (notification_ID),
	FOREIGN KEY (group_ID) REFERENCES STUDY_GROUP (group_ID)
);
GO
/*Bảng sinh ra từ mối hệ nhiều nhiều: giáo viên và khóa học*/
CREATE TABLE MANAGE(
	teacher_ID int,
	course_ID varchar(10),
	PRIMARY KEY (teacher_ID,course_ID),
	FOREIGN KEY (teacher_ID) REFERENCES TEACHER (teacher_ID),
	FOREIGN KEY (course_ID) REFERENCES COURSE (course_ID)
);
GO
/*Bảng tài khoản*/
CREATE TABLE ACCOUNT(
	username VARCHAR(100),
	pass VARCHAR(100),
	permissionname NVARCHAR(250)
);
/*






*/
/*Procedure tạo học viên mới*/
GO
CREATE PROCEDURE insertStudent
	@student_name NVARCHAR(300),
	@student_dob DATE,
	@student_gender TINYINT,
	@student_phoneNumber VARCHAR(10),
	@identification VARCHAR(12)
AS
BEGIN
	DECLARE @maxID INT;
	SELECT @maxID= ISNULL(MAX(student_ID),0) + 1 FROM STUDENT;
	INSERT INTO 
	STUDENT(student_ID,student_name,student_dob,student_gender,student_phoneNumber,identification)
	VALUES(@maxID,@student_name,@student_dob,@student_gender,@student_phoneNumber,@identification);
END
GO
/*Procedure tạo giáo viên mới*/
CREATE PROCEDURE insertTeacher
	@teacher_name NVARCHAR(300),
	@teacher_dob DATE,
	@teacher_gender TINYINT,
	@teacher_phoneNumber VARCHAR(10),
	@teacher_address NVARCHAR(500),
	@identification VARCHAR(12),
	@email VARCHAR(200)
AS
BEGIN
	DECLARE @maxID INT;
	SELECT @maxID= ISNULL(MAX(teacher_ID),0) + 1 FROM TEACHER;
	INSERT INTO 
	TEACHER
	(teacher_ID,teacher_name,teacher_dob,gender,teacher_phoneNumber,teacher_address,identification,email)
	VALUES
	(@maxID,@teacher_name,@teacher_dob,@teacher_gender,@teacher_phoneNumber,@teacher_address,@identification,@email);
END
GO
/*Procedure tạo lớp mới*/
CREATE PROCEDURE insertClass
	@clname NVARCHAR(100),
	@totalDay INT,
	@fee FLOAT,
	@course_ID VARCHAR(10)
AS
BEGIN
DECLARE @maxID INT;
SELECT @maxID=ISNULL(MAX(class_ID),0) +1 FROM CLASS;
INSERT INTO CLASS(class_ID,clname,totalDay,fee,course_ID)
VALUES(@maxID,@clname,@totalDay,@fee,@course_ID);
END
GO
/*Procedure tạo nhóm học mới*/
CREATE PROCEDURE insertStudyGr
	@minstudent TINYINT,
	@maxstudent TINYINT,
	@dayStart DATE,
	@dayEnd DATE,
	@grStatus INT,
	@totalStudent TINYINT,
	@teacher_ID INT,
	@class_ID INT,
	@room_ID INT,
	@shift_ID TINYINT
AS
BEGIN
DECLARE @maxID INT;
SELECT @maxID=ISNULL(MAX(group_ID),0) +1 FROM STUDY_GROUP;
INSERT INTO STUDY_GROUP(group_ID,minStudent,maxStudent,dayStart,dayEnd,grStatus,totalStudent,teacher_ID,class_ID,room_ID,shift_ID)
VALUES(@maxID,@minstudent,@maxstudent,@dayStart,@dayEnd,@grStatus,@totalStudent,@teacher_ID,@class_ID,@room_ID,@shift_ID);
END
GO
/*Procedure tạo thông báo mới*/
CREATE PROCEDURE insertNotification
	@title NVARCHAR(MAX),
	@content NVARCHAR(MAX),
	@daytime_send DATETIME,
	@group_ID INT
AS
BEGIN
DECLARE @maxID INT;
SELECT @maxID=ISNULL(MAX(notification_ID),0) +1 FROM NOTIFICATION;
INSERT INTO NOTIFICATION(notification_ID,title,content,daytime_send,group_ID)
VALUES(@maxID,@title,@content,@daytime_send,@group_ID);
END
GO
/*Procedure tạo phòng mới*/
CREATE PROCEDURE insertRoom
	@number_of_seats INT
AS
BEGIN
DECLARE @maxID INT;
SELECT @maxID=ISNULL(MAX(room_ID),0) +1 FROM ROOM;
INSERT INTO ROOM(room_ID,number_of_seats)
VALUES(@maxID,@number_of_seats);
END

GO
/*Procedure Tìm học viên*/
CREATE PROCEDURE selectAllStudent
	@keyword NVARCHAR(300)
AS
BEGIN
	SELECT
		student_ID,
		student_name,
		CONVERT(VARCHAR,student_dob,103) AS student_dob,
		CASE
			WHEN (student_gender=1) 
				THEN N'Nam'
			ELSE
				N'Nữ'
		END AS student_gender,
		student_phoneNumber,
		identification
	FROM STUDENT
	WHERE
		CAST(student_ID AS VARCHAR) LIKE '%' + @keyword +'%' OR
		CAST(student_phoneNumber AS VARCHAR) LIKE '%' + @keyword +'%' OR
		CAST(identification AS VARCHAR) LIKE '%' +@keyword +'%' OR
		LOWER(student_name) LIKE '%' +LOWER(@keyword) +'%'
END
GO
/*Trigger kiểm tra điểm để thêm vào lớp giao tiếp phản xạ  toàn diện */
CREATE TRIGGER trg_CheckFscoreComMaster
ON GROUP_LIST
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS 
	(
        SELECT 1
        FROM inserted i
        LEFT JOIN STUDY_GROUP  ON i.group_ID = STUDY_GROUP.group_ID
        WHERE STUDY_GROUP.class_ID = 6 AND i.firstScore < 500
    )
    BEGIN
        RAISERROR ('Điểm đầu vào phải lớn hơn hoặc bằng 500 để vào được Lớp giao tiếp toàn diện ', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
/*Trigger kiểm tra điểm đầu vào Intensive*/
CREATE TRIGGER trg_CheckFscoreIntensive
ON GROUP_LIST
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS 
	(
        SELECT 1
        FROM inserted i
        LEFT JOIN STUDY_GROUP  ON i.group_ID = STUDY_GROUP.group_ID
        WHERE STUDY_GROUP.class_ID = 2 AND i.firstScore < 400
    )
    BEGIN
        RAISERROR ('Điểm đầu vào phải lớn hơn hoặc bằng 400 để vào được Lớp Toeic Intensive', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
/*Trigger kiểm tra điểm đầu vào của Lớp luyện đề */
CREATE TRIGGER trg_CheckFscorePractice
ON GROUP_LIST
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS 
	(
        SELECT 1
        FROM inserted i
			LEFT JOIN STUDY_GROUP  ON i.group_ID = STUDY_GROUP.group_ID
        WHERE STUDY_GROUP.class_ID = 3 AND i.firstScore < 500
    )
    BEGIN
        RAISERROR ('Điểm đầu vào phải lớn hơn hoặc bằng 500 để vào được Lớp Toeic luyện đề', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO






	


