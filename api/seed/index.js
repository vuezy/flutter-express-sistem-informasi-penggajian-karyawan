const path = require('path')
require('dotenv').config({ path: path.resolve(__dirname, '../.env') })

const Promise = require('bluebird')
const bcrypt = require('bcrypt')
const db = require('../src/models')
const account = require('./account.json')
const karyawan = require('./karyawan.json')
const jabatan = require('./jabatan.json')
const attendance = require('./attendance.json')
const gajianMaster = require('./gajianMaster.json')
const gajianDetail = require('./gajianDetail.json')

async function resetAndRunSeed() {
	try {
		// Reset all tables
		await db.sequelize.sync({ force: true })

		// Insert some data to table jabatan
    await db.Jabatan.bulkCreate(jabatan.map(j => ({
			...j, created_by: null, updated_by: null
		})))

		// Insert some data to table karyawan
    await db.Karyawan.bulkCreate(karyawan.map(k => ({
			...k, created_by: null, updated_by: null
		})))

		// Insert some data to table account
		account.forEach(a => {
			a.password = bcrypt.hashSync(a.password, 10)
		})
    await db.Account.bulkCreate(account)

		// Insert some data to table attendance
    await db.Attendance.bulkCreate(attendance)

		// Insert some data to table gajian_master
    await db.GajianMaster.bulkCreate(gajianMaster)

		// Insert some data to table gajian_detail
    await db.GajianDetail.bulkCreate(gajianDetail)

		// Set created_by and updated_by for table jabatan
		await Promise.all(jabatan.map((j, i) => {
			return db.Jabatan.update({
				created_by: j.created_by,
				updated_by: j.updated_by
			}, { where: { id: i + 1 } })
		}))

		// Set created_by and updated_by for table karyawan
		await Promise.all(karyawan.map((k, i) => {
			return db.Karyawan.update({
				created_by: k.created_by,
				updated_by: k.updated_by
			}, { where: { id: i + 1 } })
		}))
	}
	catch (err) {
		console.log('ERROR! Please try again!')
		console.log(err)
	}
}

resetAndRunSeed()