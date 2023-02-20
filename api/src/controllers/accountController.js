const jwt = require('jsonwebtoken')
const bcrypt = require('bcrypt')
const { Op } = require('sequelize')
const { sequelize, Account, Karyawan } = require('../models')
const { SECRET } = require('../config')

module.exports = {
  async register(req, res) {
    try {
      const { username, email } = req.body
      const accountExists = await Account.findOne({
        where: {
          [Op.or]: [{ username }, { email }]
        }
      })
      if (accountExists) {
        return res.status(400).json({
          success: false,
          message: 'Username or email already in use!'
        })
      }
      const hashedPassword = await bcrypt.hash(req.body.password, 10)

      await sequelize.transaction(async (t) => {
        const karyawan = await Karyawan.create({
          nama: req.body.nama,
          gender: req.body.gender,
          usia: req.body.usia,
          menikah: req.body.menikah,
          jlh_anak: req.body.jlh_anak,
          alamat: req.body.alamat,
          no_telp: req.body.no_telp,
          no_rek: req.body.no_rek,
          id_jabatan: req.body.id_jabatan
        }, { transaction: t })

        const account = await Account.create({
          username: username,
          email: email,
          password: hashedPassword,
          id_karyawan: karyawan.id
        }, { transaction: t })

        await Karyawan.update({
          created_by: account.id,
          updated_by: account.id
        }, { where: { id: karyawan.id }, transaction: t })
      })

      res.status(201).json({
        success: true,
        message: 'Account registered successfully!'
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  },

  async login(req, res) {
    try {
      const { username, password } = req.body
      const accountExists = await Account.findOne({ 
        where: { username: username, status: 'ACTIVE' }
      })
      if (!accountExists) {
        return res.status(403).json({
          success: false,
          message: 'Invalid username or password!'
        })
      }

      const passwordIsValid = await bcrypt.compare(password, accountExists.password)
      if (!passwordIsValid) {
        return res.status(403).json({
          success: false,
          message: 'Invalid username or password!'
        })
      }

      const token = jwt.sign(
        {
          id: accountExists.id_karyawan,
          account: accountExists.id,
          role: accountExists.role
        },
        SECRET,
        { algorithm: 'HS256', expiresIn: '7d' }
      )
      res.status(200).json({
        success: true,
        message: 'Log In Successful!',
        account: {
          id: accountExists.id_karyawan,
          username: accountExists.username,
          role: accountExists.role,
          token: token
        }
      })
    }
    catch (err) {
      res.status(500).json({ success: false, message: 'An error has occured, please try again!' })
    }
  }
}