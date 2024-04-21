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
using BusinessLayer;


namespace Project_WPF.UserControls
{
	/// <summary>
	/// Interaction logic for UC_Home.xaml
	/// </summary>
	public partial class UC_Home : UserControl
	{
		HomeBLL home;
		DataTable dtDay;
		String err = "";
        public UC_Home()
		{
			home= new HomeBLL();
			InitializeComponent();
			calender.SelectedDate = DateTime.Now;
			string dayOfWeek = DateTime.Today.ToString("dddd", new CultureInfo("en"));
			textThu.Text = dayOfWeek;
			Total();


        }
		public void Total()
		{
			txt_Students.Text = home.TongSoHocSinh().ToString();
            txt_Teacher.Text = home.TongSoGiaoVien().ToString();
            txt_Group.Text = home.TongSoNhomHoc().ToString();

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
				findDayOfWeek(selectedDayInt);
            }
		}
		
		private void convertMonth(int x)
		{
			if(x==1) {
				textMonth.Text= "January";
			}
			else if(x==2)
			{
				textMonth.Text = "February";

			}
			else if (x == 3)
			{
				textMonth.Text = "March";
			}
			else if(x == 4)
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
		public void findDayOfWeek(int x)
		{
			try
			{
				dtDay = home.layLichHoc(ref err,x);
				stackPanelContainer.Children.Clear();
                AddDetailCalendarDynamically(dtDay.Rows.Count);
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
                DataRow row = dtDay.Rows[i];

                UC_DetailCalendar detailCalendar = new UC_DetailCalendar();

                detailCalendar.ClassName = row["clname"].ToString();
				detailCalendar.GroupID = row["groupID"].ToString();
                string fullTime = row["shift"].ToString();
				detailCalendar.Time = XuliTime(fullTime);

                detailCalendar.Room = row["room"].ToString();
                detailCalendar.Margin = new Thickness(0, 10, 0, 20);

                stackPanelContainer.Children.Add(detailCalendar);
            }
        }
		public string XuliTime(string input)
		{
            int spaceIndex = input.IndexOf(' ');
            int dashIndex = input.IndexOf('-');

            // Lấy phần chuỗi thời gian bắt đầu từ vị trí 0 đến trước dấu gạch nối
            string startTime = input.Substring(0, dashIndex).Trim();

            // Lấy phần chuỗi thời gian kết thúc từ sau dấu gạch nối đến hết chuỗi
            string endTime = input.Substring(dashIndex + 1).Trim();

            // Lấy giờ và phút của thời gian bắt đầu và kết thúc
            string formattedTimeRange = $"{startTime.Substring(0, 5)} - {endTime.Substring(0, 5)}";
			return formattedTimeRange;
        }
    }
}
