const express = require("express");

const {
    obtenerLaboratorios,
    obtenerLaboratoriosPorId,
    crearLaboratorio,
    eliminarLaboratorio,
    editarLaboratorio
} = require("./laboratorioController");

const { verificarToken, autorizarRoles } = require("../../middlewares/authMiddleware");

const router = express.Router();

// Lectura: Cualquier usuario autenticado (estudiante, laboratorio, administrador)
router.get("/", verificarToken, obtenerLaboratorios);
router.get("/:id", verificarToken, obtenerLaboratoriosPorId);

// Modificación y gestión: Solo ADMINISTRADOR o LABORATORIO
router.post("/", verificarToken, autorizarRoles("ADMINISTRADOR", "LABORATORIO"), crearLaboratorio);
router.put("/:id", verificarToken, autorizarRoles("ADMINISTRADOR", "LABORATORIO"), editarLaboratorio);
router.delete("/:id", verificarToken, autorizarRoles("ADMINISTRADOR"), eliminarLaboratorio);

module.exports = router;