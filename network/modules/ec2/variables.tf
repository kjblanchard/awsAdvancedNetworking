variable "subnet_id" {
    description = "Subnet id for this ec2 instance"

}

variable "name" {
    description = "Name of the ec2 for tag"

}

variable "instance_profile_name" {
    default = ""
    description = "The instance profile to attach to the ec2, else none"

}

variable "security_group_id" {
    default = ""
    description = "The security group to attach to this ec2, else none"
}