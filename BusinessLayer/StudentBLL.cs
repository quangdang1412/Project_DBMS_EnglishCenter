using DataLayer;
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
        public bool ThemHocSinh(ref string err, string studentName, DateTime studentDob, int studentGender, string studentPhoneNumber, string identification)
        {
            // Tạo một mảng chứa các tham số cho thủ tục lưu trữ
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@student_name", studentName),
                new SqlParameter("@student_dob", studentDob),
                new SqlParameter("@student_gender", studentGender),
                new SqlParameter("@student_phoneNumber", studentPhoneNumber),
                new SqlParameter("@identification", identification)
            };

            return db.MyExecuteNonQuery("insertStudent", CommandType.StoredProcedure, ref err, sqlParams);
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


    }
}
