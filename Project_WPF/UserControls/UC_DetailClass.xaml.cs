using MaterialDesignThemes.Wpf;
using Project_WPF.Form;
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

namespace Project_WPF.UserControls
{
    /// <summary>
    /// Interaction logic for UC_DetailCourse.xaml
    /// </summary>
    public partial class UC_DetailClass : UserControl
    {
        public UC_DetailClass()
        {
            InitializeComponent();
        }
        public string TeacherName
        {
            get => txt_Teacher.Text;
            set => txt_Teacher.Text = value;
        }

        public string GroupID
        {
            get => txt_GroupID.Text;
            set => txt_GroupID.Text = value;
        }

        public string Time
        {
            get => txtTime.Text;
            set => txtTime.Text = value;
        }
        public string Total
        {
            get => txtTotalStudents.Text;
            set => txtTotalStudents.Text = value;
        }

        private void btn_more_Click(object sender, RoutedEventArgs e)
        {
            frm_Group frm_Group = new frm_Group();
            frm_Group.ShowDialog();
        }
    }
}