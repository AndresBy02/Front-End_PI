document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('login-form');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const errorMessage = document.getElementById('error-message');

    if (loginForm) {
        loginForm.addEventListener('submit', async (e) => {
            e.preventDefault(); // 1. Evita que la página se recargue

            const email = emailInput.value.trim();
            const password = passwordInput.value.trim();

            // 2. Validación básica en el frontend
            if (!email || !password) {
                mostrarError('Por favor, completa todos los campos.');
                return;
            }

            // 3. Aquí irá la conexión al backend (Tarea 2)
            console.log('Intentando iniciar sesión con:', email);
        });
    }

    function mostrarError(mensaje) {
        if (errorMessage) {
            errorMessage.textContent = mensaje;
            errorMessage.style.display = 'block';
        } else {
            alert(mensaje);
        }
    }
});