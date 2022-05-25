#!/bin/bash

nc="\033[00m"
red="\033[01;31m"
green="\033[01;32m"
yellow="\033[01;33m"
blue="[debug]\033[01;34m"
purple="\033[01;35m"
cyan="\033[01;36m"

# default constant values
port="1337"
tordir=$PWD/hidden_service

logo="${yellow}__              ____  __ ${red}
${yellow}  ____   ____ |__| ____   ____ ${red}\   \/ /
${yellow} / __ \ /    \|  |/ __ \ /    \ ${red}\    / 
${yellow}(  \_\ )   |  \  |  \_\ )   |  ${red}\/    \ 
${yellow} \____/|___|  /__|\____/|___|  ${red}/___/\ \
${yellow}            \/               \/${red}      \/
${cyan} A dark web website for everyone ${nc}"

contact="
${yellow}YouTube -      ${purple}https://youtube.com/c/pwnos
${yellow}LinkedIn -     ${purple}https://linkedin.com/in/sam-sepi0l/
${yellow}Twitter -      ${purple}https://twitter.com/sam5epi0l
${yellow}Buymeacoffee - ${purple}https://www.buymeacoffee.com/sam5epi0l
${nc}"

echo -e "$logo $contact"

# checking for system root access
if [ "$(command -v sudo)" ]; then
  sudo="sudo"
  echo -e "${blue} Script will require sudo/root priviladges${nc}"
else
  sudo=""
  echo -e "${blue}You're a powerful enough to install packages${nc}"
fi

# checking for system home dir
if [ -d "$HOME" ]; then
  home=$HOME
else
  home="~/"
fi

echo -e "${blue} You live at ${green} $home ${nc}"

# checking for configuration dir
if [ -d /data/data/com.termux/files/usr/etc ]; then
  tor_conf_dir="/data/data/com.termux/files/usr/etc/tor"
elif [ -d /etc ]; then
  tor_conf_dir="/etc/tor"
fi

echo -e "${blue} TOR default configurations are here ${green} $tor_conf_dir ${nc}"

# checking for system bin dir
if [ -d /data/data/com.termux/files/usr/bin ]; then
  bin="/data/data/com.termux/files/usr/bin"
elif [ -d /sbin ]; then
  bin="/sbin"
elif [ -d /bin ]; then
  bin="/bin"
elif [ -d /usr/local/bin ]; then
  bin="/usr/local/bin"
fi

echo -e "${blue} Your bin directory is here $bin ${nc}"

# checking for system package manager
if [ -e /data/data/com.termux/files/usr/bin/pkg ]; then
  pac="pkg"
  system="termux"
elif [ "$(command -v apt)" ]; then
  pac="apt"
  system="linux"
elif [ "$(command -v apt-get)" ]; then
  pac="apt-get"
  system="linux"
elif [ "$(command -v apk)" ]; then
  pac="apk"
  system="linux"
elif [ "$(command -v yum)" ]; then
  pac="yum"
  system="fedora"
elif [ "$(command -v brew)" ]; then
  pac="brew"
  system="mac"
  sudo=""
fi

echo -e "${blue} Your system is $system and $pac is the package manager ${nc}"

echo -e "${blue} You are currently installing in $PWD directory ${nc}"

# setup process

echo -e "[-]${green} Installing .... ${nc}"
sleep 1
echo -e "[-]${yellow} Running setup .... ${nc}"
sleep 1

# installing dependency

# $sudo $pac update -y

#for each_pac in "tor"; do
if [ ! "$(command -v tor)" ]; then
  if [ "$sudo" ]; then
    echo -e "${blue} Installing tor with sudo${nc}"
    $sudo $pac install tor -y
  else
    echo -e "${blue} Installing tor without sudo ${nc}"
    $pac install tor -y
  fi
fi
#done


# setup tor hidden service [error]

echo -e "[-] ${yellow} starting tor hidden service on port $port ${red} change it if port is unavailable ${nc}"
echo -e "[-]${green} tor hidden service dir is here ${cyan} $tordir ${nc}"

echo -e "${blue} configuring torrc file"
# $sudo find $conf_dir/ -type f -name torrc -exec sudo sed -i "s/\#HiddenServiceDir \/var\/lib\/tor\/hidden_service\//HiddenServiceDir \/hidden_service\//g" {} +
# $sudo find $conf_dir/ -type f -name torrc -exec sudo sed -i "s/\#HiddenServicePort 80 127.0.0.1:80/HiddenServicePort 80 127.0.0.1:1337/g" {} +

cp $tor_conf_dir/torrc .
echo -e "HiddenServiceDir $PWD/hidden_service/" >> torrc
echo -e "HiddenServicePort 80 127.0.0.1:$port" >> torrc

# Start tor service
echo -e "[-] ${yellow} Starting tor hidden service ${nc}"
tor -f torrc --quiet &
echo -e "[-] ${red} tor started ${nc}"

# check onionX is installed or not
if [ -e "$bin/tor" ]; then
  echo "pass"
  if [ -d "$tordir" ]; then
    echo -e "$logo"
    echo -e "[i]${purple} onionX ${green}installed successfully !!${nc}"
    echo -e "[i]${green} Start your apache/nginx server on port $port ${nc}"
    echo -e "[i]${yellow} Check out your Website here - $(cat hidden_service/hostname) ${nc}"
    echo -e "[i]${purple} got errors, contact me here $contact ${nc}"
  else
    echo -e "$logo"
    echo -e "[i] ${red}Sorry ${cyan}: onionx ${red}is not installed !!${nc}"
    echo -e "[i] ${green}Please try again or contact me here $contact ${nc}"
  fi
fi