using System;
using System.Collections.Generic;
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
	}
}
