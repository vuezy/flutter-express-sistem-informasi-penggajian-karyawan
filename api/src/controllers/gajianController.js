const { Op } = require('sequelize')
const { sequelize, GajianMaster, GajianDetail, Karyawan } = require('../models')
const { formatDate, calculateGajian } = require('../utils')

module.exports = {
  async getGajianList(req, res) {
    try {
      let gajian = await GajianMaster.findAll({
        where: { id_karyawan: req.user.id, status: 'ACTIVE' },
        order: [
          [sequelize.fn('isnull', sequelize.col('tgl_terima')), 'DESC'],
          ['tgl_terima', 'DESC'],
          ['id', 'DESC'],
          ['gaji_diterima', 'ASC']
        ],
        include: ['jabatan', 'detail']
      })

      gajian = gajian.map(g => ({
        id: g.id,
        id_karyawan: g.id_karyawan,
        id_jabatan: g.id_jabatan,
        id_attendance: g.detail.id_attendance,
        jabatan: g.jabatan.nama,
        gaji_diterima: g.gaji_diterima,
        tgl_terima: g.tgl_terima || '-'
      }))

      res.status(200).json({
        success: true,
        gajian: gajian
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async getGajianDetail(req, res) {
    try {
      let where = { id: req.params.id, status: 'ACTIVE' }
      if (req.user.role != 'ADMIN') {
        where.id_karyawan = req.user.id
      }

      let gajian = await GajianMaster.findOne({
        where: where,
        include: [
          {
            model: GajianDetail,
            as: 'detail',
            include: ['attendance']
          },
          'jabatan',
          'karyawan'
        ]
      })

      if (!gajian) {
        return res.status(403).json({
          success: false,
          message: 'You are not allowed to do this action!'
        })
      }

      gajian = {
        id: gajian.id,
        karyawan: gajian.karyawan.nama,
        menikah: gajian.karyawan.menikah,
        jlh_anak: gajian.karyawan.jlh_anak,
        jabatan: gajian.jabatan.nama,
        id_attendance: gajian.detail.id_attendance,
        hadir: gajian.detail.attendance.hadir,
        jlh_hari_kerja: gajian.detail.attendance.jlh_hari_kerja,
        gaji_pokok: gajian.detail.gaji_pokok,
        tunjangan_jabatan: gajian.detail.tunjangan_jabatan,
        tunjangan_makan: gajian.detail.tunjangan_makan,
        tunjangan_transport: gajian.detail.tunjangan_transport,
        gaji_bruto: gajian.detail.gaji_bruto,
        biaya_jabatan: gajian.detail.biaya_jabatan,
        iuran_bpjs: gajian.detail.iuran_bpjs,
        gaji_bersih: gajian.detail.gaji_bersih,
        ptkp: gajian.ptkp,
        pkp: gajian.pkp,
        pph: gajian.pph,
        gaji_diterima: gajian.gaji_diterima,
        tgl_terima: gajian.tgl_terima || '-',
        no_rek: gajian.karyawan.no_rek,
        created_by: gajian.created_by,
        updated_by: gajian.updated_by
      }

      res.status(200).json({
        success: true,
        gajian: gajian
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async receiveGajian(req, res) {
    try {
      const gajian = await GajianMaster.findOne({
        where: {
          id: req.params.id,
          id_karyawan: req.user.id,
          tgl_terima: null,
          status: 'ACTIVE'
        }
      })

      if (!gajian) {
        return res.status(403).json({
          success: false,
          message: 'You are not allowed to do this action!'
        })
      }

      const currentDate = formatDate(Date.now())
      await GajianMaster.update({
        tgl_terima: currentDate,
        updated_by: req.user.account
      }, { where: { id: req.params.id } })

      res.status(200).json({
        success: true,
        message: 'Successfully received!'
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async searchGajian(req, res) {
    try {
      const query = req.query.nama || ''
      let gajian = await GajianMaster.findAll({
        where: { status: 'ACTIVE' },
        order: [
          [sequelize.fn('isnull', sequelize.col('tgl_terima')), 'DESC'],
          ['tgl_terima', 'DESC'],
          ['id', 'DESC'],
          ['gaji_diterima', 'ASC']
        ],
        include: [
          {
            model: Karyawan,
            as: 'karyawan',
            where: { nama: { [Op.like]: '%' + query + '%' } }
          },
          'jabatan',
          'detail'
        ]
      })

      gajian = gajian.map(g => ({
        id: g.id,
        id_karyawan: g.id_karyawan,
        id_jabatan: g.id_jabatan,
        id_attendance: g.detail.id_attendance,
        karyawan: g.karyawan.nama,
        jabatan: g.jabatan.nama,
        gaji_diterima: g.gaji_diterima,
        tgl_terima: g.tgl_terima || '-'
      }))

      res.status(200).json({
        success: true,
        gajian: gajian
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async previewGajian(req, res) {
    try {
      const { karyawan, jabatan, attendance } = req.gajian
      let gajian = calculateGajian(karyawan, jabatan, attendance)

      gajian = {
        karyawan: karyawan.nama,
        menikah: karyawan.menikah,
        jlh_anak: karyawan.jlh_anak,
        jabatan: jabatan.nama,
        id_attendance: attendance.id,
        hadir: attendance.hadir,
        jlh_hari_kerja: attendance.jlh_hari_kerja,
        gaji_pokok: gajian.gaji_pokok.toString(),
        tunjangan_jabatan: gajian.tunjangan_jabatan.toString(),
        tunjangan_makan: gajian.tunjangan_makan.toString(),
        tunjangan_transport: gajian.tunjangan_transport.toString(),
        gaji_bruto: gajian.gaji_bruto.toString(),
        biaya_jabatan: gajian.biaya_jabatan.toString(),
        iuran_bpjs: gajian.iuran_bpjs.toString(),
        gaji_bersih: gajian.gaji_bersih.toString(),
        ptkp: gajian.ptkp.toString(),
        pkp: gajian.pkp.toString(),
        pph: gajian.pph.toString(),
        gaji_diterima: gajian.gaji_diterima.toString(),
        tgl_terima: '-',
        no_rek: karyawan.no_rek
      }

      res.status(200).json({
        success: true,
        gajian: gajian
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async createGajian(req, res) {
    try {
      const { karyawan, jabatan, attendance } = req.gajian
      const gajian = calculateGajian(karyawan, jabatan, attendance)

      await sequelize.transaction(async (t) => {
        const master = await GajianMaster.create({
          ptkp: gajian.ptkp,
          pkp: gajian.pkp,
          pph: gajian.pph,
          gaji_diterima: gajian.gaji_diterima,
          id_karyawan: karyawan.id,
          id_jabatan: jabatan.id,
          created_by: req.user.account,
          updated_by: req.user.account
        }, { transaction: t })

        await GajianDetail.create({
          gaji_pokok: gajian.gaji_pokok,
          tunjangan_jabatan: gajian.tunjangan_jabatan,
          tunjangan_makan: gajian.tunjangan_makan,
          tunjangan_transport: gajian.tunjangan_transport,
          biaya_jabatan: gajian.biaya_jabatan,
          iuran_bpjs: gajian.iuran_bpjs,
          gaji_bruto: gajian.gaji_bruto,
          gaji_bersih: gajian.gaji_bersih,
          id_master: master.id,
          id_attendance: attendance.id,
          created_by: req.user.account,
          updated_by: req.user.account
        }, { transaction: t })
      })

      res.status(201).json({
        success: true,
        message: 'New gajian record has been created successfully!'
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async updateGajian(req, res) {
    try {
      const { karyawan, jabatan, attendance } = req.gajian
      const gajian = calculateGajian(karyawan, jabatan, attendance)

      await sequelize.transaction(async (t) => {
        await GajianMaster.update({
          ptkp: gajian.ptkp,
          pkp: gajian.pkp,
          pph: gajian.pph,
          gaji_diterima: gajian.gaji_diterima,
          id_karyawan: karyawan.id,
          id_jabatan: jabatan.id,
          updated_by: req.user.account
        }, { where: { id: req.params.id }, transaction: t })

        await GajianDetail.update({
          gaji_pokok: gajian.gaji_pokok,
          tunjangan_jabatan: gajian.tunjangan_jabatan,
          tunjangan_makan: gajian.tunjangan_makan,
          tunjangan_transport: gajian.tunjangan_transport,
          biaya_jabatan: gajian.biaya_jabatan,
          iuran_bpjs: gajian.iuran_bpjs,
          gaji_bruto: gajian.gaji_bruto,
          gaji_bersih: gajian.gaji_bersih,
          id_attendance: attendance.id,
          updated_by: req.user.account
        }, { where: { id: req.params.id }, transaction: t })
      })

      res.status(204).json({ success: true })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async deleteGajian(req, res) {
    try {
      await sequelize.transaction(async (t) => {
        await GajianMaster.update({
          status: 'INACTIVE',
          updated_by: req.user.account
        }, { where: { id: req.params.id }, transaction: t })

        await GajianDetail.update({
          status: 'INACTIVE',
          updated_by: req.user.account
        }, { where: { id_master: req.params.id }, transaction: t })
      })
      
      res.status(204).json({ success: true })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  }
}