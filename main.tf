terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    iam = "http://localhost:4566"
  }
}
resource "aws_iam_group" "administracion_finanzas" {
  name = "Administracion-Finanzas"
}
resource "aws_iam_group" "ventas" {
  name = "Ventas"
}
resource "aws_iam_group" "atencion_cliente" {
  name = "Atencion-Cliente"
}
resource "aws_iam_group" "soporte_it" {
  name = "Soporte-IT"
}
resource "aws_iam_group" "auditoria_compliance" {
  name = "Auditoria-Compliance"
}
