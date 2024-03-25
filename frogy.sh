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
# this code is taken from another open-source project at - https://github.com/bing0o/SubEnum/blob/master/subenum.sh

curl -sk "http://web.archive.org/cdx/search/cdx?url=*."$domain_name"&output=txt&fl=original&collapse=urlkey&page=" | awk -F / '{gsub(/:.*/, "", $3); print $3}' | anew | sort -u >> output/$cdir/wayback.txtls
cat output/$cdir/wayback.txtls | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' >> all.txtls
echo -e "\e[36mWaybackEngine count: \e[32m$(cat output/$cdir/wayback.txtls | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"

#################### CERTIFICATE ENUMERATION ######################
### AS CERT.SH IS DOWN I AM COMMENTIG THIS CODE #####
#registrant=$(whois $domain_name | grep "Registrant Organization" | cut -d ":" -f2 | xargs| sed 's/,/%2C/g' | sed 's/ /+/g'| egrep -v '(Whois|whois|WHOIS|domains|DOMAINS|Domains|domain|DOMAIN|Domain|proxy|Proxy|PROXY|PRIVACY|privacy|Privacy|REDACTED|redacted|Redacted|DNStination|WhoisGuard|Protected|protected|PROTECTED)')
#if [ -z "$registrant" ]
#then
#        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls
#else
#        curl -s "https://crt.sh/?q=$registrant" | grep -P -i '<TD>([a-zA-Z]+(\.[a-zA-Z]+)+)</TD>' | sed -e 's/^[ \t]*//' | cut -d ">" -f2 | cut -d "<" -f1 | anew >> output/$cdir/whois.txtls
#        curl -s "https://crt.sh/?q=$domain_name&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls
#fi

#registrant2=$(whois $domain_name | grep "Registrant Organisation" | cut -d ":" -f2 | xargs| sed 's/,/%2C/g' | sed 's/ /+/g'| egrep -v '(Whois|whois|WHOIS|domains|DOMAINS|Domains|domain|DOMAIN|Domain|proxy|Proxy|PROXY|PRIVACY|privacy|Privacy|REDACTED|redacted|Redacted|DNStination|WhoisGuard|Protected|protected|PROTECTED)')
#if [ -z "$registrant2" ]
#then
#        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls
#else
#        curl -s "https://crt.sh/?q="$registrant2"" | grep -a -P -i '<TD>([a-zA-Z]+(\.[a-zA-Z]+)+)</TD>' | sed -e 's/^[ \t]*//' | cut -d ">" -f2 | cut -d "<" -f1 | anew >> output/$cdir/whois.txtls
#        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls
#fi
#cat output/$cdir/whois.txtls | grep -oP '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}' | anew >> all.txtls
#echo -e "\e[36mCertificate search count: \e[32m$(cat output/$cdir/whois.txtls | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"

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

#################### DNSCAN ENUMERATION ######################

python3 dnscan/dnscan.py -d $domain_name -w dnscan/subdomains-10000.txt -o output/$cdir/dns_temp.txtls > /dev/null 2>&1
awk -v domain="$domain_name" '/^\[\*\] Scanning / && $0 ~ domain && / for A records$/ {flag=1; next} flag {print $NF}' output/$cdir/dns_temp.txtls | anew > output/$cdir/dnscan.txtls
echo -e "\e[36mDnscan count: \e[32m$(cat output/$cdir/dnscan.txtls | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\."  | wc -l)\e[0m"

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

httpx -silent -l live.assets -p 80,443,81,82,88,135,143,300,554,591,593,832,902,981,993,1010,1024,1311,2077,2079,2082,2083,2086,2087,2095,2096,2222,2480,3000,3128,3306,3333,3389,4243,4443,4567,4711,4712,4993,5000,5001,5060,5104,5108,5357,5432,5800,5985,6379,6543,7000,7170,7396,7474,7547,8000,8001,8008,8014,8042,8069,8080,8081,8083,8085,8088,8089,8090,8091,8118,8123,8172,8181,8222,8243,8280,8281,8333,8443,8500,8834,8880,8888,8983,9000,9043,9060,9080,9090,9091,9100,9200,9443,9800,9981,9999,10000,10443,12345,12443,16080,18091,18092,20720,28017,49152 -nc -j -o op.json | jq . > op2.json | echo 'Domain_Name,Application_URL,Port,Host,Title,Content_Type,Content_Length,A_record,CNAME,CSP_Domains' > output/$cdir/webometry.csv && jq -r '[.input, .url, .port, .host, .title, .content_type, .content_length, ((.a // empty) | join(", ")) , ((.cname // empty) | join(", ")), (.csp.domains // empty | join(", "))] | @csv' op2.json >> output/$cdir/webometry.csv
rm op*.json
cat output/$cdir/webometry.csv| cut -d ',' -f2 | grep -v 'Application_URL' | anew > output/$cdir/site_list.txtls

##GENERATE SUMMARY##

echo -e "\e[93mTotal unique root domains found: \e[32m$(cat output/$cdir/rootdomain.txtls | tr '[:upper:]' '[:lower:]' |anew | wc -l)\e[0m"
echo -e "\e[93mTotal unique subdomains found: \e[32m$(cat output/$cdir/$cdir.master | tr '[:upper:]' '[:lower:]'| anew  | wc -l)\e[0m"
echo -e "\e[93mTotal unique resolved subdomains found: \e[32m$(cat live.assets | wc -l) \e[0m"
echo -e "\e[93mTotal unique web applications found: \e[32m$(cat output/$cdir/site_list.txtls | tr '[:upper:]' '[:lower:]' |anew | wc -l)\e[0m"
cat output/$cdir/rootdomain.txtls | tr '[:upper:]' '[:lower:]' | anew

##HOUSE KEEEPING STUFF##
mv output/$cdir/*.txtls output/$cdir/raw_output
mv output/$cdir/raw_output/rootdomain.txtls output/$cdir/
rm live.assets
