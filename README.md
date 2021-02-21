# Frogy's Subdomain Enumeraton - It's not yet another Subdomain Enumeration tool
Using the combination of different subdomain tools it tries to identify more subdomains using combination of bruteforce and other techniques. <br/><br/>
**WARNING**<br/><br/>
<img src="https://user-images.githubusercontent.com/8291014/108618620-7327f380-7417-11eb-8f5a-2b462a820502.png" alt="Frogy" title="Frogy" height="90"/><br/>
The script logic will be used in one of my friend's paid tool with some other capabilities. Hence, I am not planning to open-source it for a couple of months. After June, I have plans to open-source it. I would suggest, run this in your sandbox environment if you don't trust the encrypted code, and you can also monitor traffic if you want. I have no intentions to steal any of your system's data. Kindly run it at your own concern and risk. I won't be responsible for any sort of liabilities.

<img src="https://user-images.githubusercontent.com/8291014/108609113-9de85c80-73c3-11eb-8836-aa2e947063e1.png" alt="Frogy" title="Frogy" height="600" />

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
    ```Output will be saved within output/ORG/ORG.master file. 
if telsa.com is your target then output file will be output/telsa/tesla.master
    ```
    
**TODO**
- ✅  ~~Efficient folder structure management~~
- ✅  ~~Resolving subdomains using Massdns~~
- ✅  ~~Add dnscan for extened subdomain enum scope~~
- ✅  ~~Add scope for extened subdomain enum scope~~
- ✅  Eliminate false positives. Currently around 7% to 10% false positives are there.
- ✅  Subdomain discovery through alterations and permutations (Altdns integration)
#### Thanks to the authors of the tools used in this script.

**Warning:** This is just a research project. Kindly use it with caution and at your own risk.
