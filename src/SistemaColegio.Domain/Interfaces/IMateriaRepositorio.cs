using System.Collections.Generic;
using System.Threading.Tasks;
using SistemaColegio.Domain.Entities;

namespace SistemaColegio.Domain.Interfaces
{
    public interface IMateriaRepositorio : IRepositorio<Subject>
    {
        Task<IReadOnlyList<Subject>> ObtenerMateriasConProfesorAsync();
        Task<IReadOnlyList<Subject>> ObtenerMateriasPorProfesorIdAsync(int profesorId);
        Task<Subject> ObtenerMateriaPorIdConProfesorAsync(int id);
        Task<Subject> ObtenerPorIdAsync(int id);
        Task<Subject> ObtenerMateriaPorCodigoAsync(string codigo);
        Task<IReadOnlyList<Subject>> ObtenerMateriasPorIdsAsync(IEnumerable<int> ids);
    }
}