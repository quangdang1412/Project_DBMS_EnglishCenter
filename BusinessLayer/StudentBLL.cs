﻿using DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
	public class StudentBLL
	{
		DAL db = null;
		public StudentBLL()
		{
			db = new DAL();
		}
		public DataSet LayHS()
		{
			return db.ExecuteQueryDataSet("select * from STUDENT", CommandType.Text, null);
		}
        public bool ThemHocSinh(ref string err, string studentName, DateTime studentDob, int studentGender, string studentPhoneNumber, string identification, int groupID, int paymentState, int firstScore)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@studentName", studentName),
                new SqlParameter("@studentDob", studentDob),
                new SqlParameter("@studentGender", studentGender),
                new SqlParameter("@studentPhone", studentPhoneNumber),
                new SqlParameter("@identification", identification),
                new SqlParameter("@groupID", groupID),
                new SqlParameter("@paymentState", paymentState),
                new SqlParameter("@firstScore", firstScore)
            };

            return db.MyExecuteNonQuery("insertStudentIntoGr", CommandType.StoredProcedure, ref err, sqlParams);
        }

        public bool CapNhatHocSinh(ref string err,int studentID, string studentName, DateTime studentDob, int studentGender, string studentPhoneNumber, string identification)
        {
            // Tạo một mảng chứa các tham số cho thủ tục lưu trữ
            SqlParameter[] sqlParams =
            {
                new SqlParameter("student_ID",studentID),
                new SqlParameter("@student_name", studentName),
                new SqlParameter("@student_dob", studentDob),
                new SqlParameter("@student_gender", studentGender),
                new SqlParameter("@student_phoneNumber", studentPhoneNumber),
                new SqlParameter("@identification", identification)
            };

            return db.MyExecuteNonQuery("updateStudent", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool XoaHocSinh(ref string err, int studentID)
        {
            // Tạo một mảng chứa các tham số cho thủ tục lưu trữ
            SqlParameter[] sqlParams =
            {
                new SqlParameter("student_ID",studentID),
            };

            return db.MyExecuteNonQuery("deleteStudent", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataSet TimKiemHocSinh(string searchText)
        {
            SqlParameter[] param = new SqlParameter[]
            {
                 new SqlParameter("@keyword", searchText)
            };
            return db.ExecuteQueryDataSet("selectAllStudent", CommandType.StoredProcedure, param);
        }

        public DataTable FindGroup(ref string err, int studentID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@student_ID", studentID),
            };

            return db.ExecuteQueryDataTable("GetGroupInfoWithShiftByStudentID", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataTable ScheduleStudent(ref string err, int groupID,int week)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@groupID", groupID),
                new SqlParameter("@weekDayID", week),
            };

            return db.ExecuteQueryDataTable("getSchedule", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool CapNhatHocSinh2(ref string err, int studentID, int groupID, int paymentstate, int firstScore)
        {
            // Tạo một mảng chứa các tham số cho thủ tục lưu trữ
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@student_ID",studentID),
                new SqlParameter("@group_ID", groupID),
                new SqlParameter("@paymentstate", paymentstate),
                new SqlParameter("@firstScore", firstScore)
            };

            return db.MyExecuteNonQuery("updateGroupList", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataTable GetGroupID(ref string err,int studentID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@studentID", studentID),
            };

            return db.ExecuteQueryDataTable("getGrID_ByStudentID", CommandType.StoredProcedure, ref err, sqlParams);
        }
    }
}
