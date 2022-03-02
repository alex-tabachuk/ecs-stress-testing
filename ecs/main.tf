data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_kms_key" "ecs" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}

resource "random_pet" "cluster" {
  count = length(toset(var.target))
}
resource "random_pet" "service" {
  count = length(toset(var.target))
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = random_pet.cluster[0].id
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  count = length(toset(var.target))

  name = random_pet.cluster[count.index].id
  container_insights = false
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
    }
  ]
}

resource "aws_ecs_service" "main" {
  count = length(toset(var.target))

  name            = random_pet.service[count.index].id
  cluster         = module.ecs[count.index].ecs_cluster_id
  task_definition = aws_ecs_task_definition.service[count.index].arn
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
  count = length(toset(var.target))

  family                = md5(module.container_definition[count.index].json_map_encoded)
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  container_definitions = module.container_definition[count.index].json_map_encoded_list
}

module "container_definition" {
  source = "cloudposse/ecs-container-definition/aws"

  count = length(toset(var.target))

  container_name  = random_pet.service[count.index].id
  container_image = "atabachuk/hulk"
  command = ["-site", var.target[count.index]]
}