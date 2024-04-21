using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
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
using static MaterialDesignThemes.Wpf.Theme;
using System.Collections.Specialized;
using static MaterialDesignThemes.Wpf.Theme.ToolBar;

namespace Project_WPF.Form
{
    /// <summary>
    /// Interaction logic for frm_Class.xaml
    /// </summary>
    public partial class frm_Class : Window
    {
        ClassBLL ClassBLL;
        DataTable dtClass;
        DataTable dtCourse;

        bool check = true;
        int course_ID;
        String id="";
        string err = "";
        public frm_Class()
        {
            InitializeComponent();
            ClassBLL = new ClassBLL();
            LoadData();
        }

        public void LoadData()
        {
            try
            {
                dtCourse = ClassBLL.LayClassByCourseID().Tables[0];

                // Clear existing items in the ComboBox
                cbo_Khoa.Items.Clear();

                // Iterate through each row in the DataTable
                foreach (DataRow row in dtCourse.Rows)
                {
                    // Get the class_name from the current row
                    string className = row["course_name"].ToString();

                    // Create a new ComboBoxItem with the class_name as content
                    ComboBoxItem item = new ComboBoxItem();
                    item.Content = className;

                    // Add the ComboBoxItem to the ComboBox
                    cbo_Khoa.Items.Add(item);
                }
            }
            catch (SqlException ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }

        public void FillData(DataRowView selectedRow)
        {
            
            // Điền dữ liệu từ hàng được chọn vào các điều khiển trên form
            txt_Name.Text = selectedRow["clname"].ToString();
            txt_Day.Text = selectedRow["totalDay"].ToString();
            txt_Fee.Text = selectedRow["fee"].ToString();
            var idClass= selectedRow["class_ID"].ToString();
            course_ID = Convert.ToInt32(idClass);
            Console.WriteLine(course_ID);
            loadDataCourse(course_ID);
            check =false;
           
        }
        void loadDataCourse(int x)
        {
            try
            {
                dtClass = ClassBLL.selectCourseByClassID(ref err,x);
                string khoa = dtClass.Rows[0]["course_name"].ToString();
                cbo_Khoa.Text = khoa;
                id= dtClass.Rows[0]["course_ID"].ToString();
                Console.WriteLine(id);


            }
            catch(SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void cbo_Khoa_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
           
        }
        void checkFee(string err)
        {
            if (err.Contains("chk_fee"))            
                MessageBox.Show("Vui lòng nhập học phí lớn hơn 0.");           
        }
        void checktotalDay(string err)
        {
            if (err.Contains("chk_totalDay"))
                MessageBox.Show("Vui lòng nhập số buổi học lớn hơn 0.");
        }
        private void btn_save_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txt_Name.Text) || string.IsNullOrWhiteSpace(txt_Day.Text) || string.IsNullOrWhiteSpace(txt_Fee.Text))
            {
                MessageBox.Show("Vui lòng điền đầy đủ thông tin vào tất cả các trường.");
                return;
            }
            Console.WriteLine(check);
            string err = "";
            var totalDay = txt_Day.Text;
            int totalDayInt = Convert.ToInt32(totalDay);
            float floatValue = float.Parse(txt_Fee.Text);



            if (check == true)
            {
                try
                {
                    bool success = ClassBLL.ThemClass(ref err, txt_Name.Text, txt_Day.Text, txt_Fee.Text, id);
                    if (success)
                    {
                        MessageBox.Show("Đã thêm xong!");
                        this.Close();
                    }
                    else
                    {
                        checkFee(err);
                        checktotalDay(err);
                    }
                }
                catch (SqlException)
                {
                    MessageBox.Show(err);
                }
            }
            else
            {
                try
                {
                    bool success = ClassBLL.CapNhatClass(ref err, course_ID, txt_Name.Text, totalDayInt, floatValue, id);
                    if (success)
                    {
                        MessageBox.Show("Đã cập nhật xong!");
                        this.Close();
                    }
                    else
                    {
                        checkFee(err);
                        checktotalDay(err);
                    }
                }
                catch (SqlException)
                {
                    MessageBox.Show(err);
                }
            }
        }

        private void Button_cancel_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }

}
