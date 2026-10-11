const jwt = require("jsonwebtoken");

const verificarToken = (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;

        if (!authHeader) {
            return res.status(401).json({
                mensaje: "Token no proporcionado"
            });
        }

        const [tipo, token] = authHeader.split(" ");

        if (tipo !== "Bearer" || !token) {
            return res.status(401).json({
                mensaje: "Formato de token inválido"
            });
        }

        const usuario = jwt.verify(
            token,
            process.env.JWT_SECRET || "saici_super_secret_jwt_token_2026_uceva"
        );

        req.usuario = usuario;
        next();

    } catch (error) {
        return res.status(401).json({
            mensaje: "Token inválido o expirado"
        });
    }
};

const autorizarRoles = (...rolesPermitidos) => {
    return (req, res, next) => {
        if (!req.usuario) {
            return res.status(401).json({
                mensaje: "Usuario no autenticado"
            });
        }

        const rolUsuario = (req.usuario.rol || "").toUpperCase();
        const tipoUsuario = (req.usuario.tipo_usuario || "").toUpperCase();

        const rolesNormalizados = rolesPermitidos.map(r => r.toUpperCase());

        // Verificar coincidencia tanto en rol principal como en tipo_usuario
        const tienePermiso = rolesNormalizados.includes(rolUsuario) ||
                             rolesNormalizados.includes(tipoUsuario);

        if (!tienePermiso) {
            return res.status(403).json({
                mensaje: `Acceso denegado: tu rol (${rolUsuario}${tipoUsuario ? ` - ${tipoUsuario}` : ''}) no tiene permisos para esta acción`
            });
        }

        next();
    };
};

module.exports = {
    verificarToken,
    autorizarRoles
};