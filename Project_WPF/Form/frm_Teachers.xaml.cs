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

namespace Project_WPF.Form
{
    /// <summary>
    /// Interaction logic for formAdd.xaml
    /// </summary>
    public partial class frm_Teachers : Window
    {
        TeacherBLL dbteacher;
        bool check = true;
        int id = 0;
        public frm_Teachers()
        {
            InitializeComponent();
            dbteacher = new TeacherBLL();
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
            id = Convert.ToInt32(selectedRow["teacher_ID"]);
            Console.WriteLine(id.ToString());
            txt_Name.Text = selectedRow["teacher_name"].ToString();
            txt_Phone.Text = selectedRow["teacher_phoneNumber"].ToString();
            txtCCCD.Text = selectedRow["identification"].ToString();
            txtDate.Text = Convert.ToDateTime(selectedRow["teacher_dob"]).ToString("dd/MM/yyyy");
            int gender = Convert.ToInt32(selectedRow["gender"]);
            if (gender == 1)
            {
                rbMale.IsChecked = true;
            }
            else
            {
                rbFemale.IsChecked = true;
            }
            txtEmail.Text= selectedRow["email"].ToString();
            txtAddress.Text = selectedRow["teacher_address"].ToString();
            check = false;
        }

        private void btn_save_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txt_Name.Text) || string.IsNullOrWhiteSpace(txtDate.Text) || string.IsNullOrWhiteSpace(txt_Phone.Text) || string.IsNullOrWhiteSpace(txtCCCD.Text) || string.IsNullOrWhiteSpace(txtEmail.Text) || string.IsNullOrWhiteSpace(txtAddress.Text))
            {
                MessageBox.Show("Vui lòng điền đầy đủ thông tin vào tất cả các trường.");
                return;
            }
            string err = "";
            DateTime teacherDob;
            bool ngaythang = DateTime.TryParseExact(txtDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out teacherDob);
            int gender = 1;
            if(rbFemale.IsChecked==true)
            {
                gender = 0;
            }
            if (check == true)
            {
                try
                {
                    bool success = dbteacher.ThemGiaoVien(ref err, txt_Name.Text, teacherDob, gender, txt_Phone.Text, txtAddress.Text, txtCCCD.Text, txtEmail.Text);
                    if (success)
                    {
                        MessageBox.Show("Đã thêm xong!");
                        this.Close();
                    }
                    else
                    {
                    MessageBox.Show(err);

                    }
                }
                catch (SqlException)
                {
                    MessageBox.Show(err);

                }
            }
            else
            {
                bool success = dbteacher.CapNhatGiaoVien(ref err, id, txt_Name.Text, teacherDob, gender, txt_Phone.Text, txtAddress.Text, txtCCCD.Text, txtEmail.Text);
                if (success)
                {
                    MessageBox.Show("Đã cập nhật xong!");
                    this.Close();
                }
                else
                {
                    MessageBox.Show(err);
                }
            }
        }
    }
}
