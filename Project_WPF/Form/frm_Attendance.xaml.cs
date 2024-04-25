using BusinessLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using static MaterialDesignThemes.Wpf.Theme;

namespace Project_WPF.Form
{
    /// <summary>
    /// Interaction logic for frm_GroupListxaml
    /// </summary>
    public partial class frm_Attendance : Window
    {
        AttendanceBLL attendanceBLL = new AttendanceBLL();
        DataTable dtAttendance= new DataTable();
        int groupID;
        DateTime schoolDay;
        public frm_Attendance(int groupID)
        {
            InitializeComponent();
            this.groupID = groupID;
            getSchoolDay();
        }
        private void btn_get_attendance_Click(object sender, EventArgs e)
        {
            string err = "";
            if (cbb_schoolDay.SelectedItem != null)
            {
                schoolDay = Convert.ToDateTime(cbb_schoolDay.SelectedItem);
                try
                {
                    attendanceDataGrid.Items.Clear();
                    dtAttendance = attendanceBLL.LayBangDiemDanh(ref err, groupID, schoolDay);
                    foreach (DataRowView rowView in attendanceDataGrid.Items)
                    {
                        int isPresent = Convert.ToInt32(rowView["present"]);
                        if (isPresent == 1)
                        {
                            rowView["present"] = true;
                        }
                        else
                        {
                            rowView["present"] = false;
                        }
                    }
                    if (dtAttendance != null && dtAttendance.Rows.Count > 0)
                    {
                        attendanceDataGrid.ItemsSource = dtAttendance.DefaultView;
                    }
                }
                catch (SqlException)
                {
                    MessageBox.Show(err);
                }
            }
            else
            {
                MessageBox.Show("Vui lòng chọn một ngày học.");
            }
        }
        private void getSchoolDay()
        {
            DataSet dtSchoolDay= new DataSet();
            dtSchoolDay = attendanceBLL.LayNgayHoc();
            foreach(DataRow row in dtSchoolDay.Tables[0].Rows)
            {
                DateTime schoolDay =Convert.ToDateTime(row["school_day"]);
                cbb_schoolDay.Items.Add(schoolDay);
            }
        }
        private void btn_exit_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
        
        private void btn_save_attendance_Click(object obj, RoutedEventArgs e)
        {
            string err = "";
            bool success = false;
            foreach(DataRowView rowView in attendanceDataGrid.Items)
            {
                DataRow row = rowView.Row;
                if (row != null)
                {
                    int present = 0;
                    int studentID = Convert.ToInt32(rowView["student_ID"].ToString());
                    object presentValue = row["present"];
                    bool isChecked = false;
                    if (presentValue != null && presentValue != DBNull.Value)
                    {
                        isChecked = (bool)presentValue;
                    }
                    if(isChecked)
                    {
                        present = 1;
                    }
                    success = attendanceBLL.DiemDanhChoHocSinh(ref err, schoolDay, groupID, studentID, present);
                }
            }
            if (success == false)
            {
                MessageBox.Show(err);
            }
            else
            {
                MessageBox.Show("Đã điểm danh xong");
            }
        }
    }
}
