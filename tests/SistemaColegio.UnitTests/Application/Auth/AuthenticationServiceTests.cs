using NUnit.Framework;
using Moq;
using SistemaColegio.Application.Features.Auth;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.UnitTests.Application.Auth;

[TestFixture]
public class AuthenticationServiceTests : TestBase
{
    private Mock<IUserRepository> _userRepositoryMock;
    private Mock<ITokenService> _tokenServiceMock;
    private IAuthenticationService _authService;

    [SetUp]
    public override void Setup()
    {
        base.Setup();
        _userRepositoryMock = new Mock<IUserRepository>();
        _tokenServiceMock = new Mock<ITokenService>();
        _authService = new AuthenticationService(_userRepositoryMock.Object, _tokenServiceMock.Object);
    }

    [Test]
    public async Task Login_WithValidCredentials_ShouldReturnToken()
    {
        // Arrange
        var username = "testuser";
        var password = "testpass";
        var hashedPassword = "hashedpass"; // En realidad esto debería ser un hash real
        var expectedToken = "jwt-token";

        var user = new User 
        { 
            Username = username,
            PasswordHash = hashedPassword,
            Role = "Teacher"
        };

        _userRepositoryMock.Setup(x => x.GetByUsernameAsync(username))
            .ReturnsAsync(user);

        _tokenServiceMock.Setup(x => x.GenerateToken(user))
            .Returns(expectedToken);

        // Act
        var result = await _authService.LoginAsync(username, password);

        // Assert
        Assert.That(result, Is.Not.Null);
        Assert.That(result.Token, Is.EqualTo(expectedToken));
    }

    [Test]
    public void Login_WithInvalidCredentials_ShouldThrowException()
    {
        // Arrange
        var username = "wronguser";
        var password = "wrongpass";

        _userRepositoryMock.Setup(x => x.GetByUsernameAsync(username))
            .ReturnsAsync((User)null);

        // Act & Assert
        var ex = Assert.ThrowsAsync<UnauthorizedException>(
            async () => await _authService.LoginAsync(username, password)
        );
        
        Assert.That(ex.Message, Is.EqualTo("Invalid credentials"));
    }
}