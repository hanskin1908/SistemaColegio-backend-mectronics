using System;
using System.Collections.Generic;

namespace SistemaColegio.Domain.Entities.Identity
{
    public class User : BaseEntity
    {
        public string Email { get; set; } = string.Empty;
        public string PasswordHash { get; set; } = string.Empty;
        public string Role { get; set; } = "student"; // Default role
        public int? StudentId { get; set; }
        public Student? Student { get; set; }
        public int? ProfessorId { get; set; }
        public Professor? Professor { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime? LastLogin { get; set; }
    }
}