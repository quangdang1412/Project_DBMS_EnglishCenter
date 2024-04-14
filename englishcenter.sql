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
ALTER TABLE STUDENT ADD CONSTRAINT chk_studentPhoneNumber 
CHECK (LEN(student_phoneNumber) = 10 AND student_phoneNumber NOT LIKE '%[^0-9]%');
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
ALTER TABLE TEACHER ADD CONSTRAINT chk_teacherPhoneNumber CHECK (LEN(teacher_phoneNumber) = 10 AND teacher_phoneNumber NOT LIKE '%[^0-9]%');
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
	minStudent INT NOT NULL,
	maxStudent INT NOT NULL,
	dayStart date NOT NULL,
	dayEnd date NOT NULL,
	grStatus int NOT NULL,
	totalStudent INT NOT NULL,
	teacher_ID int NOT NULL,
	class_ID int NOT NULL,
	room_ID int NULL,
	shift_ID tinyint NULL,
	FOREIGN KEY(teacher_ID) REFERENCES TEACHER (teacher_ID),
	FOREIGN KEY(class_ID) REFERENCES CLASS (class_ID),
	FOREIGN KEY(room_ID) REFERENCES ROOM (room_ID),
	FOREIGN KEY(shift_ID) REFERENCES STUDY_SHIFT (shift_ID)
);
ALTER TABLE STUDY_GROUP ADD DEFAULT ((0)) FOR totalStudent
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
/*Đặt giá trị mặc định cho điểm đầu ra*/
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
/*Procedure cập nhật thông tin học viên*/
CREATE PROCEDURE updateStudent
	@student_ID INT,
	@student_name NVARCHAR(300),
	@student_dob DATE,
	@student_gender TINYINT,
	@student_phoneNumber VARCHAR(10),
	@identification VARCHAR(12)
AS
BEGIN
	UPDATE STUDENT
	SET
		student_name=@student_name,
		student_dob=@student_dob,
		student_gender=@student_gender,
		student_phoneNumber=@student_phoneNumber,
		identification=@identification
	WHERE student_ID=@student_ID
END
GO
/*Xóa học sinh dựa trên ID*/
CREATE PROCEDURE deleteStudent
	@student_ID INT
AS
BEGIN
	DELETE FROM STUDENT WHERE student_ID=@student_ID
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
/*Procedure cập nhật thông tin giáo viên*/
CREATE PROCEDURE updateTeacher
	@teacher_ID INT,
	@teacher_name NVARCHAR(300),
	@teacher_dob DATE,
	@teacher_gender TINYINT,
	@teacher_phoneNumber VARCHAR(10),
	@teacher_address NVARCHAR(500),
	@identification VARCHAR(12),
	@email VARCHAR(200)
AS
BEGIN
	UPDATE TEACHER
	SET
		teacher_name=@teacher_name,
		teacher_dob=@teacher_dob,
		gender=@teacher_gender,
		teacher_phoneNumber=@teacher_phoneNumber,
		teacher_address=@teacher_address,
		identification=@identification,
		email=@email
	WHERE teacher_ID=@teacher_ID
END
GO
/*Procedure xóa giáo viên dựa trên ID*/
CREATE PROCEDURE deleteTeacher
	@teacher_ID INT
AS
	BEGIN
		DELETE FROM TEACHER WHERE teacher_ID=@teacher_ID
	END
GO
/*Procedure tạo khóa học mới*/
CREATE PROCEDURE insertCourse
	@courseID VARCHAR(10),
	@course_name NVARCHAR(100)
AS
	BEGIN
		INSERT INTO COURSE(course_ID,course_name)
		VALUES(@courseID,@course_name)
	END
GO
/*Procedure cập nhật thông tin khóa học*/
CREATE PROCEDURE updateCourse
	@courseID VARCHAR(10),
	@course_name NVARCHAR(100)
AS
BEGIN
	UPDATE COURSE
	SET
		course_name = @course_name
	WHERE course_ID = @courseID
END
GO
/*Xóa khóa dựa trên ID*/
CREATE PROCEDURE deleteCourse
	@courseID VARCHAR(10)
AS
BEGIN
	DELETE FROM COURSE WHERE course_ID=@courseID
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

/*Procedure cập nhật thông tin lớp học*/
CREATE PROCEDURE updateClass
	@classID INT,
	@clname NVARCHAR(100),
	@totalDay INT,
	@fee FLOAT,
	@course_ID VARCHAR(10)
AS
BEGIN
	UPDATE CLASS
	SET
		clname = @clname,
		totalDay = @totalDay,
		fee = @fee,
		course_ID = @course_ID
	WHERE class_ID = @classID
END
GO
/*Xóa lớp dựa trên ID*/
CREATE PROCEDURE deleteClass
	@class_ID INT
AS
BEGIN
	DELETE FROM CLASS WHERE class_ID=@class_ID
END
GO
/*Tìm kiếm class dựa trên courseID*/
CREATE PROCEDURE selectClassByCourse
	@courseID VARCHAR(10)
AS
BEGIN
	SELECT
		class_ID,
		clname,
		totalDay,
		fee
	FROM CLASS
	WHERE course_ID=@courseID
END
GO
/*Procedure tạo nhóm học mới*/
CREATE PROCEDURE insertStudyGr
	@minstudent INT,
	@maxstudent INT,
	@dayStart DATE,
	@dayEnd DATE,
	@grStatus INT, -- -1 là đang mở để đăng kí,0 là lớp đang mở và đang còn học, 1 là lớp đã học xong
	@teacher_ID INT,
	@class_ID INT,
	@room_ID INT,
	@shift_ID TINYINT
AS
BEGIN
DECLARE @maxID INT;
SELECT @maxID=ISNULL(MAX(group_ID),0) +1 FROM STUDY_GROUP;
INSERT INTO STUDY_GROUP(group_ID,minStudent,maxStudent,dayStart,dayEnd,grStatus,teacher_ID,class_ID,room_ID,shift_ID)
VALUES(@maxID,@minstudent,@maxstudent,@dayStart,@dayEnd,@grStatus,@teacher_ID,@class_ID,@room_ID,@shift_ID);
END
GO
/*Procedure cập nhật nhóm học*/
CREATE PROCEDURE updateStudyGr
	@groupID INT,
	@minstudent INT,
	@maxstudent INT,
	@dayStart DATE,
	@dayEnd DATE,
	@grStatus INT, -- -1 là đang mở để đăng kí,0 là lớp đang mở và đang còn học, 1 là lớp đã học xong
	@teacher_ID INT,
	@class_ID INT,
	@room_ID INT,
	@shift_ID TINYINT
AS
BEGIN
	UPDATE STUDY_GROUP
	SET
		group_ID = @groupID,
		minStudent = @minstudent,
		maxStudent = @maxstudent,
		dayStart = @dayStart,
		dayEnd = @dayEnd,
		grStatus = @grStatus,
		teacher_ID = @teacher_ID,
		class_ID = @class_ID,
		room_ID = @room_ID,
		shift_ID = @shift_ID
END
GO
/*Xóa nhóm học dựa trên ID*/
CREATE PROCEDURE deleteStudyGr
	@group_ID INT
AS
BEGIN
	DELETE FROM STUDY_GROUP WHERE group_ID=@group_ID
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
END;
GO
/*Procedure thêm học sinh mới vào nhóm học*/
CREATE PROCEDURE insertGroupList
	@student_ID INT,
	@group_ID INT,
	@paymenstate TINYINT,
	@firstScore INT
AS
BEGIN
	INSERT INTO GROUP_LIST(student_ID,group_ID,payment_state,firstScore)
	VALUES(@student_ID,@group_ID,@paymenstate,@firstScore)
END;
GO
/*Procedure cập nhật thông tin lớp học*/
CREATE PROCEDURE updateGroupList
	@student_ID INT,
	@group_ID INT,
	@paymenstate TINYINT,
	@firstScore INT
AS
BEGIN
	UPDATE GROUP_LIST
	SET
		student_ID = @student_ID,
		group_ID = @group_ID,
		payment_state = @paymenstate,
		firstScore = @firstScore
END;
GO
/*Procedure nhập điểm cho học sinh*/
CREATE PROCEDURE updateLastScore
	@student_ID INT,
	@group_ID INT,
	@lastScore INT
AS
BEGIN
	UPDATE GROUP_LIST
	SET 
		lastScore=@lastScore
	WHERE student_ID=@student_ID AND group_ID=@group_ID
END
GO
/*Procedure Tìm học viên dựa trên từ khóa*/
CREATE PROCEDURE selectAllStudent
	@keyword NVARCHAR(300)
AS
BEGIN
	SELECT
		student_ID,
		student_name,
		student_dob,
		student_gender,
		student_phoneNumber
	FROM STUDENT
	WHERE
		student_phoneNumber LIKE '%' + @keyword +'%' OR
		LOWER(student_name) LIKE '%' +LOWER(@keyword) +'%'
END
GO
/*Procedure tìm giáo viên dựa trên từ khóa*/
CREATE PROCEDURE selectAllTeacher
	@keyword NVARCHAR(300)
AS
BEGIN
	SELECT
		teacher_ID,
		teacher_name,
		gender,
		teacher_phoneNumber,
		email
	FROM TEACHER
	WHERE
		teacher_phoneNumber LIKE '%' + @keyword +'%' OR
		LOWER(teacher_name) LIKE '%' +LOWER(@keyword) +'%' OR
		LOWER(email) LIKE '%' +LOWER(@keyword)+ '%' 
END
GO
/*Trigger kiểm tra điểm để thêm vào lớp giao tiếp phản xạ toàn diện */
CREATE TRIGGER trg_CheckFscore
ON GROUP_LIST
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS 
	(
        SELECT 1
        FROM inserted i WHERE i.group_ID IN 
			(SELECT group_ID
				FROM STUDY_GROUP
				WHERE class_ID = 6 ) AND i.firstScore < 500
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
        FROM inserted i WHERE i.group_ID  IN 
			(SELECT group_ID
				FROM STUDY_GROUP
				WHERE class_ID = 2) AND i.firstScore<400
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
        FROM inserted i WHERE i.group_ID IN 
			(SELECT group_ID FROM STUDY_GROUP WHERE class_ID=3) AND i.firstScore < 500
    )
    BEGIN
        RAISERROR ('Điểm đầu vào phải lớn hơn hoặc bằng 500 để vào được Lớp Toeic luyện đề', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
/*Trigger Đếm số lượng học sinh của một lớp*/
CREATE TRIGGER trg_TotalStudent
ON GROUP_LIST
AFTER INSERT,DELETE, UPDATE
AS
BEGIN
	DECLARE @count INT;
	DECLARE @groupID INT;
	IF EXISTS (SELECT * FROM inserted)
	BEGIN 
		SELECT @groupID=group_ID FROM inserted;
	END
	ELSE IF EXISTS (SELECT * FROM deleted)
	BEGIN
		SELECT @groupID=group_ID FROM deleted ;
	END
	SELECT @count=COUNT(*) FROM GROUP_LIST WHERE @groupID=group_ID ;
	UPDATE STUDY_GROUP
	SET
		totalStudent=@count
	WHERE @groupID=group_ID;
END
GO
/*Trigger kiểm tra số lượng học sinh đã vượt mức tối đa chưa*/
CREATE TRIGGER chkTotalStudent
ON GROUP_LIST
AFTER INSERT,UPDATE
AS
	BEGIN
	DECLARE @group_ID INT;
	SELECT @group_ID=group_ID FROM inserted;
	DECLARE @total INT;
	SELECT @total=totalStudent FROM STUDY_GROUP WHERE group_ID=@group_ID;
	DECLARE @max INT;
	SELECT @max=maxStudent FROM STUDY_GROUP WHERE group_ID=@group_ID;
	IF(@total>@max)
	BEGIN
		RAISERROR ('Số lượng học sinh đã vượt mức tối đa không thể thêm vào nữa', 16, 1);
		ROLLBACK TRANSACTION;
	END
END;
GO
/*Trigger kiểm tra xem học viên đó còn học không trước khi xóa*/
CREATE TRIGGER chkStudentStatus
ON GROUP_LIST
AFTER DELETE
AS
	BEGIN
	DECLARE @groupID INT;
	IF EXISTS(SELECT * FROM deleted)
	BEGIN
		SELECT @groupID=group_ID FROM deleted;
	END
	IF EXISTS(SELECT grStatus FROM STUDY_GROUP WHERE group_ID=@groupID)
	BEGIN
		RAISERROR ('Học sinh này vẫn còn đang học ở nhóm %d, không thể xóa',16,1,@groupID);
		ROLLBACK TRANSACTION;
	END
END;
GO

/* Đổ dữ liệu */
USE EnglishCenter
GO
/*Thêm học sinh*/
EXEC insertStudent N'Bùi Văn Đức', '2005-01-25', 1, '0369852745', '080604013660';
EXEC insertStudent N'Mai Thị Khiết', '2004-04-18', 0, '0369258745', '080604013661';
EXEC insertStudent N'Lý Văn Lâm', '2003-08-30', 1, '0369852746', '080604013662';
EXEC insertStudent N'Hồ Thị Mai', '2002-06-22', 0, '0369258746', '080604013663';
EXEC insertStudent N'Đinh Văn Nhàn', '2004-11-09', 1, '0369852747', '080604013664';
EXEC insertStudent N'Trần Thị Nữ', '2003-10-05', 0, '0369258747', '080604013665';
EXEC insertStudent N'Phạm Văn Phát', '2005-02-14', 1, '0369852748', '080604013666';
EXEC insertStudent N'Hoàng Thị Quyên', '2004-07-20', 0, '0369258748', '080604013667';
EXEC insertStudent N'Lê Văn Ri', '2003-03-28', 1, '0369852749', '080604013668';
EXEC insertStudent N'Vũ Thị San', '2002-09-16', 0, '0369258749', '080604013669';
EXEC insertStudent N'Nguyễn Văn Triết', '2004-12-03', 1, '0369852750', '080604013670';
EXEC insertStudent N'Trần Thị Uyên', '2003-04-26', 0, '0369258750', '080604013671';
EXEC insertStudent N'Hoàng Thị Vy', '2004-09-12', 0, '0369852751', '080604013672';
EXEC insertStudent N'Lê Văn Phúc', '2003-07-05', 1, '0369258751', '080604013673';
EXEC insertStudent N'Nguyễn Thị Xuyến', '2002-05-29', 0, '0369852752', '080604013674';
EXEC insertStudent N'Trần Văn Yến', '2004-10-18', 1, '0369258752', '080604013675';
EXEC insertStudent N'Phạm Thị Phượng', '2003-11-23', 0, '0369852753', '080604013676';
EXEC insertStudent N'Vũ Văn An', '2002-08-14', 1, '0369258753', '080604013677';
EXEC insertStudent N'Lê Ngọc Trâm', '2004-12-07', 0, '0369852754', '080604013678';
EXEC insertStudent N'Hồ Văn Sỹ', '2003-02-04', 1, '0369258754', '080604013679';
EXEC insertStudent N'Nguyễn Thị Duyên', '2005-01-09', 0, '0369852755', '080604013680';
EXEC insertStudent N'Phạm Văn Tiến', '2004-06-14', 1, '0369258755', '080604013681';
EXEC insertStudent N'Trần Thị Trang', '2003-03-17', 0, '0369852756', '080604013682';
EXEC insertStudent N'Hoàng Văn Nam', '2002-07-30', 1, '0369258756', '080604013683';
EXEC insertStudent N'Bùi Thị Thanh', '2004-05-11', 0, '0369852757', '080604013684';
EXEC insertStudent N'Lê Văn Hùng', '2003-09-24', 1, '0369258757', '080604013685';
EXEC insertStudent N'Nguyễn Thị Lan', '2005-03-08', 0, '0369852758', '080604013686';
EXEC insertStudent N'Đỗ Văn Long', '2004-08-13', 1, '0369258758', '080604013687';
EXEC insertStudent N'Vũ Thị Nga', '2003-05-27', 0, '0369852759', '080604013688';
EXEC insertStudent N'Trần Văn Phong', '2002-10-12', 1, '0369258759', '080604013689';
EXEC insertStudent N'Phạm Thị Hà', '2004-01-26', 0, '0369852760', '080604013690';
EXEC insertStudent N'Hoàng Văn Tuấn', '2003-12-11', 1, '0369258760', '080604013691';
EXEC insertStudent N'Lê Thị Tuyết', '2002-04-04', 0, '0369852761', '080604013692';
EXEC insertStudent N'Vũ Văn Duy', '2004-09-21', 1, '0369258761', '080604013693';
EXEC insertStudent N'Nguyễn Thị Dung', '2003-06-16', 0, '0369852762', '080604013694';
EXEC insertStudent N'Phạm Văn Hiếu', '2002-11-08', 1, '0369258762', '080604013695';
EXEC insertStudent N'Trần Thị Minh', '2004-02-25', 0, '0369852763', '080604013696';
EXEC insertStudent N'Hoàng Văn Quân', '2003-08-29', 1, '0369258763', '080604013697';
EXEC insertStudent N'Lê Văn Tùng', '2002-01-18', 0, '0369852764', '080604013698';
EXEC insertStudent N'Vũ Thị Thanh', '2004-03-22', 1, '0369258764', '080604013699';
EXEC insertStudent N'Nguyễn Thị Vân', '2003-07-23', 0, '0369852765', '080604013700';
EXEC insertStudent N'Phạm Văn Nam', '2002-12-07', 1, '0369258765', '080604013701';
EXEC insertStudent N'Trần Thị Hương', '2004-04-17', 0, '0369852766', '080604013702';
GO
/*Thêm phòng học*/
exec insertRoom 36;
exec insertRoom 36;
exec insertRoom 36;
exec insertRoom 36;
exec insertRoom 16;
exec insertRoom 16;
GO

/*Thêm giáo viên*/
EXEC insertTeacher N'Nguyễn Minh Đạo','1986-12-04',1,'03952498123',N'Thanh Hóa','050286456231','daonm@gmail.com';
EXEC insertTeacher N'Nguyễn Đăng Quang','1982-06-25',1,'0682422369',N'Nghệ An','060682425689','quangnd@gmail.com';
EXEC insertTeacher N'Nguyễn Thị Thanh Vân','1990-08-19',0,'0254635412',N'Bình Dương','030890362152','vanntt@gmail.com';
EXEC insertTeacher N'Nguyễn Thành Sơn','1985-02-26',1,'0362452198',N'Tây Ninh','020285621452','sonnt@gmail.com';
EXEC insertTeacher N'Đinh Công Đoan','1899-04-25',1,'0526314589',N'Bình Tân','0504993695214','doandc@gmail.com';
EXEC insertTEACHER N'Nguyễn Thị Kim Oanh','1896-05-04',0,'0236214569',N'Tây Ninh','020496369258','oanhntk@gmail.com';
GO

/*Thêm khóa học*/
INSERT INTO COURSE(course_ID,course_name)
VALUES
	('TOE',N'Khóa học Toeic'),
	('SPK',N'Khóa học tiếng anh giao tiếp');
GO

/*Thêm lớp học*/
EXEC insertClass N'Lớp học Toeic Foundation',24,2000000,'TOE';
EXEC insertClass N'Lớp Toeic Intensive',22,3500000,'TOE';
EXEC insertClass N'Lớp Toeic luyện đề',20,1500000,'TOE';
EXEC insertClass N'Lớp Toeic Hoàn Hảo',20,6500000,'TOE';
EXEC insertClass N'Lớp phản xạ giao tiếp cơ bản',16,2500000,'SPK';
EXEC insertClass N'Lớp phản xạ giao tiếp toàn diện',20,5000000,'SPK';
GO



/*Thêm ca học*/
INSERT INTO STUDY_SHIFT (shift_ID,time_start, time_end)
VALUES
	(1, '17:30:00', '19:00:00'),
	(2, '19:30:00', '21:00:00');

GO

/*Thêm quản lí*/
INSERT INTO MANAGE(teacher_ID,course_ID)
VALUES
	(1,'TOE'),
	(2,'TOE'),
	(3,'SPK'),
	(4,'SPK'),
	(5,'TOE'),
	(6,'TOE');
GO

/*Thêm nhóm học*/ --  -1 là lớp đang mở để đăng kí || 0 là đang mở để học || 1 là lớp đã học xong
exec insertStudyGr 20, 36, '2022-01-05', '2022-10-05', 1, 2, 3, 3, 2;
exec insertStudyGr 10, 16, '2022-03-02', '2023-09-02', 1, 4, 6, 6, 1;
exec insertStudyGr 20, 36, '2022-01-05', '2023-06-05', 1, 6, 4, 4, 1;
exec insertStudyGr 20, 36, '2023-01-05', '2023-10-05', 1, 5, 1, 1, 1;
exec insertStudyGr 10, 16, '2023-06-05', '2024-02-05', 1, 3, 5, 5, 2;
exec insertStudyGr 20, 36, '2024-01-05', '2024-10-05', 0, 1, 2, 2, 1;
exec insertStudyGr 10, 16, '2024-01-05', '2023-06-05', -1, 4, 6, 6, 1;
exec insertStudyGr 20, 36, '2023-09-02', '2024-05-02', 0, 6, 4, 4, 1;



GO
/*Thêm thông báo*/
exec insertNotification N'Thông báo kỳ thi giữa kỳ', N'Thi giữa kỳ sẽ diễn ra vào ngày 15/06/2024', '2024-06-01 16:00:00',1;
exec insertNotification N'Thông báo mở lớp học', N'Lớp sẽ bắt đầu học vào ngày 06-06-2023', '2023-06-01 16:00:00',4;
exec insertNotification N'Thông báo kỳ nghỉ lễ', N'Nghỉ lễ Quốc khánh từ ngày 01/09/2022 đến ngày 03/09/2022', '2022-08-29 16:00:00',2;
exec insertNotification N'Thông báo hỗ trợ tài liệu', N'Cung cấp tài liệu miễn phí cho sinh viên', '2024-01-01 16:00:00',4;
exec insertNotification N'Cảnh báo thời tiết xấu', N'Ngày mai sẽ có bão, lớp học có thể bị hủy', '2023-06-01 16:00:00',3;
GO