using BusinessLayer;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows;
using System.Windows.Controls;

namespace Project_WPF.UserControls
{
	public partial class UC_Teacher : UserControl
	{
		TeacherBLL dbteacher;
		DataTable dtTeacher;

		public UC_Teacher()
		{
			InitializeComponent();
			dbteacher = new TeacherBLL(); 
			loadData();
		}

		void loadData()
		{
			try
			{
				dtTeacher = dbteacher.LayGV().Tables[0];

				TeachersDataGrid.ItemsSource = dtTeacher.DefaultView;
			}
			catch (SqlException ex)
			{
				MessageBox.Show("Error: " + ex.Message);
			}
		}

		private void SearchBox_TextChanged(object sender, TextChangedEventArgs e)
		{
			if (string.IsNullOrWhiteSpace(SearchBox.Text))
			{
				Placeholder.Visibility = Visibility.Visible;
			}
			else
			{
				Placeholder.Visibility = Visibility.Collapsed;
			}
		}
	}
}
