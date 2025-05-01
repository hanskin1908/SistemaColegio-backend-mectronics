# Database Migrations

## Problema con las migraciones de Entity Framework Core

Si estu00e1s experimentando el error "Unable to create an object of type 'SistemaColegioDbContext'" o "Unable to retrieve project metadata", hay varias soluciones posibles:

### Soluciu00f3n 1: Usar el script SQL directamente

La forma mu00e1s sencilla de resolver este problema es usar el script SQL directamente. Puedes encontrar el script en la carpeta `Scripts`:

```
Scripts/InitialMigration.sql
```

Este script crearu00e1 todas las tablas necesarias para la aplicaciu00f3n.

### Soluciu00f3n 2: Ejecutar los comandos de Entity Framework Core desde el directorio correcto

Si prefieres usar Entity Framework Core, asegu00farate de ejecutar los comandos desde el directorio rau00edz del proyecto (donde se encuentra el archivo .sln) y especificar explu00edcitamente las rutas de los proyectos:

```bash
dotnet ef migrations add InitialMigration --project src/SistemaColegio.Infrastructure --startup-project src/SistemaColegio.API
```

O si quieres eliminar la u00faltima migraciu00f3n:

```bash
dotnet ef migrations remove --project src/SistemaColegio.Infrastructure --startup-project src/SistemaColegio.API
```

### Soluciu00f3n 3: Usar la herramienta DbTools

Hemos creado una herramienta simple para generar el script SQL directamente desde el modelo. Para usarla, ejecuta:

```bash
dotnet run --project src/SistemaColegio.DbTools
```

Esto generaru00e1 un archivo `database_script.sql` en el directorio actual que puedes ejecutar en tu base de datos.

## Problema con la columna LastLogin

Si estu00e1s experimentando el error "Invalid column name 'LastLogin'", significa que la columna `LastLogin` no existe en la tabla `Users` de tu base de datos. Hay dos soluciones posibles:

### Soluciu00f3n 1: Agregar la columna a la base de datos

Ejecuta el siguiente script SQL para agregar la columna a la tabla `Users`:

```sql
ALTER TABLE [Users] ADD [LastLogin] DATETIME2 NULL;
```

Puedes encontrar este script en `Scripts/AddLastLoginColumn.sql`.

### Soluciu00f3n 2: Modificar el cu00f3digo para no utilizar esta propiedad

Si prefieres no modificar la base de datos, puedes modificar el cu00f3digo en `AuthService.cs` para no utilizar la propiedad `LastLogin`.

## Detalles de las tablas

### Profesores
- Id (PK)
- Name
- Email
- Specialty

### Estudiantes
- Id (PK)
- Name
- Email
- StudentId

### Materias
- Id (PK)
- Name
- Code
- Credits
- ProfessorId (FK)

### Registros
- Id (PK)
- EstudianteId (FK)
- MateriaId (FK)
- FechaRegistro

### Users
- Id (PK)
- Email
- PasswordHash
- Role
- CreatedAt
- LastLogin
- StudentId (FK)
- ProfessorId (FK)

## Notas importantes

- La tabla Users tiene una relaciu00f3n uno a uno con las tablas Estudiantes y Profesores
- El campo Role en la tabla Users puede tener los valores: 'student', 'professor' o 'admin'
- Al registrar un nuevo usuario, se debe proporcionar el ID apropiado (StudentId o ProfessorId) segu00fan el rol