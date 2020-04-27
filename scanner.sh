#!/bin/bash

#SETTING UP VARIABLES
#keep trach of which scan the user ran and it came back alive.
KEEP="1"
V="-v"
H="-h"
VAR1=${1:-}
VAR2=${2:-foo}
r=0
DOUBLE="1"
GRCT="1"

#CHECK IF BASH IS INSTALLED ON THE MACHNINE
BASHINSTALLED=$(command -v bash)
if [[ "$BASHINSTALLED" = "" ]]; then
echo -e "\e[31mYou do not have bash installed?! How are you running this?!?!?\e[0m"
exit
fi

#CHECK IF THIS SUPPORTS ALL THINGS THAT BASH CAN DO
BASHV=$(echo $BASH_VERSION)
BASHVM=${BASHV:0:3}
BASHVM2=${BASHV:0:1}
a=1

until [ $a -gt 5 ]; do

if grep -w "$a" <<< "$BASHVM2" > /dev/null; then

if [[ "$a" -le "4" ]]; then

if [[ "$a" = "4" ]]; then

if grep -w "4.1" <<< "$BASHVM" > /dev/null; then
echo -e "\e[31mUnsupported version of bash!!(also super old) Make sure you have bash \e[1m4.2 or higher\e[0m\e[31m!\e[0m"
echo -e "\e[96mTo update your version of bash, you can use \"\e[0m\e[1msudo apt install --only-upgrade bash\e[0m\e[96m\"."
exit
fi
if grep -w "4.0" <<< "$BASHVM" > /dev/null; then
echo -e "\e[31mUnsupported version of bash!!(also super old) Make sure you have bash \e[1m4.2 or higher\e[0m\e[31m!\e[0m"
echo -e "\e[96mTo update your version of bash, you can use \"\e[0m\e[1msudo apt install --only-upgrade bash\e[0m\e[96m\"."
exit
fi
else
echo -e "\e[31mUnsupported version of bash!!(also super old) Make sure you have bash \e[1m4.2 or higher\e[0m\e[31m!\e[0m"
echo -e "\e[96mTo update your version of bash, you can use \"\e[0m\e[1msudo apt install --only-upgrade bash\e[0m\e[96m\"."
exit
fi
fi
fi

((a=a+1))
done

APTC=$(command -v apt)
if [[ "$APTC" = "" ]]; then
echo -e "\e[31mYou do not have the \e[1m\"apt\"\e[0m\e[31m command installed! \e[1mScanner\e[0m\e[31m depends on the \e[1m\"apt\"\e[0m\e[31m command to install all the missing dependencies.\e[0m"
exit
fi

#IF USER HAS --version
if [[ "$VAR1" = "--version" ]]; then
echo -e "This is \e[1mScanner \e[0mversion \e[1m8.1.4-beta\e[0m"
echo -e "\e[91mWARNING: This is only beta! Expect some bugs!"
exit
fi

#IF USER HAS -H
if [[ "$VAR1" == "$H" ]];
then
echo -e "\e[32mUsage:\e[0m
  scanner.sh \e[31m<IP ADDRESS>\e[0m \e[96m[flags]\e[0m

\e[32mFlags:\e[0m
  \e[35m\e[1m-h\e[0m                     This menu!
  \e[35m\e[1m-v\e[0m                     Enables nmap output when nmap is run. WARNING: very messy!
  \e[35m\e[1m--version\e[0m              Shows you the version of this program.
  \e[35m\e[1m--requirements\e[0m         Show you all the requirements."
exit
fi

if [[ "$VAR2" = "foo" ]]; then
echo "F">/dev/null

else

if [[ "$VAR2" != "-v" ]]; then


if [[ "$VAR2" = "--version" ]]; then

echo -e "\e[96mPlease use \e[1m--version\e[0m\e[96m without the IP address!\e[0m"
exit

fi

if [[ "$VAR2" = "-h" ]]; then

echo -e "\e[96mPlease use \e[1m-h\e[0m\e[96m without the IP address!\e[0m"
exit

else
echo -e "\e[31mInvalid flag: \e[1m$VAR2\e[0m"
exit
fi
fi
fi

#CHECK FOR VAR1
if [[ "$VAR1" = "" ]]; then
echo ""
echo -e "\e[31mPossible flags include:\e[0m"
echo -e "  \e[35m\e[1m-h\e[0m                     Help!\e[0m"
echo -e "  \e[35m\e[1m--version\e[0m              Shows you the version of this program.\e[0m"
echo -e "  \e[35m\e[1m--requirements\e[0m         Shows you all the requirements."
echo ""
echo -e "\e[31m\e[1mor an IP address\e[0m"
echo ""
exit
fi

if [[ "$VAR1" = "-v" ]]; then
echo -e "\e[32mUsage for -v:\e[0m"
echo -e "  scanner.sh \e[31m<IP ADDRESS>\e[0m \e[96m-v\e[0m"
echo ""
exit
fi

if [[ "$VAR1" = "--requirements" ]]; then
echo -e ""
echo -e "\e[92mRequirements:\e[0m"
echo -e ""
echo -e "- Bash (version 4.2 and higher)                             \e[91mMUST\e[0m"
echo -e "- The APT command                                           \e[91mMUST\e[0m"
echo -e "- Nmap (obviously)                                          \e[91mMUST\e[0m"
echo -e "- The GRC command (if you want to use -v flag)    \e[96mOPTIONAL, BUT GIVES ERROR\e[0m"
echo -e "- Searchsploit (for vulnerabilities)                        \e[91mMUST\e[0m"
echo -e "- Curl JQ command (for location of an IP)                   \e[91mMUST\e[0m"
echo -e ""
echo -e "\e[96mThe program automatically checks for all the requirements. You can choose to install them.\e[0m"
echo -e ""
echo -e "\e[91m\e[1mWARNING: This is only beta! Expect some bugs!\e[0m"
echo -e ""
exit
fi

if [[ "$VAR1" =~ ^[0-9.]+$ ]]; then
echo F>/dev/null
else
echo -e "\e[31mThe give flag isn't an \e[1mIP address\e[0m\e[31m!\e[0m"
exit
fi

PRIVS=1
#USER SELECT TO RUN WITH OR WITHOUT SUDO OR ROOT PRIVS
while true; do
read -p $'\e[96mAre you running this command with root or sudo privileges? [\e[32m\e[1mY\e[0m\e[96m,\e[31m\e[1mn\e[0m\e[96m] \e[0m' _Response
case $_Response in
[Yy])

#TO KEEP TRACK OF PRIVS
PRIVS=1
#CHECK FOR SUDO PRIVS
if (( $(id -u) != 0 ));
then
echo -e "\e[31m\e[1m[-] \e[31mThis command isn't running as root or sudo! \e[0m"
exit
fi
break
;;
[Nn])
PRIVS=2
echo -e "\e[96mSince you are not running this as sudo or root, you will have less features!"
echo ""
break
;;
*) echo -e "\e[1m\e[96m\e[107mPlease answer with \e[32m\e[1mY\e[0m\e[107m\e[96m, \e[31m\e[1mn\e[0m\e[107m\e[96m.\e[49m\e[0m ";;
esac
done

#CHECK FOR NMAP COMMAND
NMAPC=$(command -v nmap)
if [[ "$NMAPC" = "" ]]; then
echo -e "\e[96mIt appears that you do not have the \e[1m\"nmap\"\e[0m \e[96mcommand installed!"
echo ""

function InstallNMAP () {
while true; do
read -p $'\e[96mDo you wish to install \"nmap\"? \e[1m(requires sudo or root privileges)\e[96m [\e[32m\e[1mY\e[0m\e[96m,\e[31m\e[1mn\e[0m\e[96m] \e[0m' _Installation2
case $_Installation2 in
[Yy])

echo -e "\e[92m\e[1m[+] \e[0m\e[92mInstallation began.....\e[0m"
echo ""

sudo apt install nmap
echo -e "\e[92m\e[1m[+] \e[0m\e[92mInstallation completed.....\e[0m"
echo ""
echo -e "\e[32mChecking if command successfully installed.......\e[0m"
NMAPC=$(command -v nmap)
if [[ "$NMAPC" = "" ]]; then
echo -e "\e[96mIt appears that the command hasn't been successfully installed. Please install \e[1m\"nmap\" \e[96myourself.\e[0m"
exit
fi
echo -e "\e[92m\e[1m[+] \e[0m\e[92mInstallation successfull. Continuing......\e[0m"
break;;
[Nn])
echo -e "\e[35mMust have nmap installed so that Scanner can work properly, exiting......\e[0m"
exit
;;
*)
echo -e "\e[91mPlease answer with \e[1m[\e[32m\e[1mY\e[0m\e[91m,\e[31m\e[1mn\e[0m\e[91m\e[1m] \e[0m"
InstallNMAP
;;
esac
done
}
InstallNMAP
fi

#CHECK FOR GRC COMMAND
GRCI=$(command -v grc) 
if [[ "$GRCI" = "" ]]; then
echo ""
echo -e "\e[96mIt appears that you do not have the \e[1m\"grc\"\e[0m \e[96mcommand installed!"
echo ""
GRCT="2"

function InstallGRC () {
while true; do
read -p $'\e[96mDo you wish to install \"grc\"? \e[1m(requires sudo or root privileges, otherwise you wont be able to use the -v flag)\e[96m [\e[32m\e[1mY\e[0m\e[96m,\e[31m\e[1mn\e[0m\e[96m] \e[0m' _Installation26
case $_Installation26 in
[Yy])

echo -e "\e[92m\e[1m[+] \e[0m\e[92mInstallation began.....\e[0m"
echo ""

sudo apt install grc
echo -e "\e[92m\e[1m[+] \e[0m\e[92mInstallation completed.....\e[0m"
echo ""
echo -e "\e[32mChecking if command successfully installed.......\e[0m"
GRCI=$(command -v grc)
if [[ "$GRCI" = "" ]]; then
echo -e "\e[96mIt appears that the command hasn't been successfully installed. Please install \e[1m\"grc\" \e[96myourself.\e[0m"
GRCT="2"
exit
fi
GRCT="1"
echo -e "\e[92m\e[1m[+] \e[0m\e[92mInstallation successfull. Continuing......\e[0m"
echo ""
break
;;
[Nn])
echo ""
echo -e "\e[35mIf \"grc\" command isn't installed, it's not recommended to use the -v flag, unless you want an error.\e[0m"
echo ""
GRCT="2"
break
;;
*)
echo -e "\e[91mPlease answer with \e[1m[\e[32m\e[1mY\e[0m\e[91m,\e[31m\e[1mn\e[0m\e[91m\e[1m] \e[0m"
InstallGRC
;;
esac
done
}
InstallGRC
fi


#CHECK FOR SEARCHSPLOIT
SSI=$(command -v searchsploit)
if [[ "$SSI" = "" ]]; then

function InstallSS () {

while true; do
read -p $'\e[96mDo you wish to install \"searchsploit\"? \e[1m(requires sudo or root privileges)\e[96m [\e[32m\e[1mY\e[0m\e[96m,\e[31m\e[1mn\e[0m\e[96m] \e[0m' _Installation3
case $_Installation3 in
[Yy])

echo -e "\e[92m\e[1m[+] \e[0m\e[92mInstallation began.....\e[0m"

sudo apt install exploitdb

echo -e "\e[92m\e[1m[+] \e[0m\e[92mInstallation completed.....\e[0m"
echo ""
echo -e "\e[32mChecking if command successfully installed.......\e[0m"

SSI=$(command -v searchsploit)
if [[ "$SSI" = "" ]]; then
echo -e "\e[96mIt appears that the command hasn't been successfully installed. Please install \e[1m\"searchsploit\" \e[96myourself.\e[0m"
exit
fi
echo -e "\e[92m\e[1m[+] \e[0m\e[92mInstallation successfull. Continuing......\e[0m"
break
;;
[Nn])
echo -e "\e[35mMust have searchploit installed so that Scanner can work properly, exiting......\e[0m"
exit
;;
*)
echo -e "\e[91mPlease answer with \e[1m[\e[32m\e[1mY\e[0m\e[91m,\e[31m\e[1mn\e[0m\e[91m\e[1m] \e[0m"
InstallJQ
;;
esac
done

}
InstallSS

fi

#CHECK FOR JQ COMMAND
JQC=$(command -v jq) 
if [[ "$JQC" = "" ]]; then
echo -e "\e[96mIt appears that you do not have the \e[1m\"jq\"\e[0m \e[96mcommand installed!"

function InstallJQ () {
while true; do
read -p $'\e[96mDo you wish to install \"curl jq\"? \e[1m(requires sudo or root privileges)\e[96m [\e[32m\e[1mY\e[0m\e[96m,\e[31m\e[1mn\e[0m\e[96m] \e[0m' _Installation
case $_Installation in
[Yy])

echo -e "\e[92m\e[1m[+] \e[0m\e[92mInstallation began.....\e[0m"

sudo apt install curl jq

echo -e "\e[92m\e[1m[+] \e[0m\e[92mInstallation completed.....\e[0m"
echo ""
echo -e "\e[32mChecking if command successfully installed.......\e[0m"

JQC=$(command -v jq)
if [[ "$JQC" = "" ]]; then
echo -e "\e[96mIt appears that the command hasn't been successfully installed. Please install \e[1m\"curl jq\" \e[96myourself.\e[0m"
exit
fi
echo -e "\e[92m\e[1m[+] \e[0m\e[92mInstallation successfull. Continuing......\e[0m"
break
;;
[Nn])
echo -e "\e[35mMust have jq installed so that Scanner can work properly, exiting......\e[0m"
exit
;;
*)
echo -e "\e[91mPlease answer with \e[1m[\e[32m\e[1mY\e[0m\e[91m,\e[31m\e[1mn\e[0m\e[91m\e[1m] \e[0m"
InstallJQ
;;
esac
done
}
InstallJQ

fi

#USER INPUT FOR HOW MANY PORTS TO SCAN
function PortInput () {
while true; do
read -p $'\e[96mHow many ports do you want to scan? \e[1m\e[4m(leave blank for default)\e[0m \e[96mDEFAULT: 4000 (from 0 to 4000): \e[0m' _PNU
case $_PNU in
[0])
_PNU=4000
break
;;
*)
if [ $_PNU -eq $_PNU 2>/dev/null ]; then
echo "test">/dev/null
else
echo -e "\e[31m\e[1m[-] \e[0m\e[31mThe given port isn't a number \e[0m"
echo ""
PortInput
fi

if [[ "$_PNU" = "" ]]; then
_PNU=4000
echo ""
echo -e "\e[92m\e[1m[+] \e[0m\e[92mPorts set from 0 to $_PNU \e[0m"
DOUBLE="2"
break
fi

if [[ "$DOUBLE" = "1" ]]; then
echo ""
echo -e "\e[92m\e[1m[+] \e[0m\e[92mPorts set from 0 to $_PNU \e[0m"
fi
break
;;
esac
done
}
PortInput

if [[ "$PRIVS" = "1" ]]; then
#SCANNING WITH NMAP
echo ""
echo -e "\e[92m\e[1m[+] \e[0m\e[92mScanning $VAR1 with nmap........ \e[0m"
SCANRESULTS=$(nmap -p 1-$_PNU -sV "$VAR1")
fi
if [[ "$PRIVS" = "2" ]]; then
#SCANNING WITH NMAP
echo ""
echo -e "\e[92m\e[1m[+] \e[0m\e[92mScanning $VAR1 with nmap........ \e[0m"
SCANRESULTS=$(nmap -p 1-$_PNU "$VAR1")
fi

if [[ "$GRCT" = "1" ]]; then
#IF USER HAS -V
if [[ "$VAR2" == "$V" ]]; then
echo ""
grc nmap -p 1-$_PNU -sV "$VAR1"
echo ""
fi
fi

#CHECKING IF HOST IS ALIVE
FAILED="0 hosts up"
if grep -q "$FAILED" <<< "$SCANRESULTS" ; then
echo ""
echo -e "\e[31m\e[1m[-] \e[0m\e[31mThe host is down or not responding to our ping requests. \e[0m"


#TRY NMAP AGAIN WITH -Pn
while true; do
read -p $'\e[96m\e[1m[-] \e[0m\e[96mDo you wish to try the scan again with -Pn? [\e[32m\e[1mY\e[0m\e[96m,\e[31m\e[1mn\e[0m\e[96m] \e[0m' _response
case $_response in
[Yy])
if [[ "$PRIVS" = "1" ]]; then
#SCANNING WITH NMAP
echo ""
echo -e "\e[92m\e[1m[+] \e[0m\e[92mScanning $VAR1 with nmap again...\e[0m"
SECONDRESULTS=$(nmap -p 1-$_PNU -sV -Pn "$VAR1")
fi
if [[ "$PRIVS" = "2" ]]; then

#SCANNING WITH NMAP
echo ""
echo -e "\e[92m\e[1m[+] \e[0m\e[92mScanning $VAR1 with nmap again... \e[31m(this may take a lot longer)\e[0m"
SECONDRESULTS=$(nmap -p 1-$_PNU -Pn "$VAR1")
fi

KEEP="2"
if [[ "$GRCT" = "1" ]]; then
#USERS WITH -v
if [[ "$VAR2" == "$V" ]]; then
echo ""
grc nmap -p 1-$_PNU -sV "$VAR1"
echo ""
fi
fi

if grep -q "$FAILED" <<< "$SECONDRESULTS" ; then
echo ""
echo -e "\e[31m\e[1m[-] \e[0m\e[31mThe host is down. Exiting.....\e[0m"
exit
fi
break
;;
[Nn]) echo -e "\e[95m\e[1mGo0dby3\e[0m"
exit
;;
*)
echo ""
echo -e "\e[1m\e[96m\e[107mPlease answer with \e[32m\e[1mY\e[0m\e[107m\e[96m, \e[31m\e[1mn\e[0m\e[107m\e[96m.\e[49m\e[0m ";;
esac
done
fi

#IP LOCATION SCANNER
VAR1M=${VAR1:0:3}
VAR1M2=${VAR1:0:7}
REMOTE="true"

#127.0.0.1
if grep -w "127.0.0.1" <<< "$VAR1" > /dev/null; then
echo ""
echo -e "\e[31m\e[1m[-] \e[31mCannot perform location scan, because you are scanning yourself! \e[0m"
echo ""
REMOTE="false"
fi

#10.0.0.0
if grep -w "10" <<< "$VAR1M" > /dev/null; then
echo ""
echo -e "\e[31m\e[1m[-] \e[31mThis IP address is local, cannot perform location scan! \e[0m"
echo ""
REMOTE="false"
fi

#172.16.0.0 - 172.31.255.255
if grep -w "172" <<< "$VAR1M" > /dev/null; then

n=16
until [ $n -gt 31 ]; do
if grep -w "$n" <<< "$VAR1M2" > /dev/null; then
echo ""
echo -e "\e[31m\e[1m[-] \e[31mThis IP address is local, cannot perform location scan! \e[0m"
echo ""
REMOTE="false"
fi
((n=n+1))
done
fi

#192.168.0.0 - 192.168.0.0
if grep -w "192" <<< "$VAR1M" > /dev/null; then

if grep -w "168" <<< "$VAR1M2" > /dev/null; then
echo ""
echo -e "\e[31m\e[1m[-] \e[31mThis IP address is local, cannot perform location scan! \e[0m"
echo ""
REMOTE="false"
fi

fi

#LOCATION SCAN
if [[ "$REMOTE" = "true" ]]; then
echo ""
echo -e "\e[92m\e[1m[+] \e[0m\e[92mPerforming IP location scan ......\e[0m"
IPRESULTS=$(sudo curl -s https://ipvigilante.com/$VAR1 | jq '.data.city_name, .data.country_name')
IPRESULTSM=${IPRESULTS//\"}
IPRESULTSM2=$(echo $IPRESULTSM)
echo ""
echo -e "\e[92mIP is located in \e[1m$IPRESULTSM2\e[0m"
echo ""
fi


#VARS FOR TESTING 1 AND 2, I FORGOT I DONT REALLY NEED THIS, BUT SINCE IT WORKS IM NOT GONNA CHANGE IT
KE1="1"
KE2="2"

#WITCH NMAP SCAN WORKED?
#FIRST SCAN
if [[ "$KEEP" = "$KE1" ]]; then

#IF 1000 PORTS ARE CLOSED, FILTERED OR OPEN, IF OPEN WE CONTINUE
if grep -q "$_PNU" <<< "$SCANRESULTS" ; then
if grep -q "$_PNU/tcp open" <<< "$SCANRESULTS" ; then
echo wow >/dev/null
else
#TEST FOR DEFAULT PORTS CLOSED
if grep -q "closed" <<< "$SCANRESULTS" ; then
echo -e "\e[31m\e[1m[-] \e[0m\e[31mThe host has all \e[1m$_PNU\e[0m \e[31mports closed. Exiting..........\e[0m"
exit
fi

#TEST FOR DEFAULT PORTS FILTERED
if grep -q "filtered" <<< "$SCANRESULTS" ; then
echo -e "\e[31m\e[1m[-] \e[0m\e[31mThe host has all \e[1m$_PNU\e[0m \e[31mports filtered. Exiting.........\e[0m"
exit
fi

#TEST FOR DEFAULT PORTS OPEN
if grep -q "open" <<< "$SCANRESULTS" ; then
echo -e "\e[31m\e[1m[-] \e[0m\e[31mThe host has all \e[1m$_PNU\e[0m \e[31mports open. That's not good because you can like DDOS it with masscan.\e[0m"
fi

fi

#GREP FOR OPEN PORTS
if grep -q "open" <<< "$SCANRESULTS" ; then
echo ""
echo -e "\e[92m\e[1m[+] \e[0m\e[92mFound open ports! \e[0m"
fi
fi
#CUTTING FIRST 100 CHARECTERS AND LAST 20 FROM NMAP
SCANRESULTS1=${SCANRESULTS:130}
SCANRESULTS2=${SCANRESULTS1::-20}

if [[ "$PRIVS" = "1" ]]; then
#SCANNING OPEN PORTS
r=0
op=0
i=0
until [[ $i -gt $_PNU ]];
do
if [[ $i -gt 20 ]]; then
if grep -w "$i/tcp" <<< "$SCANRESULTS2" > /dev/null; then
echo -e "\e[92m\e[1m[+] \e[0m\e[92mPort \e[1m$i \e[0m\e[92mopen on the target machine!"
my_array[r]=$i
((r=r+1))
((op=op+1))
fi
fi
((i=i+1))
done
echo -e "\e[92m\e[1m[+] \e[0m\e[92mTotal of \e[1m$op \e[0m\e[92mopen ports on the target machine!\e[0m "
echo ""
fi
echo ""
echo -e "\e[92m\e[1m[+] \e[0m\e[92mStarting service scan\e[0m"
t=0
u=1
until [[ $u -gt $r ]]; do
WOW=$(echo $SCANRESULTS2)
if [[ "$u" = $r ]]; then
JUNK=$(grep -oP "${my_array[$t]}/tcp open \K.*?(?=Service Info)" <<< $WOW)
if [[ "$JUNK" = "" ]]; then
echo "F" >/dev/null
else
echo -e "\e[92m\e[1m[+] \e[0m\e[92mService on port \e[1m${my_array[$t]}\e[0m \e[92mis \e[1m$JUNK\e[0m"
fi
else
JUNK=$(grep -oP "${my_array[$t]}/tcp open \K.*?(?= ${my_array[$u]}/tcp)" <<< $WOW)
if [[ "$JUNK" = "" ]]; then
echo "F" >/dev/null
else
echo -e "\e[92m\e[1m[+] \e[0m\e[92mService on port \e[1m${my_array[$t]}\e[0m \e[92mis \e[1m$JUNK\e[0m"
fi
fi
((u=u+1))
((t=t+1))

done
echo ""
echo -e "\e[92m\e[1m[+] \e[0m\e[92mDone service scan\e[0m"

NMAPOS=$(nmap -O $VAR1)
if grep -w "Running:" <<< "$NMAPOS" >/dev/null; then
IPHOSTOS=$(grep -w "Running:" <<< "$NMAPOS")
IPHOSTOSM=${IPHOSTOS:9}
WOWZERS="1"
if [[ "$GRCT" = "1" ]]; then
if [[ "$VAR2" = "-v" ]]; then
echo ""
grc nmap -O $VAR1
echo ""
fi
fi
echo ""
echo -e "\e[92m\e[1m[+]\e[0m\e[92m The host machine is most likely running: \e[1m$IPHOSTOSM\e[0m"
echo ""

function OSVULNS2 () {
while true; do
read -p $'\e[96mDo you want to try and scan for a better OS result? \e[1m(only if smb is open)\e[0m\e[96m [\e[32m\e[1mY\e[0m\e[96m,\e[31m\e[1mn\e[0m\e[96m] \e[0m' _Response234
case $_Response234 in
[Yy])
NMAP445=$(nmap $VAR1 -p445)
if grep -w "open" <<< "$NMAP445" >/dev/null; then


echo ""
echo -e "\e[92mScanning now.....\e[0m"
echo ""

NMAPOS2=$(nmap -p445 -sC $VAR1)

if [[ "$GRCT" = "1" ]]; then
if [[ "$VAR2" = "-v" ]]; then
echo ""
grc nmap -p445 -sC $VAR1
echo ""
fi
fi

if grep -w "smb-os-discovery:" <<< "$NMAPOS2" >/dev/null; then

TEST1=$(echo "$NMAPOS2" | grep "OS:")
OSA=${TEST1:8}
if [[ "$OSA" != "" ]]; then
TEST2=$(echo "$NMAPOS2" | grep "Computer name:")
CN=${TEST2:19}
echo -e "\e[92m\e[1m[+] \e[0m\e[92mThe host is now most likely running: \e[1m$OSA\e[0m"
if [[ "$CN" != "" ]]; then
echo -e "\e[92m\e[1m[+] \e[0m\e[92mComputer name is: \e[1m$CN\e[0m"
fi
echo ""
WOWZERS="2"
fi
else
echo ""
echo -e "\e[31mCould not find SMB OS DISCOVERY.\e[0m"
echo ""
fi

echo -e "\e[96mContinuing.....\e[0m"
echo ""
break
else

echo -e "\e[31mPort 445 is closed or filtered! Continuing.....\e[0m"
break

fi

break
;;
[Nn])
echo ""
echo -e "\e[96mContinuing with that result.....\e[0m"
echo ""
break
;;
*) echo -e "\e[1m\e[96m\e[107mPlease answer with \e[32m\e[1mY\e[0m\e[107m\e[96m, \e[31m\e[1mn\e[0m\e[107m\e[96m.\e[49m\e[0m "
OSVULNS2
;;
esac
done
}
OSVULNS2

if [[ "$WOWZERS" = "1" ]]; then

function OSVULNS () {
while true; do
read -p $'\e[96mDo you want to display all the vulnerabilities for \e[34m\e[1m'"$IPHOSTOSM"$'\e[0m\e[96m? (can be buggy) [\e[32m\e[1mY\e[0m\e[96m,\e[31m\e[1mn\e[0m\e[96m] \e[0m' _Response23
case $_Response23 in
[Yy])

echo ""
echo -e "\e[92mDisplaying all the vulns:\e[0m"
VULNSCAN=$(searchsploit $IPHOSTOSM)
echo "$VULNSCAN"
echo ""
echo -e "\e[96mContinuing.....\e[0m"
break
;;
[Nn])
echo -e "\e[96mContinuing.....\e[0m"
break
;;
*) echo -e "\e[1m\e[96m\e[107mPlease answer with \e[32m\e[1mY\e[0m\e[107m\e[96m, \e[31m\e[1mn\e[0m\e[107m\e[96m.\e[49m\e[0m "
OSVULNS
;;
esac
done
}
OSVULNS

else

#THIS BOOBOO
function OSVULNSA () {
while true; do
read -p $'\e[96mDo you want to display all the vulnerabilities for \e[34m\e[1m'"$OSA"$'\e[0m\e[96m? (can be buggy) [\e[32m\e[1mY\e[0m\e[96m,\e[31m\e[1mn\e[0m\e[96m] \e[0m' _Response235
case $_Response235 in
[Yy])

echo ""
echo -e "\e[92mDisplaying all the vulns:\e[0m"
VULNSCAN=$(searchsploit $OSA)
echo "$VULNSCAN"
echo ""
echo -e "\e[96mContinuing.....\e[0m"
break
;;
[Nn])
echo -e "\e[96mContinuing.....\e[0m"
break
;;
*) echo -e "\e[1m\e[96m\e[107mPlease answer with \e[32m\e[1mY\e[0m\e[107m\e[96m, \e[31m\e[1mn\e[0m\e[107m\e[96m.\e[49m\e[0m "
OSVULNSA
;;
esac
done
}
OSVULNSA

fi
else
echo ""
echo -e "\e[31m\e[1m[-] \e[0m\e[31mCould not find exact match for host OS!\e[0m"
echo ""
fi

else

#SCANNING OPEN PORTS
op=0
i=0
until [[ $i -gt $_PNU ]];
do
if [[ $i -gt 20 ]]; then
if grep -w "$i/tcp" <<< "$SCANRESULTS2" > /dev/null; then
echo -e "\e[92m\e[1m[+] \e[0m\e[92mPort \e[1m$i \e[0m\e[92mopen on the target machine!"
((op=op+1))
fi
fi
((i=i+1))
done
echo -e "\e[92m\e[1m[+] \e[0m\e[92mTotal of \e[1m$op \e[0m\e[92mopen ports on the target machine!\e[0m "
echo ""
fi



#SECOND SCAN
#SECOND SCAN
if [[ "$KEEP" = "$KE2" ]]; then

#IF 1000 PORTS ARE SOMETHING
if grep -q "$_PNU" <<< "$SECONDRESULTS" ; then
if grep -q "$_PNU/tcp open" <<< "$SCANRESULTS" ; then
echo wow >/dev/null
else
#TEST FOR DEFAULT PORTS CLOSED
if grep -q "closed" <<< "$SECONDRESULTS" ; then
echo -e "\e[31m\e[1m[-] \e[0m\e[31mThe host has all \e[1m$_PNU\e[0m \e[31mports closed. Exiting..........\e[0m"
exit
fi

#TEST FOR DEFAULT PORTS FILTERED
if grep -q "filtered" <<< "$SECONDRESULTS" ; then
echo -e "\e[31m\e[1m[-] \e[0m\e[31mThe host has all \e[1m$_PNU\e[0m \e[31mports filtered. Exiting.........\e[0m"
exit
fi

#TEST FOR DEFAULT PORTS OPEN
if grep -q "open" <<< "$SECONDRESULTS" ; then
echo -e "\e[92m\e[1m[+] \e[0m\e[92mThe host has all \e[1m$_PNU\e[0m \e[31mports open. Thats not good because you can like DDOS it with masscan.\e[0m"
fi
fi
fi

#GREP FOR OPEN PORTS
if grep -q "open" <<< "$SECONDRESULTS" ; then
echo ""
echo -e "\e[92m\e[1m[+] \e[0m\e[92mFound open ports! \e[0m"
fi

#CUTTING FIRST 100 CHARECTERS AND LAST 20 FROM NMAP
SECONDRESULTS1=${SECONDRESULTS:130}
SECONDRESULTS2=${SECONDRESULTS1::-20}

if [[ "$PRIVS" = "1" ]]; then

#SCANNING OPEN PORTS
op=0
i=0
until [[ $i -gt $_PNU ]];
do
if [[ $i -gt 20 ]]; then
if grep -w "$i/tcp" <<< "$SECONDRESULTS2" > /dev/null; then
echo -e "\e[92m\e[1m[+] \e[0m\e[92mPort \e[1m$i \e[0m\e[92mopen on the target machine!"
((op=op+1))
fi
fi
((i=i+1))
done
echo -e "\e[92m\e[1m[+] \e[0m\e[92mTotal of \e[1m$op \e[0m\e[92mopen ports on the target machine!"

t=0
u=1
until [[ $u -gt $r ]]; do
WOW=$(echo $SCANRESULTS2)
if [[ "$u" = $r ]]; then
JUNK=$(grep -oP "${my_array[$t]}/tcp open \K.*?(?=Service Info)" <<< $WOW)
if [[ "$JUNK" = "" ]]; then
echo "F" >/dev/null
else
echo -e "\e[92m\e[1m[+] \e[0m\e[92mService on port \e[1m${my_array[$t]}\e[0m \e[92mis \e[1m$JUNK\e[0m"
fi
else
JUNK=$(grep -oP "${my_array[$t]}/tcp open \K.*?(?= ${my_array[$u]}/tcp)" <<< $WOW)
if [[ "$JUNK" = "" ]]; then
echo "F" >/dev/null
else
echo -e "\e[92m\e[1m[+] \e[0m\e[92mService on port \e[1m${my_array[$t]}\e[0m \e[92mis \e[1m$JUNK\e[0m"
fi
fi
((u=u+1))
((t=t+1))

done
echo ""
echo -e "\e[92m\e[1m[+] \e[0m\e[92mDone service scan\e[0m"

NMAPOS=$(nmap -O $VAR1)
if grep -w "Running:" <<< "$NMAPOS" >/dev/null; then
IPHOSTOS=$(grep -w "Running:" <<< "$NMAPOS")
IPHOSTOSM=${IPHOSTOS:9}
echo ""
echo -e "\e[92m\e[1m[+]\e[0m\e[92m The host machine is most likely running: $IPHOSTOSM\e[0m"
echo ""
WOWZERS="1"


function OSVULNS2 () {
while true; do
read -p $'\e[96mDo you want to try and scan for a better OS result? \e[1m(only if smb is open)\e[0m\e[96m [\e[32m\e[1mY\e[0m\e[96m,\e[31m\e[1mn\e[0m\e[96m] \e[0m' _Response234
case $_Response234 in
[Yy])
NMAP445=$(nmap $VAR1 -p445)
if grep -w "open" <<< "$NMAP445" >/dev/null; then


echo ""
echo -e "\e[92mScanning now.....\e[0m"
echo ""

NMAPOS2=$(nmap -p445 -sC $VAR1)

if grep -w "smb-os-discovery:" <<< "$NMAPOS2" >/dev/null; then

TEST1=$(echo "$NMAPOS2" | grep "OS:")
OSA=${TEST1:8}
if [[ "$OSA" != "" ]]; then
TEST2=$(echo "$NMAPOS2" | grep "Computer name:")
CN=${TEST2:19}
echo -e "\e[92m\e[1m[+] \e[0m\e[92mThe host is now most likely running: \e[1m$OSA\e[0m"
if [[ "$CN" != "" ]]; then
echo -e "\e[92m\e[1m[+] \e[0m\e[92mComputer name is: \e[1m$CN\e[0m"
fi
echo ""
WOWZERS="2"
fi
else

echo -e "\e[31mCould not find SMB OS DISCOVERY.\e[0m"
fi  

echo -e "\e[96mContinuing.....\e[0m"
echo ""
break
else

echo -e "\e[31mPort 445 is closed or filtered! Continuing.....\e[0m"
break

fi

break
;;
[Nn])
echo ""
echo -e "\e[96mContinuing with that result.....\e[0m"
echo ""
break  
;;
*) echo -e "\e[1m\e[96m\e[107mPlease answer with \e[32m\e[1mY\e[0m\e[107m\e[96m, \e[31m\e[1mn\e[0m\e[107m\e[96m.\e[49m\e[0m "
OSVULNS2
;;
esac
done
}
OSVULNS2


if [[ "$WOWZERS" = "1" ]]; then

function OSVULNS () {
while true; do
read -p $'\e[96mDo you want to display all the vulnerabilities for \e[34m\e[1m'"$IPHOSTOSM"$'\e[0m\e[96m? [\e[32m\e[1mY\e[0m\e[96m,\e[31m\e[1mn\e[0m\e[96m] \e[0m' _Response23
case $_Response23 in
[Yy])

echo ""
echo -e "\e[92mDisplaying all the vulns:\e[0m"
VULNSCAN=$(searchsploit $IPHOSTOSM)
echo "$VULNSCAN"
echo ""
echo -e "\e[96mContinuing.....\e[0m"
break
;;
[Nn])
echo -e "\e[96mContinuing.....\e[0m"
break
;;
*) echo -e "\e[1m\e[96m\e[107mPlease answer with \e[32m\e[1mY\e[0m\e[107m\e[96m, \e[31m\e[1mn\e[0m\e[107m\e[96m.\e[49m\e[0m "
OSVULNS
;;
esac
done
}
OSVULNS
fi


else

#THIS BOOBOO
function OSVULNSA () {
while true; do
read -p $'\e[96mDo you want to display all the vulnerabilities for \e[34m\e[1m'"$OSA"$'\e[0m\e[96m? (can be buggy) [\e[32m\e[1mY\e[0m\e[96m,\e[31m\e[1mn\e[0m\e[96m] \e[0m' _Response235
case $_Response235 in
[Yy])

echo ""
echo -e "\e[92mDisplaying all the vulns:\e[0m"
VULNSCAN=$(searchsploit $OSA)
echo "$VULNSCAN"
echo ""
echo -e "\e[96mContinuing.....\e[0m"
break
;;
[Nn])
echo -e "\e[96mContinuing.....\e[0m"
break
;;
*) echo -e "\e[1m\e[96m\e[107mPlease answer with \e[32m\e[1mY\e[0m\e[107m\e[96m, \e[31m\e[1mn\e[0m\e[107m\e[96m.\e[49m\e[0m "
OSVULNSA
;;
esac
done
}
OSVULNSA

fi



else
#SCANNING OPEN PORTS
op=0
i=0
until [[ $i -gt $_PNU ]];
do
if [[ $i -gt 20 ]]; then
if grep -w "$i/tcp" <<< "$SECONDRESULTS2" > /dev/null; then
echo -e "\e[92m\e[1m[+] \e[0m\e[92mPort \e[1m$i \e[0m\e[92mopen on the target machine!"
((op=op+1))
fi
fi
((i=i+1))
done
echo -e "\e[92m\e[1m[+] \e[0m\e[92mTotal of \e[1m$op \e[0m\e[92mopen ports on the target machine!"
fi
fi


#END OF FILE, EXIT JUST IN CASE
exit
