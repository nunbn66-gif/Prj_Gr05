using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Prj_Gr05.Models;

namespace Prj_Gr05.Data;

public partial class PrjGr05Context : DbContext
{
    public PrjGr05Context(DbContextOptions<PrjGr05Context> options)
        : base(options)
    {
    }

    public virtual DbSet<DuAn> DuAns { get; set; }

    public virtual DbSet<HoSoCv> HoSoCvs { get; set; }

    public virtual DbSet<HocVan> HocVans { get; set; }

    public virtual DbSet<KyNang> KyNangs { get; set; }

    public virtual DbSet<SinhVien> SinhViens { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<DuAn>(entity =>
        {
            entity.HasOne(d => d.MaHoSoCvNavigation).WithMany(p => p.DuAns).HasConstraintName("FK_DuAn_HoSoCV");
        });

        modelBuilder.Entity<HoSoCv>(entity =>
        {
            entity.Property(e => e.MaMauCv).HasDefaultValue("Template1", "DF_HoSoCV_MaMauCV");
            entity.Property(e => e.NgayTao).HasDefaultValueSql("(sysdatetime())", "DF_HoSoCV_NgayTao");
            entity.Property(e => e.TrangThai).HasDefaultValue(true, "DF_HoSoCV_TrangThai");

            entity.HasOne(d => d.MaSvNavigation).WithMany(p => p.HoSoCvs).HasConstraintName("FK_HoSoCV_SinhVien");
        });

        modelBuilder.Entity<HocVan>(entity =>
        {
            entity.HasOne(d => d.MaHoSoCvNavigation).WithMany(p => p.HocVans).HasConstraintName("FK_HocVan_HoSoCV");
        });

        modelBuilder.Entity<KyNang>(entity =>
        {
            entity.HasOne(d => d.MaHoSoCvNavigation).WithMany(p => p.KyNangs).HasConstraintName("FK_KyNang_HoSoCV");
        });

        modelBuilder.Entity<SinhVien>(entity =>
        {
            entity.Property(e => e.NgayTao).HasDefaultValueSql("(sysdatetime())", "DF_SinhVien_NgayTao");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
