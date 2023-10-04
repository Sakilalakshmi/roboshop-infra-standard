module "shipping" {
  source = "../../terraform-roboshop-app"
  project_name = var.project_name
  env = var.env
  common_tags = var.common_tags

  # target group
  #health_check = var.health_check  # In module we already provide health check,so no need to given
  target_group_port = var.target_group_port
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  # launch-template
  image_id = data.aws_ami.devops_ami.id
  security_group_id = data.aws_ssm_parameter.shipping_sg_id.value
  user_data = filebase64("${path.module}/shipping.sh")
  launch_template_tags = var.launch_template_tags

  # autoscaling
  vpc_zone_identifier = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
  tag = var.autoscaling_tags

  # autoscaling policy, I am good with optional parameter.
  
  # listener rule
  alb_listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  rule_priority = 40 # catalogue have 10, user have 20,cart have 30 already
  host_header = "shipping.app.learningdevops.shop"
}