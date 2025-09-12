-- ============ Base de Datos de Institucion Educatica Generica =================
-- === Creacion DB
-- DROP DATABASE institucion_educativa;
CREATE DATABASE institucion_educativa;
-- === Creacion de Esquema de Colegio
-- DROP SCHEMA school0001a CASCADE;
CREATE SCHEMA school0001a;

-- === Creacion de Tablas ===
/** ========= Consideraciones tomadas ===============
 * Se crea secuencias en todas las tablas para validar y darle un mejor soporte a los id auto incrementales.
 * Se crea Triggers y Functions para la auditoria de los registros, estilo DW para rastrear quien puede manipular los registros
 * **/

-- Funcion que nos permite cambiar las columans de modificacion de usuario y fecha.
CREATE OR REPLACE FUNCTION school0001a.fn_update_modificed()
RETURNS TRIGGER AS $$
	BEGIN
		NEW.update_reg_user := CURRENT_USER;
		NEW.update_reg_date := CURRENT_TIMESTAMP;
		RETURN NEW;
	END
$$ LANGUAGE plpgsql;

-- ==== Courses ====
-- DROP SEQUENCE IF EXISTS school0001a.sq_courses;
CREATE SEQUENCE IF NOT EXISTS school0001a.sq_courses AS INT
START WITH 1 INCREMENT BY 1 NO MAXVALUE;
-- DROP TABLE IF EXISTS school0001a.courses;
CREATE TABLE IF NOT EXISTS school0001a.courses(
	id_course BIGINT DEFAULT NEXTVAL('school0001a.sq_courses') PRIMARY KEY,
	course_name VARCHAR(255) NOT NULL,
	creation_reg_user VARCHAR(255) DEFAULT CURRENT_USER NULL,
	creation_reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	update_reg_user VARCHAR(255) DEFAULT CURRENT_USER NOT NULL,
	update_reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NULL
);
CREATE OR REPLACE TRIGGER trg_update_courses
BEFORE UPDATE ON school0001a.courses
FOR EACH ROW EXECUTE FUNCTION school0001a.fn_update_modificed();

-- ==== Teachers ====
-- DROP SEQUENCE IF EXISTS school0001a.sq_teachers;
CREATE SEQUENCE IF NOT EXISTS school0001a.sq_teachers AS BIGINT
START WITH 1 INCREMENT BY 1 NO MAXVALUE;
-- DROP TABLE IF EXISTS school0001a.teachers;
CREATE TABLE IF NOT EXISTS school0001a.teachers(
	id_teacher BIGINT DEFAULT NEXTVAL('school0001a.sq_teachers') PRIMARY KEY,
	teacher_name VARCHAR(255) NOT NULL,
	teacher_birthday DATE NOT NULL,
	teacher_mail VARCHAR(255) NOT NULL,
	teacher_ps VARCHAR(255) NOT NULL,
	teacher_title VARCHAR(255) NOT NULL,
	assigned_course INT NOT NULL,
	creation_reg_user VARCHAR(255) DEFAULT CURRENT_USER NULL,
	creation_reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	update_reg_user VARCHAR(255) DEFAULT CURRENT_USER NOT NULL,
	update_reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT fk_teacher_course
		FOREIGN KEY (assigned_course) 
		REFERENCES school0001a.courses(id_course)
);
CREATE OR REPLACE TRIGGER trg_update_teachers
BEFORE UPDATE ON school0001a.teachers 
FOR EACH ROW EXECUTE FUNCTION school0001a.fn_update_modificed();

-- ==== Students ====
-- DROP SEQUENCE IF EXISTS school0001a.sq_students;
CREATE SEQUENCE IF NOT EXISTS school0001a.sq_students AS BIGINT
START WITH 1 INCREMENT BY 1 NO MAXVALUE;
-- DROP TABLE IF EXISTS school0001a.students;
CREATE TABLE IF NOT EXISTS school0001a.students(
	id_student BIGINT DEFAULT NEXTVAL('school0001a.sq_students') PRIMARY KEY,
	student_name VARCHAR(255) NOT NULL,
	student_birthday DATE NOT NULL,
	student_mail VARCHAR(255) NOT NULL,
	student_ps VARCHAR(255) NOT NULL,
	student_course INT NOT NULL,
	creation_reg_user VARCHAR(255) DEFAULT CURRENT_USER NULL,
	creation_reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	update_reg_user VARCHAR(255) DEFAULT CURRENT_USER NOT NULL,
	update_reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT fk_student_course
		FOREIGN KEY (student_course) 
		REFERENCES school0001a.courses(id_course)
);
CREATE OR REPLACE TRIGGER trg_update_student
BEFORE UPDATE ON school0001a.students
FOR EACH ROW EXECUTE FUNCTION school0001a.fn_update_modificed();

-- === Subject ===
-- DROP SEQUENCE IF EXISTS school0001a.sq_subject;
CREATE SEQUENCE IF NOT EXISTS school0001a.sq_subject AS INT
START WITH 1 INCREMENT BY 1 NO MAXVALUE;
-- DROP TABLE IF EXISTS school0001a.subject;
CREATE TABLE IF NOT EXISTS school0001a.subject(
	id_subject BIGINT DEFAULT NEXTVAL('school0001a.sq_subject') PRIMARY KEY,
	name_subject VARCHAR(255) NOT NULL,
	creation_reg_user VARCHAR(255) DEFAULT CURRENT_USER NULL,
	creation_reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	update_reg_user VARCHAR(255) DEFAULT CURRENT_USER NULL,
	update_reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
CREATE OR REPLACE TRIGGER trg_update_subject
BEFORE UPDATE ON school0001a.subject
FOR EACH ROW EXECUTE FUNCTION school0001a.fn_update_modificed();


-- === Grades ===
-- DROP SEQUENCE IF EXISTS school0001a.sq_grades;
CREATE SEQUENCE IF NOT EXISTS school0001a.sq_grades AS BIGINT
START WITH 1 INCREMENT BY 1 NO MAXVALUE;
-- DROP TABLE IF EXISTS school0001a.grades;
CREATE TABLE IF NOT EXISTS school0001a.grades(
	id_grades BIGINT DEFAULT NEXTVAL('school0001a.sq_grades') PRIMARY KEY,
	student_id BIGINT NOT NULL,
	teacher_id BIGINT NOT NULL,
	course_id BIGINT NOT NULL,
	subject_id BIGINT NOT NULL,
	rating DECIMAL NOT NULL,
	creation_reg_user VARCHAR(255) DEFAULT CURRENT_USER NOT NULL,
	creation_reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	update_reg_user VARCHAR(255) DEFAULT CURRENT_USER NOT NULL,
	update_reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT fk_grades_student FOREIGN KEY (student_id) REFERENCES school0001a.students(id_student),
	CONSTRAINT fk_grades_teacher FOREIGN KEY (teacher_id) REFERENCES school0001a.teachers(id_teacher),
	CONSTRAINT fk_grades_course FOREIGN KEY (course_id) REFERENCES school0001a.courses(id_course),
	CONSTRAINT fk_grades_subject FOREIGN KEY (subject_id) REFERENCES school0001a.subject(id_subject)
);
CREATE OR REPLACE TRIGGER trg_update_grades
BEFORE UPDATE ON school0001a.grades
FOR EACH ROW EXECUTE FUNCTION school0001a.fn_update_modificed();