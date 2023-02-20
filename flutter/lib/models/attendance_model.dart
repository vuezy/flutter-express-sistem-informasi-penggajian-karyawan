class Attendance {
  int? id;
  String? tglMulai;
  String? tglBerakhir;
  int? jlhHariKerja;
  int? hadir;
  int? idKaryawan;
  String? nama;
  String? filledAt;
  int? createdBy;
  int? updatedBy;
  bool? off;

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tglMulai = json['tgl_mulai'];
    tglBerakhir = json['tgl_berakhir'];
    jlhHariKerja = json['jlh_hari_kerja'];
    hadir = json['hadir'];
    idKaryawan = json['id_karyawan'];
    nama = json['nama'];
    filledAt = json['filled_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    off = json['off'];
  }
}