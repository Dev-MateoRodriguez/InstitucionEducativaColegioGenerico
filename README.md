# Prueba Técnica - API REST .NET + PostgreSQL

Este proyecto es una **prueba técnica** que implementa una API REST usando **.NET 6/7/8**, **Entity Framework Core**, **PostgreSQL**, **Swagger** y autenticación **JWT**.  
El objetivo es exponer las operaciones **CRUD** (Create, Read, Update, Delete) para la tabla de **Estudiantes** de una base de datos relacional que contiene:

- **Estudiantes**
- **Cursos**
- **Calificaciones**
- **Profesores**

---

## 📦 Entregables

El proyecto incluye los siguientes entregables:

1. **Base de datos relacional** con las tablas: `Estudiantes`, `Cursos`, `Calificaciones`, `Profesores`.
2. **Migraciones** de Entity Framework para crear la base de datos de forma automática.
3. **Seeds de datos iniciales** para popular las tablas con información de ejemplo.
4. **API REST** que expone la tabla de `Estudiantes` con todos los procesos CRUD:
   - **GET** – Obtener estudiantes (por ID o todos los estudiantes)
   - **POST** – Crear nuevo estudiante
   - **PUT** – Actualizar datos de un estudiante
   - **DELETE** – Eliminar estudiante
5. **Swagger UI** para documentación y pruebas de la API.
6. **Autenticación JWT** para proteger los endpoints.
7. (Opcional) **Paginación** en el endpoint GET para devolver resultados en bloques de 10 en 10.

---

## 🛠 Requerimientos Previos

- [.NET 6/7/8 SDK](https://dotnet.microsoft.com/en-us/download)
- [PostgreSQL](https://www.postgresql.org/download/)
- [Visual Studio Code](https://code.visualstudio.com/) o IDE de tu preferencia
- [Postman](https://www.postman.com/) para probar la API

## Dependencias
### Entity Framework Core para PostgreSQL
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL

### Entity Framework Tools (para migraciones)
dotnet add package Microsoft.EntityFrameworkCore.Tools

### Paquete de Swagger
dotnet add package Swashbuckle.AspNetCore

### JWT package
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer
