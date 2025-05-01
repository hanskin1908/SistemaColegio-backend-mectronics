# Sistema Colegio - Backend V2

## Arquitectura

El backend del Sistema Colegio está desarrollado siguiendo una arquitectura de capas basada en los principios de Clean Architecture. La estructura del proyecto está organizada en las siguientes capas:

### 1. Capa de Dominio (SistemaColegio.Domain)

Contiene las entidades del negocio, interfaces y reglas de dominio. Esta capa es independiente de cualquier framework o tecnología externa.

- **Entidades**: Student, Professor, Subject, Registration, User
- **Interfaces**: Define contratos para repositorios y servicios
- **Excepciones**: Excepciones específicas del dominio

### 2. Capa de Aplicación (SistemaColegio.Application)

Contiene la lógica de negocio y orquesta el flujo de datos entre la capa de presentación y la capa de infraestructura.

- **Features**: Organizado por características (Auth, Estudiantes, Profesores, Materias, Registros)
- **DTOs**: Objetos de transferencia de datos
- **Servicios**: Implementación de la lógica de negocio
- **Interfaces**: Contratos para servicios
- **Mapeos**: Configuración de AutoMapper

### 3. Capa de Infraestructura (SistemaColegio.Infrastructure)

Contiene la implementación de interfaces definidas en las capas de dominio y aplicación. Gestiona el acceso a datos, servicios externos y otras preocupaciones técnicas.

- **Persistence**: Implementación de repositorios y contexto de base de datos
- **Identity**: Implementación de autenticación y autorización
- **Services**: Implementación de servicios externos

### 4. Capa de Presentación (SistemaColegio.API)

Expone la funcionalidad de la aplicación a través de una API REST. Gestiona las solicitudes HTTP y las respuestas.

- **Controllers**: Controladores de API
- **Middleware**: Middleware personalizado para manejo de excepciones
- **Configuración**: Configuración de la aplicación y servicios

## Patrones de Diseño

El proyecto implementa varios patrones de diseño para mejorar la mantenibilidad, escalabilidad y testabilidad del código:

### 1. Patrón Repositorio

Se utiliza para abstraer y encapsular el acceso a datos, proporcionando una interfaz común para interactuar con la base de datos.

**Ejemplo**: `RepositorioBase<T>` en `SistemaColegio.Infrastructure.Persistence`

```csharp
public class RepositorioBase<T> : IRepositorio<T> where T : BaseEntity
{
    protected readonly SistemaColegioDbContext _contexto;
    
    public RepositorioBase(SistemaColegioDbContext contexto)
    {
        _contexto = contexto;
    }
    
    public async Task<IReadOnlyList<T>> ObtenerTodosAsync()
    {
        return await _contexto.Set<T>().ToListAsync();
    }
    
    // Otros métodos...
}
```

### 2. Patrón Unit of Work

Se utiliza para gestionar transacciones y asegurar la consistencia de los datos al realizar múltiples operaciones en la base de datos.

**Ejemplo**: `UnidadTrabajo` en `SistemaColegio.Infrastructure.Persistence`

```csharp
public class UnidadTrabajo : IUnidadTrabajo
{
    private readonly SistemaColegioDbContext _contexto;
    private IEstudianteRepositorio _estudianteRepositorio;
    // Otros repositorios...
    
    public IEstudianteRepositorio Estudiantes => _estudianteRepositorio ??= new EstudianteRepositorio(_contexto);
    
    public async Task<int> CompletarAsync()
    {
        return await _contexto.SaveChangesAsync();
    }
    
    // Otros métodos...
}
```

### 3. Patrón Mediator (implícito)

Aunque no se implementa explícitamente con una biblioteca como MediatR, los servicios de aplicación actúan como mediadores entre los controladores y los repositorios.

**Ejemplo**: `EstudianteService` en `SistemaColegio.Application.Features.Estudiantes.Services`

### 4. Patrón Factory (implícito)

Se utiliza en la creación de repositorios a través del Unit of Work.

**Ejemplo**: Creación de repositorios en `UnidadTrabajo`

### 5. Patrón DTO (Data Transfer Object)

Se utiliza para transferir datos entre capas y evitar la exposición directa de entidades de dominio.

**Ejemplo**: `EstudianteDto`, `MateriaDto`, etc.

### 6. Patrón Decorator

Se utiliza implícitamente a través de filtros y middleware para añadir comportamiento a los controladores.

**Ejemplo**: `ExceptionMiddleware` para el manejo global de excepciones

## Principios SOLID

El proyecto sigue los principios SOLID para garantizar un diseño orientado a objetos robusto y mantenible:

### 1. Principio de Responsabilidad Única (SRP)

Cada clase tiene una única responsabilidad y razón para cambiar.

**Ejemplo**: Los servicios están divididos por características (EstudianteService, ProfesorService, etc.), cada uno con responsabilidades específicas.

### 2. Principio de Abierto/Cerrado (OCP)

Las entidades de software deben estar abiertas para extensión pero cerradas para modificación.

**Ejemplo**: `RepositorioBase<T>` permite extender la funcionalidad para tipos específicos sin modificar la clase base.

### 3. Principio de Sustitución de Liskov (LSP)

Los objetos de un programa deberían ser reemplazables por instancias de sus subtipos sin alterar el correcto funcionamiento del programa.

**Ejemplo**: Todas las implementaciones de repositorios pueden ser utilizadas a través de sus interfaces sin conocer la implementación concreta.

### 4. Principio de Segregación de Interfaces (ISP)

Los clientes no deberían verse forzados a depender de interfaces que no utilizan.

**Ejemplo**: Interfaces específicas como `IEstudianteRepositorio`, `IProfesorRepositorio` en lugar de una única interfaz genérica.

### 5. Principio de Inversión de Dependencias (DIP)

Los módulos de alto nivel no deben depender de módulos de bajo nivel. Ambos deben depender de abstracciones.

**Ejemplo**: Los servicios dependen de interfaces de repositorio (`IEstudianteRepositorio`) en lugar de implementaciones concretas.

## Prácticas de Clean Code

El proyecto sigue varias prácticas de Clean Code para mejorar la legibilidad y mantenibilidad:

### 1. Nombres Descriptivos

Los nombres de clases, métodos y variables son descriptivos y revelan la intención.

**Ejemplo**: `ObtenerEstudiantesPorMateriaIdAsync`, `ActualizarAsync`, etc.

### 2. Funciones Pequeñas y Enfocadas

Los métodos tienen una única responsabilidad y son relativamente cortos.

**Ejemplo**: Métodos en los servicios como `ObtenerPorIdAsync`, `CrearAsync`, etc.

### 3. Comentarios Significativos

Los comentarios explican el "por qué" en lugar del "qué" cuando es necesario.

### 4. Manejo de Errores Consistente

Se utiliza un enfoque consistente para el manejo de errores mediante el uso de respuestas tipadas.

**Ejemplo**: `RespuestaData<T>` para encapsular resultados y mensajes de error.

### 5. Evitar Duplicación (DRY)

Se evita la duplicación de código mediante el uso de clases base y métodos reutilizables.

**Ejemplo**: `RepositorioBase<T>` proporciona implementaciones comunes para todos los repositorios.

## Requisitos de Instalación

### Requisitos Previos

- .NET 6.0 SDK o superior
- SQL Server (local o en la nube)
- Visual Studio 2022 o Visual Studio Code

### Paquetes NuGet Requeridos

- Microsoft.EntityFrameworkCore (6.0.16)
- Microsoft.EntityFrameworkCore.SqlServer (6.0.16)
- Microsoft.EntityFrameworkCore.Tools (6.0.16)
- Microsoft.EntityFrameworkCore.Design (6.0.16)
- Microsoft.AspNetCore.Authentication.JwtBearer (6.0.36)
- AutoMapper (12.0.1)
- AutoMapper.Extensions.Microsoft.DependencyInjection (12.0.1)
- BCrypt.Net-Next (4.0.3)
- Swashbuckle.AspNetCore (6.5.0)

### Configuración

1. Clonar el repositorio
2. Configurar la cadena de conexión en `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=your_server;Database=SistemaColegio;Trusted_Connection=True;MultipleActiveResultSets=true"
  },
  "JwtSettings": {
    "Key": "your_secret_key_here_at_least_16_characters_long",
    "Issuer": "SistemaColegio",
    "Audience": "SistemaColegioUsers",
    "DurationInMinutes": 60
  }
}
```

### Migraciones de Base de Datos

Para crear y aplicar migraciones de base de datos, sigue estos pasos:

1. Abrir una terminal en la carpeta del proyecto API

2. Crear una nueva migración:

```bash
dotnet ef migrations add InitialCreate --project ../SistemaColegio.API/SistemaColegio.API.csproj
```

3. Aplicar la migración a la base de datos:

```bash
dotnet ef database update --project ../SistemaColegio.API/SistemaColegio.API.csproj
```

Alternativamente, puedes usar la consola del Administrador de paquetes en Visual Studio:

```powershell
Add-Migration InitialCreate
Update-Database
```

### Ejecución del Proyecto

1. Restaurar paquetes NuGet:

```bash
dotnet restore
```

2. Compilar el proyecto:

```bash
dotnet build
```

3. Ejecutar el proyecto:

```bash
dotnet run --project src/SistemaColegio.API/SistemaColegio.API.csproj
```

4. Acceder a Swagger UI para probar la API:

```
https://localhost:5001/swagger
```

## Características Principales

- Autenticación y autorización basada en JWT
- Gestión de estudiantes, profesores, materias y registros
- API RESTful con documentación Swagger
- Manejo de excepciones centralizado
- Validación de datos
- Operaciones CRUD para todas las entidades
- Relaciones entre entidades (estudiantes-materias, profesores-materias, etc.)