# 1. AWS 지역 설정 (서울)
provider "aws" {
  region = "ap-northeast-2"
}

# 2. VPC (기반 네트워크) 생성
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "my-eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # 비용 절감을 위해 NAT 게이트웨이는 딱 1개만 만듭니다.
  enable_nat_gateway     = true
  single_nat_gateway     = true 
  enable_dns_hostnames   = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-sample-eks"
  cluster_version = "1.30"

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    # 💡 이름 끝에 '-new'를 붙이면 테라폼이 꼬인 과거를 잊고 새로 만듭니다.
    clean_node_group = {
      instance_types = ["m7i-flex.large"]
      min_size     = 1  
      max_size     = 1
      desired_size = 1

      # ⚠️ 에러의 주범인 bootstrap 관련 옵션은 절대 금지
    }
  }

  enable_cluster_creator_admin_permissions = true
}