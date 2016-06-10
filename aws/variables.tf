variable "stack_name" {
	type    = "string"
}

variable "region" {
	type    = "string"
    default = "eu-west-1"
}

variable "profile" {
	type    = "string"
    default = "default"
}

variable "vpc_cidr" {
	type    = "string"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
	type    = "string"
	default = "10.0.0.0/24"
}

variable "key_pair" {
	type    = "string"
}
