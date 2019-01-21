#!/bin/bash

dir=~/attack/$1

if [[ ! -e $dir ]]; then
    mkdir $dir

fi
mkdir $dir/info
cat $dir/info/full_port | grep open | grep -v Discovered | cut -d '/' -f1 | sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}' > $dir/info/open_ports
