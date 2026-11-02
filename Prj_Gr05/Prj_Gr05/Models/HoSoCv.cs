using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Prj_Gr05.Models;

[Table("HoSoCV")]
[Index("MaSv", Name = "IX_HoSoCV_MaSV")]
public partial class HoSoCv
{
    [Key]
    [Column("MaHoSoCV")]
    public int MaHoSoCv { get; set; }

    [Column("MaSV")]
    public int MaSv { get; set; }

    [Column("TenCV")]
    [StringLength(150)]
    public string TenCv { get; set; } = null!;

    [Column("MaMauCV")]
    [StringLength(30)]
    [Unicode(false)]
    public string MaMauCv { get; set; } = null!;

    public bool TrangThai { get; set; }

    [Precision(0)]
    public DateTime NgayTao { get; set; }

    [Precision(0)]
    public DateTime? NgayCapNhat { get; set; }

    [InverseProperty("MaHoSoCvNavigation")]
    public virtual ICollection<DuAn> DuAns { get; set; } = new List<DuAn>();

    [InverseProperty("MaHoSoCvNavigation")]
    public virtual ICollection<HocVan> HocVans { get; set; } = new List<HocVan>();

    [InverseProperty("MaHoSoCvNavigation")]
    public virtual ICollection<KyNang> KyNangs { get; set; } = new List<KyNang>();

    [ForeignKey("MaSv")]
    [InverseProperty("HoSoCvs")]
    public virtual SinhVien MaSvNavigation { get; set; } = null!;
}
