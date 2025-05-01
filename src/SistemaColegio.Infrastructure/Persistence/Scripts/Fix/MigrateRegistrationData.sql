-- Script para migrar datos si es necesario

-- Verificar si existen las columnas antiguas y nuevas para migrar datos
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'StudentId'
) AND EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'EstudianteId'
)
BEGIN
    -- Migrar datos de StudentId a EstudianteId
    UPDATE Registros
    SET EstudianteId = StudentId;
    PRINT 'Datos migrados de StudentId a EstudianteId';
END

IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId'
) AND EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'MateriaId'
)
BEGIN
    -- Migrar datos de SubjectId a MateriaId
    UPDATE Registros
    SET MateriaId = SubjectId;
    PRINT 'Datos migrados de SubjectId a MateriaId';
END

IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'RegistrationDate'
) AND EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'FechaRegistro'
)
BEGIN
    -- Migrar datos de RegistrationDate a FechaRegistro
    UPDATE Registros
    SET FechaRegistro = RegistrationDate;
    PRINT 'Datos migrados de RegistrationDate a FechaRegistro';
END

PRINT 'Migraciu00f3n de datos completada';