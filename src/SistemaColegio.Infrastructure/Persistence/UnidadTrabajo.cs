using System;
using System.Threading.Tasks;
using SistemaColegio.Domain.Interfaces;
using SistemaColegio.Domain.Interfaces.Identity;
using SistemaColegio.Infrastructure.Repositories.Identity;

namespace SistemaColegio.Infrastructure.Persistence
{
    public class UnidadTrabajo : IUnidadTrabajo
    {
        private readonly SistemaColegioDbContext _contexto;
        private IEstudianteRepositorio _estudianteRepositorio;
        private IProfesorRepositorio _profesorRepositorio;
        private IMateriaRepositorio _materiaRepositorio;
        private IRegistroRepositorio _registroRepositorio;
        private IUserRepository _userRepository;
        private bool _disposed;
        
        public UnidadTrabajo(SistemaColegioDbContext contexto)
        {
            _contexto = contexto ?? throw new ArgumentNullException(nameof(contexto));
        }
        
        public IEstudianteRepositorio Estudiantes => _estudianteRepositorio ??= new EstudianteRepositorio(_contexto);
        
        public IProfesorRepositorio Profesores => _profesorRepositorio ??= new ProfesorRepositorio(_contexto);
        
        public IMateriaRepositorio Materias => _materiaRepositorio ??= new MateriaRepositorio(_contexto);
        
        public IRegistroRepositorio Registros => _registroRepositorio ??= new RegistroRepositorio(_contexto);

        public IUserRepository Users => _userRepository ??= new UserRepository(_contexto);
        
        public async Task<int> CompletarAsync()
        {
            return await _contexto.SaveChangesAsync();
        }
        
        public async Task<bool> GuardarCambiosAsync()
        {
            return await _contexto.SaveChangesAsync() > 0;
        }
        
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        
        protected virtual void Dispose(bool disposing)
        {
            if (!_disposed)
            {
                if (disposing)
                {
                    _contexto.Dispose();
                }
                _disposed = true;
            }
        }
    }
}