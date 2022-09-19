##### RUN IT AS ROOT AND ENSURE YOU HAVE GO INSTALLED ON YOUR KALI MACHINE

apt update
apt install -y jq
apt install -y whois
apt install -y libpcap-dev
apt install -y golang
chmod +x frogy.sh
git clone https://github.com/aboul3la/Sublist3r.git
git clone https://github.com/rbsec/dnscan.git
go install -v github.com/tomnomnom/anew@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install github.com/tomnomnom/unfurl@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
apt install -y amass
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
wget https://github.com/Findomain/Findomain/releases/download/8.2.1/findomain-linux.zip
unzip findomain-linux.zip
chmod +x findomain
mv findomain /usr/bin/
rm findomain-linux.zip
go install -v github.com/cgboal/sonarsearch/cmd/crobat@latest
cd /root/go/bin
cp anew httpx waybackurls crobat subfinder unfurl /usr/bin/
# kali user and ubuntu user
apt install pip
pip install -r dnscan/requirements.txt
pip install -r Sublist3r/requirements.txt
