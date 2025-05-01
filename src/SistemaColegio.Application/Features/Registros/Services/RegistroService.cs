using System;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using SistemaColegio.Application.Common.DTOs;
using SistemaColegio.Application.Common.Responses;
using SistemaColegio.Application.Features.Registros.Interfaces;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.Application.Features.Registros.Services
{
    public class RegistroService : IRegistroService
    {
        private readonly IUnidadTrabajo _unidadTrabajo;
        private readonly IMapper _mapper;
        
        public RegistroService(IUnidadTrabajo unidadTrabajo, IMapper mapper)
        {
            _unidadTrabajo = unidadTrabajo;
            _mapper = mapper;
        }
        
        public async Task<RespuestaData<List<RegistroDto>>> ObtenerTodosAsync()
        {
            try
            {
                var registros = await _unidadTrabajo.Registros.ObtenerRegistrosConDetallesAsync();
                var registrosDto = _mapper.Map<List<RegistroDto>>(registros);
                
                return RespuestaData<List<RegistroDto>>.Correcto(registrosDto, "Registros obtenidos correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<List<RegistroDto>>.Fallo($"Error al obtener registros: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<RegistroDto>> ObtenerPorIdAsync(int id)
        {
            try
            {
                var registro = await _unidadTrabajo.Registros.ObtenerRegistroPorIdConDetallesAsync(id);
                
                if (registro == null)
                    return RespuestaData<RegistroDto>.Fallo($"No se encontru00f3 el registro con ID: {id}");
                
                var registroDto = _mapper.Map<RegistroDto>(registro);
                
                return RespuestaData<RegistroDto>.Correcto(registroDto, "Registro obtenido correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<RegistroDto>.Fallo($"Error al obtener el registro: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<List<RegistroDto>>> ObtenerPorEstudianteIdAsync(int estudianteId)
        {
            try
            {
                // Validar si el estudiante existe
                var estudiante = await _unidadTrabajo.Estudiantes.ObtenerPorIdAsync(estudianteId);
                if (estudiante == null)
                {
                    return RespuestaData<List<RegistroDto>>.Fallo($"No existe el estudiante con ID: {estudianteId}");
                }

                var registros = await _unidadTrabajo.Registros.ObtenerRegistrosPorEstudianteIdAsync(estudianteId);
                var registrosDto = _mapper.Map<List<RegistroDto>>(registros);
                
                return RespuestaData<List<RegistroDto>>.Correcto(registrosDto, "Registros obtenidos correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<List<RegistroDto>>.Fallo($"Error al obtener registros: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<List<RegistroDto>>> ObtenerPorMateriaIdAsync(int materiaId)
        {
            try
            {
                var registros = await _unidadTrabajo.Registros.ObtenerRegistrosPorMateriaIdAsync(materiaId);
                var registrosDto = _mapper.Map<List<RegistroDto>>(registros);
                
                return RespuestaData<List<RegistroDto>>.Correcto(registrosDto, "Registros obtenidos correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<List<RegistroDto>>.Fallo($"Error al obtener registros: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<RegistroDto>> CrearAsync(RegistroDto registroDto)
        {
            try
            {
                // Verificar si existe el estudiante
                var estudiante = await _unidadTrabajo.Estudiantes.ObtenerPorIdAsync(registroDto.EstudianteId);
                if (estudiante == null)
                    return RespuestaData<RegistroDto>.Fallo($"No existe el estudiante con ID: {registroDto.EstudianteId}");
                
                // Verificar si existe la materia
                var materia = await _unidadTrabajo.Materias.ObtenerPorIdAsync(registroDto.MateriaId);
                if (materia == null)
                    return RespuestaData<RegistroDto>.Fallo($"No existe la materia con ID: {registroDto.MateriaId}");
                
                // Verificar si ya existe un registro para este estudiante y materia
                var existeRegistro = await _unidadTrabajo.Registros.ExisteAsync(
                    r => r.StudentId == registroDto.EstudianteId && r.SubjectId == registroDto.MateriaId);
                
                if (existeRegistro)
                    return RespuestaData<RegistroDto>.Fallo("Ya existe un registro para este estudiante y materia");
                
                var registro = _mapper.Map<Registration>(registroDto);
                registro.RegistrationDate = DateTime.Now; // Establecer la fecha actual
                
                await _unidadTrabajo.Registros.AgregarAsync(registro);
                await _unidadTrabajo.CompletarAsync();
                
                // Obtener el registro completo con los detalles
                var registroCreado = await _unidadTrabajo.Registros.ObtenerRegistroPorIdConDetallesAsync(registro.Id);
                var registroDtoCreado = _mapper.Map<RegistroDto>(registroCreado);
                
                return RespuestaData<RegistroDto>.Correcto(registroDtoCreado, "Registro creado correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<RegistroDto>.Fallo($"Error al crear el registro: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<RegistroDto>> CrearAsync(RegistroCreacionDto registroCreacionDto)
        {
            try
            {
                // Verificar si existe el estudiante
                var estudiante = await _unidadTrabajo.Estudiantes.ObtenerPorIdAsync(registroCreacionDto.EstudianteId);
                if (estudiante == null)
                    return RespuestaData<RegistroDto>.Fallo($"No existe el estudiante con ID: {registroCreacionDto.EstudianteId}");
                
                // Verificar si existe la materia
                var materia = await _unidadTrabajo.Materias.ObtenerPorIdAsync(registroCreacionDto.MateriaId);
                if (materia == null)
                    return RespuestaData<RegistroDto>.Fallo($"No existe la materia con ID: {registroCreacionDto.MateriaId}");
                
                // Verificar si ya existe un registro para este estudiante y materia
                var existeRegistro = await _unidadTrabajo.Registros.ExisteAsync(
                    r => r.StudentId == registroCreacionDto.EstudianteId && r.SubjectId == registroCreacionDto.MateriaId);
                
                if (existeRegistro)
                    return RespuestaData<RegistroDto>.Fallo("Ya existe un registro para este estudiante y materia");
                
                var registro = new Registration
                {
                    StudentId = registroCreacionDto.EstudianteId,
                    SubjectId = registroCreacionDto.MateriaId,
                    RegistrationDate = DateTime.Now // Establecer la fecha actual automu00e1ticamente
                };
                
                await _unidadTrabajo.Registros.AgregarAsync(registro);
                await _unidadTrabajo.CompletarAsync();
                
                // Obtener el registro completo con los detalles
                var registroCreado = await _unidadTrabajo.Registros.ObtenerRegistroPorIdConDetallesAsync(registro.Id);
                var registroDtoCreado = _mapper.Map<RegistroDto>(registroCreado);
                
                return RespuestaData<RegistroDto>.Correcto(registroDtoCreado, "Registro creado correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<RegistroDto>.Fallo($"Error al crear el registro: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<RegistroDto>> ActualizarAsync(int id, RegistroDto registroDto)
        {
            try
            {
                var registro = await _unidadTrabajo.Registros.ObtenerPorIdAsync(id);
                
                if (registro == null)
                    return RespuestaData<RegistroDto>.Fallo($"No se encontru00f3 el registro con ID: {id}");
                
                // Verificar si existe el estudiante
                var estudiante = await _unidadTrabajo.Estudiantes.ObtenerPorIdAsync(registroDto.EstudianteId);
                if (estudiante == null)
                    return RespuestaData<RegistroDto>.Fallo($"No existe el estudiante con ID: {registroDto.EstudianteId}");
                
                // Verificar si existe la materia
                var materia = await _unidadTrabajo.Materias.ObtenerPorIdAsync(registroDto.MateriaId);
                if (materia == null)
                    return RespuestaData<RegistroDto>.Fallo($"No existe la materia con ID: {registroDto.MateriaId}");
                
                // Verificar si ya existe otro registro para este estudiante y materia
                var existeRegistro = await _unidadTrabajo.Registros.ExisteAsync(
                    r => r.StudentId == registroDto.EstudianteId && r.SubjectId == registroDto.MateriaId && r.Id != id);
                
                if (existeRegistro)
                    return RespuestaData<RegistroDto>.Fallo("Ya existe otro registro para este estudiante y materia");
                
                registro.StudentId = registroDto.EstudianteId;
                registro.SubjectId = registroDto.MateriaId;
                
                await _unidadTrabajo.Registros.ActualizarAsync(registro);
                await _unidadTrabajo.CompletarAsync();
                
                // Obtener el registro actualizado con los detalles
                var registroActualizado = await _unidadTrabajo.Registros.ObtenerRegistroPorIdConDetallesAsync(id);
                var registroDtoActualizado = _mapper.Map<RegistroDto>(registroActualizado);
                
                return RespuestaData<RegistroDto>.Correcto(registroDtoActualizado, "Registro actualizado correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<RegistroDto>.Fallo($"Error al actualizar el registro: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<bool>> EliminarAsync(int id)
        {
            try
            {
                var registro = await _unidadTrabajo.Registros.ObtenerPorIdAsync(id);
                
                if (registro == null)
                    return RespuestaData<bool>.Fallo($"No se encontru00f3 el registro con ID: {id}");
                
                await _unidadTrabajo.Registros.EliminarAsync(registro);
                await _unidadTrabajo.CompletarAsync();
                
                return RespuestaData<bool>.Correcto(true, "Registro eliminado correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<bool>.Fallo($"Error al eliminar el registro: {ex.Message}");
            }
        }

        public async Task<RespuestaData<ProfesorEstudiantesResultDto>> ObtenerEstudiantesPorProfesorYMateriaAsync(ProfesorEstudiantesFilterDto filtro)
        {
            try
            {
                // Verificar si la materia existe y pertenece al profesor
                var materia = await _unidadTrabajo.Materias.ObtenerPorIdAsync(filtro.MateriaId);
                if (materia == null)
                    return RespuestaData<ProfesorEstudiantesResultDto>.Fallo($"No se encontró la materia con ID: {filtro.MateriaId}");

                if (materia.ProfessorId != filtro.ProfesorId)
                    return RespuestaData<ProfesorEstudiantesResultDto>.Fallo("El profesor no tiene acceso a esta materia");

                // Obtener los registros de la materia
                var registros = await _unidadTrabajo.Registros.ObtenerRegistrosPorMateriaIdAsync(filtro.MateriaId);
                var registrosDto = _mapper.Map<List<RegistroDto>>(registros);

                var respuesta = new ProfesorEstudiantesResultDto
                {
                    Registros = registrosDto,
                    MateriaId = filtro.MateriaId,
                    ProfesorId = filtro.ProfesorId
                };

                return RespuestaData<ProfesorEstudiantesResultDto>.Correcto(respuesta, "Estudiantes obtenidos correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<ProfesorEstudiantesResultDto>.Fallo($"Error al obtener estudiantes: {ex.Message}");
            }
        }
    }
}