using System.Collections.Generic;

namespace SistemaColegio.Domain.Entities
{
    public class Professor : BaseEntity
    {
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Specialty { get; set; } = string.Empty;
        
        // Propiedades adicionales para compatibilidad
        public string Department => Specialty;
        public string Nombre => Name;
        
        // Relaciones
        public ICollection<Subject> Subjects { get; set; } = new List<Subject>();
    }
}