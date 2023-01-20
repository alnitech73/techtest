# Tech test

This repo contains 2 projects:

* aws-cli: Python script running in a container
* terraform-docker: Terraform code to create AWS instance, install docker and run nginx docker image

Prerequisite:

* AWS account
* IAM User with programatic access and sufficient EC2 permissions to create/list/update instances
* shared aws credentials (~/.aws/credentials) with the default profile
* docker
* terraform
* make

## aws-cli

Steps:

* Go to project folder: `cd aws-cli`
* Build test image and runs coverage report: `make test`
* Build docker image: `make build`
* Run docker image: `make run region=<REGION_NAME>`. Default region is **us-east-2**
* Help: `make help`

Python script: 
* requires a valid AWS region as argument
* displays ALL instances in the specified region

## terraform-docker

Steps:

* Go to project folder: `cd terraform-docker`
* Initialize: `terraform init`
* Plan: `terraform plan -out TF.plan`
* Apply: `terraform apply "TF.plan"`
* Destroy: `terraform destroy`

Note: Terraform state is local backend