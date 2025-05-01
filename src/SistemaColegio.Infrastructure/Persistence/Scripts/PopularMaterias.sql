-- Script para poblar la tabla Materias utilizando datos de la tabla Subjects (si existe)
-- Este script verifica primero si la tabla Subjects existe y tiene datos
-- Luego inserta los datos en la tabla Materias teniendo en cuenta las relaciones

USE SistemaColegio;
GO

-- Verificar si existen profesores, si no, crear algunos profesores de ejemplo
IF (SELECT COUNT(*) FROM Profesores) = 0
BEGIN
    PRINT 'No hay profesores en la base de datos. Insertando profesores de ejemplo...';
    
    INSERT INTO Profesores (Nombre, Apellido, Especialidad, Email, Telefono, FechaContratacion, Activo)
    VALUES 
        ('Juan', 'Pérez', 'Matemáticas', 'juan.perez@colegio.edu', '555-1234', GETDATE(), 1),
        ('María', 'González', 'Ciencias', 'maria.gonzalez@colegio.edu', '555-2345', GETDATE(), 1),
        ('Carlos', 'Rodríguez', 'Historia', 'carlos.rodriguez@colegio.edu', '555-3456', GETDATE(), 1),
        ('Ana', 'Martínez', 'Literatura', 'ana.martinez@colegio.edu', '555-4567', GETDATE(), 1),
        ('Roberto', 'Sánchez', 'Física', 'roberto.sanchez@colegio.edu', '555-5678', GETDATE(), 1);
        
    PRINT 'Profesores de ejemplo insertados correctamente.';
END

-- Verificar si la tabla Subjects existe
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Subjects')
BEGIN
    PRINT 'La tabla Subjects existe. Verificando si tiene datos...';
    
    -- Verificar si la tabla Subjects tiene datos
    IF (SELECT COUNT(*) FROM Subjects) > 0
    BEGIN
        PRINT 'La tabla Subjects tiene datos. Migrando datos a la tabla Materias...';
        
        -- Limpiar la tabla Materias antes de insertar nuevos datos
        -- (Solo si estamos seguros de que queremos eliminar los datos existentes)
        -- DELETE FROM Materias;
        -- DBCC CHECKIDENT ('Materias', RESEED, 0);
        
        -- Insertar datos de Subjects a Materias
        -- Asumiendo que las columnas coinciden según lo visto en el código
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        SELECT 
            s.Name AS Nombre,
            'Descripción de ' + s.Name AS Descripcion,
            s.Credits AS Creditos,
            s.Credits * 2 AS HorasSemanales, -- Asumiendo 2 horas por crédito
            1 AS Activo,
            ISNULL(s.ProfessorId, (SELECT TOP 1 Id FROM Profesores ORDER BY NEWID())), -- Si no tiene profesor, asignar uno aleatorio
            s.Code
        FROM Subjects s
        WHERE NOT EXISTS (
            -- Evitar duplicados basados en el código de la materia
            SELECT 1 FROM Materias m WHERE m.Code = s.Code
        );
        
        PRINT 'Datos migrados correctamente de Subjects a Materias.';
    END
    ELSE
    BEGIN
        PRINT 'La tabla Subjects no tiene datos. Insertando datos de ejemplo en Materias...';
        
        -- Insertar datos de ejemplo en Materias usando variables para los IDs de profesores
        DECLARE @ProfesorMatematicas INT, @ProfesorFisica INT, @ProfesorHistoria INT, @ProfesorLiteratura INT, @ProfesorCiencias INT, @ProfesorRandom1 INT, @ProfesorRandom2 INT, @ProfesorRandom3 INT, @ProfesorRandom4 INT;
        
        -- Obtener IDs de profesores por especialidad
        SELECT TOP 1 @ProfesorMatematicas = Id FROM Profesores WHERE Especialidad = 'Matemáticas' OR Nombre = 'Juan';
        SELECT TOP 1 @ProfesorFisica = Id FROM Profesores WHERE Especialidad = 'Física' OR Nombre = 'Roberto';
        SELECT TOP 1 @ProfesorHistoria = Id FROM Profesores WHERE Especialidad = 'Historia' OR Nombre = 'Carlos';
        SELECT TOP 1 @ProfesorLiteratura = Id FROM Profesores WHERE Especialidad = 'Literatura' OR Nombre = 'Ana';
        SELECT TOP 1 @ProfesorCiencias = Id FROM Profesores WHERE Especialidad = 'Ciencias' OR Nombre = 'María';
        
        -- Obtener IDs aleatorios para las demás materias
        SELECT TOP 1 @ProfesorRandom1 = Id FROM Profesores ORDER BY NEWID();
        SELECT TOP 1 @ProfesorRandom2 = Id FROM Profesores ORDER BY NEWID();
        SELECT TOP 1 @ProfesorRandom3 = Id FROM Profesores ORDER BY NEWID();
        SELECT TOP 1 @ProfesorRandom4 = Id FROM Profesores ORDER BY NEWID();
        
        -- Si alguna variable es NULL, asignar un profesor aleatorio
        IF @ProfesorMatematicas IS NULL SELECT TOP 1 @ProfesorMatematicas = Id FROM Profesores ORDER BY NEWID();
        IF @ProfesorFisica IS NULL SELECT TOP 1 @ProfesorFisica = Id FROM Profesores ORDER BY NEWID();
        IF @ProfesorHistoria IS NULL SELECT TOP 1 @ProfesorHistoria = Id FROM Profesores ORDER BY NEWID();
        IF @ProfesorLiteratura IS NULL SELECT TOP 1 @ProfesorLiteratura = Id FROM Profesores ORDER BY NEWID();
        IF @ProfesorCiencias IS NULL SELECT TOP 1 @ProfesorCiencias = Id FROM Profesores ORDER BY NEWID();
        
        -- Insertar materias con los IDs de profesores obtenidos
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        VALUES 
            ('Matemáticas I', 'Curso básico de matemáticas', 4, 8, 1, @ProfesorMatematicas, 'MAT101'),
            ('Física I', 'Introducción a la física', 4, 8, 1, @ProfesorFisica, 'FIS101'),
            ('Historia Universal', 'Historia del mundo', 3, 6, 1, @ProfesorHistoria, 'HIS101'),
            ('Literatura', 'Análisis literario', 3, 6, 1, @ProfesorLiteratura, 'LIT101'),
            ('Biología', 'Estudio de los seres vivos', 4, 8, 1, @ProfesorCiencias, 'BIO101'),
            ('Química', 'Fundamentos de química', 4, 8, 1, @ProfesorCiencias, 'QUI101'),
            ('Programación', 'Introducción a la programación', 3, 6, 1, @ProfesorRandom1, 'PRG101'),
            ('Inglés I', 'Nivel básico de inglés', 2, 4, 1, @ProfesorRandom2, 'ING101'),
            ('Educación Física', 'Actividad física y deportes', 2, 4, 1, @ProfesorRandom3, 'EDF101'),
            ('Arte', 'Expresión artística', 2, 4, 1, @ProfesorRandom4, 'ART101');
            
        PRINT 'Datos de ejemplo insertados correctamente en Materias.';
    END
END
ELSE
BEGIN
    PRINT 'La tabla Subjects no existe. Insertando datos de ejemplo en Materias...';
    
    -- Insertar datos de ejemplo en Materias usando variables para los IDs de profesores
    DECLARE @ProfesorMatematicas2 INT, @ProfesorFisica2 INT, @ProfesorHistoria2 INT, @ProfesorLiteratura2 INT, @ProfesorCiencias2 INT, @ProfesorRandom5 INT, @ProfesorRandom6 INT, @ProfesorRandom7 INT, @ProfesorRandom8 INT;
    
    -- Obtener IDs de profesores por especialidad
    SELECT TOP 1 @ProfesorMatematicas2 = Id FROM Profesores WHERE Especialidad = 'Matemáticas' OR Nombre = 'Juan';
    SELECT TOP 1 @ProfesorFisica2 = Id FROM Profesores WHERE Especialidad = 'Física' OR Nombre = 'Roberto';
    SELECT TOP 1 @ProfesorHistoria2 = Id FROM Profesores WHERE Especialidad = 'Historia' OR Nombre = 'Carlos';
    SELECT TOP 1 @ProfesorLiteratura2 = Id FROM Profesores WHERE Especialidad = 'Literatura' OR Nombre = 'Ana';
    SELECT TOP 1 @ProfesorCiencias2 = Id FROM Profesores WHERE Especialidad = 'Ciencias' OR Nombre = 'María';
    
    -- Obtener IDs aleatorios para las demás materias
    SELECT TOP 1 @ProfesorRandom5 = Id FROM Profesores ORDER BY NEWID();
    SELECT TOP 1 @ProfesorRandom6 = Id FROM Profesores ORDER BY NEWID();
    SELECT TOP 1 @ProfesorRandom7 = Id FROM Profesores ORDER BY NEWID();
    SELECT TOP 1 @ProfesorRandom8 = Id FROM Profesores ORDER BY NEWID();
    
    -- Si alguna variable es NULL, asignar un profesor aleatorio
    IF @ProfesorMatematicas2 IS NULL SELECT TOP 1 @ProfesorMatematicas2 = Id FROM Profesores ORDER BY NEWID();
    IF @ProfesorFisica2 IS NULL SELECT TOP 1 @ProfesorFisica2 = Id FROM Profesores ORDER BY NEWID();
    IF @ProfesorHistoria2 IS NULL SELECT TOP 1 @ProfesorHistoria2 = Id FROM Profesores ORDER BY NEWID();
    IF @ProfesorLiteratura2 IS NULL SELECT TOP 1 @ProfesorLiteratura2 = Id FROM Profesores ORDER BY NEWID();
    IF @ProfesorCiencias2 IS NULL SELECT TOP 1 @ProfesorCiencias2 = Id FROM Profesores ORDER BY NEWID();
    
    -- Insertar materias con los IDs de profesores obtenidos
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES 
        ('Matemáticas I', 'Curso básico de matemáticas', 4, 8, 1, @ProfesorMatematicas2, 'MAT101'),
        ('Física I', 'Introducción a la física', 4, 8, 1, @ProfesorFisica2, 'FIS101'),
        ('Historia Universal', 'Historia del mundo', 3, 6, 1, @ProfesorHistoria2, 'HIS101'),
        ('Literatura', 'Análisis literario', 3, 6, 1, @ProfesorLiteratura2, 'LIT101'),
        ('Biología', 'Estudio de los seres vivos', 4, 8, 1, @ProfesorCiencias2, 'BIO101'),
        ('Química', 'Fundamentos de química', 4, 8, 1, @ProfesorCiencias2, 'QUI101'),
        ('Programación', 'Introducción a la programación', 3, 6, 1, @ProfesorRandom5, 'PRG101'),
        ('Inglés I', 'Nivel básico de inglés', 2, 4, 1, @ProfesorRandom6, 'ING101'),
        ('Educación Física', 'Actividad física y deportes', 2, 4, 1, @ProfesorRandom7, 'EDF101'),
        ('Arte', 'Expresión artística', 2, 4, 1, @ProfesorRandom8, 'ART101');
        
    PRINT 'Datos de ejemplo insertados correctamente en Materias.';
END

-- Verificar si hay datos en la tabla Materias
IF (SELECT COUNT(*) FROM Materias) > 0
BEGIN
    PRINT 'La tabla Materias ahora tiene ' + CAST((SELECT COUNT(*) FROM Materias) AS VARCHAR) + ' registros.';
END
ELSE
BEGIN
    PRINT 'Error: No se pudieron insertar datos en la tabla Materias.';
END

-- Verificar si hay materias sin profesor asignado
IF EXISTS (SELECT 1 FROM Materias WHERE ProfessorId IS NULL OR ProfessorId = 0)
BEGIN
    PRINT 'Hay materias sin profesor asignado. Asignando profesores...';
    
    -- Obtener un ID de profesor aleatorio
    DECLARE @ProfesorAleatorio INT;
    SELECT TOP 1 @ProfesorAleatorio = Id FROM Profesores ORDER BY NEWID();
    
    -- Asignar profesores a materias que no tienen profesor
    UPDATE m
    SET ProfessorId = @ProfesorAleatorio
    FROM Materias m
    WHERE m.ProfessorId IS NULL OR m.ProfessorId = 0;
    
    PRINT 'Profesores asignados correctamente a todas las materias.';
END