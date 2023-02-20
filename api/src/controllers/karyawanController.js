const { Op } = require('sequelize')
const { sequelize, Karyawan, Account, Attendance } = require('../models')

module.exports = {
  async getProfile(req, res) {
    try {
      const karyawan = await Karyawan.findByPk(req.params.id, { include: ['account', 'jabatan'] })
      res.status(200).json({
        success: true,
        profile: {
          id: karyawan.id,
          nama: karyawan.nama,
          id_jabatan: karyawan.id_jabatan,
          jabatan: karyawan.jabatan.nama,
          gender: karyawan.gender,
          usia: karyawan.usia,
          menikah: karyawan.menikah,
          jlh_anak: karyawan.jlh_anak,
          alamat: karyawan.alamat,
          no_telp: karyawan.no_telp,
          no_rek: karyawan.no_rek,
          email: karyawan.account.email,
          username: karyawan.account.username
        }
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async updateProfile(req, res) {
    try {
      const payload = {
        nama: req.body.nama,
        usia: req.body.usia,
        menikah: req.body.menikah,
        jlh_anak: req.body.jlh_anak,
        alamat: req.body.alamat,
        no_telp: req.body.no_telp,
        no_rek: req.body.no_rek,
        updated_by: req.user.account
      }
      if (req.body.id_jabatan && req.user.role == 'ADMIN') {
        payload.id_jabatan = req.body.id_jabatan
      }

      await Karyawan.update(payload, { where: { id: req.params.id } })

      res.status(204).json({ success: true })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async searchKaryawan(req, res) {
    try {
      const query = req.query.nama || ''
      let karyawan = await Karyawan.findAll({
        where: {
          nama: { [Op.like]: '%' + query + '%' },
          status: 'ACTIVE'
        },
        order: [
          ['usia', 'ASC']
        ],
        include: ['account', 'jabatan']
      })

      karyawan = karyawan.map(k => ({
        id: k.id,
        nama: k.nama,
        jabatan: k.jabatan.nama,
        usia: k.usia,
        menikah: k.menikah,
        jlh_anak: k.jlh_anak,
        created_by: k.created_by,
        updated_by: k.updated_by
      }))

      res.status(200).json({
        success: true,
        karyawan: karyawan
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async deleteKaryawan(req, res) {
    try {
      await sequelize.transaction(async (t) => {
        await Karyawan.update({
          status: 'INACTIVE',
          updated_by: req.user.account
        }, { where: { id: req.params.id }, transaction: t })

        await Account.update({
          status: 'INACTIVE'
        }, { where: { id_karyawan: req.params.id }, transaction: t })

        await Attendance.update({
          status: 'INACTIVE',
          updated_by: req.user.account
        }, { where: { id_karyawan: req.params.id }, transaction: t })
      })
      
      res.status(204).json({ success: true })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  }
}