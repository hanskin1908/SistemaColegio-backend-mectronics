using System.Collections.Generic;

namespace SistemaColegio.Application.Common.DTOs
{
    public class ProfesorMateriasDto
    {
        public int ProfesorId { get; set; }
    }

    public class ProfesorMateriasFilterDto
    {
        public int ProfesorId { get; set; }
    }

    public class ProfesorEstudiantesDto
    {
        public int ProfesorId { get; set; }
        public int MateriaId { get; set; }
    }

    public class ProfesorEstudiantesFilterDto
    {
        public int ProfesorId { get; set; }
        public int MateriaId { get; set; }
    }

    public class ProfesorMateriasRespuestaDto
    {
        public List<MateriaDto> Materias { get; set; } = new List<MateriaDto>();
        public int ProfesorId { get; set; }
    }

    public class ProfesorMateriasResultDto
    {
        public List<MateriaDto> Materias { get; set; } = new List<MateriaDto>();
        public int ProfesorId { get; set; }
    }

    public class ProfesorEstudiantesRespuestaDto
    {
        public List<RegistroDto> Registros { get; set; } = new List<RegistroDto>();
        public int MateriaId { get; set; }
        public int ProfesorId { get; set; }
    }

    public class ProfesorEstudiantesResultDto
    {
        public List<RegistroDto> Registros { get; set; } = new List<RegistroDto>();
        public int MateriaId { get; set; }
        public int ProfesorId { get; set; }
    }
}