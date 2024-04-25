using DataLayer;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class AttendanceBLL
    {
        DAL db = null;
        public AttendanceBLL()
        {
            db = new DAL();
        }
        public DataSet LayLopGiaoVienDangDay(int teacherID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@teacherID", teacherID)
            };
            return db.ExecuteQueryDataSet("getGroupByTeacherID ", CommandType.StoredProcedure, sqlParams);
        }
        public DataTable LayHocSinhTheoLop(ref string err, int groupID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@groupID",groupID)
            };
            return db.ExecuteQueryDataTable("GetStudentsByGroupID ", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataTable LayBangDiemDanh(ref string err,int groupID,DateTime schoolDay)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@groupID",groupID),
                new SqlParameter("@schoolDay",schoolDay)
            };
            return db.ExecuteQueryDataTable("getAttendance ", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool TaoBangDiemDanh(ref string err, int groupID, int studentID, string studentName)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter ("@groupID",groupID),
                new SqlParameter ("@studentID",studentID),
                new SqlParameter ("@studentName",studentName)
            };
            return db.MyExecuteNonQuery("insertStudentAttendance ", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool XoaDiemDanh(ref string err, DateTime schoolDay, int groupID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter ("@school_day",schoolDay),
                new SqlParameter ("@group_ID",groupID)
            };
            return db.MyExecuteNonQuery("deleteAttendance ", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool DiemDanhChoHocSinh(ref string err, DateTime schoolDay, int groupID, int studentID,int present)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter ("@school_day",schoolDay),
                new SqlParameter ("@groupID",groupID),
                new SqlParameter ("@studentID",studentID),
                new SqlParameter ("@present",present)
            };
            return db.MyExecuteNonQuery("checkStudentPresent ", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataSet LayNgayHoc()
        {
            return db.ExecuteQueryDataSet("Select * FROM SCHOOL_DAYS", CommandType.Text, null);
        }
    }
}
