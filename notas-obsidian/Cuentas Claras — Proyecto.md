---
titulo: Cuentas Claras — Proyecto
fecha: 2026-09-16
estado: publicado
url: https://jym17.github.io/desktop-tutorial/
repo: https://github.com/Jym17/desktop-tutorial
tags:
  - proyecto
  - app
  - finanzas
---

# Cuentas Claras — Proyecto

App de finanzas personales. Responde a una sola pregunta, bien:
**¿cuánto puedo gastar hoy sin romper nada?** — descontando lo ya comprometido
en facturas, deudas, metas de ahorro y colchón de seguridad.

## Dónde vive

| | Enlace |
|---|---|
| App instalable | https://jym17.github.io/desktop-tutorial/ |
| Código | https://github.com/Jym17/desktop-tutorial |
| Artifact (dentro de Claude) | https://claude.ai/artifact/YZojxhALWiwhAeD9SxUE7t |

Rama de trabajo: `claude/cuentas-claras-mobile-responsive-2pkbyv`

## Qué es técnicamente

Un solo archivo `index.html`: HTML, CSS y JavaScript plano. **Sin dependencias,
sin build, sin backend.** Corre en dos sitios y se adapta al que le toque:

- **Dentro de Claude** — existe `window.claude`: sincronización en la nube y
  descargas por capability.
- **Como app instalada** — todo es `localStorage` y descargas por Blob.

El mismo archivo detecta dónde está y elige la ruta. Ninguna versión se rompe.

## Dónde viven los datos

| | Dentro de Claude | App instalada |
|---|---|---|
| Guardado | navegador + nube del artifact | navegador del dispositivo |
| Entre dispositivos | se sincroniza solo | no se sincroniza |
| Respaldo | exportar JSON | exportar JSON |

**No hay servidor propio.** Los datos nunca salen del dispositivo. Por eso la
regla práctica es exportar el respaldo JSON con regularidad.

Para mover datos de una copia a otra: *Copia de seguridad → Exportar JSON* en
el origen, *Importar → Reemplazar todo* en el destino.

## Decisiones que sostienen la app

- **Dinero en centavos enteros**, nunca floats. Evita errores de redondeo.
- **Fechas ISO ancladas a mediodía UTC.** Evita el bug clásico de «se corre un
  día» cerca de medianoche.
- **Conteo de ocurrencias calendario a calendario**, nunca dividiendo días. Un
  mes puede tener 4 o 5 cobros semanales, y eso cambia cuánto hay que reservar.
- **Ocho suites de pruebas internas**, 138 comprobaciones, ejecutables desde la
  consola del navegador.

## Ideas que este proyecto dejó para reutilizar

**Una sola fuente, dos destinos.** Un archivo HTML que funciona como artifact,
como web y como app instalable. Para un cliente pequeño eso es una app sin
coste de hosting, sin tienda y sin mantenimiento.

**El PWA es el atajo comercial que casi nadie usa.** Manifiesto + service worker
+ íconos = «tu app» en la pantalla de inicio del cliente. Son tres archivos. La
diferencia de percepción entre «un enlace» y «un ícono que abre a pantalla
completa y funciona sin señal» es enorme, y producirla cuesta casi nada.

**Un logo que viaja nunca depende de una fuente instalada.** Si el texto no está
rasterizado o convertido a curvas, cada dispositivo dibuja lo que le da la gana.
Aplica a logos de clientes en PDF, firmas de correo y plantillas.

**Un ícono se diseña a 36 píxeles, no a 512.** Lo que luce espectacular en
grande puede ser una mancha en el teléfono. Mira siempre el tamaño de uso final
antes de enamorarte de una propuesta.

Ver también: [[Método de trabajo con Claude]] · [[Trampas web — PWA e íconos]]
