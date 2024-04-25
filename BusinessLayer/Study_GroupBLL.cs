using DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class Study_GroupBLL
    {
        DAL db = null;
        public Study_GroupBLL()
        {
            db = new DAL();
        }
        public DataTable LayTenGV(ref string err)
        {
            return db.ExecuteQueryDataTable("select teacher_name from TEACHER ", CommandType.Text, ref err, null);
        }
        public DataTable LayTenClass(ref string err)
        {
            return db.ExecuteQueryDataTable("select clname from CLASS ", CommandType.Text, ref err, null);
        }
        public DataTable LayClassID(ref string err, string className)
        {
            return db.ExecuteQueryDataTable("select class_ID from CLASS where clname = N'" + className + "'", CommandType.Text, ref err, null);
        }

    }
}
