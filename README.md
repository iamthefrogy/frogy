<h1 align="center">
  <a href="https://github.com/iamthefrogy/frogy"><img src="https://user-images.githubusercontent.com/8291014/111029632-a1d13280-83f5-11eb-943a-002f71680d90.png" alt="frogy" height=230px></a>

![](https://visitor-badge.glitch.me/badge?page_id=iamthefrogy.frogy)<a href="https://twitter.com/iamthefrogy"> </a>

  </h1>
<h4 align="center"> Made with ❤️ ❤️ ❤️ from <img src="https://user-images.githubusercontent.com/8291014/145205748-5530f102-9102-4659-a141-21872f237c57.png" alt="frogy" height=20px> </h4>
My goal is to create an open-source Attack Surface Management solution and make it capable to find all the IPs, domains, subdomains, live websites, login portals for one company. <br/><br/>

**How it can help a large company (Some usecases):**
- **Vulnerability management team:** Can use the result to feed into their known and unknown assets database to incease their vulnerability scanning coverage.
- **Threat intel team:** Can use the result to feed into their intel DB to prioritize proactive monitoring for critical assets.
- **Asset inventory team:** Can use the result to keep their asset inventory database up-to-date by adding new unknown assets facing Internet and finding contact information for the assets inside your organization.
- **SOC team:** Can use the result to identify what all assets they are monitoring vs. not monitoring and then increase their coverage slowly.
- **Patch management team:** Many large organizations are unaware of their legacy, abandoned assets facing the Internet; they can utilize this result to identify what assets need to be taken offline if they are not being used.<br/>

It has multiple use cases depending your organization's processes and technology landscpae.

**Logic** <br/>
<img src="https://user-images.githubusercontent.com/8291014/148620188-3966a2e9-0089-401f-bf90-7909a93af1bf.jpg" alt="Frogy" title="Frogy" />

**Features**
- :frog: Horizontal subdomain enumeration
- :frog: Vertical subdomain enumeration
- :frog: Resolving subdomains to IP
- :frog: Identifying live web applications
- :frog: Identifying web applications with login portals enabled

+ **Requirements:** Go Language, Python 3.+, jq<br/>
    
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
    Output file will be saved inside the output/company_name/outut.csv folder. Where company_name is any company name which you give as an input to 'Organization Name' at the start of the script.
    ```

**TODO**
- :heavy_check_mark: Efficient folder structure management
- :heavy_check_mark: Resolving subdomains using dig
- :heavy_check_mark: Add dnscan for extened subdomain enum scope
- :heavy_check_mark: Eliminate false positives.
- :heavy_check_mark: Bug Fixed, for false positive reporting of domains and subdomains.
- :heavy_check_mark: Searching domains through crt.sh via registered organization name from WHOIS instead of domain name created some garbage data. Filtered result to only grab domains and nothing else.
- :heavy_check_mark: Now finds live websites on all standard/non-standard ports.
- :heavy_check_mark: Now finds all websites with login portals. It also checks websites home page that redirects to login page automatically upon opening.
- :heavy_check_mark: Now finds live web application based on top 1000 shodan http/https ports through facet analysis. Uses Naabu for fast port scan followed by httpx. (Credit: @nbk_2000)
- :heavy_check_mark: Generate CSV (Root domains, Subdomains, Live sites, Login Portals)
- :heavy_check_mark: Now provides output for resolved subdomains
- :heavy_check_mark: Added WayBackEngine support from another project
- :heavy_check_mark: Added BufferOver support from another project.
- :heavy_check_mark: Added Amass coverage.
- :construction: Add docker support to avoid dependency issues.
- :construction: Add progress bar for each main feature runnign so it shows some progress while running.
- :construction: Reducing execution time by performing resolved asset's port discovery.
  

#### A very warm thanks to the authors of the tools used in this script.
Initial repo created - A few weeks back below date.<br/>
Date - 4 March 2019, Open-sourced<br/>
Date - 19 March 2021, Major changes<br/>

Warning/Disclaimer: Read the detailed disclaimer at my blog - https://github.com/iamthefrogy/Disclaimer-Warning/blob/main/README.md <br/>
Logo credit - www.designevo.com
