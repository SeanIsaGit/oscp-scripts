#!/bin/bash

for ip in $(seq 1 254);do 
    nslookup 10.11.1.$ip | grep -v "NXDOMAIN" | grep name
done
