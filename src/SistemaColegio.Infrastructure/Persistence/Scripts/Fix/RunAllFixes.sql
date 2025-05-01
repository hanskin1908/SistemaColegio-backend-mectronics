-- Script maestro para ejecutar todas las correcciones

PRINT 'Iniciando proceso de correcciu00f3n de la estructura de la tabla Registros';
PRINT '--------------------------------------------------------------';

-- Verificar la estructura actual
PRINT 'Estructura actual de la tabla:';
PRINT '--------------------------------------------------------------';
:r VerifyTableStructure.sql
GO

-- Migrar datos si es necesario
PRINT '--------------------------------------------------------------';
PRINT 'Migrando datos:';
PRINT '--------------------------------------------------------------';
:r MigrateRegistrationData.sql
GO

-- Aplicar correcciones a la estructura
PRINT '--------------------------------------------------------------';
PRINT 'Aplicando correcciones a la estructura:';
PRINT '--------------------------------------------------------------';
:r FixRegistrationColumns.sql
GO

-- Verificar la estructura final
PRINT '--------------------------------------------------------------';
PRINT 'Estructura final de la tabla:';
PRINT '--------------------------------------------------------------';
:r VerifyTableStructure.sql
GO

PRINT '--------------------------------------------------------------';
PRINT 'Proceso de correcciu00f3n completado';
PRINT '--------------------------------------------------------------';