class Gajian {
  int? id;
  int? idKaryawan;
  int? idJabatan;
  int? idAttendance;
  String? karyawan;
  String? jabatan;
  String? gajiDiterima;
  String? tglTerima;

  Gajian.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idKaryawan = json['id_karyawan'];
    idJabatan = json['id_jabatan'];
    idAttendance = json['id_attendance'];
    karyawan = json['karyawan'];
    jabatan = json['jabatan'];
    gajiDiterima = json['gaji_diterima'];
    tglTerima = json['tgl_terima'];
  }
}