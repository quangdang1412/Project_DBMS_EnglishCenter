using Project_WPF.Data;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
	/// Interaction logic for UC_Home.xaml
	/// </summary>
	public partial class UC_Teacher : UserControl
	{
		public UC_Teacher()
		{
			InitializeComponent();
			var converter = new BrushConverter();
			ObservableCollection<Teacher> teachers = new ObservableCollection<Teacher>();
			teachers.Add(new Teacher { teacherID = "T001", teacherName = "Nguyen Van A", Phone = "0901234567", Gender = "Male", Email = "nguyenvana@example.com" });
			teachers.Add(new Teacher { teacherID = "T002", teacherName = "Tran Thi B", Phone = "0901234568", Gender = "Female", Email = "tranthib@example.com" });
			teachers.Add(new Teacher { teacherID = "T003", teacherName = "Le Van C", Phone = "0901234569", Gender = "Male", Email = "levanc@example.com" });
			TeachersDataGrid.ItemsSource = teachers;

		}
		private void SearchBox_TextChanged(object sender, TextChangedEventArgs e)
		{
			if (string.IsNullOrWhiteSpace(SearchBox.Text))
			{
				Placeholder.Visibility = Visibility.Visible;
			}
			else
			{
				Placeholder.Visibility = Visibility.Collapsed;
			}
		}
	}
}
