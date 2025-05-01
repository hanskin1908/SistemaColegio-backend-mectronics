namespace SistemaColegio.Application.Common.DTOs
{
    public class MateriaDto
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Codigo { get; set; }
        public int Creditos { get; set; }
        public int? ProfesorId { get; set; }
        public string? NombreProfesor { get; set; }
    }
}