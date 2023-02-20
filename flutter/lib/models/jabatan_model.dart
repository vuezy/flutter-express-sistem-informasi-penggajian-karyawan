class Jabatan {
  int? id;
  String? nama;
  String? gajiPokok;
  String? tunjanganJabatan;
  int? createdBy;
  int? updatedBy;

  Jabatan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    gajiPokok = json['gaji_pokok'];
    tunjanganJabatan = json['tunjangan_jabatan'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
  }
}