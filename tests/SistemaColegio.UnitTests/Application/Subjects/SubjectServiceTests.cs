using NUnit.Framework;
using Moq;
using SistemaColegio.Application.Features.Subjects;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.UnitTests.Application.Subjects;

[TestFixture]
public class SubjectServiceTests : TestBase
{
    private Mock<ISubjectRepository> _subjectRepositoryMock;
    private Mock<ITeacherRepository> _teacherRepositoryMock;
    private ISubjectService _subjectService;

    [SetUp]
    public override void Setup()
    {
        base.Setup();
        _subjectRepositoryMock = new Mock<ISubjectRepository>();
        _teacherRepositoryMock = new Mock<ITeacherRepository>();
        _subjectService = new SubjectService(_subjectRepositoryMock.Object, _teacherRepositoryMock.Object);
    }

    [Test]
    public async Task GetSubject_WithValidId_ShouldReturnSubject()
    {
        // Arrange
        var subjectId = 1;
        var expectedSubject = new Subject
        {
            Id = subjectId,
            Name = "Mathematics",
            Description = "Advanced Mathematics Course",
            TeacherId = 1
        };

        _subjectRepositoryMock.Setup(x => x.GetByIdAsync(subjectId))
            .ReturnsAsync(expectedSubject);

        // Act
        var result = await _subjectService.GetSubjectByIdAsync(subjectId);

        // Assert
        Assert.That(result, Is.Not.Null);
        Assert.That(result.Id, Is.EqualTo(subjectId));
        Assert.That(result.Name, Is.EqualTo("Mathematics"));
    }

    [Test]
    public async Task AssignTeacher_WithValidData_ShouldUpdateSubject()
    {
        // Arrange
        var subjectId = 1;
        var teacherId = 2;
        
        var subject = new Subject
        {
            Id = subjectId,
            Name = "Mathematics",
            TeacherId = null
        };

        var teacher = new Teacher
        {
            Id = teacherId,
            FirstName = "John",
            LastName = "Smith"
        };

        _subjectRepositoryMock.Setup(x => x.GetByIdAsync(subjectId))
            .ReturnsAsync(subject);
        
        _teacherRepositoryMock.Setup(x => x.GetByIdAsync(teacherId))
            .ReturnsAsync(teacher);

        _subjectRepositoryMock.Setup(x => x.UpdateAsync(It.IsAny<Subject>()))
            .ReturnsAsync(new Subject 
            { 
                Id = subjectId, 
                Name = "Mathematics", 
                TeacherId = teacherId 
            });

        // Act
        var result = await _subjectService.AssignTeacherAsync(subjectId, teacherId);

        // Assert
        Assert.That(result, Is.Not.Null);
        Assert.That(result.TeacherId, Is.EqualTo(teacherId));
    }

    [Test]
    public void AssignTeacher_WithInvalidTeacher_ShouldThrowException()
    {
        // Arrange
        var subjectId = 1;
        var invalidTeacherId = 999;

        var subject = new Subject
        {
            Id = subjectId,
            Name = "Mathematics",
            TeacherId = null
        };

        _subjectRepositoryMock.Setup(x => x.GetByIdAsync(subjectId))
            .ReturnsAsync(subject);
        
        _teacherRepositoryMock.Setup(x => x.GetByIdAsync(invalidTeacherId))
            .ReturnsAsync((Teacher)null);

        // Act & Assert
        var ex = Assert.ThrowsAsync<NotFoundException>(
            async () => await _subjectService.AssignTeacherAsync(subjectId, invalidTeacherId)
        );
        
        Assert.That(ex.Message, Is.EqualTo("Teacher not found"));
    }
}