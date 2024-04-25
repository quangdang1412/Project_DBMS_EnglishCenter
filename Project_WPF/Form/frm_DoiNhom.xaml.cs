using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics.Eventing.Reader;
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
using static System.Net.Mime.MediaTypeNames;

namespace Project_WPF.Form
{
    /// <summary>
    /// Interaction logic for frm_DoiNhom.xaml
    /// </summary>
    public partial class frm_DoiNhom : Window
    {
        StudentBLL studentBLL;
        DataTable DataTable;
        string err = "";
        int id;
        bool check = false;
        int gr_id;
        public frm_DoiNhom(int idgr)
        {
            InitializeComponent();
            studentBLL = new StudentBLL();
            gr_id = idgr;
             /// Gọi phương thức LoadData() để tải dữ liệu vào ComboBox khi form được khởi tạo
        }

        // Phương thức để tải dữ liệu vào ComboBox
        //public void LoadData()
        //{
        //    try
        //    {
        //        DataTable = studentBLL.L().Tables[0];

        //        // Clear existing items in the ComboBox
        //        cb_payment.Items.Clear();

        //        // Iterate through each row in the DataTable
        //        foreach (DataRow row in dtStu.Rows)
        //        {
        //            // Get the class_name from the current row
        //            string payment = row["payment_state"].ToString();

        //            // Create a new ComboBoxItem with the class_name as content
        //            ComboBoxItem item = new ComboBoxItem();
        //            item.Content = payment;

        //            // Add the ComboBoxItem to the ComboBox
        //            cb_payment.Items.Add(item);
        //        }
        //    }
        //    catch (SqlException ex)
        //    {
        //        MessageBox.Show("Error: " + ex.Message);
        //    }
        //}

        // Phương thức để điền dữ liệu từ hàng được chọn vào các điều khiển trên form
        public void FillData(DataRowView selectedRow)
        {
            try
            {
                // Điền dữ liệu từ hàng được chọn vào các điều khiển trên form
                txt_ID.Text = Convert.ToInt32(selectedRow["student_ID"]).ToString();
                txt_GroupID.Text = gr_id.ToString();
                txt_FirstScore.Text = Convert.ToInt32(selectedRow["firstScore"]).ToString();
                int payment = Convert.ToInt32(selectedRow["payment_state"]);
                if(payment == 1)
                {
                    cb_payment.Text = "Đã thanh toán";
                }
                else
                {
                    cb_payment.Text = "Chưa thanh toán";
                }
                check = true;

            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }

        private void cb_payment_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (cb_payment.SelectedItem != null)
            {
                ComboBoxItem selectItem = (ComboBoxItem)cb_payment.SelectedItem;
                string selectText = selectItem.Content.ToString();
                if (selectText == "Đã thanh toán")
                {
                    id = 1;
                }
                else if (selectText == "Chưa thanh toán")
                {
                    id = 0;
                }
                check = true;
            }
            else
            {
                check = false;
                MessageBox.Show("Vui lòng chọn trạng thái thanh toán.");
            }
        }

        private void btn_save_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txt_ID.Text) || string.IsNullOrWhiteSpace(txt_GroupID.Text) || string.IsNullOrWhiteSpace(txt_FirstScore.Text))
            {
                MessageBox.Show("Vui lòng điền đầy đủ thông tin vào tất cả các trường.");
                return;
            }
            string err = "";
            int id = Convert.ToInt32(txt_ID.Text);
            int first = Convert.ToInt32(txt_FirstScore.Text);
            int payment = 0;
            if (cb_payment.SelectedItem.ToString() == "Đã thanh toán")
            {
                payment = 1;
            }
            if (check == true)
            {
                try
                {
                    bool success = studentBLL.CapNhatHocSinh2(ref err, id, gr_id, payment, first);
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
                catch (SqlException)
                {
                    MessageBox.Show(err);
                }
            }
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}