#!/bin/bash

:>/etc/apt/sources.list
echo "deb http://ftp.de.debian.org/debian/ stretch main contrib non-free">>/etc/apt/sources.list
echo "deb http://ftp.de.debian.org/debian/ stretch-updates main contrib non-free">>/etc/apt/sources.list
echo "deb http://sft.if.usp.br/debian/ stretch contrib non-free main">>/etc/apt/sources.list
echo "deb-src http://sft.if.usp.br/debian/ stretch contrib non-free main">>/etc/apt/sources.list
echo "deb http://deb.debian.org/debian/ stretch-updates main contrib">>/etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ stretch-updates main contrib">>/etc/apt/sources.list
echo "deb http://security.debian.org/ stretch/updates main main contrib non-free">>/etc/apt/sources.list
echo "deb http://security.debian.org/debian-security stretch/updates main contrib">>/etc/apt/source.list
echo "deb-src http://security.debian.org/debian-security stretch/updates main contrib">>/etc/apt/source.list
DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y
