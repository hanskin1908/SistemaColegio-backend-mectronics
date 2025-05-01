-- Script para agregar la columna SubjectId1 a la tabla Registrations

-- Verificar si la tabla Registrations existe
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Registrations')
BEGIN
    PRINT 'Tabla Registrations encontrada, verificando columna SubjectId1...';
    
    -- Verificar si la columna SubjectId1 ya existe
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registrations' AND COLUMN_NAME = 'SubjectId1')
    BEGIN
        -- Agregar la columna SubjectId1
        BEGIN TRY
            ALTER TABLE Registrations ADD SubjectId1 INT NULL;
            PRINT 'Columna SubjectId1 agregada exitosamente a la tabla Registrations';
            
            -- Actualizar SubjectId1 con los valores de SubjectId
            IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registrations' AND COLUMN_NAME = 'SubjectId')
            BEGIN
                UPDATE Registrations SET SubjectId1 = SubjectId;
                PRINT 'Valores de SubjectId1 actualizados desde SubjectId';
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error al agregar la columna SubjectId1: ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'La columna SubjectId1 ya existe en la tabla Registrations';
        
        -- Verificar si hay valores NULL en SubjectId1 y actualizarlos
        IF EXISTS (SELECT * FROM Registrations WHERE SubjectId1 IS NULL AND SubjectId IS NOT NULL)
        BEGIN
            UPDATE Registrations SET SubjectId1 = SubjectId WHERE SubjectId1 IS NULL AND SubjectId IS NOT NULL;
            PRINT 'Valores NULL en SubjectId1 actualizados desde SubjectId';
        END
    END
    
    -- Verificar si existe el trigger para mantener sincronizada la columna SubjectId1
    IF NOT EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_Registrations_SyncSubjectId1')
    BEGIN
        EXEC('CREATE TRIGGER TR_Registrations_SyncSubjectId1
        ON Registrations
        AFTER INSERT, UPDATE
        AS
        BEGIN
            SET NOCOUNT ON;
            
            -- Sincronizar SubjectId1 con SubjectId
            UPDATE Registrations
            SET SubjectId1 = i.SubjectId
            FROM Registrations r
            INNER JOIN inserted i ON r.Id = i.Id
            WHERE (r.SubjectId1 <> i.SubjectId OR r.SubjectId1 IS NULL) AND i.SubjectId IS NOT NULL;
        END');
        PRINT 'Trigger TR_Registrations_SyncSubjectId1 creado exitosamente';
    END
    ELSE
    BEGIN
        PRINT 'El trigger TR_Registrations_SyncSubjectId1 ya existe';
    END
END
ELSE
BEGIN
    PRINT 'Error: La tabla Registrations no existe en la base de datos';
END

-- Verificar si la tabla Registros existe (nombre alternativo)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Registros')
BEGIN
    PRINT 'Tabla Registros encontrada, verificando columna SubjectId1...';
    
    -- Verificar si la columna SubjectId1 ya existe
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId1')
    BEGIN
        -- Agregar la columna SubjectId1
        BEGIN TRY
            ALTER TABLE Registros ADD SubjectId1 INT NULL;
            PRINT 'Columna SubjectId1 agregada exitosamente a la tabla Registros';
            
            -- Actualizar SubjectId1 con los valores de SubjectId
            IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Registros' AND COLUMN_NAME = 'SubjectId')
            BEGIN
                UPDATE Registros SET SubjectId1 = SubjectId;
                PRINT 'Valores de SubjectId1 actualizados desde SubjectId';
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error al agregar la columna SubjectId1: ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'La columna SubjectId1 ya existe en la tabla Registros';
        
        -- Verificar si hay valores NULL en SubjectId1 y actualizarlos
        IF EXISTS (SELECT * FROM Registros WHERE SubjectId1 IS NULL AND SubjectId IS NOT NULL)
        BEGIN
            UPDATE Registros SET SubjectId1 = SubjectId WHERE SubjectId1 IS NULL AND SubjectId IS NOT NULL;
            PRINT 'Valores NULL en SubjectId1 actualizados desde SubjectId';
        END
    END
    
    -- Verificar si existe el trigger para mantener sincronizada la columna SubjectId1
    IF NOT EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_Registros_SyncSubjectId1')
    BEGIN
        EXEC('CREATE TRIGGER TR_Registros_SyncSubjectId1
        ON Registros
        AFTER INSERT, UPDATE
        AS
        BEGIN
            SET NOCOUNT ON;
            
            -- Sincronizar SubjectId1 con SubjectId
            UPDATE Registros
            SET SubjectId1 = i.SubjectId
            FROM Registros r
            INNER JOIN inserted i ON r.Id = i.Id
            WHERE (r.SubjectId1 <> i.SubjectId OR r.SubjectId1 IS NULL) AND i.SubjectId IS NOT NULL;
        END');
        PRINT 'Trigger TR_Registros_SyncSubjectId1 creado exitosamente';
    END
    ELSE
    BEGIN
        PRINT 'El trigger TR_Registros_SyncSubjectId1 ya existe';
    END
END
ELSE
BEGIN
    PRINT 'La tabla Registros no existe en la base de datos';
END

PRINT 'Script completado exitosamente';