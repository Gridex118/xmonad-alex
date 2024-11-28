#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[0;36m'

FILE=/tmp/testc.c
HIST=/tmp/testc.last
TARGET=/tmp/testc.out

COMPILER_FLAGS="-Wall -Wextra"

read -r code_to_run
if [[ -z $code_to_run ]]; then
    code_to_run="$(cat $HIST)"
else
    echo $code_to_run > $HIST
fi

echo
echo "#include <stdio.h>" >> $FILE
for lib in "$@"; do
    case "$lib" in
        math)
        COMPILER_FLAGS=$COMPILER_FLAGS" -lm"
        ;;
        SDL*)
        COMPILER_FLAGS=$COMPILER_FLAGS" -lSDL2"
        ;;
    esac
    echo "#include <${lib}.h>" >> $FILE
done
echo "int main(void) {" >> $FILE
echo "    ${code_to_run};" >> $FILE
echo "    return 0;" >> $FILE
echo "}" >> $FILE

bat $FILE
echo
echo -n -e "Run with flags: ${RED}${COMPILER_FLAGS}${NC}? (y/n)? "
read -r run_code
echo

if [[ $run_code = "y" ]]; then
    echo -e "${CYAN}Output:${NC}"
    gcc $COMPILER_FLAGS $FILE -o $TARGET&& $TARGET
fi

# Clean up
[ -f $FILE ]&& rm $FILE
[ -f $TARGET ]&& rm $TARGET
