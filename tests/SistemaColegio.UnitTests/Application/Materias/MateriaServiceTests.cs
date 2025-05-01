using NUnit.Framework;
using Moq;
using SistemaColegio.Application.Features.Materias;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;
using SistemaColegio.Application.Features.Materias.Services;
using SistemaColegio.Application.Features.Materias.Interfaces;

namespace SistemaColegio.UnitTests.Application.Materias;

[TestFixture]
public class MateriaServiceTests : TestBase
{
    private Mock<IMateriaRepositorio> _materiaRepositoryMock;
    private Mock<IProfesorRepositorio> _profesorRepositoryMock;
    private IMateriaService _materiaService;

    [SetUp]
    public override void Setup()
    {
        base.Setup();
        _materiaRepositoryMock = new Mock<IMateriaRepositorio>();
        _profesorRepositoryMock = new Mock<IProfesorRepositorio>();
        _materiaService = new MateriaService(
            _materiaRepositoryMock.Object,
            _profesorRepositoryMock.Object);
    }

    [Test]
    public async Task ObtenerMateria_ConIdValido_DebeRetornarMateria()
    {
        // Arrange
        var materiaId = 1;
        var materiaEsperada = new Materia
        {
            Id = materiaId,
            Nombre = "Matemáticas",
            Descripcion = "Curso de Matemáticas Avanzadas",
            ProfesorId = 1
        };

        _materiaRepositoryMock.Setup(x => x.ObtenerPorIdAsync(materiaId))
            .ReturnsAsync(materiaEsperada);

        // Act
        var resultado = await _materiaService.ObtenerMateriaPorIdAsync(materiaId);

        // Assert
        Assert.That(resultado, Is.Not.Null);
        Assert.That(resultado.Id, Is.EqualTo(materiaId));
        Assert.That(resultado.Nombre, Is.EqualTo("Matemáticas"));
    }

    [Test]
    public async Task AsignarProfesor_ConDatosValidos_DebeActualizarMateria()
    {
        // Arrange
        var materiaId = 1;
        var profesorId = 2;
        
        var materia = new Materia
        {
            Id = materiaId,
            Nombre = "Matemáticas",
            ProfesorId = null
        };

        var profesor = new Profesor
        {
            Id = profesorId,
            Nombres = "Juan",
            Apellidos = "Pérez"
        };

        _materiaRepositoryMock.Setup(x => x.ObtenerPorIdAsync(materiaId))
            .ReturnsAsync(materia);
        
        _profesorRepositoryMock.Setup(x => x.ObtenerPorIdAsync(profesorId))
            .ReturnsAsync(profesor);

        _materiaRepositoryMock.Setup(x => x.ActualizarAsync(It.IsAny<Materia>()))
            .ReturnsAsync(new Materia 
            { 
                Id = materiaId, 
                Nombre = "Matemáticas", 
                ProfesorId = profesorId 
            });

        // Act
        var resultado = await _materiaService.AsignarProfesorAsync(materiaId, profesorId);

        // Assert
        Assert.That(resultado, Is.Not.Null);
        Assert.That(resultado.ProfesorId, Is.EqualTo(profesorId));
    }

    [Test]
    public void AsignarProfesor_ConProfesorInvalido_DebeLanzarExcepcion()
    {
        // Arrange
        var materiaId = 1;
        var profesorIdInvalido = 999;

        var materia = new Materia
        {
            Id = materiaId,
            Nombre = "Matemáticas",
            ProfesorId = null
        };

        _materiaRepositoryMock.Setup(x => x.ObtenerPorIdAsync(materiaId))
            .ReturnsAsync(materia);
        
        _profesorRepositoryMock.Setup(x => x.ObtenerPorIdAsync(profesorIdInvalido))
            .ReturnsAsync((Profesor)null);

        // Act & Assert
        var ex = Assert.ThrowsAsync<NotFoundException>(
            async () => await _materiaService.AsignarProfesorAsync(materiaId, profesorIdInvalido)
        );
        
        Assert.That(ex.Message, Is.EqualTo("Profesor no encontrado"));
    }

    [Test]
    public async Task CrearMateria_ConDatosValidos_DebeCrearMateria()
    {
        // Arrange
        var materiaDto = new CrearMateriaDto
        {
            Nombre = "Física",
            Descripcion = "Física Básica",
            CodigoMateria = "FIS101"
        };

        var materiaCreada = new Materia
        {
            Id = 1,
            Nombre = materiaDto.Nombre,
            Descripcion = materiaDto.Descripcion,
            CodigoMateria = materiaDto.CodigoMateria
        };

        _materiaRepositoryMock.Setup(x => x.CrearAsync(It.IsAny<Materia>()))
            .ReturnsAsync(materiaCreada);

        // Act
        var resultado = await _materiaService.CrearMateriaAsync(materiaDto);

        // Assert
        Assert.That(resultado, Is.Not.Null);
        Assert.That(resultado.Nombre, Is.EqualTo(materiaDto.Nombre));
        Assert.That(resultado.CodigoMateria, Is.EqualTo(materiaDto.CodigoMateria));
    }
}