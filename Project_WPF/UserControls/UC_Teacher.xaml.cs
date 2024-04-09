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
		void searching()
		{
			Console.WriteLine();
		}
		private void SearchBox_TextChanged(object sender, TextChangedEventArgs e)
		{
			
			if (string.IsNullOrWhiteSpace(SearchBox.Text))
			{
				txt_search.Visibility = Visibility.Visible;
                searching();
            }
			else
			{
				txt_search.Visibility = Visibility.Collapsed;
			}
		}
        private void btn_addTeacher_Click(object sender, RoutedEventArgs e)
        {
			frm_Teachers form = new frm_Teachers();
			form.ShowDialog();
			loadData();
        }
        private void btn_editdata_Click(object sender, RoutedEventArgs e)
        {
            DataRowView selectedRow = (DataRowView)TeachersDataGrid.SelectedItem;
            frm_Teachers editTeacherForm = new frm_Teachers();
            editTeacherForm.FillData(selectedRow);
            editTeacherForm.ShowDialog();
            loadData();
        }
        private void btn_deletedata_Click(object sender, RoutedEventArgs e)
        {
            DataRowView selectedRow = (DataRowView)TeachersDataGrid.SelectedItem;
            int id = Convert.ToInt32(selectedRow["teacher_ID"]);
            string err = "";
            bool success = dbteacher.XoaGiaoVien(ref err, id);
            if (success)
            {
                MessageBox.Show("Đã xoá xong!");
            }
            else
            {
                MessageBox.Show("Không xoá được!");
            }
            loadData();
        }
    }
}
