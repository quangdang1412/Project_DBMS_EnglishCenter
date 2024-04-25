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
using BusinessLayer;

namespace Project_WPF.Form
{
    /// <summary>
    /// Interaction logic for frm_AddStudyGroup.xaml
    /// </summary>
    public partial class frm_AddStudyGroup : Window
    {
        Study_GroupBLL dbstudy_GroupBLL;
        DataTable dtStu;
        DataTable dtGV;
        string err = "";
        bool check = true;
        public frm_AddStudyGroup()
        {
            InitializeComponent();
            dbstudy_GroupBLL = new Study_GroupBLL();
            LoadGV();
        }
        
        public void LoadGV()
        {
            try
            {
                
                dtGV = dbstudy_GroupBLL.LayTenGV(ref err);
                for (int i=0; i<dtGV.Rows.Count; i++)
                {
                    cb_teacher.Items.Add(dtGV.Rows[i]["teacher_name"]);
                }
            }
            catch (SqlException)
            {
                MessageBox.Show(err);
            }
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void btn_save_Click(object sender, RoutedEventArgs e)
        {
           
        }
    }
}
