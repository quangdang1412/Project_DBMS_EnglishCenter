using BusinessLayer;
using System;
using System.Collections.Generic;
using System.Data;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Project_WPF.UserControls
{
    /// <summary>
    /// Interaction logic for UC_TeacherInformation.xaml
    /// </summary>
    public partial class UC_TeacherInformation : UserControl
    {
        TeacherBLL teacherBLL = new TeacherBLL();
        public UC_TeacherInformation(int id)
        {
            InitializeComponent();
            string err = "";
            txt_ID.Text = id.ToString();
            DataTable dt = teacherBLL.TimKiemGiaoVienTheoID(ref err,id);
            if (dt.Rows.Count > 0)
            {
                txt_Name.Text = dt.Rows[0]["teacher_name"].ToString();
                txt_Date.Text = dt.Rows[0]["teacher_dob"].ToString();
                if (dt.Rows[0]["gender"].ToString()=="1")
                {
                    rbMale.IsChecked = true;
                }
                else
                {
                    rbFemale.IsChecked= true;
                }
                txt_phoneNumber.Text = dt.Rows[0]["teacher_phoneNumber"].ToString();
                txt_Address.Text = dt.Rows[0]["teacher_address"].ToString();
                txt_Identification.Text = dt.Rows[0]["identification"].ToString();
                txt_Email.Text = dt.Rows[0]["email"].ToString();
            }
        }
        void checkInfo(string err)
        {
            if (err.Contains("chk_teacherIdentify"))
            {
                MessageBox.Show("Vui lòng nhập vào 12 số cho CCCD.");
            }
        }
        void checkphoneNumber(string err)
        {
            if (err.Contains("chk_studentPhoneNumber"))
            {
                MessageBox.Show("Vui lòng nhập vào 10 số cho Số điện thoại.");
            }
        }
        private void btn_cancel_Click(object sender, RoutedEventArgs e)
        {
            return;
        }
        private void btn_save_Click(object sender, RoutedEventArgs e)
        {

        }
    }
}
