#!/bin/bash

echo -e "\033[0;92m"
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

echo -e "\e[94mEnter the organisation name (E.g., Carbon Black): \e[0m"
read org

cdir=`echo $org | tr '[:upper:]' '[:lower:]'| tr " " "_"`

cwhois=`echo $org | tr " " "+"`

echo -e "\e[94mEnter the root domain name (eg: frogy.com): \e[0m"
read domain_name

csn=`echo "$domain_name" | cut -d "." -f1`

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
        mkdir output/$cdir/raw_output
        mkdir output/$cdir/raw_output/raw_http_responses
else
        echo -e "\e[94mCreating $org directory in the 'output' folder... \e[0m"
        mkdir output/$cdir
        mkdir output/$cdir/raw_output
        mkdir output/$cdir/raw_output/raw_http_responses
fi

############################################################### Subdomain enumeration ######################################################################

#################### CHAOS ENUMERATION ######################

echo -e "\e[92mIdentifying Subdomains \e[0m"

echo -n "Is this program is in the CHAOS dataset? (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
        curl -s https://chaos-data.projectdiscovery.io/index.json -o index.json
        chaosvar=`cat index.json | grep -w $cdir | grep "URL" | sed 's/"URL": "//;s/",//' | xargs`
        if [ -z "$chaosvar" ]
        then
                echo -e "\e[36mSorry! could not find data in CHAOS DB...\e[0m"
                subfinder -d $domain_name --silent -o output/$cdir/subfinder.txtls > /dev/null 2>&1
                cat output/$cdir/subfinder.txtls | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' >> all.txtls
        else
                curl -s "$chaosvar" -O
                unzip -qq *.zip
                cat *.txt >> output/$cdir/chaos.txtls
                cat output/$cdir/chaos.txtls | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' >> all.txtls
                echo -e "\e[36mChaos count: \e[32m$(cat output/$cdir/chaos.txtls | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"
                find . | grep .txt | sed 's/.txt//g' | cut -d "/" -f2 | grep  '\.' >> subfinder.domains
                subfinder -dL subfinder.domains --silent -recursive -o output/$cdir/subfinder.txtls > /dev/null 2>&1
                rm subfinder.domains
                cat output/$cdir/subfinder.txtls | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' >> all.txtls
                rm *.zip
                rm *.txt
        fi
        rm index.json*
else
        :
fi

#################### WayBackEngine  ENUMERATION ######################

curl -sk "http://web.archive.org/cdx/search/cdx?url=*."$domain_name"&output=txt&fl=original&collapse=urlkey&page=" | awk -F / '{gsub(/:.*/, "", $3); print $3}' | anew | sort -u >> output/$cdir/wayback.txtls
cat output/$cdir/wayback.txtls | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' >> all.txtls
echo -e "\e[36mWaybackEngine count: \e[32m$(cat output/$cdir/wayback.txtls | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"

#################### CERTIFICATE ENUMERATION ######################
registrant=$(whois $domain_name | grep "Registrant Organization" | cut -d ":" -f2 | xargs| sed 's/,/%2C/g' | sed 's/ /+/g'| egrep -v '(Whois|whois|WHOIS|domains|DOMAINS|Domains|domain|DOMAIN|Domain|proxy|Proxy|PROXY|PRIVACY|privacy|Privacy|REDACTED|redacted|Redacted|DNStination|WhoisGuard|Protected|protected|PROTECTED|Registration Private|REGISTRATION PRIVATE|registration private)')
if [ -z "$registrant" ]
then
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls
else
        curl -s "https://crt.sh/?q=$registrant" | grep -P -i '<TD>([a-zA-Z]+(\.[a-zA-Z]+)+)</TD>' | sed -e 's/^[ \t]*//' | cut -d ">" -f2 | cut -d "<" -f1 | anew >> output/$cdir/whois.txtls
        curl -s "https://crt.sh/?q=$domain_name&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls
fi

registrant2=$(whois $domain_name | grep "Registrant Organisation" | cut -d ":" -f2 | xargs| sed 's/,/%2C/g' | sed 's/ /+/g'| egrep -v '(Whois|whois|WHOIS|domains|DOMAINS|Domains|domain|DOMAIN|Domain|proxy|Proxy|PROXY|PRIVACY|privacy|Privacy|REDACTED|redacted|Redacted|DNStination|WhoisGuard|Protected|protected|PROTECTED)')
if [ -z "$registrant2" ]
then
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls
else
        curl -s "https://crt.sh/?q="$registrant2"" | grep -a -P -i '<TD>([a-zA-Z]+(\.[a-zA-Z]+)+)</TD>' | sed -e 's/^[ \t]*//' | cut -d ">" -f2 | cut -d "<" -f1 | anew >> output/$cdir/whois.txtls
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls
fi
cat output/$cdir/whois.txtls | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' | anew >> all.txtls
echo -e "\e[36mCertificate search count: \e[32m$(cat output/$cdir/whois.txtls | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"

#################### FINDOMAIN ENUMERATION ######################

findomain -t $domain_name -q >> output/$cdir/findomain.txtls
cat output/$cdir/findomain.txtls | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' | anew >> all.txtls
echo -e "\e[36mFindomain count: \e[32m$(cat output/$cdir/findomain.txtls | tr '[:upper:]' '[:lower:]'| anew |grep -v " "|grep -v "@" | grep "\."| wc -l)\e[0m"

#################### GATHERING ROOT DOMAINS ######################

python3 rootdomain.py | cut -d " " -f7 | tr '[:upper:]' '[:lower:]' | anew | sed '/^$/d' | grep -v " "|grep -v "@" | grep "\." >> rootdomain.txtls

#################### SUBFINDER2 ENUMERATION ######################

subfinder -dL rootdomain.txtls --silent -o output/$cdir/subfinder2.txtls > /dev/null 2>&1
echo -e "\e[36mSubfinder count: \e[32m$(cat output/$cdir/subfinder2.txtls | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\."  | wc -l)\e[0m"
cat output/$cdir/subfinder2.txtls | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' | anew >> all.txtls

#################### BBOT ENUMERATION ######################
bbot -t $domain_name -f subdomain-enum  -rf passive -o output -n $cdir -y > /dev/null 2>&1
echo -e "\e[36mBbot count: \e[32m$(cat output/$cdir/subdomains.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\."  | wc -l)\e[0m"
cat output/$cdir/subdomains.txt | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' | anew >> all.txtls

#################### HOUSEKEEPING TASKS #########################

mv rootdomain.txtls output/$cdir/
echo "www.$domain_name" | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' >> all.txtls
echo "$domain_name" | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' >> all.txtls
cat all.txtls | tr '[:upper:]' '[:lower:]' | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' | anew >> $cdir.master
mv $cdir.master output/$cdir/$cdir.master
sed -i 's/<br>/\n/g' output/$cdir/$cdir.master
rm all.txtls

#################### SUBDOMAIN RESOLVER ######################
dnsx -l output/$cdir/$cdir.master -silent -a -aaaa -cname -ns -txt -ptr -mx -soa -axfr -caa -resp -json -o output/$cdir/resolved.json > /dev/null 2>&1
cat output/$cdir/resolved.json | jq . | grep host | cut -d " " -f4 | cut -d '"' -f2 | xargs | tr " " "\n" | anew > live.assets

##CONVERT JSON TO CSV FOR FUTURE##

############################################################################# PERFORMING WEB DISCOVERY  ##################################################################

httpx -silent -l live.assets -p 80,443,7547,8089,8085,8443,8080,4567,8008,8000,8081,2087,1024,2083,2082,2086,8888,5985,9080,81,21,8880,5000,7170,3000,8082,9000,5001,3128,8090,8001,7777,9306,10443,9090,8800,10000,88,9999,4433,82,4443,9100,9443,8083,5555,5357,4444,49152,6443 -o webometry -oa > /dev/null 2>&1
cat webometry.csv| cut -d ',' -f11 | anew > output/$cdir/site_list.txtls
cp output/$cdir/site_list.txtls .
mv site_list.txtls urls.txt
mv webometry* output/$cdir/

./loginlocator.sh > /dev/null 2>&1

mv output.csv login.csv
##GENERATE SUMMARY##

echo -e "\e[93mTotal unique root domains found: \e[32m$(cat output/$cdir/rootdomain.txtls | tr '[:upper:]' '[:lower:]' |anew | wc -l)\e[0m"
echo -e "\e[93mTotal unique subdomains found: \e[32m$(cat output/$cdir/$cdir.master | tr '[:upper:]' '[:lower:]'| anew  | wc -l)\e[0m"
echo -e "\e[93mTotal unique resolved subdomains found: \e[32m$(cat live.assets | wc -l) \e[0m"
echo -e "\e[93mTotal unique web applications found: \e[32m$(cat output/$cdir/site_list.txtls | tr '[:upper:]' '[:lower:]' |anew | wc -l)\e[0m"
echo -e "\e[93mTotal unique login interfaces found: \e[32m$( cat login.csv| cut -d "," -f2 | grep "Yes" | wc -l)\e[0m"
mv login.csv output/$cdir/
cat output/$cdir/rootdomain.txtls | tr '[:upper:]' '[:lower:]' | anew

##HOUSE KEEEPING STUFF##
mv output/$cdir/*.txtls output/$cdir/raw_output
mv output/$cdir/raw_output/rootdomain.txtls output/$cdir/
rm live.assets  urls.txt
