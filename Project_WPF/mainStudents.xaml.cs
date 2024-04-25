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
using System.Windows.Shapes;
using MaterialDesignThemes.Wpf;
using Project_WPF.UserControls;

namespace Project_WPF
{
    /// <summary>
    /// Interaction logic for mainTeachers.xaml
    /// </summary>
    public partial class mainStudents : Window
    {
        string student_name;
        int ID;
        public mainStudents(int ID, string student_name)
        {
            this.ID = ID;
            this.student_name = student_name;
            InitializeComponent();
            tb_StudentName.Text = student_name;
            loadData();
        }
        void loadData()
        {
            UC_Stu_Home uC_Stu_Home = new UC_Stu_Home(ID);
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

        private void btn_exit_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
        private void btn_info_Click(object sender, RoutedEventArgs e)
        {
            UC_Stu_Info  UC_Info = new UC_Stu_Info(); // Tạo một instance của UserControl
            MainGrid.Children.Clear();
            MainGrid.Children.Add(UC_Info);
        }

        private void btn_Notify_Click(object sender, RoutedEventArgs e)
        {
            UC_Stu_Notify uC_Stu_Notify = new UC_Stu_Notify(ID);
            MainGrid.Children.Clear();
            MainGrid.Children.Add(uC_Stu_Notify);
        }

        private void btn_Home_Click(object sender, RoutedEventArgs e)
        {
            UC_Stu_Home uC_Stu_Home=new UC_Stu_Home(ID);
            MainGrid.Children.Clear();
            MainGrid.Children.Add(uC_Stu_Home);
        }
    }
}
