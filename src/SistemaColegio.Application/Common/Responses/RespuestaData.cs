namespace SistemaColegio.Application.Common.Responses
{
    public class RespuestaData<T> : RespuestaBase
    {
        public T Data { get; set; }
        
        public static RespuestaData<T> Correcto(T data, string mensaje = null)
        {
            return new RespuestaData<T>
            {
                Exito = true,
                Mensaje = mensaje,
                Data = data
            };
        }
        
        public static RespuestaData<T> Fallo(string mensaje, List<string> errores = null)
        {
            return new RespuestaData<T>
            {
                Exito = false,
                Mensaje = mensaje,
                Errores = errores ?? new List<string>()
            };
        }
    }
}