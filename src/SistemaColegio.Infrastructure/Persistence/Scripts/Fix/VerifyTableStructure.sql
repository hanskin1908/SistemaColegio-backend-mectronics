-- Script para verificar la estructura actual de la tabla Registros

SELECT 
    c.name AS 'ColumnName',
    t.name AS 'DataType',
    c.max_length AS 'MaxLength',
    c.precision AS 'Precision',
    c.scale AS 'Scale',
    c.is_nullable AS 'IsNullable',
    ISNULL(i.is_primary_key, 0) AS 'IsPrimaryKey'
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
LEFT JOIN sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
WHERE c.object_id = OBJECT_ID('Registros')
ORDER BY c.column_id;

-- Verificar las relaciones de clave foru00e1nea
SELECT 
    fk.name AS 'ForeignKeyName',
    OBJECT_NAME(fk.parent_object_id) AS 'ParentTable',
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS 'ParentColumn',
    OBJECT_NAME(fk.referenced_object_id) AS 'ReferencedTable',
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS 'ReferencedColumn'
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
WHERE fk.parent_object_id = OBJECT_ID('Registros');