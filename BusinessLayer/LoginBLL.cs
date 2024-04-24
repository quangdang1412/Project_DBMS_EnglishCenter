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
    public class LoginBLL
    {
        DAL db = null;
        public LoginBLL()
        {
            db = new DAL();
        }
        public bool checkConn(ref string err, string user, string pass)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@account", user),
                new SqlParameter("@password", pass),
            };

            return db.MyExecuteNonQuery("accountLogin", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataTable Login_pre(ref string err, string user, string pass)
        {
            SqlParameter[] sqlParams =
             {
                new SqlParameter("@account", user),
                new SqlParameter("@password", pass),
            };

            return db.ExecuteQueryDataTable("accountLogin", CommandType.StoredProcedure, ref err,sqlParams);
        }
    }
}
