using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using AutoMapper;
using SistemaColegio.Application.Common.DTOs;
using SistemaColegio.Application.Common.Responses;
using SistemaColegio.Application.Features.Estudiantes.Interfaces;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.Application.Features.Estudiantes.Services
{
    public class EstudianteService : IEstudianteService
    {
        private readonly IUnidadTrabajo _unidadTrabajo;
        private readonly IMapper _mapper;
        
        public EstudianteService(IUnidadTrabajo unidadTrabajo, IMapper mapper)
        {
            _unidadTrabajo = unidadTrabajo;
            _mapper = mapper;
        }
        
        public async Task<RespuestaData<List<EstudianteDto>>> ObtenerTodosAsync()
        {
            try
            {
                var estudiantes = await _unidadTrabajo.Estudiantes.ObtenerEstudiantesConRegistrosAsync();
                var estudiantesDto = new List<EstudianteDto>();
                
                foreach (var estudiante in estudiantes)
                {
                    var estudianteDto = _mapper.Map<EstudianteDto>(estudiante);
                    estudianteDto.Registros = new List<RegistroDto>();
                    
                    foreach (var registro in estudiante.Registrations)
                    {
                        var registroDto = new RegistroDto
                        {
                            Id = registro.Id,
                            EstudianteId = registro.StudentId,
                            NombreEstudiante = registro.Student?.Name,
                            MateriaId = registro.SubjectId,
                            NombreMateria = registro.Subject?.Name,
                            FechaRegistro = registro.RegistrationDate
                        };
                        
                        estudianteDto.Registros.Add(registroDto);
                    }
                    
                    estudiantesDto.Add(estudianteDto);
                }
                
                return RespuestaData<List<EstudianteDto>>.Correcto(estudiantesDto, "Estudiantes obtenidos correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<List<EstudianteDto>>.Fallo($"Error al obtener estudiantes: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<List<EstudianteDto>>> ObtenerPorMateriaIdAsync(int materiaId)
        {
            try
            {
                var estudiantes = await _unidadTrabajo.Estudiantes.ObtenerEstudiantesPorMateriaIdAsync(materiaId);
                var estudiantesDto = _mapper.Map<List<EstudianteDto>>(estudiantes);
                return RespuestaData<List<EstudianteDto>>.Correcto(estudiantesDto, "Estudiantes obtenidos correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<List<EstudianteDto>>.Fallo($"Error al obtener estudiantes por materia: {ex.Message}");
            }
        }

        public async Task<MateriaDto> ObtenerMateriaPorIdAsync(int materiaId)
        {
            var materia = await _unidadTrabajo.Materias.ObtenerPorIdAsync(materiaId);
            if (materia == null) return null;
            return _mapper.Map<MateriaDto>(materia);
        }
        
        public async Task<RespuestaData<EstudianteDto>> ObtenerPorIdAsync(int id)
        {
            try
            {
                var estudiante = await _unidadTrabajo.Estudiantes.ObtenerPorIdAsync(id);
                
                if (estudiante == null)
                    return RespuestaData<EstudianteDto>.Fallo($"No se encontró el estudiante con ID: {id}");
                
                var estudianteDto = _mapper.Map<EstudianteDto>(estudiante);
                estudianteDto.Registros = new List<RegistroDto>();
                
                foreach (var registro in estudiante.Registrations)
                {
                    var registroDto = new RegistroDto
                    {
                        Id = registro.Id,
                        EstudianteId = registro.StudentId,
                        NombreEstudiante = registro.Student?.Name,
                        MateriaId = registro.SubjectId,
                        NombreMateria = registro.Subject?.Name,
                        FechaRegistro = registro.RegistrationDate
                    };
                    
                    estudianteDto.Registros.Add(registroDto);
                }
                
                return RespuestaData<EstudianteDto>.Correcto(estudianteDto, "Estudiante obtenido correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<EstudianteDto>.Fallo($"Error al obtener el estudiante: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<EstudianteDto>> ObtenerPorMatriculaAsync(string matricula)
        {
            try
            {
                var estudiante = await _unidadTrabajo.Estudiantes.ObtenerEstudiantePorMatriculaAsync(matricula);
                
                if (estudiante == null)
                    return RespuestaData<EstudianteDto>.Fallo($"No se encontró el estudiante con matrícula: {matricula}");
                
                var estudianteDto = _mapper.Map<EstudianteDto>(estudiante);
                estudianteDto.Registros = new List<RegistroDto>();
                
                foreach (var registro in estudiante.Registrations)
                {
                    var registroDto = new RegistroDto
                    {
                        Id = registro.Id,
                        EstudianteId = registro.StudentId,
                        NombreEstudiante = registro.Student?.Name,
                        MateriaId = registro.SubjectId,
                        NombreMateria = registro.Subject?.Name,
                        FechaRegistro = registro.RegistrationDate
                    };
                    
                    estudianteDto.Registros.Add(registroDto);
                }
                
                return RespuestaData<EstudianteDto>.Correcto(estudianteDto, "Estudiante obtenido correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<EstudianteDto>.Fallo($"Error al obtener el estudiante: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<EstudianteDto>> CrearAsync(EstudianteDto estudianteDto)
        {
            try
            {
                var existeEstudiante = await _unidadTrabajo.Estudiantes.ExisteAsync(e => e.StudentId == estudianteDto.Matricula);
                
                if (existeEstudiante)
                    return RespuestaData<EstudianteDto>.Fallo($"Ya existe un estudiante con la matrícula: {estudianteDto.Matricula}");
                
                var estudiante = _mapper.Map<Student>(estudianteDto);
                
                await _unidadTrabajo.Estudiantes.AgregarAsync(estudiante);
                await _unidadTrabajo.CompletarAsync();
                
                estudianteDto.Id = estudiante.Id;
                
                return RespuestaData<EstudianteDto>.Correcto(estudianteDto, "Estudiante creado correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<EstudianteDto>.Fallo($"Error al crear el estudiante: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<EstudianteDto>> ActualizarAsync(int id, EstudianteDto estudianteDto)
        {
            try
            {
                var estudiante = await _unidadTrabajo.Estudiantes.ObtenerPorIdAsync(id);
                
                if (estudiante == null)
                    return RespuestaData<EstudianteDto>.Fallo($"No se encontró el estudiante con ID: {id}");
                
                var existeEstudiante = await _unidadTrabajo.Estudiantes.ExisteAsync(e => e.StudentId == estudianteDto.Matricula && e.Id != id);
                
                if (existeEstudiante)
                    return RespuestaData<EstudianteDto>.Fallo($"Ya existe otro estudiante con la matrícula: {estudianteDto.Matricula}");
                
                estudiante.Name = estudianteDto.Nombre;
                estudiante.Email = estudianteDto.Email;
                estudiante.StudentId = estudianteDto.Matricula;
                
                await _unidadTrabajo.Estudiantes.ActualizarAsync(estudiante);
                await _unidadTrabajo.CompletarAsync();
                
                return RespuestaData<EstudianteDto>.Correcto(estudianteDto, "Estudiante actualizado correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<EstudianteDto>.Fallo($"Error al actualizar el estudiante: {ex.Message}");
            }
        }

        public async Task<RespuestaData<bool>> EliminarAsync(int id)
        {
            try
            {
                var estudiante = await _unidadTrabajo.Estudiantes.ObtenerPorIdAsync(id);
                
                if (estudiante == null)
                    return RespuestaData<bool>.Fallo($"No se encontró el estudiante con ID: {id}");
                
                await _unidadTrabajo.Estudiantes.EliminarAsync(estudiante);
                await _unidadTrabajo.CompletarAsync();
                
                return RespuestaData<bool>.Correcto(true, "Estudiante eliminado correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<bool>.Fallo($"Error al eliminar el estudiante: {ex.Message}");
            }
        }
    }
}