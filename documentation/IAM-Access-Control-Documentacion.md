# Documentación técnica — IAM Access Control with Terraform

## 1. Introducción

Este proyecto implementa un sistema de **Identity and Access Management (IAM)** para una empresa ficticia del sector asegurador. El objetivo es demostrar, con Infrastructure as Code, cómo organizar identidades y permisos por departamento aplicando el principio de mínimo privilegio.

### Componentes del proyecto

- **AWS IAM**: usuarios, grupos y políticas
- **Terraform**: definición y despliegue de la infraestructura IAM
- **AWS CLI**: comprobaciones y evidencias
- **Floci + Docker**: emulador local de AWS para practicar sin coste de cuenta
- **JSON**: políticas de referencia en `policies/`

### Dónde está cada cosa

| Contenido | Ubicación |
| --- | --- |
| Código Terraform | `main.tf`, `policies.tf`, `attachments.tf`, `users.tf`, `memberships.tf` |
| Políticas JSON (referencia) | `policies/` |
| Diagramas | `diagrams/` |
| Capturas del despliegue | `screenshots/` |
| Capturas de validación | `validation/` |
| README del repositorio | `README.md` |

---

## 2. Descripción del problema

En una organización con varios departamentos, usar permisos amplios o idénticos para todos los usuarios aumenta el riesgo de acceso indebido a datos sensibles (facturación, clientes, ventas), dificulta la auditoría y rompe el principio de mínimo privilegio.

**Problema del laboratorio:** diseñar e implementar una estructura IAM en la que cada departamento solo pueda realizar las acciones necesarias sobre los recursos que le corresponden, gestionada con Terraform y comprobable en un entorno local.

---

## 3. Casos de uso

Formato: **Rol / Acción / Resultado esperado**.

### UC-01 — Datos financieros

| Campo | Detalle |
| --- | --- |
| Rol | Usuario de Administración y Finanzas (`Carlos` o `Roberto`) |
| Acción | Listar y leer/escribir objetos en el bucket financiero |
| Resultado esperado | Acceso permitido sobre `insurance-finance-data`. Sin acceso a buckets de otros departamentos |

### UC-02 — Datos de ventas

| Campo | Detalle |
| --- | --- |
| Rol | Usuario de Ventas (`Leandro` o `Beth`) |
| Acción | Gestionar objetos del bucket de ventas |
| Resultado esperado | Acceso permitido sobre `insurance-sales-data` |

### UC-03 — Datos de clientes

| Campo | Detalle |
| --- | --- |
| Rol | Usuario de Atención al Cliente (`Petra` o `Anastasia`) |
| Acción | Gestionar objetos del bucket de clientes |
| Resultado esperado | Acceso permitido sobre `insurance-customer-data` |

### UC-04 — Soporte de infraestructura

| Campo | Detalle |
| --- | --- |
| Rol | Usuario de Soporte IT (`Javier` o `Luis`) |
| Acción | Consultar instancias EC2, arrancar/parar instancias y revisar métricas/logs |
| Resultado esperado | Acciones EC2/CloudWatch/Logs según su política. Sin permisos S3 de negocio en esa policy |

### UC-05 — Auditoría y cumplimiento

| Campo | Detalle |
| --- | --- |
| Rol | Usuario de Auditoría (`Marcos` o `Mercedes`) |
| Acción | Consultar configuración IAM, CloudTrail, EC2, CloudWatch y S3 en modo lectura |
| Resultado esperado | Acceso de lectura según `Auditoria-Compliance-Policy` |

---

## 4. Solución

### 4.1 Modelo implementado

```text
Usuario  ->  pertenece a  ->  Grupo  ->  tiene attached  ->  Política
```

| Concepto | Implementado | Archivo |
| --- | --- | --- |
| Groups | Sí | `main.tf` |
| Policies | Sí | `policies.tf` |
| Attachments | Sí | `attachments.tf` |
| Users | Sí | `users.tf` |
| Memberships | Sí | `memberships.tf` |
| Roles (`aws_iam_role`) | No | — |

El laboratorio se centra en el patrón clásico **users + groups + policies**. Existe un diagrama histórico cuyo nombre menciona "Roles"; la implementación real del código son grupos y políticas.

### 4.2 Matriz departamento / código / usuarios / permisos

| Departamento | Grupo IAM | Policy (`policies.tf`) | JSON (`policies/`) | Usuarios | Recurso | Acciones |
| --- | --- | --- | --- | --- | --- | --- |
| Administración y Finanzas | `Administracion-Finanzas` | `Administracion-Finanzas-Policy` | `administration-finance-policy.json` | Carlos, Roberto | `insurance-finance-data` | `s3:ListBucket`, `s3:GetObject`, `s3:PutObject` |
| Ventas | `Ventas` | `Ventas-Policy` | `sales-policy.json` | Leandro, Beth | `insurance-sales-data` | mismo patrón S3 |
| Atención al Cliente | `Atencion-Cliente` | `Atencion-Cliente-Policy` | `customer-service-policy.json` | Petra, Anastasia | `insurance-customer-data` | mismo patrón S3 |
| Soporte IT | `Soporte-IT` | `Soporte-IT-Policy` | `it-service-policy.json` | Javier, Luis | EC2 / CloudWatch / Logs | Describe, Start, Stop + métricas/logs |
| Auditoría y Compliance | `Auditoria-Compliance` | `Auditoria-Compliance-Policy` | `audit-compliance-policy.json` | Marcos, Mercedes | amplio (`*`) | Get/List IAM, CloudTrail, Describe EC2, lectura S3/CloudWatch |

**Ejemplo narrado**

El departamento **Administración y Finanzas** se modela con el grupo `Administracion-Finanzas`. Su política está en `policies.tf` (`Administracion-Finanzas-Policy`) y también como JSON en `policies/administration-finance-policy.json`. Los usuarios de ejemplo son **Carlos** y **Roberto** (`memberships.tf`). Con `ListBucket` + `GetObject` + `PutObject` se les otorga acceso al bucket de facturación `insurance-finance-data`, sin `DeleteObject`.

### 4.3 Notas de diseño

- Terraform aplica el contenido de `policies.tf` (`jsonencode`). Los JSON de `policies/` sirven como referencia legible.
- Los buckets S3 se referencian en las policies; no se crean como recursos Terraform en este repositorio.
- El provider apunta al emulador local (`http://localhost:4566`) con credenciales de laboratorio.

---

## 5. Arquitectura

### 5.1 Diagrama de control de acceso

![Diagrama de arquitectura de control de acceso IAM](../diagrams/IAM%20Access%20Control%20Architecture%20Diagram.png)

### 5.2 Diagrama histórico (nombre "Roles")

![Diagrama histórico de acceso IAM](../diagrams/Diagrama_Roles_IAM.png)

Este diagrama ayuda a explicar la visión por departamentos. En código, el acceso se materializa con **grupos y policies**, no con `aws_iam_role`.

### 5.3 Flujo de autorización

```mermaid
sequenceDiagram
    participant U as Usuario IAM
    participant G as Grupo IAM
    participant P as Policy IAM
    participant R as Recurso AWS

    U->>G: membership (memberships.tf)
    G->>P: attachment (attachments.tf)
    U->>R: API call (AWS CLI)
    P-->>R: Allow o Deny segun acciones y recursos
```

---

## 6. Implementación (paso a paso con evidencias)

### Paso 1 — Provider Terraform (entorno local)

Archivo: `main.tf`

Configura región, endpoint IAM local y flags necesarios para el emulador.

![Configuración del proveedor Terraform](../screenshots/01-configuracion-proveedor-terraform.png)

### Paso 2 — Grupos IAM

Archivo: `main.tf`

Se crean los cinco grupos de departamento.

![Creación de grupos IAM](../screenshots/02-creacion-grupos-iam.jpg)

![Terraform plan de grupos](../screenshots/03-terraform-plan-grupos-iam.png)

![Terraform apply de grupos](../screenshots/04-terraform-apply-grupos-iam.png)

![Comprobación de grupos en Floci](../screenshots/05-comprobacion-grupos-floci.png)

### Paso 3 — Políticas IAM

Archivo aplicado: `policies.tf`  
Referencia JSON: carpeta `policies/`

![Política Administración y Finanzas](../screenshots/06-politica-administracion-finanzas.png)

![Política Auditoría y Compliance](../screenshots/07-politica-auditoria-compliance.png)

![Política Atención al Cliente](../screenshots/08-politica-atencion-cliente.png)

![Política Soporte IT](../screenshots/09-politica-soporte-it.png)

![Política Ventas](../screenshots/10-politica-ventas.png)

### Paso 4 — Attachments grupo-política

Archivo: `attachments.tf`

![Asociación de políticas a grupos](../screenshots/11-asociacion-politicas-grupos-iam.png)

![Terraform plan de políticas](../screenshots/12-terraform-plan-politicas-iam.png)

![Terraform apply de políticas](../screenshots/13-terraform-apply-politicas-iam.png)

### Paso 5 — Usuarios y memberships

Archivos: `users.tf`, `memberships.tf`

![Usuarios IAM](../screenshots/14-usuarios-iam-terraform.png)

![Asignación de usuarios a grupos](../screenshots/15-asignacion-usuarios-grupos-iam.png)

![Terraform plan de usuarios](../screenshots/16-terraform-plan-usuarios-iam.png)

![Terraform apply de usuarios](../screenshots/17-terraform-apply-usuarios-iam.png)

### Resultado

El despliegue contempla **35 recursos**: 5 groups + 5 policies + 5 attachments + 10 users + 10 memberships.

---

## 7. Validación

### Inventario

![Validación de grupos](../validation/groups-validation.png)

![Validación de policies](../validation/policies-validation.png)

![Validación de usuarios](../validation/users-validation.png)

![Detalle policy de finanzas](../validation/finance-policy.png)

### Identidad y membresías de ejemplo

![Grupos del usuario Javier](../validation/user-groups-javier.png)

![Grupos del usuario Mercedes](../validation/user-groups-mercedes.png)

![Identidad de Javier](../validation/javier-authentication.png)

### Prueba de acceso S3 (Javier)

![Prueba S3 con Javier](../validation/javier-s3-permission-test.png)

Javier pertenece a `Soporte-IT`, cuya policy no concede S3 sobre el bucket financiero. En AWS real, esa operación debería denegarse. En emuladores locales la evaluación IAM puede diferir; por eso esta evidencia se interpreta junto con los límites del laboratorio y se complementa mejor con pruebas Allow/Deny explícitas en AWS real.

---

## 8. Limitaciones del laboratorio

- Entorno local (Floci) en lugar de cuenta AWS de producción
- Sin provisionar buckets S3 dentro del mismo código Terraform
- Sin IAM Roles, MFA ni password policy (fuera del alcance actual)
- Reproducibilidad del emulador mejorable (añadir compose/scripts en una iteración futura)

Estas limitaciones no invalidan el aprendizaje: el proyecto demuestra el modelado IAM y su automatización con Terraform.

---

## 9. Conclusiones

Este proyecto permite demostrar el modelado de identidades y permisos IAM con Terraform en un escenario de varios departamentos:

- separación de acceso por grupos y políticas
- mínimo privilegio aplicado a buckets S3 de negocio
- automatización reproducible con Terraform (`for_each`, locals, attachments)
- evidencias de `plan` / `apply` y validación con AWS CLI en entorno local

El laboratorio utiliza un emulador local (Floci) para evitar costes de cuenta. La documentación deja claro el alcance real: users, groups y policies (sin IAM Roles), y las limitaciones propias de un entorno de pruebas frente a AWS real.
