# VPC
resource "aws_vpc" "terra_vpc" {
  cidr_block       = "${var.vpc_cidr}"
  tags {
    Name = "TerraVPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "terra_igw" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  tags {
    Name = "main"
  }
}

# Subnets : public
resource "aws_subnet" "public" {
  count = "${length(var.subnets_cidr)}"
  vpc_id = "${aws_vpc.terra_vpc.id}"
  cidr_block = "${element(var.subnets_cidr,count.index)}"
  availability_zone = "${element(var.azs,count.index)}"
  tags {
    Name = "Subnet-${count.index+1}"
    immutable_metadata = "{\"purpose\": \"terra-subnet${count.index+1}\"}"
  }
}

# Route table: attach Internet Gateway 
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terra_igw.id}"
  }
  tags {
    Name = "publicRouteTable"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "a" {
  count = "${length(var.subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id,count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}




#######
# Create the Security Group
resource "aws_security_group" "My_VPC_Security_Group" {
  vpc_id       = "${aws_vpc.terra_vpc.id}"
  name         = "My VPC Security Group"
  description  = "My VPC Security Group"
ingress {
    cidr_blocks = "${var.ingressCIDRblock}"  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
tags = {
        Name = "My VPC Security Group"
  }
} # end resource



#######################################################################################
#-resource "aws_lb" "test" {
#-  name               = "test-lb-tf"
#-  internal           = false
#-  load_balancer_type = "network"
#-  security_groups    = ["${aws_security_group.My_VPC_Security_Group.id}"]
#-  subnets            = ["${aws_subnet.public.*.id}"]

#  enable_deletion_protection = true

#  access_logs {
#    bucket  = "${aws_s3_bucket.lb_logs.bucket}"
#    prefix  = "test-lb"
#    enabled = true
#  }

#-  tags = {
#-    Environment = "production"
#-  }
#-}
##########################################################################################

# Create a new load balancer
resource "aws_elb" "bar" {
  name               = "foobar-terraform-elb"
#  availability_zones = ["us-west-2a", "us-west-2b"]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }


  security_groups    = ["${aws_security_group.My_VPC_Security_Group.id}"]
  subnets            = ["${aws_subnet.public.*.id}"]

#  instances                   = ["${aws_instance.foo.id}"]
#  cross_zone_load_balancing   = true
#  idle_timeout                = 400
#  connection_draining         = true
#  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
}
######
