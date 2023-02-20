const { Op } = require('sequelize')
const { Jabatan } = require('../models')

module.exports = {
  async searchJabatan(req, res) {
    try {
      const query = req.query.nama || ''
      const jabatan = await Jabatan.findAll({
        where: {
          nama: { [Op.like]: '%' + query + '%' },
          status: 'ACTIVE'
        },
        order: [
          ['gaji_pokok', 'ASC'],
          ['tunjangan_jabatan', 'ASC']
        ],
        attributes: ['id', 'nama', 'gaji_pokok', 'tunjangan_jabatan']
      })

      res.status(200).json({
        success: true,
        jabatan: jabatan
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async createJabatan(req, res) {
    try {
      const { nama } = req.body
      const jabatanExists = await Jabatan.findOne({
        where: { nama }
      })
      if (jabatanExists) {
        return res.status(400).json({
          success: false,
          message: 'Field nama from table jabatan should be unique!'
        })
      }

      await Jabatan.create({
        nama: nama,
        gaji_pokok: req.body.gaji_pokok,
        tunjangan_jabatan: req.body.tunjangan_jabatan,
        created_by: req.user.account,
        updated_by: req.user.account
      })

      res.status(201).json({
        success: true,
        message: 'New record successfully added to table jabatan!'
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },
  
  async updateJabatan(req, res) {
    try {
      const { nama } = req.body
      const jabatanExists = await Jabatan.findOne({
        where: {
          id: { [Op.ne]: req.params.id },
          nama: nama
        }
      })
      if (jabatanExists) {
        return res.status(400).json({
          success: false,
          message: 'Field nama from table jabatan should be unique!'
        })
      }

      await Jabatan.update({
        nama: nama,
        gaji_pokok: req.body.gaji_pokok,
        tunjangan_jabatan: req.body.tunjangan_jabatan,
        updated_by: req.user.account
      }, { where: { id: req.params.id } })

      res.status(204).json({ success: true })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async deleteJabatan(req, res) {
    try {
      await Jabatan.update({
        status: 'INACTIVE',
        updated_by: req.user.account
      }, { where: { id: req.params.id } })

      res.status(204).json({ success: true })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  }
}