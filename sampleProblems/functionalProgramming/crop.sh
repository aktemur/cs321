#!/bin/bash

filename=$1
extension="${filename##*.}"
filename="${filename%.*}"
pdfcrop ${filename}.pdf
mv ${filename}-crop.pdf ${filename}.pdf
