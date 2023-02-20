const jwt = require('jsonwebtoken')
const { SECRET } = require('./config')
const { Karyawan, Jabatan, Attendance } = require('./models')

module.exports = {
  verify(req, res, next) {
    try {
      const token = req.get('Authorization').replace('Bearer ', '')
      const decoded = jwt.verify(token, SECRET, { algorithms: ['HS256'] })
      req.user = { id: decoded.id, account: decoded.account, role: decoded.role }
      next()
    }
    catch (err) {
      res.status(401).json({ success: false, message: 'Unauthorized!' })
    }
  },

  isAuthorizedOrIsAdmin(req, res, next) {
    if (req.params.id != req.user.id && req.user.role != 'ADMIN') {
      return res.status(403).json({
        success: false,
        message: 'You are not allowed to do this action!'
      })
    }
    next()
  },
  
  isAdmin(req, res, next) {
    if (req.user.role != 'ADMIN') {
      return res.status(403).json({
        success: false,
        message: 'You are not allowed to do this action!'
      })
    }
    next()
  },

  async validateId(req, res, next) {
    let id_karyawan, id_jabatan, id_attendance
    if (req.method == 'GET') {
      id_karyawan = req.query.id_karyawan
      id_jabatan = req.query.id_jabatan
      id_attendance = req.query.id_attendance
    }
    else {
      id_karyawan = req.body.id_karyawan
      id_jabatan = req.body.id_jabatan
      id_attendance = req.body.id_attendance
    }

    const karyawan = await Karyawan.findOne({ where: { id: id_karyawan, status: 'ACTIVE' } })
    if (!karyawan) {
      return res.status(400).json({
        success: false,
        message: 'Karyawan with that ID does not exist!'
      })
    }

    const jabatan = await Jabatan.findOne({ where: { id: id_jabatan, status: 'ACTIVE' } })
    if (!jabatan) {
      return res.status(400).json({
        success: false,
        message: 'Jabatan with that ID does not exist!'
      })
    }

    const attendance = await Attendance.findOne({
      where: { id: id_attendance, id_karyawan: id_karyawan, status: 'ACTIVE' }
    })
    if (!attendance) {
      return res.status(400).json({
        success: false,
        message: 'Attendance with that ID does not exist!'
      })
    }

    req.gajian = {
      karyawan: {
        id: karyawan.id,
        nama: karyawan.nama,
        menikah: karyawan.menikah,
        jlh_anak: karyawan.jlh_anak,
        no_rek: karyawan.no_rek
      },
      jabatan: {
        id: jabatan.id,
        nama: jabatan.nama,
        gaji_pokok: parseFloat(jabatan.gaji_pokok),
        tunjangan_jabatan: parseFloat(jabatan.tunjangan_jabatan)
      },
      attendance: {
        id: attendance.id,
        jlh_hari_kerja: attendance.jlh_hari_kerja,
        hadir: attendance.hadir
      }
    }
    next()
  }
}