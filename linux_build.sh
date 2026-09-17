#!/bin/bash
# -----------------------------------------------------------------------------
#  BUILD del modulo de produccion "Puerta de Baldur 5E", el mismo nombre que usa el host.
#
#  Fuente unica: src/. Nunca se edita "modules/Puerta de Baldur 5E/".
#
#  Uso:
#    ./linux_build.sh                    Compila lo cambiado y empaqueta
#                                            "modules/Puerta de Baldur 5E.mod"
#    ./linux_build.sh --check            Comprueba que src/ compila.
#                                            Simula: no escribe ningun fichero.
#    ./linux_build.sh --check a.nss ...  Comprueba solo esos.
#    ./linux_build.sh --clean            Vacia la cache y recompila todo.
#
#  Despues de un build:  ./linux_run_server.sh
#
#  Compilador: tools/linux/neverwinter/nwn_script_comp, que usa
#  libnwnscriptcomp.so (la libreria oficial del juego). Compila igual que
#  Aurora y es el compilador por defecto de nasher >= 1.0.
#
#  La ruta de NWN sale de $NWN_ROOT o de autodeteccion; no se pasa por flags.
#  El encoding por defecto ya es windows-1252, que es el de los .nss de PDB.
#
#  Nota: en este compilador -s significa SIMULAR (compilar sin escribir).
# -----------------------------------------------------------------------------
set -u

RAIZ="$(cd "$(dirname "$0")" && pwd)"
cd "$RAIZ"

COMP="$RAIZ/tools/linux/neverwinter/nwn_script_comp"
NASHER="$RAIZ/tools/linux/nasher/nasher"

# Script roots included in the production module.
SRC_NSS="$RAIZ/src/shared/nss $RAIZ/src/cnr/nss $RAIZ/src/cnr/nui $RAIZ/src/pwdb/nss"
DIRS=$(echo "$SRC_NSS" | tr ' ' ',')

[ -x "$COMP" ] || { echo "ERROR: no existe $COMP"; exit 1; }

# ---------------------------------------------------------------- --check ----
if [ "${1:-}" = "--check" ]; then
    shift
    if [ $# -gt 0 ]; then
        LISTA=""
        for n in "$@"; do
            f=$(find src -name "$n" -o -name "$n.nss" | head -1)
            [ -z "$f" ] && { echo "  no encontrado en src/: $n"; continue; }
            LISTA="$LISTA $f"
        done
        [ -z "$LISTA" ] && { echo "Nada que comprobar."; exit 1; }
        echo "=== Comprobando $# fichero(s) ==="
    else
        LISTA="$SRC_NSS"
        echo "=== Comprobando todo src/ ==="
    fi

    LOG=$(mktemp)
    # shellcheck disable=SC2086
    "$COMP" --dirs "$DIRS" -y -s -c $LISTA > "$LOG" 2>&1
    RC=$?

    grep -iE "error|Unable to open" "$LOG" | head -20 | sed 's/^/  /'
    tail -1 "$LOG" | sed 's/^/  /'
    rm -f "$LOG"
    echo "(--check no escribe nada; para desplegar usa ./linux_build.sh)"
    exit $RC
fi

# ----------------------------------------------------------------- build -----
EXTRA=""
if [ "${1:-}" = "--clean" ]; then
    EXTRA="--clean"
    echo "Modo --clean: se vacia la cache y se recompila todo. Esto tarda."
fi

echo "=== Compilando src/ y empaquetando ==="
# Sin --nssFlags: vacio es el valor por defecto de nasher para nwn_script_comp.
# Nasher construye la invocacion (ficheros, salida e includes) por si mismo.
# shellcheck disable=SC2086
"$NASHER" install default $EXTRA --verbose \
  --erfUtil:"$RAIZ/tools/linux/neverwinter/nwn_erf" \
  --gffUtil:"$RAIZ/tools/linux/neverwinter/nwn_gff" \
  --tlkUtil:"$RAIZ/tools/linux/neverwinter/nwn_tlk" \
  --nssCompiler:"$COMP" \
  --installDir:"$RAIZ" \
  --yes

MOD="$RAIZ/modules/Puerta de Baldur 5E.mod"
[ -f "$MOD" ] || { echo; echo "BUILD FALLIDO - no existe $MOD"; exit 1; }

echo
echo "=== Build correcto ==="
echo "  $MOD"
echo "  $(stat -c '%y' "$MOD" | cut -c1-19)   $(du -h "$MOD" | cut -f1)"
echo
echo "Siguiente paso:  ./linux_run_server.sh"
