using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SistemaColegio.Domain.Entities.Identity;
using SistemaColegio.Domain.Interfaces.Identity;
using SistemaColegio.Infrastructure.Persistence;

namespace SistemaColegio.Infrastructure.Repositories.Identity
{
    public class UserRepository : IUserRepository
    {
        protected readonly SistemaColegioDbContext _context;

        public UserRepository(SistemaColegioDbContext context)
        {
            _context = context;
        }

        public async Task<User> GetByEmailAsync(string email)
        {
            return await _context.Users
                .Include(u => u.Student)
                .Include(u => u.Professor)
                .FirstOrDefaultAsync(u => u.Email == email);
        }

        public async Task<bool> EmailExistsAsync(string email)
        {
            return await _context.Users.AnyAsync(u => u.Email == email);
        }

        public async Task<IReadOnlyList<User>> ObtenerTodosAsync()
        {
            return await _context.Users.ToListAsync();
        }

        public async Task<IReadOnlyList<User>> ObtenerAsync(Expression<Func<User, bool>> predicado)
        {
            return await _context.Users.Where(predicado).ToListAsync();
        }

        public async Task<User> ObtenerPorIdAsync(int id)
        {
            return await _context.Users.FindAsync(id);
        }

        public async Task<User> AgregarAsync(User entidad)
        {
            await _context.Users.AddAsync(entidad);
            return entidad;
        }

        public Task ActualizarAsync(User entidad)
        {
            _context.Entry(entidad).State = EntityState.Modified;
            return Task.CompletedTask;
        }

        public Task EliminarAsync(User entidad)
        {
            _context.Users.Remove(entidad);
            return Task.CompletedTask;
        }

        public async Task<bool> ExisteAsync(Expression<Func<User, bool>> predicado)
        {
            return await _context.Users.AnyAsync(predicado);
        }
    }
}