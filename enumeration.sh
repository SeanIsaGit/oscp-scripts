#!/bin/bash

dir=~/attack/$1
inf_dir=~/attack/$1/info
expl_dir=~/attack/$1/exploit
res_dir=~/attack/$1/resources
snmp=$(nmap -sU --open -p 161 $1 | grep open | cut -d "/" -f1)
com_string=$(onesixtyone -c ~/resources/community.txt $1 | grep $1 | cut -d "[" -f2 | cut -d "]" -f1)
IP=$1
OS=$2

if [[ ! -e $dir ]]; then
    mkdir $dir
fi

if [[ ! -e $inf_dir ]]; then
    mkdir $inf_dir
fi

if [[ ! -e $expl_dir ]]; then
    mkdir $expl_dir
fi

if [[ ! -e $res_dir ]]; then
    mkdir $res_dir
fi

echo -e "**** This is a script for enumerating HTTP, HTTPS, SMB, FTP, SMTP, SNMP, POP, IMAP, MYSQL and SSH ****\n\n"

while read port; do

if [ "$port" -eq "80" ]; then
    echo -e "Port 80 is open dude!"
    ################################
    echo -e "Unable to run gobuster:\n Run gobuster manually with the following command:\n gobuster -u http://$1:80 -w /usr/share/seclists/Discovery/Web_Content/common.txt -s '200,204,301,302,307,403,500' -e > $inf_dir/gobuster.txt\n"
    #~/bin/gobuster.sh $1 > $inf_dir/gobuster.txt
    #echo -e "Results saved in: $inf_dir/gobuster.txt\n"
    #sleep 5
    ################################
    echo -e "Running: nikto -host $1 -port 80"
    nikto -host $1 -port 80 > $inf_dir/nikto_80.txt
    echo -e "Results saved in: $inf_dir/nikto_80.txt\n"
    sleep 5
    ################################
    echo -e "Running: nmap -p 80 -vv --script http-enum* $1"
    nmap -p 80 -vv --script http-enum* $1 > $inf_dir/http_enum_nmap.txt
    echo -e "Results saved in: $inf_dir/http_enum_nmap.txt\n"
    sleep 5
    ################################
    echo -e "Running: nmap -p 80 -vv --script http-vuln* $1"
    nmap -p 80 -vv --script http-vuln* $1 > $inf_dir/http_vuln_nmap.txt
    echo -e "Results saved in: $inf_dir/http_vuln_nmap.txt\n"
    ################################
    sleep 5
fi

if [ "$port" -eq "443" ]; then
    echo -e "Port 443 is open dude!"
    ################################
    echo -e "Unable to run gobuster:\n Run gobuster manually with the following command:\n gobuster -u http://$1:443 -w /usr/share/seclists/Discovery/Web_Content/common.txt -s '200,204,301,302,307,403,500' -e > $inf_dir/gobuster.txt\n"
    #~/bin/gobuster.sh $1 > $inf_dir/gobuster.txt
    #echo -e "Results saved in: $inf_dir/gobuster.txt\n"
    #sleep 5
    ################################
    echo -e "Running: nikto -host $1 -port 443"
    nikto -host $1 -port 443 > $inf_dir/nikto_443.txt
    echo -e "Results saved in: $inf_dir/nikto_443.txt\n"
    sleep 5
    ################################
    echo -e "Running: nmap -p 443 -vv --script http-enum* $1"
    nmap -p 443 -vv --script http-enum* $1 > $inf_dir/http_enum_nmap.txt
    echo -e "Results saved in: $inf_dir/http_enum_nmap.txt\n"
    sleep 5
    ################################
    echo -e "Running: nmap -p 443 -vv --script http-vuln* $1"
    nmap -p 443 -vv --script http-vuln* $1 > $inf_dir/http_vuln_nmap.txt
    echo -e "Results saved in: $inf_dir/http_vuln_nmap.txt\n"
    ################################
    sleep 5
fi

if [ "$port" -eq "21" ]; then
    echo -e "Port 21 is open dude!"
    ################################
    echo -e "Running: nmap -vv -p 21 --script *ftp* $1"
    nmap -vv -p 21 --script ftp-anon,ftp-bounce,ftp-syst,ftp-proftpd-backdoor,ftp-vsftpd-backdoor,ftp-vuln-cve2010-4221,ftp-libopie $1 > $inf_dir/ftp_nmap.txt
    echo -e "Results saved in: $inf_dir/ftp_nmap.txt\n"
    ################################
fi

if [ "$port" -eq "22" ]; then
    echo -e "Port 22 is open dude!"
    ################################
    echo -e "Running: nmap -p 22 -vv --script *ssh* $1"
    nmap -p 22 -vv --script *ssh* $1 > $inf_dir/ssh_nmap.txt
    echo -e "Results saved in: $inf_dir/ssh_nmap.txt\n"
    ################################
fi

if [ "$port" -eq "25" ]; then
    echo -e "Port 25 is open dude!"
    ################################
    echo -e "Running: nmap -p 25 -vv --script smtp-vuln* $1"
    nmap -p 25 -vv --script smtp-vuln* $1 > $inf_dir/smtp_nmap.txt
    echo -e "Results saved in: $inf_dir/smtp_nmap.txt\n"
    ################################
fi

if [ "$port" -eq "110" ]; then
    echo -e "Port 110 is open dude!"
    ################################
    echo -e "Running: nmap -p 110 --script=*pop3* $1"
    nmap -p 110 --script=*pop3* $1 > $inf_dir/pop3_nmap.txt
    echo -e "Results saved in: $inf_dir/pop3_nmap.txt\n"
    ################################
fi

if [ "$port" -eq "143" ]; then
    echo -e "Port 143 is open dude!"
    ################################
    echo -e "Running: nmap -p 143 --script=imap-capabilities,imap-ntlm-info $1"
    nmap -p 143 --script=imap-capabilities,imap-ntlm-info $1 > $inf_dir/imap_nmap.txt
    echo -e "Results saved in: $inf_dir/imap_nmap.txt\n"
    ################################
fi

if [ "$port" -eq "139" ]; then
    echo -e "Port 139 is open dude!"
    ################################
    echo -e "Running: nmap -p139,445 -v --script smb-enum* $1"
    nmap -p139,445 -v --script smb-enum* $1 > $inf_dir/smb_enum_nmap.txt
    echo -e "Results saved in: $inf_dir/smb_enum_nmap.txt\n"
    sleep 5
    ################################
    echo -e "Running: nmap -p139,445 -v --script smb-vuln* $1"
    nmap -p139,445 -v --script smb-vuln* $1 > $inf_dir/smb_vuln_nmap.txt
    echo -e "Results saved in: $inf_dir/smb_vuln_nmap.txt\n"
    sleep 5
    ################################
    echo -e "Running: enum4linux $1"
    enum4linux $1 > $inf_dir/enum4linux.txt
    echo -e "Results saved in: $inf_dir/enum4linux.txt\n"
    ################################
fi

if [ "$port" -eq "110" ]; then
    echo -e "Port 110 is open dude!"
    ################################
    echo -e "Running: nmap -p 110 --script=*pop3* $1"
    nmap -p 110 --script=*pop3* $1 > $inf_dir/pop_enum.txt
    echo -e "Results saved in: $inf_dir/pop_enum.txt\n"
    sleep 5
    ################################
fi

if [ "$port" -eq "3306" ]; then
    echo -e "Port 3306 is open dude!"
    ################################
    echo -e "Running: nmap -p 3306 --script=mysql-empty-password,mysql-enum,mysql-users,mysql-variables,mysql-vuln* $1"
    nmap -p 3306 --script=mysql-empty-password,mysql-enum,mysql-users,mysql-variables,mysql-vuln* $1 > $inf_dir/mysql_enum.txt
    echo -e "Results saved in: $inf_dir/mysql_enum.txt\n"
    sleep 5
    ################################
fi

done < $inf_dir/open_ports.txt

if [ "161" -eq "$snmp" ]; then
    echo -e "UDP port 161 is open dude!"
    ################################
    if [ "$com_string" == "" ];then
        echo -e "Could not find a community string for $1"
        echo -e "enumeration script finished"
        exit 0
    fi
    sleep 5
    echo -e "Running: snmpwalk -c $com_string -v1 $1"
    snmpwalk -c $com_string -v1 $1 > $inf_dir/snmp_walk.txt
    echo -e "Results saved in: $inf_dir/snmp_walk.txt\n"
    ################################
    # sometimes hangs if OIDs aren't returning data
    #sleep 5
    #echo -e "Running: snmpenum $1 $com_string /usr/share/snmpenum/$2.txt"
    #snmpenum $1 $com_string /usr/share/snmpenum/$2.txt > $inf_dir/snmpenum_$2.txt
    #echo -e "Results saved in: $inf_dir/snmpenum_$2.txt\n"
    ################################
    sleep 5
    echo -e "Running: snmp-check -w -c $com_string $1"
    snmp-check -w -c $com_string $1 > $inf_dir/snmp-check.txt
    echo -e "Results saved in: $inf_dir/snmp-check.txt\n"
fi

echo -e "enumeration script finished"

