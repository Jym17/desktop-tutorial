---
titulo: Método de trabajo con Claude
fecha: 2026-09-16
origen: Sesión Cuentas Claras — publicación PWA e íconos
tags:
  - método
  - depuración
  - principios
---

# Método de trabajo con Claude

Seis reglas salidas de errores reales, no de teoría. Cada una lleva la cicatriz
que la originó — una norma sin su cicatriz se ignora.

## 1. Antes de optimizar el mecanismo, verifica que el mecanismo esté conectado

El fallo más caro de la sesión: el ícono no aparecía en la pantalla de inicio
del iPhone. Cuatro rondas invertidas en invalidar cachés, versionar rutas,
añadir `.nojekyll` y reiniciar el teléfono.

La causa real: los `<link>` estaban **dentro del `<body>`**, así que Safari
nunca llegó a pedir el ícono. Se estaba optimizando la entrega de algo que
nadie solicitaba.

## 2. «¿Esto funcionó alguna vez?»

Primera pregunta ante cualquier fallo. Si la respuesta es **no**, deja de buscar
qué se rompió y busca **qué nunca estuvo bien puesto**.

Un problema de caché, de despliegue o de versión exige que antes existiera un
estado bueno. Sin ese estado previo, la hipótesis es imposible por definición.

## 3. Si el fallo sobrevive a tus arreglos, revisa el diagnóstico, no la ejecución

Apilar arreglos sin verificar la premisa es la señal de que la hipótesis está
mal. Y cada arreglo nuevo sobre un diagnóstico sin confirmar **añade superficie
de fallo**: renombrar los íconos provocó 404 temporales que empeoraron el
síntoma.

## 4. Una observación del usuario vale más que tres hipótesis del técnico

Pide datos, no interpretaciones.

> «No funciona» no es un dato.
> «Sale un cuadrado negro con una C» sí lo es.

Una URL abierta y dos palabras de respuesta partieron en dos un problema que
llevaba tres rondas sin resolverse.

## 5. Verificar antes de afirmar

Las pruebas se ejecutan en un navegador real antes de publicar. El estado de un
despliegue se consulta, no se supone. Y cuando algo **no se puede** comprobar,
se dice con claridad en lugar de darlo por bueno.

## 6. Reconocer cuándo el propio trabajo es peor que el estándar

El signo § del ícono se intentó dibujar a mano con curvas vectoriales. Salió
peor que el glifo de una tipografía diseñada por profesionales. Se tiró.

Defender un trabajo propio mediocre cuesta más que descartarlo.

---

## Aplicación al negocio

Estas reglas no son de programación, son de **diagnóstico**. Sirven igual con un
cliente que dice «la web va lenta» o «no me llegan los formularios».

- Pregunta 2 aplicada a un cliente: *¿esto te funcionó alguna vez?* Separa
  «algo se rompió» de «nunca estuvo bien montado». Son dos facturas distintas.
- Pregunta 4 aplicada a un cliente: pide la captura, no el resumen.

Ver también: [[Trampas web — PWA e íconos]] · [[Cuentas Claras — Proyecto]]
