using BusinessLayer;
using System;
using System.Collections.Generic;
using System.Data;
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
    /// Interaction logic for UC_Stu_Home.xaml
    /// </summary>
    public partial class UC_Tea_Home : UserControl
    {
        TeacherBLL dbTeacher;
        DataTable dtGroupFind;
        DataTable dtGroup;
        string err = "";
        int student_ID;
        int gr_ID;

        public UC_Tea_Home(int ID)
        {
            dbTeacher = new TeacherBLL();
            InitializeComponent();
            student_ID = ID;
            LoadData();
            calender.SelectedDate = DateTime.Now;
            string dayOfWeek = DateTime.Today.ToString("dddd", new CultureInfo("en"));
            textThu.Text = dayOfWeek;
        }
        void LoadData()
        {
            dtGroup = dbTeacher.GetGroupID(ref err, student_ID);
            var groupID = dtGroup.Rows[0]["group_ID"].ToString();
            gr_ID = Convert.ToInt32(groupID);
        }
        private void Calendar_SelectedDatesChanged(object sender, SelectionChangedEventArgs e)
        {
            // Kiểm tra xem có ngày nào được chọn không
            if (calender.SelectedDate.HasValue)
            {
                // Định dạng phần ngày được chọn và đặt nó làm text cho TextBlock
                textDay.Text = calender.SelectedDate.Value.Day.ToString();
                convertMonth(calender.SelectedDate.Value.Month);
                string dayOfWeek = calender.SelectedDate.Value.ToString("dddd", new CultureInfo("en"));
                textThu.Text = dayOfWeek;

                DayOfWeek selectedDayOfWeek = calender.SelectedDate.Value.DayOfWeek;
                // Chuyển đổi từ DayOfWeek sang số nguyên (int)
                int selectedDayInt = (int)selectedDayOfWeek + 1;
                findGroup(gr_ID, selectedDayInt);
            }
        }

        private void convertMonth(int x)
        {
            if (x == 1)
            {
                textMonth.Text = "January";
            }
            else if (x == 2)
            {
                textMonth.Text = "February";

            }
            else if (x == 3)
            {
                textMonth.Text = "March";
            }
            else if (x == 4)
            {
                textMonth.Text = "April";
            }
            else if (x == 5)
            {
                textMonth.Text = "May";
            }
            else if (x == 6)
            {
                textMonth.Text = "June";
            }
            else if (x == 7)
            {
                textMonth.Text = "July";
            }
            else if (x == 8)
            {
                textMonth.Text = "August";
            }
            else if (x == 9)
            {
                textMonth.Text = "September";
            }
            else if (x == 10)
            {
                textMonth.Text = "October";
            }
            else if (x == 11)
            {
                textMonth.Text = "November";
            }
            else
            {
                textMonth.Text = "December";
            }
        }
        public void findGroup(int id, int week)
        {
            try
            {
                dtGroupFind = dbTeacher.ScheduleTeacher(ref err, id, week);
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
                detailStudent.ClassName = row["clname"].ToString();
                detailStudent.GroupID = "Nhóm " + row["group_ID"].ToString();
                string fullTime = row["shift"].ToString();
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
    }
}
