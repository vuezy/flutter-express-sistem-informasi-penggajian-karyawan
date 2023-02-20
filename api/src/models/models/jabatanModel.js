module.exports = (sequelize, DataTypes) => {
  const Jabatan = sequelize.define('Jabatan', 
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    nama: {
      type: DataTypes.STRING,
      unique: true,
      allowNull: false
    },
    gaji_pokok: {
      type: DataTypes.DECIMAL(12,2),
      allowNull: false,
      defaultValue: 0.00
    },
    tunjangan_jabatan: {
      type: DataTypes.DECIMAL(12,2),
      allowNull: false,
      defaultValue: 0.00
    },
    status: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: 'ACTIVE'
    }
  }, {
    tableName: 'jabatan',
    createdAt: 'created_at',
    updatedAt: 'updated_at'
  })

  return Jabatan
}