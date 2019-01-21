#!/bin/bash


gobuster -t 20 -u http://$1:80 -w /usr/share/seclists/Discovery/Web_Content/common.txt-s '200,204,301,302,307,403,500' -e
