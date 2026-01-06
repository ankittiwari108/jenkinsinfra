output "pubip" {
    value = aws_instance.inst_j.public_ip
  
}
output "pvtip"{
    value = aws_instance.inst_j.private_ip
}