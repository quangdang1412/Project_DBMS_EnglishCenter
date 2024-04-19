using System;
using System.Collections.Generic;
using System.Collections.Specialized;
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
    /// Interaction logic for frm_Course.xaml
    /// </summary>
    public partial class frm_Course : Window
    {
        CourseBLL dbsCourse;
        bool check = true;
        public frm_Course()
        {
            InitializeComponent();
            dbsCourse = new CourseBLL();
        }
        public void FillData(DataRowView selectedRow)
        {
            // Điền dữ liệu từ hàng được chọn vào các điều khiển trên form         
            txt_ID.Text = selectedRow["course_ID"].ToString();
            txt_Ten.Text = selectedRow["course_name"].ToString();             
            check = false;
        }

        

        private void btn_Save_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txt_ID.Text) || string.IsNullOrWhiteSpace(txt_Ten.Text) )
            {
                MessageBox.Show("Vui lòng điền đầy đủ thông tin vào tất cả các trường.");
                return;
            }
            string err = "";                  
            
            if (check == true)
            {
                try
                {
                    bool success = dbsCourse.ThemCourse(ref err, txt_ID.Text, txt_Ten.Text);                       

                    if (success)
                    {
                        MessageBox.Show("Đã thêm xong!");
                        this.Close();
                    }
                    
                }
                catch (SqlException)
                {
                    MessageBox.Show("err");
                }
            }
            else
            {
                bool success = dbsCourse.CapNhatCourse(ref err, txt_ID.Text,txt_Ten.Text);                
                if (success)
                {
                    MessageBox.Show("Đã cập nhật xong!");
                    this.Close();
                }
                
            }
        }

        private void btn_Cancel_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}
