using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.Infrastructure.Persistence
{
    public class ProfesorRepositorio : RepositorioBase<Professor>, IProfesorRepositorio
    {
        public ProfesorRepositorio(SistemaColegioDbContext contexto) : base(contexto)
        {
        }
        
        public async Task<IReadOnlyList<Professor>> ObtenerProfesoresConMateriasAsync()
        {
            return await _contexto.Profesores
                .Include(p => p.Subjects)
                .ToListAsync();
        }

        public async Task<Professor> ObtenerProfesorPorEmailAsync(string email)
        {
            return await _contexto.Profesores
                .FirstOrDefaultAsync(p => p.Email == email);
        }
    }
}