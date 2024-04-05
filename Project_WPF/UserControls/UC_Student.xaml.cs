using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using BusinessLayer;
using System.Data;
using System.Data.SqlClient;

namespace Project_WPF.UserControls
{
	public partial class UC_Student : UserControl
	{
		StudentBLL dbstudent;
		DataTable dtStudent;
	
		public UC_Student()
		{
			InitializeComponent();
			dbstudent = new StudentBLL();
			loadData();

		}
		void loadData()
		{
			try
			{
				dtStudent = dbstudent.LayHS().Tables[0];

				StudentsDataGrid.ItemsSource = dtStudent.DefaultView;
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

        private void btn_addstudent_Click(object sender, RoutedEventArgs e)
        {
            frm_Students form =new frm_Students();
			form.ShowDialog();
        }
    }
}
