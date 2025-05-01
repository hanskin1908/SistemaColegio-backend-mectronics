using NUnit.Framework;
using Moq;
using SistemaColegio.Application.Features.Estudiantes;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.UnitTests.Application.Estudiantes;

[TestFixture]
public class EstudianteServiceTests : TestBase
{
    private Mock<IEstudianteRepository> _estudianteRepositoryMock;
    private IEstudianteService _estudianteService;

    [SetUp]
    public override void Setup()
    {
        base.Setup();
        _estudianteRepositoryMock = new Mock<IEstudianteRepository>();
        _estudianteService = new EstudianteService(_estudianteRepositoryMock.Object);
    }

    [Test]
    public async Task ObtenerEstudiante_ConIdValido_DebeRetornarEstudiante()
    {
        // Arrange
        var estudianteId = 1;
        var estudianteEsperado = new Estudiante
        {
            Id = estudianteId,
            Nombres = "Juan",
            Apellidos = "Pérez",
            Email = "juan.perez@ejemplo.com",
            DNI = "12345678"
        };

        _estudianteRepositoryMock.Setup(x => x.ObtenerPorIdAsync(estudianteId))
            .ReturnsAsync(estudianteEsperado);

        // Act
        var resultado = await _estudianteService.ObtenerEstudiantePorIdAsync(estudianteId);

        // Assert
        Assert.That(resultado, Is.Not.Null);
        Assert.That(resultado.Id, Is.EqualTo(estudianteId));
        Assert.That(resultado.Nombres, Is.EqualTo("Juan"));
        Assert.That(resultado.Apellidos, Is.EqualTo("Pérez"));
    }

    [Test]
    public async Task CrearEstudiante_ConDatosValidos_DebeRetornarEstudianteCreado()
    {
        // Arrange
        var estudianteDto = new CrearEstudianteDto
        {
            Nombres = "María",
            Apellidos = "García",
            Email = "maria.garcia@ejemplo.com",
            DNI = "87654321",
            FechaNacimiento = DateTime.Parse("2005-05-15")
        };

        var estudianteCreado = new Estudiante
        {
            Id = 1,
            Nombres = estudianteDto.Nombres,
            Apellidos = estudianteDto.Apellidos,
            Email = estudianteDto.Email,
            DNI = estudianteDto.DNI,
            FechaNacimiento = estudianteDto.FechaNacimiento
        };

        _estudianteRepositoryMock.Setup(x => x.CrearAsync(It.IsAny<Estudiante>()))
            .ReturnsAsync(estudianteCreado);

        // Act
        var resultado = await _estudianteService.CrearEstudianteAsync(estudianteDto);

        // Assert
        Assert.That(resultado, Is.Not.Null);
        Assert.That(resultado.Nombres, Is.EqualTo(estudianteDto.Nombres));
        Assert.That(resultado.Apellidos, Is.EqualTo(estudianteDto.Apellidos));
        Assert.That(resultado.Email, Is.EqualTo(estudianteDto.Email));
    }

    [Test]
    public void CrearEstudiante_ConEmailInvalido_DebeLanzarExcepcion()
    {
        // Arrange
        var estudianteDto = new CrearEstudianteDto
        {
            Nombres = "María",
            Apellidos = "García",
            Email = "email-invalido",
            DNI = "87654321"
        };

        // Act & Assert
        var ex = Assert.ThrowsAsync<ValidationException>(
            async () => await _estudianteService.CrearEstudianteAsync(estudianteDto)
        );
        
        Assert.That(ex.Message, Contains.Substring("formato de email inválido"));
    }

    [Test]
    public async Task ActualizarEstudiante_ConDatosValidos_DebeActualizarEstudiante()
    {
        // Arrange
        var estudianteId = 1;
        var estudianteDto = new ActualizarEstudianteDto
        {
            Id = estudianteId,
            Nombres = "María",
            Apellidos = "García Modificado",
            Email = "maria.garcia.mod@ejemplo.com"
        };

        var estudianteExistente = new Estudiante
        {
            Id = estudianteId,
            Nombres = "María",
            Apellidos = "García",
            Email = "maria.garcia@ejemplo.com"
        };

        _estudianteRepositoryMock.Setup(x => x.ObtenerPorIdAsync(estudianteId))
            .ReturnsAsync(estudianteExistente);

        _estudianteRepositoryMock.Setup(x => x.ActualizarAsync(It.IsAny<Estudiante>()))
            .ReturnsAsync(new Estudiante
            {
                Id = estudianteId,
                Nombres = estudianteDto.Nombres,
                Apellidos = estudianteDto.Apellidos,
                Email = estudianteDto.Email
            });

        // Act
        var resultado = await _estudianteService.ActualizarEstudianteAsync(estudianteDto);

        // Assert
        Assert.That(resultado, Is.Not.Null);
        Assert.That(resultado.Apellidos, Is.EqualTo(estudianteDto.Apellidos));
        Assert.That(resultado.Email, Is.EqualTo(estudianteDto.Email));
    }
}