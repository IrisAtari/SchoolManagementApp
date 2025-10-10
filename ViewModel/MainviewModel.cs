using SchoolManagementApp.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace SchoolManagementApp.ViewModel
{
    public class MainviewModel:BaseViewModel
    {
        public ICommand LoadedWindowCommand { get; set; }
        public bool Isloaded = false;
        public MainviewModel() {
            LoadedWindowCommand = new RelayCommand<object>(
                p =>
                {
                    Isloaded = true;
                    SegisterWindow segisterWindow=new SegisterWindow();
                    segisterWindow.ShowDialog ();
                },
                p => { return true; }
            );

        }

    }
}
