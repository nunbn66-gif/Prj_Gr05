using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Prj_Gr05.Models;

[Table("DuAn")]
[Index("MaHoSoCv", Name = "IX_DuAn_MaHoSoCV")]
public partial class DuAn
{
    [Key]
    public int MaDuAn { get; set; }

    [Column("MaHoSoCV")]
    public int MaHoSoCv { get; set; }

    [StringLength(200)]
    public string TenDuAn { get; set; } = null!;

    [StringLength(1000)]
    public string? MoTa { get; set; }

    [StringLength(300)]
    public string? CongNghe { get; set; }

    [StringLength(150)]
    public string? VaiTro { get; set; }

    [StringLength(500)]
    public string? LienKet { get; set; }

    public DateOnly? NgayBatDau { get; set; }

    public DateOnly? NgayKetThuc { get; set; }

    public int ThuTu { get; set; }

    [ForeignKey("MaHoSoCv")]
    [InverseProperty("DuAns")]
    public virtual HoSoCv MaHoSoCvNavigation { get; set; } = null!;
}
