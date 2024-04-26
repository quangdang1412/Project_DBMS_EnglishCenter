using Project_WPF.UserControls;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
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

namespace Project_WPF
{
    /// <summary>
    /// Interaction logic for mainTeachers.xaml
    /// </summary>
    public partial class mainTeachers : Window
    {
        int ID;
        string teacher_name;
        public mainTeachers(int ID, string teacher_name)
        {
            this.ID = ID;
            this.teacher_name = teacher_name;
            InitializeComponent();
            loadData();
            tb_teacherName.Text = teacher_name;
        }
        void loadData()
        {
            UC_Tea_Home uC_Stu_Home = new UC_Tea_Home(ID);
            MainGrid.Children.Clear();
            MainGrid.Children.Add(uC_Stu_Home);
        }
        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            this.Top = 0;
            this.Left = 0;
            this.Width = SystemParameters.WorkArea.Width;
            this.Height = SystemParameters.WorkArea.Height;
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
        private void btn_information_Click(object sender, RoutedEventArgs e)
        {
            UC_TeacherInformation UC_teacherInformation = new UC_TeacherInformation(ID); // Tạo một instance của UserControl
            MainGrid.Children.Clear();
            MainGrid.Children.Add(UC_teacherInformation);
        }
        private void btn_notification_Click(object sender, RoutedEventArgs e)
        {
            UC_Notification uC_Notification = new UC_Notification(ID); // Tạo một instance của UserControl
            MainGrid.Children.Clear();
            MainGrid.Children.Add(uC_Notification);
        }
        private void btn_teacher_Click(object sender, RoutedEventArgs e)
        {
            UC_TeacherInformation UC_teacherInformation = new UC_TeacherInformation(ID); // Tạo một instance của UserControl
            MainGrid.Children.Clear();
            MainGrid.Children.Add(UC_teacherInformation);
        }
        private void btn_exit_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
        

       

        private void btn_Home_Click_1(object sender, RoutedEventArgs e)
        {
            UC_Tea_Home uC_Tea_Home = new UC_Tea_Home(ID);
            MainGrid.Children.Clear();
            MainGrid.Children.Add(uC_Tea_Home);
        }
    }
}