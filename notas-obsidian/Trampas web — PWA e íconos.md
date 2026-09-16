---
titulo: Trampas web — PWA e íconos
fecha: 2026-09-16
origen: Sesión Cuentas Claras — publicación PWA e íconos
tags:
  - web
  - pwa
  - ios
  - referencia
---

# Trampas web — PWA e íconos

Problemas concretos que costaron horas. Conocerlos es la diferencia entre
entregar en una tarde o en tres días.

## El `<head>` es real y se respeta

**Safari en iOS solo lee `apple-touch-icon` desde `<head>`.** Si el `<link>`
está en el `<body>`, lo ignora sin avisar y el sistema dibuja su comodín: un
cuadrado negro con la inicial del sitio.

Lo traicionero: **el manifiesto sí se tolera fuera del `<head>`**. Así que
aparece el interruptor «Open as Web App» y todo parece correcto. Dos etiquetas
vecinas, dos reglas distintas.

> Al depurar un ícono que no sale, lo primero es comprobar que el `<link>` está
> realmente dentro de `document.head`, no que el archivo exista.

## `/apple-touch-icon.png` por convención va en la raíz del DOMINIO

`ejemplo.com/apple-touch-icon.png`, **no** `ejemplo.com/proyecto/apple-touch-icon.png`.

En un sitio servido desde subcarpeta (típico de GitHub Pages) esa red de
seguridad no existe. Los `<link>` son la única vía.

## Cambiar un ícono son DOS pasos, no uno

1. **Renombrar los archivos** (`-v2` → `-v3`…) y actualizar sus referencias.
   Una URL nueva no puede servirse desde ninguna caché.
2. **Subir la versión del service worker**, para que los dispositivos ya
   instalados descarten la caché anterior.

Saltarse el paso 1 es la causa clásica de *«cambié el ícono y sigue saliendo el
viejo»*.

## Nunca borrar las rutas viejas de golpe

Al versionar nombres, los antiguos se dejan conviviendo **con el contenido
nuevo dentro**, hasta que las cachés expiren.

Un HTML servido desde caché pedirá la ruta vieja. Si ya no existe, recibe un
404 y el resultado es peor que el problema original: en vez de un ícono
desactualizado, ninguno.

> Un 404 de un minuto puede durar semanas en la caché de alguien.

## Cuatro cachés sobre la misma URL

Al publicar en GitHub Pages, un mismo archivo pasa por:

```
CDN de Pages  →  caché HTTP del navegador  →  service worker  →  caché de íconos del SO
```

Invalidar una sola no sirve de nada. Cambiar el **nombre del archivo** las
salta todas a la vez.

## En iPhone hay que borrar y volver a añadir

iOS **nunca** actualiza el ícono de un acceso directo ya creado.

🚫 Y jamás sugerir *«Borrar historial y datos de sitios web»*: eso elimina el
`localStorage`, donde vive todo el dato de una app web. En una app de finanzas,
eso es borrarle las cuentas al usuario.

## Detalles que evitan que una web «se sienta barata» en móvil

| Detalle | Por qué |
|---|---|
| Campos de formulario a **16px** | Por debajo, iOS hace zoom automático al tocarlos |
| Objetivos táctiles de **44px** | Por debajo, el pulgar falla |
| `safe-area-inset` y `100dvh` | La muesca y la barra inferior del iPhone |
| Tablas → tarjetas apiladas | Una tabla de 8 columnas en un móvil es scroll infinito |

Ninguno sale en una captura de pantalla. Todos se notan al usarla.

## Hospedaje gratuito exige código visible

GitHub Pages en repos privados requiere plan de pago. La regla que lo resuelve:
**separa siempre el código de los datos.** Si el código no lleva claves ni datos
de clientes, hacerlo público no cuesta nada y abre el alojamiento gratis.

Ver también: [[Método de trabajo con Claude]] · [[Cuentas Claras — Proyecto]]
