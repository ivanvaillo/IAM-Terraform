resource "aws_iam_group_policy_attachment" "administracion_finanzas" {
  group      = aws_iam_group.administracion_finanzas.name
  policy_arn = aws_iam_policy.administracion_finanzas.arn
}

resource "aws_iam_group_policy_attachment" "ventas" {
  group      = aws_iam_group.ventas.name
  policy_arn = aws_iam_policy.ventas.arn
}

resource "aws_iam_group_policy_attachment" "atencion_cliente" {
  group      = aws_iam_group.atencion_cliente.name
  policy_arn = aws_iam_policy.atencion_cliente.arn
}

resource "aws_iam_group_policy_attachment" "soporte_it" {
  group      = aws_iam_group.soporte_it.name
  policy_arn = aws_iam_policy.soporte_it.arn
}

resource "aws_iam_group_policy_attachment" "auditoria_compliance" {
  group      = aws_iam_group.auditoria_compliance.name
  policy_arn = aws_iam_policy.auditoria_compliance.arn
}