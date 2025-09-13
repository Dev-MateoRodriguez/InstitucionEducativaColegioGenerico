using Microsoft.EntityFrameworkCore;
using InstitucionEducativaGenerica.Models;

namespace InstitucionEducativaGenerica.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<Student> Students { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Student>().HasKey(s => s.IdStudent).HasAnnotation("Key", true);
            modelBuilder.Entity<Student>().Property(s => s.IdStudent).ValueGeneratedOnAdd();
}
    }
}