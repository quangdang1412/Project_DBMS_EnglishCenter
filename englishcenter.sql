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

/*Bảng thông báo*/
CREATE TABLE NOTIFICATION(
	notification_ID int PRIMARY KEY,
	title nvarchar(max) NOT NULL,
	content nvarchar(max) NOT NULL,
	daytime_send datetime NOT NULL,
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
/*Tìm các nhóm học có cùng ID lớp*/
/*Tìm các nhóm học có cùng ID lớp*/
CREATE PROCEDURE selectGrByClass
	@classID INT
AS
BEGIN
	/*Lấy tên giáo viên dựa trên @classID*/
	DECLARE @teacherName NVARCHAR(300);
	SELECT @teacherName= teacher_name FROM TEACHER t 
		WHERE t.teacher_ID = 
			(SELECT teacher_ID FROM STUDY_GROUP WHERE @classID=class_ID);
	SELECT 
		group_ID,
		minStudent,
		maxStudent
		dayStart,
		dayEnd,
		grStatus,
		totalStudent,
		@teacherName  AS teacher_name,
		CASE
			WHEN shift_ID=1
				THEN '17:30:00 - 19:00:00'
			ELSE
				'19:30:00 - 21:00:00'
		END AS studyShift
	FROM STUDY_GROUP 
	WHERE @classID=class_ID
END
GO
/*Tạo thông báo cho nhóm học*/
CREATE PROCEDURE insertNotification
	@title NVARCHAR(MAX),
	@content NVARCHAR(MAX),
	@group_ID INT
AS
BEGIN
	BEGIN TRANSACTION
		DECLARE @maxID INT;
		SELECT @maxID=ISNULL(MAX(notification_ID),0) +1 FROM NOTIFICATION;	
		INSERT INTO NOTIFICATION(notification_ID,title,content,daytime_send)
		VALUES(@maxID,@title,@content,GETDATE());
		IF(@@ERROR <>0)
		BEGIN
			RAISERROR ('Không thể tạo thông báo',16,1);
			ROLLBACK TRANSACTION;
		END
		INSERT INTO NOTIFY(notification_ID,group_ID)
		VALUES(@maxID,@group_ID);
		IF(@@ERROR <>0)
		BEGIN
			RAISERROR ('Không thể tạo thông báo cho nhóm %d',16,1,@group_ID);
			ROLLBACK TRANSACTION;
		END
	COMMIT TRANSACTION
END
GO
/*Cập nhật thông báo cho nhóm học*/
CREATE PROCEDURE updateNotification
	@notificationID INT,
	@title NVARCHAR(MAX),
	@content NVARCHAR(MAX),
	@group_ID INT
AS
BEGIN
	BEGIN TRANSACTION
		UPDATE NOTIFICATION
		SET
			title=@title,
			content=@content,
			daytime_send=GETDATE()
		WHERE notification_ID=@notificationID
		IF(@@ERROR <>0)
		BEGIN
			RAISERROR ('Không thể tìm thấy thông báo để cập nhật',16,1);
			ROLLBACK TRANSACTION;
		END
		UPDATE  NOTIFY
		SET
			group_ID=@group_ID
		WHERE notification_ID=@notificationID
		IF(@@ERROR <>0)
		BEGIN
			RAISERROR ('Không thể tìm thấy nhóm học %d để gửi thông báo',16,1,@group_ID);
			ROLLBACK TRANSACTION;
		END
	COMMIT TRANSACTION
END
GO
/*Xóa thông báo cho 1 lớp nếu không còn lớp nào có thông báo đó thì xóa luôn thông báo khỏi hệ thống*/
CREATE PROCEDURE deleteNotification
	@notificationID INT,
	@groupID INT
AS
BEGIN
	BEGIN TRANSACTION
		DELETE FROM NOTIFY WHERE group_ID=@groupID AND notification_ID=@notificationID
		IF(@@ERROR <>0)
		BEGIN
			RAISERROR ('Không thể tìm thấy nhóm học %d hoặc thông báo %d',16,1,@groupID,@notificationID);
			ROLLBACK TRANSACTION;
		END
		DELETE FROM NOTIFICATION WHERE notification_ID=@notificationID
	COMMIT TRANSACTION
END
GO
/*Lấy tên giáo viên đã gửi thông báo cho học sinh*/
CREATE FUNCTION teacherSendMessage
(
	@notificationID INT
)
RETURNS NVARCHAR(300)
AS
BEGIN
	DECLARE @teacherName NVARCHAR(300) =NULL;
	SELECT @teacherName=teacher_name FROM TEACHER t
		WHERE t.teacher_ID=(SELECT teacher_ID FROM STUDY_GROUP gr
			WHERE gr.group_ID=(SELECT group_ID FROM NOTIFY 
				WHERE notification_ID=@notificationID));
	RETURN @teacherName;
END
GO
/*Thêm lịch học cho nhóm học trong 1 ngày*/
CREATE PROCEDURE insertStudyOn
	@weekday_ID TINYINT,
	@group_ID INT
AS
BEGIN
	INSERT INTO STUDY_ON(weekday_ID,group_ID)
	VALUES (@weekday_ID,@group_ID)
END
GO
/*Cập nhật lịch học cho nhóm học*/
CREATE PROCEDURE updateStudyOn
	@weekday_ID TINYINT,
	@group_ID INT
AS
BEGIN
	UPDATE STUDY_ON
	SET 
	weekday_ID=@weekday_ID,
	group_ID=@group_ID
END
GO
/*Xóa lịch học cho nhóm học*/
CREATE PROCEDURE deleteStudyOn
	@weekday_ID TINYINT,
	@group_ID INT
AS
BEGIN
	DELETE FROM STUDY_ON WHERE weekday_ID=@weekday_ID AND group_ID=@group_ID
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
/*Xóa học sinh khỏi nhóm học*/
CREATE PROCEDURE deleleGrList
	@studentID INT,
	@groupID INT
AS
BEGIN
	DELETE FROM GROUP_LIST WHERE student_ID=@studentID AND group_ID=@groupID
END
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
/*Lấy học sinh dựa trên groupID*/
CREATE FUNCTION selectStudentByGr
(
	@groupID INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT 
		student_ID,
		student_name,
		student_dob,
		student_gender
	FROM STUDENT 
	WHERE student_ID IN (SELECT student_ID FROM GROUP_LIST WHERE  group_ID=@groupID)
)
GO
/*Hàm lấy danh sách học sinh chưa thanh toán*/
CREATE FUNCTION LayDSChuaThanhToan(@group_ID INT)
RETURNS TABLE 
AS RETURN 
	SELECT student_ID,student_name FROM STUDENT
		WHERE student_ID IN 
			(SELECT student_ID FROM GROUP_LIST 
				WHERE group_ID=@group_ID AND (payment_state = 0 OR payment_state=-1));
GO
/*View thời khóa biểu của tất cả nhóm học trong tuần*/
CREATE VIEW Schedule 
AS
SELECT 
    CASE 
        WHEN w.weekday_ID = 2 THEN N'Thứ 2'
        WHEN w.weekday_ID = 3 THEN N'Thứ 3'
        WHEN w.weekday_ID = 4 THEN N'Thứ 4'
        WHEN w.weekday_ID = 5 THEN N'Thứ 5'
        WHEN w.weekday_ID = 6 THEN N'Thứ 6'
        WHEN w.weekday_ID = 7 THEN N'Thứ 7'
        ELSE N'Chủ Nhật'
    END AS weekday,
    gr.group_ID,
    gr.room_ID,
    CASE 
        WHEN gr.shift_ID = 1 THEN '17:30:00 - 19:00:00'
        WHEN gr.shift_ID = 2 THEN '19:30:00 - 21:00:00'
    END AS shift
FROM WEEKDAY w 
LEFT JOIN STUDY_ON s ON w.weekday_ID = s.weekday_ID 
LEFT JOIN STUDY_GROUP gr ON s.group_ID = gr.group_ID
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
exec insertNotification N'Thông báo kỳ thi giữa kỳ', N'Thi giữa kỳ sẽ diễn ra vào ngày 15/06/2024',1;
exec insertNotification N'Thông báo mở lớp học', N'Lớp sẽ bắt đầu học vào ngày 06-06-2023',4;
exec insertNotification N'Thông báo kỳ nghỉ lễ', N'Nghỉ lễ Quốc khánh từ ngày 01/09/2022 đến ngày 03/09/2022',2;
exec insertNotification N'Thông báo hỗ trợ tài liệu', N'Cung cấp tài liệu miễn phí cho sinh viên',4;
exec insertNotification N'Cảnh báo thời tiết xấu', N'Ngày mai sẽ có bão, lớp học có thể bị hủy', 3;
GO

/*Thêm học sinh vào nhóm học*/
exec insertGroupList 1,1,1,500;
exec insertGroupList 2,1,1,550;
exec insertGroupList 3,1,1,550;
exec insertGroupList 4,1,1,500;
exec insertGroupList 5,1,1,500;
exec insertGroupList 6,1,1,500;
exec insertGroupList 7,5,1,0;
exec insertGroupList 8,5,1,0;
exec insertGroupList 9,5,1,10;
exec insertGroupList 10,4,1,10;
exec insertGroupList 11,4,1,100;
exec insertGroupList 12,4,1,100;
exec insertGroupList 13,6,0,400;
exec insertGroupList 14,6,0,450;
exec insertGroupList 15,6,1,500;
exec insertGroupList 16,6,1,420;
exec insertGroupList 17,3,1,0;
exec insertGroupList 18,3,1,10;
exec insertGroupList 19,3,1,20;
exec insertGroupList 20,3,1,20;
exec insertGroupList 21,3,1,30;
GO

/*Dữ liệu về thứ trong tuần*/
INSERT INTO WEEKDAY (weekday_ID)
	VALUES(2),(3),(4),(5),(6),(7),(8);
GO

/*Dữ liệu StudyOn*/
EXEC insertStudyOn 2,1
EXEC insertStudyOn 2,8
EXEC insertStudyOn 7,2
EXEC insertStudyOn 3,3
EXEC insertStudyOn 3,4
EXEC insertStudyOn 4,5
EXEC insertStudyOn 6,6
EXEC insertStudyOn 5,7

GO

