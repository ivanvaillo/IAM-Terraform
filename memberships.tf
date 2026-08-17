locals {
  user_groups = {
    carlos    = "administracion_finanzas"
    roberto   = "administracion_finanzas"
    leandro   = "ventas"
    beth      = "ventas"
    petra     = "atencion_cliente"
    anastasia = "atencion_cliente"
    javier    = "soporte_it"
    luis      = "soporte_it"
    marcos    = "auditoria_compliance"
    mercedes  = "auditoria_compliance"
  }

  group_names = {
    administracion_finanzas = aws_iam_group.administracion_finanzas.name
    ventas                  = aws_iam_group.ventas.name
    atencion_cliente        = aws_iam_group.atencion_cliente.name
    soporte_it              = aws_iam_group.soporte_it.name
    auditoria_compliance    = aws_iam_group.auditoria_compliance.name
  }
}

resource "aws_iam_user_group_membership" "usuarios_grupos" {
  for_each = local.user_groups

  user = aws_iam_user.users[each.key].name

  groups = [
    local.group_names[each.value]
  ]
}