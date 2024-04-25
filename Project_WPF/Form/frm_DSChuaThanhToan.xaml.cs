using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
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
using BusinessLayer;

namespace Project_WPF.Form
{
    /// <summary>
    /// Interaction logic for frm_DSChuaThanhToan.xaml
    /// </summary>
    public partial class frm_DSChuaThanhToan : Window
    {
        ClassBLL classBLL;
        DataTable dt = new DataTable();
        public frm_DSChuaThanhToan()
        {
            InitializeComponent();
            classBLL = new ClassBLL();
            loadData();
        }
        void loadData()
        {
            string err = "";
            try
            {
                dt = classBLL.LayDSChuaThanhToan(ref err);
                StudyDataGrid.ItemsSource = dt.DefaultView;
            }
            catch (SqlException)
            {
                MessageBox.Show(err);
            }
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}
