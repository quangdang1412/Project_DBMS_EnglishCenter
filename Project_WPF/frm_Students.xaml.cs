﻿using BusinessLayer;
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
    public partial class frm_Students : Window
    {
        StudentBLL dbstudent;
        bool check = true;
        public frm_Students()
        {
            InitializeComponent();
            dbstudent = new StudentBLL();
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
            
            // Điền dữ liệu từ hàng được chọn vào các điều khiển trên form
            txt_Name.Text = selectedRow["student_name"].ToString();
            txt_Phone.Text = selectedRow["student_phoneNumber"].ToString();
            txtCCCD.Text = selectedRow["identification"].ToString();
            txtDate.Text = Convert.ToDateTime(selectedRow["student_dob"]).ToString("dd/MM/yyyy");
            int gender = Convert.ToInt32(selectedRow["student_gender"]);
            if (gender == 1)
            {
                // Nam
                rbMale.IsChecked = true;
            }
            else
            {
                // Nữ
                rbFemale.IsChecked = true;
            }
            check = false;
        }

        private void btn_save_Click(object sender, RoutedEventArgs e)
        {
            string err = "";
            DateTime studentDob;
            bool ngaythang = DateTime.TryParseExact(txtDate.Text, "dd/mm/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out studentDob);
            int gender = rbMale.IsChecked == true ? 1 : 0;
            if (check==true)
            {
                try
                {
                    bool success = dbstudent.ThemHocSinh(ref err, txt_Name.Text, studentDob, gender, txt_Phone.Text, txtCCCD.Text);
                    if (success)
                    {
                        MessageBox.Show("Đã thêm xong!");
                        this.Close(); 
                    }
                    else
                    {
                        Console.WriteLine(err);
                        MessageBox.Show("Không thêm được!");
                    }
                }
                catch (SqlException)
                {
                    MessageBox.Show("Không thêm được. Đã xảy ra lỗi!");
                }
            }
            else
            {
                MessageBox.Show("update!");
            }
        }
    }
}
