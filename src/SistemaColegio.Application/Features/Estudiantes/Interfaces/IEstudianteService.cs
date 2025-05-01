using System.Collections.Generic;
using System.Threading.Tasks;
using SistemaColegio.Application.Common.DTOs;
using SistemaColegio.Application.Common.Responses;

namespace SistemaColegio.Application.Features.Estudiantes.Interfaces
{
    public interface IEstudianteService
    {
        Task<RespuestaData<List<EstudianteDto>>> ObtenerTodosAsync();
        Task<RespuestaData<EstudianteDto>> ObtenerPorIdAsync(int id);
        Task<RespuestaData<EstudianteDto>> ObtenerPorMatriculaAsync(string matricula);
        Task<RespuestaData<EstudianteDto>> CrearAsync(EstudianteDto estudianteDto);
        Task<RespuestaData<EstudianteDto>> ActualizarAsync(int id, EstudianteDto estudianteDto);
        Task<RespuestaData<bool>> EliminarAsync(int id);

        // Nuevo método para obtener estudiantes por materia
        Task<RespuestaData<List<EstudianteDto>>> ObtenerPorMateriaIdAsync(int materiaId);
        // Nuevo método para obtener la materia y validar el profesor
        Task<MateriaDto> ObtenerMateriaPorIdAsync(int materiaId);
    }
}