module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "2.8.0"

  name = local.project

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy = [{ capacity_provider = "FARGATE" }]

  tags = local.tags
}

module "public_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.12.0"

  name               = local.project
  load_balancer_type = "application"
  internal           = false

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_http_sg.this_security_group_id, module.alb_https_sg.this_security_group_id]

  target_groups = [
    {
      name                 = local.project
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        path                = "/"
        interval            = 5
        timeout             = 4
        unhealthy_threshold = 3
      }
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  https_listeners = [
    {
      port            = 443
      certificate_arn = module.acm.this_acm_certificate_arn
    }
  ]

  https_listener_rules = [
    {
      https_listener_index = 0
      priority             = 100

      actions = [{
        type               = "forward"
        target_group_index = 0
      }]

      conditions = [{
        path_patterns = ["/oauth2"]
      }]
    },
    {
      https_listener_index = 0
      priority             = 10

      actions = [
        {
          type = "authenticate-cognito"

          type                = "authenticate-cognito"
          user_pool_arn       = module.cognito.user_pool.arn
          user_pool_client_id = module.cognito.clients[local.project].id
          user_pool_domain    = module.cognito.domain.domain
        },
        {
          type               = "forward"
          target_group_index = 0
        }
      ]

      conditions = [{
        path_patterns = ["/*"]
      }]
    }
  ]

  tags              = local.tags
  lb_tags           = local.tags
  target_group_tags = local.tags
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = "${local.project}-vpc"
  cidr = "10.200.0.0/16"

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "2.14.0"

  domain_name = local.domain_name
  zone_id     = local.r53_zone_id

  subject_alternative_names = ["*.${local.domain_name}"]

  tags = local.tags
}

module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "3.18.0"

  name        = "${local.project}-http-alb"
  vpc_id      = module.vpc.vpc_id
  description = "Security group with HTTP ports open for specific IPv4 CIDR block (or everybody), egress ports are all world open"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = local.tags
}

module "alb_https_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "3.18.0"

  name        = "${local.project}-https-alb"
  vpc_id      = module.vpc.vpc_id
  description = "Security group with HTTP ports open for specific IPv4 CIDR block (or everybody), egress ports are all world open"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = local.tags
}

module "cognito" {
  source  = "mineiros-io/cognito-user-pool/aws"
  version = "~> 0.5.0"

  name = local.project

  schema_attributes = [
    {
      name     = "email"
      type     = "String"
      required = true
      mutable  = true
    }
  ]

  alias_attributes = [
    "email", "phone_number", "preferred_username"
  ]

  auto_verified_attributes = [
    "email"
  ]

  # If invited by an admin
  invite_email_subject = "You've been invited to Pagar.me Atlantis"
  invite_email_message = "Hi {username}, your temporary password is '{####}'."
  invite_sms_message   = "Hi {username}, your temporary password is '{####}'."

  default_email_option  = "CONFIRM_WITH_LINK"
  email_subject_by_link = "Your Verification Link"
  email_message_by_link = "Please click the link below to verify your email address. {##Verify Email##}."
  sms_message           = "Your verification code is {####}."

  password_minimum_length    = 8
  password_require_lowercase = true
  password_require_numbers   = true
  password_require_uppercase = true
  password_require_symbols   = true

  temporary_password_validity_days = 3
  allow_admin_create_user_only     = false

  domain = local.project

  clients = [
    {
      name                                 = local.project
      read_attributes                      = ["email", "email_verified"]
      callback_urls                        = ["https://${aws_route53_record.lb.fqdn}/oauth2/idpresponse"]
      logout_urls                          = ["https://${aws_route53_record.lb.fqdn}"]
      generate_secret                      = true
      allowed_oauth_flows_user_pool_client = true
      allowed_oauth_flows                  = ["code"]
      allowed_oauth_scopes                 = ["email", "openid"]
      supported_identity_providers         = ["COGNITO"]
    }
  ]

  tags = local.tags
}

resource "aws_route53_record" "lb" {
  zone_id = local.r53_zone_id
  name    = local.project
  type    = "A"

  alias {
    name                   = module.public_alb.this_lb_dns_name
    zone_id                = module.public_alb.this_lb_zone_id
    evaluate_target_health = true
  }
}
