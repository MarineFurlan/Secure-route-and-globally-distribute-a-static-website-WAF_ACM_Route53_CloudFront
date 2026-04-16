# Secure, route and globally distribute a static website : WAF + ACM + Route53 + CloudFront

**Status :** 🟡 In progress
<br/>
<br/>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<img width="107" height="60" alt="Amazon-Web-Services-AWS-Logo" src="https://github.com/user-attachments/assets/f7829385-3361-48fc-8099-849da5534de5" />
&emsp;<img width="75" height="86" alt="Terraform-Logo" src="https://github.com/user-attachments/assets/b037706b-3866-4376-9b2d-55c91b6dafc0" />


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
<br/>

| Components                                       | Justification                                                                               |
|--------------------------------------------------|---------------------------------------------------------------------------------------------|
| **Terraform**                                    | Reproducibility, version control, automated deployments, costs optimization                 | 
| **Only common rules for WAF protection**         | Demonstration simplicity, FreeTier scope for this service                                   | 

<br/>
<br/>
<br/>

## 3. Architecture Overview
<a name="#3-architecture-overview"></a>      
 <img width="919" height="651" alt="Secure_Static_Website" src="https://github.com/user-attachments/assets/e8a1fd66-fb92-4b31-aedc-71a26f50b31c" />

<br/>
<br/>     

| Components        | AWS Service                                                      | Role                                                          | 
|-------------------|------------------------------------------------------------------|---------------------------------------------------------------|
| **Distribution**  | CloudFront                                                       | Content delivery, caching, encrypted traffic with origin      |
| **Security**      | WAF, ACM, S3 bucket policy                                       | In-flight website encryption, protection against common attacks and access control| 
| **Routing**       | Route53                                                          | Routing dns requests                                          |                       
| **Storage**       | S3                                                               | Website files storage                                         |

<br/>
<br/>
<br/>

## 4. Deployment
<a name="#4-deployment"></a>
&emsp;&emsp;The distribution is deployed with Terraform, enabling fast, repeatable, automated, and version-controlled deployments.  
Here are the main steps to reproduce the environment:  

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

```terraform
git clone https://github.com/MarineFurlan/Secure-route-and-globally-distribute-a-static-website-WAF_ACM_Route53_CloudFront.git
cd Secure-route-and-globally-distribute-a-static-website-WAF_ACM_Route53_CloudFront
```
</details>

<br/> 

<details>
<summary>Step 2 - Initialize the infrastructure</summary>  
  
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

Step 3 - Confirm the subscription to security alerts in your email inbox.

<br/>

<details>
<summary>Step 4 - Deployment validation</summary>

<br/>

A serie of tests will now be executed to review the infrastructure and its integrity.

<br/>

<!-- Test diagram -->

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

<br/>
<br/>
<br/>

## Author
**Furlan Marine - Certified AWS Solutions Architect - Associate** \
📌https://www.linkedin.com/in/marinefurlan/ \
🎓https://www.credly.com/badges/06426b31-106e-4251-b866-6da8f4200e68/linked_in?t=t7j3hl
