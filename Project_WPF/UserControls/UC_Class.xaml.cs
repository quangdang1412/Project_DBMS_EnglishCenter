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
        DataTable dtGroupFind;
        DataTable dtTotal;
        String err = "";
        public ObservableCollection<string> ChartLabels { get; set; }
        public decimal maxChart { get; set; }
        public SeriesCollection ChartSeries { get; set; }



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
                int classID = Convert.ToInt32(dtClass.Rows[0]["class_ID"]);
                findGroup(classID);
            }
            catch (SqlException ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
        private void btn_addclass_Click(object sender, RoutedEventArgs e)
        {
            frm_Class frm = new frm_Class();
            frm.ShowDialog();
            loadData();
        }
       
        private void btn_editdata_Click(object sender, RoutedEventArgs e)
        {
            // Lấy hàng được chọn từ DataGrid
            DataRowView selectedRow = (DataRowView)ClassDataGrid.SelectedItem;
            // Tạo một instance của form frm_Students
            frm_Class editClassForm = new frm_Class();

            // Truyền dữ liệu từ hàng được chọn vào form
            editClassForm.FillData(selectedRow);

            // Hiển thị form để chỉnh sửa thông tin
            editClassForm.ShowDialog();

            loadData();
        }


        private void btn_deletedata_Click(object sender, RoutedEventArgs e)
        {
            // Lấy hàng được chọn từ DataGrid
            DataRowView selectedRow = (DataRowView)ClassDataGrid.SelectedItem;

            // Lấy giá trị của cột ID từ hàng được chọn
            int id = Convert.ToInt32(selectedRow["class_ID"]);

            // Thực hiện xoá học sinh
            string err = "";
            bool success = dbclass.XoaClass(ref err, id);
            if (success)
            {
                MessageBox.Show("Đã xoá xong!");
            }
            else
            {
                Console.WriteLine(err);
                MessageBox.Show(err);
            }
            loadData();
        }
        public void LoadChartData()
        {
            ChartLabels = new ObservableCollection<string>();
            ChartSeries = new SeriesCollection();
            decimal maxTotal = decimal.MinValue;

            if (dtClass != null)
            {
                foreach (DataRow row in dtClass.Rows)
                {
                    var id = row["class_ID"].ToString();
                    int classID = Convert.ToInt32(id);
                    dtTotal = dbclass.TotalIncome(ref err,classID);

                    decimal total = Convert.ToDecimal(dtTotal.Rows[0]["total"]);
                    total = total / 1000000;

                    if (total > maxTotal)
                    {
                        maxTotal = total;
                    }

                    ChartLabels.Add(id);
                    ChartValues<decimal> chartValues = new ChartValues<decimal> { total };

                    foreach (var value in chartValues)
                    {
                        Console.WriteLine(value);
                    }
                    ChartSeries.Add(new ColumnSeries
                    {
                        Title = "Doanh thu: ",
                        Values = chartValues
                    });
                }
                maxChart = maxTotal;
            }
        }





        public void findGroup(int x)
        {
            try
            {
                dtGroupFind = dbclass.FindGroup(ref err,x);
                stackPanelContainer.Children.Clear();
                AddDetailCalendarDynamically(dtGroupFind.Rows.Count);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void AddDetailCalendarDynamically(int x)
        {
            for (int i = 0; i < x; i++)
            {
                DataRow row = dtGroupFind.Rows[i];

                UC_DetailClass detailCalendar = new UC_DetailClass();

                detailCalendar.TeacherName = row["teacher_name"].ToString();
                detailCalendar.GroupID = "Nhóm " + row["group_ID"].ToString();
                string fullTime = row["studyShift"].ToString();
                detailCalendar.Time = XuliTime(fullTime);

                detailCalendar.Total = row["totalStudent"].ToString() + " students";
                detailCalendar.Margin = new Thickness(0, 10, 0, 20);

                stackPanelContainer.Children.Add(detailCalendar);
            }
        }
        public string XuliTime(string input)
        {
            int spaceIndex = input.IndexOf(' ');
            int dashIndex = input.IndexOf('-');
            
            string startTime = input.Substring(0, dashIndex).Trim();

            string endTime = input.Substring(dashIndex + 1).Trim();
            string formattedTimeRange = $"{startTime.Substring(0, 5)} - {endTime.Substring(0, 5)}";
            return formattedTimeRange;
        }

        private void ClassDataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (ClassDataGrid.SelectedItem is DataRowView selectedRow)
            {
                int classID = Convert.ToInt32(selectedRow["class_ID"]);
                findGroup(classID);
            }
        }
    }
}
