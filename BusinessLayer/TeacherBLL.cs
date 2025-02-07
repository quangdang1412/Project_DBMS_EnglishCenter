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
    public class TeacherBLL
    {
        DAL db = null;
        
        public TeacherBLL() 
        { 
            db = new DAL();
        }
		public DataSet LayGV()
		{
           return db.ExecuteQueryDataSet("select * from TEACHER", CommandType.Text, null);
        }
        public bool ThemGiaoVien(ref string err, string teachername, DateTime teacherDob, int teacherGender, string teacherPhoneNumber,string teacherAddress, string identification,string email)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@teacher_name", teachername),
                new SqlParameter("@teacher_dob", teacherDob),
                new SqlParameter("@teacher_gender", teacherGender),
                new SqlParameter("@teacher_phoneNumber", teacherPhoneNumber),
                new SqlParameter("@teacher_address",teacherAddress),
                new SqlParameter("@identification", identification),
                new SqlParameter("@email",email)
            };

            return db.MyExecuteNonQuery("insertTeacher", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool CapNhatGiaoVien(ref string err, int teacherID, string teachername, DateTime teacherDob, int teacherGender, string teacherPhoneNumber,string teacherAddress, string identification, string email)
        {   
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@teacher_ID",teacherID),
                new SqlParameter("@teacher_name", teachername),
                new SqlParameter("@teacher_dob", teacherDob),
                new SqlParameter("@teacher_gender", teacherGender),
                new SqlParameter("@teacher_phoneNumber", teacherPhoneNumber),
                new SqlParameter("@teacher_address",teacherAddress),
                new SqlParameter("@identification", identification),
                new SqlParameter("@email",email)
            };

            return db.MyExecuteNonQuery("updateTeacher", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool XoaGiaoVien(ref string err,int teacherID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@teacher_ID",teacherID)
            };
            return db.MyExecuteNonQuery("deleteTeacher",CommandType.StoredProcedure,ref err, sqlParams);
        }
        public DataSet TimKiemGiaoVien(string searchText)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@keyword",searchText)
            };
            return db.ExecuteQueryDataSet("selectAllTeacher", CommandType.StoredProcedure, sqlParams);
        }
        public DataTable TimKiemGiaoVienTheoID(ref string err,int teacherID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@teacherID",teacherID)
            };
            return db.ExecuteQueryDataTable("selectTeacherByID", CommandType.StoredProcedure,ref err, sqlParams);
        }
        public DataTable GetGroupID(ref string err, int teacherID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@teacherID", teacherID),
            };

            return db.ExecuteQueryDataTable("getGroupByTeacherID", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataTable ScheduleTeacher(ref string err, int groupID, int week)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@groupID", groupID),
                new SqlParameter("@weekDayID", week),
            };

            return db.ExecuteQueryDataTable("getSchedule", CommandType.StoredProcedure, ref err, sqlParams);
        }
    }
}
