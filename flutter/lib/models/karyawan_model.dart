class Karyawan {
  int? id;
  String? nama;
  int? idJabatan;
  String? jabatan;
  String? gender;
  int? usia;
  String? menikah;
  int? jlhAnak;
  String? alamat;
  String? noTelp;
  String? noRek;
  String? email;
  String? username;
  int? createdBy;
  int? updatedBy;

  Karyawan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    idJabatan = json['id_jabatan'];
    jabatan = json['jabatan'];
    gender = json['gender'];
    usia = json['usia'];
    menikah = json['menikah'];
    jlhAnak = json['jlh_anak'];
    alamat = json['alamat'];
    noTelp = json['no_telp'];
    noRek = json['no_rek'];
    email = json['email'];
    username = json['username'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
  }
}