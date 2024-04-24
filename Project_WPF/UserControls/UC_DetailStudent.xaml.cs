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
    /// Interaction logic for UC_DetailStudent.xaml
    /// </summary>
    public partial class UC_DetailStudent : UserControl
    {
        public UC_DetailStudent()
        {
            InitializeComponent();
        }
        public string ClassName
        {
            get => txt_class.Text;
            set => txt_class.Text = value;
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
    }
}
