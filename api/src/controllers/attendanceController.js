const Promise = require('bluebird')
const { Op } = require('sequelize')
const { sequelize, Attendance, Karyawan } = require('../models')
const { formatDate, validateDate } = require('../utils')

module.exports = {
  async getAttendanceList(req, res) {
    try {
      let attendance = await Attendance.findAll({
        where: { id_karyawan: req.user.id, status: 'ACTIVE' },
        order: [
          ['tgl_mulai', 'DESC'],
          ['tgl_berakhir', 'DESC'],
          [sequelize.fn('isnull', sequelize.col('filled_at')), 'DESC'],
          ['filled_at', 'DESC'],
          ['id', 'DESC']
        ]
      })

      const currentDate = formatDate(Date.now())
      attendance = attendance.map(a => {
        const isOff = 
          currentDate < a.tgl_mulai || currentDate >= a.tgl_berakhir || currentDate == a.filled_at
        
        return {
          id: a.id,
          tgl_mulai: a.tgl_mulai,
          tgl_berakhir: a.tgl_berakhir,
          jlh_hari_kerja: a.jlh_hari_kerja,
          hadir: a.hadir,
          filled_at: a.filled_at || '-',
          off: isOff
        }
      })

      res.status(200).json({
        success: true,
        attendance: attendance
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async fillAttendance(req, res) {
    try {
      const attendance = await Attendance.findOne({
        where: { id: req.params.id, id_karyawan: req.user.id, status: 'ACTIVE' }
      })

      const currentDate = formatDate(Date.now())
      if (!attendance || currentDate < attendance.tgl_mulai || currentDate >= attendance.tgl_berakhir) {
        return res.status(403).json({
          success: false,
          message: 'You are not allowed to do this action!'
        })
      }

      if (currentDate == attendance.filled_at) {
        return res.status(403).json({
          success: false,
          message: 'You already filled the attendance for today!'
        })
      }
      
      await Attendance.update({
        hadir: Math.min(attendance.jlh_hari_kerja, attendance.hadir + 1),
        filled_at: currentDate,
        updated_by: req.user.account
      }, { where: { id: req.params.id } })

      res.status(200).json({
        success: true,
        message: 'Successfully filled the attendance!'
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async searchAttendance(req, res) {
    try {
      const query = req.query.nama || ''
      let attendance = await Attendance.findAll({
        where: { status: 'ACTIVE' },
        order: [
          ['tgl_mulai', 'DESC'],
          ['tgl_berakhir', 'DESC'],
          [sequelize.fn('isnull', sequelize.col('filled_at')), 'DESC'],
          ['filled_at', 'DESC'],
          ['id', 'DESC']
        ],
        include: {
          model: Karyawan,
          as: 'karyawan',
          where: { nama: { [Op.like]: '%' + query + '%' } }
        }
      })

      attendance = attendance.map(a => {
        return {
          id: a.id,
          tgl_mulai: a.tgl_mulai,
          tgl_berakhir: a.tgl_berakhir,
          jlh_hari_kerja: a.jlh_hari_kerja,
          hadir: a.hadir,
          nama: a.karyawan.nama,
          filled_at: a.filled_at || '-',
          created_by: a.created_by,
          updated_by: a.updated_by,
        }
      })

      res.status(200).json({
        success: true,
        attendance: attendance
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async createAttendance(req, res) {
    try {
      const { tgl_mulai, tgl_berakhir } = req.body
      if (!validateDate(tgl_mulai) || tgl_mulai >= tgl_berakhir) {
        return res.status(400).json({
          success: false,
          message: 'Please provide valid date for field tgl_mulai!'
        })
      }

      if (req.body.id_karyawan == 'all') {
        const karyawan = await Karyawan.findAll({
          where: { status: 'ACTIVE' },
          attributes: ['id']
        })

        await sequelize.transaction(async (t) => {
          await Promise.all(karyawan.map(k => {
            return Attendance.create({
              tgl_mulai: tgl_mulai,
              tgl_berakhir: tgl_berakhir,
              jlh_hari_kerja: req.body.jlh_hari_kerja,
              id_karyawan: k.id,
              created_by: req.user.account,
              updated_by: req.user.account
            }, { transaction: t })
          }))
        })
      }
      else {
        await Attendance.create({
          tgl_mulai: tgl_mulai,
          tgl_berakhir: tgl_berakhir,
          jlh_hari_kerja: req.body.jlh_hari_kerja,
          id_karyawan: req.body.id_karyawan,
          created_by: req.user.account,
          updated_by: req.user.account
        })
      }

      res.status(201).json({
        success: true,
        message: 'Attendance has been added successfully!'
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async updateAttendance(req, res) {
    try {
      const { tgl_mulai, tgl_berakhir } = req.body
      if (tgl_mulai >= tgl_berakhir) {
        return res.status(400).json({
          success: false,
          message: 'Please provide valid date for field tgl_mulai!'
        })
      }
      
      await Attendance.update({
        tgl_mulai: tgl_mulai,
        tgl_berakhir: tgl_berakhir,
        jlh_hari_kerja: req.body.jlh_hari_kerja,
        updated_by: req.user.account
      }, { where: { id: req.params.id } })

      res.status(204).json({ success: true })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async deleteAttendance(req, res) {
    try {
      await Attendance.update({
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