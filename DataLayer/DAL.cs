using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataLayer
{
	public class DAL
	{
		string ConnStr = "Data Source=localhost;" +
		"Initial Catalog=EnglishCenter;Integrated Security=True;Encrypt=True;TrustServerCertificate=True";  
		SqlConnection conn = null;
		SqlCommand comm = null;
		SqlDataAdapter da = null;
		// Constructor
		public DAL()
		{
			conn = new SqlConnection(ConnStr);
			comm = conn.CreateCommand();
		}
        // Khai bao ham thuc thi tang ket noi
        public DataSet ExecuteQueryDataSet(string strSQL, CommandType ct, params SqlParameter[] p)
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
            conn.Open();
            comm.CommandText = strSQL;
            comm.CommandType = ct;
            comm.Parameters.Clear();

            if (p != null)
            {
                foreach (SqlParameter parameter in p)
                {
                    comm.Parameters.Add(parameter);
                }
            }

            da = new SqlDataAdapter(comm);
            DataSet ds = new DataSet();
            da.Fill(ds);
            conn.Close();
            return ds;
        }

        // Action Query = Insert | Delete | Update | Stored Procedure
        public bool MyExecuteNonQuery(string strSQL, CommandType ct, ref string error, params SqlParameter[] param)
		{
			bool f = false;
			if (conn.State == ConnectionState.Open)
				conn.Close();
			conn.Open();
			comm.Parameters.Clear();
			comm.CommandText = strSQL;
			comm.CommandType = ct;
			foreach (SqlParameter p in param)
			{
                comm.Parameters.Add(p);
            }	
			try
			{
				comm.ExecuteNonQuery();
				f = true;
			}
			catch (SqlException ex)
			{
				error = ex.Message;
			}
			finally
			{
				conn.Close();
			}
			return f;
		}
        public object ExecuteScalar(string strSQL, CommandType ct, params SqlParameter[] param)
        {
            object result = null;
            if (conn.State == ConnectionState.Open)
                conn.Close();

            try
            {
                conn.Open();
                comm.Parameters.Clear();
                comm.CommandText = strSQL;
                comm.CommandType = ct;

                foreach (SqlParameter p in param)
                {
                    comm.Parameters.Add(p);
                }

                result = comm.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw new Exception("Error executing scalar query: " + ex.Message, ex);
            }
            finally
            {
                conn.Close();
            }

            return result;
        }

    }
}
