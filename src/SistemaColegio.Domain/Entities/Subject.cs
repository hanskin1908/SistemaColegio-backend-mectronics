using System.Collections.Generic;

namespace SistemaColegio.Domain.Entities
{
    public class Subject : BaseEntity
    {
        public string Name { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
        public int Credits { get; set; } = 3;
        
        // Relaciones
        public int? ProfessorId { get; set; }
        public Professor? Professor { get; set; }
        public ICollection<Registration> Registrations { get; set; } = new List<Registration>();
    }
}