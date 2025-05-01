using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SistemaColegio.Application.Common.DTOs;
using SistemaColegio.Application.Features.Estudiantes.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace SistemaColegio.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class EstudiantesController : ControllerBase
    {
        private readonly IEstudianteService _estudianteService;
        
        public EstudiantesController(IEstudianteService estudianteService)
        {
            _estudianteService = estudianteService;
        }
        
        [HttpGet]
        [Authorize(Roles = "admin,professor")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ObtenerTodos()
        {
            var respuesta = await _estudianteService.ObtenerTodosAsync();
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpGet("{id}")]
        [Authorize(Roles = "admin,Estudiante,professor")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ObtenerPorId(int id)
        {
            var respuesta = await _estudianteService.ObtenerPorIdAsync(id);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("No se encontro"))
                return NotFound(respuesta);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpGet("matricula/{matricula}")]
        [Authorize(Roles = "admin")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ObtenerPorMatricula(string matricula)
        {
            var respuesta = await _estudianteService.ObtenerPorMatriculaAsync(matricula);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("No se encontru00f3"))
                return NotFound(respuesta);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        // Nuevo endpoint seguro: estudiantes de una materia solo si el profesor la dicta
        [HttpGet("por-materia-profesor/{materiaId}")]
        [Authorize(Roles = "professor")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ObtenerEstudiantesPorMateriaSiEsDelProfesor(int materiaId)
        {
            // Obtener el claim "profesorId" del usuario autenticado
            var profesorIdClaim = User.Claims.FirstOrDefault(c => c.Type == "profesorId");
            if (profesorIdClaim == null || !int.TryParse(profesorIdClaim.Value, out int profesorId))
            {
                return Forbid();
            }

            // Aquí deberías tener un método en el servicio que valide la relación materia-profesor
            var materia = await _estudianteService.ObtenerMateriaPorIdAsync(materiaId); // Este método debe existir o implementarse
            if (materia == null)
                return NotFound(new { Exito = false, Mensaje = "Materia no encontrada" });
            if (materia.ProfesorId != profesorId)
                return StatusCode(StatusCodes.Status403Forbidden, new { Exito = false, Mensaje = "No tiene permisos para ver los estudiantes de esta materia." });

            var respuesta = await _estudianteService.ObtenerPorMateriaIdAsync(materiaId);
            if (respuesta.Exito)
                return Ok(respuesta);
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }

        
        [HttpPost]
        [Authorize(Roles = "admin")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> Crear([FromBody] EstudianteDto estudianteDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            
            var respuesta = await _estudianteService.CrearAsync(estudianteDto);
            
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
        public async Task<IActionResult> Actualizar(int id, [FromBody] EstudianteDto estudianteDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            
            var respuesta = await _estudianteService.ActualizarAsync(id, estudianteDto);
            
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
            var respuesta = await _estudianteService.EliminarAsync(id);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("No se encontru00f3"))
                return NotFound(respuesta);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
    }
}