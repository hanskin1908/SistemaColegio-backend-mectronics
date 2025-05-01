using NUnit.Framework;
using Moq;
using SistemaColegio.Application.Features.Students;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.UnitTests.Application.Students;

[TestFixture]
public class StudentServiceTests : TestBase
{
    private Mock<IStudentRepository> _studentRepositoryMock;
    private IStudentService _studentService;

    [SetUp]
    public override void Setup()
    {
        base.Setup();
        _studentRepositoryMock = new Mock<IStudentRepository>();
        _studentService = new StudentService(_studentRepositoryMock.Object);
    }

    [Test]
    public async Task GetStudent_WithValidId_ShouldReturnStudent()
    {
        // Arrange
        var studentId = 1;
        var expectedStudent = new Student
        {
            Id = studentId,
            FirstName = "John",
            LastName = "Doe",
            Email = "john.doe@example.com"
        };

        _studentRepositoryMock.Setup(x => x.GetByIdAsync(studentId))
            .ReturnsAsync(expectedStudent);

        // Act
        var result = await _studentService.GetStudentByIdAsync(studentId);

        // Assert
        Assert.That(result, Is.Not.Null);
        Assert.That(result.Id, Is.EqualTo(studentId));
        Assert.That(result.FirstName, Is.EqualTo("John"));
        Assert.That(result.LastName, Is.EqualTo("Doe"));
    }

    [Test]
    public async Task CreateStudent_WithValidData_ShouldReturnCreatedStudent()
    {
        // Arrange
        var createStudentDto = new CreateStudentDto
        {
            FirstName = "Jane",
            LastName = "Smith",
            Email = "jane.smith@example.com"
        };

        var createdStudent = new Student
        {
            Id = 1,
            FirstName = createStudentDto.FirstName,
            LastName = createStudentDto.LastName,
            Email = createStudentDto.Email
        };

        _studentRepositoryMock.Setup(x => x.AddAsync(It.IsAny<Student>()))
            .ReturnsAsync(createdStudent);

        // Act
        var result = await _studentService.CreateStudentAsync(createStudentDto);

        // Assert
        Assert.That(result, Is.Not.Null);
        Assert.That(result.FirstName, Is.EqualTo(createStudentDto.FirstName));
        Assert.That(result.LastName, Is.EqualTo(createStudentDto.LastName));
        Assert.That(result.Email, Is.EqualTo(createStudentDto.Email));
    }

    [Test]
    public void CreateStudent_WithInvalidEmail_ShouldThrowException()
    {
        // Arrange
        var createStudentDto = new CreateStudentDto
        {
            FirstName = "Jane",
            LastName = "Smith",
            Email = "invalid-email"
        };

        // Act & Assert
        var ex = Assert.ThrowsAsync<ValidationException>(
            async () => await _studentService.CreateStudentAsync(createStudentDto)
        );
        
        Assert.That(ex.Message, Contains.Substring("Invalid email format"));
    }
}