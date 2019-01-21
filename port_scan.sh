#!/bin/bash

dir=~/attack/$1
inf_dir=~/attack/$1/info
#expl_dir=~/attack/$1/exploit
res_dir=~/attack/$1/resources

if [[ ! -e $dir ]]; then
    mkdir $dir
fi

if [[ ! -e $inf_dir ]]; then
    mkdir $inf_dir
fi
#if [[ ! -e $expl_dir ]]; then
#    mkdir $expl_dir
#fi

if [[ ! -e $res_dir ]]; then
    mkdir $res_dir
fi

echo -e  "Performing a light scan"
echo -e  "[*] nmap $1 -vv -sT --top-ports 10 --open"
nmap $1 -vv -sT --top-ports 10 --open > $inf_dir/light_scan
echo -e  "Light scan performed - results saved in $inf_dir/light_scan\n"

echo -e  "Now performing a full port scan"
echo -e  "[*] nmap $1 -vv -p- -sT -T4 --reason --dns-server 10.11.1.220"
nmap $1 -vv -p- -sT -T4 --reason --dns-server 10.11.1.220 > $inf_dir/full_port
echo -e  "Full port scan performed - results saved in $inf_dir/full_port\n"

echo -e  "Extracting open ports from scan"
cat $dir/info/full_port | grep open | grep -v Discovered | cut -d '/' -f1 | sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}' > $inf_dir/open_ports.csv
echo -e  "[*] CSV file created: $inf_dir/open_ports.csv"
cat $dir/info/full_port | grep open | grep -v Discovered | cut -d '/' -f1  > $inf_dir/open_ports.txt
echo -e  "[*] TXT file created: $inf_dir/open_ports.txt\n"

echo -e  "Now performing a version scan"
echo -e  "nmap $1 -vv -p \`cat $inf_dir/open_ports.csv\` -sV"
nmap $1 -vv -p `cat $inf_dir/open_ports.csv` -sV > $inf_dir/open_port_version
echo -e  "Version scan performed - results saved in $inf_dir/open_port_version\n"

echo -e "Now perfoming UDP scan"
echo $1 > $res_dir/ip.txt
echo -e "/root/bin/onetwopunch.sh -t $res_dir/ip.txt -p udp"
/root/bin/onetwopunch.sh -t $res_dir/ip.txt -p udp > $inf_dir/udp.txt
echo -e  "UDP scan performed - results saved in $inf_dir/udp.txt\n"

echo -e "Scan results:\n"

echo -e "Light scan"
cat $inf_dir/light_scan
echo -e "\n"

echo -e "Full port scan"
cat $inf_dir/full_port
echo -e "\n"

echo -e "Version scan"
cat $inf_dir/open_port_version
echo -e "\n"

echo -e "UDP scan"
cat $inf_dir/udp.txt
echo -e "\n"
