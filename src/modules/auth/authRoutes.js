const express = require("express");

const {
    registrarUsuario,
    loginUsuario,
    recuperarPassword,
    verificarCodigo,
    nuevaPassword,
    listarUsuarios,
    actualizarPerfil,
    cambiarPassword
} = require("./authController");

const { verificarToken, autorizarRoles } = require("../../middlewares/authMiddleware");

const router = express.Router();

router.post("/register", registrarUsuario);
router.post("/registro", registrarUsuario);
router.post("/login", loginUsuario);
router.post("/recuperar-password", recuperarPassword);
router.post("/verificar-codigo", verificarCodigo);
router.post("/nueva-password", nuevaPassword);

router.get("/perfil", verificarToken, (req, res) => {
    res.json({
        mensaje: "Acceso permitido",
        usuario: req.usuario
    });
});

router.put("/perfil", verificarToken, actualizarPerfil);
router.put("/cambiar-password", verificarToken, cambiarPassword);

// Solo el rol ADMINISTRADOR puede listar todos los usuarios
router.get("/usuarios", verificarToken, autorizarRoles("ADMINISTRADOR"), listarUsuarios);

module.exports = router;