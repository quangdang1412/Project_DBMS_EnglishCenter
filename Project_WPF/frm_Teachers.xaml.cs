using BusinessLayer;
using Project_WPF.UserControls;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
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
using System.Windows.Shapes;
using System.Xml.Linq;

namespace Project_WPF
{
    /// <summary>
    /// Interaction logic for formAdd.xaml
    /// </summary>
    public partial class frm_Teachers : Window
    {
        public frm_Teachers()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
        private void txtDate_LostFocus(object sender, RoutedEventArgs e)
        {
            DateTime parsedDate;
            if (!DateTime.TryParseExact(txtDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsedDate))
            {
                MessageBox.Show("Ngày tháng không hợp lệ. Vui lòng nhập theo định dạng dd/MM/yyyy.");
            }
        }

        public void FillData(DataRowView selectedRow)
        {
        }

        private void btn_save_Click(object sender, RoutedEventArgs e)
        {
            
        }
    }
}
