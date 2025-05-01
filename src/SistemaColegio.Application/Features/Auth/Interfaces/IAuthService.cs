using System.Threading.Tasks;
using SistemaColegio.Application.Common.Models;
using SistemaColegio.Application.Features.Auth.DTOs;

namespace SistemaColegio.Application.Features.Auth.Interfaces
{
    public interface IAuthService
    {
        Task<Response<AuthResponse>> RegisterAsync(RegisterRequest request);
        Task<Response<AuthResponse>> LoginAsync(LoginRequest request);
        Task<Response<AuthResponse>> GetProfileAsync(int userId);
    }
}