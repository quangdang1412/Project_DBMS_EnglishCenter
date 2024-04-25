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
        DataTable dtClass;
        string err = "";
        bool check = true;
        public frm_AddStudyGroup()
        {
            InitializeComponent();
            dbstudy_GroupBLL = new Study_GroupBLL();
            LoadGV();
            LoadClass();
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
        public void LoadClass()
        {
            try
            {

                dtClass = dbstudy_GroupBLL.LayTenClass(ref err);
                for (int i = 0; i < dtClass.Rows.Count; i++)
                {
                    cb_class.Items.Add(dtClass.Rows[i]["clname"]);
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
            string className = cb_class.Text;
            MessageBox.Show(className);
            dtClass = dbstudy_GroupBLL.LayClassID(ref err, className);
            MessageBox.Show(dtClass.Rows[0]["class_ID"].ToString());
        }
    }
}
