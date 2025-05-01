using System.Collections.Generic;
using System.Threading.Tasks;
using SistemaColegio.Application.Common.DTOs;
using SistemaColegio.Application.Common.Responses;

namespace SistemaColegio.Application.Features.Profesores.Interfaces
{
    public interface IProfesorService
    {
        Task<RespuestaData<List<ProfesorDto>>> ObtenerTodosAsync();
        Task<RespuestaData<ProfesorDto>> ObtenerPorIdAsync(int id);
        Task<RespuestaData<ProfesorDto>> ObtenerPorEmailAsync(string email);
        Task<RespuestaData<ProfesorDto>> CrearAsync(ProfesorDto profesorDto);
        Task<RespuestaData<ProfesorDto>> ActualizarAsync(int id, ProfesorDto profesorDto);
        Task<RespuestaData<bool>> EliminarAsync(int id);
    }
}