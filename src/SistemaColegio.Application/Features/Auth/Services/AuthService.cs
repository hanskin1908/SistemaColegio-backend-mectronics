using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using SistemaColegio.Application.Common.Models;
using SistemaColegio.Application.Features.Auth.DTOs;
using SistemaColegio.Application.Features.Auth.Interfaces;
using SistemaColegio.Domain.Entities.Identity;
using SistemaColegio.Domain.Interfaces;
using SistemaColegio.Domain.Interfaces.Identity;


namespace SistemaColegio.Application.Features.Auth.Services
{
    public class AuthService : IAuthService
    {
        private readonly IUserRepository _userRepository;
        private readonly IConfiguration _configuration;
        private readonly IEstudianteRepositorio _estudianteRepositorio;
        private readonly IProfesorRepositorio _profesorRepositorio;
        private readonly IUnidadTrabajo _unidadTrabajo;

        public AuthService(
            IUserRepository userRepository,
            IConfiguration configuration,
            IEstudianteRepositorio estudianteRepositorio,
            IProfesorRepositorio profesorRepositorio,
            IUnidadTrabajo unidadTrabajo)
        {
            _userRepository = userRepository;
            _configuration = configuration;
            _estudianteRepositorio = estudianteRepositorio;
            _profesorRepositorio = profesorRepositorio;
            _unidadTrabajo = unidadTrabajo;
        }

        public async Task<Response<AuthResponse>> RegisterAsync(RegisterRequest request)
        {
            // Verificar si el email ya existe
            if (await _userRepository.EmailExistsAsync(request.Email))
            {
                return Response<AuthResponse>.Fail("El correo electrónico ya está registrado");
            }

            // Validar el rol
            if (request.Role != "student" && request.Role != "professor" && request.Role != "admin")
            {
                return Response<AuthResponse>.Fail("Rol no válido");
            }

            // Validar relaciones según el rol
            if (request.Role == "student" && request.StudentId.HasValue)
            {
                var student = await _estudianteRepositorio.ObtenerPorIdAsync(request.StudentId.Value);
                if (student == null)
                {
                    return Response<AuthResponse>.Fail("El estudiante no existe");
                }
            }
            else if (request.Role == "professor" && request.ProfessorId.HasValue)
            {
                var professor = await _profesorRepositorio.ObtenerPorIdAsync(request.ProfessorId.Value);
                if (professor == null)
                {
                    return Response<AuthResponse>.Fail("El profesor no existe");
                }
            }

            // Crear el usuario
            var user = new User
            {
                Email = request.Email,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password),
                Role = request.Role,
                StudentId = request.StudentId,
                ProfessorId = request.ProfessorId,
                CreatedAt = DateTime.Now
            };

            await _userRepository.AgregarAsync(user);
            await _unidadTrabajo.CompletarAsync();

            // Generar token
            var token = GenerateJwtToken(user);

            return Response<AuthResponse>.Ok(new AuthResponse
            {
                UserId = user.Id,
                Token = token,
                ExpiresIn = 3600,
                Role = user.Role,
                Email = user.Email,
                Name = request.Name
            }, "Usuario registrado exitosamente");
        }

        public async Task<Response<AuthResponse>> LoginAsync(LoginRequest request)
        {
            // Buscar usuario por email
            var user = await _userRepository.GetByEmailAsync(request.Email);
            if (user == null)
            {
                return Response<AuthResponse>.Fail("Credenciales inválidas");
            }

            // Verificar contraseña
            if (!BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
            {
                return Response<AuthResponse>.Fail("Credenciales inválidas");
            }

            // Actualizar último login
            user.LastLogin = DateTime.Now;
            await _userRepository.ActualizarAsync(user);
            await _unidadTrabajo.CompletarAsync();

            // Generar token
            var token = GenerateJwtToken(user);

            // Obtener nombre según el rol
            string name = "Usuario";
            if (user.StudentId.HasValue)
            {
                var student = await _estudianteRepositorio.ObtenerPorIdAsync(user.StudentId.Value);
                if (student != null)
                {
                    name = student.Nombre;
                }
            }
            else if (user.ProfessorId.HasValue)
            {
                var professor = await _profesorRepositorio.ObtenerPorIdAsync(user.ProfessorId.Value);
                if (professor != null)
                {
                    name = professor.Nombre;
                }
            }

            return Response<AuthResponse>.Ok(new AuthResponse
            {
                UserId = user.Id,
                Token = token,
                ExpiresIn = 3600,
                Role = user.Role,
                Email = user.Email,
                Name = name
            }, "Inicio de sesión exitoso");
        }

        public async Task<Response<AuthResponse>> GetProfileAsync(int userId)
        {
            var user = await _userRepository.ObtenerPorIdAsync(userId);
            if (user == null)
            {
                return Response<AuthResponse>.Fail("Usuario no encontrado");
            }

            // Obtener nombre según el rol
            string name = "Usuario";
            if (user.StudentId.HasValue)
            {
                var student = await _estudianteRepositorio.ObtenerPorIdAsync(user.StudentId.Value);
                if (student != null)
                {
                    name = student.Nombre;
                }
            }
            else if (user.ProfessorId.HasValue)
            {
                var professor = await _profesorRepositorio.ObtenerPorIdAsync(user.ProfessorId.Value);
                if (professor != null)
                {
                    name = professor.Nombre;
                }
            }

            return Response<AuthResponse>.Ok(new AuthResponse
            {
                UserId = user.Id,
                Role = user.Role,
                Email = user.Email,
                Name = name
            }, "Perfil obtenido exitosamente");
        }

        private string GenerateJwtToken(User user)
        {
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JwtSettings:Key"]));
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claims = new List<Claim>
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
                new Claim(ClaimTypes.Role, user.Role),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            };

            // Agregar claim de profesorId si corresponde
            if (user.ProfessorId.HasValue)
            {
                claims.Add(new Claim("profesorId", user.ProfessorId.Value.ToString()));
            }
            // Si el usuario es profesor pero no tiene ProfessorId, buscar en la base de datos
            else if (user.Role == "professor")
            {
                // Buscar el profesor por email
                var profesor = _profesorRepositorio.ObtenerTodosAsync().Result
                    .FirstOrDefault(p => p.Email == user.Email);
                
                if (profesor != null)
                {
                    // Actualizar el usuario con el ID del profesor
                    user.ProfessorId = profesor.Id;
                    _userRepository.ActualizarAsync(user).Wait();
                    _unidadTrabajo.CompletarAsync().Wait();
                    
                    // Agregar el claim
                    claims.Add(new Claim("profesorId", profesor.Id.ToString()));
                }
            }
            // (Opcional) Agregar claim de studentId si corresponde
            if (user.StudentId.HasValue)
            {
                claims.Add(new Claim("studentId", user.StudentId.Value.ToString()));
            }

            var token = new JwtSecurityToken(
                issuer: _configuration["JwtSettings:Issuer"],
                audience: _configuration["JwtSettings:Audience"],
                claims: claims,
                expires: DateTime.Now.AddHours(1),
                signingCredentials: credentials);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}