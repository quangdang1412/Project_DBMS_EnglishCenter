using BusinessLayer;
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

namespace Project_WPF.Form
{
    /// <summary>
    /// Interaction logic for frm_Notification.xaml
    /// </summary>
    public partial class frm_Notification : Window
    {
        NotificationBLL notificationBLL=new NotificationBLL();
        DataRowView selectedRow;
        int notiID;
        int groupID;
        string title;
        string content;
        bool check = true;
        public frm_Notification(DataRowView selectedRow,string content)
        {
            InitializeComponent();
            this.selectedRow = selectedRow;
            this.content = content;
        }
        public void btn_send_Notification_Click(object sender, RoutedEventArgs e)
        {
            string err = "";
            content=txt_Content.Text;
            groupID = Convert.ToInt32(txt_groupID.Text);
            title=txt_Title.Text;
            if (string.IsNullOrWhiteSpace(txt_Title.Text) || string.IsNullOrWhiteSpace(txt_Content.Text))
            {
                MessageBox.Show("Vui lòng điền đầy đủ thông tin vào tất cả các trường.");
                return;
            }
            if(check)
            {
                //Thêm thông báo
                try
                {
                    bool success = notificationBLL.ThemThongBao(ref err, title, content, groupID);
                    if (success)
                    {
                        MessageBox.Show("Đã thêm xong!");
                        this.Close();
                    }
                }
                catch (SqlException)
                {
                    MessageBox.Show(err);
                }
            }
            else
            {
                //Cập nhật thông báo
                try
                {
                    bool success = notificationBLL.CapNhatThongBao(ref err,notiID,title,content,groupID);
                    if (success)
                    {
                        MessageBox.Show("Đã cập nhật xong!");
                        this.Close();
                    }
                }
                catch (SqlException)
                {
                    MessageBox.Show(err);
                }
            }
        }
       public void  FillData(DataRowView selectedRow)
       {
            notiID = Convert.ToInt32((selectedRow)["notification_ID"].ToString());
            groupID = Convert.ToInt32((selectedRow)["group_ID"].ToString());
            title = (selectedRow)["title"].ToString();
            txt_groupID.Text=groupID.ToString();
            txt_Title.Text=title;
            txt_Content.Text=content;
            check = false;
       }
        public void btn_exit_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}
