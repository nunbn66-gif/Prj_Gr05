using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Prj_Gr05.Models;

[Table("KyNang")]
[Index("MaHoSoCv", Name = "IX_KyNang_MaHoSoCV")]
public partial class KyNang
{
    [Key]
    public int MaKyNang { get; set; }

    [Column("MaHoSoCV")]
    public int MaHoSoCv { get; set; }

    [StringLength(100)]
    public string TenKyNang { get; set; } = null!;

    [StringLength(50)]
    public string? MucDo { get; set; }

    [StringLength(300)]
    public string? MoTa { get; set; }

    public int ThuTu { get; set; }

    [ForeignKey("MaHoSoCv")]
    [InverseProperty("KyNangs")]
    public virtual HoSoCv MaHoSoCvNavigation { get; set; } = null!;
}
