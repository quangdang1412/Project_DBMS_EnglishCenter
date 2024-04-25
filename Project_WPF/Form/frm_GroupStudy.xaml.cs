using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
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
    /// Interaction logic for frm_GroupStudy.xaml
    /// </summary>
    public partial class frm_GroupStudy : Window
    {
        DataTable dtGr;
        ClassBLL dbclass;
        String err = "";

        public frm_GroupStudy()
        {
            InitializeComponent();
            dbclass = new ClassBLL();
            loadData();
        }
        void loadData()
        {
            try
            {
                dtGr = dbclass.LayGroup().Tables[0];

                StudyGrDataGrid.ItemsSource = dtGr.DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
        private void btn_addGroup_Click(object sender, RoutedEventArgs e)
        {
            frm_AddStudyGroup frm = new frm_AddStudyGroup();
            frm.ShowDialog();
            loadData();
        }

        private void btn_editdata_Click(object sender, RoutedEventArgs e)
        {
            DataRowView selectedRow = (DataRowView)StudyGrDataGrid.SelectedItem;
            // Tạo một instance của form frm_Students
            frm_AddStudyGroup editStudentForm = new frm_AddStudyGroup();

            // Truyền dữ liệu từ hàng được chọn vào form
            editStudentForm.FillData(selectedRow);

            // Hiển thị form để chỉnh sửa thông tin
            editStudentForm.ShowDialog();

            loadData();
        }

        private void btn_deletedata_Click(object sender, RoutedEventArgs e)
        {
            DataRowView selectedRow = (DataRowView)StudyGrDataGrid.SelectedItem;
            // Lấy giá trị của cột ID từ hàng được chọn
            int id = Convert.ToInt32(selectedRow["group_ID"]);
            MessageBox.Show(id.ToString());
            bool success = dbclass.XoaNhom(ref err, id);
            if (success)
            {
                MessageBox.Show("Đã xoá xong!");
            }
            else
            {
                MessageBox.Show(err);
            }
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}
