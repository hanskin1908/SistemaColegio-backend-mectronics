-- Script para corregir columnas faltantes en la tabla Registros

-- Verificar y agregar la columna RegistrationDate si no existe
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'RegistrationDate'
)
BEGIN
    ALTER TABLE Registros ADD RegistrationDate DATETIME NOT NULL DEFAULT GETDATE();
    PRINT 'Columna RegistrationDate creada';
    
    -- Copiar datos de FechaRegistro a RegistrationDate si existe
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'FechaRegistro'
    )
    BEGIN
        UPDATE Registros SET RegistrationDate = FechaRegistro;
        PRINT 'Datos copiados de FechaRegistro a RegistrationDate';
    END
END
ELSE
BEGIN
    PRINT 'Columna RegistrationDate ya existe';
END

-- Verificar y agregar la columna StudentId si no existe
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'StudentId'
)
BEGIN
    ALTER TABLE Registros ADD StudentId INT NOT NULL DEFAULT 0;
    PRINT 'Columna StudentId creada';
    
    -- Copiar datos de EstudianteId a StudentId si existe
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'EstudianteId'
    )
    BEGIN
        UPDATE Registros SET StudentId = EstudianteId;
        PRINT 'Datos copiados de EstudianteId a StudentId';
    END
END
ELSE
BEGIN
    PRINT 'Columna StudentId ya existe';
END

-- Verificar y agregar la columna SubjectId si no existe
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId'
)
BEGIN
    ALTER TABLE Registros ADD SubjectId INT NOT NULL DEFAULT 0;
    PRINT 'Columna SubjectId creada';
    
    -- Copiar datos de MateriaId a SubjectId si existe
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'MateriaId'
    )
    BEGIN
        UPDATE Registros SET SubjectId = MateriaId;
        PRINT 'Datos copiados de MateriaId a SubjectId';
    END
END
ELSE
BEGIN
    PRINT 'Columna SubjectId ya existe';
END

-- Verificar y agregar la columna SubjectId1 si no existe
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId1'
)
BEGIN
    ALTER TABLE Registros ADD SubjectId1 INT NULL;
    PRINT 'Columna SubjectId1 creada';
    
    -- Copiar datos de SubjectId a SubjectId1 si existe
    IF EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId'
    )
    BEGIN
        UPDATE Registros SET SubjectId1 = SubjectId;
        PRINT 'Datos copiados de SubjectId a SubjectId1';
    END
END
ELSE
BEGIN
    PRINT 'Columna SubjectId1 ya existe';
END

PRINT 'Corrección de columnas completada';