# Task

Our requirement terraform script to work we need following variables in (varfile\default.tfvars) file

aws_access_key = ""

aws_secret_key = " "

regios = ""

vpc_main_id = ""

keyname = ""

amiid = ""   #Give ubuntu:16.04 ami id

To configure cloudfront distribution with the ELB as the origin, We have to install aws cli and aws configure on your machine 

To start terraform script following command need to run 

terraform init .

terraform validate  -var-file="varfile\default.tfvars"

terraform plan   -var-file="varfile\default.tfvars"
terraform apply  -var-file="varfile\default.tfvars"

P.S: I have written script in generic structure, however we can separate it is module based and we can trim and beatify the scripting.

