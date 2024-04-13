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
using Project_WPF.Form;


namespace Project_WPF.UserControls
{
    /// <summary>
    /// Interaction logic for UC_Group.xaml
    /// </summary>
    public partial class UC_Group : UserControl
    {
        public UC_Group()
        {
            InitializeComponent();
        }
        private void SearchBox_TextChanged(object sender, TextChangedEventArgs e)
        {

            if (string.IsNullOrWhiteSpace(SearchBox.Text))
            {
                txt_search.Visibility = Visibility.Visible;
            }
            else
            {
                txt_search.Visibility = Visibility.Collapsed;
            }
        }

        private void btn_addTeacher_Click(object sender, RoutedEventArgs e)
        {

        }
    }
}
