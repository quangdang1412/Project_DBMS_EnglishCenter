using BusinessLayer;
using Project_WPF.Form;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Project_WPF.UserControls
{
    /// <summary>
    /// Interaction logic for UC_Notification.xaml
    /// </summary>
    public partial class UC_Notification : UserControl
    {
        NotificationBLL notificationBLL= new NotificationBLL();
        DataTable dtNotification= new DataTable();
        int id;
        string content="";
        public UC_Notification(int id)
        {
            InitializeComponent();
            this.id = id;
            loadData();
        }
        void loadData()
        {
            try
            {
                dtNotification = notificationBLL.LayThongBao(id).Tables[0];
                notificationDataGrid.ItemsSource = dtNotification.DefaultView;
            }
            catch (SqlException ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
            DataRowView selectedRow = notificationDataGrid.SelectedItem as DataRowView;
            if (selectedRow != null)
            {
                int notiID = Convert.ToInt32(selectedRow["notification_ID"].ToString());
                getContent(notiID);
            }
        }
        public void getContent(int id )
        {
            content = "";
            object Objcontent = notificationBLL.LayNoiDung(id);
            if(Objcontent != null )
            {
                content= Objcontent.ToString();
            }
            tb_content.Text = content;
        }
        private void btn_add_Notification_Click(object sender, RoutedEventArgs e)
        {
            DataRowView selectedRow = notificationDataGrid.SelectedItem as DataRowView;
            frm_Notification form = new frm_Notification(selectedRow,content);
            form.ShowDialog();
            loadData();
        }
        private void btn_editdata_Click(object sender, RoutedEventArgs e)
        {
            DataRowView selectedRow = notificationDataGrid.SelectedItem as DataRowView;
            if (selectedRow != null)
            {
                int notiID = Convert.ToInt32(selectedRow["notification_ID"].ToString());
                getContent(notiID);
            }
            frm_Notification form = new frm_Notification(selectedRow,content);
            form.FillData(selectedRow);
            form.ShowDialog();
            loadData();
        }
        private void btn_deletedata_Click(Object sender, RoutedEventArgs e)
        {
            string err= "";
            DataRowView selectedRow=(DataRowView) notificationDataGrid.SelectedItem;
            int notiID = Convert.ToInt32((selectedRow)["notification_ID"].ToString());
            bool success = notificationBLL.XoaThongBao(ref err,notiID);
            if(success)
            {
                MessageBox.Show("Đã xóa xong");
            }
            else
            {
                MessageBox.Show(err);
            }
            loadData();
        }

        private void getSelectRow(object sender, MouseButtonEventArgs e)
        {
            DataRowView selectedRow = notificationDataGrid.SelectedItem as DataRowView;
            if(selectedRow != null)
            {
                int notiID = Convert.ToInt32(selectedRow["notification_ID"].ToString());
                getContent(notiID);
            }
            return;
        }
    }
}
