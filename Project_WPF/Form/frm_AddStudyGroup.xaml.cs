using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics.Eventing.Reader;
using System.Globalization;
using System.Linq;
using System.Runtime.Remoting.Messaging;
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
using BusinessLayer;

namespace Project_WPF.Form
{
    /// <summary>
    /// Interaction logic for frm_AddStudyGroup.xaml
    /// </summary>
    public partial class frm_AddStudyGroup : Window
    {
        Study_GroupBLL dbstudy_GroupBLL;
        DataTable dtStu;
        DataTable dtGroup;
        DataTable dtGV;
        DataTable dtClass;
        DataTable dtStatus;
        DataTable dtCa;
        DataTable dtThu;

        DataTable dtRoom;
        string err = "";
        bool check = true;
        int id;
        public frm_AddStudyGroup()
        {
            InitializeComponent();
            dbstudy_GroupBLL = new Study_GroupBLL();
            LoadGV();
            LoadClass();
            LoadRoom();
            LoadGr_Status();
            LoadShift();
            LoadThu();
        }

        public void LoadGV()
        {
            try
            {
                
                dtGV = dbstudy_GroupBLL.LayTenGV(ref err);
                for (int i=0; i<dtGV.Rows.Count; i++)
                {
                    cb_teacher.Items.Add(dtGV.Rows[i]["teacher_name"]);
                }
            }
            catch (SqlException)
            {
                MessageBox.Show(err);
            }
        }
        public void LoadClass()
        {
            try
            {

                dtClass = dbstudy_GroupBLL.LayTenClass(ref err);
                for (int i = 0; i < dtClass.Rows.Count; i++)
                {
                    cb_class.Items.Add(dtClass.Rows[i]["clname"]);
                }
            }
            catch (SqlException)
            {
                MessageBox.Show(err);
            }
        }
        public void LoadRoom()
        {
            try
            {
                dtRoom = dbstudy_GroupBLL.Room(ref err);
                for (int i = 0; i < dtRoom.Rows.Count; i++)
                {
                    int j = Convert.ToInt32(dtRoom.Rows[i]["room_id"]);
                    cb_room.Items.Add(j);
                }
            }
            catch (SqlException)
            {
                MessageBox.Show(err);
            }
        }
        public void LoadGr_Status()
        {
            try
            {
                dtClass = dbstudy_GroupBLL.GroupStatus(ref err);
                for (int i = 0; i < dtClass.Rows.Count; i++)
                {
                    int row = Convert.ToInt32(dtClass.Rows[i]["grStatus"]);
                    if (row == -1)
                    {
                        cb_status.Items.Add("Cho đăng ký");
                    }
                    else if (row == 0)
                    {
                        cb_status.Items.Add("Đang mở");
                    }
                    else if (row == 1)
                    {
                        cb_status.Items.Add("Lớp đã học xong");
                    }
                }
            }
            catch (SqlException)
            {
                MessageBox.Show(err);
            }
        }
        public void LoadShift()
        {
            try
            {
                dtCa = dbstudy_GroupBLL.Shift(ref err);
                for (int i = 0; i < dtCa.Rows.Count; i++)
                {
                    int j = Convert.ToInt32(dtCa.Rows[i]["shift_id"]);
                    if (j == 1)
                    {
                        cb_shift.Items.Add("17:30 - 19:00");
                    }
                    else if (j == 2)
                    {
                        cb_shift.Items.Add("19:30 - 21:00");
                    }
                    else
                    {
                        check = false;
                    }
                }
            }
            catch (SqlException)
            {
                MessageBox.Show(err);
            }
        }
        public void LoadThu()
        {
            try
            {
                dtThu = dbstudy_GroupBLL.LayIDThu(ref err);
                for (int i = 0; i < dtThu.Rows.Count; i++)
                {
                    int j = Convert.ToInt32(dtThu.Rows[i]["weekday_ID"]);
                    if (j == 1)
                    {
                        cb_week.Items.Add("Chủ nhật");
                    }
                    else if (j == 2)
                    {
                        cb_week.Items.Add("Thứ hai");
                    }
                    else if (j == 3)
                    {
                        cb_week.Items.Add("Thứ ba");
                    }
                    else if (j == 4)
                    {
                        cb_week.Items.Add("Thứ tư");
                    }
                    else if (j == 5)
                    {
                        cb_week.Items.Add("Thứ năm");
                    }
                    else if (j == 6)
                    {
                        cb_week.Items.Add("Thứ sáu");
                    }
                    else if (j == 7)
                    {
                        cb_week.Items.Add("Thứ bảy");
                    }
                    else
                    {
                        check = false;
                    }
                }
            }
            catch
            {
                MessageBox.Show(err);
            }
        }
        public void FillData(DataRowView selectedRow)
        {
            id = Convert.ToInt32(selectedRow["group_ID"]);
            dtGroup=dbstudy_GroupBLL.LayGroup(ref err,id);
            txt_min.Text = dtGroup.Rows[0]["minStudent"].ToString();
            txt_max.Text = dtGroup.Rows[0]["maxStudent"].ToString();
            txt_start.Text= Convert.ToDateTime(dtGroup.Rows[0]["dayStart"]).ToString("dd/MM/yyyy");
            txt_end.Text = Convert.ToDateTime(dtGroup.Rows[0]["dayEnd"]).ToString("dd/MM/yyyy");
            txt_total.Text= dtGroup.Rows[0]["totalStudent"].ToString();
            txt_total.IsEnabled = false;
            cb_class.Text = selectedRow["clname"].ToString();
            cb_teacher.Text = selectedRow["teacher_name"].ToString();
            cb_room.Text = selectedRow["room_ID"].ToString();
            string satus = dtGroup.Rows[0]["grStatus"].ToString();
            int shift = Convert.ToInt32(selectedRow["shift_ID"]);
            if (satus == "-1")
            {
                cb_status.Text = "Cho đăng ký";
            }
            else if (satus == "1") 
            {
                cb_status.Text = "Lớp đã học xong";

            }
            else
            {
                cb_status.Text = "Đang mở";

            }
            if (shift == 1) 
            {
                cb_shift.Text = "17:30 - 19:00";
            }
            else
            {
                cb_shift.Text = "19:30 - 21:00";

            }
            check=false;

        }
        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void btn_save_Click(object sender, RoutedEventArgs e)
        {
            string className = cb_class.Text;
            dtClass = dbstudy_GroupBLL.LayClassID(ref err, className);
            dtGV=dbstudy_GroupBLL.LayTeacherID(ref err, cb_teacher.Text);
            int Cl_id = Convert.ToInt32(dtClass.Rows[0]["class_ID"]);
            int Te_id = Convert.ToInt32(dtGV.Rows[0]["teacher_ID"]);
            int minStu = Convert.ToInt32(txt_min.Text);
            int maxStu = Convert.ToInt32(txt_max.Text);
            DateTime startDate;
            bool start = DateTime.TryParseExact(txt_start.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out startDate);
            DateTime endDate;
            bool end = DateTime.TryParseExact(txt_end.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out endDate);
            int status;
            string textStus = cb_status.Text;
            if (textStus == "Cho đăng ký")
            {
                status = -1;
            }
            else if (textStus == "Lớp đã học xong")
            {
                status = 1;
            }
            else
            {
                status = 0;
            }
            int room_ID = Convert.ToInt32(cb_room.Text);
            int shift_ID;
            if(cb_shift.Text== "17:30 - 19:00")
            {
                shift_ID = 1;

            }
            else
            {
                 shift_ID= 2;
            }
            Dictionary<string, int> ngayThuTu = new Dictionary<string, int>
                {
                    { "Chủ nhật", 1 },
                    { "Thứ hai", 2 },
                    { "Thứ ba", 3 },
                    { "Thứ tư", 4 },
                    { "Thứ năm", 5 },
                    { "Thứ sáu", 6 },
                    { "Thứ bảy", 7 }
                };

            int thu = 0; 
            if (ngayThuTu.ContainsKey(cb_week.Text))
            {
                thu = ngayThuTu[cb_week.Text];
            }
            else
            {
                thu = 1; 
            }

            if (check)
            {

                bool sucess = dbstudy_GroupBLL.InsertStudyGr(ref err,minStu, maxStu, startDate, endDate, status, Te_id, Cl_id, room_ID, shift_ID, thu);
                if (sucess)
                {
                    MessageBox.Show("Đã thêm thành công");
                    this.Close();
                }
                else
                {
                    MessageBox.Show(err);
                }

            }
            else
            {
                bool sucess = dbstudy_GroupBLL.UpdateStudyGroup(ref err, id, minStu, maxStu, startDate, endDate, status, Te_id, Cl_id,room_ID,shift_ID,thu);
                if (sucess)
                {
                    MessageBox.Show("Đã cập nhật thành công");
                    this.Close();

                }
                else
                {
                    MessageBox.Show(err);
                }
            }

        }
    }
}
