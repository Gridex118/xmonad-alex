#!/bin/bash

SRC="$1"
TITLE="${SRC%.*}"
FILENAME="$TITLE".latex
DST="$HOME/authoring/texcode/"$FILENAME
if [[ -f $DST ]]; then
    rm $DST
fi

echo "\\documentclass[14pt]{extarticle}" >> $DST
echo "\\usepackage[paperwidth=20cm, paperheight=28cm, margin=1cm]{geometry}" >> $DST
echo "\\usepackage[a4, frame, center, noinfo]{crop}" >> $DST
echo "\\usepackage[T1]{fontenc}" >> $DST
echo "\\usepackage{fontspec}" >> $DST
echo "\\newfontfamily\\meslo[Ligatures=TeX]{MesloLGS NF}" >> $DST
echo "\\usepackage{textcomp}" >> $DST
echo "\\usepackage{listings, lstautogobble}" >> $DST
echo "\\usepackage{nopageno}" >> $DST
echo "\\usepackage{algorithm}" >> $DST
echo "\\usepackage{algorithmic}" >> $DST
echo "\\usepackage{caption}" >> $DST
echo "\\setlength\\parindent{0px}" >> $DST
echo "\\lstset{basicstyle=\ttfamily, upquote=true, language=c, breaklines=true, autogobble=true, showstringspaces=false}" >> $DST

echo "\\title{}" >> $DST
echo "\\author{}" >> $DST
echo "\\date{}" >> $DST

echo "\\begin{document}" >> $DST

echo "\\maketitle" >> $DST
echo "\\vspace{-5em}" >> $DST

echo -n "Aim: " >> $DST
echo "Aim?"
cat >> $DST
echo >> $DST
echo "\\vspace{3em}" >> $DST
echo "Code:" >> $DST
echo "\\begin{lstlisting}" >> $DST
cat $SRC >> $DST
echo "\\end{lstlisting}" >> $DST
echo "\\vspace{3em}" >> $DST
echo >> $DST
echo "{" >> $DST
echo "\\meslo" >> $DST
echo "Output:\\\\" >> $DST
echo "}" >> $DST

echo "\\end{document}" >> $DST

cd ~/authoring/texcode
latexmk -quiet -lualatex -f -auxdir=$HOME/.texbuild/ -outdir=$HOME/authoring/texcode/pdf/ $FILENAME
zathura pdf/"$TITLE".pdf&
nvim $FILENAME
