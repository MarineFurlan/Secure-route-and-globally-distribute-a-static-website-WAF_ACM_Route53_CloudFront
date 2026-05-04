# Secure, route and globally distribute a static website : WAF + ACM + Route53 + CloudFront

**Status :** 🟡 In progress
<br/>
<br/>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<img width="107" height="60" alt="Amazon-Web-Services-AWS-Logo" src="https://github.com/user-attachments/assets/f7829385-3361-48fc-8099-849da5534de5" />
<img width="75" height="86" alt="Terraform-Logo" src="https://github.com/user-attachments/assets/b037706b-3866-4376-9b2d-55c91b6dafc0" />


## Table of content
- [Introduction](#1-introduction)
- [Design Decisions](#2-design-decisions)
- [Architecture Overview](#3-architecture-overview)
- [Deployment](#4-deployment)
- [Results](#5-results)
- [Infrastructure Cleaning](#6-infrastructure-cleaning)
- [Pricing](#7-pricing)
- [Improvements & Next Steps](#8-improvements--next-steps)
- [References](#9-references)
- [Repository Structure](#10-repo-structure)
<br/>
<br/>
<br/>



## 1. Introduction 
<a name="#1-introduction"></a>     
&emsp;&emsp;This lab walks through distributing a static website, hosted in S3, via the Cloudfront content delivery network, ensuring a global and fast access with its caching feature.\
In-flight traffic encryption is managed by ACM with a TLS certificate.\
WAF is used to detect and block commo web attacks.

<br/>
<br/>


## 2. Design Decisions   
<br/>

| Components                                | Justification                                                                                                                                                   |
|-------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Terraform**                             | Reproducibility, version control, automated deployments, costs optimization                                                                                     | 
| **Only common rules for WAF protection**  | Demonstration simplicity, FreeTier scope for this service                                                                                                       |
| **WAF testing with cross-site scripting** | Demonstration simplicity, multiple pentest (as DDOS or Flood attacks are prohibited by AWS) |

<br/>
<br/>
<br/>

## 3. Architecture Overview
<a name="#3-architecture-overview"></a>      
<img width="1597" height="565" alt="StaticWebsite_Distribution" src="https://github.com/user-attachments/assets/4851dabc-b1cb-47c0-bca2-e68f205efc0b" />




<br/>
<br/>     

| Components        | AWS Service                                                                         | Role                                                                                                  | 
|-------------------|-------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| **Distribution**  | CloudFront                                                                          | Content delivery, caching, encrypted traffic with origin                                              |
| **Security**      | WAF, ACM, S3 bucket policy, encryption at rest, object versioning, security headers | In-flight website encryption, protection against common attacks, access control and Disaster Recovery | 
| **Routing**       | Route53                                                                             | Routing dns requests                                                                                  |                       
| **Storage**       | S3                                                                                  | Website files storage                                                                                 |

<br/>
<br/>
<br/>

## 4. Deployment
<a name="#4-deployment"></a> 

<br/>

<details>
<summary>Prerequisites</summary>
 
- Active AWS account.   
- AWS CLI configured.   
- Terraform installed.
- A domain name in route53  
</details>

<br/>

<details>
<summary>Step 1 - Clone this repo</summary> 

<br/>

```terraform
git clone https://github.com/MarineFurlan/Secure-route-and-globally-distribute-a-static-website-WAF_ACM_Route53_CloudFront.git
cd infrastructure
```
</details>

<br/> 

<details>
<summary>Step 2 - Review and complete variables.tf file</summary>  

<br/>

Change the default value of the domain variable, it must be the domain name you want to distribute your website on.

<br/>

```terraform
variable "domain" {
  type    = string
  default = "[your_domain_name]"
}
```  
</details>

<br/>

<details>
<summary>Step 3 - Initialize the infrastructure</summary>  

<br/>

```terraform
terraform init
terraform plan
terraform apply
```  
```terraform
# Expected result in CLI

Apply complete!                                                                                                                                                                        
```
</details>

<br/>

<details>
<summary>Step 4 - Deployment validation</summary>

<br/>

A serie of tests will now be executed to review the infrastructure and its integrity.

<br/>

<!-- Test diagram -->
<img width="1597" height="638" alt="StaticWebsite_Distribution_test" src="https://github.com/user-attachments/assets/ae30c3c3-3d85-45e7-82f2-501069e5661a" />


<br/>
<br/>

```bash
# Run the validation tests
bash tests.sh
```
```bash
# Expected results                                                                                                                                                           
```
</details>

<br/>
<br/>
<br/>

## 5. Results
<a name="#5-results"></a>

Infrastructure overview :

<!-- Infrastructure screenshots -->

<br/>
<br/>
<br/>

## 6. Infrastructure cleaning
<a name="#6-infrastructure-cleaning"></a>

To avoid unexpected fees, destroying the infrastructure after the completion of this lab is good practice.

```terraform
terraform plan -destroy
terraform destroy -auto-approve
```  

<br/>
<br/>
<br/>

## 7. Pricing
<a name="#7-pricing"></a>
The estimate below is based on the [AWS Pricing Calculator](https://calculator.aws).  

| Service                            | Selected Option                   | Estimated Monthly*  | Justification |
|------------------------------------|----------------------------------|---------------------|---------------|
| **ACM**                            | TLS Public Certificate           | 0 USD               | Free service when used associated to Cloudfront. Required to encrypt data in transit |
| **Web Applicatio Firewall (WAF)**  | Free Rules                       | 5 USD per ACL       | Enough to defend against common web attacks while offering basic monitoring |
| **Route53**                        | 1 Hosted Zone / 1 Domain         | 12 USD for a .fr + 0.50 USD per hosted zone for the forst 25 zones  | Required to route traffic to Cloudfront |
| **CloudFront**                     |                                  | 0 USD               | Free within Free Tier (< 1To data transfer/month) + HTTP redirection to HTTPS |
| **TOTAL**                          |                                  | **~17.50 USD**      |

\* Costs estimated for domain name using a .fr TLD and a website hosted in eu-west-3. Includes fixed service costs only, not traffic-related costs.  

<br/> 
<br/>
<br/>

## 8. Improvements & Next Steps
<a name="#8-improvements--next-steps"></a>

Potential enhancements to the infrastructure include:  
- Encrypting s3 bucket at rest with KMS key
- Enabling bucket versioning
- Tagging every resource to analyze AWS spend by project
- Adding WAF rules (ex: geo-blocking rules, custom rules)
- Adding CloudWatch alarms for suspicious activity
- Enabling resources logging
 

<br/>
<br/>
<br/>

## 9. References
<a name="#9-references"></a>  

:link:[Hosting Static Websites on AWS - AWS Whitepaper](https://docs.aws.amazon.com/pdfs/whitepapers/latest/build-static-websites-aws/build-static-websites-aws.pdf)\
:link:[Web Application Firewall - AWS Docs](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html)\
:link:[AWS Certificate Manager - AWS Docs](https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html)\
:link:[Route53 - AWS Docs](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)\
:link:[Cloudfront - AWS Docs](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)\
:link:[AWS Pricing Calculator](https://calculator.aws/#/)\
:link:[AWS Free Tier](https://aws.amazon.com/free) 

<br/>
<br/>
<br/>

## 10. Repository Structure
<a name="#10-repo-structure"></a> 

```bash
├── infrastructure/              # IaC code
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
├── website/                     # generic website files
├── tests.sh                     # Infrastructure validation tests file
└── README.md                    # This file
```
<br/>
<br/>
<br/>

## Author
**Furlan Marine - Certified AWS Solutions Architect - Associate** \
📌https://www.linkedin.com/in/marinefurlan/ \
🎓https://www.credly.com/badges/06426b31-106e-4251-b866-6da8f4200e68/linked_in?t=t7j3hl
