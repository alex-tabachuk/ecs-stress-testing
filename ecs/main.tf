data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_kms_key" "ecs" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}

resource "random_pet" "cluster" {}
resource "random_pet" "service" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = random_pet.cluster.id
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  name = random_pet.cluster.id
  container_insights = false
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
    }
  ]
}

resource "aws_ecs_service" "main" {
  name            = random_pet.service.id
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.how_many

  capacity_provider_strategy {
      capacity_provider = "FARGATE"
      weight = 100
  }

  network_configuration {
    subnets = module.vpc.public_subnets
    assign_public_ip = true
  }
}

resource "aws_ecs_task_definition" "service" {
  family                = "service"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  container_definitions = module.container_definition.json_map_encoded_list
}

module "container_definition" {
  source = "cloudposse/ecs-container-definition/aws"

  container_name  = random_pet.service.id
  container_image = "alpine/bombardier"
  command = ["-c", "1500", "-d", "300s", "-l", var.target]
}