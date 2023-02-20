require('dotenv').config()
const express = require('express')

const app = express()
app.use(express.json())

const { sequelize } = require('./src/models')
sequelize.sync()

const accountRouter = require('./src/routes/accountRoute')
const karyawanRouter = require('./src/routes/karyawanRoute')
const jabatanRouter = require('./src/routes/jabatanRoute')
const attendanceRouter = require('./src/routes/attendanceRoute')
const gajianRouter = require('./src/routes/gajianRoute')

app.use('/api', accountRouter)
app.use('/api/karyawan', karyawanRouter)
app.use('/api/jabatan', jabatanRouter)
app.use('/api/attendance', attendanceRouter)
app.use('/api/gajian', gajianRouter)


const { PORT } = require('./src/config')
app.listen(PORT, () => {
	console.log(`Server running on port ${PORT}`)
})