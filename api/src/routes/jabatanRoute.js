const router = require('express').Router()
const { verify, isAdmin } = require('../middlewares')
const jabatanController = require('../controllers/jabatanController')

router.get('/', jabatanController.searchJabatan)

router.use('/', verify)

router.post('/', isAdmin, jabatanController.createJabatan)
router.patch('/:id', isAdmin, jabatanController.updateJabatan)
router.delete('/:id', isAdmin, jabatanController.deleteJabatan)

module.exports = router