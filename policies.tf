resource "aws_iam_policy" "administracion_finanzas" {
  name        = "Administracion-Finanzas-Policy"
  description = "Permite gestionar objetos del bucket financiero"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowFinancialDataAccess"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "arn:aws:s3:::insurance-finance-data/*"
      },
      {
        Sid    = "AllowFinancialBucketListing"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::insurance-finance-data"
      }
    ]
  })
}
resource "aws_iam_policy" "auditoria_compliance" {
  name        = "Auditoria-Compliance-Policy"
  description = "Acceso de solo lectura para auditoría y cumplimiento"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowSecurityAuditReadOnlyAccess"
        Effect = "Allow"

        Action = [
          "iam:Get*",
          "iam:List*",
          "iam:GenerateCredentialReport",
          "cloudtrail:DescribeTrails",
          "cloudtrail:GetTrailStatus",
          "cloudtrail:LookupEvents",
          "ec2:Describe*",
          "s3:GetBucketLocation",
          "s3:GetBucketPolicy",
          "s3:GetBucketVersioning",
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:GetObject",
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*"
        ]

        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_policy" "atencion_cliente" {
  name        = "Atencion-Cliente-Policy"
  description = "Permite gestionar objetos del bucket de datos de clientes"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowCustomerServiceDataAccess"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "arn:aws:s3:::insurance-customer-data/*"
      },
      {
        Sid    = "AllowCustomerServiceBucketListing"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::insurance-customer-data"
      }
    ]
  })
}
resource "aws_iam_policy" "soporte_it" {
  name        = "Soporte-IT-Policy"
  description = "Permite gestionar instancias EC2 y consultar la monitorización"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowEC2Management"
        Effect = "Allow"

        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVolumes",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]

        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchMonitoring"
        Effect = "Allow"

        Action = [
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents"
        ]

        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_policy" "ventas" {
  name        = "Ventas-Policy"
  description = "Permite gestionar objetos del bucket de datos de ventas"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowSalesDataAccess"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "arn:aws:s3:::insurance-sales-data/*"
      },
      {
        Sid    = "AllowSalesBucketListing"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::insurance-sales-data"
      }
    ]
  })
}