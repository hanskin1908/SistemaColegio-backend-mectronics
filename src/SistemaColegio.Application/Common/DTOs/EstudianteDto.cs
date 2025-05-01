using System.Collections.Generic;

namespace SistemaColegio.Application.Common.DTOs
{
    public class EstudianteDto
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Email { get; set; }
        public string Matricula { get; set; }
        public List<RegistroDto> Registros { get; set; } = new List<RegistroDto>();
    }
}