variable "amis" {
	type    = "map"
    default = {
        eu-west-1    = "ami-c36effb0"
        eu-central-1 = "ami-cfca25a0"
    }
}

variable "region" {
	type    = "string"
	default = "eu-west-1"
}

variable "instance_type" {
	type    = "string"
	default = "r3.large"
}

variable "key_pair" {
	type    = "string"
	default = "inception"
}

variable "name" {
	type    = "string"
	default = "coreos"
}


variable "subnet_id" {
	type    = "string"
}

variable "root_disk_size" {
	default = 20
}

variable "disk_size" {
	default = 100
}

variable "security_groups" {
	type = "string"
}

variable "cloud_config" {
	type    = "string"
	default = "user_data/cloud-config.yaml"
}

variable "kubelet_wrapper" {
	type    = "string"
	default = "user_data/kubelet_wrapper"
}

variable "ca_pem" {
	type    = "string"
	default = "credentials/ca.pem"
}

variable "apiserver_pem" {
	type    = "string"
	default = "credentials/apiserver.pem"
}

variable "apiserverkey_pem" {
	type    = "string"
	default = "credentials/apiserver-key.pem"
}

variable "admin_pem" {
	type    = "string"
	default = "credentials/admin.pem"
}

variable "adminkey_pem" {
	type    = "string"
	default = "credentials/admin-key.pem"
}

variable "instance_profile" {
	type    = "string"
	default = ""
}