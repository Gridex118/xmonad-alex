#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[0;36m'


function runbinary {
    NAME=${1%.*}
    nasm -felf64 ${NAME}.asm -o bin/${NAME}.o && ld bin/${NAME}.o -o bin/${NAME}.out && bin/${NAME}.out
    unset NAME
}

function runbf {
    NAME=${1%.*}
    bfc ${NAME}.bf&& ./a.out
    unset NAME
}

function runc {
    SRC=$1
    mkdir -p build
    OUT=build/"${SRC%.*}".out
    GCCARGS="-Wall -Wextra -g -O0"
    if [[ -n "$(grep 'math' $SRC)" ]]; then
        GCCARGS=$GCCARGS" -lm"
    fi
    echo -e "Running with flags: ${RED}${GCCARGS}${NC}"
    gcc $GCCARGS $SRC -o $OUT
    echo
    $OUT || exit -1
    unset SRC
    unset OUT
}

function runcpp {
    SRC=$1
    mkdir -p build
    OUT=build/"${SRC%.*}".out
    GPPARGS="-Wall -Wextra -g -O0"
    echo -e "Running with flags: ${RED}${GPPARGS}${NC}"
    g++ $GPPARGS $SRC -o $OUT
    echo
    $OUT || exit -1
    unset SRC
    unset OUT
}

if [ -z $2 ]; then
    LANG=${1#*.}
    echo "Detected Language: $LANG"
else
    LANG=$2
fi


case $LANG in
    c) runc $1;;
    cpp) runcpp $1;;
    asm) runbinary $1;;
    bf) runbf $1;;
    py) python $1;;
    *) echo "Unsupported source type";;
esac
