using System.Collections.Generic;

namespace SistemaColegio.Application.Common.Responses
{
    public class RespuestaBase
    {
        public bool Exito { get; set; }
        public string Mensaje { get; set; }
        public List<string> Errores { get; set; } = new List<string>();
    }
}