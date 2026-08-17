locals {
  users = {
    carlos    = "Carlos"
    roberto   = "Roberto"
    leandro   = "Leandro"
    beth      = "Beth"
    petra     = "Petra"
    anastasia = "Anastasia"
    javier    = "Javier"
    luis      = "Luis"
    marcos    = "Marcos"
    mercedes  = "Mercedes"
  }
}

resource "aws_iam_user" "users" {
  for_each = local.users

  name = each.value
}