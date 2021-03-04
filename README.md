# Frogy's Subdomain Enumeraton - It's not yet another Subdomain Enumeration tool
Using the combination of different subdomain tools it tries to identify more subdomains using combination of bruteforce and other techniques. <br/><br/>

<img src="https://user-images.githubusercontent.com/8291014/109435117-b7ffeb80-7a10-11eb-9324-3daa31739f58.png" alt="Frogy" title="Frogy" height="600" />

+ **Requirements:** Go Language, Python 3.+, jq<br/>
+ **Tools used - You must need to install these tools and place them into /usr/bin folder to use this script**<br/>

  + [SubFinder](https://github.com/projectdiscovery/subfinder) - Ensure the binary name must be 'subfinder' only
  + [Assetfinder](https://github.com/tomnomnom/assetfinder) - Ensure the binary name must be 'assetfinder' only
  + [Find-domain](https://github.com/Findomain/Findomain) - Ensure the binary name must be 'findomain-linux' only
  + [httprobe](https://github.com/tomnomnom/httprobe) - Ensure the binary name must be 'httprobe' only
  + [anew](https://github.com/tomnomnom/anew) - Ensure the binary name must be 'anew' only
  + [massdns](https://github.com/blechschmidt/massdns) - Ensure the binary name must be 'massdns' only
  
  You might require to install WHOIS and JQ depending upon your enviroment. You can install them using the following commands:
   ```sh
    apt install jq
    apt install whois
    ```
  
+ **Installation**
    ```sh
    git clone https://github.com/iamthefrogy/frogy.git
    cd frogy
    chmod +x frogy.sh.x
    ```
+ **Usage**
    ```sh
    ./frogy.sh.x
    ```
+ **Output**
    ```
    Output will be saved within output/ORG/ORG.master file. 
    If telsa.com is your target then output file will be output/telsa/tesla.master
    ```
    
**TODO**
- ✅  ~~Efficient folder structure management~~
- ✅  ~~Resolving subdomains using Massdns~~
- ✅  ~~Add dnscan for extened subdomain enum scope~~
- ✅  ~~Add scope for extened subdomain enum scope~~
- ✅  ~~Eliminate false positives. Currently around 2% to 4% false positives are there.
- ✅  ~~Removed resolving part~~
- ✅  ~~Find live URLs on standard (80, 443) and non-standard ports (8080, 8443, 8888, etc.)~~

#### Thanks to the authors of the tools used in this script.

**Warning:** This is just a research project. Kindly use it with caution and at your own risk.
