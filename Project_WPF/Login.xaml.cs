using BusinessLayer;
using DataLayer;
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
using static MaterialDesignThemes.Wpf.Theme;

namespace Project_WPF
{
	/// <summary>
	/// Interaction logic for Login.xaml
	/// </summary>
	public partial class Login : Window
	{
		LoginBLL loginBLL = new LoginBLL();
		public Login()
		{
			InitializeComponent();
		}

		private void txtUser_TextChanged(object sender, TextChangedEventArgs e)
		{
			if(!string.IsNullOrEmpty(txtUser.Text) && txtUser.Text.Length > 0)
			{
				textUser.Visibility = Visibility.Collapsed;

			}
			else
			{
				textUser.Visibility= Visibility.Visible;
			}
        }

		private void textUser_MouseDown(object sender, MouseButtonEventArgs e)
		{
			txtUser.Focus();
        }

        private void txtPass_PasswordChanged(object sender, RoutedEventArgs e)
        {
            if (!string.IsNullOrEmpty(txtPass.Password) && txtPass.Password.Length > 0)
            {
                textPass.Visibility = Visibility.Collapsed;
            }
            else
            {
                textPass.Visibility = Visibility.Visible;
            }
        }


        private void textPass_MouseDown(object sender, MouseButtonEventArgs e)
		{
			txtPass.Focus();
		}

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            string quyen = "";
            string err = "";

            DataTable dt = loginBLL.Login_pre(ref err, txtUser.Text, txtPass.Password);

            if (!string.IsNullOrEmpty(err))
            {
                MessageBox.Show(err);
                return;
            }

            if (dt != null && dt.Rows.Count > 0)
            {
                DAL.ConnStrBuilder.UserID = txtUser.Text;
                DAL.ConnStrBuilder.Password = txtPass.Password;
                DAL.ConnStrBuilder.IntegratedSecurity = false;
                MessageBox.Show("Đăng nhập thành công");
                quyen = dt.Rows[0]["permissionName"].ToString();
                if (quyen == "QTV")
                {
                    MainWindow main = new MainWindow();
                    main.Show();
                    this.Hide();
                }
                else if (quyen == "GV")
                {
                    int ID = int.Parse(dt.Rows[0]["ID"].ToString());
                    string name = dt.Rows[0]["userName"].ToString();
                    mainTeachers main = new mainTeachers(ID, name);
                    main.Show();
                    this.Hide();
                }
            }
            else
            {
                MessageBox.Show(err);
            }
        }

    }
}
