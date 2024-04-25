using DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class ClassBLL
    {
        DAL db = null;
        public ClassBLL() 
        { 
            db = new DAL();
        }
        public DataSet LayClass()
        {
            return db.ExecuteQueryDataSet("select * from CLASS", CommandType.Text, null);
        }
        public DataSet LayGroup()
        {
            return db.ExecuteQueryDataSet("select * from ListGroup", CommandType.Text, null);
        }
        public DataSet LayClassByCourseID()
        {
            return db.ExecuteQueryDataSet("select course_name from COURSE", CommandType.Text, null);
        }
        public bool ThemClass(ref string err, string class_name, string soBuoi, string fee, string courseID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@clname", class_name),
                new SqlParameter("@totalDay", soBuoi),
                new SqlParameter("@fee",fee),
                new SqlParameter("@course_ID",courseID)
            };

            return db.MyExecuteNonQuery("insertClass", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool CapNhatClass(ref string err, int classID, string clname, int totalDay, float fee, string courseID)
        {
            SqlParameter[] sqlParameters =
            {
                        new SqlParameter("@classID", classID),
                        new SqlParameter("@clname", clname),
                        new SqlParameter("@totalDay", totalDay),
                        new SqlParameter("@fee",fee),
                        new SqlParameter("@course_ID",courseID)
            };
            return db.MyExecuteNonQuery("updateClass", CommandType.StoredProcedure, ref err, sqlParameters);
        }
        public bool XoaClass(ref string err, int class_id)
        {
            // Tạo một mảng chứa các tham số cho thủ tục lưu trữ
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@class_ID",class_id),
            };

            return db.MyExecuteNonQuery("deleteClass", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataTable FindGroup(ref string err, int classID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@classID", classID),
            };

            return db.ExecuteQueryDataTable("selectGrByClass", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataTable FindStudentsByGroup(ref string err, int groupID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@groupID", groupID),
            };

            return db.ExecuteQueryDataTable("GetStudentsByGroupID", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataTable FindTeachersByGroup(ref string err, int groupID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@groupID", groupID),
            };

            return db.ExecuteQueryDataTable("selectTeacherandClassByGr", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool XoaHocSinh(ref string err, int studentID, int groupID)
        {
            // Tạo một mảng chứa các tham số cho thủ tục lưu trữ
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@studentID",studentID),
                new SqlParameter("@groupID",groupID),

            };

            return db.MyExecuteNonQuery("deleteStudentFromGr", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataSet TimKiemHocSinh(string searchText)
        {
            SqlParameter[] param = new SqlParameter[]
            {
                 new SqlParameter("@keyword", searchText)
            };
            return db.ExecuteQueryDataSet("selectAllStudent", CommandType.StoredProcedure, param);
        }
        public DataTable TotalIncome(ref string err, int classID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@classID", classID),
            };

            return db.ExecuteQueryDataTable("GetTotalIncome", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataTable selectCourseByClassID(ref string err, int classID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@classID", @classID),
            };

            return db.ExecuteQueryDataTable("selectCourseByClassID", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public int DoanhThu()
        {
            return Convert.ToInt32(db.ExecuteScalar("SELECT * FROM totalIncome()", CommandType.Text));
        }
        public bool XoaHocSinhTrongNhom(ref string err, int group_ID, int id)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@studentID", id),
                new SqlParameter("@groupID",group_ID)
            };

            return db.MyExecuteNonQuery("deleteStudentFromGr", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataTable LayDSChuaThanhToan(ref string err)
        {
            return db.ExecuteQueryDataTable("select * from LayDSChuaThanhToan () ", CommandType.Text, ref err, null);
        }
    }
}
