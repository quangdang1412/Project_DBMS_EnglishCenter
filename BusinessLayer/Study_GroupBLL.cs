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
        public DataTable LayTeacherID(ref string err, string studentName)
        {
            return db.ExecuteQueryDataTable("select teacher_ID from TEACHER where teacher_name = N'" + studentName + "'", CommandType.Text, ref err, null);
        }
        public DataTable LayGroup(ref string err, int groupID)
        {
            return db.ExecuteQueryDataTable("select * from STUDY_GROUP where group_ID = " + groupID, CommandType.Text, ref err, null);
        }
        public DataTable GroupStatus(ref string err)
        {
            return db.ExecuteQueryDataTable("select DISTINCT grStatus from STUDY_GROUP", CommandType.Text, ref err, null);
        }
        public DataTable Room(ref string err)
        {
            return db.ExecuteQueryDataTable("select room_ID from ROOM", CommandType.Text, ref err, null);
        }
        public DataTable Shift(ref string err)
        {
            return db.ExecuteQueryDataTable("select shift_ID from STUDY_SHIFT", CommandType.Text, ref err, null);
        }
        public DataTable LayIDThu(ref string err)
        {
            return db.ExecuteQueryDataTable("select weekday_ID from WEEKDAY", CommandType.Text, ref err, null);
        }
        public bool UpdateStudyGroup(ref string err, int groupID, int minstudent, int maxstudent, DateTime dayStart, DateTime dayEnd, int grStatus, int teacher_ID, int class_ID, int room_ID, int shift_ID, int weekdayID)
        {
            SqlParameter[] sqlParams =
            {
                new SqlParameter("@groupID", groupID),
                new SqlParameter("@minstudent", minstudent),
                new SqlParameter("@maxstudent", maxstudent),
                new SqlParameter("@dayStart", dayStart),
                new SqlParameter("@dayEnd", dayEnd),
                new SqlParameter("@grStatus", grStatus),
                new SqlParameter("@teacher_ID", teacher_ID),
                new SqlParameter("@class_ID", class_ID),
                new SqlParameter("@room_ID", room_ID),
                new SqlParameter("@shift_ID", shift_ID),
                new SqlParameter("@weekdayID", weekdayID)
            };
            return db.MyExecuteNonQuery("updateStudyGr", CommandType.StoredProcedure, ref err, sqlParams);

        }
        public bool InsertStudyGr(ref string err, int min, int max,
            DateTime start, DateTime end, int gr_sta, int teacherID, int class_id,
            int roomid, int shiftid, int weekid)
                {
                    SqlParameter[] sqlParams =
                   {
                new SqlParameter("@minstudent", min),
                new SqlParameter("@maxstudent", max),
                new SqlParameter("@dayStart", start),
                new SqlParameter("@dayEnd", end),
                new SqlParameter("@grStatus",gr_sta),
                new SqlParameter("@teacher_ID", teacherID),
                new SqlParameter("@class_ID",class_id),
                 new SqlParameter("@room_ID", roomid),
                new SqlParameter("@shift_ID", shiftid),
                new SqlParameter("@weekdayID",weekid )
            };
            return db.MyExecuteNonQuery("insertStudyGr", CommandType.StoredProcedure, ref err, sqlParams);
        }
        public DataTable DuaVaoGroupRaWeek(ref string err, int groupID)
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@groupID", groupID),
            };

            return db.ExecuteQueryDataTable("GetWeekdayIDsByGroupID", CommandType.StoredProcedure, ref err, sqlParams);
        }
    }
}
