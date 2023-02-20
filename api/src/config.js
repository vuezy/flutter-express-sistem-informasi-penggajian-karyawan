module.exports = {
  DB: {
    HOST: process.env.DB_HOST,
    PORT: process.env.DB_PORT,
    USER: process.env.DB_USER,
    PASSWORD: process.env.DB_PASSWORD,
    NAME: process.env.DB_NAME,
    POOL: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    }
  },
  PORT: process.env.PORT,
  SECRET: process.env.SECRET
}