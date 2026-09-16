# Cuentas Claras

App de finanzas personales. Responde a una sola pregunta, bien: **¿cuánto puedo
gastar hoy sin romper nada?** — descontando lo que ya está comprometido en
facturas, deudas, metas de ahorro y tu colchón de seguridad.

Es una app de un solo archivo (`index.html`): HTML, CSS y JavaScript sin
dependencias, sin build, sin servidor. Se abre igual desde un enlace, desde el
ícono de tu teléfono o desde un archivo local.

---

## Publicarla en tu propio enlace (GitHub Pages)

Una vez publicada, la app vive en una dirección tuya, pública y gratuita. No
hace falta iniciar sesión en ningún sitio para abrirla.

1. En este repositorio, entra en **Settings → Pages**.
2. En *Build and deployment* → *Source*, elige **Deploy from a branch**.
3. Branch: la rama donde está este código (`main`, o la rama de trabajo
   `claude/cuentas-claras-mobile-responsive-2pkbyv`). Carpeta: **/ (root)**.
4. **Save**. En uno o dos minutos la app queda en:

   ```
   https://jym17.github.io/desktop-tutorial/
   ```

GitHub Pages sirve por HTTPS, que es justo lo que necesitan el service worker y
la instalación en el teléfono.

## Instalarla en el teléfono

Abre ese enlace en el navegador del móvil y:

- **Android / Chrome:** aparece el aviso *Instalar app*. También está el botón
  **Instalar la app** dentro de *Copia de seguridad*.
- **iPhone / Safari:** botón **Compartir** → **Añadir a pantalla de inicio**.

Queda como un ícono más, abre a pantalla completa (sin barra del navegador) y
**funciona sin conexión**: el service worker (`sw.js`) guarda la app en el
dispositivo, así que abre igual en el metro o sin datos.

## Tus datos

| | Dentro de Claude (artifact) | Esta copia instalada |
|---|---|---|
| Guardado | navegador + copia en la nube del artifact | navegador de este dispositivo |
| Entre dispositivos | se sincroniza solo | no se sincroniza |
| Respaldo | exportar JSON | exportar JSON |

Los datos **nunca salen hacia un servidor propio**: no hay backend. Por eso la
regla práctica es exportar el respaldo JSON de vez en cuando.

**Para llevarte los datos de una copia a otra:** *Copia de seguridad* →
**Exportar respaldo completo (JSON)** en el origen, y en el destino
*Copia de seguridad* → **Importar** → modo *Reemplazar todo*.

---

## Archivos

| Archivo | Para qué |
|---|---|
| `index.html` | La app completa: interfaz, cálculos y persistencia |
| `manifest.webmanifest` | Nombre, íconos y modo pantalla completa al instalar |
| `sw.js` | Service worker: arranque instantáneo y modo sin conexión |
| `icons/` | Íconos de la app (SVG fuente + PNG generados) |
| `favicon.ico` | Ícono de la pestaña del navegador |

Dentro de `index.html`, el código está separado por módulos comentados:

- `money.js` / `date.js` — aritmética en **centavos enteros** (nunca floats) y
  fechas ISO ancladas a mediodía UTC, para que no haya errores de redondeo ni
  días corridos por zona horaria.
- `reservas.js` — cuánto separar de cada cobro para cada factura, y el cálculo
  del disponible real.
- `transacciones.js` — las 8 reglas contables (transferencias, tarjetas de
  crédito, reembolsos…).
- `ahorro.js` — progreso de metas y plan semanal.
- `estado.js` — persistencia, exportación CSV/JSON, importación y datos de
  ejemplo.
- `dbsync.js` — sincronización en la nube cuando corre dentro de Claude.
- `app.js` — interfaz, navegación y adaptación a móvil.

## Probar en local

```bash
python3 -m http.server 8777
# abre http://127.0.0.1:8777/
```

Las suites de pruebas internas se ejecutan desde la consola del navegador:

```js
App.money.__runTests(); App.date.__runTests();
App.calc.reserves.__runTests(); App.calc.available.__runTests();
App.calc.tx.__runTests(); App.calc.savings.__runTests();
App.planner.__runTests(); App.state.__runTests();
```

## Regenerar los íconos

Los PNG salen de los SVG de `icons/`. Si cambias el diseño, vuelve a
rasterizarlos con cualquier herramienta a 192, 512 (normal y *maskable*) y 180
píxeles (`apple-touch-icon.png`).
