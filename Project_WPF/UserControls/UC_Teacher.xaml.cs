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
			string keyword=txt_search.Text;
			try
			{
				dtTeacher = dbteacher.LayGV(keyword).Tables[0];

				TeachersDataGrid.ItemsSource = dtTeacher.DefaultView;
			}
			catch (SqlException ex)
			{
				MessageBox.Show("Error: " + ex.Message);
			}
		}

		private void SearchBox_TextChanged(object sender, TextChangedEventArgs e)
		{
			loadData();
			if (string.IsNullOrWhiteSpace(SearchBox.Text))
			{
				txt_search.Visibility = Visibility.Visible;
			}
			else
			{
				txt_search.Visibility = Visibility.Collapsed;
			}
		}

        private void btn_addTeacher_Click(object sender, RoutedEventArgs e)
        {

        }

    }
}
