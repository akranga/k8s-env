resource "aws_instance" "main" {
    ami = "${lookup(var.amis, var.region)}"
    instance_type = "${var.instance_type}"
    tags {
        Name = "${var.name}"
    }

    key_name = "${var.key_pair}"
    subnet_id = "${var.subnet_id}"
    user_data = "${template_file.cloud_config.rendered}"
#    user_data = "${file("${path.cwd}/${var.cloud_config}")}"
	security_groups = ["${split(",", "${var.security_groups}")}"]
	iam_instance_profile  = "${var.instance_profile}"

    associate_public_ip_address = true

	ephemeral_block_device {
		device_name  = "/dev/sdc"
		virtual_name = "ephemeral0"
	}

	root_block_device {
		volume_type  = "gp2"
		volume_size  = "${var.root_disk_size}"
		delete_on_termination = true
	}

	ebs_block_device {
		device_name           = "/dev/sdb"
		volume_type           = "gp2"
		volume_size           = "${var.disk_size}"
		delete_on_termination = true
	}
}

resource "template_file" "cloud_config" {
    template = "${file("${path.cwd}/${var.cloud_config}")}"
    vars {
    	ca_pem            = "${file("${path.cwd}/${var.ca_pem}")}"
    	apiserver_pem     = "${file("${path.cwd}/${var.apiserver_pem}")}"
    	apiserverkey_pem  = "${file("${path.cwd}/${var.apiserverkey_pem}")}"
#    	pod_cidr		  = "${var.pod_cidr}"
#    	kubelet_wrapper   = "${base64encode(file("${path.cwd}/${var.kubelet_wrapper}"))}"
    	kubernetes_ver    = "v1.2.3_coreos.0"
#        region         = "${var.region}"
#        cluster_props  = "${base64encode( template_file.cluster_props.rendered )}"
    }
}

output "public_ip" {
	value = "${aws_instance.main.public_ip}"
}