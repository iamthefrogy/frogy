#!/bin/bash
if [ `whoami` != 'root' ];then
    echo -e "\033[1;91m"
    echo -e "\t\t\t!! Run with sudo !! " 
    exit 
fi

echo "Installing tools..."
apt-get -qq update
apt-get -qq install pip jq whois amass libpcap-dev unzip -y 
chmod +x frogy.sh
git clone https://github.com/rbsec/dnscan.git 2>/dev/null 
pip -qq install -r dnscan/requirements.txt 

function project_discovery(){
    case $(arch) in
        x86_64)
            cpu='amd64'
            ;;
        i686 | i386)
            cpu='386'
            ;;
        aarch64)
            cpu='arm64'
            ;;
        *)
            cpu='amd64'
            ;;
        esac

    for tool in {httpx,subfinder,dnsx,katana}
    do
        version=$(curl -IkLs -o /dev/null -w %{url_effective}  https://github.com/projectdiscovery/$tool/releases/latest|grep -o "[^/]*$"| sed "s/v//g")
        baseurl="https://github.com/projectdiscovery/$tool/releases/download/v$version/"$tool"_$version"_linux_"$cpu.zip"
        wget -q $baseurl -O $tool.zip 
        unzip -qo $tool.zip  
        chmod +x $tool && mv $tool /usr/bin/ 
        rm $tool.zip
    done

}

function tomnomnom(){
    case $(arch) in         
    x86_64)
        cpu='amd64'
        ;;
    i686 | i386)
        cpu='386'
        ;;
    *)
        cpu='amd64'
        ;;
    esac

    for tool in {anew,waybackurls,unfurl}
    do
        version=$(curl -IkLs -o /dev/null -w %{url_effective}  https://github.com/tomnomnom/$tool/releases/latest|grep -o "[^/]*$"| sed "s/v//g")
        baseurl="https://github.com/tomnomnom/$tool/releases/download/v$version/$tool-linux-$cpu-$version.tgz"        
        wget -q $baseurl -O $tool.tgz 
        tar xzf "$tool.tgz"
        chmod +x $tool && mv $tool /usr/bin/ 
        rm $tool.tgz
    done
}


function find_domain(){
    case $(arch) in         
    x86_64)
        cpu='-linux'
        ;;
    i686 | i386)
        #calling i386 function
        cpu='-linux-i386'
        ;;
    aarch64)
        #calling aarch function
        cpu='-aarch64'
        ;;
    *)
        cpu='-linux'
        ;;
    esac
    findomain_version=$(curl -IkLs -o /dev/null -w %{url_effective}  https://github.com/Findomain/Findomain/releases/latest|grep -o "[^/]*$"| sed "s/v//g")
    baseurl="https://github.com/Findomain/Findomain/releases/download/$findomain_version/findomain$cpu.zip"
    wget -q $baseurl -O findomain.zip 
    unzip -qo findomain.zip 
    chmod +x findomain && mv findomain /usr/bin/
    rm findomain.zip  
}

#Calling functions to downlaod binary file & move to /usr/bin
project_discovery
tomnomnom
find_domain

echo "Installation completed successfully!"
