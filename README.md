# Cuentas Claras

App de finanzas personales. Una sola página, sin dependencias ni compilación:
se abre `index.html` y funciona. Instalable en el teléfono (PWA) y operativa
sin conexión.

Responde a una pregunta que un saldo de banco no contesta:
**¿cuánto puedo gastar hoy sin quedarme corto para lo que viene?**

## Qué hace

- **Panel** — disponible real para gastar, con el desglose de por qué es ese número
  y no el saldo de la cuenta.
- **Transacciones** — historial con filtros plegables y contador de filtros activos.
- **Plan semanal** — semanas reales y proyectadas; herramienta para repartir un ingreso.
- **Metas y reservas** — cuánto apartar de cada cobro para cada factura, calculado
  contando los cobros reales que quedan antes del vencimiento (no dividiendo días).
- **Configuración** — cuentas, ingresos, gastos recurrentes, deudas, metas y
  categorías, organizados en carpetas plegables.
- **Copia de seguridad** — exportar CSV y JSON; importar respaldo JSON o
  transacciones desde CSV, con vista previa antes de guardar.

## Cómo usarla

Abre `index.html` en el navegador. Para tenerla como app en el teléfono:

- **iPhone / iPad** — ábrela en Safari, toca Compartir y elige
  *Añadir a pantalla de inicio*.
- **Android** — Chrome ofrece *Instalar* desde el menú, o desde el botón
  de la pantalla *Copia de seguridad*.

Servida por HTTPS (o en `localhost`) registra un service worker y queda
disponible sin conexión.

## Dónde viven los datos

En el almacenamiento del navegador (`localStorage`), en el dispositivo.
No viajan a ningún servidor propio.

Cada instalación es independiente: la copia del navegador y la añadida a la
pantalla de inicio **no comparten datos entre sí**. Para pasar información de
un dispositivo a otro se usa *Exportar respaldo completo (JSON)* y luego
*Restaurar un respaldo* con el modo **Reemplazar todo**.

> El CSV exporta solo los movimientos. El respaldo que conserva cuentas, metas,
> gastos recurrentes y ajustes es el **JSON**.

⚠️ Los archivos de respaldo contienen información financiera personal.
El `.gitignore` los excluye a propósito: no los subas al repositorio.

## Estructura

```
index.html              la app completa (estilos, módulos y lógica)
sw.js                   service worker (modo sin conexión)
manifest.json           metadatos de instalación
icons/                  iconos de la app
```

Dentro de `index.html`, el código está separado en módulos independientes:

| Módulo             | Responsabilidad                                            |
| ------------------ | ---------------------------------------------------------- |
| `money.js`         | aritmética en centavos enteros y fechas ISO                 |
| `reservas.js`      | reservas para facturas y disponible para gastar             |
| `transacciones.js` | reglas contables de movimientos y balances                  |
| `ahorro.js`        | metas de ahorro y plan semanal                              |
| `estado.js`        | estado, persistencia, importación y exportación             |
| `dbsync.js`        | sincronización opcional cuando corre dentro de Claude       |
| `app.js`           | interfaz y navegación                                       |

## Decisiones de diseño

- **El dinero son enteros en centavos, nunca decimales flotantes.** Evita que
  `0.1 + 0.2` produzca un céntimo fantasma en un saldo.
- **Las fechas se anclan a mediodía UTC.** Impide el clásico corrimiento de un
  día cerca de medianoche o con husos negativos.
- **Las ocurrencias se cuentan por calendario real**, nunca dividiendo días entre
  siete: un mes con cinco viernes ofrece cinco cobros, no cuatro.
- **Los datos de demostración jamás se guardan ni se sincronizan**, para que no
  puedan tapar información real.
- **El disponible puede salir negativo** y se muestra tal cual: un déficit
  escondido no es información, es un error silencioso.

## Pruebas

Cada módulo trae su propio conjunto de pruebas, ejecutable desde la consola
del navegador:

```js
App.money.__runTests();
App.date.__runTests();
App.calc.tx.__runTests();
App.calc.reserves.__runTests();
App.calc.available.__runTests();
App.calc.savings.__runTests();
App.planner.__runTests();
App.state.__runTests();
```
