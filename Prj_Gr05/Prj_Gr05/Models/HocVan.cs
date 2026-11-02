using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Prj_Gr05.Models;

[Table("HocVan")]
[Index("MaHoSoCv", Name = "IX_HocVan_MaHoSoCV")]
public partial class HocVan
{
    [Key]
    public int MaHocVan { get; set; }

    [Column("MaHoSoCV")]
    public int MaHoSoCv { get; set; }

    [StringLength(200)]
    public string TenTruong { get; set; } = null!;

    [StringLength(150)]
    public string? ChuyenNganh { get; set; }

    [StringLength(100)]
    public string? BangCap { get; set; }

    public DateOnly? NgayBatDau { get; set; }

    public DateOnly? NgayKetThuc { get; set; }

    [StringLength(500)]
    public string? MoTa { get; set; }

    public int ThuTu { get; set; }

    [ForeignKey("MaHoSoCv")]
    [InverseProperty("HocVans")]
    public virtual HoSoCv MaHoSoCvNavigation { get; set; } = null!;
}
