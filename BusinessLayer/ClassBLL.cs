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
    }
}
