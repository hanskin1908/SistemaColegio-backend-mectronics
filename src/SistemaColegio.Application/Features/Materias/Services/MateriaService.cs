using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using SistemaColegio.Application.Common.DTOs;
using SistemaColegio.Application.Common.Responses;
using SistemaColegio.Application.Features.Materias.Interfaces;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.Application.Features.Materias.Services
{
    public class MateriaService : IMateriaService
    {
        private readonly IUnidadTrabajo _unidadTrabajo;
        private readonly IMapper _mapper;
        
        public MateriaService(IUnidadTrabajo unidadTrabajo, IMapper mapper)
        {
            _unidadTrabajo = unidadTrabajo;
            _mapper = mapper;
        }
        
        public async Task<RespuestaData<List<MateriaDto>>> ObtenerTodasAsync()
        {
            try
            {
                var materias = await _unidadTrabajo.Materias.ObtenerMateriasConProfesorAsync();
                var materiasDto = _mapper.Map<List<MateriaDto>>(materias);
                
                return RespuestaData<List<MateriaDto>>.Correcto(materiasDto, "Materias obtenidas correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<List<MateriaDto>>.Fallo($"Error al obtener materias: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<MateriaDto>> ObtenerPorIdAsync(int id)
        {
            try
            {
                var materia = await _unidadTrabajo.Materias.ObtenerMateriaPorIdConProfesorAsync(id);
                
                if (materia == null)
                    return RespuestaData<MateriaDto>.Fallo($"No se encontru00f3 la materia con ID: {id}");
                
                var materiaDto = _mapper.Map<MateriaDto>(materia);
                
                return RespuestaData<MateriaDto>.Correcto(materiaDto, "Materia obtenida correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<MateriaDto>.Fallo($"Error al obtener la materia: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<List<MateriaDto>>> ObtenerPorProfesorIdAsync(int profesorId)
        {
            try
            {
                var materias = await _unidadTrabajo.Materias.ObtenerMateriasPorProfesorIdAsync(profesorId);
                var materiasDto = _mapper.Map<List<MateriaDto>>(materias);
                
                return RespuestaData<List<MateriaDto>>.Correcto(materiasDto, "Materias obtenidas correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<List<MateriaDto>>.Fallo($"Error al obtener materias: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<List<MateriaDto>>> ObtenerPorEstudianteIdAsync(int id)
        {
            try
            {
                // Variable para almacenar el ID del estudiante
                int estudianteId;
                
                // Primero intentamos buscar directamente como estudiante
                var estudiante = await _unidadTrabajo.Estudiantes.ObtenerPorIdAsync(id);
                
                // Si no encontramos un estudiante, verificamos si es un ID de usuario
                if (estudiante == null)
                {
                    var usuario = await _unidadTrabajo.Users.ObtenerPorIdAsync(id);
                    if (usuario == null)
                    {
                        return RespuestaData<List<MateriaDto>>.Fallo($"No se encontró ningún estudiante o usuario con ID: {id}");
                    }
                    
                    // Si el usuario no tiene un estudiante asociado, retornamos error
                    if (!usuario.StudentId.HasValue)
                    {
                        return RespuestaData<List<MateriaDto>>.Fallo($"El usuario con ID: {id} no tiene un estudiante asociado");
                    }
                    
                    // Obtenemos el estudiante asociado al usuario
                    estudiante = await _unidadTrabajo.Estudiantes.ObtenerPorIdAsync(usuario.StudentId.Value);
                    if (estudiante == null)
                    {
                        return RespuestaData<List<MateriaDto>>.Fallo($"No se encontró el estudiante asociado al usuario con ID: {id}");
                    }
                }
                
                // En este punto tenemos un estudiante válido
                estudianteId = estudiante.Id;

                // Obtener los registros del estudiante usando el ID del estudiante
                var registros = await _unidadTrabajo.Registros.ObtenerRegistrosPorEstudianteIdAsync(estudianteId);
                
                // Si no hay registros, devolver lista vacía
                if (registros == null || !registros.Any())
                {
                    return RespuestaData<List<MateriaDto>>.Correcto(new List<MateriaDto>(), "El estudiante no tiene materias registradas");
                }
                
                // Extraer los IDs de las materias y filtrar los nulos
                var materiaIds = registros.Where(r => r?.SubjectId > 0).Select(r => r.SubjectId).Distinct().ToList();
                
                if (!materiaIds.Any())
                {
                    return RespuestaData<List<MateriaDto>>.Correcto(new List<MateriaDto>(), "No se encontraron materias válidas para el estudiante");
                }

                // Obtener las materias con sus detalles
                var materias = new List<Subject>();
                foreach (var materiaId in materiaIds)
                {
                    var materia = await _unidadTrabajo.Materias.ObtenerMateriaPorIdConProfesorAsync(materiaId);
                    if (materia != null)
                    {
                        materias.Add(materia);
                    }
                }
                
                var materiasDto = _mapper.Map<List<MateriaDto>>(materias);
                
                return RespuestaData<List<MateriaDto>>.Correcto(materiasDto, 
                    materias.Any() 
                        ? "Materias del estudiante obtenidas correctamente" 
                        : "No se encontraron materias activas para el estudiante");
            }
            catch (Exception ex)
            {
                return RespuestaData<List<MateriaDto>>.Fallo($"Error al obtener materias del estudiante: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<MateriaDto>> ObtenerPorCodigoAsync(string codigo)
        {
            try
            {
                var materia = await _unidadTrabajo.Materias.ObtenerMateriaPorCodigoAsync(codigo);
                
                if (materia == null)
                    return RespuestaData<MateriaDto>.Fallo($"No se encontru00f3 la materia con cu00f3digo: {codigo}");
                
                var materiaDto = _mapper.Map<MateriaDto>(materia);
                
                return RespuestaData<MateriaDto>.Correcto(materiaDto, "Materia obtenida correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<MateriaDto>.Fallo($"Error al obtener la materia: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<MateriaDto>> CrearAsync(MateriaDto materiaDto)
        {
            try
            {
                // Verificar si ya existe una materia con el mismo código
                var existeMateria = await _unidadTrabajo.Materias.ExisteAsync(m => m.Code == materiaDto.Codigo);
                
                if (existeMateria)
                    return RespuestaData<MateriaDto>.Fallo($"Ya existe una materia con el cu00f3digo: {materiaDto.Codigo}");
                
                var materia = _mapper.Map<Subject>(materiaDto);
                
                await _unidadTrabajo.Materias.AgregarAsync(materia);
                await _unidadTrabajo.CompletarAsync();
                
                materiaDto.Id = materia.Id;
                
                return RespuestaData<MateriaDto>.Correcto(materiaDto, "Materia creada correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<MateriaDto>.Fallo($"Error al crear la materia: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<MateriaDto>> ActualizarAsync(int id, MateriaDto materiaDto)
        {
            try
            {
                var materia = await _unidadTrabajo.Materias.ObtenerPorIdAsync(id);
                
                if (materia == null)
                    return RespuestaData<MateriaDto>.Fallo($"No se encontru00f3 la materia con ID: {id}");
                
                // Verificar si ya existe otra materia con el mismo código
                var existeMateria = await _unidadTrabajo.Materias.ExisteAsync(m => m.Code == materiaDto.Codigo && m.Id != id);
                
                if (existeMateria)
                    return RespuestaData<MateriaDto>.Fallo($"Ya existe otra materia con el cu00f3digo: {materiaDto.Codigo}");
                
                materia.Name = materiaDto.Nombre;
                materia.Code = materiaDto.Codigo;
                materia.Credits = materiaDto.Creditos;
                materia.ProfessorId = materiaDto.ProfesorId.HasValue ? materiaDto.ProfesorId.Value : 0;
                
                await _unidadTrabajo.Materias.ActualizarAsync(materia);
                await _unidadTrabajo.CompletarAsync();
                
                materiaDto.Id = materia.Id;
                
                return RespuestaData<MateriaDto>.Correcto(materiaDto, "Materia actualizada correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<MateriaDto>.Fallo($"Error al actualizar la materia: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<bool>> EliminarAsync(int id)
        {
            try
            {
                var materia = await _unidadTrabajo.Materias.ObtenerPorIdAsync(id);
                
                if (materia == null)
                    return RespuestaData<bool>.Fallo($"No se encontru00f3 la materia con ID: {id}");
                
                // Verificar si hay registros asociados a esta materia
                var tieneRegistros = await _unidadTrabajo.Registros.ExisteAsync(r => r.SubjectId == id);
                
                if (tieneRegistros)
                    return RespuestaData<bool>.Fallo("No se puede eliminar la materia porque tiene registros asociados");
                
                await _unidadTrabajo.Materias.EliminarAsync(materia);
                await _unidadTrabajo.CompletarAsync();
                
                return RespuestaData<bool>.Correcto(true, "Materia eliminada correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<bool>.Fallo($"Error al eliminar la materia: {ex.Message}");
            }
        }

        public async Task<RespuestaData<List<MateriaDto>>> ObtenerPorIdsAsync(List<int> ids)
        {
            try
            {
                if (ids == null || !ids.Any())
                    return RespuestaData<List<MateriaDto>>.Correcto(new List<MateriaDto>(), "No se proporcionaron IDs de materias");
                
                var materias = await _unidadTrabajo.Materias.ObtenerMateriasPorIdsAsync(ids);
                var materiasDto = _mapper.Map<List<MateriaDto>>(materias);
                
                return RespuestaData<List<MateriaDto>>.Correcto(materiasDto, "Materias obtenidas correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<List<MateriaDto>>.Fallo($"Error al obtener materias por IDs: {ex.Message}");
            }
        }

        public async Task<RespuestaData<ProfesorMateriasResultDto>> ObtenerMateriasPorProfesorAsync(ProfesorMateriasFilterDto filtro)
        {
            try
            {
                // Verificar si el profesor existe
                var profesor = await _unidadTrabajo.Profesores.ObtenerPorIdAsync(filtro.ProfesorId);
                if (profesor == null)
                    return RespuestaData<ProfesorMateriasResultDto>.Fallo($"No se encontró el profesor con ID: {filtro.ProfesorId}");
                
                // Obtener las materias del profesor
                var materias = await _unidadTrabajo.Materias.ObtenerMateriasPorProfesorIdAsync(filtro.ProfesorId);
                var materiasDto = _mapper.Map<List<MateriaDto>>(materias);
                
                var respuesta = new ProfesorMateriasResultDto
                {
                    Materias = materiasDto,
                    ProfesorId = filtro.ProfesorId
                };
                
                return RespuestaData<ProfesorMateriasResultDto>.Correcto(respuesta, "Materias del profesor obtenidas correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<ProfesorMateriasResultDto>.Fallo($"Error al obtener materias del profesor: {ex.Message}");
            }
        }

        public async Task<Professor> BuscarProfesorPorEmailAsync(string email)
        {
            try
            {
                // Buscar el profesor por email
                var profesores = await _unidadTrabajo.Profesores.ObtenerTodosAsync();
                return profesores.FirstOrDefault(p => p.Email == email);
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}