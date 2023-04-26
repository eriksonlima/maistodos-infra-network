.PHONY: init-dv check plan-prd apply-prd
init-prd:
	terraform init;
	terraform workspace new prd || true;
	terraform workspace select prd;

check:
	terraform fmt;
	terraform validate;

plan-prd:
	$(MAKE) init-prd;
	$(MAKE) check
	terraform plan -out prd.tfplan
apply-prd:
	$(MAKE) init-prd;
	terraform apply prd.tfplan

####