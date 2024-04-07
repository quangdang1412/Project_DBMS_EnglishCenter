using Project_WPF.UserControls;
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
using System.Windows.Shapes;
using System.Xml.Linq;

namespace Project_WPF
{
    /// <summary>
    /// Interaction logic for formAdd.xaml
    /// </summary>
    public partial class frm_Students : Window
    {

        public frm_Students()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
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
        }
    }
}
