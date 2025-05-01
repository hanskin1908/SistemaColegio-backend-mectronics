-- Script para poblar todas las tablas principales del Sistema Colegio
-- Incluye: Estudiantes, Profesores, Materias y Registros

USE SistemaColegio;
GO

-- Desactivar temporalmente las restricciones de clave foránea para facilitar la carga de datos
-- EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';

-- 1. POBLAR TABLA PROFESORES
-- ===========================
PRINT 'Poblando tabla Profesores...';

-- Verificar si ya hay datos en la tabla
IF (SELECT COUNT(*) FROM Profesores) = 0
BEGIN
    -- Insertar profesores de ejemplo
    INSERT INTO Profesores (Nombre, Apellido, Especialidad, Email, Telefono, FechaContratacion, Activo)
    VALUES 
        ('Juan', 'Pérez', 'Matemáticas', 'juan.perez@colegio.edu', '555-1234', DATEADD(YEAR, -5, GETDATE()), 1),
        ('María', 'González', 'Ciencias', 'maria.gonzalez@colegio.edu', '555-2345', DATEADD(YEAR, -3, GETDATE()), 1),
        ('Carlos', 'Rodríguez', 'Historia', 'carlos.rodriguez@colegio.edu', '555-3456', DATEADD(YEAR, -4, GETDATE()), 1),
        ('Ana', 'Martínez', 'Literatura', 'ana.martinez@colegio.edu', '555-4567', DATEADD(YEAR, -2, GETDATE()), 1),
        ('Roberto', 'Sánchez', 'Física', 'roberto.sanchez@colegio.edu', '555-5678', DATEADD(YEAR, -3, GETDATE()), 1),
        ('Laura', 'López', 'Química', 'laura.lopez@colegio.edu', '555-6789', DATEADD(YEAR, -1, GETDATE()), 1),
        ('Miguel', 'Torres', 'Educación Física', 'miguel.torres@colegio.edu', '555-7890', DATEADD(YEAR, -2, GETDATE()), 1),
        ('Carmen', 'Díaz', 'Inglés', 'carmen.diaz@colegio.edu', '555-8901', DATEADD(YEAR, -4, GETDATE()), 1),
        ('Javier', 'Ruiz', 'Informática', 'javier.ruiz@colegio.edu', '555-9012', DATEADD(YEAR, -1, GETDATE()), 1),
        ('Patricia', 'Gómez', 'Arte', 'patricia.gomez@colegio.edu', '555-0123', DATEADD(YEAR, -2, GETDATE()), 1);
        
    PRINT 'Se han insertado 10 profesores de ejemplo.';
END
ELSE
BEGIN
    PRINT 'La tabla Profesores ya contiene datos. No se insertaron nuevos registros.';
END

-- 2. POBLAR TABLA MATERIAS
-- ========================
PRINT 'Poblando tabla Materias...';

-- Obtener IDs de profesores para asignar a las materias
DECLARE @ProfesorMatematicas INT, @ProfesorFisica INT, @ProfesorHistoria INT, @ProfesorLiteratura INT;
DECLARE @ProfesorQuimica INT, @ProfesorEducacionFisica INT, @ProfesorIngles INT, @ProfesorInformatica INT;
DECLARE @ProfesorArte INT, @ProfesorCiencias INT;

-- Obtener IDs de profesores por especialidad
SELECT TOP 1 @ProfesorMatematicas = Id FROM Profesores WHERE Especialidad = 'Matemáticas';
SELECT TOP 1 @ProfesorFisica = Id FROM Profesores WHERE Especialidad = 'Física';
SELECT TOP 1 @ProfesorHistoria = Id FROM Profesores WHERE Especialidad = 'Historia';
SELECT TOP 1 @ProfesorLiteratura = Id FROM Profesores WHERE Especialidad = 'Literatura';
SELECT TOP 1 @ProfesorQuimica = Id FROM Profesores WHERE Especialidad = 'Química';
SELECT TOP 1 @ProfesorEducacionFisica = Id FROM Profesores WHERE Especialidad = 'Educación Física';
SELECT TOP 1 @ProfesorIngles = Id FROM Profesores WHERE Especialidad = 'Inglés';
SELECT TOP 1 @ProfesorInformatica = Id FROM Profesores WHERE Especialidad = 'Informática';
SELECT TOP 1 @ProfesorArte = Id FROM Profesores WHERE Especialidad = 'Arte';
SELECT TOP 1 @ProfesorCiencias = Id FROM Profesores WHERE Especialidad = 'Ciencias';

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
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Matemáticas I', 'Fundamentos de álgebra y aritmética', 4, 6, 1, @ProfesorMatematicas, 'MAT101');
    
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Matemáticas II', 'Geometría y trigonometría', 4, 6, 1, @ProfesorMatematicas, 'MAT102');
    
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Cálculo I', 'Introducción al cálculo diferencial', 5, 8, 1, @ProfesorMatematicas, 'MAT201');
    
    -- Ciencias
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Física I', 'Mecánica clásica', 4, 6, 1, @ProfesorFisica, 'FIS101');
    
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Física II', 'Electricidad y magnetismo', 4, 6, 1, @ProfesorFisica, 'FIS102');
    
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Química General', 'Principios básicos de química', 4, 6, 1, @ProfesorQuimica, 'QUI101');
    
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Biología', 'Estudio de los seres vivos', 4, 6, 1, @ProfesorCiencias, 'BIO101');
    
    -- Humanidades
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Historia Universal', 'Principales acontecimientos históricos mundiales', 3, 4, 1, @ProfesorHistoria, 'HIS101');
    
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Historia Nacional', 'Historia del país', 3, 4, 1, @ProfesorHistoria, 'HIS102');
    
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Literatura Universal', 'Obras clásicas de la literatura mundial', 3, 4, 1, @ProfesorLiteratura, 'LIT101');
    
    -- Idiomas
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Inglés Básico', 'Fundamentos del idioma inglés', 3, 4, 1, @ProfesorIngles, 'ING101');
    
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Inglés Intermedio', 'Nivel intermedio del idioma inglés', 3, 4, 1, @ProfesorIngles, 'ING102');
    
    -- Tecnología
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Informática Básica', 'Introducción a la informática', 3, 4, 1, @ProfesorInformatica, 'INF101');
    
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Programación', 'Fundamentos de programación', 4, 6, 1, @ProfesorInformatica, 'INF102');
    
    -- Otros
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Educación Física', 'Actividad física y deportes', 2, 4, 1, @ProfesorEducacionFisica, 'EDF101');
    
    INSERT INTO Materias (Nombre, Descripcion, Creditos, HorasSemanales, Activo, ProfessorId, Code)
    VALUES ('Arte y Música', 'Expresión artística y musical', 2, 4, 1, @ProfesorArte, 'ART101');
    
    PRINT 'Se han insertado 16 materias de ejemplo.';
END
ELSE
BEGIN
    PRINT 'La tabla Materias ya contiene datos. No se insertaron nuevos registros.';
END

-- 3. POBLAR TABLA ESTUDIANTES
-- ===========================
PRINT 'Poblando tabla Estudiantes...';

-- Verificar si ya hay datos en la tabla
IF (SELECT COUNT(*) FROM Estudiantes) = 0
BEGIN
    -- Insertar estudiantes de ejemplo
    INSERT INTO Estudiantes (Nombre, Apellido, FechaNacimiento, Direccion, Telefono, Email, FechaRegistro, Activo, StudentId, Name)
    VALUES 
        ('Alejandro', 'García', '2005-03-15', 'Calle Principal 123', '555-1111', 'alejandro.garcia@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST001', 'Alejandro García'),
        ('Sofía', 'Martínez', '2006-07-22', 'Avenida Central 456', '555-2222', 'sofia.martinez@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST002', 'Sofía Martínez'),
        ('Daniel', 'López', '2005-11-10', 'Calle Secundaria 789', '555-3333', 'daniel.lopez@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST003', 'Daniel López'),
        ('Valentina', 'Rodríguez', '2006-04-05', 'Avenida Norte 321', '555-4444', 'valentina.rodriguez@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST004', 'Valentina Rodríguez'),
        ('Mateo', 'Hernández', '2005-09-18', 'Calle Sur 654', '555-5555', 'mateo.hernandez@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST005', 'Mateo Hernández'),
        ('Isabella', 'Díaz', '2006-01-30', 'Avenida Este 987', '555-6666', 'isabella.diaz@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST006', 'Isabella Díaz'),
        ('Santiago', 'Pérez', '2005-06-12', 'Calle Oeste 159', '555-7777', 'santiago.perez@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST007', 'Santiago Pérez'),
        ('Camila', 'Sánchez', '2006-10-25', 'Avenida Principal 753', '555-8888', 'camila.sanchez@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST008', 'Camila Sánchez'),
        ('Sebastián', 'Torres', '2005-02-08', 'Calle Central 951', '555-9999', 'sebastian.torres@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST009', 'Sebastián Torres'),
        ('Valeria', 'Flores', '2006-08-17', 'Avenida Secundaria 357', '555-0000', 'valeria.flores@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST010', 'Valeria Flores'),
        ('Nicolás', 'González', '2005-12-03', 'Calle Norte 852', '555-1212', 'nicolas.gonzalez@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST011', 'Nicolás González'),
        ('Luciana', 'Ruiz', '2006-05-20', 'Avenida Sur 456', '555-2323', 'luciana.ruiz@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST012', 'Luciana Ruiz'),
        ('Emilio', 'Gómez', '2005-08-11', 'Calle Este 789', '555-3434', 'emilio.gomez@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST013', 'Emilio Gómez'),
        ('Mariana', 'Castro', '2006-02-28', 'Avenida Oeste 123', '555-4545', 'mariana.castro@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST014', 'Mariana Castro'),
        ('Tomás', 'Vargas', '2005-04-14', 'Calle Principal 456', '555-5656', 'tomas.vargas@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST015', 'Tomás Vargas'),
        ('Gabriela', 'Morales', '2006-09-07', 'Avenida Central 789', '555-6767', 'gabriela.morales@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST016', 'Gabriela Morales'),
        ('Joaquín', 'Ortiz', '2005-01-23', 'Calle Secundaria 123', '555-7878', 'joaquin.ortiz@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST017', 'Joaquín Ortiz'),
        ('Renata', 'Núñez', '2006-06-16', 'Avenida Norte 456', '555-8989', 'renata.nunez@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST018', 'Renata Núñez'),
        ('Benjamín', 'Rojas', '2005-10-09', 'Calle Sur 789', '555-9090', 'benjamin.rojas@email.com', DATEADD(YEAR, -2, GETDATE()), 1, 'EST019', 'Benjamín Rojas'),
        ('Antonia', 'Medina', '2006-03-26', 'Avenida Este 123', '555-0101', 'antonia.medina@email.com', DATEADD(YEAR, -1, GETDATE()), 1, 'EST020', 'Antonia Medina');
        
    PRINT 'Se han insertado 20 estudiantes de ejemplo.';
END
ELSE
BEGIN
    PRINT 'La tabla Estudiantes ya contiene datos. No se insertaron nuevos registros.';
END

-- 4. POBLAR TABLA REGISTROS (INSCRIPCIONES)
-- ========================================
PRINT 'Poblando tabla Registros...';

-- Verificar si ya hay datos en la tabla
IF (SELECT COUNT(*) FROM Registros) = 0
BEGIN
    -- Obtener IDs de estudiantes y materias para crear registros
    DECLARE @TotalEstudiantes INT, @TotalMaterias INT;
    SELECT @TotalEstudiantes = COUNT(*) FROM Estudiantes;
    SELECT @TotalMaterias = COUNT(*) FROM Materias;
    
    IF @TotalEstudiantes > 0 AND @TotalMaterias > 0
    BEGIN
        -- Crear tabla temporal para almacenar combinaciones de estudiante-materia
        CREATE TABLE #TempRegistros (
            EstudianteId INT,
            MateriaId INT,
            Calificacion DECIMAL(5,2),
            FechaRegistro DATETIME
        );
        
        -- Insertar combinaciones aleatorias en la tabla temporal
        -- Cada estudiante se inscribe en 4-8 materias diferentes
        DECLARE @EstudianteId INT = 1;
        WHILE @EstudianteId <= @TotalEstudiantes
        BEGIN
            -- Determinar cuántas materias tomará este estudiante (entre 4 y 8)
            DECLARE @NumMaterias INT = 4 + ABS(CHECKSUM(NEWID())) % 5;
            
            -- Crear inscripciones para este estudiante
            DECLARE @ContadorMaterias INT = 0;
            WHILE @ContadorMaterias < @NumMaterias AND @ContadorMaterias < @TotalMaterias
            BEGIN
                -- Seleccionar una materia aleatoria que el estudiante no haya tomado aún
                DECLARE @MateriaId INT = 1 + ABS(CHECKSUM(NEWID())) % @TotalMaterias;
                
                -- Verificar si esta combinación ya existe en la tabla temporal
                IF NOT EXISTS (SELECT 1 FROM #TempRegistros WHERE EstudianteId = @EstudianteId AND MateriaId = @MateriaId)
                BEGIN
                    -- Generar una calificación aleatoria entre 60 y 100
                    DECLARE @Calificacion DECIMAL(5,2) = 60 + (ABS(CHECKSUM(NEWID())) % 41);
                    
                    -- Generar una fecha de registro aleatoria en el último año
                    DECLARE @FechaRegistro DATETIME = DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE());
                    
                    -- Insertar en la tabla temporal
                    INSERT INTO #TempRegistros (EstudianteId, MateriaId, Calificacion, FechaRegistro)
                    VALUES (@EstudianteId, @MateriaId, @Calificacion, @FechaRegistro);
                    
                    SET @ContadorMaterias = @ContadorMaterias + 1;
                END
            END
            
            SET @EstudianteId = @EstudianteId + 1;
        END
        
        -- Insertar de la tabla temporal a la tabla Registros
        INSERT INTO Registros (EstudianteId, MateriaId, FechaRegistro, Calificacion, StudentId, SubjectId, RegistrationDate)
        SELECT 
            tr.EstudianteId,
            tr.MateriaId,
            tr.FechaRegistro,
            tr.Calificacion,
            tr.EstudianteId, -- StudentId = EstudianteId
            tr.MateriaId,    -- SubjectId = MateriaId
            tr.FechaRegistro -- RegistrationDate = FechaRegistro
        FROM #TempRegistros tr;
        
        -- Eliminar la tabla temporal
        DROP TABLE #TempRegistros;
        
        DECLARE @NumRegistros INT;
        SELECT @NumRegistros = COUNT(*) FROM Registros;
        PRINT 'Se han insertado ' + CAST(@NumRegistros AS VARCHAR) + ' registros de ejemplo.';
    END
    ELSE
    BEGIN
        PRINT 'No hay suficientes estudiantes o materias para crear registros.';
    END
END
ELSE
BEGIN
    PRINT 'La tabla Registros ya contiene datos. No se insertaron nuevos registros.';
END

-- Reactivar las restricciones de clave foránea
-- EXEC sp_MSforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL';

PRINT 'Proceso de población de tablas completado.';

-- Mostrar resumen de datos
PRINT '======== RESUMEN DE DATOS =========';
PRINT 'Profesores: ' + CAST((SELECT COUNT(*) FROM Profesores) AS VARCHAR);
PRINT 'Materias: ' + CAST((SELECT COUNT(*) FROM Materias) AS VARCHAR);
PRINT 'Estudiantes: ' + CAST((SELECT COUNT(*) FROM Estudiantes) AS VARCHAR);
PRINT 'Registros: ' + CAST((SELECT COUNT(*) FROM Registros) AS VARCHAR);
PRINT '==================================';