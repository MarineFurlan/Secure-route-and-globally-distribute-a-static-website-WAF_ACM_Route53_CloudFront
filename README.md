# AWS Static Website Distribution : CloudFront + Route 53 + WAF + ACM
<br/>
<br/>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<img width="107" height="60" alt="Amazon-Web-Services-AWS-Logo" src="https://github.com/user-attachments/assets/f7829385-3361-48fc-8099-849da5534de5" />
&emsp;<img width="75" height="86" alt="Terraform-Logo" src="https://github.com/user-attachments/assets/b037706b-3866-4376-9b2d-55c91b6dafc0" />


## Table of content
- [Introduction](#1-introduction)
- [Design Decisions](#2-design-decisions)
- [Architecture Overview](#3-architecture-overview)
- [Features](#4-features)
- [Deployment Steps](#5-deployment-steps)
- [Pricing](#6-pricing)
- [Improvements & Next Steps](#7-improvements--next-steps)
- [References](#8-references)
<br/>
<br/>
<br/>



## 1. Introduction 
<a name="#1-introduction"></a>     
&emsp;&emsp;This project showcases the secure distribution of a static website hosted on S3.         
It distributes a static wesite with CloudFront and Route53, using a TLS certificate (ACM) to encrypt data in transit.  
Security and monitoring are handled with WAF (Web Application Firewal) to restrict and detect common web attacks.
<br/>
<br/>


## 2. Design Decisions   
<a name="#2-design-decisions"></a>
### <ins>Terraform</ins>
Using IaC ensures reproducibility, version control, and automated deployments. The infrastructure can be deployed or destroyed with a single command, optimizing costs and agility.

## 3. Architecture Overview
<a name="#3-architecture-overview"></a>      
 <img width="919" height="651" alt="Secure_Static_Website" src="https://github.com/user-attachments/assets/e8a1fd66-fb92-4b31-aedc-71a26f50b31c" />

### Main Components: 

:open_file_folder:[Cloudfront](./infrastructure/modules/distribution/cloudfront.tf) : Distribution

:open_file_folder:[ACM](./infrastructure/modules/distribution/acm.tf) : Encryption in transit
<details>

<summary>See ACM attach in Cloudfront code</summary>
```terraform
viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
```
</details>

:open_file_folder:[Route53](./infrastructure/modules/distribution/route53.tf) : Routing to Cloudfront

:open_file_folder:[WAF](./infrastructure/modules/waf/main.tf) : Defense against common web attacks

## 4. Features
<a name="#4-features"></a>   

<br/>

- **_Security_**: 
  
<br/>

- **_Monitoring_**: 

<br/>

- **_Reproductibility_**: 

<br/>

- **_Isolation_**:

<br/>
<br/>
<br/>

## 5. Deployment Steps
<a name="#5-deployment-steps"></a>
&emsp;&emsp;The distribution is deployed with Terraform, enabling fast, repeatable, automated, and version-controlled deployments.  
Here are the main steps to reproduce the environment:  

### <ins>Prerequisites:</ins>
- Active AWS account.   
- AWS CLI configured.   
- Terraform installed.
- A domain name in route53  
  
### <ins>Deployment Steps:</ins>   

## 6. Pricing
<a name="#6-pricing"></a>
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

## 7. Improvements & Next Steps
<a name="#7-improvements--next-steps"></a>
Potential enhancements to the infrastructure include:  
 

<br/>
<br/>
<br/>

## 8. References
<a name="#8-references"></a>   
:link:[AWS Pricing Calculator](https://calculator.aws/#/)  
:link:[AWS Free Tier](https://aws.amazon.com/free) 
