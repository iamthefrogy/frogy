#!/bin/bash

echo -e "
           .,;::::,..      ......      .,:llllc;'.
        .cxdolcccloddl;:looooddooool::xxdlc:::clddl.
       cxo;'',;;;,,,:ododkOOOOOOOOkdxxl:,';;;;,,,:odl
      od:,;,...x0c:c;;ldox00000000dxdc,,:;00...,:;;cdl
     'dc,;.    ..  .o;:odoOOOOOOOOodl,;;         ::;od.
     'ol';          :o;odlkkkkkkkxodl,d          .o;ld.
     .do,o..........docddoxxxxxxxxodo;x,.........:d;od'
     ;odlcl,......,odcdddodddddddddddl:d:.......:dcodl:.
    ;clodocllcccloolldddddddddddddddddoclllccclollddolc:
   ,:looddddollllodddddddddddddddddddddddollllodddddooc:,
   ':lloddddddddddddddddxxdddddddodxddddddddddddddddoll:'
    :cllclodddddddddddddxloddddddllddddddddddddddolcllc:
     :cloolclodxxxdddddddddddddddddddddddxxxxollclool:,
       ::cloolllllodxxxxxxxxxxxxxxkkkxxdolllllooolc:;
         .::clooddoollllllllllllllllllloodddolcc:,
              ,:cclloodddxxxxxxxxxdddoollcc::.
                     .,:ccccccccccc:::.
"

############################################################### Housekeeping tasks ######################################################################

echo -e "\e[94mEnter the organisation name (Only lowercase letters, you can include space): \e[0m"
read org

cdir=`echo $org | tr '[:upper:]' '[:lower:]'| tr " " "_"`

cwhois=`echo $org | tr " " "+"`


echo -e "\e[94mEnter the root domain name (eg: frogy.com): \e[0m"
read domain_name
echo -e "\e[92mHold on! some house keeping tasks being done... \e[0m"
if [[ -d output ]]
then
        :
else
        mkdir output
fi
if [[ -d output/$cdir ]]
then
        echo -e "\e[94mCreating $org directory in the 'output' folder...\e[0m"
        rm -r -f output/$cdir
        mkdir output/$cdir
	mkdir output/$cdir/raw_http_responses
else
        echo -e "\e[94mCreating $org directory in the 'output' folder... \e[0m"
        mkdir output/$cdir
	mkdir output/$cdir/raw_http_responses
fi

############################################################### Subdomain enumeration ######################################################################


#################### CHAOS ENUMERATION ######################

echo -e "\e[92mIdentifying Subdomains \e[0m"

echo -n "Is this program is in CHAOS dataset? (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
        curl -s https://chaos-data.projectdiscovery.io/index.json -o index.json
	chaosvar=`cat index.json | grep $cdir | grep "URL" | sed 's/"URL": "//;s/",//' | xargs`
	if [ -z "$chaosvar" ]
	then
		echo -e "\e[36mSorry! could not find data in CHAOS DB...\e[0m"
		subfinder -d $domain_name --silent >> output/$cdir/subfinder.txtls
	        cat output/$cdir/subfinder.txtls >> all.txtls
	else
		curl -s "$chaosvar" -O
		unzip -qq *.zip
		cat *.txt >> output/$cdir/chaos.txtls
		cat output/$cdir/chaos.txtls >> all.txtls
		echo -e "\e[36mChaos count: \e[32m$(cat output/$cdir/chaos.txtls | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"
		find . | grep .txt | sed 's/.txt//g' | cut -d "/" -f2 | grep  '\.' >> subfinder.domains
	        subfinder -dL subfinder.domains --silent -recursive >> output/$cdir/subfinder.txtls
		rm subfinder.domains
		cat output/$cdir/subfinder.txtls >> all.txtls
		rm *.zip
		rm *.txt
	fi
        rm index.json*
else
	:
fi

#################### CERTIFICATE ENUMERATION ######################

registrant=$(whois $domain_name | grep "Registrant Organization" | cut -d ":" -f2 | xargs| sed 's/,/%2C/g' | sed 's/ /+/g'| egrep -v '(*Whois*|*whois*|*WHOIS*|*domains*|*DOMAINS*|*Domains*|*domain*|*DOMAIN*|*Domain*|*proxy*|*Proxy*|*PROXY*|*PRIVACY*|*privacy*|*Privacy*|*REDACTED*|*redacted*|*Redacted*|*DNStination*|*WhoisGuard*|*Protected*|*protected*|*PROTECTED*)')
if [ -z "$registrant" ]
then
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls
else
        curl -s "https://crt.sh/?q="$registrant"" | grep -P -i '<TD>([a-zA-Z]+(\.[a-zA-Z]+)+)</TD>' | sed -e 's/^[ \t]*//' | cut -d ">" -f2 | cut -d "<" -f1 | anew >> output/$cdir/whois.txtls
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls
fi

registrant2=$(whois $domain_name | grep "Registrant Organisation" | cut -d ":" -f2 | xargs| sed 's/,/%2C/g' | sed 's/ /+/g'| egrep -v '(*Whois*|*whois*|*WHOIS*|*domains*|*DOMAINS*|*Domains*|*domain*|*DOMAIN*|*Domain*|*proxy*|*Proxy*|*PROXY*|*PRIVACY*|*privacy*|*Privacy*|*REDACTED*|*redacted*|*Redacted*|*DNStination*|*WhoisGuard*|*Protected*|*protected*|*PROTECTED*)')
if [ -z "$registrant2" ]
then
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois2.txtls
else
        curl -s "https://crt.sh/?q="$registrant2"" | grep -a -P -i '<TD>([a-zA-Z]+(\.[a-zA-Z]+)+)</TD>' | sed -e 's/^[ \t]*//' | cut -d ">" -f2 | cut -d "<" -f1 | anew >> output/$cdir/whois2.txtls
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois2.txtls
fi
cat output/$cdir/whois*.txtls >> all.txtls
echo -e "\e[36mCertificate search count: \e[32m$(cat output/$cdir/whois.txtls | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"


#################### SUBLIST3R ENUMERATION ######################

python3 Sublist3r/sublist3r.py -d $domain_name -o sublister_output.txt &> /dev/null
if [[ -e sublister_output.txt ]]
then
        cat sublister_output.txt >> output/$cdir/sublister.txtls
        rm sublister_output.txt
else
        :
fi
cat output/$cdir/sublister.txtls >> all.txtls
echo -e "\e[36mSublister count: \e[32m$(cat output/$cdir/sublister.txtls | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"

#################### FINDOMAIN ENUMERATION ######################

findomain-linux -t $domain_name -q >> output/$cdir/findomain.txtls
cat output/$cdir/findomain.txtls >> all.txtls
echo -e "\e[36mFindomain count: \e[32m$(cat output/$cdir/findomain.txtls | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"

#################### GATHERING ROOT DOMAINS ######################

python rootdomain.py | grep -v "Match" | grep "\S" | anew >> rootdomain.txtls
#cat  all.txtls | awk -F\. '{print $(NF-1) FS $NF}' | anew >> rootdomain.txtls

#################### DNSCAN ENUMERATION ######################

python3 dnscan/dnscan.py -d %%.$domain_name -w wordlist/subdomains-top1million-5000.txt -D -o output/$cdir/dnscan.txtls &> /dev/null
cat output/$cdir/dnscan.txtls | grep $domain_name | egrep -iv ".(DMARC|spf|=|[*])" | cut -d " " -f1 | anew | sort -u >> all.txtls
echo -e "\e[36mDnscan: \e[32m$(cat output/$cdir/dnscan.txtls | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"

#################### SUBFINDER2 ENUMERATION ######################

subfinder -dL rootdomain.txtls --silent >> output/$cdir/subfinder2.txtls
echo -e "\e[36mSubfinder count: \e[32m$(cat output/$cdir/subfinder2.txtls | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"
cat output/$cdir/subfinder2.txtls | grep "/" | cut -d "/" -f3 >> all.txtls
cat output/$cdir/subfinder2.txtls | grep -v "/" >> all.txtls

mv rootdomain.txtls output/$cdir/
echo "www.$domain_name" >> all.txtls
echo "$domain_name" >> all.txtls
cat all.txtls | tr '[:upper:]' '[:lower:]'| anew | grep -v "*." >> $cdir.master
mv $cdir.master output/$cdir/$cdir.master
sed -i 's/<br>/\n/g' output/$cdir/$cdir.master
rm all.txtls


############################################################################# FINDING LOGIN PORTALS  ##################################################################

portlst=`naabu -l output/$cdir/$cdir.master -pf ports -silent | cut -d ":" -f2 | anew | tr "\n" "," | sed 's/.$//'` &> /dev/null

httpx -silent -l output/$cdir/$cdir.master -p $portlst  -fr -include-chain -store-chain -sc -tech -server -title -cdn -cname -probe -srd output/$cdir/raw_http_responses -o output/$cdir/temp_live.txtls &> /dev/null

cat output/$cdir/temp_live.txtls | grep SUCCESS | cut -d "[" -f1 >> output/$cdir/livesites.txtls

cat output/$cdir/temp_live.txtls | grep SUCCESS >> output/$cdir/technology.txtls

rm -f output/$cdir/temp_live.txtls

while read lf; do
        loginfound=`curl -s -L $lf | grep 'type="password"'`
        if [ -z "$loginfound" ]
                then
                :
        else
                echo "$lf" >> output/$cdir/loginfound.txtls
        fi

done <output/$cdir/livesites.txtls


echo -e "\e[93mTotal live websites (on all available ports) found: \e[32m$(cat output/$cdir/livesites.txtls | tr '[:upper:]' '[:lower:]' | anew | wc -l)\e[0m"

if [[ -f "output/$cdir/loginfound.txtls" ]]
	then
		echo -e "\e[93mTotal login portals found: \e[32m$(cat output/$cdir/loginfound.txtls | tr '[:upper:]' '[:lower:]' | anew| wc -l)\e[0m"
	else
		echo -e "\e[93mTotal login portals found: \e[32m0\e[0m"
fi

echo -e "\e[93mTotal unique subdomains found: \e[32m$(cat output/$cdir/$cdir.master | tr '[:upper:]' '[:lower:]'| anew  | wc -l)\e[0m"
echo -e "\e[93mTotal unique root domains found: \e[32m$(cat output/$cdir/rootdomain.txtls | tr '[:upper:]' '[:lower:]'|anew | wc -l)\e[0m"
cat output/$cdir/rootdomain.txtls | tr '[:upper:]' '[:lower:]' | anew
