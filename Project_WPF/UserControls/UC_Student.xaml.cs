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
                Placeholder.Text = "Search here...";
                loadData();

            }
            else
            {
                Placeholder.Text = "";
                string keyword = SearchBox.Text.Trim();
                Console.WriteLine(keyword);
                FilterTeachers(keyword);
            }
        }
        void FilterTeachers(string keyword)
        {
            dtStudent = dbstudent.TimKiemHocSinh(keyword).Tables[0];
            StudentsDataGrid.ItemsSource = dtStudent.DefaultView;
        }

        private void btn_addstudent_Click(object sender, RoutedEventArgs e)
        {
            frm_Students form =new frm_Students();
			form.ShowDialog();
			loadData();
        }

        private void btn_editdata_Click(object sender, RoutedEventArgs e)
        {
            // Lấy hàng được chọn từ DataGrid
            DataRowView selectedRow = (DataRowView)StudentsDataGrid.SelectedItem;
            // Tạo một instance của form frm_Students
            frm_Students editStudentForm = new frm_Students();

            // Truyền dữ liệu từ hàng được chọn vào form
            editStudentForm.FillData(selectedRow);

            // Hiển thị form để chỉnh sửa thông tin
            editStudentForm.ShowDialog();

            loadData();

        }


        private void btn_deletedata_Click(object sender, RoutedEventArgs e)
        {

            // Lấy hàng được chọn từ DataGrid
            DataRowView selectedRow = (DataRowView)StudentsDataGrid.SelectedItem;

            // Lấy giá trị của cột ID từ hàng được chọn
            int id = Convert.ToInt32(selectedRow["student_ID"]);

            // Thực hiện xoá học sinh
            string err = "";
            bool success = dbstudent.XoaHocSinh(ref err, id);
            if (success)
            {
                MessageBox.Show("Đã xoá xong!");
            }
            else
            {
                Console.WriteLine(err);
                MessageBox.Show("Không xoá được!");
            }
            loadData();
        }

    }
}
