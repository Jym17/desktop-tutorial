#!/usr/bin/env bash
#
# sincronizar-obsidian.sh
#
# Copia las notas de este repositorio a una bóveda de Obsidian local.
#
# Pensado para ejecutarse en el Mac, donde sí hay acceso al disco. El
# contenedor donde corre Claude no alcanza la bóveda; GitHub es el terreno
# común entre los dos.
#
# USO
#   ./notas-obsidian/sincronizar-obsidian.sh "/ruta/a/tu/boveda"
#
# o definiendo la ruta una sola vez en el perfil del shell:
#   export OBSIDIAN_VAULT="/Users/tu-usuario/Documents/MiBoveda"
#   ./notas-obsidian/sincronizar-obsidian.sh
#
# Las notas se copian dentro de una subcarpeta propia de la bóveda, para no
# mezclarlas con el resto de tus notas.

set -euo pipefail

ORIGEN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBCARPETA="${OBSIDIAN_SUBCARPETA:-Cuentas Claras}"
VAULT="${1:-${OBSIDIAN_VAULT:-}}"

rojo()  { printf '\033[31m%s\033[0m\n' "$*"; }
verde() { printf '\033[32m%s\033[0m\n' "$*"; }
gris()  { printf '\033[90m%s\033[0m\n' "$*"; }

if [ -z "$VAULT" ]; then
  rojo "Falta la ruta de la bóveda."
  echo
  echo "  Pásala como argumento:"
  echo "    $0 \"/Users/tu-usuario/Documents/MiBoveda\""
  echo
  echo "  O defínela una vez en tu perfil (~/.zshrc):"
  echo "    export OBSIDIAN_VAULT=\"/Users/tu-usuario/Documents/MiBoveda\""
  echo
  echo "  Para saber la ruta: Obsidian → Ajustes → Acerca de → ruta de la bóveda."
  exit 1
fi

if [ ! -d "$VAULT" ]; then
  rojo "Esa carpeta no existe: $VAULT"
  exit 1
fi

# Toda bóveda real tiene una carpeta .obsidian. Si no está, puede que la ruta
# apunte a otro sitio: se avisa y se pide confirmación en vez de escribir a ciegas.
if [ ! -d "$VAULT/.obsidian" ]; then
  rojo "Aviso: \"$VAULT\" no contiene una carpeta .obsidian."
  echo "Puede que no sea una bóveda, o que aún no la hayas abierto nunca en Obsidian."
  printf "¿Escribir ahí de todos modos? [s/N] "
  read -r respuesta
  case "$respuesta" in
    s|S|si|Si|SI) ;;
    *) echo "Cancelado. No se ha tocado nada."; exit 0 ;;
  esac
fi

DESTINO="$VAULT/$SUBCARPETA"
mkdir -p "$DESTINO"

echo
gris "origen : $ORIGEN"
gris "destino: $DESTINO"
echo

copiadas=0
for archivo in "$ORIGEN"/*.md; do
  [ -e "$archivo" ] || continue
  nombre="$(basename "$archivo")"
  if [ -f "$DESTINO/$nombre" ] && cmp -s "$archivo" "$DESTINO/$nombre"; then
    gris "  = $nombre (sin cambios)"
  else
    cp "$archivo" "$DESTINO/$nombre"
    verde "  ✓ $nombre"
    copiadas=$((copiadas + 1))
  fi
done

echo
if [ "$copiadas" -eq 0 ]; then
  gris "Nada que actualizar: la bóveda ya estaba al día."
else
  verde "$copiadas nota(s) actualizada(s) en «$SUBCARPETA»."
fi
echo
gris "Nota: los archivos con el mismo nombre se sobrescriben. Si editas estas"
gris "notas dentro de Obsidian, tus cambios se perderán en la próxima copia."
