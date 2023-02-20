const router = require('express').Router()
const { verify, isAdmin } = require('../middlewares')
const attendanceController = require('../controllers/attendanceController')

router.use('/', verify)

router.get('/', attendanceController.getAttendanceList)
router.patch('/fill/:id', attendanceController.fillAttendance)

router.get('/all', isAdmin, attendanceController.searchAttendance)
router.post('/', isAdmin, attendanceController.createAttendance)
router.patch('/:id', isAdmin, attendanceController.updateAttendance)
router.delete('/:id', isAdmin, attendanceController.deleteAttendance)

module.exports = router