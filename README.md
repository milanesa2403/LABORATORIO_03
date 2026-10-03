# Infraestructura Multi-ambiente (DEV y QA) con Terraform y Docker Hub

Este proyecto despliega la arquitectura basada en contenedores utilizando imágenes oficiales obtenidas directamente desde **Docker Hub** (`nginx:alpine`, `node:18-alpine`, `postgres:15-alpine`), organizadas en los ambientes de **DEV** y **QA** con sus respectivos mapeos de puertos.

## Prerrequisitos

Asegúrate de tener instalado en tu entorno local:
- [Docker](https://www.docker.com/) (activo y funcionando).
- [Terraform](https://www.terraform.io/) (versión 1.0 o superior).

---

## Instrucciones de Instalación y Despliegue

Sigue estos pasos desde el momento en que descargas o clonas el proyecto:

1. **Abrir la terminal y navegar a la carpeta de Terraform:**
   ```bash
   cd terraform
   ```

2. **Inicializar Terraform:**
   Descarga los proveedores necesarios (como el proveedor de Docker) definidos en la configuración.
   ```bash
   terraform init
   ```

3. **Aplicar la configuración y desplegar los ambientes:**
   Ejecuta el comando de despliegue y confirma con `yes` cuando se te solicite en la terminal.
   ```bash
   terraform apply
   ```

---

## Verificación del Despliegue

Puedes verificar que los contenedores de ambos ambientes se estén ejecutando correctamente en tu entorno local ejecutando:
```bash
docker ps
```

---

## Endpoints de la Arquitectura

- **DEV:**
  - Frontend: `http://localhost:4001`
  - Backend: `http://localhost:4002`
  - Database: `localhost:4003`

- **QA:**
  - Frontend: `http://localhost:5001`
  - Backend: `http://localhost:5002`
  - Database: `http://localhost:5003`

---

## Limpieza de Recursos

Si deseas detener y eliminar todos los contenedores, redes y volúmenes creados por Terraform, ejecuta:
```bash
terraform destroy
```
*(Confirma la acción escribiendo `yes`)*