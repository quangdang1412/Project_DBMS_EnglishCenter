using Project_WPF.UserControls;
using System;
using System.Collections.Generic;
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

namespace Project_WPF
{
	/// <summary>
	/// Interaction logic for MainWindow.xaml
	/// </summary>
	public partial class MainWindow : Window
	{
		public MainWindow()
		{
			InitializeComponent();
		}
		private void Window_Loaded(object sender, RoutedEventArgs e)
		{
			this.Top = 0;
			this.Left = 0;
			this.Width = SystemParameters.WorkArea.Width;
			this.Height = SystemParameters.WorkArea.Height;
			btn_Home.Focus();
		}

		private void btn_Home_Click(object sender, RoutedEventArgs e)
		{
			UC_Home ucHome = new UC_Home(); // Tạo một instance của UserControl
			MainGrid.Children.Clear(); // Xóa tất cả các UserControl hiện tại
			MainGrid.Children.Add(ucHome);
		}

		private void btn_Teacher_Click(object sender, RoutedEventArgs e)
		{
			UC_Teacher ucTeacher = new UC_Teacher(); // Tạo một instance của UserControl
			MainGrid.Children.Clear(); // Xóa tất cả các UserControl hiện tại
			MainGrid.Children.Add(ucTeacher);
		}

		private void btn_Student_Click(object sender, RoutedEventArgs e)
		{
			UC_Student ucStudent = new UC_Student(); // Tạo một instance của UserControl
			MainGrid.Children.Clear(); // Xóa tất cả các UserControl hiện tại
			MainGrid.Children.Add(ucStudent);
		}

        private void btn_exit_Click(object sender, RoutedEventArgs e)
        {
			this.Close();
        }
        private void btn_course_Click(object sender, RoutedEventArgs e)
        {
            UC_Course ucCourse = new UC_Course(); // Tạo một instance của UserControl
            MainGrid.Children.Clear(); // Xóa tất cả các UserControl hiện tại
            MainGrid.Children.Add(ucCourse);
        }

        private new void GotFocus(object sender, RoutedEventArgs e)
        {
            Button button = sender as Button;
            button.Background = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#7b5cd6"));
        }

        private new void LostFocus(object sender, RoutedEventArgs e)
        {
            Button button = sender as Button;
            button.Background = Brushes.Transparent;
        }

        private void btn_studygroup_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_classroom_Click(object sender, RoutedEventArgs e)
        {
            UC_Class uC_Class = new UC_Class(); // Tạo một instance của UserControl
            MainGrid.Children.Clear(); // Xóa tất cả các UserControl hiện tại
            MainGrid.Children.Add(uC_Class);
        }

        private void account_MouseEnter(object sender, MouseEventArgs e)
        {
            UC_DetailAccount.Visibility = Visibility.Visible;
        }

        private void account_MouseLeave(object sender, MouseEventArgs e)
        {
            UC_DetailAccount.Visibility = Visibility.Collapsed;

        }
    }
}
