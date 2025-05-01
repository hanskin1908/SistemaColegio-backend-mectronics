using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.Infrastructure.Persistence
{
    public class MateriaRepositorio : RepositorioBase<Subject>, IMateriaRepositorio
    {
        public MateriaRepositorio(SistemaColegioDbContext contexto) : base(contexto)
        {
        }
        
        public async Task<IReadOnlyList<Subject>> ObtenerMateriasConProfesorAsync()
        {
            return await _contexto.Materias
                .Include(m => m.Professor)
                .ToListAsync();
        }
        
        public async Task<IReadOnlyList<Subject>> ObtenerMateriasPorProfesorIdAsync(int profesorId)
        {
            return await _contexto.Materias
                .Where(m => m.ProfessorId == profesorId)
                .ToListAsync();
        }

        public async Task<Subject> ObtenerMateriaPorIdConProfesorAsync(int id)
        {
            return await _contexto.Materias
                .Include(m => m.Professor)
                .FirstOrDefaultAsync(m => m.Id == id);
        }

        public async Task<Subject> ObtenerMateriaPorCodigoAsync(string codigo)
        {
            return await _contexto.Materias
                .FirstOrDefaultAsync(m => m.Code == codigo);
        }

        public async Task<IReadOnlyList<Subject>> ObtenerMateriasPorIdsAsync(IEnumerable<int> ids)
        {
            return await _contexto.Materias
                .Include(m => m.Professor)
                .Where(m => ids.Contains(m.Id))
                .ToListAsync();
        }
        // Nuevo método: obtener materia por id (sin incluir profesor necesariamente)
        public async Task<Subject> ObtenerPorIdAsync(int id)
        {
            return await _contexto.Materias.FirstOrDefaultAsync(m => m.Id == id);
        }

    }
}