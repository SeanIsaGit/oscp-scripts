#!/bin/bash
dir=~/attack/$1

if [[ ! -e $dir ]]; then
    mkdir $dir

fi
mkdir $dir/info
nmap $1 -vv -p- -sT -T4 --reason --dns-server 10.11.1.220 | tee $dir/info/full_port
