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
    /// Interaction logic for frm_GroupStudy.xaml
    /// </summary>
    public partial class frm_GroupStudy : Window
    {
        DataTable dtGr;
        ClassBLL dbclass;
        String err = "";

        public frm_GroupStudy()
        {
            InitializeComponent();
            dbclass = new ClassBLL();
            loadData();
        }
        void loadData()
        {
            try
            {
                dtGr = dbclass.LayGroup().Tables[0];

                StudyGrDataGrid.ItemsSource = dtGr.DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
        private void btn_addGroup_Click(object sender, RoutedEventArgs e)
        {
            frm_AddStudyGroup frm = new frm_AddStudyGroup();
            frm.ShowDialog();
            loadData();
        }

        private void btn_editdata_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_deletedata_Click(object sender, RoutedEventArgs e)
        {

        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}
