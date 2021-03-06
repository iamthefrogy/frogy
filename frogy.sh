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

echo -e "\e[94mEnter the organisation name (without space): \e[0m"
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

registrant=$(whois $domain_name | grep "Registrant Organization" | cut -d ":" -f2 | xargs| sed 's/,/%2C/g' | sed 's/ /+/g'| egrep -iv ".(*Whois*|*whois*|*WHOIS*|*domains*|*DOMAINS*|*domain*|*DOMAIN*|*proxy*|*PROXY*|*PRIVACY*|*privacy*|*REDACTED*|*redacted*|*DNStination*|*WhoisGuard*)")
if [ -z "$registrant" ]
then
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].common_name" | sed 's/*.//g' | anew >> output/$org/whois.txtls
else
        curl -s "https://crt.sh/?q="$registrant"&output=json" | jq -r ".[].common_name" | sed 's/*.//g' | anew >> output/$org/whois.txtls
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].common_name" | sed 's/*.//g' | anew >> output/$org/whois.txtls
fi

cat output/$org/whois.txtls >> all.txtls
echo -e "\e[36mCertificate search count: \e[32m$(cat output/$org/whois.txtls | anew | wc -l)\e[0m"

python3 sublister/sublist3r.py -d $domain_name -o sublister_output.txt &> /dev/null
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

awk -F\. '{print $(NF-1) FS $NF}' all.txtls | anew >> final.txtls
subfinder -dL final.txtls --silent >> output/$org/subfinder2.txtls
echo -e "\e[36mSubfinder count: \e[32m$(cat output/$org/subfinder2.txtls | anew | wc -l)\e[0m"

cat output/$org/subfinder2.txtls >> all.txtls

rm final.txtls
echo "www.$domain_name" >> all.txtls
echo "$domain_name" >> all.txtls
cat all.txtls | grep $org | anew >> $org.master
mv $org.master output/$org/$org.master
rm all.txtls
echo -e "\e[93mTotal UNIQUE subdomains found: $(cat output/$org/$org.master | anew | wc -l)\e[0m"

echo -e "\e[94mGenerating live URLs...\e[0m"
cat output/$org/$org.master | httpx --silent -ports 80,280,443,591,593,832,981,1965,2480,4444,4445,4567,5104,5800,5985,5986,7000,7002,8008,8042,8080,8088,8222,8243,8280,8281,8403,8448,8530,8531,8887,8888,9443,9981,11371,12043,12046,12443,16080,18091,18092 >> output/$org/liveurls.txtls
echo -e "\e[93mCount of live websites: $(cat output/$org/liveurls.txtls | anew | wc -l)\e[0m"
