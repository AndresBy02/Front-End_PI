const pool = require("../../config/db");

const timeToSeconds = (value) => {
    const [hours, minutes, seconds = "0"] = value.split(":");
    return Number(hours) * 3600 + Number(minutes) * 60 + Number(seconds);
};

const listarHorarios = async (_req, res) => {
    try {
        const resultado = await pool.query(
            `SELECT id_horario, dia_semana, hora_apertura, hora_cierre, activo
             FROM horario
             ORDER BY dia_semana, hora_apertura, id_horario`
        );
        return res.status(200).json(resultado.rows);
    } catch (error) {
        console.error("Error obteniendo horarios:", error);
        return res.status(500).json({ mensaje: "Error al obtener los horarios" });
    }
};

const crearHorario = async (req, res) => {
    const { dia_semana, hora_apertura, hora_cierre } = req.body;
    const weekday = Number(dia_semana);
    const timePattern = /^([01]\d|2[0-3]):[0-5]\d(?::[0-5]\d)?$/;

    if (!Number.isInteger(weekday) || weekday < 1 || weekday > 7) {
        return res.status(400).json({ mensaje: "El día debe ser un valor entre 1 (lunes) y 7 (domingo)" });
    }
    if (!timePattern.test(hora_apertura || "") || !timePattern.test(hora_cierre || "")) {
        return res.status(400).json({ mensaje: "Las horas deben tener formato HH:mm" });
    }
    if (timeToSeconds(hora_cierre) <= timeToSeconds(hora_apertura)) {
        return res.status(400).json({ mensaje: "La hora de cierre debe ser posterior a la apertura" });
    }

    try {
        const resultado = await pool.query(
            `INSERT INTO horario (dia_semana, hora_apertura, hora_cierre, activo)
             VALUES ($1, $2, $3, TRUE)
             RETURNING id_horario, dia_semana, hora_apertura, hora_cierre, activo`,
            [weekday, hora_apertura, hora_cierre]
        );
        return res.status(201).json({
            mensaje: "Franja horaria creada exitosamente",
            horario: resultado.rows[0]
        });
    } catch (error) {
        console.error("Error creando horario:", error);
        return res.status(500).json({ mensaje: "Error al crear la franja horaria" });
    }
};

const actualizarEstadoHorario = async (req, res) => {
    const id = Number(req.params.id);
    const { activo } = req.body;

    if (!Number.isInteger(id) || id <= 0) {
        return res.status(400).json({ mensaje: "El ID del horario debe ser un número válido" });
    }
    if (typeof activo !== "boolean") {
        return res.status(400).json({ mensaje: "El estado activo debe ser verdadero o falso" });
    }

    try {
        const resultado = await pool.query(
            `UPDATE horario
             SET activo = $1
             WHERE id_horario = $2
             RETURNING id_horario, dia_semana, hora_apertura, hora_cierre, activo`,
            [activo, id]
        );
        if (resultado.rows.length === 0) {
            return res.status(404).json({ mensaje: "Franja horaria no encontrada" });
        }
        return res.status(200).json({
            mensaje: "Estado del horario actualizado",
            horario: resultado.rows[0]
        });
    } catch (error) {
        console.error("Error actualizando horario:", error);
        return res.status(500).json({ mensaje: "Error al actualizar el estado del horario" });
    }
};

module.exports = { listarHorarios, crearHorario, actualizarEstadoHorario };
