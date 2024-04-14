using Project_WPF.Form;
using System;
using System.Collections.Generic;
using System.Data;
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
    /// Interaction logic for UC_Class.xaml
    /// </summary>
    public partial class UC_Class : UserControl
    {
        public UC_Class()
        {
            InitializeComponent();
        }

        private void btn_addclass_Click(object sender, RoutedEventArgs e)
        {

        }
        private void SearchBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(SearchBox.Text))
            {
                Placeholder.Visibility = Visibility.Visible;
            }
            else
            {
                Placeholder.Visibility = Visibility.Collapsed;
            }
        }
        private void btn_editdata_Click(object sender, RoutedEventArgs e)
        {

        }


        private void btn_deletedata_Click(object sender, RoutedEventArgs e)
        {

        }
    }
}
