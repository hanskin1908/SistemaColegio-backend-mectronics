using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SistemaColegio.Application.Common.DTOs;
using SistemaColegio.Application.Features.Profesores.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace SistemaColegio.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ProfesoresController : ControllerBase
    {
        private readonly IProfesorService _profesorService;
        
        public ProfesoresController(IProfesorService profesorService)
        {
            _profesorService = profesorService;
        }
        
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ObtenerTodos()
        {
            var respuesta = await _profesorService.ObtenerTodosAsync();
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ObtenerPorId(int id)
        {
            var respuesta = await _profesorService.ObtenerPorIdAsync(id);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("No se encontru00f3"))
                return NotFound(respuesta);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpGet("email/{email}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ObtenerPorEmail(string email)
        {
            var respuesta = await _profesorService.ObtenerPorEmailAsync(email);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("No se encontru00f3"))
                return NotFound(respuesta);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpPost]
        [Authorize(Roles = "admin")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> Crear([FromBody] ProfesorDto profesorDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            
            var respuesta = await _profesorService.CrearAsync(profesorDto);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("Ya existe"))
                return BadRequest(respuesta);
            
            if (respuesta.Exito)
                return CreatedAtAction(nameof(ObtenerPorId), new { id = respuesta.Data.Id }, respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpPut("{id}")]
        [Authorize(Roles = "admin")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> Actualizar(int id, [FromBody] ProfesorDto profesorDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            
            var respuesta = await _profesorService.ActualizarAsync(id, profesorDto);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("No se encontru00f3"))
                return NotFound(respuesta);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("Ya existe"))
                return BadRequest(respuesta);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpDelete("{id}")]
        [Authorize(Roles = "admin")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> Eliminar(int id)
        {
            var respuesta = await _profesorService.EliminarAsync(id);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("No se encontru00f3"))
                return NotFound(respuesta);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
    }
}