module "eu1" {
    source = "./ecs"

    region = "eu-central-1"
    secret_key = var.secret_key
    access_key = var.access_key
    how_many = var.count
    target = var.target
}

module "eu2" {
    source = "./ecs"

    region = "eu-west-1"
    secret_key = var.secret_key
    access_key = var.access_key
    how_many = var.count
    target = var.target
}

module "eu3" {
    source = "./ecs"

    region = "eu-west-2"
    secret_key = var.secret_key
    access_key = var.access_key
    how_many = var.count
    target = var.target
}

module "us1" {
    source = "./ecs"

    region = "us-east-1"
    secret_key = var.secret_key
    access_key = var.access_key
    how_many = var.count
    target = var.target
}

module "us2" {
    source = "./ecs"

    region = "us-west-1"
    secret_key = var.secret_key
    access_key = var.access_key
    how_many = var.count
    target = var.target
}

module "ca1" {
    source = "./ecs"

    region = "ca-central-1"
    secret_key = var.secret_key
    access_key = var.access_key
    how_many = var.count
    target = var.target
}

module "ap1" {
    source = "./ecs"

    region = "ap-southeast-1"
    secret_key = var.secret_key
    access_key = var.access_key
    how_many = var.count
    target = var.target
}

module "sa1" {
    source = "./ecs"

    region = "sa-east-1"
    secret_key = var.secret_key
    access_key = var.access_key
    how_many = var.count
    target = var.target
}

module "ap2" {
    source = "./ecs"

    region = "ap-southeast-2"
    secret_key = var.secret_key
    access_key = var.access_key
    how_many = var.count
    target = var.target
}

module "ap3" {
    source = "./ecs"

    region = "ap-northeast-1"
    secret_key = var.secret_key
    access_key = var.access_key
    how_many = var.count
    target = var.target
}