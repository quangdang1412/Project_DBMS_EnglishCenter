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
    public class HomeBLL
    {
        DAL db = null;
        public HomeBLL()
        {
            db = new DAL();
        }
        public int TongSoHocSinh()
        {
            return Convert.ToInt32(db.ExecuteScalar("SELECT COUNT(*) FROM STUDENT", CommandType.Text));
        }



    }
}
