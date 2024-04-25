using System;
using System.Collections.Generic;
using System.Data.SqlClient;
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
using BusinessLayer;
using Project_WPF.Form;

namespace Project_WPF.UserControls
{
    /// <summary>
    /// Interaction logic for UC_Stu_Notify.xaml
    /// </summary>
    public partial class UC_Stu_Notify : UserControl
    {
        NotificationBLL notifyBLL;
        DataTable dtNotify;
        DataTable dtGroupID;
        int id_Stu;
        public UC_Stu_Notify(int id)
        {
            InitializeComponent();
            notifyBLL = new NotificationBLL();
            id_Stu = id;
            loadData();
            

        }
        void loadData()
        {
            try
            {
                dtGroupID = notifyBLL.LayGroupByStu_ID(id_Stu).Tables[0];
                foreach (DataRow row in dtGroupID.Rows)
                {
                    // Lấy GroupID từ dòng hiện tại
                    int groupID = Convert.ToInt32(row["group_ID"]);

                    // Tìm thông báo tương ứng với GroupID
                    dtNotify = notifyBLL.LayThongBaoByGroupID(groupID).Tables[0];

                    StudentsDataGrid.ItemsSource = dtNotify.DefaultView;
                }
            }
            catch (SqlException ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
        private void NotifyDataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (StudentsDataGrid.SelectedItem is DataRowView selectedRow)
            {
                string notifyID = selectedRow["notification_ID"].ToString();
                int ID = Convert.ToInt32(notifyID);
                dtNotify = notifyBLL.LayNoiDungThongBaoTheoID(ID).Tables[0];
                txt_title.Text = dtNotify.Rows[0]["title"].ToString();
                txt_content.Text = dtNotify.Rows[0]["content"].ToString();
            }
        }
    }
}
