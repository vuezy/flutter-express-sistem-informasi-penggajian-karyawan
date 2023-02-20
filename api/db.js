require('dotenv').config()
const mysql = require('mysql2/promise')

async function createDb() {
	let conn = null
	try {
		conn = await mysql.createConnection({
			host: process.env.DB_HOST,
			port: process.env.DB_PORT,
			user: process.env.DB_USER,
			password: process.env.DB_PASSWORD
		})
		await conn.query('CREATE DATABASE IF NOT EXISTS si_penggajian')
		console.log('Database si_penggajian created successfully!')
	}
	catch (err) {
		console.log('ERROR! Please try again!')
		console.log(err)
	}
	if (conn) await conn.end()
}

createDb()