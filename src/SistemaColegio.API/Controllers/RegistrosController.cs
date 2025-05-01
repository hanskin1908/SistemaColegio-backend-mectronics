using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SistemaColegio.Application.Common.DTOs;
using SistemaColegio.Application.Features.Registros.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace SistemaColegio.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RegistrosController : ControllerBase
    {
        private readonly IRegistroService _registroService;
        
        public RegistrosController(IRegistroService registroService)
        {
            _registroService = registroService;
        }
        
        [HttpGet]
        [Authorize(Roles = "admin")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ObtenerTodos()
        {
            var respuesta = await _registroService.ObtenerTodosAsync();
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpGet("{id}")]
        [Authorize(Roles = "admin,student")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ObtenerPorId(int id)
        {
            var respuesta = await _registroService.ObtenerPorIdAsync(id);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("No se encontru00f3"))
                return NotFound(respuesta);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpGet("estudiante/{estudianteId}")]
        [Authorize(Roles = "admin,student,professor")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ObtenerPorEstudianteId(int estudianteId)
        {
            var respuesta = await _registroService.ObtenerPorEstudianteIdAsync(estudianteId);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpGet("materia/{materiaId}")]
        [Authorize(Roles = "admin,student,professor")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ObtenerPorMateriaId(int materiaId)
        {
            var respuesta = await _registroService.ObtenerPorMateriaIdAsync(materiaId);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> Crear([FromBody] RegistroCreacionDto registroCreacionDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            
            var respuesta = await _registroService.CrearAsync(registroCreacionDto);
            
            if (!respuesta.Exito && (respuesta.Mensaje.Contains("No existe") || respuesta.Mensaje.Contains("Ya existe")))
                return BadRequest(respuesta);
            
            if (respuesta.Exito)
                return CreatedAtAction(nameof(ObtenerPorId), new { id = respuesta.Data.Id }, respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> Actualizar(int id, [FromBody] RegistroDto registroDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            
            var respuesta = await _registroService.ActualizarAsync(id, registroDto);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("No se encontru00f3"))
                return NotFound(respuesta);
            
            if (!respuesta.Exito && (respuesta.Mensaje.Contains("No existe") || respuesta.Mensaje.Contains("Ya existe")))
                return BadRequest(respuesta);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
        
        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> Eliminar(int id)
        {
            var respuesta = await _registroService.EliminarAsync(id);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("No se encontru00f3"))
                return NotFound(respuesta);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }

        [HttpGet("profesor/{profesorId}/materia/{materiaId}")]
        [Authorize(Roles = "Profesor")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> ObtenerEstudiantesPorProfesorYMateria(int profesorId, int materiaId)
        {
            var filtro = new ProfesorEstudiantesFilterDto
            {
                ProfesorId = profesorId,
                MateriaId = materiaId
            };

            var respuesta = await _registroService.ObtenerEstudiantesPorProfesorYMateriaAsync(filtro);
            
            if (!respuesta.Exito && respuesta.Mensaje.Contains("No se encontr"))
                return NotFound(respuesta);

            if (!respuesta.Exito && respuesta.Mensaje.Contains("no tiene acceso"))
                return StatusCode(StatusCodes.Status403Forbidden, respuesta);
            
            if (respuesta.Exito)
                return Ok(respuesta);
            
            return StatusCode(StatusCodes.Status500InternalServerError, respuesta);
        }
    }
}