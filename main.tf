provider "aws" {
    region = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "instance_1" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    subnet_id = module.vpc.public_subnets[0]
    tags = {
        Name = "Instance-1"
    }
}

resource "aws_instance" "instance_2" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    subnet_id = module.vpc.public_subnets[1]
    tags = {
        Name = "Instance-2"
    }
}