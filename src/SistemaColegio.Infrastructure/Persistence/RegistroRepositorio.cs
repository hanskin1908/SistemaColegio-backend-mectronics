using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.Infrastructure.Persistence
{
    public class RegistroRepositorio : RepositorioBase<Registration>, IRegistroRepositorio
    {
        public RegistroRepositorio(SistemaColegioDbContext contexto) : base(contexto)
        {
        }
        
        public async Task<IReadOnlyList<Registration>> ObtenerRegistrosPorEstudianteIdAsync(int estudianteId)
        {
            return await _contexto.Registros
                .Where(r => r.StudentId == estudianteId)
                .Include(r => r.Subject)
                    .ThenInclude(m => m.Professor)
                .Include(r => r.Student)
                .ToListAsync();
        }
        
        public async Task<IReadOnlyList<Registration>> ObtenerRegistrosPorMateriaIdAsync(int materiaId)
        {
            return await _contexto.Registros
                .Where(r => r.SubjectId == materiaId)
                .Include(r => r.Student)
                .ToListAsync();
        }
        
        public async Task<bool> ExisteRegistroAsync(int estudianteId, int materiaId)
        {
            return await _contexto.Registros
                .AnyAsync(r => r.StudentId == estudianteId && r.SubjectId == materiaId);
        }

        public async Task<IReadOnlyList<Registration>> ObtenerRegistrosConDetallesAsync()
        {
            return await _contexto.Registros
                .Include(r => r.Student)
                .Include(r => r.Subject)
                .ToListAsync();
        }

        // Sobrescribimos el método ObtenerPorIdAsync para incluir las relaciones
        public override async Task<Registration> ObtenerPorIdAsync(int id)
        {
            return await _contexto.Registros
                .Include(r => r.Student)
                .Include(r => r.Subject)
                .FirstOrDefaultAsync(r => r.Id == id);
        }

        public async Task<Registration> ObtenerRegistroPorIdConDetallesAsync(int id)
        {
            return await _contexto.Registros
                .Include(r => r.Student)
                .Include(r => r.Subject)
                    .ThenInclude(m => m.Professor)
                .FirstOrDefaultAsync(r => r.Id == id);
        }
    }
}