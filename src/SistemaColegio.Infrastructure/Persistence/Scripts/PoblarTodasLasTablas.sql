-- Script para poblar todas las tablas del Sistema Colegio
-- Basado en SistemaColegioDbContext
-- Incluye: Profesores, Estudiantes, Materias, Registros y Users

USE SistemaColegio;
GO

-- Desactivar temporalmente las restricciones de clave foránea para facilitar la carga de datos
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';

-- 1. POBLAR TABLA PROFESORES
-- ===========================
PRINT 'Poblando tabla Profesores...';

-- Verificar si ya hay datos en la tabla
IF (SELECT COUNT(*) FROM Profesores) = 0
BEGIN
    -- Insertar profesores de ejemplo
    INSERT INTO Profesores (Name, Nombre, Apellido, Specialty, Email, Telefono, FechaContratacion, Activo)
    VALUES 
        ('Juan Pérez', 'Juan', 'Pérez', 'Matemáticas', 'juan.perez@colegio.edu', '555-1234', DATEADD(YEAR, -5, GETDATE()), 1),
        ('María González', 'María', 'González', 'Ciencias', 'maria.gonzalez@colegio.edu', '555-2345', DATEADD(YEAR, -3, GETDATE()), 1),
        ('Carlos Rodríguez', 'Carlos', 'Rodríguez', 'Historia', 'carlos.rodriguez@colegio.edu', '555-3456', DATEADD(YEAR, -4, GETDATE()), 1),
        ('Ana Martínez', 'Ana', 'Martínez', 'Literatura', 'ana.martinez@colegio.edu', '555-4567', DATEADD(YEAR, -2, GETDATE()), 1),
        ('Roberto Sánchez', 'Roberto', 'Sánchez', 'Física', 'roberto.sanchez@colegio.edu', '555-5678', DATEADD(YEAR, -3, GETDATE()), 1),
        ('Laura López', 'Laura', 'López', 'Química', 'laura.lopez@colegio.edu', '555-6789', DATEADD(YEAR, -1, GETDATE()), 1),
        ('Miguel Torres', 'Miguel', 'Torres', 'Educación Física', 'miguel.torres@colegio.edu', '555-7890', DATEADD(YEAR, -2, GETDATE()), 1),
        ('Carmen Díaz', 'Carmen', 'Díaz', 'Inglés', 'carmen.diaz@colegio.edu', '555-8901', DATEADD(YEAR, -4, GETDATE()), 1),
        ('Javier Ruiz', 'Javier', 'Ruiz', 'Informática', 'javier.ruiz@colegio.edu', '555-9012', DATEADD(YEAR, -1, GETDATE()), 1),
        ('Patricia Gómez', 'Patricia', 'Gómez', 'Arte', 'patricia.gomez@colegio.edu', '555-0123', DATEADD(YEAR, -2, GETDATE()), 1);
        
    PRINT 'Se han insertado 10 profesores de ejemplo.';
END
ELSE
BEGIN
    PRINT 'La tabla Profesores ya contiene datos. No se insertaron nuevos registros.';
END

-- 2. POBLAR TABLA ESTUDIANTES
-- ===========================
PRINT 'Poblando tabla Estudiantes...';

-- Verificar si ya hay datos en la tabla
IF (SELECT COUNT(*) FROM Estudiantes) = 0
BEGIN
    -- Insertar estudiantes de ejemplo
    INSERT INTO Estudiantes (Name, Nombre, Apellido, FechaNacimiento, Direccion, Telefono, Email, FechaRegistro, Activo, StudentId)
    VALUES 
        ('Alejandro García', 'Alejandro', 'García', '2005-03-15', 'Calle Principal 123', '555-1111', 'alejandro.garcia@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST001'),
        ('Sofía Martínez', 'Sofía', 'Martínez', '2006-07-22', 'Avenida Central 456', '555-2222', 'sofia.martinez@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST002'),
        ('Daniel López', 'Daniel', 'López', '2005-11-10', 'Calle Secundaria 789', '555-3333', 'daniel.lopez@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST003'),
        ('Valentina Rodríguez', 'Valentina', 'Rodríguez', '2006-04-05', 'Avenida Norte 321', '555-4444', 'valentina.rodriguez@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST004'),
        ('Mateo Hernández', 'Mateo', 'Hernández', '2005-09-18', 'Calle Sur 654', '555-5555', 'mateo.hernandez@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST005'),
        ('Isabella Díaz', 'Isabella', 'Díaz', '2006-01-30', 'Avenida Este 987', '555-6666', 'isabella.diaz@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST006'),
        ('Santiago Pérez', 'Santiago', 'Pérez', '2005-06-12', 'Calle Oeste 159', '555-7777', 'santiago.perez@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST007'),
        ('Camila Sánchez', 'Camila', 'Sánchez', '2006-10-25', 'Avenida Principal 753', '555-8888', 'camila.sanchez@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST008'),
        ('Sebastián Torres', 'Sebastián', 'Torres', '2005-02-08', 'Calle Central 951', '555-9999', 'sebastian.torres@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST009'),
        ('Valeria Flores', 'Valeria', 'Flores', '2006-08-17', 'Avenida Secundaria 357', '555-0000', 'valeria.flores@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST010'),
        ('Nicolás González', 'Nicolás', 'González', '2005-12-03', 'Calle Norte 852', '555-1212', 'nicolas.gonzalez@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST011'),
        ('Luciana Ruiz', 'Luciana', 'Ruiz', '2006-05-20', 'Avenida Sur 456', '555-2323', 'luciana.ruiz@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST012'),
        ('Emilio Gómez', 'Emilio', 'Gómez', '2005-08-11', 'Calle Este 789', '555-3434', 'emilio.gomez@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST013'),
        ('Mariana Castro', 'Mariana', 'Castro', '2006-02-28', 'Avenida Oeste 123', '555-4545', 'mariana.castro@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST014'),
        ('Tomás Vargas', 'Tomás', 'Vargas', '2005-04-14', 'Calle Principal 456', '555-5656', 'tomas.vargas@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST015');
        
    PRINT 'Se han insertado 15 estudiantes de ejemplo.';
END
ELSE
BEGIN
    PRINT 'La tabla Estudiantes ya contiene datos. No se insertaron nuevos registros.';
END

-- 3. POBLAR TABLA MATERIAS
-- ========================
PRINT 'Poblando tabla Materias...';

-- Obtener IDs de profesores para asignar a las materias
DECLARE @ProfesorMatematicas INT, @ProfesorFisica INT, @ProfesorHistoria INT, @ProfesorLiteratura INT;
DECLARE @ProfesorQuimica INT, @ProfesorEducacionFisica INT, @ProfesorIngles INT, @ProfesorInformatica INT;
DECLARE @ProfesorArte INT, @ProfesorCiencias INT;

-- Obtener IDs de profesores por especialidad
SELECT TOP 1 @ProfesorMatematicas = Id FROM Profesores WHERE Specialty = 'Matemáticas';
SELECT TOP 1 @ProfesorFisica = Id FROM Profesores WHERE Specialty = 'Física';
SELECT TOP 1 @ProfesorHistoria = Id FROM Profesores WHERE Specialty = 'Historia';
SELECT TOP 1 @ProfesorLiteratura = Id FROM Profesores WHERE Specialty = 'Literatura';
SELECT TOP 1 @ProfesorQuimica = Id FROM Profesores WHERE Specialty = 'Química';
SELECT TOP 1 @ProfesorEducacionFisica = Id FROM Profesores WHERE Specialty = 'Educación Física';
SELECT TOP 1 @ProfesorIngles = Id FROM Profesores WHERE Specialty = 'Inglés';
SELECT TOP 1 @ProfesorInformatica = Id FROM Profesores WHERE Specialty = 'Informática';
SELECT TOP 1 @ProfesorArte = Id FROM Profesores WHERE Specialty = 'Arte';
SELECT TOP 1 @ProfesorCiencias = Id FROM Profesores WHERE Specialty = 'Ciencias';

-- Si alguna variable es NULL, asignar un profesor aleatorio
DECLARE @ProfesorAleatorio INT;
SELECT TOP 1 @ProfesorAleatorio = Id FROM Profesores ORDER BY NEWID();

IF @ProfesorMatematicas IS NULL SET @ProfesorMatematicas = @ProfesorAleatorio;
IF @ProfesorFisica IS NULL SET @ProfesorFisica = @ProfesorAleatorio;
IF @ProfesorHistoria IS NULL SET @ProfesorHistoria = @ProfesorAleatorio;
IF @ProfesorLiteratura IS NULL SET @ProfesorLiteratura = @ProfesorAleatorio;
IF @ProfesorQuimica IS NULL SET @ProfesorQuimica = @ProfesorAleatorio;
IF @ProfesorEducacionFisica IS NULL SET @ProfesorEducacionFisica = @ProfesorAleatorio;
IF @ProfesorIngles IS NULL SET @ProfesorIngles = @ProfesorAleatorio;
IF @ProfesorInformatica IS NULL SET @ProfesorInformatica = @ProfesorAleatorio;
IF @ProfesorArte IS NULL SET @ProfesorArte = @ProfesorAleatorio;
IF @ProfesorCiencias IS NULL SET @ProfesorCiencias = @ProfesorAleatorio;

-- Verificar si ya hay datos en la tabla
IF (SELECT COUNT(*) FROM Materias) = 0
BEGIN
    -- Insertar materias de ejemplo
    -- Matemáticas
    INSERT INTO Materias (Name, Nombre, Descripcion, Credits, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Matemáticas I', 'Matemáticas I', 'Fundamentos de álgebra y aritmética', 4, 6, 1, @ProfesorMatematicas, 'MAT101');
    
    INSERT INTO Materias (Name, Nombre, Descripcion, Credits, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Matemáticas II', 'Matemáticas II', 'Geometría y trigonometría', 4, 6, 1, @ProfesorMatematicas, 'MAT102');
    
    INSERT INTO Materias (Name, Nombre, Descripcion, Credits, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Cálculo I', 'Cálculo I', 'Introducción al cálculo diferencial', 5, 8, 1, @ProfesorMatematicas, 'MAT201');
    
    -- Ciencias
    INSERT INTO Materias (Name, Nombre, Descripcion, Credits, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Física I', 'Física I', 'Mecánica clásica', 4, 6, 1, @ProfesorFisica, 'FIS101');
    
    INSERT INTO Materias (Name, Nombre, Descripcion, Credits, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Física II', 'Física II', 'Electricidad y magnetismo', 4, 6, 1, @ProfesorFisica, 'FIS102');
    
    INSERT INTO Materias (Name, Nombre, Descripcion, Credits, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Química General', 'Química General', 'Principios básicos de química', 4, 6, 1, @ProfesorQuimica, 'QUI101');
    
    -- Humanidades
    INSERT INTO Materias (Name, Nombre, Descripcion, Credits, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Historia Universal', 'Historia Universal', 'Principales acontecimientos históricos mundiales', 3, 4, 1, @ProfesorHistoria, 'HIS101');
    
    INSERT INTO Materias (Name, Nombre, Descripcion, Credits, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Literatura Universal', 'Literatura Universal', 'Obras clásicas de la literatura mundial', 3, 4, 1, @ProfesorLiteratura, 'LIT101');
    
    -- Idiomas
    INSERT INTO Materias (Name, Nombre, Descripcion, Credits, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Inglés Básico', 'Inglés Básico', 'Fundamentos del idioma inglés', 3, 4, 1, @ProfesorIngles, 'ING101');
    
    -- Tecnología
    INSERT INTO Materias (Name, Nombre, Descripcion, Credits, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Informática Básica', 'Informática Básica', 'Introducción a la informática', 3, 4, 1, @ProfesorInformatica, 'INF101');
    
    PRINT 'Se han insertado 10 materias de ejemplo.';
END
ELSE
BEGIN
    PRINT 'La tabla Materias ya contiene datos. No se insertaron nuevos registros.';
END

-- 4. POBLAR TABLA REGISTROS (INSCRIPCIONES)
-- ========================================
PRINT 'Poblando tabla Registros...';

-- Verificar si ya hay datos en la tabla
IF (SELECT COUNT(*) FROM Registros) = 0
BEGIN
    -- Crear tabla temporal para almacenar combinaciones de estudiante-materia
    CREATE TABLE #TempRegistros (
        EstudianteId INT,
        MateriaId INT,
        Calificacion DECIMAL(5,2),
        FechaRegistro DATETIME
    );
    
    -- Insertar combinaciones aleatorias en la tabla temporal
    -- Cada estudiante se inscribe en 3-5 materias diferentes
    
    -- Obtener todos los estudiantes
    DECLARE @EstudianteId INT;
    DECLARE @CursorEstudiantes CURSOR;
    
    SET @CursorEstudiantes = CURSOR FOR
    SELECT Id FROM Estudiantes;
    
    OPEN @CursorEstudiantes;
    FETCH NEXT FROM @CursorEstudiantes INTO @EstudianteId;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Determinar cuántas materias tomará este estudiante (entre 3 y 5)
        DECLARE @NumMaterias INT = FLOOR(RAND() * 3) + 3;
        
        -- Insertar registros para este estudiante
        INSERT INTO #TempRegistros (EstudianteId, MateriaId, Calificacion, FechaRegistro)
        SELECT TOP (@NumMaterias)
            @EstudianteId,
            Id,
            CAST(RAND() * 4 + 6 AS DECIMAL(5,2)), -- Calificación entre 6.00 y 10.00
            DATEADD(DAY, -FLOOR(RAND() * 180), GETDATE()) -- Fecha en los últimos 6 meses
        FROM Materias
        ORDER BY NEWID(); -- Selección aleatoria de materias
        
        FETCH NEXT FROM @CursorEstudiantes INTO @EstudianteId;
    END
    
    CLOSE @CursorEstudiantes;
    DEALLOCATE @CursorEstudiantes;
    
    -- Insertar registros desde la tabla temporal a la tabla real
    INSERT INTO Registros (EstudianteId, MateriaId, Calificacion, FechaRegistro)
    SELECT EstudianteId, MateriaId, Calificacion, FechaRegistro
    FROM #TempRegistros;
    
    -- Eliminar tabla temporal
    DROP TABLE #TempRegistros;
    
    PRINT 'Se han insertado registros de inscripción para todos los estudiantes.';
END
ELSE
BEGIN
    PRINT 'La tabla Registros ya contiene datos. No se insertaron nuevos registros.';
END

-- 5. POBLAR TABLA USERS
-- =====================
PRINT 'Poblando tabla Users...';

-- Verificar si ya hay datos en la tabla
IF (SELECT COUNT(*) FROM Users) = 0
BEGIN
    -- 1. Crear usuario administrador
    INSERT INTO Users (Email, PasswordHash, Role, CreatedAt, LastLogin, Activo)
    VALUES ('admin@colegio.edu', 
            CONVERT(VARBINARY(64), HASHBYTES('SHA2_512', 'Admin123!')), -- Contraseña hasheada
            'Admin', 
            GETDATE(), 
            GETDATE(), 
            1);
    
    -- 2. Crear usuarios para profesores
    INSERT INTO Users (Email, PasswordHash, Role, CreatedAt, LastLogin, Activo, ProfessorId)
    SELECT 
        Email, 
        CONVERT(VARBINARY(64), HASHBYTES('SHA2_512', 'Profesor123!')), -- Contraseña hasheada
        'Professor', 
        GETDATE(), 
        GETDATE(), 
        1,
        Id
    FROM Profesores;
    
    -- 3. Crear usuarios para estudiantes
    INSERT INTO Users (Email, PasswordHash, Role, CreatedAt, LastLogin, Activo, StudentId)
    SELECT 
        Email, 
        CONVERT(VARBINARY(64), HASHBYTES('SHA2_512', 'Estudiante123!')), -- Contraseña hasheada
        'Student', 
        GETDATE(), 
        GETDATE(), 
        1,
        Id
    FROM Estudiantes;
    
    PRINT 'Se han creado usuarios para administrador, profesores y estudiantes.';
END
ELSE
BEGIN
    PRINT 'La tabla Users ya contiene datos. No se insertaron nuevos registros.';
END

-- Reactivar las restricciones de clave foránea
EXEC sp_MSforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL';

PRINT 'Proceso de población de tablas completado exitosamente.';
GO