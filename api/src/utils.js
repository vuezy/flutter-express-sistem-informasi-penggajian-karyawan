module.exports = {
  formatDate(ms) {
    const date = new Date(ms)
    let day = date.getDate()
    let month = date.getMonth() + 1
    const year = date.getFullYear()

    if (day < 10) {
      day = '0' + day
    }
    if (month < 10) {
      month = '0' + month
    }

    return year + '-' + month + '-' + day
  },

  validateDate(date) {
    const currentDate = new Date(Date.now())
    if (currentDate.getFullYear() > date.slice(0, 4)) return false
    if (currentDate.getMonth() + 1 > date.slice(5, 7)) return false
    return true
  },

  calculateGajian(karyawan, jabatan, attendance) {
    const { menikah, jlh_anak } = karyawan
    const { gaji_pokok, tunjangan_jabatan } = jabatan
    const { jlh_hari_kerja, hadir } = attendance

    const fraction = hadir / jlh_hari_kerja
    const tunjangan_makan = Math.floor((fraction * 300000) / 1000) * 1000
    const tunjangan_transport = Math.floor((fraction * 400000) / 1000) * 1000
    const gaji_bruto = gaji_pokok + tunjangan_jabatan + tunjangan_makan + tunjangan_transport

    const biaya_jabatan = Math.min(500000, (0.05 * gaji_bruto))
    const iuran_bpjs = 0.04 * (gaji_pokok + tunjangan_jabatan)
    const gaji_bersih = gaji_bruto - biaya_jabatan - iuran_bpjs

    let tanggungan = Math.min(3, jlh_anak)
    if (menikah == 'SUDAH') tanggungan += 1
    const ptkp = 4500000 + 375000 * tanggungan
    const pkp = Math.floor(Math.max(0, gaji_bersih - ptkp) / 1000) * 1000
    const pkp_tahunan = pkp * 12

    let pph = 0
    if (pkp_tahunan <= 60000000) {
      pph = 0.05 * pkp_tahunan / 12
    }
    else if (pkp_tahunan <= 250000000) {
      pph = 0.15 * pkp_tahunan / 12
    }
    else if (pkp_tahunan <= 500000000) {
      pph = 0.25 * pkp_tahunan / 12
    }
    else if (pkp_tahunan <= 5000000000) {
      pph = 0.30 * pkp_tahunan / 12
    }
    else {
      pph = 0.35 * pkp_tahunan / 12
    }
    const gaji_diterima = gaji_bersih - pph
    
    return {
      gaji_pokok: parseFloat(gaji_pokok.toFixed(2)),
      tunjangan_jabatan: parseFloat(tunjangan_jabatan.toFixed(2)),
      tunjangan_makan: parseFloat(tunjangan_makan.toFixed(2)),
      tunjangan_transport: parseFloat(tunjangan_transport.toFixed(2)),
      gaji_bruto: parseFloat(gaji_bruto.toFixed(2)),
      biaya_jabatan: parseFloat(biaya_jabatan.toFixed(2)),
      iuran_bpjs: parseFloat(iuran_bpjs.toFixed(2)),
      gaji_bersih: parseFloat(gaji_bersih.toFixed(2)),
      ptkp: parseFloat(ptkp.toFixed(2)),
      pkp: parseFloat(pkp.toFixed(2)),
      pph: parseFloat(pph.toFixed(2)),
      gaji_diterima: parseFloat(gaji_diterima.toFixed(2))
    }
  }
}