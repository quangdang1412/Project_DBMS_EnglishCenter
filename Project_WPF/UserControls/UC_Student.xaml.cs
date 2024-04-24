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
using Project_WPF.Form;

namespace Project_WPF.UserControls
{
	public partial class UC_Student : UserControl
	{
		StudentBLL dbstudent;
		DataTable dtStudent;
        DataTable dtGroupFind;
        string err = "";
	
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
                int studentID = Convert.ToInt32(dtStudent.Rows[0]["student_ID"]);

                findGroup(studentID);

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
                FilterStudents(keyword);
            }
        }
        void FilterStudents(string keyword)
        {
            dtStudent = dbstudent.TimKiemHocSinh(keyword).Tables[0];
            StudentsDataGrid.ItemsSource = dtStudent.DefaultView;
        }

        

        private void btn_editdata_Click(object sender, RoutedEventArgs e)
        {
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
                MessageBox.Show(err);
            }
            loadData();
        }
        public void findGroup(int x)
        {
            try
            {
                dtGroupFind = dbstudent.FindGroup(ref err, x);
                stackPanelContainer.Children.Clear();
                AddDetailCalendarDynamically(dtGroupFind.Rows.Count);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void AddDetailCalendarDynamically(int x)
        {
            for (int i = 0; i < x; i++)
            {
                DataRow row = dtGroupFind.Rows[i];

                UC_DetailStudent detailStudent = new UC_DetailStudent();

                detailStudent.ClassName = row["class_name"].ToString();
                detailStudent.GroupID = "Nhóm " + row["group_ID"].ToString();
                string fullTime = row["studyShift"].ToString();
                detailStudent.Time = XuliTime(fullTime);

                detailStudent.Margin = new Thickness(0, 10, 0, 20);

                stackPanelContainer.Children.Add(detailStudent);
            }
        }
        public string XuliTime(string input)
        {
            int spaceIndex = input.IndexOf(' ');
            int dashIndex = input.IndexOf('-');

            string startTime = input.Substring(0, dashIndex).Trim();

            string endTime = input.Substring(dashIndex + 1).Trim();
            string formattedTimeRange = $"{startTime.Substring(0, 5)} - {endTime.Substring(0, 5)}";
            return formattedTimeRange;
        }

        private void StudentsDataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (StudentsDataGrid.SelectedItem is DataRowView selectedRow)
            {
                int studentID = Convert.ToInt32(selectedRow["student_ID"]);
                findGroup(studentID);
            }
        }
    }
}
