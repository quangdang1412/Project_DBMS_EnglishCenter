using DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
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
	}
}
