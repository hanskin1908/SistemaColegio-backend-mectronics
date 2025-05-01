-- Script para crear la base de datos inicial del Sistema de Colegio
-- Este script crea todas las tablas necesarias con las columnas correctas
-- para evitar errores de columnas faltantes

-- Crear la base de datos si no existe
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SistemaColegio')
BEGIN
    CREATE DATABASE SistemaColegio;
    PRINT 'Base de datos SistemaColegio creada';
END
ELSE
BEGIN
    PRINT 'La base de datos SistemaColegio ya existe';
END
GO

-- Usar la base de datos
USE SistemaColegio;
GO

-- Crear tabla de Estudiantes
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Estudiantes')
BEGIN
    CREATE TABLE Estudiantes (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL,
        Apellido NVARCHAR(100) NOT NULL,
        FechaNacimiento DATE NOT NULL,
        Direccion NVARCHAR(200),
        Telefono NVARCHAR(20),
        Email NVARCHAR(100),
        FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
        Activo BIT NOT NULL DEFAULT 1
    );
    PRINT 'Tabla Estudiantes creada';
END
ELSE
BEGIN
    PRINT 'La tabla Estudiantes ya existe';
END

-- Crear tabla de Materias
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Materias')
BEGIN
    CREATE TABLE Materias (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL,
        Descripcion NVARCHAR(500),
        Creditos INT NOT NULL DEFAULT 0,
        HorasSemanales INT NOT NULL DEFAULT 0,
        Activo BIT NOT NULL DEFAULT 1
    );
    PRINT 'Tabla Materias creada';
END
ELSE
BEGIN
    PRINT 'La tabla Materias ya existe';
END

-- Crear tabla de Profesores
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Profesores')
BEGIN
    CREATE TABLE Profesores (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL,
        Apellido NVARCHAR(100) NOT NULL,
        Especialidad NVARCHAR(100),
        Email NVARCHAR(100),
        Telefono NVARCHAR(20),
        FechaContratacion DATE NOT NULL DEFAULT GETDATE(),
        Activo BIT NOT NULL DEFAULT 1
    );
    PRINT 'Tabla Profesores creada';
END
ELSE
BEGIN
    PRINT 'La tabla Profesores ya existe';
END

-- Crear tabla de Registros (con todas las columnas necesarias en inglés y español)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Registros')
BEGIN
    CREATE TABLE Registros (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        -- Columnas en español
        EstudianteId INT NOT NULL,
        MateriaId INT NOT NULL,
        FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
        Calificacion DECIMAL(5,2),
        Observaciones NVARCHAR(500),
        -- Columnas en inglés (duplicadas para compatibilidad)
        StudentId INT NOT NULL,
        SubjectId INT NOT NULL,
        SubjectId1 INT NULL, -- Columna adicional que causaba error
        RegistrationDate DATETIME NOT NULL DEFAULT GETDATE(),
        -- Restricciones de clave foránea
        CONSTRAINT FK_Registros_Estudiantes FOREIGN KEY (EstudianteId) REFERENCES Estudiantes(Id),
        CONSTRAINT FK_Registros_Materias FOREIGN KEY (MateriaId) REFERENCES Materias(Id),
        -- Restricciones para mantener la integridad entre columnas duplicadas
        CONSTRAINT CK_Registros_EstudianteId_StudentId CHECK (EstudianteId = StudentId),
        CONSTRAINT CK_Registros_MateriaId_SubjectId CHECK (MateriaId = SubjectId),
        CONSTRAINT CK_Registros_FechaRegistro_RegistrationDate CHECK (FechaRegistro = RegistrationDate)
    );
    PRINT 'Tabla Registros creada';
    
    -- Crear un trigger para mantener sincronizadas las columnas duplicadas
    EXEC('CREATE TRIGGER TR_Registros_SyncColumns
    ON Registros
    AFTER INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
        
        -- Sincronizar StudentId y EstudianteId
        UPDATE Registros
        SET StudentId = i.EstudianteId
        FROM Registros r
        INNER JOIN inserted i ON r.Id = i.Id
        WHERE r.StudentId <> i.EstudianteId;
        
        UPDATE Registros
        SET EstudianteId = i.StudentId
        FROM Registros r
        INNER JOIN inserted i ON r.Id = i.Id
        WHERE r.EstudianteId <> i.StudentId;
        
        -- Sincronizar SubjectId y MateriaId
        UPDATE Registros
        SET SubjectId = i.MateriaId
        FROM Registros r
        INNER JOIN inserted i ON r.Id = i.Id
        WHERE r.SubjectId <> i.MateriaId;
        
        UPDATE Registros
        SET MateriaId = i.SubjectId
        FROM Registros r
        INNER JOIN inserted i ON r.Id = i.Id
        WHERE r.MateriaId <> i.SubjectId;
        
        -- Sincronizar SubjectId1 con SubjectId
        UPDATE Registros
        SET SubjectId1 = i.SubjectId
        FROM Registros r
        INNER JOIN inserted i ON r.Id = i.Id
        WHERE (r.SubjectId1 <> i.SubjectId OR r.SubjectId1 IS NULL) AND i.SubjectId IS NOT NULL;
        
        -- Sincronizar RegistrationDate y FechaRegistro
        UPDATE Registros
        SET RegistrationDate = i.FechaRegistro
        FROM Registros r
        INNER JOIN inserted i ON r.Id = i.Id
        WHERE r.RegistrationDate <> i.FechaRegistro;
        
        UPDATE Registros
        SET FechaRegistro = i.RegistrationDate
        FROM Registros r
        INNER JOIN inserted i ON r.Id = i.Id
        WHERE r.FechaRegistro <> i.RegistrationDate;
    END');
    PRINT 'Trigger de sincronización creado';
END
ELSE
BEGIN
    PRINT 'La tabla Registros ya existe';
    
    -- Verificar y agregar columnas faltantes si la tabla ya existe
    DECLARE @sql NVARCHAR(MAX) = '';
    
    -- Verificar columna EstudianteId
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'EstudianteId')
    BEGIN
        SET @sql = @sql + 'ALTER TABLE Registros ADD EstudianteId INT NOT NULL DEFAULT 0; ';
    END
    
    -- Verificar columna MateriaId
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'MateriaId')
    BEGIN
        SET @sql = @sql + 'ALTER TABLE Registros ADD MateriaId INT NOT NULL DEFAULT 0; ';
    END
    
    -- Verificar columna FechaRegistro
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'FechaRegistro')
    BEGIN
        SET @sql = @sql + 'ALTER TABLE Registros ADD FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(); ';
    END
    
    -- Verificar columna StudentId
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'StudentId')
    BEGIN
        SET @sql = @sql + 'ALTER TABLE Registros ADD StudentId INT NOT NULL DEFAULT 0; ';
    END
    
    -- Verificar columna SubjectId
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId')
    BEGIN
        SET @sql = @sql + 'ALTER TABLE Registros ADD SubjectId INT NOT NULL DEFAULT 0; ';
    END
    
    -- Verificar columna SubjectId1
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId1')
    BEGIN
        SET @sql = @sql + 'ALTER TABLE Registros ADD SubjectId1 INT NULL; ';
    END
    
    -- Verificar columna RegistrationDate
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'RegistrationDate')
    BEGIN
        SET @sql = @sql + 'ALTER TABLE Registros ADD RegistrationDate DATETIME NOT NULL DEFAULT GETDATE(); ';
    END
    
    -- Ejecutar las alteraciones si hay alguna
    IF @sql <> ''
    BEGIN
        EXEC sp_executesql @sql;
        PRINT 'Columnas faltantes agregadas a la tabla Registros';
        
        -- Sincronizar datos entre columnas equivalentes
        UPDATE Registros SET StudentId = EstudianteId WHERE StudentId <> EstudianteId;
        UPDATE Registros SET EstudianteId = StudentId WHERE EstudianteId <> StudentId;
        UPDATE Registros SET SubjectId = MateriaId WHERE SubjectId <> MateriaId;
        UPDATE Registros SET MateriaId = SubjectId WHERE MateriaId <> SubjectId;
        UPDATE Registros SET SubjectId1 = SubjectId WHERE (SubjectId1 <> SubjectId OR SubjectId1 IS NULL) AND SubjectId IS NOT NULL;
        UPDATE Registros SET RegistrationDate = FechaRegistro WHERE RegistrationDate <> FechaRegistro;
        UPDATE Registros SET FechaRegistro = RegistrationDate WHERE FechaRegistro <> RegistrationDate;
        PRINT 'Datos sincronizados entre columnas equivalentes';
    END
    
    -- Verificar si existe el trigger de sincronización
    IF NOT EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_Registros_SyncColumns')
    BEGIN
        EXEC('CREATE TRIGGER TR_Registros_SyncColumns
        ON Registros
        AFTER INSERT, UPDATE
        AS
        BEGIN
            SET NOCOUNT ON;
            
            -- Sincronizar StudentId y EstudianteId
            UPDATE Registros
            SET StudentId = i.EstudianteId
            FROM Registros r
            INNER JOIN inserted i ON r.Id = i.Id
            WHERE r.StudentId <> i.EstudianteId;
            
            UPDATE Registros
            SET EstudianteId = i.StudentId
            FROM Registros r
            INNER JOIN inserted i ON r.Id = i.Id
            WHERE r.EstudianteId <> i.StudentId;
            
            -- Sincronizar SubjectId y MateriaId
            UPDATE Registros
            SET SubjectId = i.MateriaId
            FROM Registros r
            INNER JOIN inserted i ON r.Id = i.Id
            WHERE r.SubjectId <> i.MateriaId;
            
            UPDATE Registros
            SET MateriaId = i.SubjectId
            FROM Registros r
            INNER JOIN inserted i ON r.Id = i.Id
            WHERE r.MateriaId <> i.SubjectId;
            
            -- Sincronizar SubjectId1 con SubjectId
            UPDATE Registros
            SET SubjectId1 = i.SubjectId
            FROM Registros r
            INNER JOIN inserted i ON r.Id = i.Id
            WHERE (r.SubjectId1 <> i.SubjectId OR r.SubjectId1 IS NULL) AND i.SubjectId IS NOT NULL;
            
            -- Sincronizar RegistrationDate y FechaRegistro
            UPDATE Registros
            SET RegistrationDate = i.FechaRegistro
            FROM Registros r
            INNER JOIN inserted i ON r.Id = i.Id
            WHERE r.RegistrationDate <> i.FechaRegistro;
            
            UPDATE Registros
            SET FechaRegistro = i.RegistrationDate
            FROM Registros r
            INNER JOIN inserted i ON r.Id = i.Id
            WHERE r.FechaRegistro <> i.RegistrationDate;
        END');
        PRINT 'Trigger de sincronización creado';
    END
END

-- Crear tabla de Aulas
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Aulas')
BEGIN
    CREATE TABLE Aulas (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nombre NVARCHAR(50) NOT NULL,
        Capacidad INT NOT NULL DEFAULT 0,
        Ubicacion NVARCHAR(100),
        Activo BIT NOT NULL DEFAULT 1
    );
    PRINT 'Tabla Aulas creada';
END
ELSE
BEGIN
    PRINT 'La tabla Aulas ya existe';
END

-- Crear tabla de Horarios
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Horarios')
BEGIN
    CREATE TABLE Horarios (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        MateriaId INT NOT NULL,
        ProfesorId INT NOT NULL,
        AulaId INT NOT NULL,
        DiaSemana TINYINT NOT NULL, -- 1=Lunes, 2=Martes, etc.
        HoraInicio TIME NOT NULL,
        HoraFin TIME NOT NULL,
        Activo BIT NOT NULL DEFAULT 1,
        CONSTRAINT FK_Horarios_Materias FOREIGN KEY (MateriaId) REFERENCES Materias(Id),
        CONSTRAINT FK_Horarios_Profesores FOREIGN KEY (ProfesorId) REFERENCES Profesores(Id),
        CONSTRAINT FK_Horarios_Aulas FOREIGN KEY (AulaId) REFERENCES Aulas(Id)
    );
    PRINT 'Tabla Horarios creada';
END
ELSE
BEGIN
    PRINT 'La tabla Horarios ya existe';
END

-- Crear tabla de Usuarios
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Usuarios')
BEGIN
    CREATE TABLE Usuarios (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        NombreUsuario NVARCHAR(50) NOT NULL UNIQUE,
        Contraseña NVARCHAR(100) NOT NULL,
        Nombre NVARCHAR(100) NOT NULL,
        Apellido NVARCHAR(100) NOT NULL,
        Email NVARCHAR(100),
        Rol NVARCHAR(20) NOT NULL, -- 'Admin', 'Profesor', 'Estudiante'
        FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
        UltimoAcceso DATETIME,
        Activo BIT NOT NULL DEFAULT 1
    );
    PRINT 'Tabla Usuarios creada';
END
ELSE
BEGIN
    PRINT 'La tabla Usuarios ya existe';
END

-- Insertar datos de ejemplo
-- Estudiantes
IF NOT EXISTS (SELECT TOP 1 * FROM Estudiantes)
BEGIN
    INSERT INTO Estudiantes (Nombre, Apellido, FechaNacimiento, Direccion, Telefono, Email)
    VALUES 
    ('Juan', 'Pérez', '2000-05-15', 'Calle Principal 123', '555-1234', 'juan.perez@email.com'),
    ('María', 'González', '2001-08-22', 'Avenida Central 456', '555-5678', 'maria.gonzalez@email.com'),
    ('Carlos', 'Rodríguez', '1999-11-10', 'Calle Secundaria 789', '555-9012', 'carlos.rodriguez@email.com'),
    ('Ana', 'Martínez', '2002-03-25', 'Boulevard Norte 321', '555-3456', 'ana.martinez@email.com'),
    ('Pedro', 'López', '2000-12-05', 'Calle Sur 654', '555-7890', 'pedro.lopez@email.com');
    
    PRINT 'Datos de ejemplo insertados en Estudiantes';
END

-- Materias
IF NOT EXISTS (SELECT TOP 1 * FROM Materias)
BEGIN
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales)
    VALUES 
    ('Matemáticas', 'Curso básico de matemáticas', 4, 6),
    ('Física', 'Principios fundamentales de física', 4, 6),
    ('Química', 'Introducción a la química', 3, 4),
    ('Historia', 'Historia universal', 3, 4),
    ('Literatura', 'Literatura clásica y contemporánea', 3, 4),
    ('Programación', 'Fundamentos de programación', 5, 8);
    
    PRINT 'Datos de ejemplo insertados en Materias';
END

-- Profesores
IF NOT EXISTS (SELECT TOP 1 * FROM Profesores)
BEGIN
    INSERT INTO Profesores (Nombre, Apellido, Especialidad, Email, Telefono, FechaContratacion)
    VALUES 
    ('Roberto', 'Gómez', 'Matemáticas', 'roberto.gomez@email.com', '555-2468', '2018-01-15'),
    ('Laura', 'Sánchez', 'Física', 'laura.sanchez@email.com', '555-1357', '2019-03-20'),
    ('Miguel', 'Torres', 'Química', 'miguel.torres@email.com', '555-3690', '2017-08-10'),
    ('Carmen', 'Díaz', 'Historia', 'carmen.diaz@email.com', '555-4812', '2020-02-05'),
    ('Javier', 'Ruiz', 'Literatura', 'javier.ruiz@email.com', '555-9753', '2018-09-12'),
    ('Sofía', 'Vargas', 'Programación', 'sofia.vargas@email.com', '555-8642', '2021-01-10');
    
    PRINT 'Datos de ejemplo insertados en Profesores';
END

-- Aulas
IF NOT EXISTS (SELECT TOP 1 * FROM Aulas)
BEGIN
    INSERT INTO Aulas (Nombre, Capacidad, Ubicacion)
    VALUES 
    ('A101', 30, 'Edificio A, Primer Piso'),
    ('A102', 25, 'Edificio A, Primer Piso'),
    ('B201', 40, 'Edificio B, Segundo Piso'),
    ('B202', 35, 'Edificio B, Segundo Piso'),
    ('C301', 50, 'Edificio C, Tercer Piso'),
    ('LAB101', 20, 'Laboratorio, Primer Piso');
    
    PRINT 'Datos de ejemplo insertados en Aulas';
END

-- Registros (con columnas en inglés y español sincronizadas)
IF NOT EXISTS (SELECT TOP 1 * FROM Registros)
BEGIN
    -- Insertar registros asegurando que las columnas duplicadas tengan los mismos valores
    INSERT INTO Registros (EstudianteId, MateriaId, FechaRegistro, Calificacion, Observaciones, StudentId, SubjectId, SubjectId1, RegistrationDate)
    VALUES 
    (1, 1, GETDATE(), 85.5, 'Buen desempeño', 1, 1, 1, GETDATE()),
    (1, 2, GETDATE(), 78.0, 'Necesita mejorar en laboratorio', 1, 2, 2, GETDATE()),
    (2, 1, GETDATE(), 92.0, 'Excelente participación', 2, 1, 1, GETDATE()),
    (2, 3, GETDATE(), 88.5, 'Muy buen trabajo en equipo', 2, 3, 3, GETDATE()),
    (3, 4, GETDATE(), 79.0, 'Debe mejorar en exposiciones', 3, 4, 4, GETDATE()),
    (3, 5, GETDATE(), 91.0, 'Excelente análisis literario', 3, 5, 5, GETDATE()),
    (4, 6, GETDATE(), 95.0, 'Destacado en programación', 4, 6, 6, GETDATE()),
    (5, 6, GETDATE(), 82.0, 'Buen avance en el curso', 5, 6, 6, GETDATE());
    
    PRINT 'Datos de ejemplo insertados en Registros';
END

-- Horarios
IF NOT EXISTS (SELECT TOP 1 * FROM Horarios)
BEGIN
    INSERT INTO Horarios (MateriaId, ProfesorId, AulaId, DiaSemana, HoraInicio, HoraFin)
    VALUES 
    (1, 1, 1, 1, '08:00', '10:00'), -- Matemáticas, Lunes
    (1, 1, 1, 3, '08:00', '10:00'), -- Matemáticas, Miércoles
    (2, 2, 2, 2, '10:30', '12:30'), -- Física, Martes
    (2, 2, 2, 4, '10:30', '12:30'), -- Física, Jueves
    (3, 3, 3, 1, '13:00', '15:00'), -- Química, Lunes
    (3, 3, 3, 3, '13:00', '15:00'), -- Química, Miércoles
    (4, 4, 4, 2, '15:30', '17:30'), -- Historia, Martes
    (4, 4, 4, 4, '15:30', '17:30'), -- Historia, Jueves
    (5, 5, 5, 5, '08:00', '10:00'), -- Literatura, Viernes
    (6, 6, 6, 5, '10:30', '14:30'); -- Programación, Viernes (clase larga)
    
    PRINT 'Datos de ejemplo insertados en Horarios';
END

-- Usuarios
IF NOT EXISTS (SELECT TOP 1 * FROM Usuarios)
BEGIN
    -- Nota: En un sistema real, las contraseñas deberían estar hasheadas
    INSERT INTO Usuarios (NombreUsuario, Contraseña, Nombre, Apellido, Email, Rol)
    VALUES 
    ('admin', 'admin123', 'Administrador', 'Sistema', 'admin@colegio.edu', 'Admin'),
    ('prof1', 'prof123', 'Roberto', 'Gómez', 'roberto.gomez@email.com', 'Profesor'),
    ('prof2', 'prof123', 'Laura', 'Sánchez', 'laura.sanchez@email.com', 'Profesor'),
    ('est1', 'est123', 'Juan', 'Pérez', 'juan.perez@email.com', 'Estudiante'),
    ('est2', 'est123', 'María', 'González', 'maria.gonzalez@email.com', 'Estudiante');
    
    PRINT 'Datos de ejemplo insertados en Usuarios';
END

PRINT 'Inicialización de la base de datos completada con éxito';
GO