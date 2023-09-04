# Configure the AWS provider with the desired region
provider "aws" {
  region = "eu-west-1c"  # Adjust the region as needed
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Create a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
}

# Create a NAT Gateway in the public subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {}

# Create a security group for the EC2 instance
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Security group for the EC2 instance"
  vpc_id      = aws_vpc.my_vpc.id
}

# Create an EC2 instance in the public subnet
resource "aws_instance" "ec2_instance" {
  ami           = "ami-051f7e7f6c2f40dc1"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = "devOps"     # Replace with your key pair name
}

# Create an S3 bucket for Terraform remote state (adjust the bucket name)
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "terraform-remote-state-bucket"
}

# Create an RDS instance
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "Amdocs51"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
