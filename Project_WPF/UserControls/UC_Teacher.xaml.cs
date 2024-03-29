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
			dbteacher = new TeacherBLL(); // Initialize the TeacherBLL instance

			// Load data when the UserControl is initialized
			loadData();
		}

		void loadData()
		{
			try
			{
				// Assuming LayGV() method returns a DataSet containing teacher data
				dtTeacher = dbteacher.LayGV().Tables[0];

				// Set the ItemsSource of the DataGrid to the DataTable
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
