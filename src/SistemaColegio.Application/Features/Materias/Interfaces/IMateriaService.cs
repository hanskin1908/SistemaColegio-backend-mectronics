using System.Collections.Generic;
using System.Threading.Tasks;
using SistemaColegio.Application.Common.DTOs;
using SistemaColegio.Application.Common.Responses;
using SistemaColegio.Domain.Entities;

namespace SistemaColegio.Application.Features.Materias.Interfaces
{
    public interface IMateriaService
    {
        Task<RespuestaData<List<MateriaDto>>> ObtenerTodasAsync();
        Task<RespuestaData<MateriaDto>> ObtenerPorIdAsync(int id);
        Task<RespuestaData<List<MateriaDto>>> ObtenerPorProfesorIdAsync(int profesorId);
        Task<RespuestaData<ProfesorMateriasResultDto>> ObtenerMateriasPorProfesorAsync(ProfesorMateriasFilterDto filtro);
        Task<RespuestaData<List<MateriaDto>>> ObtenerPorEstudianteIdAsync(int estudianteId);
        Task<RespuestaData<MateriaDto>> ObtenerPorCodigoAsync(string codigo);
        Task<RespuestaData<List<MateriaDto>>> ObtenerPorIdsAsync(List<int> ids);
        Task<RespuestaData<MateriaDto>> CrearAsync(MateriaDto materiaDto);
        Task<RespuestaData<MateriaDto>> ActualizarAsync(int id, MateriaDto materiaDto);
        Task<RespuestaData<bool>> EliminarAsync(int id);
        Task<Professor> BuscarProfesorPorEmailAsync(string email);
    }
}