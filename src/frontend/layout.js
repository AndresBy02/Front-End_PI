/* ==========================================================================
   SAICI · Componente de layout (sidebar + topbar)
   Es el ÚNICO lugar donde se define la navegación y el encabezado.

   Uso en cada pantalla de escritorio (carpetas usuario/ y admin/):

     <link rel="stylesheet" href="../styles.css">
     ...
     <div class="wrap">
       <div class="app-frame">
         <div class="app-content"> ...contenido de la pantalla... </div>
       </div>
     </div>
     <script src="../layout.js"></script>

   El rol (usuario | admin) y el ítem activo se deducen de la URL.
   Las pantallas que no están en el menú (detalle, asistente, confirmación)
   simplemente no resaltan ningún ítem.
   ========================================================================== */
(function () {
  'use strict';

  // ---- Configuración editable ------------------------------------------
  var TOPBAR = {
    title: 'SAICI · Reservas UCEVA',
    subtitle: 'Hola, Laura Andrea (vista de demostración)',
    badge: 'PROTOTIPO · DATOS DE EJEMPLO'
  };
  var BRAND = { name: 'SAICI', tagline: 'Espacios universitarios' };
  var LOGIN = '../auth/01-login.html';

  // section = carpeta donde vive la pantalla
  var NAV = [
    { heading: null, items: [
      { section: 'usuario', file: '01-inicio.html',           label: 'Inicio' },
      { section: 'usuario', file: '02-explorar-espacios.html', label: 'Espacios' },
      { section: 'usuario', file: '06-mis-reservas.html',      label: 'Mis reservas' },
      { section: 'usuario', file: '08-perfil.html',            label: 'Perfil' }
    ]},
    { heading: 'Usuario', items: [
      { section: 'usuario', file: '07-historial-reservas.html',  label: 'Historial de reservas' },
      { section: 'usuario', file: '09-registrar-asistencia.html', label: 'Registrar asistencia' },
      { section: 'usuario', file: '10-historial-asistencia.html', label: 'Historial de asistencia' },
      { section: 'usuario', file: '18-menu.html', label: 'Más opciones' }
    ]},
    { heading: 'Administración', items: [
      { section: 'admin', file: '01-panel.html',               label: 'Panel administrativo' },
      { section: 'admin', file: '02-gestionar-reservas.html',  label: 'Gestionar reservas' },
      { section: 'admin', file: '03-gestionar-espacios.html',  label: 'Gestionar espacios' },
      { section: 'admin', file: '04-gestionar-horarios.html',  label: 'Gestionar horarios' },
      { section: 'admin', file: '05-estadisticas-reportes.html', label: 'Estadísticas y reportes' },
      { section: 'admin', file: '06-usuarios.html',            label: 'Usuarios' },
      { section: 'admin', file: '07-menu.html', label: 'Más opciones' }
    ]}
  ];
  // ----------------------------------------------------------------------

  var parts = location.pathname.split('/');
  var file = decodeURIComponent(parts[parts.length - 1] || '');
  var section = parts[parts.length - 2] || '';

  function el(tag, cls, text) {
    var n = document.createElement(tag);
    if (cls) n.className = cls;
    if (text != null) n.textContent = text;
    return n;
  }

  function link(href, label, active) {
    var a = el('a', 'app-nav__link' + (active ? ' is-active' : ''));
    a.href = href;
    a.appendChild(el('span', 'app-nav__text', label));
    return a;
  }

  function buildSidebar() {
    var side = el('div', 'app-sidebar');

    var brand = el('div', 'app-brand');
    brand.appendChild(el('div', 'app-brand__name', BRAND.name));
    brand.appendChild(el('div', 'app-brand__tagline', BRAND.tagline));
    side.appendChild(brand);

    NAV.forEach(function (group) {
      //Logica separacion de roles
      if (section === 'usuario' && group.heading === 'Administración') {
        return;
      }

      if (section === 'admin' && (group.heading === 'Usuario' || group.heading === null)) {
        return;
      }
      //Fin
      
      var nav = el('nav', 'app-nav');
      if (group.heading) {
        var h = el('div', 'app-nav__heading');
        h.appendChild(el('div', 'app-nav__heading-text', group.heading));
        nav.appendChild(h);
      }
      group.items.forEach(function (it) {
        var href = it.section === section ? it.file : '../' + it.section + '/' + it.file;
        nav.appendChild(link(href, it.label, it.section === section && it.file === file));
      });
      side.appendChild(nav);
    });

    side.appendChild(el('div', 'app-nav__spacer'));

    var foot = el('nav', 'app-nav');
    foot.appendChild(link(LOGIN, 'Volver al acceso', false));
    side.appendChild(foot);
    return side;
  }

  function buildTopbar() {
    var bar = el('div', 'app-topbar');
    var titles = el('div', 'app-topbar__titles');
    titles.appendChild(el('div', 'app-topbar__title', TOPBAR.title));
    titles.appendChild(el('div', 'app-topbar__subtitle', TOPBAR.subtitle));
    bar.appendChild(titles);
    var badge = el('div', 'app-badge');
    badge.appendChild(el('div', 'app-badge__text', TOPBAR.badge));
    bar.appendChild(badge);
    return bar;
  }

  var frame = document.querySelector('.app-frame');
  var content = frame && frame.querySelector(':scope > .app-content');
  if (!frame || !content) return;

  var main = el('div', 'app-main');
  main.appendChild(buildTopbar());
  main.appendChild(content);          // mueve el contenido existente

  frame.appendChild(buildSidebar());
  frame.appendChild(main);
})();
