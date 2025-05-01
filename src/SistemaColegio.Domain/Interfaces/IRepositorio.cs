using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading.Tasks;
using SistemaColegio.Domain.Entities;

namespace SistemaColegio.Domain.Interfaces
{
    public interface IRepositorio<T> where T : BaseEntity
    {
        Task<IReadOnlyList<T>> ObtenerTodosAsync();
        Task<IReadOnlyList<T>> ObtenerAsync(Expression<Func<T, bool>> predicado);
        Task<T> ObtenerPorIdAsync(int id);
        Task<T> AgregarAsync(T entidad);
        Task ActualizarAsync(T entidad);
        Task EliminarAsync(T entidad);
        Task<bool> ExisteAsync(Expression<Func<T, bool>> predicado);
    }
}