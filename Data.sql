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
