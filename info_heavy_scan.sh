#!/bin/bash
dir=~/attack/$1

if [[ ! -e $dir ]]; then
    mkdir $dir

fi
mkdir $dir/info
nmap $1 -vv -p- -sV --reason --dns-server 10.11.1.220 | tee $dir/info/heavy_scan
