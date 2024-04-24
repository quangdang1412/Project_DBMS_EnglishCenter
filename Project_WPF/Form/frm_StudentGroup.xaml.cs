using BusinessLayer;
using System;
using System.Collections.Generic;
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

namespace Project_WPF.Form
{
    /// <summary>
    /// Interaction logic for frm_StudentGroup.xaml
    /// </summary>
    public partial class frm_StudentGroup : Window
    {
        StudentBLL dbstudent;
        string err = "";
        int groupID;

        public frm_StudentGroup(int group_ID)
        {
            InitializeComponent();
            dbstudent = new StudentBLL();
            groupID = group_ID;
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Close();

        }

        private void btn_save_Click(object sender, RoutedEventArgs e)
        {


            if (string.IsNullOrWhiteSpace(tbox_Name.Text) || string.IsNullOrWhiteSpace(tb_date.Text) || string.IsNullOrWhiteSpace(tb_sdt.Text) || string.IsNullOrWhiteSpace(tb_cccd.Text))
            {
                MessageBox.Show("Vui lòng điền đầy đủ thông tin vào tất cả các trường.");
                return;
            }

            DateTime studentDob;
            bool ngaythang = DateTime.TryParseExact(tb_date.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out studentDob);

            int gender = rbMale.IsChecked == true ? 1 : 0;
            var first = tb_first.Text;
            int firstScore =Convert.ToInt32(first);

            int payment = cb_payment.SelectedItem != null && ((ComboBoxItem)cb_payment.SelectedItem).Content.ToString() == "Đã thanh toán" ? 1 : 0;

            try
            {
                bool success = dbstudent.ThemHocSinh(ref err, tbox_Name.Text, studentDob, gender, tb_sdt.Text, tb_cccd.Text, groupID, payment, firstScore);
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
    }
}
