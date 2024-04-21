using BusinessLayer;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows;

namespace Project_WPF.Form
{
    public partial class frm_Group : Window
    {
        public string groupID { get; set; }
        int groupIDInt;
        DataTable dtClassStudent;
        DataTable dtClassTeacher;

        ClassBLL dbclass;
        String err = "";
        public frm_Group()
        {
            InitializeComponent();
            dbclass = new ClassBLL();
            

        }
        public void UpdateGroupID(string id)
        {
            groupID = id;
            groupIDInt = Convert.ToInt32(id);
            loadDataStudents(groupIDInt);
            loadDataTeachers(groupIDInt);
        }
        public void loadDataStudents(int x)
        {
            try
            {
                dtClassStudent = dbclass.FindStudentsByGroup(ref err, x);

                StudentsDataGrid.ItemsSource = dtClassStudent.DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
        public void loadDataTeachers(int x)
        {
            try
            {
                dtClassTeacher = dbclass.FindTeachersByGroup(ref err, x);
                txt_class.Text = dtClassTeacher.Rows[0]["classname"].ToString()  + " " + x;
                txt_TeacherName.Text ="GV: " + dtClassTeacher.Rows[0]["teacherName"].ToString();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }



        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
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

            loadDataStudents(groupIDInt);
        }

        private void btn_deletedata_Click(object sender, RoutedEventArgs e)
        {
            DataRowView selectedRow = (DataRowView)StudentsDataGrid.SelectedItem;
            // Lấy giá trị của cột ID từ hàng được chọn
            int id = Convert.ToInt32(selectedRow["student_ID"]);

            // Thực hiện xoá học sinh
            string err = "";
            bool success = dbclass.XoaHocSinh(ref err, id,groupIDInt);
            if (success)
            {
                MessageBox.Show("Đã xoá xong!");
            }
            else
            {
                Console.WriteLine(err);
                MessageBox.Show("Không xoá được!" + err);
            }
            loadDataStudents(groupIDInt);

        }

        private void btn_addstudent_Click(object sender, RoutedEventArgs e)
        {
            frm_Students form = new frm_Students();
            form.ShowDialog();
            loadDataStudents(groupIDInt);
        }
    }

}
