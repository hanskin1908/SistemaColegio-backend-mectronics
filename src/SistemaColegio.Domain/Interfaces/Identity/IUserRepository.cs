using System.Threading.Tasks;
using SistemaColegio.Domain.Entities.Identity;

namespace SistemaColegio.Domain.Interfaces.Identity
{
    public interface IUserRepository : IRepositorio<User>
    {
        Task<User> GetByEmailAsync(string email);
        Task<bool> EmailExistsAsync(string email);
    }
}