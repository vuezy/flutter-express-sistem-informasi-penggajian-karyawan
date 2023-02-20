const { DataTypes } = require('sequelize')

let foreignKey = {
  name: '',
  type: DataTypes.INTEGER,
  allowNull: false
}

const constraints = {
  onDelete: 'RESTRICT',
  onUpdate: 'RESTRICT'
}

function addCreatedByAndUpdatedBy(Account, model) {
  // One-To-Many relationship between Account and another model
  foreignKey = { ...foreignKey, name: 'created_by', allowNull: true }
  Account.hasMany(model, { foreignKey, ...constraints })
  model.belongsTo(Account, { foreignKey, ...constraints, as: 'user_create' })

  foreignKey = { ...foreignKey, name: 'updated_by', allowNull: true }
  Account.hasMany(model, { foreignKey, ...constraints })
  model.belongsTo(Account, { foreignKey, ...constraints, as: 'user_update' })
}


module.exports = (db) => {
  // One-To-Many relationship between Jabatan and Karyawan
  foreignKey = { ...foreignKey, name: 'id_jabatan' }
  db.Jabatan.hasMany(db.Karyawan, { foreignKey, ...constraints, as: 'karyawan' })
  db.Karyawan.belongsTo(db.Jabatan, { foreignKey, ...constraints, as: 'jabatan' })


  // One-To-One relationship between Karyawan and Account
  foreignKey = { ...foreignKey, name: 'id_karyawan' }
  db.Karyawan.hasOne(db.Account, { foreignKey, ...constraints, as: 'account' })
  db.Account.belongsTo(db.Karyawan, { foreignKey, ...constraints, as: 'karyawan' })


  // One-To-Many relationship between Karyawan and Attendance
  foreignKey = { ...foreignKey, name: 'id_karyawan' }
  db.Karyawan.hasMany(db.Attendance, { foreignKey, ...constraints, as: 'attendance' })
  db.Attendance.belongsTo(db.Karyawan, { foreignKey, ...constraints, as: 'karyawan' })


  // One-To-Many relationship between Karyawan and GajianMaster
  foreignKey = { ...foreignKey, name: 'id_karyawan' }
  db.Karyawan.hasMany(db.GajianMaster, { foreignKey, ...constraints, as: 'gajian' })
  db.GajianMaster.belongsTo(db.Karyawan, { foreignKey, ...constraints, as: 'karyawan' })


  // One-To-Many relationship between Jabatan and GajianMaster
  foreignKey = { ...foreignKey, name: 'id_jabatan' }
  db.Jabatan.hasMany(db.GajianMaster, { foreignKey, ...constraints, as: 'gajian' })
  db.GajianMaster.belongsTo(db.Jabatan, { foreignKey, ...constraints, as: 'jabatan' })


  // One-To-One relationship between GajianMaster and GajianDetail
  foreignKey = { ...foreignKey, name: 'id_master' }
  db.GajianMaster.hasOne(db.GajianDetail, { foreignKey, ...constraints, as: 'detail' })
  db.GajianDetail.belongsTo(db.GajianMaster, { foreignKey, ...constraints, as: 'master' })


  // One-To-One relationship between Attendance and GajianDetail
  foreignKey = { ...foreignKey, name: 'id_attendance' }
  db.Attendance.hasOne(db.GajianDetail, { foreignKey, ...constraints, as: 'gajian' })
  db.GajianDetail.belongsTo(db.Attendance, { foreignKey, ...constraints, as: 'attendance' })


  addCreatedByAndUpdatedBy(db.Account, db.Karyawan)
  addCreatedByAndUpdatedBy(db.Account, db.Jabatan)
  addCreatedByAndUpdatedBy(db.Account, db.Attendance)
  addCreatedByAndUpdatedBy(db.Account, db.GajianMaster)
  addCreatedByAndUpdatedBy(db.Account, db.GajianDetail)
}