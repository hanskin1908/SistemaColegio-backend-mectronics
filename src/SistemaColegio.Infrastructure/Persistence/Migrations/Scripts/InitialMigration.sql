-- Crear tablas base
CREATE TABLE [Profesores] (
    [Id] INT NOT NULL IDENTITY,
    [Name] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(100) NOT NULL,
    [Specialty] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_Profesores] PRIMARY KEY ([Id])
);

CREATE TABLE [Estudiantes] (
    [Id] INT NOT NULL IDENTITY,
    [Name] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(100) NOT NULL,
    [StudentId] NVARCHAR(20) NOT NULL,
    CONSTRAINT [PK_Estudiantes] PRIMARY KEY ([Id])
);

CREATE TABLE [Materias] (
    [Id] INT NOT NULL IDENTITY,
    [Name] NVARCHAR(100) NOT NULL,
    [Code] NVARCHAR(20) NOT NULL,
    [Credits] INT NOT NULL,
    [ProfessorId] INT NULL,
    CONSTRAINT [PK_Materias] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Materias_Profesores] FOREIGN KEY ([ProfessorId]) REFERENCES [Profesores] ([Id]) ON DELETE SET NULL
);

CREATE TABLE [Registros] (
    [Id] INT NOT NULL IDENTITY,
    [EstudianteId] INT NOT NULL,
    [MateriaId] INT NOT NULL,
    [FechaRegistro] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_Registros] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Registros_Estudiantes] FOREIGN KEY ([EstudianteId]) REFERENCES [Estudiantes] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Registros_Materias] FOREIGN KEY ([MateriaId]) REFERENCES [Materias] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [Users] (
    [Id] INT NOT NULL IDENTITY,
    [Email] NVARCHAR(100) NOT NULL,
    [PasswordHash] NVARCHAR(MAX) NOT NULL,
    [Role] NVARCHAR(20) NOT NULL,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [LastLogin] DATETIME2 NULL,
    [StudentId] INT NULL,
    [ProfessorId] INT NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Users_Estudiantes] FOREIGN KEY ([StudentId]) REFERENCES [Estudiantes] ([Id]) ON DELETE SET NULL,
    CONSTRAINT [FK_Users_Profesores] FOREIGN KEY ([ProfessorId]) REFERENCES [Profesores] ([Id]) ON DELETE SET NULL
);

-- Crear u00edndices
CREATE INDEX [IX_Materias_ProfessorId] ON [Materias] ([ProfessorId]);
CREATE INDEX [IX_Registros_EstudianteId] ON [Registros] ([EstudianteId]);
CREATE INDEX [IX_Registros_MateriaId] ON [Registros] ([MateriaId]);
CREATE INDEX [IX_Users_StudentId] ON [Users] ([StudentId]);
CREATE INDEX [IX_Users_ProfessorId] ON [Users] ([ProfessorId]);

-- Insertar datos de ejemplo
INSERT INTO [Profesores] ([Name], [Email], [Specialty])
VALUES 
('Roberto Gu00f3mez', 'roberto.gomez@ejemplo.com', 'Matemu00e1ticas'),
('Laura Torres', 'laura.torres@ejemplo.com', 'Ciencias'),
('Miguel Fernu00e1ndez', 'miguel.fernandez@ejemplo.com', 'Historia'),
('Carmen Lu00f3pez', 'carmen.lopez@ejemplo.com', 'Literatura'),
('Javier Du00edaz', 'javier.diaz@ejemplo.com', 'Informu00e1tica');

INSERT INTO [Estudiantes] ([Name], [Email], [StudentId])
VALUES 
('Juan Pu00e9rez', 'juan.perez@ejemplo.com', 'EST-001'),
('Maru00eda Garcu00eda', 'maria.garcia@ejemplo.com', 'EST-002'),
('Carlos Rodru00edguez', 'carlos.rodriguez@ejemplo.com', 'EST-003'),
('Ana Martu00ednez', 'ana.martinez@ejemplo.com', 'EST-004'),
('Luis Su00e1nchez', 'luis.sanchez@ejemplo.com', 'EST-005');

-- Insertar usuario administrador
INSERT INTO [Users] ([Email], [PasswordHash], [Role])
VALUES ('admin@example.com', '$2a$10$8KxX97Ly9Yv4.B8CiMKAeO9RrQnKAiiwPYhXDmsBvP0hqaAYl9N6W', 'admin'); -- password: password123