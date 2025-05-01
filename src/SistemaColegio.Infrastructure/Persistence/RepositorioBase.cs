using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.Infrastructure.Persistence
{
    public class RepositorioBase<T> : IRepositorio<T> where T : BaseEntity
    {
        protected readonly SistemaColegioDbContext _contexto;
        
        public RepositorioBase(SistemaColegioDbContext contexto)
        {
            _contexto = contexto;
        }
        
        public async Task<IReadOnlyList<T>> ObtenerTodosAsync()
        {
            return await _contexto.Set<T>().ToListAsync();
        }
        
        public async Task<IReadOnlyList<T>> ObtenerAsync(Expression<Func<T, bool>> predicado)
        {
            return await _contexto.Set<T>().Where(predicado).ToListAsync();
        }
        
        public virtual async Task<T> ObtenerPorIdAsync(int id)
        {
            return await _contexto.Set<T>().FindAsync(id);
        }
        
        public async Task<T> AgregarAsync(T entidad)
        {
            await _contexto.Set<T>().AddAsync(entidad);
            return entidad;
        }
        
        public Task ActualizarAsync(T entidad)
        {
            _contexto.Entry(entidad).State = EntityState.Modified;
            return Task.CompletedTask;
        }
        
        public Task EliminarAsync(T entidad)
        {
            _contexto.Set<T>().Remove(entidad);
            return Task.CompletedTask;
        }
        
        public async Task<bool> ExisteAsync(Expression<Func<T, bool>> predicado)
        {
            return await _contexto.Set<T>().AnyAsync(predicado);
        }
    }
}