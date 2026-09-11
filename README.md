# IAM Access Control with Terraform

Control de acceso IAM para una aseguradora ficticia, definido como Infrastructure as Code con Terraform y validado en un laboratorio local (Floci).

**Documentación completa:** [documentation/IAM-Access-Control-Documentacion.md](documentation/IAM-Access-Control-Documentacion.md)

## Highlights

- 5 departamentos, 5 grupos IAM, 5 políticas y 10 usuarios de ejemplo
- Separación de permisos por recurso (buckets S3 de negocio, soporte EC2/monitorización y auditoría)
- 35 recursos Terraform desplegados de forma reproducible
- Evidencias de `plan` / `apply` y validación con AWS CLI contra emulador local

## Stack

Terraform · AWS IAM · AWS CLI · Docker · Floci · JSON

## Modelo de acceso

```text
Usuario IAM  ->  Grupo IAM  ->  Política IAM  ->  Acciones permitidas
```

Este laboratorio se centra en **users, groups y policies**. No provisiona IAM Roles.

## Estructura

```text
main.tf            Provider local + grupos
policies.tf        Políticas aplicadas por Terraform
attachments.tf     Asociación grupo-política
users.tf           Usuarios
memberships.tf     Membresías
policies/          JSON de referencia por departamento
diagrams/          Diagramas
screenshots/       Evidencias del despliegue
validation/        Evidencias de comprobación
documentation/     Documentación técnica completa
```

## Quick start (laboratorio local)

```bash
terraform init
terraform plan
terraform apply
```

Requisito: emulador IAM disponible en `http://localhost:4566` (Floci).

## Lectura recomendada

1. Abre la [documentación completa](documentation/IAM-Access-Control-Documentacion.md)
2. Revisa la matriz departamento / grupo / policy / usuarios
3. Sigue las capturas de `screenshots/` y `validation/`
