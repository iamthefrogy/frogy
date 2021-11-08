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

registrant=$(whois $domain_name &> /dev/null | grep "Registrant Organization" | cut -d ":" -f2 | xargs| sed 's/,/%2C/g' | sed 's/ /+/g'| egrep -v '(*Whois*|*whois*|*WHOIS*|*domains*|*DOMAINS*|*Domains*|*domain*|*DOMAIN*|*Domain*|*proxy*|*Proxy*|*PROXY*|*PRIVACY*|*privacy*|*Privacy*|*REDACTED*|*redacted*|*Redacted*|*DNStination*|*WhoisGuard*|*Protected*|*protected*|*PROTECTED*)')
if [ -z "$registrant" ]
then
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls
else
        curl -s "https://crt.sh/?q="$registrant"" | grep -P -i '<TD>([a-zA-Z]+(\.[a-zA-Z]+)+)</TD>' | sed -e 's/^[ \t]*//' | cut -d ">" -f2 | cut -d "<" -f1 | anew >> output/$cdir/whois.txtls
        curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls
fi

registrant2=$(whois $domain_name &> /dev/null | grep "Registrant Organisation" | cut -d ":" -f2 | xargs| sed 's/,/%2C/g' | sed 's/ /+/g'| egrep -v '(*Whois*|*whois*|*WHOIS*|*domains*|*DOMAINS*|*Domains*|*domain*|*DOMAIN*|*Domain*|*proxy*|*Proxy*|*PROXY*|*PRIVACY*|*privacy*|*Privacy*|*REDACTED*|*redacted*|*Redacted*|*DNStination*|*WhoisGuard*|*Protected*|*protected*|*PROTECTED*)')
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

if [ -f "sublister_output.txt" ]; then
        cat sublister_output.txt >> output/$cdir/sublister.txtls
        rm sublister_output.txt
	cat output/$cdir/sublister.txtls >> all.txtls
	echo -e "\e[36mSublister count: \e[32m$(cat output/$cdir/sublister.txtls | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"
else
        echo -e "\e[36mSublister count: \e[32m0\e[0m"
fi

#################### FINDOMAIN ENUMERATION ######################

findomain-linux -t $domain_name -q >> output/$cdir/findomain.txtls
cat output/$cdir/findomain.txtls >> all.txtls
echo -e "\e[36mFindomain count: \e[32m$(cat output/$cdir/findomain.txtls | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"

#################### GATHERING ROOT DOMAINS ######################

python3 rootdomain.py | cut -d " " -f7 | anew | sed '/^$/d' >> rootdomain.txtls
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

portlst=`naabu -l output/$cdir/$cdir.master -p 80,443,8008,2082,2086,2087,5001,5000,2096,8080,2083,2095,10443,2077,2079,8443,21,8081,4443,3128,8090,9090,2222,9443,20000,8000,8888,444,10000,81,8083,7080,9000,25,8800,4100,7001,3000,3001,9001,8181,1500,8089,10243,8880,4040,18081,9306,9002,8500,11000,7443,12000,2030,465,2031,3702,8889,587,10250,9999,10001,8001,9080,50000,5353,49153,88,82,11300,11211,8834,5984,7071,2121,5006,22222,1000,5222,4848,9943,53,3306,8009,83,5555,8086,8140,8082,49152,14147,9200,5172,8123,60001,3790,17000,13579,8139,32400,21025,25105,85,23424,7548,27017,28017,16992,50050,52869,16010,50100,23023,32764,37215,50070,55442,51106,41800,55554,9998,33060,8887,4433,8088,3780,7777,37777,35000,25001,2376,9123,631,8010,20547,7000,6308,7081,5005,4643,8099,5986,55443,993,9191,84,9444,6080,8200,23,1900,8060,5002,14265,9092,5601,8098,666,7547,5050,8087,1024,8069,9595,9009,22,8085,55553,1234,8545,8112,311,16993,7474,1080,8334,5010,9098,8333,8084,7779,8649,2223,445,9007,7657,143,1025,221,7634,2002,5800,51235,7218,2323,4567,4321,9981,2375,1935,5801,2480,2067,8002,873,880,2020,9944,9869,110,4430,5858,9160,9295,5560,90,8899,4949,992,9082,2332,5900,5432,995,8444,5500,25565,1400,1471,503,5985,5901,6667,3689,1311,3542,4840,5357,8383,808,5003,6664,3541,9008,102,3749,8180,5080,1741,888,2008,6666,1604,89,4664,1883,4782,119,9988,4506,4063,8018,1023,6001,8999,8091,6633,6653,8989,2379,2000,5443,8011,1200,6000,902,4282,9042,5007,502,2455,8043,4911,6443,9997,8006,8852,11,49,4022,15,26,389,6697,2080,8111,19,5577,9084,5009,9088,13,2081,17,86,37,9091,8050,4064,636,99,8003,8859,2404,9010,8100,70,43,3333,7171,8282,8005,180,2345,8021,800,8096,6379,8447,1153,9051,8101,2181,9006,1521,4500,8095,8585,11112,8445,2021,4001,9003,8020,7002,9151,79,8866,7070,8004,8446,4899,8442,27015,179,771,5004,4646,9004,62078,8787,548,54138,9005,3443,8092,9445,8023,8033,8012,8040,8015,8848,1099,3389,8047,448,515,8030,3052,8007,8051,8022,8032,5600,3002,7788,2048,8052,8850,4242,2221,8413,8403,8041,8093,8881,8042,2053,8990,2443,8013,8416,8590,7700,8553,8094,8402,8036,8019,9990,2001,8038,8017,9966,8097,8102,8035,8182,3080,8014,8412,777,8034,8044,8054,8420,7010,8415,8045,20,8891,7979,8418,1111,7778,5569,8037,8857,8046,8025,8877,8988,8053,8686,8843,8049,8110,6565,8103,8048,8107,8104,2100,2761,8126,9100,2762,8222,8108,8055,990,9500,8029,8066,10554,8808,554,8602,9020,5025,7090,2052,8016,7500,8106,8765,8448,8801,8890,2122,4999,8028,8027,8812,8410,9600,8105,8031,9876,8026,8039,8401,8811,2233,8855,98,8845,7005,8935,8830,20256,8791,8432,8804,7004,8833,830,7003,8788,8818,801,3299,6006,8056,8143,3260,8184,8024,8623,9898,7654,8810,3388,1110,3005,8109,8700,8829,8823,7999,8821,8841,9050,8666,6668,8820,1599,8071,8856,8586,7776,9021,9991,8431,7445,7537,8844,8876,8426,8807,8118,8419,8784,8072,8790,8805,8885,8879,9011,9070,7444,8190,8248,8251,8847,2018,8767,8814,8827,8425,8840,8779,9201,8663,8433,8817,8837,8241,8824,450,8424,8838,8236,8414,8422,8621,8809,8969,7510,8873,8237,8766,8853,8991,8430,8865,8159,8423,7433,7493,8421,9761,449,1026,7401,8058,8802,8826,8836,8239,8417,8428,8839,1723,2525,8429,8806,8849,8870,8858,8878,7170,8832,8688,8789,8872,9016,9530,2111,8819,8861,8868,8252,8825,8842,8846,1433,7676,8291,8405,8813,8860,9099,8057,8238,8822,8871,9015,5269,7887,8064,8993,9022,6002,7998,8406,8411,8851,9102,9527,7465,9418,999,8407,8831,8828,100,447,5938,8864,8554,8622,8782,9992,2022,3310,6600,7535,8409,9012,7014,8816,8863,8875,9040,8637,8815,8862,9027,8249,8803,8404,9036,9994,8243,8733,9097,9111,9300,8869,9093,3100,8874,9095,8408,8835,9031,9955,9014,9211,8867,2055,9094,9205,222,2060,8513,9207,21379,91,104,2010,9310,9389,2070,9202,2069,6789,9307,4369,8427,9045,9215,9993,9217,9950,2065,9048,8854,2054,211,1962,2066,9203,789,2150,2352,4002,2059,9023,9101,9204,2058,9038,9026,1235,9013,6580,9049,9218,9029,9105,9110,9222,9690,2200,9019,9210,5150,9030,9251,2063,4445,9214,9743,4786,6008,9682,9032,9107,9220,121,9765,1981,2068,4545,2061,9037,2057,18245,264,2225,9189,9216,9303,1911,9206,9219,9304,113,1028,9041,9299,4730,9108,9305,2351,9208,9221,9301,44818,2626,9035,2056,5678,2250,9103,2062,9028,9034,9106,195,1990,9025,1050,9018,9046,9136,9209,9861,175,2560,3404,9089,9550,5400,9033,9899,4200,9039,9047,9119,9212,9213,9302,2051,2201,6003,9104,9199,9311,9433,9606,9704,2232,2555,9044,2259,3090,9663,9024,9096,4010,92,3101,3838,6007,6262,9017,3053,3200,2548,1250,2126,2211,2220,87,2557,5090,9109,111,843,2382,2567,3104,5201,5672,9309,555,3690,4043,2709,3085,3307,6161,1355,2202,2266,2550,3092,5070,9308,2551,3048,6543,135,2012,3050,3083,3552,9043,2320,2559,3056,3060,3095,3120,3550,5280,1119,1833,2050,2602,3094,6955,2549,2566,3055,3058,3073,6005,1027,2561,3102,5321,2558,3403,5454,2556,2569,3110,805,3091,3129,5446,3071,3074,2554,3054,3082,3111,3115,6511,1947,2572,3121,3557,3068,3096,3112,3113,3950,3523,6010,2003,3049,3099,3569,5051,1588,3063,5567,5596,2553,2563,3088,2601,3062,3409,199,1650,1660,3079,3098,3548,3951,5605,106,2985,3069,3077,3117,5602,5908,1290,1344,1830,2006,3070 -silent | cut -d ":" -f2 | anew | tr "\n" "," | sed 's/.$//'` &> /dev/null

httpx -silent -l output/$cdir/$cdir.master -p $portlst -fr -include-chain -store-chain -sc -tech-detect -server -title -cdn -cname -probe -srd output/$cdir/raw_http_responses/ -o output/$cdir/temp_live.txtls &> /dev/null

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
