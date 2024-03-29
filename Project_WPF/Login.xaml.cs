using System;
using System.Collections.Generic;
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

namespace Project_WPF
{
	/// <summary>
	/// Interaction logic for Login.xaml
	/// </summary>
	public partial class Login : Window
	{
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
			if (!string.IsNullOrEmpty(textPass.Text) && textPass.Text.Length > 0)
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
			MainWindow mainWindow = new MainWindow();
			mainWindow.Show();
			this.Close();
		}
	}
}
