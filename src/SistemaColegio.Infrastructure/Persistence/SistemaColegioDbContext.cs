using Microsoft.EntityFrameworkCore;
using SistemaColegio.Domain.Entities;
using SistemaColegio.Domain.Entities.Identity;

namespace SistemaColegio.Infrastructure.Persistence
{
    public class SistemaColegioDbContext : DbContext
    {
        public SistemaColegioDbContext(DbContextOptions<SistemaColegioDbContext> options) : base(options)
        {
          
        }
        
        public DbSet<Student> Estudiantes { get; set; }
        public DbSet<Professor> Profesores { get; set; }
        public DbSet<Subject> Materias { get; set; }
        public DbSet<Registration> Registros { get; set; }
        public DbSet<User> Users { get; set; }
        
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            
            modelBuilder.Entity<Student>(entity =>
            {
                entity.ToTable("Estudiantes");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Name).IsRequired().HasMaxLength(100);
                entity.Property(e => e.Email).IsRequired().HasMaxLength(100);
                entity.Property(e => e.StudentId).IsRequired().HasMaxLength(20);
                entity.Ignore(e => e.Nombre);
                
                entity.HasMany(e => e.Registrations)
                      .WithOne(r => r.Student)
                      .HasForeignKey(r => r.StudentId)
                      .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(s => s.User)
                      .WithOne(u => u.Student)
                      .HasForeignKey<Student>(s => s.UserId)
                      .OnDelete(DeleteBehavior.SetNull);
            });
            
            modelBuilder.Entity<Professor>(entity =>
            {
                entity.ToTable("Profesores");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Name).IsRequired().HasMaxLength(100);
                entity.Property(e => e.Email).IsRequired().HasMaxLength(100);
                entity.Property(e => e.Specialty).IsRequired().HasMaxLength(100);
                entity.Ignore(e => e.Department);
                entity.Ignore(e => e.Nombre);
            });
            
            modelBuilder.Entity<Subject>(entity =>
            {
                entity.ToTable("Materias");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Name).IsRequired().HasMaxLength(100);
                entity.Property(e => e.Code).IsRequired().HasMaxLength(20);
                entity.Property(e => e.Credits).IsRequired();
                entity.Property(e => e.ProfessorId).IsRequired(false);
                
                entity.HasOne(s => s.Professor)
                      .WithMany(p => p.Subjects)
                      .HasForeignKey(s => s.ProfessorId)
                      .OnDelete(DeleteBehavior.SetNull);
            });
            
            modelBuilder.Entity<Registration>(entity =>
            {
                entity.ToTable("Registros");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.RegistrationDate).IsRequired();
                
                entity.Property(e => e.StudentId).IsRequired();
                entity.Property(e => e.SubjectId).IsRequired();
                entity.Property(e => e.RegistrationDate).IsRequired();
                
                entity.HasOne(r => r.Student)
                      .WithMany(s => s.Registrations)
                      .HasForeignKey(r => r.StudentId)
                      .OnDelete(DeleteBehavior.Cascade);
                
                entity.HasOne(r => r.Subject)
                      .WithMany(s => s.Registrations)
                      .HasForeignKey(r => r.SubjectId)
                      .OnDelete(DeleteBehavior.Cascade);
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("Users");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Email).IsRequired().HasMaxLength(100);
                entity.Property(e => e.PasswordHash).IsRequired();
                entity.Property(e => e.Role).IsRequired().HasMaxLength(20);
                entity.Property(e => e.CreatedAt).IsRequired();
                
                entity.HasOne(u => u.Student)
                      .WithOne(s => s.User)
                      .HasForeignKey<Student>(s => s.UserId)
                      .OnDelete(DeleteBehavior.SetNull);
                
                entity.HasOne(u => u.Professor)
                      .WithOne()
                      .HasForeignKey<User>(u => u.ProfessorId)
                      .OnDelete(DeleteBehavior.SetNull);
            });
        }
    }
}