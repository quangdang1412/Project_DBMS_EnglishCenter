using BusinessLayer;
using Project_WPF.Form;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
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

namespace Project_WPF.UserControls
{
    /// <summary>
    /// Interaction logic for UC_Attendance.xaml
    /// </summary>
    public partial class UC_Attendance : UserControl
    {
        int teacherID;
        AttendanceBLL attendanceBLL=new AttendanceBLL();
        DataTable dtAttendance=new DataTable();
        DataTable dtStudent = new DataTable();
        int groupID;
        public UC_Attendance(int teacherID)
        {
            InitializeComponent();
            this.teacherID = teacherID;
            loadData();
        }
        private void loadData()
        {
            try
            {
                dtAttendance = attendanceBLL.LayLopGiaoVienDangDay(teacherID).Tables[0];
                attendanceDataGrid.ItemsSource = dtAttendance.DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
        private void btn_view_attendance_Click(object sender, RoutedEventArgs e)
        {
            DataRowView selectedRow = attendanceDataGrid.SelectedItem as DataRowView;
            if (selectedRow != null)
            {
                groupID = Convert.ToInt32((selectedRow)["group_ID"].ToString());
            }
            frm_Attendance form = new frm_Attendance (groupID);
            form.ShowDialog();
        }
        private void btn_add_attendance_Click(object sender,RoutedEventArgs e)
        {
            string err = "";
            bool success = false;
            dtStudent = attendanceBLL.LayHocSinhTheoLop(ref err, groupID);
            foreach (DataRow row in dtStudent.Rows)
            {
                int id = Convert.ToInt32(row["student_ID"]);
                string name = row["student_name"].ToString();
                success = attendanceBLL.TaoBangDiemDanh(ref err, groupID, id, name);
            }
            if (success == false)
            {
                MessageBox.Show(err);
            }
            else
            {
                MessageBox.Show("Đã tạo thành công");
            }
        }
    }

}
