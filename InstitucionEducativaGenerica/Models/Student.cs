using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace InstitucionEducativaGenerica.Models
{
    // Apuntamiento del esquema de la BD a trabajar
[Table("students", Schema = "school0001a")]
public class Student
{
    [Key]
    [Column("id_student")]
    public int IdStudent { get; set; }
    
    [Column("student_name")]
    public required string StudentName { get; set; }
    
    [Column("student_birthday")]
    public required DateOnly Birthday { get; set; }
    
    [Column("student_mail")]
    public required string StudentMail { get; set; }
    
    [Column("student_ps")]
    public required string StudentPs { get; set; }
    
    [Column("student_course")]
    public required int Course { get; set; }
}
}