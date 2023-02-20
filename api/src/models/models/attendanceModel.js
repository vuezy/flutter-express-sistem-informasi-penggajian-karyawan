module.exports = (sequelize, DataTypes) => {
  const Attendance = sequelize.define('Attendance', 
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    tgl_mulai: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    tgl_berakhir: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    jlh_hari_kerja: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 30
    },
    hadir: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0
    },
    filled_at: {
      type: DataTypes.DATEONLY,
      allowNull: true
    },
    status: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: 'ACTIVE'
    }
  }, {
    tableName: 'attendance',
    createdAt: 'created_at',
    updatedAt: 'updated_at'
  })

  return Attendance
}