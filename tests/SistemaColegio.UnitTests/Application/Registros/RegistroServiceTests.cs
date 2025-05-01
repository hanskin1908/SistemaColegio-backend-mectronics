using NUnit.Framework;
using Moq;
using SistemaColegio.Application.Features.Registros;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.UnitTests.Application.Registros;

[TestFixture]
public class RegistroServiceTests : TestBase
{
    private Mock<IRegistroRepository> _registroRepositoryMock;
    private Mock<IEstudianteRepository> _estudianteRepositoryMock;
    private Mock<IMateriaRepository> _materiaRepositoryMock;
    private IRegistroService _registroService;

    [SetUp]
    public override void Setup()
    {
        base.Setup();
        _registroRepositoryMock = new Mock<IRegistroRepository>();
        _estudianteRepositoryMock = new Mock<IEstudianteRepository>();
        _materiaRepositoryMock = new Mock<IMateriaRepository>();
        _registroService = new RegistroService(
            _registroRepositoryMock.Object,
            _estudianteRepositoryMock.Object,
            _materiaRepositoryMock.Object);
    }

    [Test]
    public async Task RegistrarCalificacion_ConDatosValidos_DebeCrearRegistro()
    {
        // Arrange
        var registroDto = new RegistrarCalificacionDto
        {
            EstudianteId = 1,
            MateriaId = 1,
            Calificacion = 85.5m,
            FechaEvaluacion = DateTime.Now,
            TipoEvaluacion = "Examen Final"
        };

        var estudiante = new Estudiante { Id = 1, Nombres = "Juan", Apellidos = "Pérez" };
        var materia = new Materia { Id = 1, Nombre = "Matemáticas" };

        _estudianteRepositoryMock.Setup(x => x.ObtenerPorIdAsync(registroDto.EstudianteId))
            .ReturnsAsync(estudiante);
        _materiaRepositoryMock.Setup(x => x.ObtenerPorIdAsync(registroDto.MateriaId))
            .ReturnsAsync(materia);

        // Act
        var resultado = await _registroService.RegistrarCalificacionAsync(registroDto);

        // Assert
        Assert.That(resultado, Is.Not.Null);
        Assert.That(resultado.Calificacion, Is.EqualTo(registroDto.Calificacion));
        Assert.That(resultado.EstudianteId, Is.EqualTo(registroDto.EstudianteId));
    }

    [Test]
    public void RegistrarCalificacion_ConCalificacionInvalida_DebeLanzarExcepcion()
    {
        // Arrange
        var registroDto = new RegistrarCalificacionDto
        {
            EstudianteId = 1,
            MateriaId = 1,
            Calificacion = 105.0m, // Calificación mayor a 100
            FechaEvaluacion = DateTime.Now
        };

        // Act & Assert
        var ex = Assert.ThrowsAsync<ValidationException>(
            async () => await _registroService.RegistrarCalificacionAsync(registroDto)
        );
        Assert.That(ex.Message, Contains.Substring("calificación inválida"));
    }

    [Test]
    public async Task CalcularPromedio_DebeRetornarPromedioCorrecto()
    {
        // Arrange
        var estudianteId = 1;
        var materiaId = 1;
        var registros = new List<Registro>
        {
            new Registro { EstudianteId = estudianteId, MateriaId = materiaId, Calificacion = 80.0m },
            new Registro { EstudianteId = estudianteId, MateriaId = materiaId, Calificacion = 90.0m }
        };

        _registroRepositoryMock.Setup(x => x.ObtenerRegistrosEstudianteAsync(estudianteId, materiaId))
            .ReturnsAsync(registros);

        // Act
        var promedio = await _registroService.CalcularPromedioAsync(estudianteId, materiaId);

        // Assert
        Assert.That(promedio, Is.EqualTo(85.0m));
    }

    [Test]
    public async Task ObtenerBoletinEstudiante_DebeRetornarReporteCompleto()
    {
        // Arrange
        var estudianteId = 1;
        var registros = new List<Registro>
        {
            new Registro { 
                EstudianteId = estudianteId, 
                MateriaId = 1, 
                Calificacion = 85.0m, 
                TipoEvaluacion = "Parcial",
                FechaEvaluacion = DateTime.Now.AddDays(-30)
            },
            new Registro { 
                EstudianteId = estudianteId, 
                MateriaId = 1, 
                Calificacion = 90.0m,
                TipoEvaluacion = "Final",
                FechaEvaluacion = DateTime.Now
            }
        };

        _registroRepositoryMock.Setup(x => x.ObtenerRegistrosEstudianteAsync(estudianteId))
            .ReturnsAsync(registros);

        // Act
        var boletin = await _registroService.ObtenerBoletinEstudianteAsync(estudianteId);

        // Assert
        Assert.That(boletin, Is.Not.Null);
        Assert.That(boletin.Registros, Has.Count.EqualTo(2));
        Assert.That(boletin.PromedioGeneral, Is.EqualTo(87.5m));
    }

    [Test]
    public async Task RegistrarCalificacionesMasivas_DebeProcesarTodosLosRegistros()
    {
        // Arrange
        var registrosMasivosDto = new RegistroCalificacionesMasivasDto
        {
            MateriaId = 1,
            TipoEvaluacion = "Examen Final",
            FechaEvaluacion = DateTime.Now,
            Calificaciones = new List<CalificacionEstudianteDto>
            {
                new() { EstudianteId = 1, Calificacion = 85.0m },
                new() { EstudianteId = 2, Calificacion = 90.0m },
                new() { EstudianteId = 3, Calificacion = 75.0m }
            }
        };

        // Act
        var resultados = await _registroService.RegistrarCalificacionesMasivasAsync(registrosMasivosDto);

        // Assert
        Assert.That(resultados, Has.Count.EqualTo(3));
        Assert.That(resultados.Average(r => r.Calificacion), Is.EqualTo(83.33m).Within(0.01m));
    }
}