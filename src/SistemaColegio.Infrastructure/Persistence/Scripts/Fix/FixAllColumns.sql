-- Script para corregir todas las columnas faltantes en la tabla Registros

-- Verificar si la tabla Registros existe
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Registros')
BEGIN
    PRINT 'Tabla Registros encontrada, procediendo con las correcciones...';
    
    -- 1. Verificar y agregar la columna RegistrationDate
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'RegistrationDate'
    )
    BEGIN
        -- Intentar crear la columna RegistrationDate
        BEGIN TRY
            ALTER TABLE Registros ADD RegistrationDate DATETIME;
            PRINT 'Columna RegistrationDate creada exitosamente';
            
            -- Actualizar con valores predeterminados
            UPDATE Registros SET RegistrationDate = GETDATE();
            PRINT 'Valores predeterminados establecidos para RegistrationDate';
            
            -- Establecer la restricción NOT NULL después de actualizar los valores
            ALTER TABLE Registros ALTER COLUMN RegistrationDate DATETIME NOT NULL;
            PRINT 'Restricción NOT NULL establecida para RegistrationDate';
            
            -- Copiar datos de FechaRegistro si existe
            IF EXISTS (
                SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'FechaRegistro'
            )
            BEGIN
                UPDATE Registros SET RegistrationDate = FechaRegistro;
                PRINT 'Datos copiados de FechaRegistro a RegistrationDate';
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error al crear la columna RegistrationDate: ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'Columna RegistrationDate ya existe';
    END
    
    -- 2. Verificar y agregar la columna StudentId
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'StudentId'
    )
    BEGIN
        -- Intentar crear la columna StudentId
        BEGIN TRY
            ALTER TABLE Registros ADD StudentId INT;
            PRINT 'Columna StudentId creada exitosamente';
            
            -- Actualizar con valores predeterminados
            UPDATE Registros SET StudentId = 0;
            PRINT 'Valores predeterminados establecidos para StudentId';
            
            -- Establecer la restricción NOT NULL después de actualizar los valores
            ALTER TABLE Registros ALTER COLUMN StudentId INT NOT NULL;
            PRINT 'Restricción NOT NULL establecida para StudentId';
            
            -- Copiar datos de EstudianteId si existe
            IF EXISTS (
                SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'EstudianteId'
            )
            BEGIN
                UPDATE Registros SET StudentId = EstudianteId;
                PRINT 'Datos copiados de EstudianteId a StudentId';
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error al crear la columna StudentId: ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'Columna StudentId ya existe';
    END
    
    -- 3. Verificar y agregar la columna SubjectId
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId'
    )
    BEGIN
        -- Intentar crear la columna SubjectId
        BEGIN TRY
            ALTER TABLE Registros ADD SubjectId INT;
            PRINT 'Columna SubjectId creada exitosamente';
            
            -- Actualizar con valores predeterminados
            UPDATE Registros SET SubjectId = 0;
            PRINT 'Valores predeterminados establecidos para SubjectId';
            
            -- Establecer la restricción NOT NULL después de actualizar los valores
            ALTER TABLE Registros ALTER COLUMN SubjectId INT NOT NULL;
            PRINT 'Restricción NOT NULL establecida para SubjectId';
            
            -- Copiar datos de MateriaId si existe
            IF EXISTS (
                SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'MateriaId'
            )
            BEGIN
                UPDATE Registros SET SubjectId = MateriaId;
                PRINT 'Datos copiados de MateriaId a SubjectId';
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error al crear la columna SubjectId: ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'Columna SubjectId ya existe';
    END
    
    -- 4. Verificar y agregar la columna SubjectId1
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId1'
    )
    BEGIN
        -- Intentar crear la columna SubjectId1 (esta puede ser NULL)
        BEGIN TRY
            ALTER TABLE Registros ADD SubjectId1 INT NULL;
            PRINT 'Columna SubjectId1 creada exitosamente';
            
            -- Copiar datos de SubjectId si existe
            IF EXISTS (
                SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId'
            )
            BEGIN
                UPDATE Registros SET SubjectId1 = SubjectId;
                PRINT 'Datos copiados de SubjectId a SubjectId1';
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error al crear la columna SubjectId1: ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'Columna SubjectId1 ya existe';
    END
    
    -- 5. Verificar y agregar la columna FechaRegistro si no existe
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'FechaRegistro'
    )
    BEGIN
        -- Intentar crear la columna FechaRegistro
        BEGIN TRY
            ALTER TABLE Registros ADD FechaRegistro DATETIME;
            PRINT 'Columna FechaRegistro creada exitosamente';
            
            -- Actualizar con valores predeterminados
            UPDATE Registros SET FechaRegistro = GETDATE();
            PRINT 'Valores predeterminados establecidos para FechaRegistro';
            
            -- Establecer la restricción NOT NULL después de actualizar los valores
            ALTER TABLE Registros ALTER COLUMN FechaRegistro DATETIME NOT NULL;
            PRINT 'Restricción NOT NULL establecida para FechaRegistro';
            
            -- Copiar datos de RegistrationDate si existe
            IF EXISTS (
                SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'RegistrationDate'
            )
            BEGIN
                UPDATE Registros SET FechaRegistro = RegistrationDate;
                PRINT 'Datos copiados de RegistrationDate a FechaRegistro';
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error al crear la columna FechaRegistro: ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'Columna FechaRegistro ya existe';
    END
    
    -- 6. Verificar y agregar la columna EstudianteId si no existe
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'EstudianteId'
    )
    BEGIN
        -- Intentar crear la columna EstudianteId
        BEGIN TRY
            ALTER TABLE Registros ADD EstudianteId INT;
            PRINT 'Columna EstudianteId creada exitosamente';
            
            -- Actualizar con valores predeterminados
            UPDATE Registros SET EstudianteId = 0;
            PRINT 'Valores predeterminados establecidos para EstudianteId';
            
            -- Establecer la restricción NOT NULL después de actualizar los valores
            ALTER TABLE Registros ALTER COLUMN EstudianteId INT NOT NULL;
            PRINT 'Restricción NOT NULL establecida para EstudianteId';
            
            -- Copiar datos de StudentId si existe
            IF EXISTS (
                SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'StudentId'
            )
            BEGIN
                UPDATE Registros SET EstudianteId = StudentId;
                PRINT 'Datos copiados de StudentId a EstudianteId';
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error al crear la columna EstudianteId: ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'Columna EstudianteId ya existe';
    END
    
    -- 7. Verificar y agregar la columna MateriaId si no existe
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'MateriaId'
    )
    BEGIN
        -- Intentar crear la columna MateriaId
        BEGIN TRY
            ALTER TABLE Registros ADD MateriaId INT;
            PRINT 'Columna MateriaId creada exitosamente';
            
            -- Actualizar con valores predeterminados
            UPDATE Registros SET MateriaId = 0;
            PRINT 'Valores predeterminados establecidos para MateriaId';
            
            -- Establecer la restricción NOT NULL después de actualizar los valores
            ALTER TABLE Registros ALTER COLUMN MateriaId INT NOT NULL;
            PRINT 'Restricción NOT NULL establecida para MateriaId';
            
            -- Copiar datos de SubjectId si existe
            IF EXISTS (
                SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId'
            )
            BEGIN
                UPDATE Registros SET MateriaId = SubjectId;
                PRINT 'Datos copiados de SubjectId a MateriaId';
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error al crear la columna MateriaId: ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'Columna MateriaId ya existe';
    END
    
    -- Sincronizar datos entre columnas equivalentes
    BEGIN TRY
        -- Sincronizar RegistrationDate y FechaRegistro
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'RegistrationDate')
        AND EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'FechaRegistro')
        BEGIN
            UPDATE Registros SET RegistrationDate = FechaRegistro WHERE RegistrationDate <> FechaRegistro;
            UPDATE Registros SET FechaRegistro = RegistrationDate WHERE FechaRegistro <> RegistrationDate;
            PRINT 'Datos sincronizados entre RegistrationDate y FechaRegistro';
        END
        
        -- Sincronizar StudentId y EstudianteId
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'StudentId')
        AND EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'EstudianteId')
        BEGIN
            UPDATE Registros SET StudentId = EstudianteId WHERE StudentId <> EstudianteId;
            UPDATE Registros SET EstudianteId = StudentId WHERE EstudianteId <> StudentId;
            PRINT 'Datos sincronizados entre StudentId y EstudianteId';
        END
        
        -- Sincronizar SubjectId y MateriaId
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId')
        AND EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'MateriaId')
        BEGIN
            UPDATE Registros SET SubjectId = MateriaId WHERE SubjectId <> MateriaId;
            UPDATE Registros SET MateriaId = SubjectId WHERE MateriaId <> SubjectId;
            PRINT 'Datos sincronizados entre SubjectId y MateriaId';
        END
        
        -- Sincronizar SubjectId1 con SubjectId
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId1')
        AND EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId')
        BEGIN
            UPDATE Registros SET SubjectId1 = SubjectId WHERE (SubjectId1 <> SubjectId OR SubjectId1 IS NULL) AND SubjectId IS NOT NULL;
            PRINT 'Datos sincronizados entre SubjectId1 y SubjectId';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Error al sincronizar datos: ' + ERROR_MESSAGE();
    END CATCH
    
    PRINT 'Corrección de columnas completada exitosamente';
END
ELSE
BEGIN
    PRINT 'Error: La tabla Registros no existe en la base de datos';
END