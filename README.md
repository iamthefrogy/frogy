<h1 align="center">
  <a href="https://github.com/iamthefrogy/frogy"><img src="https://user-images.githubusercontent.com/8291014/111029632-a1d13280-83f5-11eb-943a-002f71680d90.png" alt="frogy" height=230px></a>
  </h1>
Using the combination of different subdomain tools it tries to identify more subdomains using combination of bruteforce and other techniques. <br/><br/>

**Logic**<br/>
<img src="https://user-images.githubusercontent.com/8291014/110205963-f82cf700-7e72-11eb-9156-78f1d2e7a57a.png" alt="Frogy" title="Frogy" />

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
    chmod +x frogy.sh
    ```
+ **Usage**
    ```sh
    ./frogy.sh
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
- Eliminate false positives. Currently around 2% to 4% false positives are there.
- ✅  ~~Removed resolving part~~
- ✅  ~~Find live URLs on standard (80, 443) and non-standard ports (8080, 8443, 8888, etc.)~~

#### Thanks to the authors of the tools used in this script.

#### I planned to used it in one of the paid tools but soon realised that the tools I am using in this script are restricted for commercial license. I didn't check it in the first place (my bad). So Removed encrypted script, scrapped paid tool project, open-sourced this script. Script is very simple though. I may update it occassionally.

Initial repo created - A few weeks back below date.
Date - 4 March 2019, Open-sourced

**Warning:** This is just a research project. Kindly use it with caution and at your own risk. </br>
Logo credit - www.designevo.com
