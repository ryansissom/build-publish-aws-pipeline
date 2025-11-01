output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnets" { value = module.vpc.public_subnets }
output "private_subnets" { value = module.vpc.private_subnets }
output "ecr_repo_url" { value = aws_ecr_repository.my_app_repo.repository_url }
