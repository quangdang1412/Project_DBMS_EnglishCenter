using LiveCharts.Wpf;
using LiveCharts;
using Project_WPF.Form;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection.Emit;
using System.Runtime.Serialization;
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
using BusinessLayer;
using System.Data.SqlClient;
using System.Collections.ObjectModel;

namespace Project_WPF.UserControls
{
    /// <summary>
    /// Interaction logic for UC_Class.xaml
    /// </summary>
    public partial class UC_Class : UserControl
    {
        DataTable dtClass;
        ClassBLL dbclass;
        public ObservableCollection<string> ChartLabels { get; set; }


        public UC_Class()
        {
            InitializeComponent();
            dbclass = new ClassBLL();
            loadData();
            LoadChartData();
            this.DataContext = this;
        }
        void loadData()
        {
            try
            {
                dtClass = dbclass.LayClass().Tables[0];

                ClassDataGrid.ItemsSource = dtClass.DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
        private void btn_addclass_Click(object sender, RoutedEventArgs e)
        {
            UC_Group uC_Group = new UC_Group();
            grid_Change.Children.Clear();
            grid_Change.Children.Add(uC_Group);
        }
       
        private void btn_editdata_Click(object sender, RoutedEventArgs e)
        {

        }


        private void btn_deletedata_Click(object sender, RoutedEventArgs e)
        {

        }
        public void LoadChartData()
        {
            ChartLabels = new ObservableCollection<string>();
            if (dtClass != null)
            {
                foreach (DataRow row in dtClass.Rows)
                {
                    var id = row["class_ID"].ToString();
                    ChartLabels.Add(id);
                }
            }
        }

    }
}
