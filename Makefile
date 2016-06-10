.PHONY: plan apply deploy destroy clean

export CLOUD ?= aws

default: deploy
	
plan:
	terraform get -update $(CLOUD)/
	terraform plan -module-depth=-1 -var-file terraform.tfvars -out terraform.tfplan $(CLOUD)/

apply:
	terraform apply -var-file terraform.tfvars $(CLOUD)/

deploy: plan apply

destroy:
	terraform plan -destroy -var-file terraform.tfvars -out terraform.tfplan $(CLOUD)/
	terraform apply terraform.tfplan

clean: compress
	gzip user_data/cloud-config.yaml user_data/cloud-config.yaml.gz

clean: destroy
	rm -f terraform.tfplan
	rm -f terraform.tfstate
	rm -fR .terraform
