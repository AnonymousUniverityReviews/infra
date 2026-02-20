moved {
  from = module.networking.aws_vpc.eks_vpc
  to   = module.networking.aws_vpc.vpc
}

moved {
  from = module.networking.aws_subnet.eks_private_subnets
  to   = module.networking.aws_subnet.private_subnets
}

moved {
  from = module.networking.aws_subnet.eks_public_subnets
  to   = module.networking.aws_subnet.public_subnets
}

moved {
  from = module.networking.aws_internet_gateway.eks_gw
  to   = module.networking.aws_internet_gateway.gw
}

moved {
  from = module.networking.aws_route_table.eks_public
  to   = module.networking.aws_route_table.public
}

moved {
  from = module.networking.aws_route_table_association.eks_private_subnets
  to   = module.networking.aws_route_table_association.private_subnets
}

moved {
  from = module.networking.aws_route_table_association.eks_public_subnets
  to   = module.networking.aws_route_table_association.public_subnets
}

moved {
  from = module.networking.aws_eip.eks_nat
  to   = module.networking.aws_eip.nat
}

moved {
  from = module.networking.aws_nat_gateway.eks
  to   = module.networking.aws_nat_gateway.nat
}

moved {
  from = module.networking.aws_route_table.eks_private
  to   = module.networking.aws_route_table.private
}

moved {
  from = module.networking.aws_route_table_association.eks_private_subnets
  to   = module.networking.aws_route_table_association.private_subnets
}
