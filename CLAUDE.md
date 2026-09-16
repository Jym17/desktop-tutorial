# Cómo trabajar en este repositorio

App de finanzas personales **Cuentas Claras**. Un solo archivo (`index.html`)
con HTML, CSS y JavaScript plano: sin dependencias, sin build, sin backend.
Corre en dos sitios a la vez y se adapta al que le toque:

- **Dentro de Claude**, como artifact (ahí existe `window.claude`: sincronización
  en la nube y descargas por capability).
- **Como app instalada**, publicada en GitHub Pages
  (`https://jym17.github.io/desktop-tutorial/`), donde todo es localStorage y
  descargas por Blob.

El idioma del proyecto es **español**: interfaz, comentarios del código y
mensajes de commit.

---

## Método de trabajo

Estas reglas salieron de errores reales cometidos en este repositorio, no de
teoría. Se respetan aunque cuesten tiempo.

### 1. Antes de optimizar el mecanismo, verifica que el mecanismo esté conectado

El fallo más caro de este proyecto: el ícono no aparecía en la pantalla de
inicio del iPhone. Se invirtieron cuatro rondas en invalidar cachés, versionar
rutas de archivo, añadir `.nojekyll` y reiniciar el teléfono.

La causa real era que los `<link>` estaban **dentro del `<body>`**, así que
Safari nunca llegó a pedir el ícono. Se estaba optimizando la entrega de algo
que no se solicitaba.

### 2. «¿Esto funcionó alguna vez?»

Es la primera pregunta ante cualquier fallo. Si la respuesta es **no**, deja de
buscar qué se rompió y busca **qué nunca estuvo bien puesto**. Un problema de
caché, de despliegue o de versión exige que antes existiera un estado bueno.

En el caso del ícono, el dato estaba en la primera captura del usuario y se
mencionó de pasada sin actuar en consecuencia.

### 3. Si el fallo sobrevive a tus arreglos, revisa el diagnóstico, no la ejecución

Apilar un arreglo sobre otro sin verificar la premisa es la señal de que la
hipótesis está mal. Cada arreglo nuevo sobre un diagnóstico sin confirmar añade
superficie de fallo: renombrar los íconos, por ejemplo, provocó 404 temporales
que empeoraron el síntoma.

### 4. Una observación del usuario vale más que tres hipótesis propias

El entorno de desarrollo **no puede alcanzar `jym17.github.io`** (la red de
salida lo bloquea). Cuando el problema viva del lado del usuario, pídele una
observación concreta y comprobable — «abre esta URL y dime qué ves» — en lugar
de seguir adivinando. Pide datos, no interpretaciones.

### 5. Verificar antes de afirmar

Nada se da por hecho: las pruebas se ejecutan en un navegador real antes de
publicar, y el estado de un despliegue se consulta, no se supone. Cuando algo
no se pueda comprobar (como abrir el sitio en vivo), se dice con claridad en
lugar de darlo por bueno.

### 6. Reconocer cuándo el propio trabajo es peor que el estándar

El signo `§` del ícono se intentó dibujar a mano con curvas vectoriales. Salió
peor que el glifo de una tipografía diseñada por profesionales. Se tiró y se
usó el bueno. Defender un trabajo propio mediocre cuesta más que descartarlo.

---

## Trampas ya pagadas (no repetirlas)

### El `<head>` es real y se respeta

`index.html` abre con una línea que cierra `</head><body>` muy pronto. **Todo
`<meta>`, `<title>` y `<link>` debe quedar dentro de `<head>`**, antes de ese
cierre. Safari en iOS ignora `apple-touch-icon` si está en el `<body>` — el
manifiesto sí lo tolera, lo que despista el diagnóstico.

Tras cualquier cambio en la cabecera, verificar en navegador real que
`document.head` contiene los enlaces y que el `<body>` no tiene residuos.

### Cambiar un ícono son DOS pasos

1. **Renombrar los archivos** (`-v2` → `-v3`…) y actualizar sus referencias en
   `index.html`, `manifest.json` y `sw.js`. Una URL nueva no puede servirse
   desde ninguna caché.
2. **Subir `VERSION` en `sw.js`**, para que los dispositivos ya instalados
   descarten la caché anterior.

**Nunca borrar los nombres antiguos de golpe.** Se dejan conviviendo, con el
diseño nuevo dentro, hasta que las cachés expiren: un HTML cacheado que pida la
ruta vieja debe recibir un ícono válido, no un 404.

### En iPhone hay que borrar y volver a añadir

iOS nunca actualiza el ícono de un acceso directo ya creado. Y **jamás sugerir
«Borrar historial y datos de sitios web»**: eso eliminaría los datos
financieros del usuario, que viven en el localStorage de Safari.

### `/apple-touch-icon.png` por convención va en la raíz del DOMINIO

`jym17.github.io/apple-touch-icon.png`, no la subcarpeta del proyecto. En un
sitio servido desde subcarpeta esa red de seguridad no existe: los `<link>` son
la única vía.

### El service worker no intercepta íconos ni manifiesto

Van siempre directos a la red. Si el service worker fallara al servirlos, el
sistema operativo se queda sin ícono. No puede romper lo que no toca.

### `favicon.ico` no se versiona

El navegador lo pide en esa ruta exacta por convención; renombrarlo provoca un
404 en cada carga.

### El dinero es entero, en centavos

Nunca floats. Toda aritmética pasa por `App.money`. Las fechas son ISO
`YYYY-MM-DD` ancladas a mediodía UTC vía `App.date`; nunca `new Date(iso)`
seguido de getters locales. El conteo de ocurrencias usa
`App.date.occurrencesBetween`, jamás una división de días.

---

## Probar

```bash
python3 -m http.server 8777
```

Ocho suites internas, 138 comprobaciones. Desde la consola del navegador:

```js
App.money.__runTests(); App.date.__runTests();
App.calc.reserves.__runTests(); App.calc.available.__runTests();
App.calc.tx.__runTests(); App.calc.savings.__runTests();
App.planner.__runTests(); App.state.__runTests();
```

Antes de publicar, comprobar en Chromium real a **390×844 y 1440×900**: las seis
pantallas sin desborde horizontal, sin errores de consola, y las suites en
verde. Hay Chromium en `/opt/pw-browsers/chromium-1194/chrome-linux/chrome`.

---

## Publicar

- **GitHub Pages** sirve la rama `claude/cuentas-claras-mobile-responsive-2pkbyv`
  desde `/ (root)`. Cada push despliega solo; el estado se consulta con las
  herramientas de GitHub, no se supone.
- **El artifact** se actualiza republicando `index.html` con su URL.
- El repositorio es público para que Pages funcione en el plan gratuito. **No
  contiene datos personales**: los del usuario viven en su navegador.
