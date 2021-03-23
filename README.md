<h1 align="center">
  <a href="https://github.com/iamthefrogy/frogy"><img src="https://user-images.githubusercontent.com/8291014/111029632-a1d13280-83f5-11eb-943a-002f71680d90.png" alt="frogy" height=230px></a>
  </h1>
Using the combination of different subdomain enumeration tools and logic this script tries to identify more subdomains and TLDs in recon. <br/><br/>

**Logic**<br/>
<img src="https://user-images.githubusercontent.com/8291014/110205963-f82cf700-7e72-11eb-9156-78f1d2e7a57a.png" alt="Frogy" title="Frogy" />

+ **Requirements:** Go Language, Python 3.+, jq<br/>
+ **Tools used - You must need to install these tools and place them into /usr/bin folder to use this script**<br/>

  + [SubFinder](https://github.com/projectdiscovery/subfinder)
  + [Find-domain](https://github.com/Findomain/Findomain)
  + [httpx](https://github.com/projectdiscovery/httpx)
  + [anew](https://github.com/tomnomnom/anew)
    
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
    If telsa.com is your target then output file Of all the subdomains will be output/telsa/tesla.master and all the TLDs will be recorded in the output/tesla/tld.txtls file.
    ```
    
**TODO**
- ✅  ~~Efficient folder structure management~~
- ✅  ~~Resolving subdomains using Massdns~~
- ✅  ~~Add dnscan for extened subdomain enum scope~~
- ✅  ~~Add scope for extened subdomain enum scope~~
- ✅  ~~Eliminate false positives. Currently around 2% to 4% false positives are there.~~
- ✅  ~~Removed resolving part~~
- ✅  ~~Find live URLs on standard (80, 443) and non-standard ports (8080, 8443, 8888, etc.)~~
-  Search for assets in CHAOS for organization names having space.
-  Add dnsenum for more extended support.

#### Thanks to the authors of the tools used in this script.
For crt.sh https://github.com/HackerUniverse/Reconcobra/blob/HackerUniverse-patch-1/crt.sh, this logic has been used.

Initial repo created - A few weeks back below date.<br/>
Date - 4 March 2019, Open-sourced<br/>
Date - 19 March 2021, Major changes<br/>

Warning/Disclaimer: Read the detailed disclaimer at my blog - https://github.com/iamthefrogy/Disclaimer-Warning/blob/main/README.md <br/>
Logo credit - www.designevo.com
