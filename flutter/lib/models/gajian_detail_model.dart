class GajianDetail {
  int? id;
  String? karyawan;
  String? menikah;
  int? jlhAnak;
  String? jabatan;
  int? idAttendance;
  int? hadir;
  int? jlhHariKerja;
  String? gajiPokok;
  String? tunjanganJabatan;
  String? tunjanganMakan;
  String? tunjanganTransport;
  String? gajiBruto;
  String? biayaJabatan;
  String? iuranBpjs;
  String? gajiBersih;
  String? ptkp;
  String? pkp;
  String? pph;
  String? gajiDiterima;
  String? tglTerima;
  String? noRek;
  int? createdBy;
  int? updatedBy;

  GajianDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    karyawan = json['karyawan'];
    menikah = json['menikah'];
    jlhAnak = json['jlh_anak'];
    jabatan = json['jabatan'];
    idAttendance = json['id_attendance'];
    hadir = json['hadir'];
    jlhHariKerja = json['jlh_hari_kerja'];
    gajiPokok = json['gaji_pokok'];
    tunjanganJabatan = json['tunjangan_jabatan'];
    tunjanganMakan = json['tunjangan_makan'];
    tunjanganTransport = json['tunjangan_transport'];
    gajiBruto = json['gaji_bruto'];
    biayaJabatan = json['biaya_jabatan'];
    iuranBpjs = json['iuran_bpjs'];
    gajiBersih = json['gaji_bersih'];
    ptkp = json['ptkp'];
    pkp = json['pkp'];
    pph = json['pph'];
    gajiDiterima = json['gaji_diterima'];
    tglTerima = json['tgl_terima'];
    noRek = json['no_rek'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
  }
}