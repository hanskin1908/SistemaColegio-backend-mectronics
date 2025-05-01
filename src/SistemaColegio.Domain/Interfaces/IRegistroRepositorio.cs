using System.Collections.Generic;
using System.Threading.Tasks;
using SistemaColegio.Domain.Entities;

namespace SistemaColegio.Domain.Interfaces
{
    public interface IRegistroRepositorio : IRepositorio<Registration>
    {
        Task<IReadOnlyList<Registration>> ObtenerRegistrosPorEstudianteIdAsync(int estudianteId);
        Task<IReadOnlyList<Registration>> ObtenerRegistrosPorMateriaIdAsync(int materiaId);
        Task<bool> ExisteRegistroAsync(int estudianteId, int materiaId);
        Task<IReadOnlyList<Registration>> ObtenerRegistrosConDetallesAsync();
        Task<Registration> ObtenerRegistroPorIdConDetallesAsync(int id);
    }
}