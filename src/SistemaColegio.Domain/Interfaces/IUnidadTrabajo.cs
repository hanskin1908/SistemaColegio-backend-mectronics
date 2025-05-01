using System;
using System.Threading.Tasks;
using SistemaColegio.Domain.Interfaces.Identity;

namespace SistemaColegio.Domain.Interfaces
{
    public interface IUnidadTrabajo : IDisposable
    {
        IEstudianteRepositorio Estudiantes { get; }
        IProfesorRepositorio Profesores { get; }
        IMateriaRepositorio Materias { get; }
        IRegistroRepositorio Registros { get; }
        IUserRepository Users { get; }
        
        Task<int> CompletarAsync();
        Task<bool> GuardarCambiosAsync();
    }
}