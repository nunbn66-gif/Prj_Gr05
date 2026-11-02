using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Prj_Gr05.Models;

[Table("SinhVien")]
public partial class SinhVien
{
    [Key]
    [Column("MaSV")]
    public int MaSv { get; set; }

    [StringLength(100)]
    public string HoTen { get; set; } = null!;

    [StringLength(254)]
    public string Email { get; set; } = null!;

    [StringLength(20)]
    [Unicode(false)]
    public string? SoDienThoai { get; set; }

    [StringLength(1000)]
    public string? GioiThieu { get; set; }

    [Precision(0)]
    public DateTime NgayTao { get; set; }

    [InverseProperty("MaSvNavigation")]
    public virtual ICollection<HoSoCv> HoSoCvs { get; set; } = new List<HoSoCv>();
}
