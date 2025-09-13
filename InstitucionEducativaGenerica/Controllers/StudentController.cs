using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using InstitucionEducativaGenerica.Data;
using InstitucionEducativaGenerica.Models;
using Microsoft.AspNetCore.Authorization;

namespace InstitucionEducativaGenerica
{
    [Route("api/[controller]")]
    [ApiController]
    public class StudentsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public StudentsController(ApplicationDbContext context)
        { _context = context; }

        // Metodo GET de vista todos los registros
        [Authorize]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Student>>> GetStudents()
        { return await _context.Students.ToListAsync(); }

        // Metodo GET pagina de 10 en 10
        [Authorize]
        [HttpGet("pagedTentoTen")]
        public async Task<ActionResult<IEnumerable<Student>>> GetStudentsPagedTentoTen([FromQuery] int page = 1)
        {
            // Indicar el numero de registros por pagina
            int pageSize = 10;
            if (page < 1) page = 1;
            // Crea variable donde realiza el paginado de registros
            var students = await _context.Students
                .OrderBy(s => s.IdStudent)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return students;
        }
        // Metodo GET por ID
        [Authorize]
        // GET: api/students/search/juan
        [HttpGet("search/{name}")]
        public async Task<ActionResult<IEnumerable<Student>>> GetStudentByName(string name)
        {
            var students = await _context.Students
                .Where(s => s.StudentName.Contains(name))
                .ToListAsync();

            return students;
        }

        // Metodo POST con validacion de correo electronico
        [Authorize]
        [HttpPost]
        public async Task<ActionResult<Student>> PostStudent(Student student)
        {
            try
            {
                // Validaciones básicas
                if (!ModelState.IsValid)
                { return BadRequest(ModelState); }

                // Validacion de Correo Unico
                var existingStudent = await _context.Students
                    .FirstOrDefaultAsync(s => s.StudentMail == student.StudentMail);

                if (existingStudent != null)
                { return BadRequest("Ya existe un estudiante con ese email"); }

                _context.Students.Add(student);
                await _context.SaveChangesAsync();

                return CreatedAtAction(nameof(GetStudentByName), new { name = student.StudentName }, student);
            }
            catch (Exception ex)
            { return StatusCode(500, $"Error interno: {ex.Message}"); }
        }
        // Metodo PUT con validaciones
        [Authorize]
        [HttpPut("email/{email}")]
        public async Task<IActionResult> PutStudentByEmail(string email, Student student)
        {
            try
            {
                if (!ModelState.IsValid)
                { return BadRequest(ModelState); }

                // Buscar estudiante por email
                var existingStudent = await _context.Students
                    .FirstOrDefaultAsync(s => s.StudentMail == email);

                if (existingStudent == null)
                { return NotFound($"No se encontró estudiante con email: {email}"); }

                // Verifica si el correo existe
                if (existingStudent.StudentMail != student.StudentMail)
                {
                    var emailExists = await _context.Students.AnyAsync(s => s.StudentMail == student.StudentMail);

                    if (emailExists)
                    { return BadRequest("Ya existe otro estudiante con ese email"); }
                }

                existingStudent.StudentName = student.StudentName;
                existingStudent.Birthday = student.Birthday;
                existingStudent.StudentMail = student.StudentMail;
                existingStudent.StudentPs = student.StudentPs;
                existingStudent.Course = student.Course;

                await _context.SaveChangesAsync();
                return NoContent();
            }
            catch (Exception ex)
            { return StatusCode(500, $"Error interno: {ex.Message}"); }
        }
        // Metodo DELETE por correo
        [Authorize]
        [HttpPut("update/email/{email}")]
        public async Task<IActionResult> UpdateStudentByEmail(string email, [FromBody] UpdateStudentDto updateDto)
        {
            var student = await _context.Students
                .FirstOrDefaultAsync(s => s.StudentMail == email);
            
            if (student == null)
            {
                return NotFound($"No se encontró estudiante con email: {email}");
            }

            try
            {
                // Actualizar solo los campos que no son nulos
                if (!string.IsNullOrEmpty(updateDto.StudentName))
                    student.StudentName = updateDto.StudentName;
                    
                if (updateDto.Birthday.HasValue)
                    student.Birthday = updateDto.Birthday.Value;
                    
                if (!string.IsNullOrEmpty(updateDto.StudentMail))
                    student.StudentMail = updateDto.StudentMail;
                    
                if (!string.IsNullOrEmpty(updateDto.StudentPs))
                    student.StudentPs = updateDto.StudentPs;
                    
                if (updateDto.Course.HasValue)
                    student.Course = updateDto.Course.Value;

                await _context.SaveChangesAsync();
                
                return Ok(new { 
                    message = "Estudiante actualizado exitosamente",
                    student = new {
                        id = student.IdStudent,
                        name = student.StudentName,
                        email = student.StudentMail,
                        birthday = student.Birthday,
                        course = student.Course
                    }
                });
            }
            catch (Exception ex)
            {
                return BadRequest($"Error al actualizar estudiante: {ex.Message}");
            }
        }

        // DTO para la actualización
        public class UpdateStudentDto
        {
            public string? StudentName { get; set; }
            public DateOnly? Birthday { get; set; }
            public string? StudentMail { get; set; }
            public string? StudentPs { get; set; }
            public int? Course { get; set; }
        }
    }
}