using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SistemaColegio.Application.Features.Auth.DTOs;
using SistemaColegio.Application.Features.Auth.Interfaces;

namespace SistemaColegio.API.Controllers
{
    [Route("api/auth")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;
        
        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }
        
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest request)
        {
            var response = await _authService.RegisterAsync(request);
            if (response.Success)
                return Ok(response);
            return BadRequest(response);
        }
        
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            var response = await _authService.LoginAsync(request);
            if (response.Success)
                return Ok(response);
            return Unauthorized(response);
        }
        
        [HttpGet("profile/{id}")]
        [Authorize]
        public async Task<IActionResult> GetProfile(int id)
        {
            var response = await _authService.GetProfileAsync(id);
            if (response.Success)
                return Ok(response);
            return NotFound(response);
        }
    }
}