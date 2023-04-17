resource "aws_instance" "aliu_ec2" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public_subnet_1.id
  security_groups = [aws_security_group.sg.id]

  count = 5

  tags = {
    Name = "aliu-ec2-${count.index}"
  }

  key_name = aws_key_pair.Aliu_key.id
}

# create key pair

resource "aws_key_pair" "Aliu_key" {
  key_name   = "Aliu_key"
  public_key = file("${path.module}/public_key")
}


# create vpc

resource "aws_vpc" "Aliu_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Aliu-vpc"
  }
}

# create 4 subnet 

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.Aliu_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-Subnet-1"
  }
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.Aliu_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-Subnet-2"
  }
}
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.Aliu_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "pri-Subnet-1"
  }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.Aliu_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-west-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "pri-Subnet-2"
  }
}

# create internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Aliu_vpc.id
}

# create route table

resource "aws_route_table" "ali_rt" {
  vpc_id = aws_vpc.Aliu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "aliu-rt"
  }
}

# associate the route table
resource "aws_route_table_association" "A" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.ali_rt.id
}
resource "aws_route_table_association" "B" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.ali_rt.id
}
resource "aws_route_table_association" "C" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.ali_rt.id
}

# create security group
resource "aws_security_group" "sg" {
  name        = "Allow_tls"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.Aliu_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aliu_SG"
  }
}


