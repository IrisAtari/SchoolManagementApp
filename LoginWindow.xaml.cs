using SchoolManagementApp.Models;
using System.Security.Cryptography;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace StudyManagementWpfApp
{
    /// <summary>
    /// Interaction logic for LoginWindow.xaml
    /// </summary>
    public partial class LoginWindow : Window
    {
        public LoginWindow()
        {
            InitializeComponent();


        }

        QuanLyGiangDuongContext dbContext = new QuanLyGiangDuongContext();

        //xử lý sự kiện nhấn nút đăng nhập
        //private void btnDangNhap_Click(object sender, RoutedEventArgs e)
        //{
        //    //đảm bảo tên tk và mk không trống
        //    if (txtBoxAccName.Text == string.Empty || txtBoxPassword.Password == string.Empty)
        //    {
        //        MessageBox.Show("Tài khoản và mật khẩu không được để trống!","Lỗi!", MessageBoxButton.OK, MessageBoxImage.Warning);
        //    }
        //    else
        //    {
        //        //truy vấn dữ liệu
        //        //var query =  from listAcc in dbContext.TaiKhoanNguoiDungs
        //        //             where listAcc.TenNguoiDung == txtBoxAccName.Text
        //        //             select listAcc;
        //        var tkDangNhap = dbContext.TaiKhoanNguoiDungs.SingleOrDefault(tk => tk.TenNguoiDung ==  txtBoxAccName.Text);
        //        if (tkDangNhap == null)
        //        {
        //            MessageBox.Show("Tài khoản sai hoặc không tồn tại!", "Lỗi!", MessageBoxButton.OK, MessageBoxImage.Warning);
        //            return;
        //        }

        //        //Tạo hash từ passwordbox
        //        byte[] key = new byte[64];
        //        using (SHA512 sha512 = SHA512.Create())
        //        {
        //            byte[] hash = sha512.ComputeHash(System.Text.Encoding.UTF8.GetBytes(txtBoxPassword.Password));
        //            Array.Copy(hash, key, 64);
        //        }
        //        //So sánh chuỗi bit tạo từ hash với hash được lưu trữ trên csdl
        //        int bitIndex = 0;
        //        do
        //        {
        //            if (tkDangNhap.HashMatKhau[bitIndex] != key[bitIndex])
        //            {
        //                MessageBox.Show("Mật khẩu không chính xác!", "Lỗi!", MessageBoxButton.OK, MessageBoxImage.Warning);
        //                return;
        //            }
        //            bitIndex++;
        //        }
        //        while (bitIndex<63);
                
        //        MessageBox.Show("Đăng nhập thành công!", "Thành công!", MessageBoxButton.OK, MessageBoxImage.Information);
                
        //    }
            
        //}

        //Xử lý sự kiện nút đăng ký
        private void btnDangKy_Click(object sender, RoutedEventArgs e)
        {
            //var tkSua = dbContext.TaiKhoanNguoiDungs.SingleOrDefault(tk => tk.TenNguoiDung == txtBoxAccName.Text);
            //if (tkSua == null)
            //{
            //    MessageBox.Show("Tài khoản sai hoặc không tồn tại!", "Lỗi!", MessageBoxButton.OK, MessageBoxImage.Warning);
            //    return;
            //}
            //if (txtBoxPassword.Password ==  string.Empty)
            //{
            //    return;
            //}
            ////Tạo hash từ passwordbox
            //byte[] key = new byte[64];
            //using (SHA512 sha512 = SHA512.Create())
            //{
            //    byte[] hash = sha512.ComputeHash(System.Text.Encoding.UTF8.GetBytes(txtBoxPassword.Password));
            //    Array.Copy(hash, key, 64);
            //}

            //tkSua.HashMatKhau = key;
            //dbContext.SaveChanges();
        }
    }
}