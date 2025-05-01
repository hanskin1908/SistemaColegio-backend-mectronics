using NUnit.Framework;

namespace SistemaColegio.UnitTests;

public abstract class TestBase
{
    [SetUp]
    public virtual void Setup()
    {
        // Configuración común para todas las pruebas
    }

    [TearDown]
    public virtual void TearDown()
    {
        // Limpieza común para todas las pruebas
    }
}