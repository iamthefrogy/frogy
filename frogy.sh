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

echo -e "\e[94mEnter the organisation name (For space include '+', E.g. recorded+future): \e[0m"
read org
echo -e "\e[94mEnter the root domain name (eg: frogy.com): \e[0m"
read domain_name
echo -e "\e[92mHold on! some house keeping tasks being done... \e[0m"
if [[ -d output ]]
then
        :
else
        mkdir output
fi
if [[ -d output/$org ]]
then
        echo -e "\e[94mCreating $org directory in the 'output' folder...\e[0m"
        rm -r output/$org
        mkdir output/$org
else
        echo -e "\e[94mCreating $org directory in the 'output' folder... \e[0m"
        mkdir output/$org
fi

############################################################### Subdomain enumeration ######################################################################
echo -e "\e[92mIdentifying Subdomains \e[0m"

echo -n "Is this program is in CHAOS dataset? (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
        wget -q "https://chaos-data.projectdiscovery.io/index.json" && cat index.json | grep $org | grep "URL" | sed 's/"URL": "//;s/",//' | while read host do;do wget -q "$host";done && for i in `ls -1 | grep .zip$`;  do unzip -qq $i; done && rm *.zip || true
        cat *.txt >> output/$org/chaos.txtls || true
        rm index.json* || true
        cat output/$org/chaos.txtls >> all.txtls || true
        echo -e "\e[36mChaos count: \e[32m$(cat output/$org/chaos.txtls | anew | wc -l)\e[0m"
        find . | grep .txt | sed 's/.txt//g' | cut -d "/" -f2 | grep  '\.' >> subfinder.domains
        subfinder -dL subfinder.domains --silent -recursive >> output/$org/subfinder.txtls
        rm subfinder.domains
        cat output/$org/subfinder.txtls >> all.txtls
        rm *.txt
else
        subfinder -d $domain_name --silent >> output/$org/subfinder.txtls
        cat output/$org/subfinder.txtls >> all.txtls
fi
############ Generating Wordlist  ##############
cat all.txtls | cut -d "." -f1 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f2 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f3 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f4 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f5 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f6 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f7 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f8 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f9 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f10 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f11 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f12 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f13 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f14 >> temp_wordlist.txt
cat all.txtls | cut -d "." -f15 >> temp_wordlist.txt
cat temp_wordlist.txt | anew | sed '/^$/d' | sed 's/\*\.//g' | grep -v " " | grep -v "@" | grep -v "*" | sort -u >> $org-wordlist.txt

rm temp_wordlist.txt
mv $org-wordlist.txt output/$org

registrant=$(whois $domain_name | grep "Registrant Organization" | cut -d ":" -f2 | xargs| sed 's/,/%2C/g' | sed 's/ /+/g'| egrep -v '(*Whois*|*whois*|*WHOIS*|*domains*|*DOMAINS*|*Domains*|*domain*|*DOMAIN*|*Domain*|*proxy*|*Proxy*|*PROXY*|*PRIVACY*|*privacy*|*Privacy*|*REDACTED*|*redacted*|*Redacted*|*DNStination*|*WhoisGuard*|*Protected*|*protected*|*PROTECTED*)')
if [ -z "$registrant" ]
then
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$org/whois.txtls
else
        curl -s "https://crt.sh/?q="$registrant"" | grep -P -i '<TD>([a-zA-Z]+(\.[a-zA-Z]+)+)</TD>' | sed -e 's/^[ \t]*//' | cut -d ">" -f2 | cut -d "<" -f1 | anew >> output/$org/whois.txtls
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$org/whois.txtls
fi

registrant2=$(whois $domain_name | grep "Registrant Organisation" | cut -d ":" -f2 | xargs| sed 's/,/%2C/g' | sed 's/ /+/g'| egrep -v '(*Whois*|*whois*|*WHOIS*|*domains*|*DOMAINS*|*Domains*|*domain*|*DOMAIN*|*Domain*|*proxy*|*Proxy*|*PROXY*|*PRIVACY*|*privacy*|*Privacy*|*REDACTED*|*redacted*|*Redacted*|*DNStination*|*WhoisGuard*|*Protected*|*protected*|*PROTECTED*)')
if [ -z "$registrant2" ]
then
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$org/whois2.txtls
else
        curl -s "https://crt.sh/?q="$registrant2"" | grep -a -P -i '<TD>([a-zA-Z]+(\.[a-zA-Z]+)+)</TD>' | sed -e 's/^[ \t]*//' | cut -d ">" -f2 | cut -d "<" -f1 | anew >> output/$org/whois2.txtls
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$org/whois2.txtls
fi

cat output/$org/whois*.txtls >> all.txtls

echo -e "\e[36mCertificate search count: \e[32m$(cat output/$org/whois.txtls | anew | wc -l)\e[0m"

python3 Sublist3r/sublist3r.py -d $domain_name -o sublister_output.txt &> /dev/null
if [[ -e sublister_output.txt ]]
then
        cat sublister_output.txt >> output/$org/sublister.txtls
        rm sublister_output.txt
else
        :
fi
cat output/$org/sublister.txtls >> all.txtls
echo -e "\e[36mSublister count: \e[32m$(cat output/$org/sublister.txtls | anew | wc -l)\e[0m"

findomain-linux -t $domain_name -q >> output/$org/findomain.txtls
cat output/$org/findomain.txtls >> all.txtls
echo -e "\e[36mFindomain count: \e[32m$(cat output/$org/findomain.txtls | anew | wc -l)\e[0m"

python3 dnscan/dnscan.py -d %%.$domain_name -w output/$org/$org-wordlist.txt -D -o output/$org/dnscan.txtls &> /dev/null
cat output/$org/dnscan.txtls | grep $org | egrep -iv ".(DMARC|spf|=|[*])" | cut -d " " -f1 | anew | sort -u >> all.txtls

echo -e "\e[36mDnscan: \e[32m$(cat output/$org/dnscan.txtls | anew | wc -l)\e[0m"

python tld.py | grep -v "Match" | grep "\S" | anew >> tld.txtls

#cat  all.txtls | awk -F\. '{print $(NF-1) FS $NF}' | anew >> tld.txtls
subfinder -dL tld.txtls --silent >> output/$org/subfinder2.txtls
echo -e "\e[36mSubfinder count: \e[32m$(cat output/$org/subfinder2.txtls | anew | wc -l)\e[0m"
cat output/$org/subfinder2.txtls | grep "/" | cut -d "/" -f3 >> all.txtls
cat output/$org/subfinder2.txtls | grep -v "/" >> all.txtls

mv tld.txtls output/$org/
echo "www.$domain_name" >> all.txtls
echo "$domain_name" >> all.txtls
cat all.txtls | anew | grep -v "*." >> $org.master
mv $org.master output/$org/$org.master
sed -i 's/<br>/\n/g' output/$org/$org.master
rm all.txtls
httpx -l output/$org/$org.master -p 8080,10000,20000,2222,7080,9009,7443,2087,2096,8443,4100,2082,2083,2086,9999,2052,9001,9002,7000,7001,8082,8084,8085,8010,9000,2078,2080,2079,2053,2095,4000,5280,8888,9443,5800,631,8000,8008,8087,84,85,86,88,10125,9003,7071,8383,7547,3434,10443,8089,3004,81,4567,7081,82,444,1935,3000,9998,4433,4431,4443,83,90,8001,8099,80,300,443,591,593,832,981,1010,1311,2480,3128,3333,4243,4711,4712,4993,5000,5104,5108,6543,7396,7474,8014,8042,8069,8081,8088,8090,8091,8118,8123,8172,8222,8243,8280,8281,8333,8500,8834,8880,8983,9043,9060,9080,9090,9091,9200,9800,9981,12443,16080,18091,18092,20720,28017 -o output/$org/livesites.txtls &> /dev/null
echo -e "\e[93mTotal live websites (on all available ports) found: \e[32m$(cat output/$org/livesites.txtls | wc -l)\e[0m"
echo -e "\e[93mTotal UNIQUE subdomains found: \e[32m$(cat output/$org/$org.master | wc -l)\e[0m"
echo -e "\e[93mTotal UNIQUE TLDs found: \e[32m$(cat output/$org/tld.txtls | wc -l)\e[0m"
cat output/$org/tld.txtls
