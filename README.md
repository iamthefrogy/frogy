<h1 align="center">
  <a href="https://github.com/iamthefrogy/frogy"><img src="https://user-images.githubusercontent.com/8291014/111029632-a1d13280-83f5-11eb-943a-002f71680d90.png" alt="frogy" height=230px></a>

  </h1>
<h4 align="center"> Made with ❤️ ❤️ ❤️ from <img src="https://user-images.githubusercontent.com/8291014/145205748-5530f102-9102-4659-a141-21872f237c57.png" alt="frogy" height=20px> </h4>
Using the combination of different subdomain enumeration tools and logic this script tries to identify more subdomains and root domains in recon. <br/><br/>

**Logic**<br/>
<img src="https://user-images.githubusercontent.com/8291014/140434882-95e04fae-b225-4ab5-b686-3e6c8cfb9b0c.png" alt="Frogy" title="Frogy" />

+ **Requirements:** Go Language, Python 3.+, jq<br/>
+ **Tools used in this script - Below tools are covered in the installation process already.**<br/>

  + [SubFinder](https://github.com/projectdiscovery/subfinder)
  + [Find-domain](https://github.com/Findomain/Findomain)
  + [httpx](https://github.com/projectdiscovery/httpx)
  + [anew](https://github.com/tomnomnom/anew)
  + [naabu](https://github.com/projectdiscovery/naabu)
    
+ **Installation**
    ```sh
  chmod +x install.sh
  ./install.sh
    ```
+ **Usage**
    ```sh
    ./frogy.sh
    ```
+ **Demo**

    [![demo](https://asciinema.org/a/xDJyE9TccP1L809DPWGtIvuPj.svg)](https://asciinema.org/a/xDJyE9TccP1L809DPWGtIvuPj?autoplay=1)


+ **Output**
    ```
    Output will be saved within output/ORG/ORG.master file. 
    If you give 'chintan frogy' as your organization input, then the script will automatically create the 'chintan_frogy' folder inside the 'output' directory.
    ```
<img src="https://user-images.githubusercontent.com/8291014/140436973-71f45735-141c-4224-8e47-9855862719f4.png" alt="Frogy" title="Frogy" />

**TODO**
- ✅  Efficient folder structure management
- Resolving subdomains using Massdns
- ✅  Add dnscan for extened subdomain enum scope
- ✅  Eliminate false positives. Currently around 2% to 4% false positives are there.
- ✅  Bug Fixed, for false positive reporting of domains and subdomains.
- ✅  Searching domains through crt.sh via registered organization name from WHOIS instead of domain name created some garbage data. Filtered result to only grab domains and nothing else.
- ✅  Now finds live websites on all standard/non-standard ports.
- ✅  Now finds all websites with login portals. It also checks websites home page that redirects to login page automatically upon opening.
- ✅  Now finds live web application based on top 1000 shodan http/https ports through facet analysis. Uses Naabu for fast port scan followed by httpx. (Credit: @nbk_2000)
- ✅  Generate CSV (Root domains, Subdomains, Live sites, Login Portals)
- ✅  Now provides output for resolved subdomains
- ✅  Added WayBackEngine support from another project
- ✅  Added BufferOver support from another project.
- ✅  Added Amass coverage.

#### Thanks to the authors of the tools used in this script.
Initial repo created - A few weeks back below date.<br/>
Date - 4 March 2019, Open-sourced<br/>
Date - 19 March 2021, Major changes<br/>

Warning/Disclaimer: Read the detailed disclaimer at my blog - https://github.com/iamthefrogy/Disclaimer-Warning/blob/main/README.md <br/>
Logo credit - www.designevo.com
