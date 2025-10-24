using SchoolManagementApp.Models;
using SchoolManagementApp.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;

namespace SchoolManagementApp.ViewModels
{
    public class LoginViewModel : BaseViewModel
    {
        QuanLyGiangDuongContext dbContext = new QuanLyGiangDuongContext();

        public LoginViewModel() 
        {
            //MessageBox.Show("Switch to MVVM");
            //Binding accNameBinding = new Binding("AccName");
            //accNameBinding.Mode = BindingMode.OneWay;
            //accNameBinding.Source = this;

            //BindingOperations.SetBinding()
        
            
        }


    }
}
