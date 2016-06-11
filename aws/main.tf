provider "aws" {
    profile    = "${var.profile}"
    region     = "${var.region}"
}

module "host_1" {
	source           = "coreos"
	name             = "${var.stack_name}-coreos-1"
	subnet_id        = "${aws_subnet.public.id}"
	key_pair         = "${var.key_pair}"
	instance_type    = "r3.large"
    instance_profile = "${aws_iam_instance_profile.basic.name}"
	security_groups  = "${aws_security_group.allow_ssh.id},${aws_security_group.allow_internal.id},${aws_security_group.allow_apps.id}"
}

output "host1_ip" {
	value = "${module.host_1.public_ip}"
}

