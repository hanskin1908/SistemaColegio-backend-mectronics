using System.Collections.Generic;
using System.Threading.Tasks;
using SistemaColegio.Application.Common.DTOs;
using SistemaColegio.Application.Common.Responses;

namespace SistemaColegio.Application.Features.Registros.Interfaces
{
    public interface IRegistroService
    {
        Task<RespuestaData<List<RegistroDto>>> ObtenerTodosAsync();
        Task<RespuestaData<RegistroDto>> ObtenerPorIdAsync(int id);
        Task<RespuestaData<List<RegistroDto>>> ObtenerPorEstudianteIdAsync(int estudianteId);
        Task<RespuestaData<List<RegistroDto>>> ObtenerPorMateriaIdAsync(int materiaId);
        Task<RespuestaData<ProfesorEstudiantesResultDto>> ObtenerEstudiantesPorProfesorYMateriaAsync(ProfesorEstudiantesFilterDto filtro);
        Task<RespuestaData<RegistroDto>> CrearAsync(RegistroDto registroDto);
        Task<RespuestaData<RegistroDto>> CrearAsync(RegistroCreacionDto registroCreacionDto);
        Task<RespuestaData<RegistroDto>> ActualizarAsync(int id, RegistroDto registroDto);
        Task<RespuestaData<bool>> EliminarAsync(int id);
    }
}