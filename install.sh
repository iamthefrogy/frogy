apt install -y jq
apt install -y whois
sudo apt install -y libpcap-dev
chmod +x frogy.sh
git clone https://github.com/aboul3la/Sublist3r.git
git clone https://github.com/rbsec/dnscan.git
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go get -u github.com/tomnomnom/anew
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux
chmod +x findomain-linux
cp findomain-linux /usr/bin
cd /root/go/bin
cp anew httpx subfinder naabu /usr/bin/
