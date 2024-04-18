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
        public DataTable FindGroup(int classID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@classID", classID),
            };

            return db.ExecuteQueryDataTable("selectGrByClass", CommandType.StoredProcedure, sqlParams);
        }
        public DataTable FindStudentsByGroup(int groupID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@groupID", groupID),
            };

            return db.ExecuteQueryDataTable("GetStudentsByGroupID", CommandType.StoredProcedure, sqlParams);
        }
        public DataTable FindTeachersByGroup(int groupID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@groupID", groupID),
            };

            return db.ExecuteQueryDataTable("selectTeacherandClassByGr", CommandType.StoredProcedure, sqlParams);
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
    }
}
