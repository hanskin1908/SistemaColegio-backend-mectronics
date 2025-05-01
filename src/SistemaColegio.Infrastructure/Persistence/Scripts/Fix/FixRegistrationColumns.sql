-- Script para corregir el problema de las columnas en la entidad Registration

-- Verificar si existen las columnas que causan el problema
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'RegistrationDate'
)
BEGIN
    -- Si no existe la columna RegistrationDate, crearla
    ALTER TABLE Registros ADD RegistrationDate DATETIME NOT NULL DEFAULT GETDATE();
    PRINT 'Columna RegistrationDate creada';
    
    -- Actualizar los valores de RegistrationDate con los valores de FechaRegistro
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'FechaRegistro'
    )
    BEGIN
        UPDATE Registros SET RegistrationDate = FechaRegistro;
        PRINT 'Valores de RegistrationDate actualizados desde FechaRegistro';
    END
END
ELSE
BEGIN
    PRINT 'Columna RegistrationDate ya existe';
END

IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'StudentId'
)
BEGIN
    -- Si no existe la columna StudentId, crearla
    ALTER TABLE Registros ADD StudentId INT NOT NULL DEFAULT 0;
    PRINT 'Columna StudentId creada';
    
    -- Actualizar los valores de StudentId con los valores de EstudianteId
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'EstudianteId'
    )
    BEGIN
        UPDATE Registros SET StudentId = EstudianteId;
        PRINT 'Valores de StudentId actualizados desde EstudianteId';
    END
    
    -- Crear la relación con la tabla Estudiantes
    ALTER TABLE Registros ADD CONSTRAINT FK_Registros_Estudiantes_StudentId
    FOREIGN KEY (StudentId) REFERENCES Estudiantes(Id);
    PRINT 'Relación con Estudiantes creada para StudentId';
END
ELSE
BEGIN
    PRINT 'Columna StudentId ya existe';
END

IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId'
)
BEGIN
    -- Si no existe la columna SubjectId, crearla
    ALTER TABLE Registros ADD SubjectId INT NOT NULL DEFAULT 0;
    PRINT 'Columna SubjectId creada';
    
    -- Actualizar los valores de SubjectId con los valores de MateriaId
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'MateriaId'
    )
    BEGIN
        UPDATE Registros SET SubjectId = MateriaId;
        PRINT 'Valores de SubjectId actualizados desde MateriaId';
    END
    
    -- Crear la relación con la tabla Materias
    ALTER TABLE Registros ADD CONSTRAINT FK_Registros_Materias_SubjectId
    FOREIGN KEY (SubjectId) REFERENCES Materias(Id);
    PRINT 'Relación con Materias creada para SubjectId';
END
ELSE
BEGIN
    PRINT 'Columna SubjectId ya existe';
END

-- Verificar si existe la columna SubjectId1 y crearla si no existe
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId1'
)
BEGIN
    -- Si no existe la columna SubjectId1, crearla
    ALTER TABLE Registros ADD SubjectId1 INT NULL;
    PRINT 'Columna SubjectId1 creada';
    
    -- Actualizar los valores de SubjectId1 con los valores de SubjectId
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId'
    )
    BEGIN
        UPDATE Registros SET SubjectId1 = SubjectId;
        PRINT 'Valores de SubjectId1 actualizados desde SubjectId';
    END
END
ELSE
BEGIN
    PRINT 'Columna SubjectId1 ya existe';
END

-- Verificar si existen las columnas en español, y si no, crearlas
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'EstudianteId'
)
BEGIN
    -- Si no existe la columna EstudianteId, crearla
    ALTER TABLE Registros ADD EstudianteId INT NOT NULL DEFAULT 0;
    PRINT 'Columna EstudianteId creada';
    
    -- Crear la relación con la tabla Estudiantes
    ALTER TABLE Registros ADD CONSTRAINT FK_Registros_Estudiantes
    FOREIGN KEY (EstudianteId) REFERENCES Estudiantes(Id);
    PRINT 'Relación con Estudiantes creada';
    
    -- Actualizar los valores de EstudianteId con los valores de StudentId si existe
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'StudentId'
    )
    BEGIN
        UPDATE Registros SET EstudianteId = StudentId;
        PRINT 'Valores de EstudianteId actualizados desde StudentId';
    END
END
ELSE
BEGIN
    PRINT 'Columna EstudianteId ya existe';
END

IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'MateriaId'
)
BEGIN
    -- Si no existe la columna MateriaId, crearla
    ALTER TABLE Registros ADD MateriaId INT NOT NULL DEFAULT 0;
    PRINT 'Columna MateriaId creada';
    
    -- Crear la relación con la tabla Materias
    ALTER TABLE Registros ADD CONSTRAINT FK_Registros_Materias
    FOREIGN KEY (MateriaId) REFERENCES Materias(Id);
    PRINT 'Relación con Materias creada';
    
    -- Actualizar los valores de MateriaId con los valores de SubjectId si existe
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId'
    )
    BEGIN
        UPDATE Registros SET MateriaId = SubjectId;
        PRINT 'Valores de MateriaId actualizados desde SubjectId';
    END
END
ELSE
BEGIN
    PRINT 'Columna MateriaId ya existe';
END

IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'FechaRegistro'
)
BEGIN
    -- Si no existe la columna FechaRegistro, crearla
    ALTER TABLE Registros ADD FechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
    PRINT 'Columna FechaRegistro creada';
    
    -- Actualizar los valores de FechaRegistro con los valores de RegistrationDate si existe
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'RegistrationDate'
    )
    BEGIN
        UPDATE Registros SET FechaRegistro = RegistrationDate;
        PRINT 'Valores de FechaRegistro actualizados desde RegistrationDate';
    END
END
ELSE
BEGIN
    PRINT 'Columna FechaRegistro ya existe';
END

-- Crear triggers para mantener sincronizadas las columnas en inglés y español
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_Registros_SyncColumns')
BEGIN
    EXEC('CREATE TRIGGER TR_Registros_SyncColumns
    ON Registros
    AFTER UPDATE
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
        WHERE r.SubjectId1 <> i.SubjectId OR (r.SubjectId1 IS NULL AND i.SubjectId IS NOT NULL);
        
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

PRINT 'Script de corrección completado';