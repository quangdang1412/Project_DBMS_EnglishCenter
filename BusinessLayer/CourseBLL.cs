using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayer;

namespace BusinessLayer
{
    public class CourseBLL
    {
        DAL db = null;
        public CourseBLL()
        {
            db = new DAL();
        }
        public DataSet LayCourse()
        {
            return db.ExecuteQueryDataSet("select * from COURSE", CommandType.Text, null);
        }
        public bool ThemCourse(ref string err, string courseID, string courseName)
        {
            // Tạo một mảng chứa các tham số cho thủ tục lưu trữ
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@courseID", courseID),
                new SqlParameter("@course_name", courseName)     
            };

            return db.MyExecuteNonQuery("insertCourse", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool CapNhatCourse(ref string err, string courseID, string courseName)
        {
            // Tạo một mảng chứa các tham số cho thủ tục lưu trữ
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@courseID", courseID),
                new SqlParameter("@course_name", courseName)
            };

            return db.MyExecuteNonQuery("updateCourse", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool XoaCourse(ref string err, string courseID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@courseID",courseID),
            };

            return db.MyExecuteNonQuery("deleteCourse", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataTable Course_FindClass(ref string err, string courseID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@courseID", courseID),
            };

            return db.ExecuteQueryDataTable("selectClassByCourse", CommandType.StoredProcedure, ref err, sqlParams);
        }
    }
}
