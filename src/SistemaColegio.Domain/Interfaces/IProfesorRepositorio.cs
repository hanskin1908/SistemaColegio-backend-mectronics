using System.Collections.Generic;
using System.Threading.Tasks;
using SistemaColegio.Domain.Entities;

namespace SistemaColegio.Domain.Interfaces
{
    public interface IProfesorRepositorio : IRepositorio<Professor>
    {
        Task<IReadOnlyList<Professor>> ObtenerProfesoresConMateriasAsync();
        Task<Professor> ObtenerProfesorPorEmailAsync(string email);
    }
}