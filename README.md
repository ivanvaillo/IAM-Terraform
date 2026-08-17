\# IAM Access Control with Terraform



Proyecto de implementación de un sistema de \*\*Identity and Access Management (IAM)\*\* para una empresa ficticia del sector asegurador, utilizando \*\*Terraform\*\* como Infrastructure as Code.



\## Objetivo



Diseñar una estructura de control de acceso basada en \*\*usuarios, grupos y políticas IAM\*\*, aplicando el principio de mínimo privilegio.



\## Tecnologías



\* AWS IAM

\* Terraform

\* AWS CLI

\* Docker

\* Floci

\* JSON



\## Implementación



Terraform se utiliza para definir y gestionar los recursos IAM y sus relaciones.



Las políticas de acceso se han definido mediante archivos JSON independientes.



El proyecto se ha probado en un entorno local mediante \*\*Floci y Docker\*\*, utilizando un emulador de servicios AWS para realizar las pruebas de forma local.



\## Validación



La infraestructura se ha inicializado, planificado y desplegado mediante Terraform.



```bash

terraform init

terraform plan

terraform apply

```



El plan final mostró \*\*35 recursos a crear\*\*, y la configuración fue aplicada correctamente.



\## Estructura



```text

IAM-Terraform/

├── policies/

├── validation/

├── documentation/

├── screenshots/

├── diagrams/

├── attachments.tf

├── main.tf

├── memberships.tf

├── policies.tf

├── users.tf

└── README.md

```



\## Evidencias



El repositorio incluye capturas de la implementación y validación, además de los diagramas y la documentación técnica del proyecto.





