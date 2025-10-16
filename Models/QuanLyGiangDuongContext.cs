using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace SchoolManagementApp.Models;

public partial class QuanLyGiangDuongContext : DbContext
{
    public QuanLyGiangDuongContext()
    {
    }

    public QuanLyGiangDuongContext(DbContextOptions<QuanLyGiangDuongContext> options)
        : base(options)
    {
    }

    public virtual DbSet<TaiKhoanNguoiDung> TaiKhoanNguoiDungs { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=MSI;Initial Catalog=QUAN_LY_GIANG_DUONG;Integrated Security=True;Encrypt=True;Trust Server Certificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<TaiKhoanNguoiDung>(entity =>
        {
            entity.HasKey(e => e.MaNguoiDung);

            entity.ToTable("TAI_KHOAN_NGUOI_DUNG");

            entity.Property(e => e.MaNguoiDung)
                .ValueGeneratedNever()
                .HasColumnName("maNguoiDung");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("email");
            entity.Property(e => e.HashMatKhau)
                .HasMaxLength(64)
                .IsFixedLength()
                .HasColumnName("hashMatKhau");
            entity.Property(e => e.SDt)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("sDT");
            entity.Property(e => e.TenNguoiDung)
                .HasMaxLength(50)
                .HasColumnName("tenNguoiDung");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasColumnName("trangThai");
            entity.Property(e => e.VaiTromaVt).HasColumnName("VAI_TROmaVT");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
