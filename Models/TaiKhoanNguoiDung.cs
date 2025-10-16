using System;
using System.Collections.Generic;

namespace SchoolManagementApp.Models;

public partial class TaiKhoanNguoiDung
{
    public int MaNguoiDung { get; set; }

    public string TenNguoiDung { get; set; } = null!;

    public string? Email { get; set; }

    public string? SDt { get; set; }

    public byte[] HashMatKhau { get; set; } = null!;

    public string? TrangThai { get; set; }

    public int? VaiTromaVt { get; set; }
}
