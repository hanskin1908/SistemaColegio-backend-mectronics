using Microsoft.EntityFrameworkCore;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Entities.Identity;
using System;
using System.Linq;
using System.Threading.Tasks;
using BCrypt.Net;

namespace SistemaColegio.Infrastructure.Persistence
{
    public static class SeedData
    {
        public static async Task Initialize(SistemaColegioDbContext context)
        {
            await context.Database.MigrateAsync();

            // Seed Users if empty
            if (!context.Users.Any())
            {
                var adminUser = new User
                {
                    Email = "admin@sistemacolegio.com",
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("Admin123!"),
                    Role = "admin",
                    CreatedAt = DateTime.Now
                };

                context.Users.Add(adminUser);
                await context.SaveChangesAsync();
            }

            // Seed Professors if empty
            if (!context.Profesores.Any())
            {
                var professors = new[]
                {
                    new Professor
                    {
                        Name = "Dr. Juan Pérez",
                        Email = "juan.perez@sistemacolegio.com",
                        Specialty = "Matemáticas"
                    },
                    new Professor
                    {
                        Name = "Dra. María García",
                        Email = "maria.garcia@sistemacolegio.com",
                        Specialty = "Física"
                    },
                    new Professor
                    {
                        Name = "Dr. Carlos Rodríguez",
                        Email = "carlos.rodriguez@sistemacolegio.com",
                        Specialty = "Química"
                    },
                    new Professor
                    {
                        Name = "Dra. Ana Martínez",
                        Email = "ana.martinez@sistemacolegio.com",
                        Specialty = "Biología"
                    },
                    new Professor
                    {
                        Name = "Dr. Luis Torres",
                        Email = "luis.torres@sistemacolegio.com",
                        Specialty = "Programación"
                    }
                };

                context.Profesores.AddRange(professors);
                await context.SaveChangesAsync();
            }

            // Seed Subjects if empty
            if (!context.Materias.Any())
            {
                var professors = await context.Profesores.ToListAsync();
                
                var subjects = new[]
                {
                    new Subject
                    {
                        Name = "Cálculo Diferencial",
                        Code = "MAT101",
                        Credits = 4,
                        ProfessorId = professors[0].Id  // Matemáticas
                    },
                    new Subject
                    {
                        Name = "Cálculo Integral",
                        Code = "MAT102",
                        Credits = 4,
                        ProfessorId = professors[0].Id  // Matemáticas
                    },
                    new Subject
                    {
                        Name = "Física Mecánica",
                        Code = "FIS101",
                        Credits = 4,
                        ProfessorId = professors[1].Id  // Física
                    },
                    new Subject
                    {
                        Name = "Física Electromagnética",
                        Code = "FIS102",
                        Credits = 4,
                        ProfessorId = professors[1].Id  // Física
                    },
                    new Subject
                    {
                        Name = "Química General",
                        Code = "QUI101",
                        Credits = 3,
                        ProfessorId = professors[2].Id  // Química
                    },
                    new Subject
                    {
                        Name = "Química Orgánica",
                        Code = "QUI102",
                        Credits = 3,
                        ProfessorId = professors[2].Id  // Química
                    },
                    new Subject
                    {
                        Name = "Biología Celular",
                        Code = "BIO101",
                        Credits = 3,
                        ProfessorId = professors[3].Id  // Biología
                    },
                    new Subject
                    {
                        Name = "Genética",
                        Code = "BIO102",
                        Credits = 3,
                        ProfessorId = professors[3].Id  // Biología
                    },
                    new Subject
                    {
                        Name = "Programación Básica",
                        Code = "PRG101",
                        Credits = 4,
                        ProfessorId = professors[4].Id  // Programación
                    },
                    new Subject
                    {
                        Name = "Estructuras de Datos",
                        Code = "PRG102",
                        Credits = 4,
                        ProfessorId = professors[4].Id  // Programación
                    }
                };

                context.Materias.AddRange(subjects);
                await context.SaveChangesAsync();
            }
        }
    }
}