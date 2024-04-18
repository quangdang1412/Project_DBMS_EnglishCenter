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
ALTER TABLE STUDY_GROUP ADD DEFAULT ((0)) FOR totalStudent;
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
GO
/*

*/
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
/*Procedure tạo nhóm học mới và xếp lịch cho nhóm học đó*/
CREATE PROCEDURE insertStudyGr
	@minstudent INT,
	@maxstudent INT,
	@dayStart DATE,
	@dayEnd DATE,
	@grStatus INT, -- -1 là đang mở để đăng kí,0 là lớp đang mở và đang còn học, 1 là lớp đã học xong
	@teacher_ID INT,
	@class_ID INT,
	@room_ID INT,
	@shift_ID TINYINT,
	@weekdayID INT
AS
BEGIN
	BEGIN TRANSACTION
		IF @dayStart >@dayEnd
		BEGIN
			RAISERROR ('Ngày bắt đầu phải nhỏ hơn ngày kết thúc',16,1);
			RETURN;
		END
		IF EXISTS (SELECT teacher_ID FROM STUDY_GROUP s WHERE 
					group_ID IN (SELECT group_ID FROM STUDY_ON WHERE weekday_ID=@weekdayID AND shift_ID=@shift_ID))
		BEGIN
			RAISERROR ('Giáo viên này đã có lịch dạy vào thứ %d ca %d',16,1,@weekdayID,@shift_ID);
			RETURN;
		END
		IF EXISTS (SELECT room_ID FROM STUDY_GROUP s WHERE 
					group_ID IN (SELECT group_ID FROM STUDY_ON WHERE weekday_ID=@weekdayID AND shift_ID=@shift_ID))
		BEGIN
			RAISERROR ('Phòng học này đã được sử dụng vào thứ %d ca %d',16,1,@weekdayID,@shift_ID);
			RETURN;
		END
		DECLARE @maxID INT;
		SELECT @maxID=ISNULL(MAX(group_ID),0) +1 FROM STUDY_GROUP;
		INSERT INTO STUDY_GROUP
			(group_ID,minStudent,maxStudent,dayStart,dayEnd,grStatus,teacher_ID,class_ID,room_ID,shift_ID)
		VALUES
			(@maxID,@minstudent,@maxstudent,@dayStart,@dayEnd,@grStatus,@teacher_ID,@class_ID,@room_ID,@shift_ID);
		IF @@ERROR <> 0
		BEGIN
			RAISERROR ('Không thể thêm nhóm học',16,1);
			ROLLBACK TRANSACTION;
			RETURN;
		END
		INSERT INTO STUDY_ON
			(group_ID,weekday_ID)
		VALUES
			(@maxID,@weekdayID)
		IF @@ERROR <> 0
		BEGIN 
			RAISERROR ('Không thể xếp lịch học cho nhóm học %d vào thứ %d',16,1,@maxID,@weekdayID)
			ROLLBACK TRANSACTION;
			RETURN;
		END
		COMMIT TRANSACTION;
END
GO
/*Procedure cập nhật nhóm học và lịch học cho nhóm học*/
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
	@shift_ID TINYINT,
	@weekdayID INT
AS
BEGIN
	BEGIN TRANSACTION
		IF @dayStart >@dayEnd
		BEGIN
			RAISERROR ('Ngày bắt đầu phải nhỏ hơn ngày kết thúc',16,1);
			RETURN;
		END
		IF EXISTS (SELECT teacher_ID FROM STUDY_GROUP s WHERE 
					group_ID IN (SELECT group_ID FROM STUDY_ON WHERE weekday_ID=@weekdayID AND shift_ID=@shift_ID))
		BEGIN
			RAISERROR ('Giáo viên này đã có lịch dạy vào thứ %d ca %d',16,1,@weekdayID,@shift_ID);
			RETURN;
		END
		IF EXISTS (SELECT room_ID FROM STUDY_GROUP s WHERE 
					group_ID IN (SELECT group_ID FROM STUDY_ON WHERE weekday_ID=@weekdayID AND shift_ID=@shift_ID))
		BEGIN
			RAISERROR ('Phòng học này đã được sử dụng vào thứ %d ca %d',16,1,@weekdayID,@shift_ID);
			RETURN;
		END
		UPDATE STUDY_GROUP
			SET 
				minStudent=@minstudent,
				maxStudent=@maxstudent,
				dayStart=@dayStart,
				dayEnd=@dayEnd,
				grStatus=@grStatus,
				teacher_ID=@teacher_ID,
				class_ID=@class_ID,
				room_ID=@room_ID,
				shift_ID=@shift_ID
			WHERE group_ID=@groupID
		IF @@ERROR <> 0
		BEGIN
			RAISERROR ('Không thể chỉnh sửa nhóm học',16,1);
			ROLLBACK TRANSACTION;
			RETURN;
		END
		UPDATE STUDY_ON
		SET
			group_ID=@groupID
		WHERE weekday_ID=@weekdayID AND group_ID=@groupID
		IF @@ERROR <> 0
		BEGIN 
			RAISERROR ('Không thể xếp lịch học cho nhóm học %d vào thứ %d',16,1,@groupID,@weekdayID)
			ROLLBACK TRANSACTION;
			RETURN;
		END
		COMMIT TRANSACTION;
END
GO
/*Xóa nhóm học dựa trên ID*/
CREATE PROCEDURE deleteStudyGr
	@groupID INT
AS
BEGIN
	BEGIN TRANSACTION
		IF NOT EXISTS (SELECT 1 FROM STUDY_ON WHERE group_ID=@groupID)
		BEGIN
			IF EXISTS (SELECT 1 FROM GROUP_LIST WHERE group_ID=@groupID)
			BEGIN
				RAISERROR ('Vẫn còn học sinh trong nhóm học này',16,1)
				ROLLBACK TRANSACTION;
				RETURN;
			END
			ELSE
				DELETE FROM STUDY_GROUP WHERE group_ID=@groupID;
		END
		ELSE
		BEGIN
			RAISERROR ('Không thể xóa do nhóm học vẫn còn lịch học',16,1);
			ROLLBACK TRANSACTION;
			RETURN;
		END
		COMMIT TRANSACTION;
END
GO
/*Procedure Thêm học viên mới vào 1 nhóm học*/
CREATE PROCEDURE insertStudentIntoGr
	@studentName NVARCHAR(300),
	@studentDob DATE,
	@studentGender TINYINT,
	@studentPhone VARCHAR(10),
	@identification VARCHAR(12),
	@groupID INT,
	@paymentState TINYINT,
	@firstScore INT
AS
BEGIN
	DECLARE @maxStudentID INT;
	SELECT @maxStudentID= ISNULL(MAX(student_ID),0)+1 FROM STUDENT;
	BEGIN TRANSACTION
		INSERT INTO STUDENT(student_ID,student_name,student_dob,student_gender,student_phoneNumber,identification)
		VALUES(@maxStudentID,@studentName,@studentDob,@studentGender,@studentPhone,@identification);
		IF @@ERROR <> 0
		BEGIN
			RAISERROR ('Không thể thêm học viên',16,1)
			ROLLBACK TRANSACTION;
			RETURN;
		END
		INSERT INTO GROUP_LIST(student_ID,group_ID,payment_state,firstScore)
		VALUES(@maxStudentID,@groupID,@paymentState,@firstScore);
		IF @@ERROR <>0
		BEGIN
			RAISERROR ('Không thể thêm học viên vào nhóm học %d',16,1,@groupID)
			ROLLBACK TRANSACTION;
			RETURN;
		END
		COMMIT TRANSACTION;
END
GO
/*Cập nhật thông tin nhóm học*/
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
/*Xóa học viên khỏi nhóm học nếu học viên đó không còn học nhóm nào nữa thì xóa*/
CREATE PROCEDURE deleteStudentFromGr
	@studentID INT,
	@groupID INT
AS
BEGIN
	DECLARE @studentName NVARCHAR(300);
	SELECT @studentName= student_name FROM STUDENT WHERE student_ID=@studentID;
	IF @studentName IS NULL
	BEGIN
		RAISERROR('Không tồn tại học viên với mã học viên %d',16,1,@studentID)
		RETURN
	END
	BEGIN TRANSACTION
	DELETE FROM GROUP_LIST WHERE student_ID=@studentID AND group_ID=@groupID
		IF @@ROWCOUNT = 0
		BEGIN
			RAISERROR ('Không có học viên %s trong nhóm học %d',16,1,@studentName,@groupID)
			ROLLBACK TRANSACTION;
			RETURN;
		END
	IF NOT EXISTS (SELECT 1 FROM GROUP_LIST WHERE student_ID=@studentID)
	BEGIN
		DELETE FROM STUDENT WHERE student_ID=@studentID;
		IF @@ERROR <>0
		BEGIN
			RAISERROR ('Không thể xóa học viên',16,1)
			ROLLBACK TRANSACTION;
			RETURN;
		END
		COMMIT TRANSACTION;
	END
END
GO
/*Tìm các nhóm học có cùng ID lớp*/
CREATE PROCEDURE selectGrByClass
	@classID INT
AS
BEGIN
	/*Lấy tên giáo viên dựa trên @classID*/
	DECLARE @teacherName NVARCHAR(300);
	SELECT @teacherName = teacher_name FROM TEACHER t 
		WHERE t.teacher_ID IN 
			(SELECT teacher_ID FROM STUDY_GROUP WHERE @classID=class_ID);
	SELECT 
		group_ID,
		minStudent,
		maxStudent,
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
			RETURN;
		END
		INSERT INTO NOTIFY(notification_ID,group_ID)
		VALUES(@maxID,@group_ID);
		IF(@@ERROR <>0)
		BEGIN
			RAISERROR ('Không thể tạo thông báo cho nhóm %d',16,1,@group_ID);
			ROLLBACK TRANSACTION;
			RETURN;
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
			RETURN;
		END
		UPDATE  NOTIFY
		SET
			group_ID=@group_ID
		WHERE notification_ID=@notificationID
		IF(@@ERROR <>0)
		BEGIN
			RAISERROR ('Không thể tìm thấy nhóm học %d để gửi thông báo',16,1,@group_ID);
			ROLLBACK TRANSACTION;
			RETURN;
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
			RETURN;
		END
		DELETE FROM NOTIFICATION WHERE notification_ID=@notificationID
	COMMIT TRANSACTION;
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
CREATE PROCEDURE GetStudentsByGroupID
	@groupID INT
AS
BEGIN 
	SELECT
		student_ID,
		student_name,
		student_dob,
		student_gender,
		student_phoneNumber,
		identification
	FROM STUDENT 
	WHERE student_ID IN (SELECT student_ID FROM GROUP_LIST WHERE  group_ID=@groupID)
END
GO
/*Lấy tên lớp và tên giáo viên dạy nhóm học đó*/
CREATE PROCEDURE selectTeacherandClassByGr
	@groupID INT
AS
BEGIN
	DECLARE @teacherName NVARCHAR(300);
	DECLARE @className NVARCHAR(300);
	SELECT @teacherName=teacher_name FROM TEACHER 
		WHERE teacher_ID =(SELECT teacher_ID FROM STUDY_GROUP WHERE group_ID=@groupID);
	SELECT @className= clname FROM CLASS
		WHERE class_ID =(SELECT class_ID FROM STUDY_GROUP WHERE group_ID=@groupID);
	SELECT @groupID,@className AS className,@teacherName AS teacherName;
END
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
    w.weekday_ID,
	CASE 
		WHEN gr.group_ID IS NOT NULL THEN CONCAT (N'Nhóm',' ',gr.group_ID)
		ELSE NULL
    END AS groupID,
	cl.clname,
	CASE
		WHEN gr.room_ID IS NOT NULL THEN CONCAT(N'Phòng ', gr.room_ID)
		ELSE NULL
	END AS room,
    CASE 
        WHEN gr.shift_ID = 1 THEN '17:30:00 - 19:00:00'
        WHEN gr.shift_ID = 2 THEN '19:30:00 - 21:00:00'
    END AS shift
FROM WEEKDAY w 
LEFT JOIN STUDY_ON s ON w.weekday_ID = s.weekday_ID 
LEFT JOIN STUDY_GROUP gr ON s.group_ID = gr.group_ID
LEFT JOIN CLASS cl ON cl.class_ID=gr.class_ID
GO
/*Lấy thời khóa biểu theo thứ*/
CREATE PROCEDURE ScheduleByDay
	@weekdayID INT
AS
BEGIN
	SELECT * FROM Schedule
	WHERE weekday_ID=@weekdayID
END
GO
/*Danh sách nhóm học của trung tâm*/
CREATE VIEW ListGrOfCenter AS
SELECT
	CONCAT(N'Nhóm',' ',s.group_ID) AS groupID,
	cl.class_ID,
	cl.clname,
	t.teacher_name,
	s.grStatus,
	s.totalStudent,
	s.dayStart,
	s.dayEnd,
	cl.fee
FROM STUDY_GROUP s
LEFT JOIN CLASS cl ON s.class_ID  = cl.class_ID
LEFT JOIN TEACHER t ON t.teacher_ID= s.teacher_ID
GO
/*Tính doanh thu của trung tâm*/
CREATE FUNCTION totalIncome
(
	@classID INT
)
RETURNS TABLE
AS 
RETURN
(
	SELECT class_ID,clname,SUM(fee*totalStudent) AS total FROM ListGrOfCenter 
	WHERE class_ID=@classID 
	GROUP BY class_ID,clname
)
GO
CREATE PROCEDURE GetTotalIncome
    @classID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM totalIncome(@classID);
END
GO

/* Đổ dữ liệu */
USE EnglishCenter
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
EXEC insertTeacher N'Nguyễn Thị Kim Oanh','1896-05-04',0,'0236214569',N'Tây Ninh','020496369258','oanhntk@gmail.com';
GO
/*Dữ liệu về thứ trong tuần*/
INSERT INTO WEEKDAY (weekday_ID)
	VALUES(2),(3),(4),(5),(6),(7),(8);
GO
/*Thêm ca học*/
INSERT INTO STUDY_SHIFT (shift_ID,time_start, time_end)
VALUES
	(1, '17:30:00', '19:00:00'),
	(2, '19:30:00', '21:00:00');
GO
/*Thêm nhóm học và xếp lịch học cho nhóm đó*/
exec insertStudyGr 20, 36, '2022-01-05', '2022-10-05',1,1,1,1,1,2;
exec insertStudyGr 20, 36, '2022-03-02', '2023-09-02', 1,2,2,2,1,3;
exec insertStudyGr 20, 36, '2022-01-05', '2023-06-05', 1,3,3,3,1,4;
exec insertStudyGr 20, 36, '2023-01-05', '2023-10-05', 1,4,4,4,1,5;
exec insertStudyGr 10, 16, '2023-06-05', '2024-02-05', 1,5,5,5,1,6;
exec insertStudyGr 20, 36, '2024-01-05', '2024-10-05', 0,6,6,6,1,7
exec insertStudyGr 10, 16, '2024-01-05', '2024-06-05', -1,1,1,1,2,2;
exec insertStudyGr 20, 36, '2023-09-02', '2024-05-02', 0,2,2,2,2,3;
GO
/*Thêm học sinh vào nhóm học*/
EXEC insertStudentIntoGr N'Bùi Văn Đức', '2005-01-25', 1, '0369852745', '080604013660',1,1,0;
EXEC insertStudentIntoGr N'Mai Thị Khiết', '2004-04-18', 0, '0369258745', '080604013661',1,1,0;
EXEC insertStudentIntoGr N'Lý Văn Lâm', '2003-08-30', 1, '0369852746', '080604013662',1,1,0;
EXEC insertStudentIntoGr N'Hồ Thị Mai', '2002-06-22', 0, '0369258746', '080604013663',1,1,0;
EXEC insertStudentIntoGr N'Đinh Văn Nhàn', '2004-11-09', 1, '0369852747', '080604013664',1,1,0;
EXEC insertStudentIntoGr N'Trần Thị Nữ', '2003-10-05', 0, '0369258747', '080604013665',1,1,0;
EXEC insertStudentIntoGr N'Phạm Văn Phát', '2005-02-14', 1, '0369852748', '080604013666',1,1,0;
EXEC insertStudentIntoGr N'Hoàng Thị Quyên', '2004-07-20', 0, '0369258748', '080604013667',1,1,0;
EXEC insertStudentIntoGr N'Lê Văn Ri', '2003-03-28', 1, '0369852749', '080604013668',1,1,0;
EXEC insertStudentIntoGr N'Vũ Thị San', '2002-09-16', 0, '0369258749', '080604013669',1,1,0;
EXEC insertStudentIntoGr N'Nguyễn Văn Triết', '2004-12-03', 1, '0369852750', '080604013670',1,1,0;
EXEC insertStudentIntoGr N'Trần Thị Uyên', '2003-04-26', 0, '0369258750', '080604013671',1,1,0;
EXEC insertStudentIntoGr N'Hoàng Thị Vy', '2004-09-12', 0, '0369852751', '080604013672',1,1,0;
EXEC insertStudentIntoGr N'Lê Văn Phúc', '2003-07-05', 1, '0369258751', '080604013673',1,1,0;
EXEC insertStudentIntoGr N'Nguyễn Thị Xuyến', '2002-05-29', 0, '0369852752', '080604013674',1,1,0;
EXEC insertStudentIntoGr N'Trần Văn Yến', '2004-10-18', 1, '0369258752', '080604013675',1,1,0;
EXEC insertStudentIntoGr N'Phạm Thị Phượng', '2003-11-23', 0, '0369852753', '080604013676',1,1,0;
EXEC insertStudentIntoGr N'Vũ Văn An', '2002-08-14', 1, '0369258753', '080604013677',1,1,0;
EXEC insertStudentIntoGr N'Lê Ngọc Trâm', '2004-12-07', 0, '0369852754', '080604013678',1,1,0;
EXEC insertStudentIntoGr N'Hồ Văn Sỹ', '2003-02-04', 1, '0369258754', '080604013679',1,1,0;
GO
EXEC insertStudentIntoGr N'Nguyễn Thị Duyên', '2005-01-09', 0, '0369852755', '080604013680',2,1,400;
EXEC insertStudentIntoGr N'Phạm Văn Tiến', '2004-06-14', 1, '0369258755', '080604013681',2,1,400;
EXEC insertStudentIntoGr N'Trần Thị Trang', '2003-03-17', 0, '0369852756', '080604013682',2,1,400;
EXEC insertStudentIntoGr N'Hoàng Văn Nam', '2002-07-30', 1, '0369258756', '080604013683',2,1,400;
EXEC insertStudentIntoGr N'Bùi Thị Thanh', '2004-05-11', 0, '0369852757', '080604013684',2,1,400;
EXEC insertStudentIntoGr N'Lê Văn Hùng', '2003-09-24', 1, '0369258757', '080604013685',2,1,400;
EXEC insertStudentIntoGr N'Nguyễn Thị Lan', '2005-03-08', 0, '0369852758', '080604013686',2,1,400;
EXEC insertStudentIntoGr N'Đỗ Văn Long', '2004-08-13', 1, '0369258758', '080604013687',2,1,400;
EXEC insertStudentIntoGr N'Vũ Thị Nga', '2003-05-27', 0, '0369852759', '080604013688',2,1,400;
EXEC insertStudentIntoGr N'Trần Văn Phong', '2002-10-12', 1, '0369258759', '080604013689',2,1,400;
EXEC insertStudentIntoGr N'Phạm Thị Hà', '2004-01-26', 0, '0369852760', '080604013690',2,1,400;
EXEC insertStudentIntoGr N'Hoàng Văn Tuấn', '2003-12-11', 1, '0369258760', '080604013691',2,1,400;
EXEC insertStudentIntoGr N'Lê Thị Tuyết', '2002-04-04', 0, '0369852761', '080604013692',2,1,400;
EXEC insertStudentIntoGr N'Vũ Văn Duy', '2004-09-21', 1, '0369258761', '080604013693',2,1,400;
EXEC insertStudentIntoGr N'Nguyễn Thị Dung', '2003-06-16', 0, '0369852762', '080604013694',2,1,400;
EXEC insertStudentIntoGr N'Phạm Văn Hiếu', '2002-11-08', 1, '0369258762', '080604013695',2,1,400;
EXEC insertStudentIntoGr N'Trần Thị Minh', '2004-02-25', 0, '0369852763', '080604013696',2,1,400;
EXEC insertStudentIntoGr N'Hoàng Văn Quân', '2003-08-29', 1, '0369258763', '080604013697',2,1,400;
EXEC insertStudentIntoGr N'Lê Văn Tùng', '2002-01-18', 0, '0369852764', '080604013698',2,1,400;
EXEC insertStudentIntoGr N'Vũ Thị Thanh', '2004-03-22', 1, '0369258764', '080604013699',2,1,400;
GO
EXEC insertStudentIntoGr N'Nguyễn Thị Vân', '2003-07-23', 0, '0369852765', '080604013700',3,1,500;
EXEC insertStudentIntoGr N'Phạm Văn Nam', '2002-12-07', 1, '0369258765', '080604013701',3,1,500;
EXEC insertStudentIntoGr N'Trần Thị Hương', '2004-04-17', 0, '0369852766', '080604013702',3,1,500;
EXEC insertStudentIntoGr N'Nguyễn Văn Anh', '2000-01-01', 1, '0123456789', '080604013703',3,1,500;
EXEC insertStudentIntoGr N'Trần Thị Bon', '2000-01-02', 0, '0123456780', '080604013704',3,1,500;
EXEC insertStudentIntoGr N'Lê Văn Chính', '2000-01-03', 1, '0123456781', '080604013705',3,1,500;
EXEC insertStudentIntoGr N'Hoàng Thị Diễm', '2000-01-04', 0, '0123456782', '080604013706',3,1,500;
EXEC insertStudentIntoGr N'Phạm Văn Ê', '2000-01-05', 1, '0123456783', '080604013707',3,1,500;
EXEC insertStudentIntoGr N'Nguyễn Thị Phớ', '2000-01-06', 0, '0123456784', '080604013708',3,1,500;
EXEC insertStudentIntoGr N'Trần Văn Giang', '2000-01-07', 1, '0123456785', '080604013709',3,1,500;
EXEC insertStudentIntoGr N'Lê Thị Hương', '2000-01-08', 0, '0123456786', '080604013710',3,1,500;
EXEC insertStudentIntoGr N'Hoàng Văn Yên', '2000-01-09', 1, '0123456787', '080604013711',3,1,500;
EXEC insertStudentIntoGr N'Phạm Thị Khiết', '2000-01-10', 0, '0123456788', '080604013712',3,1,500;
EXEC insertStudentIntoGr N'Nguyễn Văn Vỹ', '2000-01-21', 1, '0213456789', '080604013723',3,1,500;
EXEC insertStudentIntoGr N'Trần Thị Xuyên', '2000-01-22', 0, '0213456780', '080604013724',3,1,500;
EXEC insertStudentIntoGr N'Lê Văn Yến', '2000-01-23', 1, '0213456781', '080604013725',3,1,500;
EXEC insertStudentIntoGr N'Hoàng Thị Uông', '2000-01-24', 0, '0213456782', '080604013726',3,1,500;
EXEC insertStudentIntoGr N'Phạm Văn Đồng', '2000-01-25', 1, '0213456783', '080604013727',3,1,500;
EXEC insertStudentIntoGr N'Nguyễn Thị Bảo', '2000-01-26', 0, '0213456784', '080604013728',3,1,500;
EXEC insertStudentIntoGr N'Trần Văn Chiến', '2000-01-27', 1, '0213456785', '080604013729',3,1,500;
GO
EXEC insertStudentIntoGr N'Lê Thị Xuyến', '2000-01-28', 0, '0123256786', '080604013730',4,1,10;
EXEC insertStudentIntoGr N'Hoàng Văn Chiến', '2000-01-29', 1, '0121456787', '080604013731',4,1,10;
EXEC insertStudentIntoGr N'Phạm Thị Kiều Loan', '2000-01-30', 0, '01232456788', '080604013732',4,1,10;
EXEC insertStudentIntoGr N'Nguyễn Trường Giang', '2000-01-31', 1, '0132456789', '080604013733',4,1,10;
EXEC insertStudentIntoGr N'Trần Thị Kiều', '2000-02-01', 0, '0123444780', '080604013734',4,1,10;
EXEC insertStudentIntoGr N'Lê Văn Lộc', '2000-02-02', 1, '0123456666', '080604013735',4,1,10;
EXEC insertStudentIntoGr N'Hoàng Thị Hương', '2000-02-03', 0, '0124356782', '080604013736',4,1,10;
EXEC insertStudentIntoGr N'Phạm Văn Trinh', '2000-02-04', 1, '0123436783', '080604013737',4,1,10;
EXEC insertStudentIntoGr N'Nguyễn Thị Kiều Hương', '2000-02-05', 0, '0123465784', '080604013738',4,1,10;
EXEC insertStudentIntoGr N'Trần Văn Quy', '2000-02-06', 1, '0123467785', '080604013739',4,1,10;
EXEC insertStudentIntoGr N'Lê Thị Nu', '2000-02-07', 0, '0123455586', '080604013740',4,1,10;
EXEC insertStudentIntoGr N'Hoàng Văn Bảo Phúc', '2000-02-08', 1, '0111456787', '080604013741',4,1,10;
EXEC insertStudentIntoGr N'Phạm Thị Nhật', '2000-02-09', 0, '0123456668', '080604013742',4,1,10;
EXEC insertStudentIntoGr N'Nguyễn Văn Dương', '2000-02-10', 1, '0122226789', '080604013743',4,1,10;
EXEC insertStudentIntoGr N'Trần Thị Trân', '2000-02-11', 0, '0123456980', '080604013744',4,1,10;
EXEC insertStudentIntoGr N'Lê Văn Lưỡng', '2000-02-12', 1, '0123456187', '080604013745',4,1,10;
EXEC insertStudentIntoGr N'Hoàng Thị Tuyết Mai', '2000-02-13', 0, '0873456782', '080604013746',4,1,10;
EXEC insertStudentIntoGr N'Phạm Văn Duy', '2000-02-14', 1, '0123456712', '080604013747',4,1,10;
EXEC insertStudentIntoGr N'Nguyễn Thị Vy', '2000-02-15', 0, '0123456324', '080604013748',4,1,10;
EXEC insertStudentIntoGr N'Trần Văn Dương', '2000-02-16', 1, '0123452285', '080604013749',4,1,10;
GO
EXEC insertStudentIntoGr N'Lê Thị Mỹ Dung', '2000-02-17', 0, '0123451186', '080604013750',5,1,0;
EXEC insertStudentIntoGr N'Hoàng Văn Hiếu', '2000-02-18', 1, '0123450087', '080604013751',5,1,0;
EXEC insertStudentIntoGr N'Phạm Thị Dung', '2000-02-19', 0, '0123456008', '080604013752',5,1,0;
EXEC insertStudentIntoGr N'Nguyễn Văn Ảnh', '2000-02-20', 1, '0123006789', '080604013753',5,1,0;
EXEC insertStudentIntoGr N'Trần Thị Thu', '2000-02-21', 0, '0123450080', '080604013754',5,1,0;
EXEC insertStudentIntoGr N'Lê Văn Thạo', '2000-02-22', 1, '0123016781', '080604013755',5,1,0;
EXEC insertStudentIntoGr N'Nguyễn Thị Thiên Thiên', '2000-02-25', 0, '0843456784', '080604013758',5,1,0;
EXEC insertStudentIntoGr N'Trần Văn Duy', '2000-02-26', 1, '0843456785', '080604013759',5,1,0;
EXEC insertStudentIntoGr N'Lê Thị Thu Hương', '2000-02-27', 0, '0843456786', '080604013760',5,1,0;
EXEC insertStudentIntoGr N'Hoàng Văn Tiến Trung', '2000-02-28', 1, '0883456787', '080604013761',5,1,0;
EXEC insertStudentIntoGr N'Phạm Thị Oách', '2000-02-29', 0, '0923456788', '080604013762',5,1,0;
EXEC insertStudentIntoGr N'Nguyễn Văn Cư', '2000-03-01', 1, '0923456789', '080604013763',5,1,0;
EXEC insertStudentIntoGr N'Trần Thị Sĩ Cư', '2000-03-02', 0, '0923456780', '080604013764',5,1,0;
GO
EXEC insertStudentIntoGr N'Lê Văn Nam', '2000-03-03', 1, '0923456781', '080604013765',6,0,500;
EXEC insertStudentIntoGr N'Hoàng Thị Nương', '2000-03-04', 0, '0923456782', '080604013766',6,0,500;
EXEC insertStudentIntoGr N'Phạm Văn Đồng Khởi', '2000-03-05', 1, '0923456783', '080604013767',6,0,520;
EXEC insertStudentIntoGr N'Nguyễn Thị Phụng', '2000-03-06', 0, '0923456784', '080604013768',6,1,500;
EXEC insertStudentIntoGr N'Hoàng Thùy Dương', '2000-02-23', 0, '0893456782', '080604013756',6,1,500;
EXEC insertStudentIntoGr N'Phạm Văn Tiến Đạt', '2000-02-24', 1, '0893456783', '080604013757',6,0,500;
EXEC insertStudentIntoGr N'Nguyễn Văn Lam', '2000-01-11', 1, '0987654321', '080604013713',6,0,510;
EXEC insertStudentIntoGr N'Trần Thị Mậu', '2000-01-12', 0, '0987654322', '080604013714',6,1,500;
EXEC insertStudentIntoGr N'Lê Văn Nan', '2000-01-13', 1, '0987654323', '080604013715',6,0,510;
EXEC insertStudentIntoGr N'Hoàng Thị Oanh', '2000-01-14', 0, '0987654324', '080604013716',6,0,510;
GO
EXEC insertStudentIntoGr N'Phạm Văn Phụng', '2000-01-15', 1, '0987654325', '080604013717',8,0,405;
EXEC insertStudentIntoGr N'Nguyễn Thị Quyết', '2000-01-16', 0, '0987654326', '080604013718',8,1,400;
EXEC insertStudentIntoGr N'Trần Văn Bảo', '2000-01-17', 1, '0987654327', '080604013719',8,0,450;
EXEC insertStudentIntoGr N'Lê Thị San', '2000-01-18', 0, '0987654328', '080604013720',8,1,400;
EXEC insertStudentIntoGr N'Hoàng Văn Thịnh', '2000-01-19', 1, '0987654329', '080604013721',8,0,420;
EXEC insertStudentIntoGr N'Phạm Thị Uyển', '2000-01-20', 0, '0987654330', '080604013722',8,0,400;
GO

/*Cập nhật last Score đối với các nhóm đã kết thúc*/
exec updateLastScore 1,1,400;
exec updateLastScore 2,1,400;
exec updateLastScore 3,1,400;
exec updateLastScore 4,1,400;
exec updateLastScore 5,1,400;
exec updateLastScore 6,1,400;
exec updateLastScore 7,1,400;
exec updateLastScore 8,1,400;
exec updateLastScore 9,1,400;
exec updateLastScore 10,1,400;
exec updateLastScore 11,1,400;
exec updateLastScore 12,1,400;
exec updateLastScore 13,1,400;
exec updateLastScore 14,1,400;
exec updateLastScore 15,1,400;
exec updateLastScore 16,1,400;
exec updateLastScore 17,1,400;
exec updateLastScore 18,1,400;
exec updateLastScore 19,1,400;
exec updateLastScore 20,1,400;
GO
exec updateLastScore 21,2,600;
exec updateLastScore 22,2,600;
exec updateLastScore 23,2,600;
exec updateLastScore 24,2,600;
exec updateLastScore 25,2,600;
exec updateLastScore 26,2,600;
exec updateLastScore 27,2,600;
exec updateLastScore 28,2,600;
exec updateLastScore 29,2,600;
exec updateLastScore 30,2,600;
exec updateLastScore 31,2,600;
exec updateLastScore 32,2,600;
exec updateLastScore 33,2,600;
exec updateLastScore 34,2,600;
exec updateLastScore 35,2,600;
exec updateLastScore 36,2,600;
exec updateLastScore 37,2,600;
exec updateLastScore 38,2,600;
exec updateLastScore 39,2,600;
exec updateLastScore 40,2,600;
GO
exec updateLastScore 41,3,600;
exec updateLastScore 42,3,600;
exec updateLastScore 43,3,600;
exec updateLastScore 44,3,600;
exec updateLastScore 45,3,600;
exec updateLastScore 46,3,600;
exec updateLastScore 47,3,600;
exec updateLastScore 48,3,600;
exec updateLastScore 49,3,600;
exec updateLastScore 50,3,600;
exec updateLastScore 51,3,600;
exec updateLastScore 52,3,600;
exec updateLastScore 53,3,600;
exec updateLastScore 54,3,600;
exec updateLastScore 55,3,600;
exec updateLastScore 56,3,600;
exec updateLastScore 57,3,600;
exec updateLastScore 58,3,600;
exec updateLastScore 59,3,600;
exec updateLastScore 60,3,600;
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
/*Thêm thông báo*/
exec insertNotification N'Thông báo kỳ thi giữa kỳ', N'Thi giữa kỳ sẽ diễn ra vào ngày 15/06/2024',1;
exec insertNotification N'Thông báo mở lớp học', N'Lớp sẽ bắt đầu học vào ngày 06-06-2023',4;
exec insertNotification N'Thông báo kỳ nghỉ lễ', N'Nghỉ lễ Quốc khánh từ ngày 01/09/2022 đến ngày 03/09/2022',2;
exec insertNotification N'Thông báo hỗ trợ tài liệu', N'Cung cấp tài liệu miễn phí cho sinh viên',4;
exec insertNotification N'Cảnh báo thời tiết xấu', N'Ngày mai sẽ có bão, lớp học có thể bị hủy', 3;
GO

