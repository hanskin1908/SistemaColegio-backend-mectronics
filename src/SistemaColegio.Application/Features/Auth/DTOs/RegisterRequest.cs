namespace SistemaColegio.Application.Features.Auth.DTOs
{
    public class RegisterRequest
    {
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public int? StudentId { get; set; }
        public int? ProfessorId { get; set; }
        public string Role { get; set; } = "student";
    }
}