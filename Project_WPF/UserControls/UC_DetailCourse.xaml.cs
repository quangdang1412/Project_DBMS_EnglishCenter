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
    public partial class UC_DetailCourse : UserControl
    {
        public UC_DetailCourse()
        {
            InitializeComponent();
        }
        public string ClassName
        {
            get => txt_classname.Text;
            set => txt_classname.Text = value;
        }

        public string ClassID
        {
            get => txt_classID.Text;
            set => txt_classID.Text = value;
        }

        public string TotalDay
        {
            get => txt_Day.Text;
            set => txt_Day.Text = value;
        }
    }
}
