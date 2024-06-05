variable "cidr_block" {
  type = string
  description = "cidr block value"
}

variable "cidr_block_s1" {
  type = string
  description = "cidr block for subnet1"
}

variable "az" {
  type = string
  description = "availability zone for my vpc"
}

variable "cidr_block_s2" {
  type = string
  description = "cidr block for subnet2"
}

variable "az2" {
  type = string
  description = "availability zone for my subnet"
}

variable "route_cidr" {
  type = string
  description = "cidr for route table"
}