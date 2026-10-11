const express = require('express');
const router = express.Router();

const reservaController = require('./reservaController');
const { verificarToken, autorizarRoles } = require('../../middlewares/authMiddleware');

// Crear reserva: cualquier usuario autenticado (estudiantes y egresados)
router.post('/', verificarToken, reservaController.crearReserva);

// Listar reservas: si es estudiante/egresado, el servicio solo entrega las suyas. Si es admin o lab, entrega todas.
router.get('/', verificarToken, reservaController.obtenerReservas);

router.get('/:id', verificarToken, reservaController.obtenerReservaPorId);
router.put('/:id', verificarToken, reservaController.editarReserva);

// Cancelar reserva: el propio usuario o un administrador
router.delete('/:id', verificarToken, reservaController.cancelarReserva);

// Cambiar estado (aprobar/finalizar): solo ADMINISTRADOR o LABORATORIO
router.patch('/:id/estado', verificarToken, autorizarRoles('ADMINISTRADOR', 'LABORATORIO'), reservaController.cambiarEstado);

module.exports = router;