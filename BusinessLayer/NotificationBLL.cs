using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayer;
namespace BusinessLayer
{
    public class NotificationBLL
    {
        DAL db = null;
        public NotificationBLL()
        {
            db=new DAL();
        }
        public DataSet LayThongBao(int notificationID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@notificationID", notificationID)
            };
            return db.ExecuteQueryDataSet("getNotificationMakeByTeacher ", CommandType.StoredProcedure,sqlParams);
        }
        public object LayNoiDung(int notificationID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@notificationID", notificationID)
            };
            return db.ExecuteScalar("getContent ", CommandType.StoredProcedure, sqlParams);
        }
        public bool ThemThongBao(ref string err,string title,string content,int groupID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@title", title),
                new SqlParameter("@content", content),
                new SqlParameter("@group_ID", groupID)
            };

            return db.MyExecuteNonQuery("insertNotification ", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool CapNhatThongBao(ref string err, int notificationID, string title, string content, int studentGender, int groupID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@notification",notificationID),
                new SqlParameter("@title", title),
                new SqlParameter("@content", content),
                new SqlParameter("@group_ID", groupID)
            };
            return db.MyExecuteNonQuery("updateNotification ", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public bool XoaThongBao(ref string err, int notificationID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@notificationID",notificationID),
            };
            return db.MyExecuteNonQuery("deleteStudent", CommandType.StoredProcedure, ref err, sqlParams);
        }
    }
    

}
