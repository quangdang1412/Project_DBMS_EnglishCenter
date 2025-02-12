﻿using BusinessLayer;
using Microsoft.Xaml.Behaviors.Media;
using Project_WPF.Form;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows;
using System.Windows.Controls;
namespace Project_WPF.UserControls
{
	public partial class UC_Course : UserControl
	{
		DataTable dtb;
        CourseBLL dbcourse;
        DataTable dt_find;
		string err="";
        public UC_Course()
		{
			InitializeComponent();
			dbcourse = new CourseBLL();
			loadData();

        }
        void loadData()
        {
            try
            {
                dtb = dbcourse.LayCourse().Tables[0];

                CourseDataGrid.ItemsSource = dtb.DefaultView;
                string firstCourseID = dtb.Rows[0]["course_ID"].ToString();
                findClass(firstCourseID);
            }
            catch (SqlException ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
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
        private void btn_editdata_Click(object sender, RoutedEventArgs e)
        {
            // Lấy hàng được chọn từ DataGrid
            DataRowView selectedRow = (DataRowView)CourseDataGrid.SelectedItem;
            // Tạo một instance của form frm_Students
            frm_Course editCoursetForm = new frm_Course();

            // Truyền dữ liệu từ hàng được chọn vào form
            editCoursetForm.FillData(selectedRow);

            // Hiển thị form để chỉnh sửa thông tin
            editCoursetForm.ShowDialog();

            loadData();

        }


        private void btn_deletedata_Click(object sender, RoutedEventArgs e)
        {

            // Lấy hàng được chọn từ DataGrid
            DataRowView selectedRow = (DataRowView)CourseDataGrid.SelectedItem;

            // Lấy giá trị của cột ID từ hàng được chọn
            string id = selectedRow["course_ID"].ToString();

            // Thực hiện xoá học sinh
            string err = "";
            bool success = dbcourse.XoaCourse(ref err, id);
            if (success)
            {
                MessageBox.Show("Đã xoá xong!");
            }
            else
            {
                MessageBox.Show(err);
            }
            loadData();
        }

        private void btn_addCourse_Click(object sender, RoutedEventArgs e)
        {
            frm_Course course = new frm_Course();
            course.ShowDialog();
            loadData();
        }

        private void CourseDataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (CourseDataGrid.SelectedItem is DataRowView selectedRow)
            {
                string courseID = selectedRow["course_ID"].ToString();
                findClass(courseID);
            }
        }
        public void findClass(string courseID)
        {
            try
            {
                dt_find = dbcourse.Course_FindClass(ref err,courseID);

                stackPanelContainer.Children.Clear();

                AddDetailCoursesDynamically(dt_find.Rows.Count,courseID);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void AddDetailCoursesDynamically(int x,string courseID)
        {
            for (int i = 0; i < x; i++)
            {
                DataRow row = dt_find.Rows[i];

                UC_DetailCourse detailCourse = new UC_DetailCourse();

                detailCourse.ClassName = row["clname"].ToString();
                detailCourse.ClassID = courseID;
                detailCourse.TotalDay = row["totalDay"].ToString() + " total";
                detailCourse.Margin = new Thickness(0, 10, 0, 20);

                stackPanelContainer.Children.Add(detailCourse);
            }
        }
    }
}
