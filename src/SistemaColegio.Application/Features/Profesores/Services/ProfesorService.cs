using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using AutoMapper;
using SistemaColegio.Application.Common.DTOs;
using SistemaColegio.Application.Common.Responses;
using SistemaColegio.Application.Features.Profesores.Interfaces;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Interfaces;

namespace SistemaColegio.Application.Features.Profesores.Services
{
    public class ProfesorService : IProfesorService
    {
        private readonly IUnidadTrabajo _unidadTrabajo;
        private readonly IMapper _mapper;
        
        public ProfesorService(IUnidadTrabajo unidadTrabajo, IMapper mapper)
        {
            _unidadTrabajo = unidadTrabajo;
            _mapper = mapper;
        }
        
        public async Task<RespuestaData<List<ProfesorDto>>> ObtenerTodosAsync()
        {
            try
            {
                var profesores = await _unidadTrabajo.Profesores.ObtenerProfesoresConMateriasAsync();
                var profesoresDto = _mapper.Map<List<ProfesorDto>>(profesores);
                
                return RespuestaData<List<ProfesorDto>>.Correcto(profesoresDto, "Profesores obtenidos correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<List<ProfesorDto>>.Fallo($"Error al obtener profesores: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<ProfesorDto>> ObtenerPorIdAsync(int id)
        {
            try
            {
                var profesor = await _unidadTrabajo.Profesores.ObtenerPorIdAsync(id);
                
                if (profesor == null)
                    return RespuestaData<ProfesorDto>.Fallo($"No se encontró el profesor con ID: {id}");
                
                var profesorDto = _mapper.Map<ProfesorDto>(profesor);
                
                // Obtener materias del profesor
                var materias = await _unidadTrabajo.Materias.ObtenerMateriasPorProfesorIdAsync(id);
                profesorDto.Materias = _mapper.Map<List<MateriaDto>>(materias);
                
                return RespuestaData<ProfesorDto>.Correcto(profesorDto, "Profesor obtenido correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<ProfesorDto>.Fallo($"Error al obtener el profesor: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<ProfesorDto>> ObtenerPorEmailAsync(string email)
        {
            try
            {
                var profesor = await _unidadTrabajo.Profesores.ObtenerProfesorPorEmailAsync(email);
                
                if (profesor == null)
                    return RespuestaData<ProfesorDto>.Fallo($"No se encontró el profesor con email: {email}");
                
                var profesorDto = _mapper.Map<ProfesorDto>(profesor);
                
                return RespuestaData<ProfesorDto>.Correcto(profesorDto, "Profesor obtenido correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<ProfesorDto>.Fallo($"Error al obtener el profesor: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<ProfesorDto>> CrearAsync(ProfesorDto profesorDto)
        {
            try
            {
                // Verificar si ya existe un profesor con el mismo email
                var existeProfesor = await _unidadTrabajo.Profesores.ExisteAsync(p => p.Email == profesorDto.Email);
                
                if (existeProfesor)
                    return RespuestaData<ProfesorDto>.Fallo($"Ya existe un profesor con el email: {profesorDto.Email}");
                
                var profesor = _mapper.Map<Professor>(profesorDto);
                
                await _unidadTrabajo.Profesores.AgregarAsync(profesor);
                await _unidadTrabajo.CompletarAsync();
                
                profesorDto.Id = profesor.Id;
                
                return RespuestaData<ProfesorDto>.Correcto(profesorDto, "Profesor creado correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<ProfesorDto>.Fallo($"Error al crear el profesor: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<ProfesorDto>> ActualizarAsync(int id, ProfesorDto profesorDto)
        {
            try
            {
                var profesor = await _unidadTrabajo.Profesores.ObtenerPorIdAsync(id);
                
                if (profesor == null)
                    return RespuestaData<ProfesorDto>.Fallo($"No se encontró el profesor con ID: {id}");
                
                // Verificar si ya existe otro profesor con el mismo email
                var existeProfesor = await _unidadTrabajo.Profesores.ExisteAsync(p => p.Email == profesorDto.Email && p.Id != id);
                
                if (existeProfesor)
                    return RespuestaData<ProfesorDto>.Fallo($"Ya existe otro profesor con el email: {profesorDto.Email}");
                
                profesor.Name = profesorDto.Nombre;
                profesor.Email = profesorDto.Email;
                profesor.Specialty = profesorDto.Departamento;
                
                await _unidadTrabajo.Profesores.ActualizarAsync(profesor);
                await _unidadTrabajo.CompletarAsync();
                
                profesorDto.Id = profesor.Id;
                
                return RespuestaData<ProfesorDto>.Correcto(profesorDto, "Profesor actualizado correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<ProfesorDto>.Fallo($"Error al actualizar el profesor: {ex.Message}");
            }
        }
        
        public async Task<RespuestaData<bool>> EliminarAsync(int id)
        {
            try
            {
                var profesor = await _unidadTrabajo.Profesores.ObtenerPorIdAsync(id);
                
                if (profesor == null)
                    return RespuestaData<bool>.Fallo($"No se encontró el profesor con ID: {id}");
                
                await _unidadTrabajo.Profesores.EliminarAsync(profesor);
                await _unidadTrabajo.CompletarAsync();
                
                return RespuestaData<bool>.Correcto(true, "Profesor eliminado correctamente");
            }
            catch (Exception ex)
            {
                return RespuestaData<bool>.Fallo($"Error al eliminar el profesor: {ex.Message}");
            }
        }
    }
}