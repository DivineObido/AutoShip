resource "aws_acm_certificate" "cert" {
  domain_name = "goldgym.work.gd"
   subject_alternative_names = ["www.goldgym.work.gd"]
  validation_method = "DNS"
}