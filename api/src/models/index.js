const { Sequelize, DataTypes } = require('sequelize')
const { DB } = require('../config')

const sequelize = new Sequelize(
  DB.NAME,
  DB.USER,
  DB.PASSWORD,
  {
    host: DB.HOST,
    port: DB.PORT,
    dialect: 'mysql',
    operatorsAliases: 0,
    pool: DB.POOL
  }
)

const db = { sequelize: sequelize }

db.Account = require('./models/accountModel')(sequelize, DataTypes)
db.Karyawan = require('./models/karyawanModel')(sequelize, DataTypes)
db.Jabatan = require('./models/jabatanModel')(sequelize, DataTypes)
db.Attendance = require('./models/attendanceModel')(sequelize, DataTypes)
db.GajianMaster = require('./models/gajianMasterModel')(sequelize, DataTypes)
db.GajianDetail = require('./models/gajianDetailModel')(sequelize, DataTypes)

require('./associations')(db)

module.exports = db