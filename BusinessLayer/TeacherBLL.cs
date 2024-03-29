using DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
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
	}
}
