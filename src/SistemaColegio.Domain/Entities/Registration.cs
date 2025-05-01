using System;

namespace SistemaColegio.Domain.Entities
{
    public class Registration : BaseEntity
    {
        public int StudentId { get; set; }
        public Student Student { get; set; }
        
        public int SubjectId { get; set; }
        public Subject Subject { get; set; }
        
        public DateTime RegistrationDate { get; set; } = DateTime.Now;
    }
}