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

namespace Project_WPF.Form
{
    /// <summary>
    /// Interaction logic for frm_Group.xaml
    /// </summary>
    public partial class frm_Group : Window
    {
        public frm_Group()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void btn_editdata_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_deletedata_Click(object sender, RoutedEventArgs e)
        {

        }
    }
}
