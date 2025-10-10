using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace SchoolManagementApp.ViewModel
{
    public class ControlBarViewModel : BaseViewModel
    {
        #region commands
        public ICommand CloseWindowCommand { get; set; }
        public ICommand MaximizeWindowCommand {  get; set; }
        public ICommand MinimizeWindowCommand { get; set; }
        public ICommand MouseMoveWindowCommand { get; set; }

        #endregion 

        public ControlBarViewModel()
        {
            CloseWindowCommand = new RelayCommand<UserControl>(
                p =>
                {
                    var window = GetWindowParent(p);
                    if (window != null)
                    {
                        window.Close();
                    }
                },
                p => p != null && GetWindowParent(p) != null
            );
            MaximizeWindowCommand = new RelayCommand<UserControl>(
               p =>
               {
                   var window = GetWindowParent(p);
                   if (window != null)
                   {
                       if (window.WindowState != WindowState.Maximized)
                           window.WindowState = WindowState.Maximized;
                       else
                           window.WindowState = WindowState.Normal;
                   }
               },
               p => p != null && GetWindowParent(p) != null
           );
            MinimizeWindowCommand = new RelayCommand<UserControl>(
               p =>
               {
                   var window = GetWindowParent(p);
                   if (window != null)
                   {
                       if(window.WindowState != WindowState.Minimized)
                      
                       window.WindowState = WindowState.Minimized;
                      else 
                           window.WindowState = WindowState.Maximized;

                   }
               },
               p => p != null && GetWindowParent(p) != null
           );
            MouseMoveWindowCommand = new RelayCommand<UserControl>(
              p =>
              {
                  var window = GetWindowParent(p);
                  if (window != null)
                  {
                      window.DragMove();
                  }
              },
              p => p != null && GetWindowParent(p) != null
          );
        }

        private Window GetWindowParent(UserControl p)
        {
            if (p == null) return null;

       
            return Window.GetWindow(p);
        }
    }
}

