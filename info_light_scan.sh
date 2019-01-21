#!/bin/bash
dir=~/attack/$1

if [[ ! -e $dir ]]; then
    mkdir $dir

fi
mkdir $dir/info
nmap $1 -sT --top-ports 10 --open | tee $dir/info/light_scan
