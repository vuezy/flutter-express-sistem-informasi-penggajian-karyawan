module.exports = (sequelize, DataTypes) => {
  const Karyawan = sequelize.define('Karyawan', 
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    nama: {
      type: DataTypes.STRING,
      allowNull: false
    },
    gender: {
      type: DataTypes.STRING,
      allowNull: false
    },
    usia: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    menikah: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: 'BELUM'
    },
    jlh_anak: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0
    },
    alamat: {
      type: DataTypes.STRING,
      allowNull: false
    },
    no_telp: {
      type: DataTypes.STRING,
      allowNull: false
    },
    no_rek: {
      type: DataTypes.STRING,
      allowNull: false
    },
    status: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: 'ACTIVE'
    }
  }, {
    tableName: 'karyawan',
    createdAt: 'created_at',
    updatedAt: 'updated_at'
  })

  return Karyawan
}