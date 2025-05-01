-- Script para poblar la tabla Materias
-- Este script evita el uso de subconsultas en contextos no permitidos

USE SistemaColegio;
GO

-- Verificar si existen profesores, si no, crear algunos profesores de ejemplo
IF (SELECT COUNT(*) FROM Profesores) = 0
BEGIN
    PRINT 'No hay profesores en la base de datos. Insertando profesores de ejemplo...';
    
    INSERT INTO Profesores (Nombre, Apellido, Especialidad, Email, Telefono, FechaContratacion, Activo)
    VALUES 
        ('Juan', 'Pu00e9rez', 'Matemu00e1ticas', 'juan.perez@colegio.edu', '555-1234', GETDATE(), 1),
        ('Maru00eda', 'Gonzu00e1lez', 'Ciencias', 'maria.gonzalez@colegio.edu', '555-2345', GETDATE(), 1),
        ('Carlos', 'Rodru00edguez', 'Historia', 'carlos.rodriguez@colegio.edu', '555-3456', GETDATE(), 1),
        ('Ana', 'Martu00ednez', 'Literatura', 'ana.martinez@colegio.edu', '555-4567', GETDATE(), 1),
        ('Roberto', 'Su00e1nchez', 'Fu00edsica', 'roberto.sanchez@colegio.edu', '555-5678', GETDATE(), 1);
        
    PRINT 'Profesores de ejemplo insertados correctamente.';
END

-- Obtener IDs de profesores para usar en las materias
DECLARE @ProfesorMatematicas INT, @ProfesorFisica INT, @ProfesorHistoria INT, @ProfesorLiteratura INT, @ProfesorCiencias INT;
DECLARE @ProfesorRandom1 INT, @ProfesorRandom2 INT, @ProfesorRandom3 INT, @ProfesorRandom4 INT;
DECLARE @ProfesorPorDefecto INT;

-- Obtener IDs de profesores por especialidad
SELECT TOP 1 @ProfesorMatematicas = Id FROM Profesores WHERE Especialidad = 'Matemu00e1ticas' OR Nombre = 'Juan';
SELECT TOP 1 @ProfesorFisica = Id FROM Profesores WHERE Especialidad = 'Fu00edsica' OR Nombre = 'Roberto';
SELECT TOP 1 @ProfesorHistoria = Id FROM Profesores WHERE Especialidad = 'Historia' OR Nombre = 'Carlos';
SELECT TOP 1 @ProfesorLiteratura = Id FROM Profesores WHERE Especialidad = 'Literatura' OR Nombre = 'Ana';
SELECT TOP 1 @ProfesorCiencias = Id FROM Profesores WHERE Especialidad = 'Ciencias' OR Nombre = 'Maru00eda';

-- Obtener IDs aleatorios para las demu00e1s materias
SELECT TOP 1 @ProfesorRandom1 = Id FROM Profesores ORDER BY NEWID();
SELECT TOP 1 @ProfesorRandom2 = Id FROM Profesores ORDER BY NEWID();
SELECT TOP 1 @ProfesorRandom3 = Id FROM Profesores ORDER BY NEWID();
SELECT TOP 1 @ProfesorRandom4 = Id FROM Profesores ORDER BY NEWID();
SELECT TOP 1 @ProfesorPorDefecto = Id FROM Profesores ORDER BY NEWID();

-- Si alguna variable es NULL, asignar un profesor aleatorio
IF @ProfesorMatematicas IS NULL SELECT TOP 1 @ProfesorMatematicas = Id FROM Profesores ORDER BY NEWID();
IF @ProfesorFisica IS NULL SELECT TOP 1 @ProfesorFisica = Id FROM Profesores ORDER BY NEWID();
IF @ProfesorHistoria IS NULL SELECT TOP 1 @ProfesorHistoria = Id FROM Profesores ORDER BY NEWID();
IF @ProfesorLiteratura IS NULL SELECT TOP 1 @ProfesorLiteratura = Id FROM Profesores ORDER BY NEWID();
IF @ProfesorCiencias IS NULL SELECT TOP 1 @ProfesorCiencias = Id FROM Profesores ORDER BY NEWID();

-- Verificar si la tabla Subjects existe y tiene datos
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Subjects') AND (SELECT COUNT(*) FROM Subjects) > 0
BEGIN
    PRINT 'La tabla Subjects existe y tiene datos. Migrando datos a la tabla Materias...';
    
    -- Crear una tabla temporal para almacenar los datos de Subjects
    CREATE TABLE #TempSubjects (
        Id INT,
        Name NVARCHAR(100),
        Code NVARCHAR(20),
        Credits INT,
        ProfessorId INT
    );
    
    -- Insertar datos de Subjects en la tabla temporal
    INSERT INTO #TempSubjects (Id, Name, Code, Credits, ProfessorId)
    SELECT Id, Name, Code, Credits, ProfessorId FROM Subjects;
    
    -- Actualizar los ProfessorId NULL en la tabla temporal
    UPDATE #TempSubjects
    SET ProfessorId = @ProfesorPorDefecto
    WHERE ProfessorId IS NULL OR ProfessorId = 0;
    
    -- Insertar datos de la tabla temporal a Materias, evitando duplicados
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    SELECT 
        ts.Name,
        'Descripciu00f3n de ' + ts.Name,
        ts.Credits,
        ts.Credits * 2, -- Asumiendo 2 horas por cru00e9dito
        1, -- Activo
        ts.ProfessorId,
        ts.Code
    FROM #TempSubjects ts
    LEFT JOIN Materias m ON ts.Code = m.Code
    WHERE m.Id IS NULL; -- Solo insertar si no existe ya
    
    -- Eliminar la tabla temporal
    DROP TABLE #TempSubjects;
    
    PRINT 'Datos migrados correctamente de Subjects a Materias.';
END
ELSE
BEGIN
    PRINT 'La tabla Subjects no existe o no tiene datos. Insertando datos de ejemplo en Materias...';
    
    -- Verificar si ya existen materias con estos cu00f3digos
    IF NOT EXISTS (SELECT 1 FROM Materias WHERE Code = 'MAT101')
    BEGIN
        -- Insertar materias con los IDs de profesores obtenidos
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        VALUES 
            ('Matemu00e1ticas I', 'Curso bu00e1sico de matemu00e1ticas', 4, 8, 1, @ProfesorMatematicas, 'MAT101');
    END
    
    IF NOT EXISTS (SELECT 1 FROM Materias WHERE Code = 'FIS101')
    BEGIN
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        VALUES 
            ('Fu00edsica I', 'Introducciu00f3n a la fu00edsica', 4, 8, 1, @ProfesorFisica, 'FIS101');
    END
    
    IF NOT EXISTS (SELECT 1 FROM Materias WHERE Code = 'HIS101')
    BEGIN
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        VALUES 
            ('Historia Universal', 'Historia del mundo', 3, 6, 1, @ProfesorHistoria, 'HIS101');
    END
    
    IF NOT EXISTS (SELECT 1 FROM Materias WHERE Code = 'LIT101')
    BEGIN
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        VALUES 
            ('Literatura', 'Anu00e1lisis literario', 3, 6, 1, @ProfesorLiteratura, 'LIT101');
    END
    
    IF NOT EXISTS (SELECT 1 FROM Materias WHERE Code = 'BIO101')
    BEGIN
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        VALUES 
            ('Biologu00eda', 'Estudio de los seres vivos', 4, 8, 1, @ProfesorCiencias, 'BIO101');
    END
    
    IF NOT EXISTS (SELECT 1 FROM Materias WHERE Code = 'QUI101')
    BEGIN
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        VALUES 
            ('Quu00edmica', 'Fundamentos de quu00edmica', 4, 8, 1, @ProfesorCiencias, 'QUI101');
    END
    
    IF NOT EXISTS (SELECT 1 FROM Materias WHERE Code = 'PRG101')
    BEGIN
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        VALUES 
            ('Programaciu00f3n', 'Introducciu00f3n a la programaciu00f3n', 3, 6, 1, @ProfesorRandom1, 'PRG101');
    END
    
    IF NOT EXISTS (SELECT 1 FROM Materias WHERE Code = 'ING101')
    BEGIN
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        VALUES 
            ('Inglu00e9s I', 'Nivel bu00e1sico de inglu00e9s', 2, 4, 1, @ProfesorRandom2, 'ING101');
    END
    
    IF NOT EXISTS (SELECT 1 FROM Materias WHERE Code = 'EDF101')
    BEGIN
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        VALUES 
            ('Educaciu00f3n Fu00edsica', 'Actividad fu00edsica y deportes', 2, 4, 1, @ProfesorRandom3, 'EDF101');
    END
    
    IF NOT EXISTS (SELECT 1 FROM Materias WHERE Code = 'ART101')
    BEGIN
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        VALUES 
            ('Arte', 'Expresiu00f3n artu00edstica', 2, 4, 1, @ProfesorRandom4, 'ART101');
    END
    
    PRINT 'Datos de ejemplo insertados correctamente en Materias.';
END

-- Verificar si hay datos en la tabla Materias
DECLARE @NumMaterias INT;
SELECT @NumMaterias = COUNT(*) FROM Materias;

IF @NumMaterias > 0
BEGIN
    PRINT 'La tabla Materias ahora tiene ' + CAST(@NumMaterias AS VARCHAR) + ' registros.';
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
    UPDATE Materias
    SET ProfessorId = @ProfesorAleatorio
    WHERE ProfessorId IS NULL OR ProfessorId = 0;
    
    PRINT 'Profesores asignados correctamente a todas las materias.';
END