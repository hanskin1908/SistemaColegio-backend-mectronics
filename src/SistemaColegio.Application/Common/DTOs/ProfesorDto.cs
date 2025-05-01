using System.Collections.Generic;

namespace SistemaColegio.Application.Common.DTOs
{
    public class ProfesorDto
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Email { get; set; }
        public string Departamento { get; set; }
        public List<MateriaDto> Materias { get; set; } = new List<MateriaDto>();
    }
}