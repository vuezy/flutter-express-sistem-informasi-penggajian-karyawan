const router = require('express').Router()
const { verify, isAdmin, validateId } = require('../middlewares')
const gajianController = require('../controllers/gajianController')

router.use('/', verify)

router.get('/', gajianController.getGajianList)
router.get('/detail/:id', gajianController.getGajianDetail)
router.patch('/receive/:id', gajianController.receiveGajian)

router.get('/all', isAdmin, gajianController.searchGajian)
router.get('/preview', isAdmin, validateId, gajianController.previewGajian)
router.post('/', isAdmin, validateId, gajianController.createGajian)
router.patch('/:id', isAdmin, validateId, gajianController.updateGajian)
router.delete('/:id', isAdmin, gajianController.deleteGajian)

module.exports = router