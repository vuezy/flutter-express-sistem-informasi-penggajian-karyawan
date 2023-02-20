const router = require('express').Router()
const { verify, isAuthorizedOrIsAdmin, isAdmin } = require('../middlewares')
const karyawanController = require('../controllers/karyawanController')

router.use('/', verify)

router.get('/profile/:id', isAuthorizedOrIsAdmin, karyawanController.getProfile)
router.patch('/profile/:id', isAuthorizedOrIsAdmin, karyawanController.updateProfile)

router.get('/', isAdmin, karyawanController.searchKaryawan)
router.delete('/:id', isAdmin, karyawanController.deleteKaryawan)

module.exports = router