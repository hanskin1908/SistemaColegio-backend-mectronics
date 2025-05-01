using System;

namespace SistemaColegio.Application.Common.DTOs
{
    public class RegistroDto
    {
        public int Id { get; set; }
        public int EstudianteId { get; set; }
        public string NombreEstudiante { get; set; }
        public int MateriaId { get; set; }
        public string NombreMateria { get; set; }
        public int Creditos { get; set; }
        public string NombreProfesor { get; set; }
        public DateTime FechaRegistro { get; set; }
    }
}