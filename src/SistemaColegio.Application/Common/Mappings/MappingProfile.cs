using System;
using AutoMapper;
using SistemaColegio.Application.Common.DTOs;
using SistemaColegio.Domain.Entities;

namespace SistemaColegio.Application.Common.Mappings
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Student, EstudianteDto>()
                .ForMember(dest => dest.Nombre, opt => opt.MapFrom(src => src.Name))
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.Email))
                .ForMember(dest => dest.Matricula, opt => opt.MapFrom(src => src.StudentId));
            
            CreateMap<EstudianteDto, Student>()
                .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Nombre))
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.Email))
                .ForMember(dest => dest.StudentId, opt => opt.MapFrom(src => src.Matricula));
            
            CreateMap<Professor, ProfesorDto>()
                .ForMember(dest => dest.Nombre, opt => opt.MapFrom(src => src.Name))
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.Email))
                .ForMember(dest => dest.Departamento, opt => opt.MapFrom(src => src.Specialty));
            
            CreateMap<ProfesorDto, Professor>()
                .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Nombre))
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.Email))
                .ForMember(dest => dest.Specialty, opt => opt.MapFrom(src => src.Departamento));
            
            CreateMap<Subject, MateriaDto>()
                .ForMember(dest => dest.Nombre, opt => opt.MapFrom(src => src.Name))
                .ForMember(dest => dest.Codigo, opt => opt.MapFrom(src => src.Code))
                .ForMember(dest => dest.Creditos, opt => opt.MapFrom(src => src.Credits))
                .ForMember(dest => dest.ProfesorId, opt => opt.MapFrom(src => src.ProfessorId))
                .ForMember(dest => dest.NombreProfesor, opt => opt.MapFrom(src => src.Professor != null ? src.Professor.Name : null));
            
            CreateMap<MateriaDto, Subject>()
                .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Nombre))
                .ForMember(dest => dest.Code, opt => opt.MapFrom(src => src.Codigo))
                .ForMember(dest => dest.Credits, opt => opt.MapFrom(src => src.Creditos))
                .ForMember(dest => dest.ProfessorId, opt => opt.MapFrom(src => src.ProfesorId));
            
            CreateMap<Registration, RegistroDto>()
                .ForMember(dest => dest.EstudianteId, opt => opt.MapFrom(src => src.StudentId))
                .ForMember(dest => dest.NombreEstudiante, opt => opt.MapFrom(src => src.Student != null ? src.Student.Name : null))
                .ForMember(dest => dest.MateriaId, opt => opt.MapFrom(src => src.SubjectId))
                .ForMember(dest => dest.NombreMateria, opt => opt.MapFrom(src => src.Subject != null ? src.Subject.Name : null))
                .ForMember(dest => dest.Creditos, opt => opt.MapFrom(src => src.Subject != null ? src.Subject.Credits : 0))
                .ForMember(dest => dest.NombreProfesor, opt => opt.MapFrom(src => src.Subject != null && src.Subject.Professor != null ? src.Subject.Professor.Name : null))
                .ForMember(dest => dest.FechaRegistro, opt => opt.MapFrom(src => src.RegistrationDate));
            
            CreateMap<RegistroDto, Registration>()
                .ForMember(dest => dest.StudentId, opt => opt.MapFrom(src => src.EstudianteId))
                .ForMember(dest => dest.SubjectId, opt => opt.MapFrom(src => src.MateriaId))
                .ForMember(dest => dest.RegistrationDate, opt => opt.MapFrom(src => src.FechaRegistro));
                
            // Mapeo para RegistroCreacionDto
            CreateMap<RegistroCreacionDto, Registration>()
                .ForMember(dest => dest.StudentId, opt => opt.MapFrom(src => src.EstudianteId))
                .ForMember(dest => dest.SubjectId, opt => opt.MapFrom(src => src.MateriaId))
                .ForMember(dest => dest.RegistrationDate, opt => opt.MapFrom(src => DateTime.Now)); // Establecer fecha actual
                
            CreateMap<RegistroCreacionDto, RegistroDto>()
                .ForMember(dest => dest.EstudianteId, opt => opt.MapFrom(src => src.EstudianteId))
                .ForMember(dest => dest.NombreEstudiante, opt => opt.MapFrom(src => src.NombreEstudiante))
                .ForMember(dest => dest.MateriaId, opt => opt.MapFrom(src => src.MateriaId))
                .ForMember(dest => dest.NombreMateria, opt => opt.MapFrom(src => src.NombreMateria))
                .ForMember(dest => dest.FechaRegistro, opt => opt.MapFrom(src => DateTime.Now)); // Establecer fecha actual
        }
    }
}