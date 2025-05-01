using System;

namespace SistemaColegio.Application.Common.DTOs
{
    public class RegistroCreacionDto
    {
        public int EstudianteId { get; set; }
        public string NombreEstudiante { get; set; }
        public int MateriaId { get; set; }
        public string NombreMateria { get; set; }
        // La fecha de registro se establecerá automáticamente en el servicio
    }
}