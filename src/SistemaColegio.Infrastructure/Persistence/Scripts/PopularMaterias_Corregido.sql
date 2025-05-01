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
        ('Juan', 'Pu00e9rez', 'Matemu00e1ticas', 'juan.perez@colegio.edu', '555-1234', GETDATE(), 1),
        ('Maru00eda', 'Gonzu00e1lez', 'Ciencias', 'maria.gonzalez@colegio.edu', '555-2345', GETDATE(), 1),
        ('Carlos', 'Rodru00edguez', 'Historia', 'carlos.rodriguez@colegio.edu', '555-3456', GETDATE(), 1),
        ('Ana', 'Martu00ednez', 'Literatura', 'ana.martinez@colegio.edu', '555-4567', GETDATE(), 1),
        ('Roberto', 'Su00e1nchez', 'Fu00edsica', 'roberto.sanchez@colegio.edu', '555-5678', GETDATE(), 1);
        
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
        
        -- Para cada Subject, obtener un profesor aleatorio si no tiene uno asignado
        DECLARE @ProfesorPorDefecto INT;
        SELECT TOP 1 @ProfesorPorDefecto = Id FROM Profesores ORDER BY NEWID();
        
        -- Insertar datos de Subjects a Materias
        -- Asumiendo que las columnas coinciden segu00fan lo visto en el cu00f3digo
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        SELECT 
            s.Name AS Nombre,
            'Descripciu00f3n de ' + s.Name AS Descripcion,
            s.Credits AS Creditos,
            s.Credits * 2 AS HorasSemanales, -- Asumiendo 2 horas por cru00e9dito
            1 AS Activo,
            ISNULL(s.ProfessorId, @ProfesorPorDefecto), -- Si no tiene profesor, asignar uno aleatorio
            s.Code
        FROM Subjects s
        WHERE NOT EXISTS (
            -- Evitar duplicados basados en el cu00f3digo de la materia
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
        
        -- Si alguna variable es NULL, asignar un profesor aleatorio
        IF @ProfesorMatematicas IS NULL SELECT TOP 1 @ProfesorMatematicas = Id FROM Profesores ORDER BY NEWID();
        IF @ProfesorFisica IS NULL SELECT TOP 1 @ProfesorFisica = Id FROM Profesores ORDER BY NEWID();
        IF @ProfesorHistoria IS NULL SELECT TOP 1 @ProfesorHistoria = Id FROM Profesores ORDER BY NEWID();
        IF @ProfesorLiteratura IS NULL SELECT TOP 1 @ProfesorLiteratura = Id FROM Profesores ORDER BY NEWID();
        IF @ProfesorCiencias IS NULL SELECT TOP 1 @ProfesorCiencias = Id FROM Profesores ORDER BY NEWID();
        
        -- Insertar materias con los IDs de profesores obtenidos
        INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
        VALUES 
            ('Matemu00e1ticas I', 'Curso bu00e1sico de matemu00e1ticas', 4, 8, 1, @ProfesorMatematicas, 'MAT101'),
            ('Fu00edsica I', 'Introducciu00f3n a la fu00edsica', 4, 8, 1, @ProfesorFisica, 'FIS101'),
            ('Historia Universal', 'Historia del mundo', 3, 6, 1, @ProfesorHistoria, 'HIS101'),
            ('Literatura', 'Anu00e1lisis literario', 3, 6, 1, @ProfesorLiteratura, 'LIT101'),
            ('Biologu00eda', 'Estudio de los seres vivos', 4, 8, 1, @ProfesorCiencias, 'BIO101'),
            ('Quu00edmica', 'Fundamentos de quu00edmica', 4, 8, 1, @ProfesorCiencias, 'QUI101'),
            ('Programaciu00f3n', 'Introducciu00f3n a la programaciu00f3n', 3, 6, 1, @ProfesorRandom1, 'PRG101'),
            ('Inglu00e9s I', 'Nivel bu00e1sico de inglu00e9s', 2, 4, 1, @ProfesorRandom2, 'ING101'),
            ('Educaciu00f3n Fu00edsica', 'Actividad fu00edsica y deportes', 2, 4, 1, @ProfesorRandom3, 'EDF101'),
            ('Arte', 'Expresiu00f3n artu00edstica', 2, 4, 1, @ProfesorRandom4, 'ART101');
            
        PRINT 'Datos de ejemplo insertados correctamente en Materias.';
    END
END
ELSE
BEGIN
    PRINT 'La tabla Subjects no existe. Insertando datos de ejemplo en Materias...';
    
    -- Insertar datos de ejemplo en Materias usando variables para los IDs de profesores
    DECLARE @ProfesorMatematicas2 INT, @ProfesorFisica2 INT, @ProfesorHistoria2 INT, @ProfesorLiteratura2 INT, @ProfesorCiencias2 INT, @ProfesorRandom5 INT, @ProfesorRandom6 INT, @ProfesorRandom7 INT, @ProfesorRandom8 INT;
    
    -- Obtener IDs de profesores por especialidad
    SELECT TOP 1 @ProfesorMatematicas2 = Id FROM Profesores WHERE Especialidad = 'Matemu00e1ticas' OR Nombre = 'Juan';
    SELECT TOP 1 @ProfesorFisica2 = Id FROM Profesores WHERE Especialidad = 'Fu00edsica' OR Nombre = 'Roberto';
    SELECT TOP 1 @ProfesorHistoria2 = Id FROM Profesores WHERE Especialidad = 'Historia' OR Nombre = 'Carlos';
    SELECT TOP 1 @ProfesorLiteratura2 = Id FROM Profesores WHERE Especialidad = 'Literatura' OR Nombre = 'Ana';
    SELECT TOP 1 @ProfesorCiencias2 = Id FROM Profesores WHERE Especialidad = 'Ciencias' OR Nombre = 'Maru00eda';
    
    -- Obtener IDs aleatorios para las demu00e1s materias
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
        ('Matemu00e1ticas I', 'Curso bu00e1sico de matemu00e1ticas', 4, 8, 1, @ProfesorMatematicas2, 'MAT101'),
        ('Fu00edsica I', 'Introducciu00f3n a la fu00edsica', 4, 8, 1, @ProfesorFisica2, 'FIS101'),
        ('Historia Universal', 'Historia del mundo', 3, 6, 1, @ProfesorHistoria2, 'HIS101'),
        ('Literatura', 'Anu00e1lisis literario', 3, 6, 1, @ProfesorLiteratura2, 'LIT101'),
        ('Biologu00eda', 'Estudio de los seres vivos', 4, 8, 1, @ProfesorCiencias2, 'BIO101'),
        ('Quu00edmica', 'Fundamentos de quu00edmica', 4, 8, 1, @ProfesorCiencias2, 'QUI101'),
        ('Programaciu00f3n', 'Introducciu00f3n a la programaciu00f3n', 3, 6, 1, @ProfesorRandom5, 'PRG101'),
        ('Inglu00e9s I', 'Nivel bu00e1sico de inglu00e9s', 2, 4, 1, @ProfesorRandom6, 'ING101'),
        ('Educaciu00f3n Fu00edsica', 'Actividad fu00edsica y deportes', 2, 4, 1, @ProfesorRandom7, 'EDF101'),
        ('Arte', 'Expresiu00f3n artu00edstica', 2, 4, 1, @ProfesorRandom8, 'ART101');
        
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