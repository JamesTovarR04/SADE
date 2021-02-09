-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- begin attached script 'script'
# 1418 Usar 
SET GLOBAL log_bin_trust_function_creators = 1;
-- end attached script 'script'
-- -----------------------------------------------------
-- Schema sadeDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema sadeDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sadeDB` DEFAULT CHARACTER SET utf8 ;
USE `sadeDB` ;

-- -----------------------------------------------------
-- Table `sadeDB`.`Usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`Usuarios` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `nombres` VARCHAR(60) NOT NULL,
  `apellido1` VARCHAR(45) NOT NULL,
  `apellido2` VARCHAR(45) NULL,
  `tipo` INT NOT NULL COMMENT '1 = Estudiante\n2 = Docente\n3 = Directivo',
  `email` VARCHAR(45) NOT NULL,
  `sexo` ENUM('M', 'F') NOT NULL,
  `fechaNacimiento` DATE NOT NULL,
  `intentosConexion` INT NOT NULL,
  `fechaRegistro` DATETIME NOT NULL DEFAULT NOW(),
  `contrasenia` VARCHAR(500) NULL,
  `remember_token` VARCHAR(100) NULL,
  `fotoPerfil` BLOB NULL,
  `delete` DATETIME NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE INDEX `email_Usuarios_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`Docentes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`Docentes` (
  `idUsuario` INT NOT NULL,
  `direccion` VARCHAR(45) NULL,
  `perfilAcademico` TINYTEXT NULL,
  PRIMARY KEY (`idUsuario`),
  CONSTRAINT `fk_Docentes_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `sadeDB`.`Usuarios` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`Grupos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`Grupos` (
  `idGrupo` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(10) NOT NULL,
  `jornada` ENUM('Mañana', 'Tarde', 'Nocturno', 'Mixto') NOT NULL,
  `salon` INT NULL,
  `grado` TINYINT(2) NOT NULL,
  `director` INT NULL,
  PRIMARY KEY (`idGrupo`),
  INDEX `fk_Grupos_Docentes1_idx` (`director` ASC) VISIBLE,
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE,
  CONSTRAINT `fk_Grupos_Docentes1`
    FOREIGN KEY (`director`)
    REFERENCES `sadeDB`.`Docentes` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`Estudiantes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`Estudiantes` (
  `idUsuario` INT NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `RH` ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', '0+', '0-') NOT NULL,
  `egresado` TINYINT NOT NULL DEFAULT 0,
  `idGrupo` INT NULL,
  PRIMARY KEY (`idUsuario`),
  INDEX `fk_Estudiantes_Grupos1_idx` (`idGrupo` ASC) VISIBLE,
  CONSTRAINT `fk_Estudiantes_Usuarios`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `sadeDB`.`Usuarios` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Estudiantes_Grupos1`
    FOREIGN KEY (`idGrupo`)
    REFERENCES `sadeDB`.`Grupos` (`idGrupo`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`Directivos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`Directivos` (
  `idUsuario` INT NOT NULL,
  `cargo` VARCHAR(50) NOT NULL,
  `direccion` VARCHAR(45) NULL,
  `emailPublico` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idUsuario`),
  CONSTRAINT `fk_Administrativos_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `sadeDB`.`Usuarios` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`DocumentoIdentidad`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`DocumentoIdentidad` (
  `idUsuario` INT NOT NULL,
  `tipoDocumento` ENUM('CC', 'CE', 'RC', 'TI') NOT NULL,
  `numero` VARCHAR(11) NOT NULL,
  `fechaExpedicion` DATE NOT NULL,
  `lugarExpedicion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idUsuario`),
  CONSTRAINT `fk_DocumentoIdentidad_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `sadeDB`.`Usuarios` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`Telefono`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`Telefono` (
  `idTelefono` INT NOT NULL AUTO_INCREMENT,
  `idUsuario` INT NOT NULL,
  `telefono` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`idTelefono`),
  INDEX `fk_Telefono_Usuarios1_idx` (`idUsuario` ASC) VISIBLE,
  CONSTRAINT `fk_Telefono_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `sadeDB`.`Usuarios` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`GruposDocentes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`GruposDocentes` (
  `idGrupo` INT NOT NULL,
  `idDocente` INT NOT NULL,
  PRIMARY KEY (`idGrupo`, `idDocente`),
  INDEX `fk_Grupos_has_Docentes_Docentes1_idx` (`idDocente` ASC) VISIBLE,
  INDEX `fk_Grupos_has_Docentes_Grupos1_idx` (`idGrupo` ASC) VISIBLE,
  CONSTRAINT `fk_Grupos_has_Docentes_Grupos1`
    FOREIGN KEY (`idGrupo`)
    REFERENCES `sadeDB`.`Grupos` (`idGrupo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Grupos_has_Docentes_Docentes1`
    FOREIGN KEY (`idDocente`)
    REFERENCES `sadeDB`.`Docentes` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`Privacidad`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`Privacidad` (
  `idPrivacidad` INT NOT NULL AUTO_INCREMENT,
  `publico` TINYINT NOT NULL DEFAULT 0,
  `directivos` TINYINT NOT NULL DEFAULT 1,
  `docentes` TINYINT NOT NULL DEFAULT 1,
  `estudiantes` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idPrivacidad`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`Publicaciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`Publicaciones` (
  `idPublicacion` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(150) NOT NULL,
  `contenido` TEXT(1000) NOT NULL,
  `fecha` DATETIME NOT NULL DEFAULT now(),
  `idUsuario` INT NOT NULL,
  `idPrivacidad` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idPublicacion`),
  INDEX `fk_Publicaciones_Usuarios1_idx` (`idUsuario` ASC) VISIBLE,
  INDEX `fk_Publicaciones_Privacidad1_idx` (`idPrivacidad` ASC) VISIBLE,
  CONSTRAINT `fk_Publicaciones_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `sadeDB`.`Usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Publicaciones_Privacidad1`
    FOREIGN KEY (`idPrivacidad`)
    REFERENCES `sadeDB`.`Privacidad` (`idPrivacidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`Dislike`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`Dislike` (
  `idPublicacion` INT NOT NULL,
  `idUsuario` INT NOT NULL,
  PRIMARY KEY (`idPublicacion`, `idUsuario`),
  INDEX `fk_Publicaciones_has_Usuarios_Usuarios1_idx` (`idUsuario` ASC) VISIBLE,
  INDEX `fk_Publicaciones_has_Usuarios_Publicaciones1_idx` (`idPublicacion` ASC) VISIBLE,
  CONSTRAINT `fk_Publicaciones_has_Usuarios_Publicaciones1`
    FOREIGN KEY (`idPublicacion`)
    REFERENCES `sadeDB`.`Publicaciones` (`idPublicacion`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Publicaciones_has_Usuarios_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `sadeDB`.`Usuarios` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`Likes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`Likes` (
  `idPublicacion` INT NOT NULL,
  `idUsuario` INT NOT NULL,
  PRIMARY KEY (`idPublicacion`, `idUsuario`),
  INDEX `fk_Publicaciones_has_Usuarios1_Usuarios1_idx` (`idUsuario` ASC) VISIBLE,
  INDEX `fk_Publicaciones_has_Usuarios1_Publicaciones1_idx` (`idPublicacion` ASC) VISIBLE,
  CONSTRAINT `fk_Publicaciones_has_Usuarios1_Publicaciones1`
    FOREIGN KEY (`idPublicacion`)
    REFERENCES `sadeDB`.`Publicaciones` (`idPublicacion`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Publicaciones_has_Usuarios1_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `sadeDB`.`Usuarios` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`Eventos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`Eventos` (
  `idEventos` INT NOT NULL AUTO_INCREMENT,
  `hora` DATETIME NOT NULL DEFAULT now(),
  `descripcion` VARCHAR(100) NOT NULL,
  `idUsuario` INT NOT NULL,
  `idPrivacidad` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idEventos`),
  INDEX `fk_Eventos_Usuarios1_idx` (`idUsuario` ASC) VISIBLE,
  INDEX `fk_Eventos_Privacidad1_idx` (`idPrivacidad` ASC) VISIBLE,
  CONSTRAINT `fk_Eventos_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `sadeDB`.`Usuarios` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Eventos_Privacidad1`
    FOREIGN KEY (`idPrivacidad`)
    REFERENCES `sadeDB`.`Privacidad` (`idPrivacidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`Notificaciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`Notificaciones` (
  `idNotificacion` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(500) NOT NULL,
  `fecha` DATETIME NOT NULL DEFAULT NOW(),
  `directivo` TINYINT NOT NULL DEFAULT 0,
  `docente` TINYINT NOT NULL DEFAULT 0,
  `estudiante` TINYINT NOT NULL DEFAULT 0,
  `idUsuario` INT NULL,
  PRIMARY KEY (`idNotificacion`),
  INDEX `fk_Notificaciones_Usuarios1_idx` (`idUsuario` ASC) VISIBLE,
  CONSTRAINT `fk_Notificaciones_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `sadeDB`.`Usuarios` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sadeDB`.`VistasNotificaciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sadeDB`.`VistasNotificaciones` (
  `idUsuario` INT NOT NULL,
  `idNotificacion` INT NOT NULL,
  PRIMARY KEY (`idUsuario`, `idNotificacion`),
  INDEX `fk_Usuarios_has_Notificaciones_Notificaciones1_idx` (`idNotificacion` ASC) VISIBLE,
  INDEX `fk_Usuarios_has_Notificaciones_Usuarios1_idx` (`idUsuario` ASC) VISIBLE,
  CONSTRAINT `fk_Usuarios_has_Notificaciones_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `sadeDB`.`Usuarios` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Usuarios_has_Notificaciones_Notificaciones1`
    FOREIGN KEY (`idNotificacion`)
    REFERENCES `sadeDB`.`Notificaciones` (`idNotificacion`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `sadeDB` ;

-- -----------------------------------------------------
-- procedure p_eventosMes
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_eventosMes` (IN mes INT, IN anho INT)
BEGIN
	SELECT
		DAY(hora) AS Dia,
		COUNT(*) AS Eventos
	FROM Eventos
	WHERE MONTH(hora) = mes AND YEAR(hora) = anho
	GROUP BY DAY(hora);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_notificacionesUsuario
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_notificacionesUsuario` (IN arg_idUsuario INT)
BEGIN
	SELECT
		n.idNotificacion,
        n.descripcion,
        n.fecha
	FROM Notificaciones n
	WHERE 
	(CASE tipoUsuarioSegunId(arg_idUsuario)
		WHEN 1 THEN n.estudiante = 1
        WHEN 2 THEN n.docente  = 1
        WHEN 3 THEN n.directivo = 1
        ELSE FALSE
    END
    OR n.idUsuario = arg_idUsuario)
    AND 
    NOT EXISTS(SELECT vi.*
	FROM VistasNotificaciones vi 
    WHERE vi.idNotificacion = n.idNotificacion AND vi.idUsuario = arg_idUsuario
    );
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_numNotificaciones
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_numNotificaciones` (IN arg_idUsuario INT)
BEGIN
	SELECT
		COUNT(*) AS notificaciones
	FROM Notificaciones n
	WHERE 
	(CASE tipoUsuarioSegunId(arg_idUsuario)
		WHEN 1 THEN n.estudiante = 1
        WHEN 2 THEN n.docente  = 1
        WHEN 3 THEN n.directivo = 1
        ELSE FALSE
    END
    OR n.idUsuario = arg_idUsuario)
    AND 
    NOT EXISTS(SELECT vi.*
	FROM VistasNotificaciones vi 
    WHERE vi.idNotificacion = n.idNotificacion AND vi.idUsuario = arg_idUsuario
    );
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_pub_numUsuarios
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_pub_numUsuarios`()
BEGIN
	SELECT 
	(SELECT COUNT(*) FROM Estudiantes e INNER JOIN Usuarios u ON u.idUsuario=e.idUsuario WHERE u.delete IS NULL AND e.egresado = 0) AS estudiantes,
    (SELECT COUNT(*) FROM Estudiantes e INNER JOIN Usuarios u ON u.idUsuario=e.idUsuario WHERE u.delete IS NULL AND e.egresado = 1) AS egresados,
    (SELECT COUNT(*) FROM Docentes d INNER JOIN Usuarios u ON u.idUsuario=d.idUsuario WHERE u.delete IS NULL) AS docentes,
    (SELECT COUNT(*) FROM Directivos d INNER JOIN Usuarios u ON u.idUsuario=d.idUsuario WHERE u.delete IS NULL) AS directivos;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_pub_eventosMes
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_pub_eventosMes`(IN mes INT, IN anho INT)
BEGIN
	SELECT
		DAY(e.hora) AS Dia,
		COUNT(*) AS Eventos
	FROM Eventos e
    INNER JOIN Privacidad p ON p.idPrivacidad = e.idPrivacidad
	WHERE MONTH(e.hora) = mes AND YEAR(e.hora) = anho AND p.publico = 1
	GROUP BY DAY(e.hora);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_pub_login
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_pub_login`(IN `usuario` VARCHAR(45))
BEGIN
	DECLARE var_idUsuario INT;
    DECLARE intentos INT;
	SET var_idUsuario = 0;-- Si existe el usuario
    SET intentos = 0; -- Intentos Conexion
    # Si el usuario no es numerico
    IF (usuario  REGEXP '^[0-9]+$') = 0 THEN
		# Verificar si es un email
		IF (usuario REGEXP '[A-Z0-9._%+-]+@[A-Z0-9-]+.+.[A-Z]{2,4}') = 1 THEN
			SELECT idUsuario, intentosConexion INTO var_idUsuario, intentos FROM Usuarios u
			WHERE u.delete IS NULL
			AND email=usuario;
        END IF;
    ELSE
		SELECT u.idUsuario, intentosConexion INTO var_idUsuario, intentos FROM Usuarios u
        INNER JOIN DocumentoIdentidad d ON u.idUsuario=d.idUsuario
        WHERE u.delete IS NULL
        AND numERO=usuario;
    END IF;
    # SI EXISTE EL USUARIO
    IF var_idUsuario > 0 THEN
		IF intentos < 8 THEN
			UPDATE Usuarios SET intentosConexion=intentosConexion+1 WHERE idUsuario=var_idUsuario LIMIT 1;
        END IF;
        SELECT idUsuario,intentosConexion FROM Usuarios WHERE idUsuario=var_idUsuario;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_eventosMes
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_eventosMes`(IN arg_idUsuario INT,IN mes INT, IN anho INT)
BEGIN
	SELECT
		DAY(e.hora) AS Dia,
		COUNT(*) AS Eventos
	FROM Eventos e
    INNER JOIN Privacidad p ON p.idPrivacidad = e.idPrivacidad
	WHERE MONTH(e.hora) = mes AND YEAR(e.hora) = anho AND (p.estudiantes = 1 OR e.idUsuario=arg_idUsuario)
	GROUP BY DAY(e.hora);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_updateDatos
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_updateDatos`(
	IN arg_idUsuario INT, 
    IN arg_direccion VARCHAR(45),
    IN arg_email VARCHAR(45),
    IN arg_contrasenia VARCHAR(500)
)
BEGIN
	IF arg_contrasenia IS NOT NULL OR arg_email IS NOT NULL THEN
		UPDATE Usuarios SET 
			contrasenia = IF(arg_contrasenia IS NULL, contrasenia, arg_contrasenia),
            email = IF(arg_email IS NULL, email, arg_email)
		WHERE idUsuario = arg_idUsuario;
    END IF;
    IF arg_direccion IS NOT NULL THEN
		UPDATE Estudiantes SET 
			direccion = arg_direccion
		WHERE idUsuario = arg_idUsuario;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_verDatosEstudiante
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_verDatosEstudiante` (IN arg_idUsuario INT)
BEGIN
	SELECT * FROM vs_datosestudiantes WHERE idUsuario = arg_idUsuario LIMIT 1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_verTelefonos
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_verTelefonos` (IN arg_idUsuario INT)
BEGIN
	SELECT 
		idTelefono,
        telefono
    FROM vs_telefonostipousuario 
    WHERE idUsuario=arg_idUsuario AND tipo=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_deleteTelefono
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_deleteTelefono` (IN arg_idTelefono INT, IN arg_idUsuario INT)
BEGIN
    IF tipoUsuarioSegunId(arg_idUsuario) = 1 THEN
		DELETE FROM Telefono WHERE idTelefono=arg_idTelefono AND idUsuario = arg_idUsuario;
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_addTelefono
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_addTelefono` (IN arg_idUsuario INT, IN arg_telefono VARCHAR(15))
BEGIN
    IF tipoUsuarioSegunId(arg_idUsuario) = 1 THEN
		INSERT Telefono (idUsuario,telefono) VALUES (arg_idUsuario,arg_telefono);
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_editTelefono
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_editTelefono` (IN arg_idTelefono INT, IN arg_idUsuario INT, IN arg_telefono VARCHAR(15))
BEGIN
    IF tipoUsuarioSegunId(arg_idUsuario) = 1 THEN
		UPDATE Telefono SET 
			telefono=arg_telefono 
		WHERE idTelefono=arg_idTelefono AND idUsuario = arg_idUsuario;
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_vistoNotificacion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_vistoNotificacion` (IN arg_idNotificacion INT, IN arg_idUsuario INT)
BEGIN
	IF tipoUsuarioSegunId(arg_idUsuario) = 1 THEN
		INSERT INTO VistasNotificaciones (idUsuario, idNotificacion)
		SELECT * FROM (SELECT arg_idUsuario, arg_idNotificacion) AS tmp
		WHERE NOT EXISTS (
			SELECT * FROM VistasNotificaciones WHERE idUsuario=arg_idUsuario AND idNotificacion=arg_idNotificacion
		) LIMIT 1;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_addPublicacion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_addPublicacion` 
(
	IN arg_titulo VARCHAR(150),
    IN arg_contenido TEXT(1000),
    IN arg_privacidad INT,
    IN arg_idUsuario INT,
    IN arg_fecha DATETIME
)
BEGIN
	IF tipoUsuarioSegunId(arg_idUsuario) = 1 AND arg_privacidad != 1 THEN
		INSERT INTO Publicaciones
        (titulo,contenido,fecha,idUsuario,idPrivacidad) VALUES
        (arg_titulo,arg_contenido,arg_fecha,arg_idUsuario,arg_privacidad);
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_deletePublicacion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_deletePublicacion` (IN arg_idPublicacon INT, IN arg_idUsuario INT)
BEGIN
    IF tipoUsuarioSegunId(arg_idUsuario) = 1 THEN
		DELETE FROM Publicaciones WHERE idPublicacion = arg_idPublicacion AND idUsuario = arg_idUsuario;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_editPublicacion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_editPublicacion` 
(
	IN arg_idPublicacon INT,
    IN arg_idUsuario INT,
    IN arg_titulo VARCHAR(150), 
    IN arg_contenido TEXT(1000)
)
BEGIN
    IF tipoUsuarioSegunId(arg_idUsuario)  = 1 THEN
		UPDATE Publicaciones 
        SET 
			titulo = IF(arg_titulo IS NULL,titulo,arg_titulo),
			contenido = IF(arg_contenido IS NULL,contenido,arg_contenido)
		WHERE idPublicacion = arg_idPublicacion AND idUsuario = arg_idUsuario;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_addPublicacion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_addPublicacion` 
(
	IN arg_titulo VARCHAR(150),
    IN arg_contenido TEXT(1000),
    IN arg_privacidad INT,
    IN arg_idUsuario INT,
    IN arg_fecha DATETIME
)
BEGIN
	IF tipoUsuarioSegunId(arg_idUsuario) = 2 THEN
		INSERT INTO Publicaciones
        (titulo,contenido,fecha,idUsuario,idPrivacidad) VALUES
        (arg_titulo,arg_contenido,arg_fecha,arg_idUsuario,arg_privacidad);
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_addTelefono
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_addTelefono` (IN arg_idUsuario INT, IN arg_telefono VARCHAR(15))
BEGIN
    IF tipoUsuarioSegunId(arg_idUsuario) = 2 THEN
		INSERT Telefono (idUsuario,telefono) VALUES (arg_idUsuario,arg_telefono);
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_deletePublicacion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_deletePublicacion` (IN arg_idPublicacon INT, IN arg_idUsuario INT)
BEGIN
    IF tipoUsuarioSegunId(arg_idUsuario) = 2 THEN
		DELETE FROM Publicaciones WHERE idPublicacion = arg_idPublicacion AND idUsuario = arg_idUsuario;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_deleteTelefono
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_deleteTelefono` (IN arg_idTelefono INT, IN arg_idUsuario INT)
BEGIN
    IF tipoUsuarioSegunId(arg_idUsuario) = 2 THEN
		DELETE FROM Telefono WHERE idTelefono=arg_idTelefono AND idUsuario = arg_idUsuario;
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_editPublicacion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_editPublicacion` 
(
	IN arg_idPublicacon INT,
    IN arg_idUsuario INT,
    IN arg_titulo VARCHAR(150), 
    IN arg_contenido TEXT(1000)
)
BEGIN
    IF tipoUsuarioSegunId(arg_idUsuario)  = 2 THEN
		UPDATE Publicaciones 
        SET 
			titulo = IF(arg_titulo IS NULL,titulo,arg_titulo),
			contenido = IF(arg_contenido IS NULL,contenido,arg_contenido)
		WHERE idPublicacion = arg_idPublicacion AND idUsuario = arg_idUsuario;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_editTelefono
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_editTelefono` (IN arg_idTelefono INT, IN arg_idUsuario INT, IN arg_telefono VARCHAR(15))
BEGIN
    IF tipoUsuarioSegunId(arg_idUsuario) = 2 THEN
		UPDATE Telefono SET 
			telefono=arg_telefono 
		WHERE idTelefono=arg_idTelefono AND idUsuario = arg_idUsuario;
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_eventosMes
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_eventosMes`(IN arg_idUsuario INT,IN mes INT, IN anho INT)
BEGIN
	SELECT
		DAY(e.hora) AS Dia,
		COUNT(*) AS Eventos
	FROM Eventos e
    INNER JOIN Privacidad p ON p.idPrivacidad = e.idPrivacidad
	WHERE MONTH(e.hora) = mes AND YEAR(e.hora) = anho AND (p.estudiantes = 2 OR e.idUsuario = arg_idUsuario)
	GROUP BY DAY(e.hora);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_updateDatos
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_updateDatos`(
	IN arg_idUsuario INT, 
    IN arg_direccion VARCHAR(45),
    IN arg_perfilAcademico VARCHAR(45),
    IN arg_email VARCHAR(45),
    IN arg_contrasenia VARCHAR(500)
)
BEGIN
	IF arg_contrasenia IS NOT NULL OR arg_email IS NOT NULL THEN
		UPDATE Usuarios SET 
			contrasenia = IF(arg_contrasenia IS NULL, contrasenia, arg_contrasenia),
            email = IF(arg_email IS NULL, email, arg_email)
		WHERE idUsuario = arg_idUsuario;
    END IF;
    IF arg_direccion IS NOT NULL OR arg_perfilAcademico IS NOT NULL THEN
		UPDATE Docentes SET 
			direccion = IF(arg_direccion IS NULL, direccion, arg_direccion),
            perfilAcademico = IF(arg_perfilAcademico IS NULL, perfilAcademico, perfilAcademico)
		WHERE idUsuario = arg_idUsuario;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_verDatosEstudiante
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_verDatosEstudiante` (IN arg_idUsuario INT)
BEGIN
	SELECT * FROM vs_datosdocentes WHERE idUsuario = arg_idUsuario LIMIT 1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_verTelefonos
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_verTelefonos` (IN arg_idUsuario INT)
BEGIN
	SELECT 
		idTelefono,
        telefono
    FROM vs_telefonostipousuario 
    WHERE idUsuario=arg_idUsuario AND tipo=2;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_vistoNotificacion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_vistoNotificacion` (IN arg_idNotificacion INT, IN arg_idUsuario INT)
BEGIN
	IF tipoUsuarioSegunId(arg_idUsuario) = 2 THEN
		INSERT INTO VistasNotificaciones (idUsuario, idNotificacion)
		SELECT * FROM (SELECT arg_idUsuario, arg_idNotificacion) AS tmp
		WHERE NOT EXISTS (
			SELECT * FROM VistasNotificaciones WHERE idUsuario=arg_idUsuario AND idNotificacion=arg_idNotificacion
		) LIMIT 1;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_misGruposClases
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_misGruposClases` (IN arg_idUsuario INT)
BEGIN
	SELECT
		g.*
	FROM GruposDocentes gd
    INNER JOIN Grupos g ON g.idGrupo = gd.idGrupo
    WHERE gd.idDocente = arg_idUsuario;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_misGruposDireccion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_misGruposDireccion` (IN arg_idUsuario INT)
BEGIN
	SELECT * FROM Grupos WHERE director = arg_idUsuario;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_dir_eventosMes
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_dir_eventosMes`(IN arg_idUsuario INT,IN mes INT, IN anho INT)
BEGIN
	SELECT
		DAY(e.hora) AS Dia,
		COUNT(*) AS Eventos
	FROM Eventos e
    INNER JOIN Privacidad p ON p.idPrivacidad = e.idPrivacidad
	WHERE MONTH(e.hora) = mes AND YEAR(e.hora) = anho AND (p.estudiantes = 3 OR e.idUsuario = arg_idUsuario)
	GROUP BY DAY(e.hora);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_buscarEstudiante
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_buscarEstudiante` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		*
	FROM
		vs_est_infoestudiantes
	WHERE
	nombre LIKE CONCAT('%',busqueda,'%')
	OR email LIKE CONCAT(busqueda,'%')
	OR nombreGrupo LIKE CONCAT(busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_buscarDocente
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_buscarDocente` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		*
	FROM
		vs_est_infodocentes
	WHERE
	nombre LIKE CONCAT('%',busqueda,'%')
	OR email LIKE CONCAT(busqueda,'%')
	OR perfilAcademico LIKE CONCAT('%',busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_buscarDirectivo
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_buscarDirectivo` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		*
	FROM
		vs_est_infodirectivos
	WHERE
	nombre LIKE CONCAT('%',busqueda,'%')
	OR emailPublico LIKE CONCAT(busqueda,'%')
	OR cargo LIKE CONCAT(busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_buscarGrupo
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_buscarGrupo` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		*
	FROM
		grupos
	WHERE
	nombre LIKE CONCAT(busqueda,'%')
	OR jornada LIKE CONCAT(busqueda,'%')
	OR salon LIKE CONCAT(busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_buscarEvento
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_buscarEvento` ()
BEGIN
	SELECT 
		* 
	FROM vs_est_eventos
	WHERE
	descripcion LIKE CONCAT('%',busqueda,'%')
	OR nombreCompleto LIKE CONCAT('%',busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_est_buscarPublicacion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_est_buscarPublicacion` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		* 
	FROM vs_est_publicaciones
	WHERE
	titulo LIKE CONCAT('%',busqueda,'%')
	OR contenido LIKE CONCAT('%',busqueda,'%')
	OR nombreCompleto LIKE CONCAT('%',busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_pub_buscarDirectivo
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_pub_buscarDirectivo` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		* 
	FROM vs_pub_directivos
	WHERE
	nombre LIKE CONCAT('%',busqueda,'%')
	OR emailPublico LIKE CONCAT(busqueda,'%')
	OR cargo LIKE CONCAT(busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_pub_buscarPublicacion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_pub_buscarPublicacion` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		* 
	FROM vs_pub_publicaciones
	WHERE
	titulo LIKE CONCAT('%',busqueda,'%')
	OR contenido LIKE CONCAT('%',busqueda,'%')
	OR nombreCompleto LIKE CONCAT('%',busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_pub_buscarEvento
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_pub_buscarEvento` ()
BEGIN
	SELECT 
		*
	FROM vs_pub_eventos
	WHERE
	descripcion LIKE CONCAT('%',busqueda,'%')
	OR nombreCompleto LIKE CONCAT('%',busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_buscarDirectivo
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_buscarDirectivo` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		*
	FROM
		vs_prf_infodirectivo
	WHERE
	nombre LIKE CONCAT('%',busqueda,'%')
    OR email LIKE CONCAT(busqueda,'%')
	OR emailPublico LIKE CONCAT(busqueda,'%')
	OR cargo LIKE CONCAT(busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_buscarDocente
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_buscarDocente` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		*
	FROM
		vs_prf_infodocentes
	WHERE
	nombre LIKE CONCAT('%',busqueda,'%')
	OR email LIKE CONCAT(busqueda,'%')
	OR perfilAcademico LIKE CONCAT('%',busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_buscarEstudiante
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_buscarEstudiante` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		*
	FROM
		vs_prf_infoestudiantes
	WHERE
	nombre LIKE CONCAT('%',busqueda,'%')
	OR email LIKE CONCAT(busqueda,'%')
	OR nombreGrupo LIKE CONCAT(busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_buscarEvento
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_buscarEvento` ()
BEGIN
	SELECT 
		* 
	FROM vs_prf_eventos
	WHERE
	descripcion LIKE CONCAT('%',busqueda,'%')
	OR nombreCompleto LIKE CONCAT('%',busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_buscarGrupo
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_buscarGrupo` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		*
	FROM
		grupos
	WHERE
	nombre LIKE CONCAT(busqueda,'%')
	OR jornada LIKE CONCAT(busqueda,'%')
	OR salon LIKE CONCAT(busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_prf_buscarPublicacion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_prf_buscarPublicacion` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		* 
	FROM vs_prf_publicaciones
	WHERE
	titulo LIKE CONCAT('%',busqueda,'%')
	OR contenido LIKE CONCAT('%',busqueda,'%')
	OR nombreCompleto LIKE CONCAT('%',busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_dir_buscarDirectivo
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_dir_buscarDirectivo` (IN busqueda VARCHAR(100))
BEGIN
	SELECT
		* 
	FROM vs_infodirectivos
	WHERE
	nombre LIKE CONCAT('%',busqueda,'%')
	OR email LIKE CONCAT(busqueda,'%')
	OR emailPublico LIKE CONCAT(busqueda,'%')
	OR cargo LIKE CONCAT(busqueda,'%')
	OR documentoIdentidad LIKE CONCAT('%',busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_dir_buscarDocente
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_dir_buscarDocente` (IN buscar VARCHAR(100))
BEGIN
	SELECT 
		* 
	FROM vs_infodocentes
	WHERE
	nombre LIKE CONCAT('%',busqueda,'%')
	OR email LIKE CONCAT(busqueda,'%')
	OR perfilAcademico LIKE CONCAT('%',busqueda,'%')
	OR documentoIdentidad LIKE CONCAT('%',busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_dir_buscarEstudiante
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_dir_buscarEstudiante` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		* 
	FROM vs_infoestudiantes
	WHERE
	nombre LIKE CONCAT('%',busqueda,'%')
	OR email LIKE CONCAT(busqueda,'%')
	OR documentoIdentidad LIKE CONCAT('%',busqueda,'%')
	OR nombreGrupo LIKE CONCAT(busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_dir_buscarEvento
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_dir_buscarEvento` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		* 
	FROM vs_dir_eventos
	WHERE
	descripcion LIKE CONCAT('%',busqueda,'%')
	OR nombreCompleto LIKE CONCAT('%',busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_dir_buscarGrupo
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_dir_buscarGrupo` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		*
	FROM
		grupos
	WHERE
	nombre LIKE CONCAT(busqueda,'%')
	OR jornada LIKE CONCAT(busqueda,'%')
	OR salon LIKE CONCAT(busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure p_dir_buscarPublicacion
-- -----------------------------------------------------

DELIMITER $$
USE `sadeDB`$$
CREATE PROCEDURE `p_dir_buscarPublicacion` (IN busqueda VARCHAR(100))
BEGIN
	SELECT 
		* 
	FROM vs_dir_publicaciones
	WHERE
	titulo LIKE CONCAT('%',busqueda,'%')
	OR contenido LIKE CONCAT('%',busqueda,'%')
	OR nombreCompleto LIKE CONCAT('%',busqueda,'%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_infousuario`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_infousuario` AS
SELECT 
	idUsuario, 
    CONCAT_WS(' ',nombres,apellido1) AS nombreCompleto, 
    CASE tipo 
		WHEN 1 THEN 'estudiante'
        WHEN 2 THEN 'profesor'
        WHEN 3 THEN 'directivo'
    END AS tipo,
    fotoPerfil AS foto
FROM Usuarios;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_publicaciones`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_publicaciones` AS
SELECT 
	p.idPublicacion,
    p.titulo,
    p.contenido,
    p.fecha,
    viu.*,
    (SELECT COUNT(*) FROM likes l WHERE l.idPublicacion=p.idPublicacion) AS nlikes,
    (SELECT COUNT(*) FROM dislike l WHERE l.idPublicacion=p.idPublicacion) AS ndislikes,
    pv.publico,
    pv.directivos,
    pv.docentes,
    pv.estudiantes
FROM Publicaciones p
INNER JOIN vs_infousuario viu ON viu.idUsuario = p.idUsuario
INNER JOIN Privacidad pv ON pv.idPrivacidad = p.idPrivacidad;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_eventos`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_eventos` AS
SELECT 
	e.idEventos,
    e.hora,
    e.descripcion,
    e.idUsuario,
    viu.nombreCompleto,
    viu.tipo,
    pv.publico,
    pv.directivos,
    pv.docentes,
    pv.estudiantes
FROM Eventos e
INNER JOIN vs_infousuario viu ON viu.idUsuario = e.idUsuario
INNER JOIN Privacidad pv ON pv.idPrivacidad = e.idPrivacidad;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_datosUsuarios`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_datosUsuarios` AS
SELECT
	u.idUsuario,
    u.nombres,
    u.apellido1,
    u.apellido2,
    u.email,
    u.tipo,
    u.sexo,
    u.fechaNacimiento,
    u.fechaRegistro,
    u.fotoPerfil,
    di.tipoDocumento,
    di.numero,
    di.fechaExpedicion,
    di.lugarExpedicion
FROM Usuarios u
LEFT JOIN DocumentoIdentidad di ON di.idUsuario = u.idUsuario
WHERE u.delete IS NULL;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_datosEstudiantes`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_datosEstudiantes` AS
SELECT
	vdu.*,
    e.direccion,
    e.RH,
    e.egresado,
    e.idGrupo,
    g.nombre AS nombreGrupo,
    g.grado
FROM Estudiantes e
INNER JOIN vs_datosusuarios vdu ON vdu.idUsuario = e.idUsuario
LEFT JOIN Grupos g ON g.idGrupo = e.idGrupo;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_datosdocentes`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_datosdocentes` AS
SELECT
	vdu.*,
    d.direccion,
    d.perfilAcademico
FROM Docentes d
INNER JOIN vs_datosusuarios vdu ON vdu.idUsuario = d.idUsuario;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_datosdirectivo`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_datosdirectivo` AS
SELECT
	vdu.*,
    d.direccion,
    d.cargo,
    emailPublico
FROM Directivos d
INNER JOIN vs_datosusuarios vdu ON vdu.idUsuario = d.idUsuario;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_infodirectivos`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_infodirectivos` AS
SELECT
	d.idUsuario,
    CONCAT_WS(' ',nombres, apellido1, apellido2) AS nombre,
    fotoPerfil,
    email,
    emailPublico,
    CONCAT_WS('-',tipoDocumento,numero) AS documentoIdentidad,
    cargo,
    MAX(telefono) AS telefono
FROM Directivos d
INNER JOIN vs_datosusuarios vdu ON vdu.idUsuario = d.idUsuario
LEFT JOIN Telefono t ON t.idUsuario = d.idUsuario
GROUP BY idTelefono;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_infodocentes`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_infodocentes` AS
SELECT
	d.idUsuario,
    CONCAT_WS(' ',nombres, apellido1, apellido2) AS nombre,
    fotoPerfil,
    email,
    CONCAT_WS('-',tipoDocumento,numero) AS documentoIdentidad,
    perfilAcademico,
    MAX(telefono) AS telefono
FROM Docentes d
INNER JOIN vs_datosusuarios vdu ON vdu.idUsuario = d.idUsuario
LEFT JOIN Telefono t ON t.idUsuario = d.idUsuario
GROUP BY idTelefono;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_infoestudiantes`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_infoestudiantes` AS
SELECT
	e.idUsuario,
    CONCAT_WS(' ',nombres, apellido1, apellido2) AS nombre,
    fotoPerfil,
    email,
    CONCAT_WS('-',tipoDocumento,numero) AS documentoIdentidad,
    egresado,
    e.idGrupo,
    g.nombre AS nombreGrupo,
    MAX(telefono) AS telefono
FROM Estudiantes e
INNER JOIN vs_datosusuarios vdu ON vdu.idUsuario = e.idUsuario
LEFT JOIN Telefono t ON t.idUsuario = e.idUsuario
LEFT JOIN Grupos g ON g.idGrupo = e.idGrupo
GROUP BY idTelefono;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_pub_publicaciones`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_pub_publicaciones` AS
SELECT
	idPublicacion,
    titulo,
    contenido,
    fecha,
    nombreCompleto,
    tipo,
    foto,
    nlikes,
    ndislikes
FROM vs_publicaciones
WHERE publico = 1;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_pub_eventos`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_pub_eventos` AS
SELECT
	idEventos,
    hora,
    descripcion,
    nombreCompleto,
    tipo
FROM vs_eventos
WHERE publico = 1;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_pub_directivos`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_pub_directivos` AS
SELECT
	nombre,
    fotoPerfil,
    emailPublico,
    cargo
FROM vs_infodirectivos;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_est_publicaciones`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_est_publicaciones` AS
SELECT
	idPublicacion,
    titulo,
    contenido,
    fecha,
    idUsuario,
    nombreCompleto,
    tipo,
    foto,
    nlikes,
    ndislikes
FROM vs_publicaciones
WHERE estudiantes = 1;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_prf_publicaciones`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_prf_publicaciones` AS
SELECT
	idPublicacion,
    titulo,
    contenido,
    fecha,
    idUsuario,
    nombreCompleto,
    tipo,
    foto,
    nlikes,
    ndislikes
FROM vs_publicaciones
WHERE docentes = 1;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_dir_publicaciones`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_dir_publicaciones` AS
SELECT
	idPublicacion,
    titulo,
    contenido,
    fecha,
    idUsuario,
    nombreCompleto,
    tipo,
    foto,
    nlikes,
    ndislikes
FROM vs_publicaciones
WHERE directivos = 1;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_est_eventos`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_est_eventos` AS
SELECT
	idEventos,
    hora,
    descripcion,
    idUsuario,
    nombreCompleto,
    tipo
FROM vs_eventos
WHERE estudiantes = 1;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_est_infodocentes`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_est_infodocentes` AS
SELECT
	idUsuario,
    nombre,
    fotoPerfil,
    email,
    perfilAcademico
FROM vs_infodocentes;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_est_infoestudiantes`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_est_infoestudiantes` AS
SELECT
	idUsuario,
    nombre,
    fotoPerfil,
    email,
    egresado,
    idGrupo,
    nombreGrupo
FROM vs_infoestudiantes;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_est_infodirectivos`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_est_infodirectivos` AS
SELECT
	idUsuario,
    nombre,
    fotoPerfil,
    emailPublico,
    cargo
FROM vs_infodirectivos;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_est_gradosdocentes`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_est_gradosdocentes` AS
SELECT
	g.idGrupo,
    g.nombre AS nombreGrupo,
    vid.*
FROM GruposDocentes gd
INNER JOIN vs_est_infodocentes vid ON vid.idUsuario=gd.idDocente
INNER JOIN Grupos g ON g.idGrupo = gd.idGrupo;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_telefonostipousuario`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_telefonostipousuario` AS
SELECT
	t.*,
    u.tipo
FROM Telefono t
INNER JOIN Usuarios u ON t.idUsuario = u.idUsuario;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_prf_infodocentes`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_prf_infodocentes` AS
SELECT
	idUsuario,
    nombre,
    fotoPerfil,
    email,
    perfilAcademico
FROM vs_infodocentes;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_prf_infodirectivo`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_prf_infodirectivo` AS
SELECT 
	idUsuario,
    nombre,
    fotoPerfil,
    email,
    emailPublico,
    cargo,
    telefono
FROM vs_infodirectivos;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_prf_infoestudiantes`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_prf_infoestudiantes` AS
SELECT
	idUsuario,
    nombre,
    fotoPerfil,
    email,
    egresado,
    idGrupo,
    nombreGrupo
FROM vs_infoestudiantes;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_prf_eventos`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_prf_eventos` AS
SELECT
	idEventos,
    hora,
    descripcion,
    idUsuario,
    nombreCompleto,
    tipo
FROM vs_eventos
WHERE docentes = 1;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_prf_gradosdocentes`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_prf_gradosdocentes` AS
SELECT
	g.idGrupo,
    g.nombre AS nombreGrupo,
    vid.*
FROM GruposDocentes gd
INNER JOIN vs_prf_infodocentes vid ON vid.idUsuario=gd.idDocente
INNER JOIN Grupos g ON g.idGrupo = gd.idGrupo;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_prf_estudiantesClase`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_prf_estudiantesClase` AS
SELECT
	idUsuario,
	nombres,
	apellido1,
	apellido2,
	email,
	RH,
    fotoPerfil,
    idGrupo
FROM vs_datosestudiantes;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_prf_estudiantesDirector`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_prf_estudiantesDirector` AS
SELECT
	de.idUsuario,
	de.nombres,
	de.apellido1,
	de.apellido2,
	de.email,
	de.RH,
    de.fotoPerfil,
    de.tipoDocumento,
    de.numero AS numeroDocumento,
    de.direccion,
    de.fechaNacimiento,
    de.sexo,
    de.idGrupo,
    MAX(t.telefono) AS telefono
FROM vs_datosestudiantes de
INNER JOIN Telefono t ON t.idUsuario = de.idUsuario
GROUP BY de.idUsuario;

-- -----------------------------------------------------
-- View `sadeDB`.`vs_dir_eventos`
-- -----------------------------------------------------
USE `sadeDB`;
CREATE  OR REPLACE VIEW `vs_dir_eventos` AS
SELECT
	idEventos,
    hora,
    descripcion,
    idUsuario,
    nombreCompleto,
    tipo
FROM vs_eventos
WHERE directivos = 1;
USE `sadeDB`;

DELIMITER $$
USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Usuarios_AFTER_INSERT` AFTER INSERT ON `Usuarios` FOR EACH ROW
BEGIN
	# Notificacion de bienvenido
	DECLARE var_descripcion VARCHAR(200);
    SET var_descripcion = CONCAT('Hola ',NEW.Nombres,' bienvenido a la plataforma SADE, has sido registrado como ',tipoUsuario(NEW.tipo),', aquí podras estar al día con información y tus datos institucionales.');
    INSERT INTO Notificaciones
	(descripcion, fecha, idUsuario) VALUES
	(var_descripcion, NOW(), NEW.idUsuario);
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Usuarios_AFTER_UPDATE` AFTER UPDATE ON `Usuarios` FOR EACH ROW
BEGIN
	# Crear Notificacion cambio de datos
	DECLARE var_descripcion VARCHAR(200);
    SET var_descripcion = OLD.nombres;
    # Si se cambia la contraseña
    IF OLD.contrasenia <> NEW.contrasenia THEN
		SET var_descripcion = CONCAT_WS(' ',var_descripcion,'tu contraseña ha sido cambiada.');
        INSERT INTO Notificaciones
		(descripcion, fecha, idUsuario) VALUES
		(var_descripcion, NOW(), OLD.idUsuario);
    END IF;
    # Si se cambian datos
    IF 
		OLD.nombres <> NEW.nombres
        OR OLD.apellido1 <> NEW.apellido1
        OR OLD.apellido2 <> NEW.apellido2
        OR OLD.email <> NEW.email
        OR OLD.sexo <> NEW.sexo
        OR OLD.fechaNacimiento <> NEW.fechaNacimiento
        OR OLD.fotoPerfil <> NEW.fotoPerfil
    THEN
		SET var_descripcion = CONCAT_WS(' ',var_descripcion,'se actualizarón tus datos, verifica que estos esten correctos.');
		INSERT INTO Notificaciones
		(descripcion, fecha, idUsuario) VALUES
		(var_descripcion, NOW(), OLD.idUsuario);
	END IF;
    # si se "elimina" el usuario
    IF NEW.delete IS NOT NULL THEN
		SET var_descripcion = CONCAT_WS(' ','El',tipoUsuario(OLD.tipo),CONCAT_WS(' ',OLD.nombres,OLD.apellido1,OLD.apellido2),'ha sido eliminado.');
        INSERT INTO Notificaciones
		(descripcion, fecha, directivo) VALUES
		(var_descripcion, NOW(), 1);
    END IF;
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Docentes_AFTER_UPDATE` AFTER UPDATE ON `Docentes` FOR EACH ROW
BEGIN
	# Generar Notificaciones
    DECLARE var_descripcion VARCHAR(200);
    DECLARE var_nombre VARCHAR(60);
    IF 
		NEW.direccion <> OLD.direccion 
        OR NEW.perfilAcademico <> OLD.perfilAcademico
	THEN
		SELECT nombres INTO var_nombre FROM Usuarios WHERE idUsuario = OLD.idUsuario;
		SET var_descripcion = CONCAT(var_nombre,', tus datos han sido actualizados, verifica que estos sean correctos.');
        INSERT INTO Notificaciones
		(descripcion, fecha, idUsuario) VALUES
		(var_descripcion, NOW(), OLD.idUsuario);
    END IF;
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Grupos_AFTER_INSERT` AFTER INSERT ON `Grupos` FOR EACH ROW
BEGIN
	# Generar Notificaciones
    DECLARE var_descripcion VARCHAR(200);
    SET var_descripcion = CONCAT('Se creó el grupo ',NEW.nombre,' en la jornada ',NEW.jornada,'.');
	INSERT INTO Notificaciones
	(descripcion, fecha, directivo) VALUES
	(var_descripcion, NOW(), 1);
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Grupos_AFTER_UPDATE` AFTER UPDATE ON `Grupos` FOR EACH ROW
BEGIN
	# Generar Notificaciones
    DECLARE var_descripcion VARCHAR(200);
    DECLARE var_nombreDirector VARCHAR(200);
    SET var_descripcion = CONCAT('El grupo ',OLD.nombre);
    IF OLD.jornada <> NEW.jornada THEN
		SET var_descripcion = CONCAT(var_descripcion,' cambió a la jornada ',NEW.jornada,'.');
		# Notificar a estudiantes del grupo
        INSERT INTO Notificaciones 
		(descripcion, fecha, idUsuario)
        SELECT
        var_descripcion, NOW(), e.idUsuario
        FROM Estudiantes e
        WHERE e.idGrupo = OLD.idGrupo;
        # Notificar a docentes del grupo
        INSERT INTO Notificaciones 
		(descripcion, fecha, idUsuario)
        SELECT
        var_descripcion, NOW(), gd.idDocente
        FROM GruposDocentes gd
        WHERE gd.idGrupo = OLD.idGrupo;
    END IF;
    IF OLD.salon <> NEW.salon AND NEW.salon IS NOT NULL THEN
		SET var_descripcion = CONCAT(var_descripcion,' cambió al salón ',NEW.salon,'.');
		# Notificar a estudiantes del grupo
        INSERT INTO Notificaciones 
		(descripcion, fecha, idUsuario)
        SELECT
        var_descripcion, NOW(), e.idUsuario
        FROM Estudiantes e
        WHERE e.idGrupo = OLD.idGrupo;
        # Notificar a docentes del grupo
        INSERT INTO Notificaciones 
		(descripcion, fecha, idUsuario)
        SELECT
        var_descripcion, NOW(), gd.idDocente
        FROM GruposDocentes gd
        WHERE gd.idGrupo = OLD.idGrupo;
    END IF;
    IF OLD.director <> NEW.director OR NEW.director IS NOT NULL THEN
		SELECT CONCAT_WS(' ',nombres,apellido1,apellido2) INTO var_nombreDirector FROM Usuarios WHERE idUsuario = NEW.director;
		SET var_descripcion = CONCAT('El profesor ',var_nombreDirector,' ahora es director del grado ',OLD.nombre,'.');
		# Notificar a estudiantes del grupo
        INSERT INTO Notificaciones 
		(descripcion, fecha, idUsuario)
        SELECT
        var_descripcion, NOW(), e.idUsuario
        FROM Estudiantes e
        WHERE e.idGrupo = OLD.idGrupo;
        # Notificar a docentes del grupo
        INSERT INTO Notificaciones 
		(descripcion, fecha, idUsuario)
        SELECT
        var_descripcion, NOW(), gd.idDocente
        FROM GruposDocentes gd
        WHERE gd.idGrupo = OLD.idGrupo;
    END IF;
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Grupos_AFTER_DELETE` AFTER DELETE ON `Grupos` FOR EACH ROW
BEGIN
	# Generar Notificaciones
    DECLARE var_descripcion VARCHAR(200);
    SET var_descripcion = CONCAT('Se eliminó el grupo ',OLD.nombre,'.');
	INSERT INTO Notificaciones
	(descripcion, fecha, directivo) VALUES
	(var_descripcion, NOW(), 1);
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Estudiantes_BEFORE_UPDATE` BEFORE UPDATE ON `Estudiantes` FOR EACH ROW
BEGIN
	# Si es egresado
    IF NEW.egresado = 1 THEN
        SET NEW.idGrupo = NULL;
    END IF;
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Estudiantes_AFTER_UPDATE` AFTER UPDATE ON `Estudiantes` FOR EACH ROW
BEGIN
	# Crear Notificaciones
    DECLARE var_descripcion VARCHAR(200);
    DECLARE var_nombreGrupo VARCHAR(10);
    DECLARE var_gradoAnterior TINYINT(2);
    DECLARE var_gradoNuevo TINYINT(2);
    SELECT nombres INTO var_descripcion FROM Usuarios WHERE idUsuario=OLD.idUsuario;
    # Si se cambia el grupo
    IF OLD.idGrupo <> NEW.idGrupo THEN
		SELECT grado INTO var_gradoAnterior FROM Grupos WHERE idGrupo = OLD.idGrupo;
        SELECT grado,nombre INTO var_gradoNuevo,var_nombreGrupo FROM Grupos WHERE idGrupo = NEW.idGrupo;
		IF var_gradoNuevo > var_gradoAnterior THEN
			SET var_descripcion = CONCAT(var_descripcion,' has sido promovido al grado ',var_gradoNuevo,'°, felicidades, ahora eres parte del grupo ',var_nombreGrupo,'.');
        ELSE
			SET var_descripcion = CONCAT(var_descripcion,' ahora eres parte del grupo ',var_nombreGrupo,'.');
        END IF;
        INSERT INTO Notificaciones
		(descripcion, fecha, idUsuario) VALUES
		(var_descripcion, NOW(), OLD.idUsuario);
    END IF;
    # Si es egresado
    IF NEW.egresado = 1 THEN
        SET var_descripcion = CONCAT(var_descripcion,' ahora eres egresado, esperamos seguir viendote por aquí.');
        INSERT INTO Notificaciones
		(descripcion, fecha, idUsuario) VALUES
		(var_descripcion, NOW(), OLD.idUsuario);
    END IF;
    # Cambio de datos
    IF 
		OLD.direccion <> NEW.direccion
        OR OLD.RH <> NEW.RH
    THEN
		SET var_descripcion = CONCAT_WS(' ',var_descripcion,'se actualizarón tus datos, verifica que estos esten correctos.');
		INSERT INTO Notificaciones
		(descripcion, fecha, idUsuario) VALUES
		(var_descripcion, NOW(), OLD.idUsuario);
	END IF;
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Directivos_AFTER_UPDATE` AFTER UPDATE ON `Directivos` FOR EACH ROW
BEGIN
	# Generar Notificaciones
    DECLARE var_descripcion VARCHAR(200);
    DECLARE var_nombre VARCHAR(200);
    # Notificar cambio de cargo
    IF NEW.cargo <> OLD.cargo THEN
		SELECT CONCAT_WS(' ',nombres,apellido1,apellido2) INTO var_nombre FROM Usuarios WHERE idUsuario = OLD.idUsuario;
		SET var_descripcion = CONCAT('Te informamos que ',var_nombre,' ahora ejerce el cargo de ',NEW.cargo,'.');
        INSERT INTO Notificaciones
		(descripcion, fecha, directivo, docente, estudiante) VALUES
		(var_descripcion, NOW(), 1,1,1);
    END IF;
    # Notificar cambio de datos
    IF 
		NEW.direccion <> OLD.direccion 
        OR NEW.emailPublico <> OLD.emailPublico
	THEN
		SELECT nombres INTO var_nombre FROM Usuarios WHERE idUsuario = OLD.idUsuario;
		SET var_descripcion = CONCAT(var_nombre,', tus datos han sido actualizados, verifica que estos esten correctos.');
        INSERT INTO Notificaciones
		(descripcion, fecha, idUsuario) VALUES
		(var_descripcion, NOW(), OLD.idUsuario);
    END IF;
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`DocumentoIdentidad_AFTER_UPDATE` AFTER UPDATE ON `DocumentoIdentidad` FOR EACH ROW
BEGIN
	# Generar Notificaciones
    DECLARE var_descripcion VARCHAR(200);
    DECLARE var_nombre VARCHAR(60);
    SELECT nombres INTO var_nombre FROM Usuarios WHERE idUsuario = OLD.idUsuario;
	SET var_descripcion = CONCAT(var_nombre,', los datos de tu documento de identidad han sido cambiados.');
	INSERT INTO Notificaciones
	(descripcion, fecha, idUsuario) VALUES
	(var_descripcion, NOW(), OLD.idUsuario);
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Telefono_AFTER_UPDATE` AFTER UPDATE ON `Telefono` FOR EACH ROW
BEGIN
	# Generar Notificaciones
    DECLARE var_descripcion VARCHAR(200);
    DECLARE var_nombre VARCHAR(60);
    SELECT nombres INTO var_nombre FROM Usuarios WHERE idUsuario = OLD.idUsuario;
	SET var_descripcion = CONCAT(var_nombre,', se cambió el número de teléfono ',OLD.telefono,' a ',NEW.telefono,'.');
	INSERT INTO Notificaciones
	(descripcion, fecha, idUsuario) VALUES
	(var_descripcion, NOW(), OLD.idUsuario);
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`GruposDocentes_AFTER_INSERT` AFTER INSERT ON `GruposDocentes` FOR EACH ROW
BEGIN
	# Generar Notificaciones
    DECLARE var_descripcion VARCHAR(200);
    DECLARE var_nombreDocente VARCHAR(200);
    DECLARE var_nombreGrupo VARCHAR(10);
    SELECT CONCAT_WS(' ',nombres, apellido1, apellido2) INTO var_nombreDocente FROM Usuarios WHERE idUsuario = NEW.idDocente;
    SELECT nombre INTO var_nombreGrupo FROM Grupos WHERE idGrupo = NEW.idGrupo;
    SET var_descripcion = CONCAT(var_nombreDocente,' se agregó como profesor(a) al grupo ',var_nombreGrupo,'.');
    # Notificar a estudiantes del grupo
	INSERT INTO Notificaciones 
	(descripcion, fecha, idUsuario)
	SELECT
	var_descripcion, NOW(), e.idUsuario
	FROM Estudiantes e
	WHERE e.idGrupo = NEW.idGrupo;
    # Notificar al profesor
    SET var_descripcion = CONCAT('Has sido agregado como profesor(a) en el grupo ',var_nombreGrupo,'.');
    INSERT INTO Notificaciones
	(descripcion, fecha, idUsuario) VALUES
	(var_descripcion, NOW(), NEW.idDocente);
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`GruposDocentes_AFTER_DELETE` AFTER DELETE ON `GruposDocentes` FOR EACH ROW
BEGIN
	# Generar Notificaciones
    DECLARE var_descripcion VARCHAR(200);
    DECLARE var_nombreDocente VARCHAR(200);
    DECLARE var_nombreGrupo VARCHAR(10);
    SELECT CONCAT_WS(' ',nombres, apellido1, apellido2) INTO var_nombreDocente FROM Usuarios WHERE idUsuario = OLD.idDocente;
    SELECT nombre INTO var_nombreGrupo FROM Grupos WHERE idGrupo = OLD.idGrupo;
    SET var_descripcion = CONCAT(var_nombreDocente,' ya no es profesor(a) del grupo ',var_nombreGrupo,'.');
    # Notificar a estudiantes del grupo
	INSERT INTO Notificaciones 
	(descripcion, fecha, idUsuario)
	SELECT
	var_descripcion, NOW(), e.idUsuario
	FROM Estudiantes e
	WHERE e.idGrupo = OLD.idGrupo;
    # Notificar al profesor
    SET var_descripcion = CONCAT('Ya no eres profesor(a) del grupo ',var_nombreGrupo,'.');
    INSERT INTO Notificaciones
	(descripcion, fecha, idUsuario) VALUES
	(var_descripcion, NOW(), OLD.idDocente);
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Publicaciones_AFTER_INSERT` AFTER INSERT ON `Publicaciones` FOR EACH ROW
BEGIN
	# Notificar a quien publicó
    DECLARE var_descripcion VARCHAR(200);
    SET var_descripcion = CONCAT('Has publicado ',UPPER(NEW.titulo),' el día ',DAY(NEW.FECHA),' de ',mesesEspanol(MONTH(NEW.fecha)),' a las ',DATE_FORMAT(NEW.fecha,'%h:%i %p'));
    INSERT INTO Notificaciones
	(descripcion, fecha, idUsuario) VALUES
	(var_descripcion, NOW(), NEW.idUsuario);
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Publicaciones_AFTER_DELETE` AFTER DELETE ON `Publicaciones` FOR EACH ROW
BEGIN
	# Notificar a quien publicó
    DECLARE var_descripcion VARCHAR(200);
    SET var_descripcion = CONCAT('Se eliminó tu publicación ',UPPER(OLD.titulo));
    INSERT INTO Notificaciones
	(descripcion, fecha, idUsuario) VALUES
	(var_descripcion, NOW(), OLD.idUsuario);
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Eventos_AFTER_INSERT` AFTER INSERT ON `Eventos` FOR EACH ROW
BEGIN
	# Generar Notificaciones
    DECLARE var_descripcion VARCHAR(500);
    DECLARE var_nombrePublicador VARCHAR(200);
    DECLARE var_tipo VARCHAR(200);
    DECLARE var_directivos TINYINT;
    DECLARE var_docentes TINYINT;
    DECLARE var_estudiantes TINYINT;
    SELECT CONCAT_WS(' ',nombres,apellido1),tipo INTO var_nombrePublicador, var_tipo FROM Usuarios WHERE idUsuario = NEW.idUsuario;
    SET var_descripcion = CONCAT_WS(' ','El',tipoUsuario(var_tipo),var_nombrePublicador,'ha publicado un nuevo evento para el día',DAY(NEW.hora),'de',mesesEspanol(MONTH(NEW.hora)),'del',YEAR(NEW.hora),'a las',CONCAT(DATE_FORMAT(NEW.hora,'%h:%i %p'),':'),NEW.descripcion);
    SELECT directivos,docentes,estudiantes INTO var_directivos,var_docentes,var_estudiantes FROM Privacidad WHERE idPrivacidad = NEW.idPrivacidad;
    INSERT INTO Notificaciones
	(descripcion, fecha, directivo, docente, estudiante) VALUES
	(var_descripcion, NOW(),var_directivos,var_docentes,var_estudiantes);
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`Eventos_AFTER_DELETE` AFTER DELETE ON `Eventos` FOR EACH ROW
BEGIN
	# Generar Notificaciones
    DECLARE var_descripcion VARCHAR(500);
    DECLARE var_nombrePublicador VARCHAR(200);
    DECLARE var_tipo VARCHAR(200);
    DECLARE var_directivos TINYINT;
    DECLARE var_docentes TINYINT;
    DECLARE var_estudiantes TINYINT;
    # Notificar solo eventos que son mayores a la fecha actual
    IF OLD.hora > NOW() THEN
		SELECT CONCAT_WS(' ',nombres,apellido1),tipo INTO var_nombrePublicador, var_tipo FROM Usuarios WHERE idUsuario = OLD.idUsuario;
		SET var_descripcion = CONCAT_WS(' ','El',tipoUsuario(var_tipo),var_nombrePublicador,'ha cancelado el evento del día',DAY(OLD.hora),'de',mesesEspanol(MONTH(OLD.hora)),'del',YEAR(OLD.hora),'a las',CONCAT(DATE_FORMAT(OLD.hora,'%h:%i %p'),':'),OLD.descripcion);
		SELECT directivos,docentes,estudiantes INTO var_directivos,var_docentes,var_estudiantes FROM Privacidad WHERE idPrivacidad = OLD.idPrivacidad;
		INSERT INTO Notificaciones
		(descripcion, fecha, directivo, docente, estudiante) VALUES
		(var_descripcion, NOW(),var_directivos,var_docentes,var_estudiantes);
	END IF;
END$$

USE `sadeDB`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sadeDB`.`VistasNotificaciones_AFTER_INSERT` AFTER INSERT ON `VistasNotificaciones` FOR EACH ROW
BEGIN
	IF 
    EXISTS(SELECT * FROM Notificaciones WHERE directivo=0 AND docente=0 AND estudiante=0 AND idUsuario=NEW.idUsuario AND idNotificacion=NEW.idNotificacion)
    THEN
		DELETE FROM Notificaciones WHERE idNotificacion=NEW.idNotificacion;
    END IF;
END$$


DELIMITER ;
CREATE USER 'sade-publico' IDENTIFIED BY '1234';

GRANT EXECUTE ON procedure `sadeDB`.`p_pub_numUsuarios` TO 'sade-publico';
GRANT SELECT, SHOW VIEW ON TABLE `sadeDB`.`vs_pub_publicaciones` TO 'sade-publico';
GRANT SELECT, SHOW VIEW ON TABLE `sadeDB`.`vs_pub_eventos` TO 'sade-publico';
GRANT EXECUTE ON procedure `sadeDB`.`p_pub_eventosMes` TO 'sade-publico';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_pub_directivos` TO 'sade-publico';
GRANT SELECT, UPDATE ON TABLE `sadeDB`.`Usuarios` TO 'sade-publico';
GRANT EXECUTE ON procedure `sadeDB`.`p_pub_login` TO 'sade-publico';
GRANT EXECUTE ON procedure `sadeDB`.`p_pub_buscarDirectivo` TO 'sade-publico';
GRANT EXECUTE ON procedure `sadeDB`.`p_pub_buscarPublicacion` TO 'sade-publico';
CREATE USER 'sade-directivo' IDENTIFIED BY '1234';

GRANT INSERT, SELECT, UPDATE ON TABLE `sadeDB`.`Usuarios` TO 'sade-directivo';
GRANT INSERT, SELECT, UPDATE ON TABLE `sadeDB`.`Estudiantes` TO 'sade-directivo';
GRANT INSERT, SELECT, UPDATE ON TABLE `sadeDB`.`Docentes` TO 'sade-directivo';
GRANT UPDATE, SELECT, INSERT ON TABLE `sadeDB`.`Directivos` TO 'sade-directivo';
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE `sadeDB`.`DocumentoIdentidad` TO 'sade-directivo';
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `sadeDB`.`Telefono` TO 'sade-directivo';
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `sadeDB`.`Grupos` TO 'sade-directivo';
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `sadeDB`.`GruposDocentes` TO 'sade-directivo';
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `sadeDB`.`Publicaciones` TO 'sade-directivo';
GRANT INSERT, DELETE, UPDATE, SELECT ON TABLE `sadeDB`.`Dislike` TO 'sade-directivo';
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `sadeDB`.`Likes` TO 'sade-directivo';
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `sadeDB`.`Eventos` TO 'sade-directivo';
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `sadeDB`.`Notificaciones` TO 'sade-directivo';
GRANT UPDATE, SELECT, DELETE, INSERT ON TABLE `sadeDB`.`VistasNotificaciones` TO 'sade-directivo';
GRANT UPDATE, SELECT, INSERT, DELETE ON TABLE `sadeDB`.`Privacidad` TO 'sade-directivo';
GRANT SELECT, SHOW VIEW ON TABLE `sadeDB`.`vs_datosdirectivo` TO 'sade-directivo';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_dir_publicaciones` TO 'sade-directivo';
GRANT EXECUTE ON procedure `sadeDB`.`p_notificacionesUsuario` TO 'sade-directivo';
GRANT EXECUTE ON procedure `sadeDB`.`p_numNotificaciones` TO 'sade-directivo';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_datosdocentes` TO 'sade-directivo';
GRANT SELECT, SHOW VIEW ON TABLE `sadeDB`.`vs_datosEstudiantes` TO 'sade-directivo';
GRANT SELECT, SHOW VIEW ON TABLE `sadeDB`.`vs_datosUsuarios` TO 'sade-directivo';
GRANT SELECT, SHOW VIEW ON TABLE `sadeDB`.`vs_publicaciones` TO 'sade-directivo';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_telefonostipousuario` TO 'sade-directivo';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_infousuario` TO 'sade-directivo';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_infoestudiantes` TO 'sade-directivo';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_infodocentes` TO 'sade-directivo';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_infodirectivos` TO 'sade-directivo';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_eventos` TO 'sade-directivo';
GRANT EXECUTE ON procedure `sadeDB`.`p_dir_eventosMes` TO 'sade-directivo';
GRANT EXECUTE ON procedure `sadeDB`.`p_dir_buscarDirectivo` TO 'sade-directivo';
GRANT EXECUTE ON procedure `sadeDB`.`p_dir_buscarDocente` TO 'sade-directivo';
GRANT EXECUTE ON procedure `sadeDB`.`p_dir_buscarEstudiante` TO 'sade-directivo';
GRANT EXECUTE ON procedure `sadeDB`.`p_dir_buscarEvento` TO 'sade-directivo';
GRANT EXECUTE ON procedure `sadeDB`.`p_dir_buscarGrupo` TO 'sade-directivo';
GRANT EXECUTE ON procedure `sadeDB`.`p_dir_buscarPublicacion` TO 'sade-directivo';
CREATE USER 'sade-profesor' IDENTIFIED BY '1234';

GRANT SELECT ON TABLE `sadeDB`.`Grupos` TO 'sade-profesor';
GRANT UPDATE, SELECT, DELETE, INSERT ON TABLE `sadeDB`.`Dislike` TO 'sade-profesor';
GRANT UPDATE, SELECT, INSERT, DELETE ON TABLE `sadeDB`.`Likes` TO 'sade-profesor';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_prf_publicaciones` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_notificacionesUsuario` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_numNotificaciones` TO 'sade-profesor';
GRANT SELECT, SHOW VIEW ON TABLE `sadeDB`.`vs_prf_gradosdocentes` TO 'sade-profesor';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_prf_infodirectivo` TO 'sade-profesor';
GRANT SELECT, SHOW VIEW ON TABLE `sadeDB`.`vs_prf_infodocentes` TO 'sade-profesor';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_prf_infoestudiantes` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_addTelefono` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_deletePublicacion` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_deleteTelefono` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_editPublicacion` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_editTelefono` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_eventosMes` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_updateDatos` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_verDatosEstudiante` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_verTelefonos` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_misGruposClases` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_misGruposDireccion` TO 'sade-profesor';
GRANT SELECT, SHOW VIEW ON TABLE `sadeDB`.`vs_prf_estudiantesDirector` TO 'sade-profesor';
GRANT SELECT, SHOW VIEW ON TABLE `sadeDB`.`vs_publicaciones` TO 'sade-profesor';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_infousuario` TO 'sade-profesor';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_eventos` TO 'sade-profesor';
GRANT SELECT, SHOW VIEW ON TABLE `sadeDB`.`vs_prf_estudiantesClase` TO 'sade-profesor';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_prf_eventos` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_buscarDocente` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_buscarEstudiante` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_buscarEvento` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_buscarGrupo` TO 'sade-profesor';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_buscarPublicacion` TO 'sade-profesor';
CREATE USER 'sade-estudiante' IDENTIFIED BY '1234';

GRANT SELECT ON TABLE `sadeDB`.`Grupos` TO 'sade-estudiante';
GRANT UPDATE, SELECT, INSERT, DELETE ON TABLE `sadeDB`.`Dislike` TO 'sade-estudiante';
GRANT UPDATE, SELECT, INSERT, DELETE ON TABLE `sadeDB`.`Likes` TO 'sade-estudiante';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_est_publicaciones` TO 'sade-estudiante';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_est_eventos` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_eventosMes` TO 'sade-estudiante';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_est_infodocentes` TO 'sade-estudiante';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_est_infoestudiantes` TO 'sade-estudiante';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_est_infodirectivos` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_notificacionesUsuario` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_numNotificaciones` TO 'sade-estudiante';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_est_gradosdocentes` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_updateDatos` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_verDatosEstudiante` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_verTelefonos` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_deleteTelefono` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_addTelefono` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_vistoNotificacion` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_addPublicacion` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_deletePublicacion` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_editPublicacion` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_vistoNotificacion` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_addPublicacion` TO 'sade-estudiante';
GRANT SELECT, SHOW VIEW ON TABLE `sadeDB`.`vs_publicaciones` TO 'sade-estudiante';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_infousuario` TO 'sade-estudiante';
GRANT SHOW VIEW, SELECT ON TABLE `sadeDB`.`vs_eventos` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_buscarEstudiante` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_buscarDocente` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_buscarDirectivo` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_buscarGrupo` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_buscarEvento` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_est_buscarPublicacion` TO 'sade-estudiante';
GRANT EXECUTE ON procedure `sadeDB`.`p_prf_buscarDirectivo` TO 'sade-estudiante';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
-- begin attached script 'script1'
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `tipoUsuario`(tipo INT) RETURNS varchar(12) CHARSET utf8
BEGIN
    CASE tipo
		WHEN 1 THEN RETURN 'estudiante';
        WHEN 2 THEN RETURN 'profesor';
        WHEN 3 THEN RETURN 'directivo';
    END CASE;
	RETURN 'No existe';
END$$
DELIMITER ;
-- end attached script 'script1'
-- begin attached script 'script2'
DELIMITER $$
USE `sadedb`$$
CREATE FUNCTION `tipoUsuarioSegunId` (arg_idUsuario INT)
RETURNS INTEGER
BEGIN
	DECLARE tipoUser INT;
    SELECT tipo INTO tipoUser FROM Usuarios WHERE idUsuario = arg_idUsuario;
	RETURN tipoUser;
END$$

DELIMITER ;
-- end attached script 'script2'
-- begin attached script 'script3'
DELIMITER $$
USE `sadedb`$$
CREATE FUNCTION `getIdPrivacidad` 
(
	arg_publico TINYINT,
	arg_directivos TINYINT,
	arg_docentes TINYINT, 
	arg_estudiantes TINYINT
)
RETURNS INTEGER
BEGIN
	DECLARE val_idPrivacidad INT;
	IF arg_publico > 0 THEN 
		RETURN 1;
	END IF;
	SELECT
		idPrivacidad INTO val_idPrivacidad
	FROM Privacidad
	WHERE 
    publico = 0 
    AND directivos = arg_directivos
    AND docentes = arg_docentes
    AND estudiantes = arg_estudiantes;
	RETURN val_idPrivacidad;
END$$

GRANT EXECUTE ON FUNCTION getIdPrivacidad TO 'sade-estudiante'$$
GRANT EXECUTE ON FUNCTION getIdPrivacidad TO 'sade-directivo'$$
GRANT EXECUTE ON FUNCTION getIdPrivacidad TO 'sade-profesor'$$

DELIMITER ;
-- end attached script 'script3'
-- begin attached script 'script4'
DELIMITER $$
USE `sadedb`$$
CREATE FUNCTION `mesesEspanol` (mes INT)
RETURNS VARCHAR(15)
BEGIN
	CASE mes
		WHEN 1 THEN RETURN 'enero';
        WHEN 2 THEN RETURN 'febrero';
        WHEN 3 THEN RETURN 'marzo';
        WHEN 4 THEN RETURN 'abril';
        WHEN 5 THEN RETURN 'mayo';
        WHEN 6 THEN RETURN 'junio';
        WHEN 7 THEN RETURN 'julio';
        WHEN 8 THEN RETURN 'agosto';
        WHEN 9 THEN RETURN 'septiembre';
        WHEN 10 THEN RETURN 'octubre';
        WHEN 11 THEN RETURN 'noviembre';
        WHEN 12 THEN RETURN 'diciembre';
    END CASE;
	RETURN 'No existe';
END$$

DELIMITER ;
-- end attached script 'script4'

-- -----------------------------------------------------
-- Data for table `sadeDB`.`Usuarios`
-- -----------------------------------------------------
START TRANSACTION;
USE `sadeDB`;
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (1, 'Edilberto', 'Martinez', 'Uragama', 1, 'edilberto234@gmail.com', 'M', '2012-3-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (2, 'Marleny', 'Castillo', 'Ruiz', 1, 'marleny163@gmail.com', 'F', '2012-7-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (3, 'Carlos Antonio', 'Galvis', '', 1, 'carlosantonio786@gmail.com', 'M', '2008-2-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (4, 'Oswaldo', 'Benitez', '', 1, 'oswaldo432@gmail.com', 'M', '2005-12-9', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (5, 'Luis Daniel', 'Vargas', 'Atencia', 1, 'luisdaniel640@gmail.com', 'M', '2005-9-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (6, 'Emmanuel', 'Gomez', 'Garizabalo', 1, 'emmanuel891@gmail.com', 'M', '2012-1-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (7, 'Maria Romelia', 'Jorge', '', 1, 'mariaromelia578@gmail.com', 'F', '2015-6-21', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (8, 'Andres Leonardo', 'Arrieta', 'Rodriguez', 1, 'andresleonardo402@gmail.com', 'M', '2010-3-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (9, 'Sarah', 'Narvaez', '', 1, 'sarah0@gmail.com', 'F', '2011-1-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (10, 'Jaime Antonio', 'Herrera', 'Rivera', 1, 'jaimeantonio990@gmail.com', 'M', '2012-12-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (11, 'Maria Andrea', 'Alvarez', '', 1, 'mariaandrea371@gmail.com', 'F', '2011-11-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (12, 'Laura Isabella', 'Paternina', 'Gonzalez', 1, 'lauraisabella213@gmail.com', 'F', '2010-2-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (13, 'Fernando Alonso', 'Gonzalez', '', 1, 'fernandoalonso133@gmail.com', 'M', '2008-8-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (14, 'Rodrigo Jesus', 'Diaz', '', 1, 'rodrigojesus857@gmail.com', 'M', '2010-3-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (15, 'Sandra Ximena', 'Mendivil', 'Feria', 1, 'sandraximena288@gmail.com', 'F', '2015-2-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (16, 'Violeta', 'Ramos', 'Mercado', 1, 'violeta931@gmail.com', 'F', '2010-10-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (17, 'Juan Nicolas', 'Santos', 'Arroyo', 1, 'juannicolas824@gmail.com', 'M', '2013-7-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (18, 'John Anderson', 'Muã‘Oz', '', 1, 'johnanderson871@gmail.com', 'M', '2011-10-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (19, 'Jose Aldemar', 'Benitez', 'Martinez', 1, 'josealdemar410@gmail.com', 'M', '2012-1-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (20, 'Cesar Mauricio', 'Montes', 'Pozo', 1, 'cesarmauricio265@gmail.com', 'M', '2004-7-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (21, 'Maria Aracelly', 'Oviedo', '', 1, 'mariaaracelly818@gmail.com', 'F', '2014-12-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (22, 'Diego Mauricio', 'Vergara', 'Alvarez', 1, 'diegomauricio351@gmail.com', 'M', '2013-6-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (23, 'Jhon Fredy', 'Ortiz', '', 1, 'jhonfredy793@gmail.com', 'M', '2015-4-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (24, 'Maria Irma', 'Alvarez', 'Feria', 1, 'mariairma136@gmail.com', 'F', '2008-1-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (25, 'Yuri Andrea', 'Perdomo', '', 1, 'yuriandrea548@gmail.com', 'F', '2010-6-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (26, 'John Edison', 'Mercado', '', 1, 'johnedison96@gmail.com', 'M', '2006-1-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (27, 'Andres Jose', 'Rodriguez', '', 1, 'andresjose115@gmail.com', 'M', '2007-10-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (28, 'Silvana', 'Romero', 'Arrieta', 1, 'silvana157@gmail.com', 'F', '2008-10-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (29, 'Jhon Fredy', 'Perez', '', 1, 'jhonfredy160@gmail.com', 'M', '2011-9-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (30, 'Blanca Nelly', 'Mercado', '', 1, 'blancanelly997@gmail.com', 'F', '2015-12-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (31, 'Oscar', 'Corrales', 'Zarate', 1, 'oscar71@gmail.com', 'M', '2013-11-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (32, 'Paula Tatiana', 'Sequeda', 'Monterroza', 1, 'paulatatiana917@gmail.com', 'F', '2008-9-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (33, 'Danna', 'Calderon', '', 1, 'danna328@gmail.com', 'F', '2006-4-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (34, 'Sergio Alberto', 'Sanchez', 'Contreras', 1, 'sergioalberto31@gmail.com', 'M', '2010-9-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (35, 'Daniel Fernando', 'Castillo', 'Sencio', 1, 'danielfernando784@gmail.com', 'M', '2014-2-21', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (36, 'Oscar Hernando', 'Benitez', '', 1, 'oscarhernando416@gmail.com', 'M', '2006-2-9', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (37, 'Luis Santiago', 'Clemente', '', 1, 'luissantiago514@gmail.com', 'M', '2011-4-21', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (38, 'Wilson Enrique', 'Sanchez', '', 1, 'wilsonenrique65@gmail.com', 'M', '2010-8-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (39, 'Karen Alejandra', 'Lidueã‘A', 'Cali', 1, 'karenalejandra473@gmail.com', 'F', '2013-7-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (40, 'Christian Alberto', 'Carmona', '', 1, 'christianalberto665@gmail.com', 'M', '2008-2-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (41, 'Martha', 'Chamorro', 'Valle', 1, 'martha101@gmail.com', 'F', '2013-4-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (42, 'Alba Rosa', 'Pineda', '', 1, 'albarosa39@gmail.com', 'F', '2008-9-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (43, 'Erica', 'Escaã‘O', '', 1, 'erica100@gmail.com', 'F', '2008-11-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (44, 'Mauricio Antonio', 'Diaz', 'Fonseca', 1, 'mauricioantonio936@gmail.com', 'M', '2008-1-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (45, 'John James', 'Perez', '', 1, 'johnjames657@gmail.com', 'M', '2008-8-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (46, 'Ian', 'Gaviria', '', 1, 'ian652@gmail.com', 'M', '2004-2-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (47, 'Jose Diego', 'Montes', 'Jimenez', 1, 'josediego385@gmail.com', 'M', '2008-4-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (48, 'Andres Sebastian', 'Camargo', '', 1, 'andressebastian882@gmail.com', 'M', '2015-2-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (49, 'Fernando Andres', 'Bettin', 'Guerra', 1, 'fernandoandres154@gmail.com', 'M', '2012-4-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (50, 'Ana Silvia', 'Dominguez', '', 1, 'anasilvia479@gmail.com', 'F', '2013-8-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (51, 'Victor Raul', 'Posada', 'Hoyos', 1, 'victorraul784@gmail.com', 'M', '2014-2-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (52, 'Lina Alejandra', 'Ozuna', '', 1, 'linaalejandra973@gmail.com', 'F', '2010-8-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (53, 'Laura Alexandra', 'Rodriguez', 'Piã‘Eres', 1, 'lauraalexandra146@gmail.com', 'F', '2005-12-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (54, 'Sergio Alexander', 'Melendez', '', 1, 'sergioalexander391@gmail.com', 'M', '2014-8-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (55, 'Juan Guillermo', 'Vega', 'Martelo', 1, 'juanguillermo606@gmail.com', 'M', '2010-7-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (56, 'Sandra Yulieth', 'Peinado', 'Aguas', 1, 'sandrayulieth560@gmail.com', 'F', '2008-8-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (57, 'Cristian Javier', 'Clemente', '', 1, 'cristianjavier54@gmail.com', 'M', '2006-6-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (58, 'Sandra Eugenia', 'Sandoval', '', 1, 'sandraeugenia164@gmail.com', 'F', '2015-9-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (59, 'Hector Antonio', 'Narvaez', 'De Arrieta', 1, 'hectorantonio903@gmail.com', 'M', '2007-6-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (60, 'Camilo Arturo', 'Montaã‘O', 'Paternina', 1, 'camiloarturo332@gmail.com', 'M', '2006-8-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (61, 'Luisa Alejandra', 'Montes', 'Diaz', 1, 'luisaalejandra147@gmail.com', 'F', '2009-3-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (62, 'Luis Eduardo', 'Guerra', '', 1, 'luiseduardo453@gmail.com', 'M', '2006-11-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (63, 'Lucas', 'Perez', 'Conde', 1, 'lucas240@gmail.com', 'M', '2015-8-21', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (64, 'Mauricio Andres', 'De Paternina', 'Camargo', 1, 'mauricioandres46@gmail.com', 'M', '2013-4-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (65, 'Luis Alfredo', 'Lobo', 'Martinez', 1, 'luisalfredo412@gmail.com', 'M', '2015-10-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (66, 'Duvan', 'Paternina', '', 1, 'duvan209@gmail.com', 'M', '2011-7-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (67, 'Jhon Mario', 'Caballero', '', 1, 'jhonmario45@gmail.com', 'M', '2011-8-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (68, 'Claudia Andrea', 'Herazo', 'Flores', 1, 'claudiaandrea171@gmail.com', 'F', '2004-11-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (69, 'Rosa Helena', 'Benitez', '', 1, 'rosahelena783@gmail.com', 'F', '2015-12-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (70, 'Magda Lorena', 'Parra', 'Juez', 1, 'magdalorena142@gmail.com', 'F', '2014-2-21', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (71, 'Yessika', 'Osorio', 'Herazo', 1, 'yessika95@gmail.com', 'F', '2008-8-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (72, 'Cecilia', 'Cardenas', '', 1, 'cecilia568@gmail.com', 'F', '2006-8-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (73, 'Pedro Manuel', 'Ricardo', 'Nisperuza', 1, 'pedromanuel492@gmail.com', 'M', '2010-3-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (74, 'Beatriz Eugenia', 'Atencia', '', 1, 'beatrizeugenia500@gmail.com', 'F', '2008-11-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (75, 'William', 'Arrieta', 'Borja', 1, 'william946@gmail.com', 'M', '2004-2-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (76, 'Jean Pierre', 'Perez', '', 1, 'jeanpierre870@gmail.com', 'M', '2010-10-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (77, 'Miller', 'Jimenez', 'Guerra', 1, 'miller863@gmail.com', 'M', '2007-10-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (78, 'Alexandra Patricia', 'Hernandez', 'Calderon', 1, 'alexandrapatricia106@gmail.com', 'F', '2014-3-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (79, 'Reinaldo Jesus', 'Perez', 'Carbajal', 1, 'reinaldojesus139@gmail.com', 'M', '2009-4-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (80, 'Charles', 'Gonzalez', '', 1, 'charles659@gmail.com', 'M', '2009-12-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (81, 'Xiomara', 'Sierra', '', 1, 'xiomara256@gmail.com', 'F', '2004-8-5', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (82, 'Marta Elena', 'Romero', '', 1, 'martaelena679@gmail.com', 'F', '2013-8-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (83, 'Maria Emma', 'Guerrero', 'Martinez', 1, 'mariaemma356@gmail.com', 'F', '2007-11-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (84, 'Hector Eduardo', 'Guerra', 'Jaraba', 1, 'hectoreduardo438@gmail.com', 'M', '2011-11-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (85, 'Johan Fernando', 'Ruiz', '', 1, 'johanfernando92@gmail.com', 'M', '2013-1-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (86, 'John David', 'De La Rosa', 'Gutierrez', 1, 'johndavid94@gmail.com', 'M', '2005-3-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (87, 'Oscar Julian', 'Lopez', '', 1, 'oscarjulian581@gmail.com', 'M', '2014-11-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (88, 'Maria Magdalena', 'Lopez', 'Luna', 1, 'mariamagdalena225@gmail.com', 'F', '2008-5-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (89, 'Wilson Enrique', 'Arrieta', 'Chavez', 1, 'wilsonenrique39@gmail.com', 'M', '2008-12-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (90, 'Jose Agustin', 'Martinez', 'Severiche', 1, 'joseagustin169@gmail.com', 'M', '2011-11-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (91, 'Sandra Maria', 'Martinez', 'Herazo', 1, 'sandramaria462@gmail.com', 'F', '2009-12-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (92, 'Felix Eduardo', 'Santos', 'Huerta', 1, 'felixeduardo578@gmail.com', 'M', '2004-3-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (93, 'Blanca Margarita', 'Perez', '', 1, 'blancamargarita586@gmail.com', 'F', '2005-2-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (94, 'William Eduardo', 'Alvarez', '', 1, 'williameduardo313@gmail.com', 'M', '2009-8-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (95, 'Soraida', 'Herrera', 'De Paternina', 1, 'soraida675@gmail.com', 'F', '2011-11-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (96, 'Lucelly', 'Huerta', 'Vasquez', 1, 'lucelly142@gmail.com', 'F', '2012-2-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (97, 'Marisel', 'Nuã‘Ez', '', 1, 'marisel31@gmail.com', 'F', '2010-10-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (98, 'Jimmy Alexander', 'Asendra', 'Vergara', 1, 'jimmyalexander783@gmail.com', 'M', '2009-7-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (99, 'Laura Manuela', 'Siolo', 'Lidueã‘A', 1, 'lauramanuela493@gmail.com', 'F', '2009-4-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (100, 'Johana Andrea', 'Alvarez', 'Martinez', 1, 'johanaandrea947@gmail.com', 'F', '2013-12-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (101, 'Giovanny', 'Coronado', 'Hernandez', 1, 'giovanny992@gmail.com', 'M', '2014-8-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (102, 'Ana Victoria', 'Canchila', '', 1, 'anavictoria442@gmail.com', 'F', '2007-9-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (103, 'Vladimir', 'Vega', '', 1, 'vladimir363@gmail.com', 'M', '2012-5-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (104, 'Monica Alejandra', 'Alvarez', 'Hernandez', 1, 'monicaalejandra187@gmail.com', 'F', '2010-8-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (105, 'Erika', 'Herrera', '', 1, 'erika994@gmail.com', 'F', '2004-11-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (106, 'Ana Catalina', 'Altamiranda', 'Bertel', 1, 'anacatalina418@gmail.com', 'F', '2015-12-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (107, 'Jose Carmen', 'Calderon', '', 1, 'josecarmen458@gmail.com', 'M', '2005-3-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (108, 'Yalile', 'Mendez', 'Romero', 1, 'yalile590@gmail.com', 'F', '2005-1-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (109, 'Jhon Freddy', 'Montalvo', 'Karol', 1, 'jhonfreddy837@gmail.com', 'M', '2008-12-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (110, 'Maria Aracelly', 'Acosta', '', 1, 'mariaaracelly64@gmail.com', 'F', '2010-7-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (111, 'Amalfi', 'Suarez', 'Barreto', 1, 'amalfi342@gmail.com', 'F', '2006-5-5', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (112, 'German Alberto', 'Meriã‘O', '', 1, 'germanalberto287@gmail.com', 'M', '2008-3-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (113, 'Yessica Alexandra', 'Naranjo', '', 1, 'yessicaalexandra99@gmail.com', 'F', '2008-6-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (114, 'Vanessa', 'Diaz', 'Loarte', 1, 'vanessa350@gmail.com', 'F', '2015-6-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (115, 'John Fredy', 'Carrascal', '', 1, 'johnfredy857@gmail.com', 'M', '2005-4-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (116, 'Jean Pierre', 'Sequeda', '', 1, 'jeanpierre123@gmail.com', 'M', '2008-7-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (117, 'Maria Lucero', 'Lara', '', 1, 'marialucero394@gmail.com', 'F', '2007-11-5', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (118, 'Deiby', 'Barboza', '', 1, 'deiby835@gmail.com', 'M', '2013-5-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (119, 'Johana Marcela', 'Romero', 'Nuã‘Ez', 1, 'johanamarcela468@gmail.com', 'F', '2006-5-9', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (120, 'Fernando Andres', 'Mercado', '', 1, 'fernandoandres104@gmail.com', 'M', '2010-10-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (121, 'Carlos', 'Benitez', 'Padilla', 1, 'carlos14@gmail.com', 'M', '2015-5-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (122, 'John Javier', 'Cordoba', 'Bermudez', 1, 'johnjavier488@gmail.com', 'M', '2012-12-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (123, 'Maria Esther', 'Fernandez', 'Florez', 1, 'mariaesther443@gmail.com', 'F', '2012-12-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (124, 'Maria Lourdes', 'Ruiz', '', 1, 'marialourdes380@gmail.com', 'F', '2009-1-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (125, 'Arles', 'Perez', 'Ospina', 1, 'arles283@gmail.com', 'M', '2008-4-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (126, 'Luis David', 'Molinares', 'Leguia', 1, 'luisdavid852@gmail.com', 'M', '2009-2-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (127, 'Giovanny Alexander', 'Berrio', 'Aleman', 1, 'giovannyalexander787@gmail.com', 'M', '2014-9-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (128, 'Javier Felipe', 'Ortega', '', 1, 'javierfelipe499@gmail.com', 'M', '2010-6-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (129, 'Maria Daniela', 'Barreto', 'Montalvo', 1, 'mariadaniela831@gmail.com', 'F', '2015-5-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (130, 'Karen Sofia', 'Montes', 'Aconcho', 1, 'karensofia693@gmail.com', 'F', '2007-7-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (131, 'Erika Johana', 'Morales', '', 1, 'erikajohana856@gmail.com', 'F', '2012-12-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (132, 'Emilce', 'Reyes', '', 1, 'emilce895@gmail.com', 'F', '2013-5-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (133, 'Ezequiel', 'Marin', '', 1, 'ezequiel312@gmail.com', 'M', '2007-4-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (134, 'Ana Libia', 'Borja', 'Pacheco', 1, 'analibia408@gmail.com', 'F', '2007-6-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (135, 'Guido', 'Rodriguez', '', 1, 'guido688@gmail.com', 'M', '2015-12-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (136, 'Ï»¿Sandra Milena', 'Pereira', '', 1, 'ï»¿sandramilena460@gmail.com', 'F', '2010-1-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (137, 'Adriana Patricia', 'Lidueã‘A', 'Juez', 1, 'adrianapatricia18@gmail.com', 'F', '2007-3-5', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (138, 'Oscar Julian', 'Marquez', 'Martinez', 1, 'oscarjulian165@gmail.com', 'M', '2012-1-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (139, 'Jaime Augusto', 'Arroyave', '', 1, 'jaimeaugusto524@gmail.com', 'M', '2013-5-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (140, 'Marta Liliana', 'Torres', 'Pacheco', 1, 'martaliliana333@gmail.com', 'F', '2013-8-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (141, 'David Mauricio', 'Montalvo', 'Salazar', 1, 'davidmauricio562@gmail.com', 'M', '2009-8-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (142, 'Claudia Milena', 'Lara', 'Martinez', 1, 'claudiamilena179@gmail.com', 'F', '2004-3-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (143, 'Willington', 'Herazo', '', 1, 'willington136@gmail.com', 'M', '2007-7-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (144, 'John Sebastian', 'Cardenas', 'Ortega', 1, 'johnsebastian21@gmail.com', 'M', '2011-10-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (145, 'Marco', 'Barreto', 'Martinez', 1, 'marco449@gmail.com', 'M', '2015-6-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (146, 'Edgar Humberto', 'Rios', '', 1, 'edgarhumberto95@gmail.com', 'M', '2013-1-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (147, 'Victor Manuel', 'Benitez', 'Martinez', 1, 'victormanuel357@gmail.com', 'M', '2013-11-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (148, 'Alexander', 'Navarro', '', 1, 'alexander330@gmail.com', 'M', '2006-5-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (149, 'Libia Maria', 'Romero', 'Mercado', 1, 'libiamaria134@gmail.com', 'F', '2014-2-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (150, 'Irma', 'De Dominguez', 'Galeano', 1, 'irma207@gmail.com', 'F', '2009-1-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (151, 'Jeison', 'Severiche', 'Toro', 1, 'jeison152@gmail.com', 'M', '2010-12-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (152, 'Irene', 'Navarro', '', 1, 'irene275@gmail.com', 'F', '2011-9-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (153, 'Ariel', 'Suarez', '', 1, 'ariel435@gmail.com', 'M', '2011-1-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (154, 'Nicolas', 'Martinez', 'Mercado', 1, 'nicolas204@gmail.com', 'M', '2008-8-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (155, 'Sebastian Felipe', 'Sierra', '', 1, 'sebastianfelipe830@gmail.com', 'M', '2005-2-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (156, 'Gladis', 'Murillo', '', 1, 'gladis161@gmail.com', 'F', '2007-11-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (157, 'Angela Lucia', 'Salcedo', 'Jimenez', 1, 'angelalucia542@gmail.com', 'F', '2015-10-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (158, 'Maria Gladys', 'Peã‘Afiel', '', 1, 'mariagladys326@gmail.com', 'F', '2015-7-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (159, 'Juana Valentina', 'Arias', '', 1, 'juanavalentina579@gmail.com', 'F', '2014-10-5', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (160, 'Yina Paola', 'Ricardo', 'Sandoval', 1, 'yinapaola606@gmail.com', 'F', '2013-1-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (161, 'Braian', 'Blanquicet', '', 1, 'braian972@gmail.com', 'M', '2015-7-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (162, 'Karol', 'Arias', 'Vergara', 1, 'karol420@gmail.com', 'F', '2006-5-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (163, 'German David', 'Ruiz', 'Fonseca', 1, 'germandavid938@gmail.com', 'M', '2008-12-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (164, 'Nerea', 'Herrera', '', 1, 'nerea133@gmail.com', 'F', '2012-7-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (165, 'Cindy Lorena', 'Ramos', 'Garcia', 1, 'cindylorena237@gmail.com', 'F', '2015-4-9', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (166, 'Yurani', 'Garcia', 'Castro', 1, 'yurani152@gmail.com', 'F', '2007-1-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (167, 'Hernando Jesus', 'Arias', 'Triana', 1, 'hernandojesus589@gmail.com', 'M', '2005-2-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (168, 'Alba Nubia', 'Pila', 'Diaz', 1, 'albanubia677@gmail.com', 'F', '2007-6-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (169, 'Michell', 'Julio', '', 1, 'michell138@gmail.com', 'F', '2013-5-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (170, 'Jhon Faber', 'Hoyos', '', 1, 'jhonfaber405@gmail.com', 'M', '2015-8-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (171, 'Yenifer', 'Mestra', '', 1, 'yenifer137@gmail.com', 'F', '2006-4-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (172, 'Hernando', 'Arias', 'Altamar', 1, 'hernando619@gmail.com', 'M', '2006-4-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (173, 'Camilo Arturo', 'Cuadros', '', 1, 'camiloarturo669@gmail.com', 'M', '2005-1-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (174, 'Tatiana Marcela', 'Ojeda', 'Diaz', 1, 'tatianamarcela720@gmail.com', 'F', '2010-6-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (175, 'Joseph', 'Torres', '', 1, 'joseph34@gmail.com', 'M', '2006-10-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (176, 'Carlos Felipe', 'Rocha', '', 1, 'carlosfelipe612@gmail.com', 'M', '2008-9-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (177, 'Leidy Daniela', 'Marquez', 'Rodriguez', 1, 'leidydaniela757@gmail.com', 'F', '2013-4-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (178, 'Gloria', 'Farrayans', '', 1, 'gloria371@gmail.com', 'F', '2013-1-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (179, 'Jose William', 'Rodriguez', '', 1, 'josewilliam702@gmail.com', 'M', '2014-5-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (180, 'Alba Ines', 'Diaz', '', 1, 'albaines294@gmail.com', 'F', '2005-11-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (181, 'Yerson', 'Morales', 'Perez', 1, 'yerson468@gmail.com', 'M', '2010-11-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (182, 'Gloria Cecilia', 'Diaz', 'Rodelo', 1, 'gloriacecilia402@gmail.com', 'F', '2008-5-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (183, 'Cristhian Eduardo', 'Castro', '', 1, 'cristhianeduardo625@gmail.com', 'M', '2013-2-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (184, 'Oscar Javier', 'Alvarez', '', 1, 'oscarjavier183@gmail.com', 'M', '2007-5-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (185, 'Abraham', 'Diaz', '', 1, 'abraham890@gmail.com', 'M', '2013-8-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (186, 'Ernesto Jesus', 'Diã‘Eres', 'Simanca', 1, 'ernestojesus889@gmail.com', 'M', '2008-1-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (187, 'Luz Enith', 'Paternina', '', 1, 'luzenith416@gmail.com', 'F', '2011-7-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (188, 'Jhon James', 'De Medrano', 'Chavez', 1, 'jhonjames655@gmail.com', 'M', '2007-3-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (189, 'Nolberto', 'Perez', '', 1, 'nolberto681@gmail.com', 'M', '2005-7-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (190, 'Ernesto Jesus', 'Ricardo', '', 1, 'ernestojesus7@gmail.com', 'M', '2009-5-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (191, 'Salome', 'Fernandez', '', 1, 'salome523@gmail.com', 'F', '2015-8-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (192, 'Liliana Andrea', 'Menco', '', 1, 'lilianaandrea963@gmail.com', 'F', '2015-6-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (193, 'Aura Maria', 'Narvaez', '', 1, 'auramaria638@gmail.com', 'F', '2015-5-9', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (194, 'Rafael Angel', 'Barreto', 'Olivera', 1, 'rafaelangel215@gmail.com', 'M', '2005-8-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (195, 'Jean Pierre', 'Berrio', 'Diã‘Eres', 1, 'jeanpierre84@gmail.com', 'M', '2005-6-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (196, 'Alba Rocio', 'Soto', 'Arrieta', 1, 'albarocio351@gmail.com', 'F', '2015-3-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (197, 'Julian Ricardo', 'Mercado', 'Martinez', 1, 'julianricardo785@gmail.com', 'M', '2012-2-5', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (198, 'Esperanza', 'Ortega', '', 1, 'esperanza991@gmail.com', 'F', '2015-4-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (199, 'Farid', 'Sandoval', '', 1, 'farid491@gmail.com', 'M', '2005-6-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (200, 'Kelly Tatiana', 'Villa', '', 1, 'kellytatiana361@gmail.com', 'F', '2008-4-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (201, 'Blanca Doris', 'Corrales', '', 1, 'blancadoris782@gmail.com', 'F', '2005-2-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (202, 'Wilber', 'Osorio', '', 1, 'wilber978@gmail.com', 'M', '2012-8-21', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (203, 'Juan Rafael', 'Ortiz', '', 1, 'juanrafael348@gmail.com', 'M', '2004-4-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (204, 'Edwin Alejandro', 'Barragan', '', 1, 'edwinalejandro839@gmail.com', 'M', '2008-3-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (205, 'Bertha Lucia', 'Imitola', '', 1, 'berthalucia704@gmail.com', 'F', '2014-11-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (206, 'Horacio', 'Vergara', 'Santos', 1, 'horacio74@gmail.com', 'M', '2009-12-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (207, 'David Andres', 'Pacheco', '', 1, 'davidandres962@gmail.com', 'M', '2013-11-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (208, 'Sonia Patricia', 'De Mejia', 'Rodriguez', 1, 'soniapatricia169@gmail.com', 'F', '2012-11-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (209, 'Miguel Eduardo', 'Bertel', 'Rodriguez', 1, 'migueleduardo421@gmail.com', 'M', '2006-12-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (210, 'Danny Alexander', 'Zuã‘Iga', '', 1, 'dannyalexander742@gmail.com', 'M', '2005-3-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (211, 'Sonia Andrea', 'Castillo', 'Mangones', 1, 'soniaandrea634@gmail.com', 'F', '2004-12-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (212, 'Steven', 'Diaz', '', 1, 'steven534@gmail.com', 'M', '2008-2-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (213, 'Ramon Alberto', 'Cardenas', 'Leiton', 1, 'ramonalberto119@gmail.com', 'M', '2004-4-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (214, 'Evelyn', 'Monterroza', '', 1, 'evelyn11@gmail.com', 'F', '2015-2-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (215, 'Jose Giovanny', 'Parra', 'Eliaz', 1, 'josegiovanny756@gmail.com', 'M', '2008-5-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (216, 'Lilia Maria', 'Camargo', 'Londoã‘O', 1, 'liliamaria882@gmail.com', 'F', '2005-5-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (217, 'Ademir', 'Atencia', 'Herrera', 1, 'ademir54@gmail.com', 'M', '2012-6-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (218, 'Oscar Adolfo', 'Perez', 'Barrios', 1, 'oscaradolfo378@gmail.com', 'M', '2015-4-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (219, 'Viviana Alexandra', 'Sanchez', 'Herazo', 1, 'vivianaalexandra364@gmail.com', 'F', '2005-6-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (220, 'John Edison', 'Diaz', '', 1, 'johnedison986@gmail.com', 'M', '2013-3-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (221, 'Yadira', 'Corpas', 'Muã‘Oz', 1, 'yadira630@gmail.com', 'F', '2012-5-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (222, 'Jhon Mario', 'Arias', 'Perez', 1, 'jhonmario402@gmail.com', 'M', '2010-10-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (223, 'Jair', 'Pacheco', '', 1, 'jair629@gmail.com', 'M', '2010-6-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (224, 'Elsa', 'Marquez', 'Monterroza', 1, 'elsa158@gmail.com', 'F', '2015-4-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (225, 'Luis Gilberto', 'Osorio', '', 1, 'luisgilberto921@gmail.com', 'M', '2010-4-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (226, 'Steven Andres', 'Altamiranda', 'Julio', 1, 'stevenandres86@gmail.com', 'M', '2009-4-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (227, 'Jessica Alejandra', 'Martinez', '', 1, 'jessicaalejandra141@gmail.com', 'F', '2004-12-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (228, 'Arlex', 'Jaraba', '', 1, 'arlex169@gmail.com', 'M', '2013-5-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (229, 'Yeison', 'Ruiz', '', 1, 'yeison609@gmail.com', 'M', '2005-10-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (230, 'Freddy Alberto', 'Agudelo', '', 1, 'freddyalberto702@gmail.com', 'M', '2008-2-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (231, 'Mayra Alexandra', 'Caldera', 'Angulo', 1, 'mayraalexandra327@gmail.com', 'F', '2010-2-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (232, 'Jose Saul', 'Teran', 'Ayala', 1, 'josesaul539@gmail.com', 'M', '2011-7-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (233, 'Gerardo Antonio', 'Mercado', '', 1, 'gerardoantonio333@gmail.com', 'M', '2010-5-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (234, 'Jorge Anibal', 'Villa', '', 1, 'jorgeanibal426@gmail.com', 'M', '2010-4-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (235, 'Miguel Alberto', 'Novoa', 'Arias', 1, 'miguelalberto445@gmail.com', 'M', '2006-12-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (236, 'Lilibeth', 'Romero', '', 1, 'lilibeth864@gmail.com', 'F', '2010-8-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (237, 'Maria Susana', 'Hurtado', '', 1, 'mariasusana21@gmail.com', 'F', '2004-10-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (238, 'Cesar', 'Olivera', '', 1, 'cesar158@gmail.com', 'M', '2008-9-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (239, 'Jeison Alexander', 'Chavez', 'Murillo', 1, 'jeisonalexander332@gmail.com', 'M', '2009-5-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (240, 'Carmen Elisa', 'Camargo', '', 1, 'carmenelisa411@gmail.com', 'F', '2014-7-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (241, 'Brayan Stiven', 'Melendres', 'Diaz', 1, 'brayanstiven448@gmail.com', 'M', '2012-6-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (242, 'Maricela', 'Meza', 'Luna', 1, 'maricela350@gmail.com', 'F', '2005-9-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (243, 'Hector Eduardo', 'De Vides', 'Hernandez', 1, 'hectoreduardo885@gmail.com', 'M', '2010-10-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (244, 'Danna', 'Ramos', 'Acevedo', 1, 'danna651@gmail.com', 'F', '2015-11-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (245, 'Cristian Leonardo', 'Paternina', 'Pacheco', 1, 'cristianleonardo417@gmail.com', 'M', '2009-3-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (246, 'Oscar Enrique', 'Diaz', '', 1, 'oscarenrique538@gmail.com', 'M', '2004-6-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (247, 'Laura Camila', 'Mendoza', 'Ensuncho', 1, 'lauracamila672@gmail.com', 'F', '2014-10-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (248, 'Norbey', 'Herrera', '', 1, 'norbey751@gmail.com', 'M', '2007-12-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (249, 'Yasmin', 'Berrio', 'Cardenas', 1, 'yasmin888@gmail.com', 'F', '2011-2-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (250, 'Ricardo Alfonso', 'Acosta', 'Martinez', 1, 'ricardoalfonso841@gmail.com', 'M', '2009-1-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (251, 'Diana Janeth', 'Naar', 'Mercado', 1, 'dianajaneth747@gmail.com', 'F', '2014-7-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (252, 'Gustavo Jesus', 'Higuita', 'Martinez', 1, 'gustavojesus375@gmail.com', 'M', '2015-2-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (253, 'Carlos Esteban', 'Alvarez', '', 1, 'carlosesteban881@gmail.com', 'M', '2006-4-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (254, 'Andres Alfonso', 'Polo', '', 1, 'andresalfonso449@gmail.com', 'M', '2013-10-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (255, 'Danna Sofia', 'Camargo', '', 1, 'dannasofia732@gmail.com', 'F', '2014-3-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (256, 'David Julian', 'Valle', 'Garay', 1, 'davidjulian731@gmail.com', 'M', '2007-4-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (257, 'Jorge Isaac', 'Ruiz', '', 1, 'jorgeisaac62@gmail.com', 'M', '2013-3-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (258, 'Julio', 'Espitia', '', 1, 'julio984@gmail.com', 'M', '2011-11-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (259, 'Roger Alexander', 'Ortega', '', 1, 'rogeralexander489@gmail.com', 'M', '2007-4-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (260, 'Luis Henry', 'Ortiz', '', 1, 'luishenry517@gmail.com', 'M', '2005-3-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (261, 'Marcela Pilar', 'Carrascal', 'Gonzalez', 1, 'marcelapilar664@gmail.com', 'F', '2005-2-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (262, 'Yovanna', 'Suarez', 'Balcazar', 1, 'yovanna994@gmail.com', 'F', '2010-9-21', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (263, 'Rodolfo Andres', 'Salcedo', '', 1, 'rodolfoandres966@gmail.com', 'M', '2010-8-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (264, 'Eliana Marcela', 'Avila', 'Mendivil', 1, 'elianamarcela228@gmail.com', 'F', '2013-7-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (265, 'Fabio Antonio', 'Calvo', '', 1, 'fabioantonio304@gmail.com', 'M', '2010-2-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (266, 'Rocio', 'Diaz', '', 1, 'rocio689@gmail.com', 'F', '2008-4-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (267, 'Ï»¿Sandra Milena', 'Arrieta', '', 1, 'ï»¿sandramilena69@gmail.com', 'F', '2006-2-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (268, 'Diana Pilar', 'Rivero', 'Martinez', 1, 'dianapilar184@gmail.com', 'F', '2005-1-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (269, 'William Antonio', 'Cardenas', 'Canchila', 1, 'williamantonio762@gmail.com', 'M', '2008-3-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (270, 'Leidy Alejandra', 'Martinez', 'Contreras', 1, 'leidyalejandra993@gmail.com', 'F', '2005-12-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (271, 'Jose Henry', 'Tamara', '', 1, 'josehenry728@gmail.com', 'M', '2011-12-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (272, 'Carmen Julia', 'Romero', 'Narvaez', 1, 'carmenjulia743@gmail.com', 'F', '2010-8-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (273, 'Marilin', 'Perez', 'Leiton', 1, 'marilin279@gmail.com', 'F', '2011-11-9', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (274, 'Claudia Lorena', 'Barreto', '', 1, 'claudialorena17@gmail.com', 'F', '2014-5-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (275, 'Carmen Emilia', 'Gonzalez', 'Clemente', 1, 'carmenemilia797@gmail.com', 'F', '2014-2-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (276, 'Julian Dario', 'Romero', 'Viera', 1, 'juliandario34@gmail.com', 'M', '2015-3-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (277, 'Liliana Maria', 'Nuã‘Ez', 'Marquez', 1, 'lilianamaria311@gmail.com', 'F', '2011-6-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (278, 'Gustavo Alfonso', 'Gamarra', 'Reyes', 1, 'gustavoalfonso933@gmail.com', 'M', '2011-9-21', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (279, 'Alexis', 'Viera', 'Ossa', 1, 'alexis719@gmail.com', 'M', '2012-3-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (280, 'Wilson Javier', 'Simanca', 'Martinez', 1, 'wilsonjavier982@gmail.com', 'M', '2008-7-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (281, 'July Andrea', 'Espitia', '', 1, 'julyandrea71@gmail.com', 'F', '2011-4-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (282, 'Nicole', 'Gomez', '', 1, 'nicole266@gmail.com', 'F', '2005-1-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (283, 'Luis Albeiro', 'Diaz', 'Cuello', 1, 'luisalbeiro538@gmail.com', 'M', '2007-10-5', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (284, 'Cesar Alberto', 'Alvarez', 'Marquez', 1, 'cesaralberto904@gmail.com', 'M', '2012-7-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (285, 'Wilmer Andres', 'Teheran', 'Arias', 1, 'wilmerandres713@gmail.com', 'M', '2014-5-9', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (286, 'Norman', 'Salazar', '', 1, 'norman240@gmail.com', 'M', '2013-7-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (287, 'Leidy Yuliana', 'Ragel', '', 1, 'leidyyuliana875@gmail.com', 'F', '2015-12-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (288, 'Libia Maria', 'Avila', '', 1, 'libiamaria188@gmail.com', 'F', '2013-3-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (289, 'Marco Antonio', 'Blanco', '', 1, 'marcoantonio928@gmail.com', 'M', '2008-4-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (290, 'Leidy Johana', 'Hernandez', 'Herrera', 1, 'leidyjohana897@gmail.com', 'F', '2004-5-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (291, 'Leidy Yuliana', 'Gamboa', '', 1, 'leidyyuliana188@gmail.com', 'F', '2010-7-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (292, 'Elvia Maria', 'Cabrera', '', 1, 'elviamaria885@gmail.com', 'F', '2005-5-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (293, 'Hector Manuel', 'Sierra', '', 1, 'hectormanuel341@gmail.com', 'M', '2011-10-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (294, 'Jaime Alejandro', 'Carvajal', '', 1, 'jaimealejandro172@gmail.com', 'M', '2013-1-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (295, 'Maria Marcela', 'Villadiego', 'Conde', 1, 'mariamarcela525@gmail.com', 'F', '2007-11-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (296, 'Laura Ximena', 'Peralta', 'Diaz', 1, 'lauraximena849@gmail.com', 'F', '2007-9-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (297, 'Natalia', 'Angulo', '', 1, 'natalia206@gmail.com', 'F', '2012-4-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (298, 'Olga Lucia', 'Santiago', '', 1, 'olgalucia173@gmail.com', 'F', '2010-10-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (299, 'Maria Alexandra', 'Mercado', 'Blanco', 1, 'mariaalexandra764@gmail.com', 'F', '2012-12-21', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (300, 'Rosmira', 'Contreras', 'Hoyos', 1, 'rosmira429@gmail.com', 'F', '2008-12-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (301, 'David Ricardo', 'Merlano', 'Mestra', 1, 'davidricardo552@gmail.com', 'M', '2012-11-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (302, 'Javier Andres', 'Acosta', 'Paternina', 1, 'javierandres486@gmail.com', 'M', '2013-11-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (303, 'Gian Carlo', 'Contreras', '', 1, 'giancarlo488@gmail.com', 'M', '2010-5-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (304, 'Gloria Elena', 'Sierra', 'Camargo', 1, 'gloriaelena890@gmail.com', 'F', '2014-2-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (305, 'Maria Esneda', 'De Garrido', 'Montes', 1, 'mariaesneda660@gmail.com', 'F', '2015-5-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (306, 'Alcides', 'Rodriguez', '', 1, 'alcides848@gmail.com', 'M', '2009-10-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (307, 'Maria Nora', 'Mercado', 'Leones', 1, 'marianora837@gmail.com', 'F', '2008-5-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (308, 'Yurany', 'Rodriguez', '', 1, 'yurany204@gmail.com', 'F', '2006-11-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (309, 'Nelson Jesus', 'Villero', '', 1, 'nelsonjesus42@gmail.com', 'M', '2006-1-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (310, 'Jose Rafael', 'Hoyos', '', 1, 'joserafael648@gmail.com', 'M', '2012-8-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (311, 'Leidy Katherine', 'Martinez', '', 1, 'leidykatherine623@gmail.com', 'F', '2012-8-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (312, 'Sandra', 'Arias', 'Lara', 1, 'sandra657@gmail.com', 'F', '2009-1-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (313, 'Cristian Javier', 'Lambraã‘O', 'Martinez', 1, 'cristianjavier697@gmail.com', 'M', '2012-7-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (314, 'Jacob', 'Meza', '', 1, 'jacob948@gmail.com', 'M', '2013-8-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (315, 'Carlos Fabian', 'Perez', 'Soto', 1, 'carlosfabian681@gmail.com', 'M', '2014-4-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (316, 'Gustavo Alonso', 'Ayala', 'Mora', 1, 'gustavoalonso126@gmail.com', 'M', '2010-4-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (317, 'Nerea', 'Paternina', 'Quiã‘Onez', 1, 'nerea861@gmail.com', 'F', '2014-9-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (318, 'Martha Ruth', 'Mercado', 'Villalba', 1, 'martharuth904@gmail.com', 'F', '2013-11-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (319, 'Jesus Orlando', 'Benitez', 'Machacado', 1, 'jesusorlando78@gmail.com', 'M', '2011-1-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (320, 'Jesus Maria', 'Martinez', 'Marquez', 1, 'jesusmaria322@gmail.com', 'M', '2012-11-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (321, 'Jose Oscar', 'Cabrera', 'Castillo', 1, 'joseoscar351@gmail.com', 'M', '2004-10-21', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (322, 'William Andres', 'Sierra', 'Perez', 1, 'williamandres158@gmail.com', 'M', '2005-12-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (323, 'Cristobal', 'Arrieta', '', 1, 'cristobal923@gmail.com', 'M', '2005-8-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (324, 'Jairo Alexander', 'Vargas', '', 1, 'jairoalexander356@gmail.com', 'M', '2009-6-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (325, 'Dora Lilia', 'Hernandez', '', 1, 'doralilia722@gmail.com', 'F', '2010-3-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (326, 'Maria Cielo', 'Arroyave', 'Chamorro', 1, 'mariacielo7@gmail.com', 'F', '2005-4-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (327, 'Cristian Daniel', 'Mendez', 'Reyes', 1, 'cristiandaniel213@gmail.com', 'M', '2009-1-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (328, 'Isabella', 'Solar', '', 1, 'isabella252@gmail.com', 'F', '2010-8-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (329, 'Milena', 'Rodriguez', 'Cardenas', 1, 'milena911@gmail.com', 'F', '2010-5-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (330, 'Diana Luz', 'Salcedo', '', 1, 'dianaluz299@gmail.com', 'F', '2009-7-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (331, 'Diana Cristina', 'Mendez', '', 1, 'dianacristina932@gmail.com', 'F', '2005-1-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (332, 'Sandra Rocio', 'Osorio', '', 1, 'sandrarocio641@gmail.com', 'F', '2012-7-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (333, 'Maria Elvia', 'Zapata', '', 1, 'mariaelvia114@gmail.com', 'F', '2007-3-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (334, 'Norma', 'Dias', '', 1, 'norma491@gmail.com', 'F', '2008-9-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (335, 'Maria Valentina', 'Castro', 'Bolivar', 1, 'mariavalentina375@gmail.com', 'F', '2004-7-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (336, 'Andres Alexander', 'Anaya', 'Tuiran', 1, 'andresalexander466@gmail.com', 'M', '2009-8-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (337, 'Diana Esperanza', 'Solano', 'Contreras', 1, 'dianaesperanza678@gmail.com', 'F', '2009-6-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (338, 'Maria Margarita', 'Karol', 'Hernandez', 1, 'mariamargarita355@gmail.com', 'F', '2009-12-5', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (339, 'Hector Enrique', 'Lopez', 'Villadiego', 1, 'hectorenrique574@gmail.com', 'M', '2013-12-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (340, 'Ferney', 'Clemente', 'Aguas', 1, 'ferney377@gmail.com', 'M', '2004-1-9', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (341, 'Clara Patricia', 'Fuentes', '', 1, 'clarapatricia47@gmail.com', 'F', '2004-6-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (342, 'John Edward', 'Hernandez', '', 1, 'johnedward184@gmail.com', 'M', '2014-8-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (343, 'Marley', 'Sanchez', '', 1, 'marley348@gmail.com', 'F', '2009-11-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (344, 'Daniela Maria', 'Vanegas', 'Carrascal', 1, 'danielamaria470@gmail.com', 'F', '2005-3-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (345, 'Monica Cecilia', 'Monterroza', 'Alvarez', 1, 'monicacecilia201@gmail.com', 'F', '2015-3-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (346, 'Diego Alonso', 'Villero', '', 1, 'diegoalonso379@gmail.com', 'M', '2011-9-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (347, 'Sebastian Camilo', 'Osta', '', 1, 'sebastiancamilo16@gmail.com', 'M', '2009-11-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (348, 'Yesica Lorena', 'Castro', '', 1, 'yesicalorena893@gmail.com', 'F', '2014-1-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (349, 'Hugo Hernan', 'Rojas', '', 1, 'hugohernan978@gmail.com', 'M', '2010-2-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (350, 'Dora Luz', 'Mercado', 'Bustamante', 1, 'doraluz144@gmail.com', 'F', '2005-3-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (351, 'Jose Santiago', 'Arias', 'Merlano', 1, 'josesantiago753@gmail.com', 'M', '2005-1-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (352, 'Felipe', 'Romero', 'Marin', 1, 'felipe343@gmail.com', 'M', '2006-2-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (353, 'Benilda', 'Osuna', 'Hernandez', 1, 'benilda715@gmail.com', 'F', '2006-6-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (354, 'Paula Tatiana', 'Angulo', '', 1, 'paulatatiana404@gmail.com', 'F', '2015-1-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (355, 'Didier', 'Correa', 'Jimenez', 1, 'didier125@gmail.com', 'M', '2004-6-9', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (356, 'Adolfo Leon', 'Marquez', 'Camargo', 1, 'adolfoleon544@gmail.com', 'M', '2010-7-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (357, 'Marco', 'Teheran', 'Leyva', 1, 'marco68@gmail.com', 'M', '2011-2-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (358, 'Martin Eduardo', 'Buelvas', 'Ponce', 1, 'martineduardo444@gmail.com', 'M', '2005-5-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (359, 'Jose Walter', 'Castillo', '', 1, 'josewalter205@gmail.com', 'M', '2011-10-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (360, 'Alba Rosa', 'Geres', 'Soto', 1, 'albarosa622@gmail.com', 'F', '2010-3-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (361, 'Luis Gonzaga', 'Navarro', '', 1, 'luisgonzaga26@gmail.com', 'M', '2007-6-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (362, 'Harol', 'Galindo', 'Cardenas', 1, 'harol335@gmail.com', 'M', '2012-8-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (363, 'Luis', 'Gonzalez', '', 1, 'luis486@gmail.com', 'M', '2006-3-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (364, 'Sandro', 'Flores', 'Hurtado', 1, 'sandro422@gmail.com', 'M', '2007-6-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (365, 'Lina Patricia', 'Alvarez', '', 1, 'linapatricia916@gmail.com', 'F', '2004-11-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (366, 'Danny Alexander', 'Villalba', '', 1, 'dannyalexander7@gmail.com', 'M', '2011-2-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (367, 'Pamela', 'Lopez', '', 1, 'pamela968@gmail.com', 'F', '2004-7-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (368, 'Ingrid Katherine', 'Villadiego', '', 1, 'ingridkatherine926@gmail.com', 'F', '2013-7-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (369, 'Blanca Luz', 'Ortiz', 'Bohorquez', 1, 'blancaluz696@gmail.com', 'F', '2014-5-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (370, 'Guillermo Alfonso', 'Vergara', 'Mercado', 1, 'guillermoalfonso251@gmail.com', 'M', '2011-6-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (371, 'Maria Deisy', 'Suarez', 'Castro', 1, 'mariadeisy793@gmail.com', 'F', '2007-1-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (372, 'Vilma', 'Villadiego', 'Chamorro', 1, 'vilma481@gmail.com', 'F', '2009-9-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (373, 'Noelia', 'Villa', '', 1, 'noelia569@gmail.com', 'F', '2013-5-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (374, 'Dario Antonio', 'Murillo', '', 1, 'darioantonio260@gmail.com', 'M', '2010-11-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (375, 'Dora Luz', 'Gamboa', '', 1, 'doraluz258@gmail.com', 'F', '2009-6-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (376, 'Valery', 'Barrera', '', 1, 'valery308@gmail.com', 'F', '2010-7-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (377, 'Maria Cielo', 'Ricardo', 'Serpa', 1, 'mariacielo511@gmail.com', 'F', '2008-12-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (378, 'Rubiela', 'Montes', '', 1, 'rubiela761@gmail.com', 'F', '2009-11-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (379, 'Heriberto Jesus', 'Zuã‘Iga', '', 1, 'heribertojesus151@gmail.com', 'M', '2014-8-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (380, 'Luz Mabel', 'Polo', 'Escobar', 1, 'luzmabel595@gmail.com', 'F', '2014-8-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (381, 'Ian', 'Narvaez', '', 1, 'ian45@gmail.com', 'M', '2013-12-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (382, 'Karen Andrea', 'Chamorro', '', 1, 'karenandrea822@gmail.com', 'F', '2011-7-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (383, 'Blanca Ruby', 'Rivero', 'Mendivil', 1, 'blancaruby232@gmail.com', 'F', '2012-11-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (384, 'Jhan Carlos', 'Bohorquez', 'Romero', 1, 'jhancarlos251@gmail.com', 'M', '2007-9-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (385, 'Jose German', 'Reyes', 'Campo', 1, 'josegerman829@gmail.com', 'M', '2009-3-9', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (386, 'Diana Catalina', 'Gomez', 'Carrascal', 1, 'dianacatalina127@gmail.com', 'F', '2006-11-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (387, 'Ivan', 'Ruiz', '', 1, 'ivan868@gmail.com', 'M', '2004-11-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (388, 'Martha Liliana', 'Martinez', '', 1, 'marthaliliana733@gmail.com', 'F', '2010-4-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (389, 'Maria Jesus', 'Narvaez', '', 1, 'mariajesus538@gmail.com', 'F', '2007-9-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (390, 'Maria Elsa', 'Avilez', '', 1, 'mariaelsa780@gmail.com', 'F', '2012-9-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (391, 'Gustavo Alonso', 'Contreras', '', 1, 'gustavoalonso414@gmail.com', 'M', '2013-11-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (392, 'Arturo', 'Sepulveda', '', 1, 'arturo510@gmail.com', 'M', '2010-1-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (393, 'Kevin Sebastian', 'Herazo', '', 1, 'kevinsebastian385@gmail.com', 'M', '2007-12-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (394, 'Angela Cristina', 'Hernandez', '', 1, 'angelacristina847@gmail.com', 'F', '2013-1-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (395, 'Hugo Armando', 'Buelvas', 'Fonseca', 1, 'hugoarmando497@gmail.com', 'M', '2013-8-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (396, 'Maria Marlene', 'Pedroza', 'Lagares', 1, 'mariamarlene537@gmail.com', 'F', '2011-1-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (397, 'Claudia Margarita', 'Acosta', '', 1, 'claudiamargarita499@gmail.com', 'F', '2012-7-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (398, 'Daniel Eduardo', 'Arrieta', '', 1, 'danieleduardo39@gmail.com', 'M', '2009-3-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (399, 'Gustavo Alonso', 'Hernandez', '', 1, 'gustavoalonso2@gmail.com', 'M', '2006-10-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (400, 'Cruz Elena', 'Benitez', '', 1, 'cruzelena55@gmail.com', 'F', '2012-11-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (401, 'Alberto Mario', 'Peralta', 'Polo', 1, 'albertomario329@gmail.com', 'M', '2007-12-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (402, 'Fabian Mauricio', 'De Vergara', '', 1, 'fabianmauricio716@gmail.com', 'M', '2014-9-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (403, 'Claudia Alejandra', 'Oviedo', 'Basilio', 1, 'claudiaalejandra205@gmail.com', 'F', '2011-11-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (404, 'Natalia Alejandra', 'Arroyo', 'Benitez', 1, 'nataliaalejandra720@gmail.com', 'F', '2004-5-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (405, 'Tatiana Marcela', 'Martinez', 'Rocha', 1, 'tatianamarcela23@gmail.com', 'F', '2012-8-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (406, 'Olga Marina', 'Leiton', 'De Arias', 1, 'olgamarina880@gmail.com', 'F', '2013-3-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (407, 'Jonathan', 'De La Ossa', 'Jaraba', 1, 'jonathan659@gmail.com', 'M', '2005-1-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (408, 'Lorenza', 'De Avila', 'Olivero', 1, 'lorenza782@gmail.com', 'F', '2009-6-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (409, 'Luis Guillermo', 'Martinez', '', 1, 'luisguillermo309@gmail.com', 'M', '2007-10-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (410, 'Claudia Rocio', 'Vergara', 'Ortega', 1, 'claudiarocio85@gmail.com', 'F', '2010-4-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (411, 'Kevin Alejandro', 'Martinez', 'Rodriguez', 1, 'kevinalejandro105@gmail.com', 'M', '2005-3-21', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (412, 'Rocio Pilar', 'Camargo', 'Bohorquez', 1, 'rociopilar825@gmail.com', 'F', '2014-2-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (413, 'Karen Melissa', 'Hoyos', '', 1, 'karenmelissa669@gmail.com', 'F', '2008-9-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (414, 'Paula Cristina', 'Herrera', '', 1, 'paulacristina541@gmail.com', 'F', '2009-1-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (415, 'Madeleine', 'Hernandez', 'Vanegas', 1, 'madeleine966@gmail.com', 'F', '2015-4-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (416, 'Aidee', 'Vasquez', '', 1, 'aidee991@gmail.com', 'F', '2009-9-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (417, 'Marta Ines', 'Tejada', '', 1, 'martaines449@gmail.com', 'F', '2013-2-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (418, 'Zuleima', 'Arias', 'Navarro', 1, 'zuleima334@gmail.com', 'F', '2010-4-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (419, 'Myriam', 'Torres', '', 1, 'myriam64@gmail.com', 'F', '2005-2-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (420, 'Sara', 'Uragama', '', 1, 'sara859@gmail.com', 'F', '2009-12-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (421, 'Julie Andrea', 'Marquez', '', 1, 'julieandrea981@gmail.com', 'F', '2015-3-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (422, 'Brian', 'Muã‘Oz', 'Chavez', 1, 'brian912@gmail.com', 'M', '2008-7-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (423, 'Gina Paola', 'Diaz', '', 1, 'ginapaola454@gmail.com', 'F', '2009-9-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (424, 'Ana Milena', 'De Acuã‘A', 'Hernandez', 1, 'anamilena938@gmail.com', 'F', '2007-10-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (425, 'Daiana', 'Perez', 'Guerrero', 1, 'daiana483@gmail.com', 'F', '2011-10-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (426, 'Maria Lida', 'Baiz', 'Leguia', 1, 'marialida201@gmail.com', 'F', '2007-8-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (427, 'Cesar Leonardo', 'Dion', '', 1, 'cesarleonardo276@gmail.com', 'M', '2010-7-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (428, 'Jairo', 'Murillo', '', 1, 'jairo544@gmail.com', 'M', '2006-10-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (429, 'Carlos Ernesto', 'Santiago', 'Diaz', 1, 'carlosernesto347@gmail.com', 'M', '2004-3-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (430, 'Jessica Maria', 'Ortega', '', 1, 'jessicamaria288@gmail.com', 'F', '2012-11-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (431, 'Blanca Liliana', 'Santos', 'Chavez', 1, 'blancaliliana95@gmail.com', 'F', '2014-6-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (432, 'Nicolas Esteban', 'Acosta', 'Diaz', 1, 'nicolasesteban498@gmail.com', 'M', '2012-5-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (433, 'Jessica Lorena', 'Perez', '', 1, 'jessicalorena431@gmail.com', 'F', '2007-10-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (434, 'Hamilton', 'Diaz', 'Cardenas', 1, 'hamilton941@gmail.com', 'M', '2009-10-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (435, 'William Fernando', 'Calderon', 'Sierra', 1, 'williamfernando234@gmail.com', 'M', '2015-2-21', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (436, 'Milena', 'Alvarez', 'Ortega', 1, 'milena575@gmail.com', 'F', '2006-11-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (437, 'Carmen Adriana', 'Triana', '', 1, 'carmenadriana372@gmail.com', 'F', '2015-2-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (438, 'Alison', 'Perez', 'Aleman', 1, 'alison374@gmail.com', 'F', '2015-7-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (439, 'Dayana', 'Gomez', 'Pereira', 1, 'dayana58@gmail.com', 'F', '2012-5-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (440, 'Jeremy', 'Martinez', 'Oliveros', 1, 'jeremy858@gmail.com', 'M', '2006-7-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (441, 'Natalia Carolina', 'Calvo', 'Anaya', 1, 'nataliacarolina763@gmail.com', 'F', '2011-7-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (442, 'Gabriel', 'Perez', 'Buelvas', 1, 'gabriel436@gmail.com', 'M', '2011-11-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (443, 'Maria Esneda', 'Paternina', 'Mercado', 1, 'mariaesneda666@gmail.com', 'F', '2007-2-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (444, 'Diana Lucia', 'Martinez', '', 1, 'dianalucia554@gmail.com', 'F', '2004-2-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (445, 'Edith', 'Salcedo', 'Espitia', 1, 'edith244@gmail.com', 'F', '2010-12-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (446, 'Betty', 'Martinez', '', 1, 'betty767@gmail.com', 'F', '2005-9-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (447, 'Susana', 'Benitez', '', 1, 'susana86@gmail.com', 'F', '2011-2-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (448, 'Jaime Humberto', 'Acosta', '', 1, 'jaimehumberto522@gmail.com', 'M', '2005-11-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (449, 'Ana Patricia', 'Gamboa', 'Atencia', 1, 'anapatricia93@gmail.com', 'F', '2005-2-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (450, 'John James', 'Martinez', '', 1, 'johnjames997@gmail.com', 'M', '2015-11-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (451, 'Fabio Alejandro', 'Meriã‘O', '', 1, 'fabioalejandro419@gmail.com', 'M', '2009-4-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (452, 'Oliver', 'Julio', 'De Perez', 1, 'oliver862@gmail.com', 'M', '2012-8-17', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (453, 'Dora Cecilia', 'Avilez', 'Ricardo', 1, 'doracecilia344@gmail.com', 'F', '2015-2-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (454, 'Javier Mauricio', 'Moreno', '', 1, 'javiermauricio942@gmail.com', 'M', '2012-3-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (455, 'Norma Constanza', 'Mangones', 'Escobar', 1, 'normaconstanza409@gmail.com', 'F', '2012-8-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (456, 'Yessenia', 'Fernandez', 'Romero', 1, 'yessenia0@gmail.com', 'F', '2005-2-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (457, 'Astrid', 'Peralta', 'Ropero', 1, 'astrid344@gmail.com', 'F', '2015-9-2', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (458, 'Paola Marcela', 'Teheran', 'Arias', 1, 'paolamarcela147@gmail.com', 'F', '2014-7-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (459, 'Jairo Humberto', 'Hurtado', 'De Garrido', 1, 'jairohumberto421@gmail.com', 'M', '2011-4-23', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (460, 'Diego Jesus', 'Hernandez', 'Torregroza', 1, 'diegojesus461@gmail.com', 'M', '2015-4-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (461, 'Tomas', 'Ramos', 'Vanega', 1, 'tomas73@gmail.com', 'M', '2014-8-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (462, 'Marcela', 'Martinez', '', 1, 'marcela426@gmail.com', 'F', '2009-4-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (463, 'Ana Mercedes', 'Salcedo', '', 1, 'anamercedes278@gmail.com', 'F', '2010-9-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (464, 'Rubiel', 'Eliaz', '', 1, 'rubiel736@gmail.com', 'M', '2004-9-25', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (465, 'Cecilia', 'Agamez', '', 1, 'cecilia477@gmail.com', 'F', '2007-12-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (466, 'Luz Alejandra', 'Wilches', '', 1, 'luzalejandra49@gmail.com', 'F', '2011-5-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (467, 'Constanza', 'Osta', '', 1, 'constanza974@gmail.com', 'F', '2013-1-16', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (468, 'Lucero', 'Martinez', 'Hoyos', 1, 'lucero643@gmail.com', 'F', '2014-5-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (469, 'Flor', 'Castro', '', 1, 'flor986@gmail.com', 'F', '2014-12-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (470, 'Luz Karime', 'Ladeuth', 'Benitez', 1, 'luzkarime221@gmail.com', 'F', '2006-5-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (471, 'Yamileth', 'Paternina', '', 1, 'yamileth688@gmail.com', 'F', '2012-12-19', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (472, 'Diego Fabian', 'Pedroza', 'Navarro', 1, 'diegofabian296@gmail.com', 'M', '2013-8-1', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (473, 'Daniela Alejandra', 'Solis', 'Flores', 1, 'danielaalejandra623@gmail.com', 'F', '2006-6-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (474, 'Angela Cristina', 'Marquez', 'Baiz', 1, 'angelacristina366@gmail.com', 'F', '2006-9-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (475, 'Juliana', 'Mendoza', '', 1, 'juliana310@gmail.com', 'F', '2004-12-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (476, 'Sara Ines', 'Vargas', '', 1, 'saraines662@gmail.com', 'F', '2012-12-9', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (477, 'James', 'Peã‘A', 'Ortega', 1, 'james843@gmail.com', 'M', '2015-8-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (478, 'Carlos', 'Rivero', '', 1, 'carlos292@gmail.com', 'M', '2011-10-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (479, 'Arley', 'Arias', '', 1, 'arley489@gmail.com', 'M', '2008-4-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (480, 'Jeffrey', 'Tuiran', '', 2, 'jeffrey855@gmail.com', 'M', '2001-7-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (481, 'Yovanna', 'Espitia', '', 2, 'yovanna52@gmail.com', 'F', '2001-2-6', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (482, 'Mireya', 'Porras', 'Morales', 2, 'mireya193@gmail.com', 'F', '1973-10-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (483, 'Ramon', 'Marin', '', 2, 'ramon909@gmail.com', 'M', '1989-6-24', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (484, 'Leidy Tatiana', 'Novoa', '', 2, 'leidytatiana604@gmail.com', 'F', '1975-1-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (485, 'Jhon Edinson', 'Bustamante', '', 2, 'jhonedinson583@gmail.com', 'M', '1986-8-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (486, 'Saray', 'Vides', '', 2, 'saray786@gmail.com', 'F', '1997-7-11', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (487, 'Hugo Jesus', 'Montes', 'Figueroa', 2, 'hugojesus532@gmail.com', 'M', '1960-4-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (488, 'Cristian Eduardo', 'Cardenas', '', 2, 'cristianeduardo327@gmail.com', 'M', '1979-12-20', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (489, 'Jose Alonso', 'Galvis', '', 2, 'josealonso555@gmail.com', 'M', '1996-4-22', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (490, 'Maria Gabriela', 'Peã‘A', 'Peã‘A', 2, 'mariagabriela226@gmail.com', 'F', '1960-5-4', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (491, 'Juan', 'Tapias', '', 2, 'juan266@gmail.com', 'M', '1977-5-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (492, 'Jose Edison', 'Ricardo', 'Rivera', 2, 'joseedison864@gmail.com', 'M', '1997-3-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (493, 'Christian Andres', 'Sierra', 'Herazo', 2, 'christianandres819@gmail.com', 'M', '1962-6-8', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (494, 'Ingrid Katherine', 'Peralta', '', 2, 'ingridkatherine266@gmail.com', 'F', '1994-9-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (495, 'Jhony Alexander', 'Mendoza', '', 2, 'jhonyalexander937@gmail.com', 'M', '1983-3-3', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (496, 'Alvaro Javier', 'Cardenas', '', 2, 'alvarojavier462@gmail.com', 'M', '1990-2-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (497, 'Leidy Vanessa', 'Arroyo', 'Garizabalo', 2, 'leidyvanessa268@gmail.com', 'F', '1982-2-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (498, 'Juan Ricardo', 'Ortiz', 'Martinez', 2, 'juanricardo593@gmail.com', 'M', '1970-4-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (499, 'Fernando Augusto', 'Zabaleta', '', 2, 'fernandoaugusto778@gmail.com', 'M', '1990-6-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (500, 'Luz Angelica', 'Herrera', 'Hernandez', 2, 'luzangelica808@gmail.com', 'F', '2002-3-26', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (501, 'Cristian Andres', 'Flores', '', 2, 'cristianandres644@gmail.com', 'M', '1973-6-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (502, 'Laura Milena', 'Leiton', '', 2, 'lauramilena826@gmail.com', 'F', '1971-10-5', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (503, 'Nini Johana', 'Sierra', 'Mercado', 2, 'ninijohana723@gmail.com', 'F', '1987-11-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (504, 'Ricardo Jesus', 'Barboza', 'Alvarez', 2, 'ricardojesus833@gmail.com', 'M', '1991-11-14', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (505, 'Mauricio Alexander', 'Monterroza', 'Tuiran', 2, 'mauricioalexander911@gmail.com', 'M', '1968-1-12', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (506, 'Napoleon', 'Alvarez', '', 2, 'napoleon638@gmail.com', 'M', '1996-4-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (507, 'Ricardo Antonio', 'Montes', 'Garcia', 2, 'ricardoantonio790@gmail.com', 'M', '1995-7-9', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (508, 'Mauricio', 'Rocha', '', 2, 'mauricio409@gmail.com', 'M', '1980-6-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (509, 'Nohemy', 'Luna', '', 2, 'nohemy351@gmail.com', 'F', '1993-1-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (510, 'Miguel Alejandro', 'Ponce', '', 3, 'miguelalejandro183@gmail.com', 'M', '1973-12-10', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (511, 'Juan Guillermo', 'Garcia', 'Perez', 3, 'juanguillermo925@gmail.com', 'M', '2002-2-28', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (512, 'Claudia', 'Angulo', 'Plaza', 3, 'claudia463@gmail.com', 'F', '1982-4-18', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (513, 'Nayibe', 'Sierra', '', 3, 'nayibe333@gmail.com', 'F', '1996-4-27', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (514, 'Samanta', 'Albarino', '', 3, 'samanta240@gmail.com', 'F', '1961-2-7', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (515, 'David Fernando', 'Torres', 'Chavez', 3, 'davidfernando517@gmail.com', 'M', '1969-5-15', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (516, 'Javier Antonio', 'Castillo', 'Estrada', 3, 'javierantonio270@gmail.com', 'M', '1982-4-13', 0, DEFAULT, NULL, NULL, NULL, NULL);
INSERT INTO `sadeDB`.`Usuarios` (`idUsuario`, `nombres`, `apellido1`, `apellido2`, `tipo`, `email`, `sexo`, `fechaNacimiento`, `intentosConexion`, `fechaRegistro`, `contrasenia`, `remember_token`, `fotoPerfil`, `delete`) VALUES (517, 'Reinaldo Jesus', 'Wilches', '', 3, 'reinaldojesus813@gmail.com', 'M', '1975-5-6', 0, DEFAULT, NULL, NULL, NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `sadeDB`.`Docentes`
-- -----------------------------------------------------
START TRANSACTION;
USE `sadeDB`;
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (480, 'Carrera 56 #1-27', 'Licenciado en literatura');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (481, 'Carrera 36 #10-57', 'Licenciado en literatura');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (482, 'Calle 47 #72-60', 'Licenciado en ingles');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (483, 'Carrera 50 #97-27', 'Licenciado en geografía e historia');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (484, 'Calle 52 #50-13', 'Biologo');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (485, 'Calle 227 #43-71', 'Licenciado en ingles');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (486, 'Calle 69 #32-78', 'Biologo');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (487, 'Calle 50 #65-61', 'Matematico');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (488, 'Calle 154 #12-39', 'Licenciado en literatura');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (489, 'Carrera 12 #49-90', 'Licenciado en geografía e historia');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (490, 'Carrera 57 #70-37', 'Licenciado en geografía e historia');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (491, 'Calle 72 #16-84', 'Matematico');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (492, 'Calle 86 #91-31', 'Biologo');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (493, 'Carrera 59 #39-77', 'Biologo');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (494, 'Calle 237 #48-78', 'Ingeniero en sistemas');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (495, 'Calle 55 #60-47', 'Licenciado en literatura');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (496, 'Carrera 63 #26-36', 'Licenciado en ingles');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (497, 'Carrera 67 #8-5', 'Biologo');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (498, 'Carrera 17 #42-80', 'Matematico');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (499, 'Calle 208 #43-77', 'Matematico');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (500, 'Calle 234 #68-20', 'Ingeniero en sistemas');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (501, 'Calle 11 #82-35', 'Licenciado en literatura');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (502, 'Carrera 62 #52-33', 'Licenciado en geografía e historia');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (503, 'Carrera 23 #18-97', 'Ingeniero en sistemas');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (504, 'Carrera 11 #83-37', 'Biologo');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (505, 'Carrera 15 #34-39', 'Matematico');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (506, 'Calle 239 #56-35', 'Licenciado en ingles');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (507, 'Calle 197 #72-38', 'Ingeniero en sistemas');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (508, 'Calle 246 #83-71', 'Licenciado en literatura');
INSERT INTO `sadeDB`.`Docentes` (`idUsuario`, `direccion`, `perfilAcademico`) VALUES (509, 'Carrera 29 #33-27', 'Ingeniero en sistemas');

COMMIT;


-- -----------------------------------------------------
-- Data for table `sadeDB`.`Grupos`
-- -----------------------------------------------------
START TRANSACTION;
USE `sadeDB`;
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (401, '401', 'Tarde', 258, 4, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (402, '402', 'Nocturno', 106, 4, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (403, '403', 'Mañana', 200, 4, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (501, '501', 'Mañana', 190, 5, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (502, '502', 'Tarde', 123, 5, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (503, '503', 'Nocturno', 179, 5, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (601, '601', 'Nocturno', 107, 6, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (602, '602', 'Nocturno', 203, 6, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (603, '603', 'Tarde', 173, 6, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (701, '701', 'Mañana', 100, 7, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (702, '702', 'Mixto', 293, 7, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (703, '703', 'Mañana', 264, 7, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (801, '801', 'Nocturno', 288, 8, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (802, '802', 'Mixto', 254, 8, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (803, '803', 'Tarde', 242, 8, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (901, '901', 'Mixto', 207, 9, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (902, '902', 'Mañana', 190, 9, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (903, '903', 'Tarde', 252, 9, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (1001, '1001', 'Mixto', 289, 10, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (1002, '1002', 'Mañana', 272, 10, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (1003, '1003', 'Nocturno', 269, 10, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (1101, '1101', 'Mixto', 213, 11, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (1102, '1102', 'Mixto', 171, 11, NULL);
INSERT INTO `sadeDB`.`Grupos` (`idGrupo`, `nombre`, `jornada`, `salon`, `grado`, `director`) VALUES (1103, '1103', 'Mañana', 139, 11, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `sadeDB`.`Estudiantes`
-- -----------------------------------------------------
START TRANSACTION;
USE `sadeDB`;
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (1, 'Calle 158 #78-54', '0+', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (2, 'Calle 177 #72-78', '0+', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (3, 'Calle 167 #89-80', 'AB+', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (4, 'Carrera 26 #97-26', 'A-', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (5, 'Carrera 50 #35-11', 'AB-', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (6, 'Calle 56 #50-62', 'B+', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (7, 'Calle 187 #96-14', 'A-', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (8, 'Calle 277 #68-93', 'B+', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (9, 'Carrera 65 #74-80', '0+', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (10, 'Carrera 31 #99-90', 'A+', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (11, 'Calle 278 #60-78', 'A-', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (12, 'Carrera 15 #89-64', 'B+', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (13, 'Carrera 26 #84-28', 'B-', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (14, 'Calle 225 #12-82', '0+', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (15, 'Carrera 51 #45-45', '0+', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (16, 'Calle 82 #87-13', 'B+', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (17, 'Calle 192 #39-66', 'B-', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (18, 'Calle 146 #3-46', 'AB+', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (19, 'Calle 64 #70-6', 'AB-', 0, 1103);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (20, 'Calle 298 #4-48', '0+', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (21, 'Calle 112 #6-31', '0-', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (22, 'Calle 100 #82-33', '0+', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (23, 'Calle 169 #21-37', '0+', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (24, 'Carrera 30 #82-55', 'A+', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (25, 'Calle 225 #30-32', 'AB-', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (26, 'Calle 7 #9-50', '0-', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (27, 'Carrera 43 #73-12', 'B-', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (28, 'Calle 219 #96-12', 'AB-', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (29, 'Calle 164 #26-68', 'A-', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (30, 'Calle 125 #83-53', '0+', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (31, 'Calle 231 #36-70', 'AB-', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (32, 'Calle 270 #86-37', 'AB+', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (33, 'Carrera 60 #35-91', 'A+', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (34, 'Calle 263 #99-45', '0+', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (35, 'Calle 94 #89-45', 'A-', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (36, 'Carrera 61 #73-72', '0+', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (37, 'Carrera 52 #35-70', 'A+', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (38, 'Calle 166 #83-18', '0-', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (39, 'Calle 46 #86-10', 'B+', 0, 401);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (40, 'Calle 159 #84-40', '0-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (41, 'Carrera 70 #13-23', '0+', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (42, 'Carrera 38 #5-30', 'A-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (43, 'Carrera 1 #74-52', 'B-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (44, 'Carrera 24 #37-44', 'AB-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (45, 'Calle 223 #88-87', '0+', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (46, 'Carrera 6 #2-69', 'B+', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (47, 'Carrera 20 #20-98', 'A+', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (48, 'Calle 239 #16-82', 'A-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (49, 'Carrera 38 #94-53', '0-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (50, 'Carrera 48 #78-94', '0+', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (51, 'Carrera 8 #41-7', '0-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (52, 'Carrera 15 #28-17', 'A-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (53, 'Carrera 60 #80-33', 'AB-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (54, 'Carrera 34 #12-33', 'AB-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (55, 'Calle 171 #58-3', 'A+', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (56, 'Calle 221 #50-17', '0-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (57, 'Carrera 49 #27-1', '0-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (58, 'Calle 28 #18-29', 'B+', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (59, 'Calle 23 #19-63', 'A-', 0, 402);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (60, 'Carrera 43 #31-28', 'AB+', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (61, 'Calle 109 #11-8', 'AB+', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (62, 'Calle 42 #26-24', 'A-', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (63, 'Calle 130 #18-36', 'A+', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (64, 'Calle 47 #99-5', 'B-', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (65, 'Carrera 46 #86-41', '0-', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (66, 'Carrera 15 #10-22', '0-', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (67, 'Carrera 51 #26-16', 'AB-', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (68, 'Carrera 57 #44-17', 'A+', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (69, 'Carrera 28 #70-8', '0+', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (70, 'Carrera 23 #39-99', 'A+', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (71, 'Calle 157 #73-24', 'B-', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (72, 'Carrera 66 #21-92', '0+', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (73, 'Calle 171 #83-35', '0-', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (74, 'Calle 81 #92-99', 'B+', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (75, 'Calle 87 #86-99', 'A+', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (76, 'Carrera 29 #99-13', 'A+', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (77, 'Calle 227 #32-20', '0-', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (78, 'Calle 169 #69-20', '0+', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (79, 'Carrera 3 #55-69', 'A-', 0, 403);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (80, 'Carrera 68 #20-49', 'B+', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (81, 'Carrera 14 #85-48', 'B-', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (82, 'Calle 256 #90-52', 'A-', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (83, 'Carrera 60 #29-19', 'A+', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (84, 'Carrera 27 #97-98', 'B-', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (85, 'Calle 193 #90-45', 'A-', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (86, 'Carrera 40 #56-85', 'AB+', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (87, 'Calle 181 #73-30', 'A+', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (88, 'Carrera 6 #17-96', 'A+', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (89, 'Calle 167 #70-30', 'A-', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (90, 'Carrera 1 #70-61', 'B-', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (91, 'Carrera 67 #37-46', 'AB-', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (92, 'Carrera 3 #66-10', '0+', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (93, 'Calle 150 #52-31', 'A+', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (94, 'Calle 30 #42-81', 'B+', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (95, 'Carrera 38 #62-14', 'AB-', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (96, 'Carrera 16 #62-7', '0+', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (97, 'Carrera 37 #54-49', 'AB-', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (98, 'Carrera 29 #89-12', 'AB+', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (99, 'Carrera 12 #21-8', 'B+', 0, 501);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (100, 'Calle 283 #31-77', 'AB-', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (101, 'Carrera 50 #7-94', 'B+', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (102, 'Calle 181 #67-49', 'AB-', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (103, 'Calle 141 #58-45', 'B+', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (104, 'Carrera 20 #2-52', '0-', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (105, 'Calle 240 #8-27', 'B+', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (106, 'Carrera 55 #26-8', 'B+', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (107, 'Carrera 2 #14-70', 'A-', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (108, 'Calle 111 #2-17', 'A-', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (109, 'Calle 265 #45-81', 'A-', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (110, 'Calle 7 #7-96', 'B-', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (111, 'Calle 224 #64-86', 'AB+', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (112, 'Carrera 13 #12-10', 'B+', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (113, 'Carrera 16 #94-14', 'AB-', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (114, 'Calle 113 #58-73', 'AB-', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (115, 'Carrera 27 #66-93', 'A-', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (116, 'Carrera 39 #53-55', '0+', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (117, 'Carrera 48 #94-1', 'A+', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (118, 'Carrera 27 #54-49', 'A-', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (119, 'Calle 169 #30-32', 'AB+', 0, 502);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (120, 'Calle 268 #71-71', 'A+', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (121, 'Carrera 70 #65-5', 'AB+', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (122, 'Calle 263 #62-34', '0-', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (123, 'Carrera 18 #22-33', 'AB-', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (124, 'Carrera 34 #40-39', 'AB-', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (125, 'Carrera 47 #81-5', '0+', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (126, 'Calle 219 #62-14', 'B+', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (127, 'Carrera 35 #6-81', 'B+', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (128, 'Carrera 19 #52-39', 'AB+', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (129, 'Calle 189 #57-4', 'AB+', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (130, 'Calle 199 #66-2', 'A-', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (131, 'Carrera 23 #81-44', 'AB-', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (132, 'Carrera 25 #98-63', 'AB+', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (133, 'Carrera 28 #10-56', 'AB-', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (134, 'Carrera 63 #34-86', 'B+', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (135, 'Carrera 17 #54-46', '0-', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (136, 'Carrera 55 #84-34', 'AB+', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (137, 'Carrera 36 #31-24', 'AB+', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (138, 'Calle 102 #25-82', 'B+', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (139, 'Calle 92 #8-94', 'AB-', 0, 503);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (140, 'Carrera 39 #5-67', 'AB-', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (141, 'Calle 82 #21-66', 'B-', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (142, 'Calle 94 #77-92', 'AB-', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (143, 'Carrera 51 #13-68', '0+', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (144, 'Carrera 40 #27-60', 'AB-', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (145, 'Carrera 17 #6-76', 'AB+', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (146, 'Calle 138 #25-72', 'A-', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (147, 'Calle 61 #73-9', 'A+', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (148, 'Carrera 18 #7-62', '0-', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (149, 'Carrera 21 #45-34', 'A-', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (150, 'Carrera 22 #23-5', 'AB-', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (151, 'Carrera 44 #84-89', '0-', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (152, 'Calle 18 #53-2', 'AB+', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (153, 'Carrera 38 #89-13', 'B+', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (154, 'Carrera 8 #85-65', '0+', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (155, 'Carrera 61 #43-6', '0+', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (156, 'Carrera 69 #61-95', 'AB-', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (157, 'Carrera 56 #15-99', 'B-', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (158, 'Calle 166 #35-81', 'B-', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (159, 'Calle 206 #92-75', 'AB+', 0, 601);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (160, 'Calle 34 #30-22', '0-', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (161, 'Calle 148 #76-76', 'A+', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (162, 'Calle 254 #94-66', 'B-', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (163, 'Carrera 59 #15-64', 'B-', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (164, 'Calle 282 #93-83', '0+', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (165, 'Carrera 42 #31-12', 'A-', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (166, 'Carrera 4 #51-41', 'AB-', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (167, 'Carrera 37 #24-37', '0+', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (168, 'Carrera 20 #58-79', 'AB-', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (169, 'Carrera 16 #28-70', 'A-', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (170, 'Calle 279 #87-12', 'AB-', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (171, 'Carrera 11 #52-67', '0-', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (172, 'Calle 81 #4-59', 'AB+', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (173, 'Calle 132 #75-96', 'A+', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (174, 'Calle 14 #91-31', '0+', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (175, 'Calle 123 #32-82', 'AB+', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (176, 'Calle 90 #68-70', 'A+', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (177, 'Carrera 41 #92-97', '0-', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (178, 'Calle 207 #64-22', 'B+', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (179, 'Calle 263 #56-71', 'A-', 0, 602);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (180, 'Calle 187 #83-29', 'B+', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (181, 'Calle 213 #7-30', 'A-', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (182, 'Calle 260 #2-85', 'A-', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (183, 'Carrera 67 #71-34', '0+', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (184, 'Carrera 39 #81-19', '0+', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (185, 'Calle 128 #82-68', '0+', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (186, 'Carrera 68 #96-34', 'AB-', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (187, 'Carrera 32 #63-45', 'AB-', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (188, 'Calle 99 #61-5', 'AB-', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (189, 'Carrera 39 #53-31', 'A+', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (190, 'Carrera 28 #14-26', 'A-', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (191, 'Calle 227 #48-52', '0+', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (192, 'Carrera 37 #47-53', '0-', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (193, 'Carrera 39 #1-27', 'B-', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (194, 'Calle 233 #53-68', '0+', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (195, 'Carrera 45 #7-92', 'B-', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (196, 'Calle 138 #36-37', 'B-', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (197, 'Calle 195 #33-91', 'B-', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (198, 'Carrera 9 #20-15', '0-', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (199, 'Carrera 24 #93-48', 'AB+', 0, 603);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (200, 'Carrera 44 #94-45', 'A+', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (201, 'Calle 199 #25-44', 'B-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (202, 'Carrera 52 #5-3', 'B-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (203, 'Carrera 6 #12-12', '0-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (204, 'Calle 15 #3-24', 'B+', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (205, 'Carrera 51 #66-57', 'B+', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (206, 'Calle 175 #52-24', 'AB-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (207, 'Carrera 16 #79-12', 'B-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (208, 'Carrera 9 #4-66', 'B-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (209, 'Calle 251 #23-81', 'B-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (210, 'Carrera 27 #57-31', 'AB-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (211, 'Carrera 4 #35-68', 'B-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (212, 'Calle 161 #63-93', 'A-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (213, 'Calle 171 #37-78', 'A+', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (214, 'Carrera 54 #28-88', 'B+', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (215, 'Carrera 25 #87-92', 'AB+', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (216, 'Carrera 37 #3-77', 'A+', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (217, 'Carrera 28 #91-48', 'A-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (218, 'Calle 299 #13-40', 'A-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (219, 'Calle 167 #89-54', '0-', 0, 701);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (220, 'Carrera 35 #63-65', 'A-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (221, 'Calle 207 #44-84', 'B-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (222, 'Calle 254 #72-85', 'B-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (223, 'Carrera 5 #52-26', 'B-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (224, 'Carrera 1 #4-46', '0+', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (225, 'Calle 242 #92-58', 'A-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (226, 'Calle 11 #46-56', 'A-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (227, 'Calle 59 #12-84', 'B+', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (228, 'Calle 240 #9-29', 'AB-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (229, 'Carrera 51 #61-29', 'AB-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (230, 'Calle 44 #73-44', '0-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (231, 'Calle 110 #45-14', 'B-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (232, 'Calle 50 #60-50', 'AB-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (233, 'Carrera 60 #37-1', 'A-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (234, 'Carrera 14 #67-49', 'B+', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (235, 'Calle 95 #47-64', 'B-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (236, 'Calle 268 #28-20', 'B+', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (237, 'Calle 164 #56-13', 'AB-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (238, 'Calle 80 #97-83', '0-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (239, 'Carrera 24 #97-24', '0-', 0, 702);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (240, 'Carrera 52 #99-76', 'AB+', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (241, 'Carrera 14 #91-46', 'B-', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (242, 'Calle 134 #68-61', '0-', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (243, 'Carrera 19 #62-57', 'B+', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (244, 'Calle 46 #29-13', '0+', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (245, 'Carrera 28 #12-94', 'A+', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (246, 'Carrera 64 #88-17', 'AB-', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (247, 'Carrera 65 #65-64', 'B-', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (248, 'Carrera 41 #78-81', 'A-', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (249, 'Carrera 12 #96-54', 'A+', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (250, 'Carrera 2 #37-61', 'AB-', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (251, 'Carrera 20 #38-18', 'A-', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (252, 'Carrera 63 #75-73', '0+', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (253, 'Carrera 11 #97-74', '0-', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (254, 'Carrera 19 #40-99', 'A-', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (255, 'Calle 115 #38-59', 'AB-', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (256, 'Carrera 56 #97-42', 'AB+', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (257, 'Carrera 63 #50-45', 'A+', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (258, 'Carrera 18 #30-21', 'B-', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (259, 'Calle 166 #46-98', '0+', 0, 703);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (260, 'Carrera 4 #28-92', 'A-', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (261, 'Carrera 11 #97-27', 'AB-', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (262, 'Calle 290 #37-87', 'A+', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (263, 'Calle 36 #20-43', 'AB-', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (264, 'Carrera 65 #95-34', 'B-', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (265, 'Calle 36 #92-66', '0-', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (266, 'Calle 259 #79-90', 'AB+', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (267, 'Carrera 64 #51-72', 'A+', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (268, 'Calle 216 #41-10', 'AB-', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (269, 'Carrera 55 #35-68', '0-', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (270, 'Calle 186 #18-21', 'A+', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (271, 'Calle 100 #59-82', 'AB+', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (272, 'Carrera 33 #63-27', 'A+', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (273, 'Calle 182 #8-90', 'A+', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (274, 'Calle 40 #97-36', 'B+', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (275, 'Carrera 66 #6-50', 'B-', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (276, 'Calle 67 #23-79', 'A-', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (277, 'Calle 119 #39-9', '0+', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (278, 'Calle 114 #23-27', '0-', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (279, 'Calle 210 #75-46', '0-', 0, 801);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (280, 'Carrera 45 #19-8', '0-', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (281, 'Calle 149 #70-63', 'AB-', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (282, 'Carrera 43 #94-30', 'B+', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (283, 'Calle 28 #9-39', 'B+', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (284, 'Carrera 30 #98-14', '0+', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (285, 'Carrera 38 #34-84', 'AB+', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (286, 'Carrera 53 #16-42', 'B-', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (287, 'Carrera 41 #44-83', '0-', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (288, 'Calle 203 #41-13', 'A-', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (289, 'Carrera 19 #21-47', '0+', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (290, 'Calle 287 #92-4', 'AB+', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (291, 'Calle 99 #98-44', 'B+', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (292, 'Calle 51 #47-1', '0+', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (293, 'Carrera 49 #67-84', 'A+', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (294, 'Carrera 35 #56-36', 'AB-', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (295, 'Calle 226 #3-1', 'AB+', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (296, 'Calle 245 #38-85', 'AB+', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (297, 'Calle 284 #20-2', 'A-', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (298, 'Calle 20 #80-11', 'B-', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (299, 'Calle 249 #89-2', '0+', 0, 802);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (300, 'Calle 152 #6-5', 'B-', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (301, 'Calle 24 #5-88', 'A-', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (302, 'Carrera 39 #78-33', 'A+', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (303, 'Carrera 46 #69-36', 'B-', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (304, 'Carrera 41 #99-94', 'A+', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (305, 'Carrera 28 #49-23', 'B-', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (306, 'Carrera 16 #27-25', 'A-', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (307, 'Carrera 54 #53-26', 'AB+', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (308, 'Calle 128 #18-94', 'AB-', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (309, 'Carrera 57 #98-26', '0+', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (310, 'Carrera 33 #15-26', 'A-', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (311, 'Carrera 48 #33-9', 'AB+', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (312, 'Calle 175 #96-42', 'A-', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (313, 'Calle 277 #58-73', 'B+', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (314, 'Carrera 3 #40-58', '0-', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (315, 'Carrera 41 #1-87', 'B-', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (316, 'Carrera 41 #56-13', '0+', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (317, 'Calle 146 #79-54', 'B+', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (318, 'Calle 291 #78-1', 'A+', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (319, 'Calle 170 #99-9', '0+', 0, 803);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (320, 'Calle 70 #31-53', 'A-', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (321, 'Carrera 16 #71-49', 'B-', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (322, 'Carrera 22 #82-75', '0+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (323, 'Calle 86 #2-20', '0+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (324, 'Calle 190 #94-73', 'B+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (325, 'Calle 194 #33-11', 'A+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (326, 'Carrera 56 #31-14', '0+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (327, 'Carrera 29 #64-48', '0+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (328, 'Carrera 62 #82-33', '0+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (329, 'Carrera 32 #59-83', 'A-', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (330, 'Carrera 1 #62-65', '0+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (331, 'Carrera 47 #12-86', 'AB+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (332, 'Carrera 7 #34-5', 'A+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (333, 'Calle 1 #14-95', 'B+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (334, 'Carrera 24 #85-35', 'B-', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (335, 'Calle 91 #46-71', 'B-', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (336, 'Calle 42 #4-54', 'B+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (337, 'Carrera 36 #71-90', '0+', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (338, 'Calle 8 #77-11', '0-', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (339, 'Calle 238 #83-85', 'AB-', 0, 901);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (340, 'Carrera 51 #72-8', '0-', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (341, 'Calle 193 #22-78', '0+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (342, 'Calle 283 #89-92', 'AB+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (343, 'Calle 213 #46-19', '0+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (344, 'Calle 160 #85-18', '0+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (345, 'Calle 159 #88-32', 'AB+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (346, 'Calle 196 #55-91', '0+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (347, 'Carrera 52 #75-79', 'A-', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (348, 'Calle 102 #60-98', '0-', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (349, 'Carrera 55 #29-87', 'AB+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (350, 'Carrera 28 #32-62', 'AB+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (351, 'Calle 74 #97-32', 'B+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (352, 'Carrera 13 #8-11', 'A+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (353, 'Calle 272 #42-91', '0+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (354, 'Calle 42 #73-76', 'AB-', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (355, 'Calle 174 #66-97', 'B-', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (356, 'Carrera 41 #12-86', '0+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (357, 'Carrera 66 #68-12', 'B+', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (358, 'Carrera 52 #77-37', '0-', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (359, 'Carrera 4 #75-7', 'B-', 0, 902);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (360, 'Carrera 52 #10-42', 'AB+', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (361, 'Carrera 29 #3-76', 'A+', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (362, 'Carrera 42 #82-32', 'B+', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (363, 'Calle 29 #72-50', 'A-', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (364, 'Calle 73 #57-84', 'B-', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (365, 'Carrera 33 #38-55', 'B+', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (366, 'Calle 181 #23-52', 'A-', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (367, 'Calle 228 #66-83', 'B-', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (368, 'Carrera 41 #91-39', 'A+', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (369, 'Carrera 53 #57-93', '0+', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (370, 'Calle 222 #90-69', 'B-', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (371, 'Calle 3 #12-6', '0+', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (372, 'Calle 183 #15-1', 'A-', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (373, 'Calle 203 #78-67', '0+', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (374, 'Carrera 61 #6-49', 'AB+', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (375, 'Carrera 34 #14-24', 'A-', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (376, 'Carrera 1 #10-22', 'AB+', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (377, 'Carrera 50 #95-66', 'B-', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (378, 'Calle 187 #31-31', 'A-', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (379, 'Carrera 53 #30-43', 'B+', 0, 903);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (380, 'Calle 105 #1-10', '0+', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (381, 'Carrera 70 #11-71', 'A-', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (382, 'Carrera 20 #62-82', 'A+', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (383, 'Calle 85 #23-62', 'B+', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (384, 'Calle 27 #69-82', 'AB+', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (385, 'Calle 116 #15-88', 'B-', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (386, 'Calle 153 #18-44', 'AB-', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (387, 'Calle 10 #65-85', 'B-', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (388, 'Calle 245 #11-5', 'AB+', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (389, 'Calle 211 #21-19', 'B+', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (390, 'Calle 2 #79-60', 'AB+', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (391, 'Calle 290 #17-45', 'A-', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (392, 'Carrera 53 #67-21', 'B-', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (393, 'Calle 242 #24-17', 'AB+', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (394, 'Carrera 47 #34-68', 'A+', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (395, 'Calle 6 #27-93', 'B+', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (396, 'Carrera 48 #78-76', '0-', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (397, 'Calle 282 #96-22', '0+', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (398, 'Calle 238 #99-50', 'B+', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (399, 'Carrera 68 #70-69', '0-', 0, 1001);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (400, 'Calle 296 #21-31', 'AB-', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (401, 'Calle 7 #88-59', '0-', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (402, 'Calle 198 #54-90', 'B-', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (403, 'Calle 151 #64-87', 'A-', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (404, 'Carrera 21 #64-86', 'AB+', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (405, 'Calle 228 #85-27', '0-', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (406, 'Carrera 67 #14-34', 'AB-', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (407, 'Carrera 61 #2-94', 'B+', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (408, 'Calle 194 #34-94', 'B+', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (409, 'Carrera 67 #25-61', 'B+', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (410, 'Carrera 16 #25-20', 'A-', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (411, 'Carrera 27 #2-65', 'AB-', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (412, 'Carrera 22 #99-45', 'B+', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (413, 'Calle 75 #76-92', 'AB+', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (414, 'Carrera 22 #10-18', 'A-', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (415, 'Calle 63 #70-11', 'B-', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (416, 'Carrera 7 #99-91', 'A+', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (417, 'Carrera 1 #32-3', 'B-', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (418, 'Carrera 24 #92-24', 'A+', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (419, 'Carrera 53 #56-49', 'AB+', 0, 1002);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (420, 'Carrera 42 #77-20', 'AB+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (421, 'Carrera 49 #33-47', 'AB+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (422, 'Calle 169 #71-96', 'AB+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (423, 'Carrera 1 #24-28', 'B+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (424, 'Carrera 3 #70-94', 'B+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (425, 'Carrera 42 #39-33', 'AB+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (426, 'Calle 40 #13-29', 'AB-', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (427, 'Calle 248 #89-94', '0-', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (428, 'Calle 275 #4-70', 'B+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (429, 'Calle 190 #59-21', 'AB-', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (430, 'Calle 151 #53-70', 'AB-', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (431, 'Calle 242 #41-22', 'B-', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (432, 'Carrera 14 #42-35', 'AB+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (433, 'Calle 198 #24-91', '0+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (434, 'Calle 203 #73-85', 'B+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (435, 'Calle 174 #53-99', '0+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (436, 'Carrera 17 #18-77', 'AB+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (437, 'Carrera 36 #55-44', 'B-', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (438, 'Carrera 41 #44-16', 'A+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (439, 'Carrera 49 #92-99', 'A+', 0, 1003);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (440, 'Calle 146 #52-15', 'B-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (441, 'Calle 203 #76-91', 'A-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (442, 'Calle 265 #85-1', 'AB-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (443, 'Carrera 48 #8-19', '0-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (444, 'Calle 128 #35-42', '0+', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (445, 'Calle 181 #89-91', 'AB+', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (446, 'Carrera 23 #52-92', '0-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (447, 'Calle 160 #86-65', '0+', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (448, 'Carrera 69 #74-13', 'B-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (449, 'Carrera 7 #87-96', '0-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (450, 'Calle 30 #78-91', 'AB-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (451, 'Carrera 24 #9-86', 'AB+', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (452, 'Carrera 65 #92-76', 'B-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (453, 'Carrera 62 #61-79', 'B-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (454, 'Carrera 38 #55-14', 'B-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (455, 'Calle 260 #28-73', 'A+', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (456, 'Carrera 64 #7-32', 'AB-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (457, 'Calle 245 #79-13', 'AB+', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (458, 'Calle 124 #53-16', '0-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (459, 'Carrera 32 #72-89', '0-', 0, 1101);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (460, 'Carrera 62 #42-7', 'AB-', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (461, 'Carrera 9 #58-28', '0-', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (462, 'Calle 232 #13-42', 'B-', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (463, 'Calle 12 #30-41', 'AB-', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (464, 'Calle 192 #94-79', 'B+', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (465, 'Carrera 30 #95-77', '0-', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (466, 'Calle 68 #29-14', 'A-', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (467, 'Calle 198 #94-85', 'A+', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (468, 'Carrera 60 #80-2', 'B-', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (469, 'Carrera 25 #23-62', 'A+', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (470, 'Carrera 41 #97-48', 'B-', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (471, 'Carrera 53 #55-29', 'A-', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (472, 'Carrera 35 #81-23', '0-', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (473, 'Calle 166 #38-26', 'AB+', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (474, 'Carrera 43 #70-78', 'A+', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (475, 'Calle 20 #11-11', 'AB-', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (476, 'Carrera 32 #84-16', '0+', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (477, 'Carrera 27 #44-27', 'AB+', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (478, 'Carrera 13 #87-97', '0+', 0, 1102);
INSERT INTO `sadeDB`.`Estudiantes` (`idUsuario`, `direccion`, `RH`, `egresado`, `idGrupo`) VALUES (479, 'Calle 72 #9-34', 'B+', 0, 1102);

COMMIT;


-- -----------------------------------------------------
-- Data for table `sadeDB`.`Directivos`
-- -----------------------------------------------------
START TRANSACTION;
USE `sadeDB`;
INSERT INTO `sadeDB`.`Directivos` (`idUsuario`, `cargo`, `direccion`, `emailPublico`) VALUES (510, 'Secretari@', 'Carrera 24 #31-42', 'directivo-510@sade.edu');
INSERT INTO `sadeDB`.`Directivos` (`idUsuario`, `cargo`, `direccion`, `emailPublico`) VALUES (511, 'Consejero', 'Carrera 43 #93-19', 'directivo-511@sade.edu');
INSERT INTO `sadeDB`.`Directivos` (`idUsuario`, `cargo`, `direccion`, `emailPublico`) VALUES (512, 'Coordinador', 'Carrera 20 #69-96', 'directivo-512@sade.edu');
INSERT INTO `sadeDB`.`Directivos` (`idUsuario`, `cargo`, `direccion`, `emailPublico`) VALUES (513, 'Psicologo', 'Calle 111 #77-69', 'directivo-513@sade.edu');
INSERT INTO `sadeDB`.`Directivos` (`idUsuario`, `cargo`, `direccion`, `emailPublico`) VALUES (514, 'Coordinador', 'Carrera 47 #14-5', 'directivo-514@sade.edu');
INSERT INTO `sadeDB`.`Directivos` (`idUsuario`, `cargo`, `direccion`, `emailPublico`) VALUES (515, 'Consejero', 'Calle 118 #1-82', 'directivo-515@sade.edu');
INSERT INTO `sadeDB`.`Directivos` (`idUsuario`, `cargo`, `direccion`, `emailPublico`) VALUES (516, 'Coordinador', 'Carrera 50 #56-48', 'directivo-516@sade.edu');
INSERT INTO `sadeDB`.`Directivos` (`idUsuario`, `cargo`, `direccion`, `emailPublico`) VALUES (517, 'Consejero', 'Carrera 4 #36-73', 'directivo-517@sade.edu');

COMMIT;


-- -----------------------------------------------------
-- Data for table `sadeDB`.`DocumentoIdentidad`
-- -----------------------------------------------------
START TRANSACTION;
USE `sadeDB`;
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (1, 'CC', '816320582', '1996-7-2', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (2, 'CC', '1574438854', '2008-9-6', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (3, 'CE', '56859622', '2003-12-14', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (4, 'CC', '466619021', '2004-8-22', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (5, 'RC', '1163520681', '1979-2-6', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (6, 'CC', '1733355893', '2003-9-8', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (7, 'TI', '78055967', '2014-8-8', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (8, 'RC', '781044154', '1983-7-20', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (9, 'CC', '237430749', '1999-9-7', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (10, 'CE', '1635965577', '1994-8-6', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (11, 'RC', '539883800', '1983-4-12', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (12, 'CE', '1287435161', '2008-4-20', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (13, 'CE', '1532082146', '1998-8-18', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (14, 'RC', '177461191', '2015-7-7', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (15, 'CC', '235772259', '1998-2-19', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (16, 'TI', '224618833', '2013-10-21', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (17, 'CC', '509208617', '2015-10-19', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (18, 'CC', '1962160791', '1998-8-22', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (19, 'RC', '1185576335', '2005-2-4', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (20, 'CC', '964504427', '2013-8-20', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (21, 'TI', '966083386', '1994-7-6', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (22, 'CE', '1264006517', '1983-2-1', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (23, 'CC', '875976726', '2001-12-18', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (24, 'CE', '184880469', '1982-8-24', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (25, 'RC', '627037852', '2006-10-11', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (26, 'RC', '207914358', '1995-11-20', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (27, 'CE', '802856869', '2002-12-5', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (28, 'CE', '323366109', '2008-11-13', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (29, 'CC', '1520218050', '2002-2-3', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (30, 'RC', '817767664', '1992-2-17', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (31, 'CE', '571481617', '2005-12-14', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (32, 'CE', '1132461454', '1982-10-27', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (33, 'CC', '914330214', '1995-1-20', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (34, 'CC', '446513734', '2000-3-21', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (35, 'TI', '812639525', '2010-6-25', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (36, 'RC', '1986660627', '2007-1-13', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (37, 'RC', '1603357242', '1982-5-25', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (38, 'CC', '1758096038', '2009-4-6', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (39, 'CE', '1977395991', '2000-5-5', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (40, 'CE', '517024206', '2003-6-2', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (41, 'TI', '107350558', '1988-2-23', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (42, 'CE', '1338075289', '1984-4-12', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (43, 'CC', '1674312075', '1986-4-5', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (44, 'RC', '1766272842', '2000-7-22', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (45, 'RC', '1708708980', '1985-2-9', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (46, 'CE', '1312461229', '1994-1-1', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (47, 'RC', '836655971', '1988-10-19', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (48, 'CE', '1823530260', '1980-2-6', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (49, 'CE', '1406839823', '1992-4-10', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (50, 'CE', '1416948630', '1994-10-2', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (51, 'TI', '1319427914', '1980-7-10', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (52, 'CC', '1493581669', '2009-2-20', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (53, 'CC', '641539629', '2012-11-25', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (54, 'RC', '650706004', '1998-8-26', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (55, 'RC', '331860341', '1998-3-23', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (56, 'CE', '245601231', '2002-9-17', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (57, 'CC', '863037837', '2003-5-2', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (58, 'TI', '909677545', '2006-8-13', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (59, 'CC', '837945194', '2001-1-10', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (60, 'CC', '135714330', '2011-7-2', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (61, 'RC', '540738405', '1994-10-23', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (62, 'CC', '1064021631', '1980-8-25', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (63, 'CC', '109918118', '2007-2-11', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (64, 'CC', '1521530268', '1999-5-25', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (65, 'RC', '1177004620', '1983-3-5', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (66, 'RC', '573840675', '1985-7-11', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (67, 'CC', '363558562', '1994-3-27', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (68, 'TI', '705140807', '2002-1-13', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (69, 'TI', '1903517254', '2006-6-9', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (70, 'TI', '1722582886', '2001-7-19', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (71, 'TI', '1204196055', '1996-11-7', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (72, 'CC', '1056287451', '2007-1-27', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (73, 'TI', '1347569391', '1998-10-22', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (74, 'TI', '1431754737', '2013-9-19', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (75, 'RC', '1316710690', '2015-1-26', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (76, 'TI', '1049190975', '2006-3-18', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (77, 'TI', '1163906332', '2005-8-10', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (78, 'TI', '595903312', '1990-2-13', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (79, 'RC', '364702562', '2008-8-8', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (80, 'CE', '28790012', '2010-12-28', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (81, 'TI', '1050319862', '2015-3-3', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (82, 'CE', '1203190519', '2006-7-28', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (83, 'CE', '1122632095', '1996-8-18', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (84, 'CE', '1354407602', '2005-12-28', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (85, 'TI', '1687830097', '2000-6-27', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (86, 'RC', '1548649382', '2013-3-18', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (87, 'TI', '619271725', '2013-9-1', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (88, 'RC', '682411459', '2015-11-25', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (89, 'CE', '329008868', '1989-4-17', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (90, 'CE', '1294397895', '1999-11-28', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (91, 'CE', '1516207244', '1991-1-10', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (92, 'RC', '1012581425', '1978-4-3', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (93, 'TI', '1115498013', '1992-4-24', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (94, 'CE', '1446477448', '1999-2-19', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (95, 'CE', '418261411', '2007-4-27', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (96, 'CE', '1974536240', '1993-2-22', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (97, 'TI', '1627883525', '1987-4-19', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (98, 'CC', '357707257', '1993-1-1', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (99, 'CC', '840196096', '1996-9-3', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (100, 'TI', '1988997642', '2009-12-4', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (101, 'CE', '1635962913', '2015-6-11', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (102, 'RC', '626845509', '2005-12-7', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (103, 'CC', '1325892091', '2009-12-22', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (104, 'TI', '1619377798', '2006-1-18', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (105, 'RC', '632987715', '1985-1-22', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (106, 'CE', '1402510015', '2005-12-20', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (107, 'CC', '578268229', '1994-7-21', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (108, 'CC', '448681258', '1981-10-6', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (109, 'CE', '1953846059', '1985-12-10', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (110, 'CE', '1791127442', '1995-3-18', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (111, 'RC', '1813986071', '2004-7-22', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (112, 'RC', '1679498476', '1995-10-10', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (113, 'RC', '1017191797', '2012-9-23', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (114, 'CE', '801937361', '2012-6-21', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (115, 'RC', '1313132153', '2003-3-10', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (116, 'CE', '1119050682', '1988-6-5', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (117, 'TI', '1878234134', '1993-10-18', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (118, 'TI', '1277548913', '1983-10-14', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (119, 'CC', '1273817682', '1997-4-4', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (120, 'RC', '1120038104', '1984-7-6', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (121, 'RC', '529338729', '2005-10-24', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (122, 'CE', '1275937623', '2005-1-3', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (123, 'CC', '315365305', '1978-5-14', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (124, 'CC', '338341786', '1984-7-18', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (125, 'CC', '421203274', '2001-4-11', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (126, 'CE', '1407659480', '1980-3-28', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (127, 'RC', '485255531', '2007-6-7', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (128, 'CC', '1773750153', '2013-1-4', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (129, 'CE', '1455488135', '1981-8-17', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (130, 'CC', '1759401565', '1995-1-24', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (131, 'CC', '1196402636', '1988-1-16', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (132, 'CE', '1560168266', '1978-7-5', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (133, 'TI', '1576249507', '2005-4-2', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (134, 'RC', '1795245490', '1982-5-27', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (135, 'CC', '1444760493', '1995-1-4', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (136, 'CE', '1247538143', '2010-3-21', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (137, 'RC', '1056908885', '1990-10-17', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (138, 'TI', '1577610578', '1982-11-16', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (139, 'CC', '1103476144', '2010-7-2', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (140, 'TI', '1122258243', '2012-4-14', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (141, 'CE', '778114739', '1985-1-19', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (142, 'CC', '1845247548', '1990-10-28', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (143, 'TI', '644823153', '2003-8-18', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (144, 'CE', '703937981', '2007-6-20', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (145, 'CE', '1716382452', '1990-1-16', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (146, 'CC', '1043373600', '2008-1-4', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (147, 'CE', '1114485507', '1997-9-9', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (148, 'CC', '1843667689', '2003-11-12', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (149, 'CC', '1642026490', '2007-7-20', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (150, 'CC', '749647983', '1999-2-3', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (151, 'CE', '1291654989', '1993-8-19', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (152, 'TI', '1922169092', '1982-7-8', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (153, 'TI', '1546396323', '1995-1-10', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (154, 'CC', '1620925460', '1987-11-5', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (155, 'CE', '1967935142', '1995-1-3', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (156, 'TI', '648104630', '2003-3-28', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (157, 'RC', '1690123119', '2015-4-10', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (158, 'CC', '81962928', '1993-11-25', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (159, 'CC', '1338156237', '2015-5-24', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (160, 'CC', '808179564', '1982-5-25', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (161, 'CE', '1609324315', '2006-1-17', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (162, 'CE', '1964473383', '2004-10-17', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (163, 'TI', '1939980446', '2009-10-13', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (164, 'RC', '106891573', '1997-12-4', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (165, 'CC', '445285425', '2002-7-9', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (166, 'TI', '39312961', '2011-11-25', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (167, 'TI', '1789051573', '1999-6-1', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (168, 'RC', '977558450', '1990-9-17', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (169, 'RC', '483315165', '1997-4-15', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (170, 'TI', '711390233', '2015-8-10', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (171, 'RC', '104657853', '2007-6-22', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (172, 'CE', '877393725', '1989-1-13', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (173, 'TI', '527219392', '2003-5-15', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (174, 'RC', '1456781352', '1987-1-13', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (175, 'RC', '1613606220', '2015-3-9', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (176, 'CC', '1666193445', '2014-9-27', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (177, 'TI', '1328355783', '1988-1-27', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (178, 'CC', '1184391317', '2003-6-10', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (179, 'CE', '455083072', '1992-6-19', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (180, 'RC', '1253011533', '1980-5-7', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (181, 'RC', '1720511137', '1985-7-1', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (182, 'TI', '1207973080', '2008-11-12', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (183, 'CE', '1888454682', '1978-2-10', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (184, 'CE', '1885646745', '1992-10-6', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (185, 'CE', '818226036', '1990-10-27', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (186, 'TI', '877704120', '2009-6-19', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (187, 'CC', '1224613285', '2014-7-1', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (188, 'TI', '1718426745', '2014-9-8', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (189, 'TI', '541163003', '2004-9-12', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (190, 'CC', '1679580054', '2014-2-19', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (191, 'CC', '1634848299', '2012-3-21', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (192, 'CC', '1338582400', '1984-2-28', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (193, 'CC', '1077933173', '2000-11-18', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (194, 'TI', '1997285160', '1986-10-13', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (195, 'RC', '330808520', '2003-10-14', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (196, 'CC', '1011606021', '2008-6-19', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (197, 'CE', '1711666939', '1994-11-28', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (198, 'TI', '951526872', '2001-1-7', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (199, 'CE', '305070941', '1985-2-27', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (200, 'TI', '182133325', '2005-9-4', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (201, 'CC', '1397707421', '1993-10-12', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (202, 'RC', '1338889331', '2007-11-28', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (203, 'CC', '627693935', '1996-6-19', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (204, 'CC', '719181055', '2000-5-12', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (205, 'TI', '261115722', '1979-5-1', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (206, 'CC', '1138047237', '2010-1-24', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (207, 'TI', '184309405', '2004-6-27', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (208, 'RC', '1972706873', '1997-6-12', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (209, 'CE', '804156014', '2001-7-18', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (210, 'CC', '1787762585', '2010-4-20', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (211, 'RC', '1483800067', '1985-10-23', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (212, 'CC', '1993318654', '2012-10-2', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (213, 'RC', '630348580', '1991-10-21', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (214, 'RC', '393032940', '2010-4-5', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (215, 'TI', '734722348', '1996-9-8', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (216, 'RC', '79422411', '2005-4-26', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (217, 'RC', '788576506', '2009-12-1', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (218, 'CE', '1145812795', '2007-1-4', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (219, 'CC', '422311751', '1999-3-24', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (220, 'RC', '333981342', '1988-5-21', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (221, 'CE', '1190207663', '2001-6-1', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (222, 'RC', '229901895', '2001-8-16', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (223, 'TI', '546607623', '1998-9-28', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (224, 'TI', '282687689', '1995-4-24', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (225, 'TI', '1411342863', '1986-1-13', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (226, 'CC', '700202853', '2011-6-25', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (227, 'CC', '66462554', '2011-10-12', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (228, 'CE', '1909058293', '1983-12-18', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (229, 'TI', '603627505', '1982-7-13', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (230, 'CC', '803199443', '1995-8-27', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (231, 'RC', '798034476', '1995-10-1', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (232, 'RC', '764654209', '1991-3-23', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (233, 'TI', '847685146', '1991-2-3', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (234, 'CE', '506384807', '2012-10-1', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (235, 'RC', '862281091', '2012-12-9', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (236, 'RC', '1488919815', '1979-10-28', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (237, 'RC', '1834712636', '2001-10-8', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (238, 'CC', '1654904057', '1987-5-19', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (239, 'CC', '1730372711', '1994-3-16', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (240, 'TI', '1765364441', '2001-7-28', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (241, 'TI', '672849104', '1986-8-25', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (242, 'CC', '618009521', '1995-9-22', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (243, 'CC', '49331362', '1992-5-23', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (244, 'RC', '181513004', '1980-8-16', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (245, 'RC', '760029293', '2004-7-18', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (246, 'RC', '480314235', '1978-3-15', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (247, 'RC', '573950204', '1991-2-24', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (248, 'RC', '86207446', '1980-8-14', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (249, 'CE', '1990285769', '1994-7-25', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (250, 'CE', '1835094052', '2011-9-25', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (251, 'CC', '355473401', '2005-4-25', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (252, 'CE', '1396845391', '1980-9-15', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (253, 'CE', '1982708031', '1993-1-12', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (254, 'CC', '677170512', '1993-3-3', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (255, 'TI', '1945936585', '2010-2-7', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (256, 'CC', '1750734483', '1990-6-1', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (257, 'RC', '1657999060', '1998-1-17', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (258, 'CC', '1445205786', '1983-10-20', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (259, 'RC', '1115215413', '2009-4-22', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (260, 'TI', '799995202', '1989-5-19', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (261, 'RC', '1222379088', '2012-8-5', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (262, 'CE', '1036594698', '1993-7-19', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (263, 'TI', '10036363', '2013-4-12', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (264, 'CC', '1052224679', '1979-7-17', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (265, 'CE', '1381293375', '2012-4-3', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (266, 'CC', '770884084', '1992-10-18', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (267, 'TI', '922997788', '1989-4-13', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (268, 'TI', '1894950421', '2012-5-17', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (269, 'CE', '1300720047', '1984-11-1', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (270, 'TI', '1876104901', '2003-12-26', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (271, 'CC', '692121114', '2008-3-20', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (272, 'RC', '1071200405', '1998-11-11', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (273, 'CE', '1520080107', '1995-5-7', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (274, 'CC', '782594287', '2011-6-27', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (275, 'CE', '1238256072', '2009-8-22', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (276, 'TI', '1710409333', '1997-4-26', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (277, 'RC', '11071728', '2013-5-5', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (278, 'RC', '1714051797', '1998-3-20', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (279, 'RC', '172175488', '2002-6-7', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (280, 'RC', '1307144695', '2000-6-19', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (281, 'CE', '327462206', '1993-1-8', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (282, 'RC', '651905851', '2014-8-25', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (283, 'RC', '1045947329', '2008-6-16', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (284, 'TI', '1753025479', '2012-1-24', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (285, 'RC', '695308118', '2000-9-22', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (286, 'TI', '1068252191', '1997-10-23', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (287, 'CE', '959004216', '1993-11-19', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (288, 'CC', '1590947820', '1999-7-2', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (289, 'CC', '966968921', '1986-12-17', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (290, 'CC', '650525019', '2014-3-15', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (291, 'CE', '1004735090', '2014-3-20', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (292, 'TI', '498721312', '1997-2-3', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (293, 'TI', '1453728076', '2006-7-22', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (294, 'CE', '722288844', '1979-9-24', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (295, 'RC', '1047677848', '1992-12-20', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (296, 'RC', '969027529', '1984-1-8', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (297, 'CC', '314652530', '1997-10-28', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (298, 'RC', '446841367', '2009-8-18', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (299, 'TI', '446223186', '2002-5-6', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (300, 'CC', '252760231', '2012-4-4', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (301, 'CE', '422156824', '2013-9-2', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (302, 'RC', '1482220608', '1997-3-1', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (303, 'CC', '11021003', '1991-3-13', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (304, 'TI', '633162304', '1985-1-15', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (305, 'RC', '34183780', '1989-8-4', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (306, 'CE', '1439662804', '1992-5-5', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (307, 'CE', '211324221', '1990-2-7', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (308, 'CC', '1323130356', '1999-10-9', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (309, 'CE', '1130426590', '2012-6-13', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (310, 'TI', '157327030', '1996-10-4', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (311, 'CC', '186475984', '1983-5-19', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (312, 'RC', '293088202', '1999-12-23', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (313, 'CE', '1356453286', '2014-9-12', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (314, 'CC', '1722450358', '2009-10-27', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (315, 'TI', '738299969', '1996-12-8', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (316, 'CE', '622477785', '1984-3-21', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (317, 'RC', '1855372205', '2000-6-5', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (318, 'CE', '1410198851', '1980-9-11', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (319, 'RC', '1954419962', '1993-2-14', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (320, 'RC', '45173788', '1980-4-24', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (321, 'CC', '1399121629', '2013-11-1', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (322, 'CC', '238073664', '1993-6-23', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (323, 'TI', '1013154535', '1978-11-4', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (324, 'RC', '1536618545', '2000-5-26', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (325, 'RC', '550869923', '1998-12-8', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (326, 'TI', '1364218964', '2009-5-6', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (327, 'CE', '1116051874', '1983-3-9', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (328, 'RC', '1012751789', '1991-4-10', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (329, 'TI', '837054074', '2014-6-3', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (330, 'CC', '1841109856', '1983-10-6', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (331, 'TI', '1426455745', '2005-11-3', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (332, 'CC', '757671135', '2007-12-9', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (333, 'CC', '1540229088', '2015-4-20', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (334, 'CE', '1061682255', '2014-8-5', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (335, 'TI', '918445444', '2008-8-9', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (336, 'RC', '1795747084', '2014-8-7', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (337, 'TI', '217053687', '2000-1-11', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (338, 'CC', '1143999945', '1978-11-14', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (339, 'TI', '1366027138', '1980-4-7', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (340, 'RC', '1421070963', '1991-7-22', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (341, 'RC', '1472587683', '1979-2-22', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (342, 'RC', '185257788', '1995-1-21', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (343, 'CC', '70987231', '1988-1-17', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (344, 'RC', '1621925435', '1981-10-21', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (345, 'TI', '1532840402', '2007-6-27', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (346, 'RC', '650344646', '1984-7-10', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (347, 'TI', '1784932640', '2001-11-8', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (348, 'CC', '1944373351', '2012-8-16', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (349, 'TI', '1855019538', '2004-6-28', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (350, 'CE', '369087588', '1996-4-23', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (351, 'CE', '874481546', '2010-9-9', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (352, 'CC', '1636421692', '1989-7-7', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (353, 'CE', '1625411744', '2008-5-26', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (354, 'CC', '508138921', '1993-6-18', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (355, 'TI', '1903697535', '1988-9-24', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (356, 'CC', '721918902', '2015-4-12', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (357, 'CC', '1339353806', '1985-2-10', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (358, 'RC', '388583839', '2008-10-24', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (359, 'CC', '859639688', '1992-8-19', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (360, 'RC', '1478800847', '1990-5-11', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (361, 'RC', '1391978742', '2009-8-13', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (362, 'CC', '1737611533', '2000-7-9', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (363, 'CC', '1511881678', '1990-9-14', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (364, 'TI', '614134665', '2015-12-5', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (365, 'TI', '263765485', '1996-9-4', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (366, 'CC', '1500707969', '1996-4-23', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (367, 'CC', '1473164042', '1993-6-19', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (368, 'CE', '923598188', '2005-11-18', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (369, 'CC', '640368307', '1996-8-6', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (370, 'TI', '735145799', '2009-7-23', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (371, 'CC', '1849326246', '1997-9-10', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (372, 'CE', '1763114458', '1982-9-6', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (373, 'TI', '499960311', '2014-10-20', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (374, 'TI', '1167554446', '1986-9-12', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (375, 'CC', '393604523', '1990-4-27', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (376, 'CE', '1265286688', '1982-8-10', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (377, 'RC', '1384352208', '1984-6-27', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (378, 'RC', '90902051', '2008-7-1', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (379, 'TI', '854462826', '2011-11-5', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (380, 'TI', '434438662', '1978-10-5', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (381, 'CE', '1439281345', '1984-12-24', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (382, 'CE', '668803409', '2011-2-21', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (383, 'RC', '1805658530', '1986-7-17', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (384, 'RC', '839682138', '2012-5-26', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (385, 'CC', '767952915', '2000-11-19', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (386, 'TI', '1332054483', '2003-9-27', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (387, 'CC', '470393260', '1997-8-17', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (388, 'CE', '1801023240', '1982-6-5', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (389, 'RC', '158645933', '2002-12-15', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (390, 'CE', '274433391', '1983-11-24', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (391, 'TI', '227514544', '1983-9-5', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (392, 'RC', '11255014', '1989-5-5', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (393, 'TI', '1057092407', '1989-9-10', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (394, 'RC', '1439324328', '1978-4-3', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (395, 'CC', '1110218382', '1980-6-5', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (396, 'RC', '1993050100', '2010-9-22', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (397, 'CC', '1534169723', '1978-5-2', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (398, 'CE', '1241632584', '1985-12-1', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (399, 'CC', '781217162', '1988-6-23', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (400, 'RC', '1423275225', '2009-11-10', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (401, 'TI', '832824150', '2011-3-4', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (402, 'RC', '1655054022', '1981-5-3', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (403, 'CC', '1694507126', '2013-9-1', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (404, 'CE', '1848959510', '1993-9-28', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (405, 'TI', '932799502', '2006-6-16', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (406, 'CE', '1716366316', '1993-6-17', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (407, 'RC', '1028785372', '2008-12-17', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (408, 'RC', '512965539', '1980-11-28', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (409, 'CE', '714596443', '2000-7-2', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (410, 'RC', '1242416032', '1984-1-4', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (411, 'CC', '1409883731', '2003-7-10', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (412, 'CE', '1712684251', '1992-12-4', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (413, 'CE', '377135627', '2008-2-6', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (414, 'TI', '1145276271', '1995-12-28', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (415, 'RC', '1828572954', '1991-4-25', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (416, 'CC', '693460871', '1988-9-10', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (417, 'CE', '1500162631', '1980-2-15', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (418, 'CC', '787439128', '2003-2-9', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (419, 'TI', '1330177247', '1979-5-12', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (420, 'CE', '607846351', '2011-10-20', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (421, 'CE', '1593297852', '2013-10-1', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (422, 'TI', '677236120', '1995-3-24', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (423, 'TI', '1581755664', '1992-9-14', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (424, 'CC', '323678907', '1997-6-12', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (425, 'CE', '1325598181', '1992-7-3', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (426, 'TI', '1445951539', '1982-5-1', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (427, 'TI', '1434137890', '2015-12-18', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (428, 'RC', '72545110', '2015-10-14', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (429, 'TI', '658845326', '1994-6-11', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (430, 'CE', '1005842683', '2000-4-17', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (431, 'CC', '1094073584', '1989-2-4', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (432, 'CE', '1530469517', '1979-4-15', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (433, 'CE', '729360689', '2013-5-17', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (434, 'CC', '891648854', '2007-1-2', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (435, 'TI', '819518648', '2005-1-2', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (436, 'RC', '1849965995', '1982-9-21', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (437, 'CE', '1955204917', '1984-7-11', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (438, 'TI', '202615587', '1995-2-21', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (439, 'RC', '928480841', '1981-1-28', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (440, 'CE', '552617671', '2007-7-6', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (441, 'RC', '1864925300', '1988-4-10', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (442, 'TI', '1265902012', '1987-2-24', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (443, 'CE', '1156769078', '2015-2-17', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (444, 'TI', '924209335', '2002-3-28', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (445, 'CC', '1487908805', '1989-12-10', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (446, 'RC', '511060405', '1983-6-1', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (447, 'CE', '352809068', '1997-5-11', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (448, 'RC', '1753136118', '2008-5-3', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (449, 'CC', '1277354610', '1997-12-24', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (450, 'TI', '548931675', '2013-7-25', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (451, 'CC', '1515899502', '1985-12-6', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (452, 'RC', '370889493', '1980-11-6', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (453, 'CC', '263382842', '2011-8-23', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (454, 'RC', '1780571318', '1999-6-8', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (455, 'CE', '1696158049', '1985-1-7', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (456, 'CE', '1591208206', '1994-2-8', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (457, 'RC', '1495656986', '1992-12-27', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (458, 'CC', '1016750406', '1995-5-9', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (459, 'RC', '597852336', '1988-6-10', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (460, 'CC', '1296913855', '1997-11-3', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (461, 'CE', '1771296807', '1983-2-11', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (462, 'RC', '1611704336', '1986-3-28', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (463, 'CE', '540859806', '2007-8-20', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (464, 'CC', '1505626685', '1981-6-2', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (465, 'CE', '1107772729', '2008-5-27', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (466, 'RC', '1903240520', '1979-4-22', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (467, 'TI', '357698085', '2006-9-11', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (468, 'TI', '367063427', '2015-10-2', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (469, 'CC', '448993178', '1986-10-24', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (470, 'CC', '925459842', '1991-3-21', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (471, 'CE', '893935500', '2006-8-11', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (472, 'CC', '1591392436', '1990-4-17', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (473, 'RC', '524315065', '1993-1-14', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (474, 'RC', '1202035240', '1978-1-28', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (475, 'RC', '1499077412', '1986-1-1', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (476, 'CE', '1449644119', '1981-6-18', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (477, 'CE', '1999086365', '2006-2-4', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (478, 'RC', '70902180', '1996-10-24', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (479, 'TI', '102374251', '1979-10-17', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (480, 'CC', '1010893806', '1997-2-9', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (481, 'CC', '1367766258', '2001-9-20', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (482, 'TI', '1875761241', '2008-11-25', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (483, 'CC', '559170801', '2015-5-24', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (484, 'RC', '148827520', '1985-4-13', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (485, 'CC', '526003424', '2009-10-5', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (486, 'CE', '1885329275', '1994-5-4', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (487, 'CC', '1093663683', '1989-8-4', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (488, 'CE', '1038902537', '2000-8-9', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (489, 'RC', '339174397', '2015-4-23', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (490, 'CE', '1366621753', '1987-5-17', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (491, 'TI', '1256018143', '2014-11-28', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (492, 'CE', '1150642715', '1984-4-1', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (493, 'CC', '1539536026', '1994-5-20', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (494, 'TI', '1099865127', '1986-2-26', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (495, 'RC', '1369575731', '2015-9-16', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (496, 'CC', '1562543380', '1992-8-8', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (497, 'TI', '386703180', '1997-7-7', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (498, 'CE', '762346424', '2006-9-8', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (499, 'TI', '75947407', '1987-11-26', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (500, 'CC', '1008076302', '2015-9-21', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (501, 'RC', '369209453', '2005-1-4', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (502, 'CE', '1920512227', '1982-12-25', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (503, 'CE', '1139150320', '1996-5-25', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (504, 'CE', '1594971436', '1984-1-23', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (505, 'RC', '1609980856', '2000-2-28', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (506, 'CE', '383858516', '1979-10-8', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (507, 'CE', '1728121915', '1990-3-17', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (508, 'CE', '602194081', '2015-2-4', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (509, 'TI', '884240383', '2012-7-22', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (510, 'CC', '1155028684', '1993-4-19', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (511, 'TI', '1215315891', '1998-3-16', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (512, 'RC', '126839729', '2004-3-9', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (513, 'RC', '1635572688', '1979-7-8', 'Pitalito - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (514, 'TI', '1837799065', '2000-10-14', 'Campoalegre - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (515, 'RC', '605579060', '1990-10-15', 'Neiva - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (516, 'CC', '776609431', '2004-8-3', 'Rivera - Huila');
INSERT INTO `sadeDB`.`DocumentoIdentidad` (`idUsuario`, `tipoDocumento`, `numero`, `fechaExpedicion`, `lugarExpedicion`) VALUES (517, 'CC', '1082378753', '1986-5-7', 'Neiva - Huila');

COMMIT;


-- -----------------------------------------------------
-- Data for table `sadeDB`.`Telefono`
-- -----------------------------------------------------
START TRANSACTION;
USE `sadeDB`;
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 1, '3222210730');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 2, '3168632288');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 3, '3110001322');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 4, '3156667274');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 5, '3160203330');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 6, '3116832340');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 7, '3201120638');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 8, '3153461147');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 9, '3104199485');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 10, '3102014399');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 11, '3119974871');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 12, '3168397132');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 13, '3157057242');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 14, '3210313841');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 15, '3130752894');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 16, '3154162768');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 17, '3113728467');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 18, '3192258606');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 19, '3183517217');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 20, '3101140777');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 21, '3147607941');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 22, '3211942367');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 23, '3196715656');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 24, '3206471850');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 25, '3126880031');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 26, '3172023004');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 27, '3194202451');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 28, '3110265964');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 29, '3223225257');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 30, '3112109759');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 31, '3154049991');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 32, '3165787936');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 33, '3165457367');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 34, '3224141536');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 35, '3216835148');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 36, '3187797164');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 37, '3131323682');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 38, '3194532834');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 39, '3154946766');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 40, '3163271967');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 41, '3147775911');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 42, '3140215341');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 43, '3212945910');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 44, '3154697679');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 45, '3147897503');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 46, '3191170436');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 47, '3132486240');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 48, '3144770247');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 49, '3167734979');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 50, '3197290786');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 51, '3150683540');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 52, '3193434225');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 53, '3199848846');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 54, '3140719855');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 55, '3157103542');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 56, '3219958661');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 57, '3131783593');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 58, '3221710503');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 59, '3150249351');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 60, '3147880885');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 61, '3115154454');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 62, '3113079533');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 63, '3170508555');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 64, '3106794270');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 65, '3199970228');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 66, '3178473126');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 67, '3211669367');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 68, '3127793657');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 69, '3140695932');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 70, '3112554940');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 71, '3159711083');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 72, '3202718147');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 73, '3186593140');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 74, '3185656387');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 75, '3203890272');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 76, '3134206726');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 77, '3220355795');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 78, '3155547455');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 79, '3174148085');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 80, '3194490427');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 81, '3205557641');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 82, '3195356063');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 83, '3124989388');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 84, '3162562318');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 85, '3151614530');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 86, '3103386475');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 87, '3155133622');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 88, '3138414653');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 89, '3118987455');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 90, '3141592561');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 91, '3109870624');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 92, '3210675217');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 93, '3159391729');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 94, '3173801342');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 95, '3117408320');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 96, '3189792284');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 97, '3186121508');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 98, '3190503559');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 99, '3192209208');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 100, '3201844979');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 101, '3145748793');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 102, '3215819407');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 103, '3228352804');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 104, '3157382227');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 105, '3201741155');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 106, '3184217756');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 107, '3139575993');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 108, '3212942401');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 109, '3129686103');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 110, '3141320776');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 111, '3118136364');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 112, '3228636573');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 113, '3223508932');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 114, '3107252523');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 115, '3168974181');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 116, '3210123389');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 117, '3149037110');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 118, '3172947589');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 119, '3147189350');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 120, '3100417457');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 121, '3109241173');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 122, '3150272235');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 123, '3152348493');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 124, '3217997522');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 125, '3127987119');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 126, '3167809659');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 127, '3104175556');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 128, '3206835660');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 129, '3151739550');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 130, '3223203107');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 131, '3175445912');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 132, '3190364234');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 133, '3139770514');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 134, '3169729487');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 135, '3203637562');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 136, '3126880933');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 137, '3142718012');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 138, '3123387730');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 139, '3118328463');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 140, '3178236193');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 141, '3213512817');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 142, '3109147450');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 143, '3216394503');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 144, '3108685725');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 145, '3124896443');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 146, '3113315427');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 147, '3191411293');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 148, '3192963701');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 149, '3165797217');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 150, '3115210955');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 151, '3195164402');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 152, '3182631616');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 153, '3105541440');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 154, '3147102271');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 155, '3120414813');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 156, '3175197702');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 157, '3111513156');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 158, '3151698312');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 159, '3111562417');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 160, '3227590494');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 161, '3185800711');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 162, '3140914339');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 163, '3173226584');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 164, '3111762274');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 165, '3138599185');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 166, '3163418182');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 167, '3200696772');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 168, '3158591315');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 169, '3102455519');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 170, '3118427804');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 171, '3160284798');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 172, '3208588922');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 173, '3181466263');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 174, '3194208858');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 175, '3124464010');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 176, '3215106472');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 177, '3163683636');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 178, '3226940612');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 179, '3100267136');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 180, '3107386143');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 181, '3179896072');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 182, '3225397422');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 183, '3220098774');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 184, '3164225704');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 185, '3127095276');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 186, '3229132473');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 187, '3228883660');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 188, '3136905162');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 189, '3128879409');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 190, '3188377393');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 191, '3167373514');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 192, '3116995274');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 193, '3224137959');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 194, '3140525924');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 195, '3163395530');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 196, '3147966770');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 197, '3116251899');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 198, '3154853772');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 199, '3169744247');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 200, '3155495363');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 201, '3161090733');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 202, '3204970798');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 203, '3222339310');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 204, '3176603302');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 205, '3101313483');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 206, '3219768724');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 207, '3180006625');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 208, '3178834504');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 209, '3164886672');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 210, '3137171678');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 211, '3168488028');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 212, '3215042147');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 213, '3176826506');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 214, '3136788150');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 215, '3135058500');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 216, '3217478318');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 217, '3128485337');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 218, '3209131365');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 219, '3149865861');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 220, '3147049984');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 221, '3198234573');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 222, '3132206993');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 223, '3226738874');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 224, '3222127119');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 225, '3219041926');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 226, '3138209859');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 227, '3127590722');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 228, '3192924428');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 229, '3185772875');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 230, '3149260621');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 231, '3150906077');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 232, '3211220824');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 233, '3198697913');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 234, '3171949009');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 235, '3132582020');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 236, '3182313079');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 237, '3222900927');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 238, '3214591702');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 239, '3197900044');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 240, '3202087978');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 241, '3172378961');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 242, '3195173119');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 243, '3199564238');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 244, '3168628054');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 245, '3229239628');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 246, '3130740935');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 247, '3187883305');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 248, '3220240409');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 249, '3224277955');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 250, '3141291217');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 251, '3159489013');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 252, '3119021211');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 253, '3187306272');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 254, '3211108926');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 255, '3221240607');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 256, '3126578809');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 257, '3111099411');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 258, '3133140656');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 259, '3174836746');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 260, '3137564342');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 261, '3229142685');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 262, '3172924708');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 263, '3145524759');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 264, '3109077091');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 265, '3153009997');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 266, '3128699591');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 267, '3220810795');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 268, '3151457557');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 269, '3116533980');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 270, '3157524118');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 271, '3164192320');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 272, '3134978412');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 273, '3136718097');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 274, '3200639536');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 275, '3120156659');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 276, '3134898709');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 277, '3124277125');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 278, '3160535400');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 279, '3106305749');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 280, '3150579447');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 281, '3180285711');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 282, '3168433225');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 283, '3222037129');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 284, '3104127010');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 285, '3153886846');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 286, '3144324149');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 287, '3209314641');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 288, '3142175640');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 289, '3142371816');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 290, '3146603507');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 291, '3195002358');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 292, '3139354761');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 293, '3123357754');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 294, '3202215888');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 295, '3154878478');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 296, '3118398709');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 297, '3185193211');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 298, '3137250706');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 299, '3141683652');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 300, '3119725994');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 301, '3187207691');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 302, '3102856407');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 303, '3108285366');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 304, '3213334045');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 305, '3227946747');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 306, '3111865674');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 307, '3174609738');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 308, '3183898496');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 309, '3215797639');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 310, '3119946754');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 311, '3128609938');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 312, '3154830672');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 313, '3158968868');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 314, '3155912222');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 315, '3102463918');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 316, '3199084677');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 317, '3154321403');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 318, '3200241732');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 319, '3207836837');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 320, '3196630269');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 321, '3144596939');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 322, '3225292721');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 323, '3173147143');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 324, '3125795748');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 325, '3192991305');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 326, '3211549791');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 327, '3211332307');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 328, '3226883921');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 329, '3193047618');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 330, '3164165623');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 331, '3175908831');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 332, '3201288467');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 333, '3180668664');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 334, '3102523367');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 335, '3112934476');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 336, '3169422056');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 337, '3137778222');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 338, '3217780175');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 339, '3227585590');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 340, '3223253512');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 341, '3137964789');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 342, '3208138941');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 343, '3137508106');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 344, '3136852248');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 345, '3167762169');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 346, '3205016381');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 347, '3154083084');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 348, '3218763813');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 349, '3219310047');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 350, '3198475244');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 351, '3180880012');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 352, '3166117858');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 353, '3175691572');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 354, '3115476062');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 355, '3134197501');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 356, '3127668262');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 357, '3219615525');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 358, '3196575047');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 359, '3128236865');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 360, '3161846985');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 361, '3193700816');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 362, '3165958506');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 363, '3204807118');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 364, '3118501306');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 365, '3226216753');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 366, '3167449009');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 367, '3184468472');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 368, '3161833281');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 369, '3115106611');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 370, '3126035507');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 371, '3220528554');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 372, '3188039096');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 373, '3225962249');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 374, '3144581760');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 375, '3128270359');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 376, '3205102957');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 377, '3100826662');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 378, '3176126742');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 379, '3142731840');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 380, '3153099743');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 381, '3175623988');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 382, '3169730827');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 383, '3146283979');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 384, '3176599340');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 385, '3192204202');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 386, '3199949366');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 387, '3177364177');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 388, '3195302357');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 389, '3135872964');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 390, '3160815845');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 391, '3114972088');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 392, '3108405163');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 393, '3156390723');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 394, '3200500206');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 395, '3182714620');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 396, '3156038093');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 397, '3115100643');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 398, '3133758155');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 399, '3106714710');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 400, '3129404840');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 401, '3187278743');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 402, '3178522614');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 403, '3222838022');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 404, '3193076698');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 405, '3180298267');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 406, '3119376474');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 407, '3195994170');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 408, '3145667585');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 409, '3100495077');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 410, '3128581935');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 411, '3135259056');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 412, '3124979325');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 413, '3195041088');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 414, '3141806673');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 415, '3220713111');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 416, '3127845420');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 417, '3118081325');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 418, '3200204277');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 419, '3134326473');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 420, '3185407752');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 421, '3200733509');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 422, '3155752407');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 423, '3184179002');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 424, '3160257697');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 425, '3102496838');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 426, '3165974940');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 427, '3107227312');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 428, '3140989059');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 429, '3118389419');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 430, '3218566725');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 431, '3131654296');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 432, '3158169150');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 433, '3141093942');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 434, '3109379190');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 435, '3147480497');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 436, '3114415985');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 437, '3175772108');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 438, '3150472455');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 439, '3171666471');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 440, '3178152584');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 441, '3192266826');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 442, '3222804935');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 443, '3114322280');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 444, '3145184937');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 445, '3102987364');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 446, '3156757802');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 447, '3156572303');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 448, '3164557571');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 449, '3112809675');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 450, '3152661288');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 451, '3179009510');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 452, '3202813145');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 453, '3110175329');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 454, '3224106964');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 455, '3138629207');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 456, '3146188680');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 457, '3133203021');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 458, '3153341555');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 459, '3105625324');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 460, '3189559239');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 461, '3215224038');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 462, '3201974963');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 463, '3206193656');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 464, '3225080469');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 465, '3146654074');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 466, '3114857385');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 467, '3117319265');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 468, '3216445543');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 469, '3131087971');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 470, '3212131663');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 471, '3152058079');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 472, '3114629906');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 473, '3160947318');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 474, '3128211726');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 475, '3107608829');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 476, '3116863922');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 477, '3206637948');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 478, '3157518740');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 479, '3199500564');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 480, '3142910861');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 481, '3105959840');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 482, '3137448932');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 483, '3108337547');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 484, '3172240433');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 485, '3133860161');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 486, '3225800183');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 487, '3118815847');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 488, '3113526925');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 489, '3101116403');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 490, '3123022207');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 491, '3131009438');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 492, '3206667360');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 493, '3178701221');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 494, '3135674190');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 495, '3162947334');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 496, '3220785831');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 497, '3124557514');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 498, '3176417232');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 499, '3181865392');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 500, '3120321833');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 501, '3207728078');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 502, '3223906112');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 503, '3151548249');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 504, '3158191446');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 505, '3183494835');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 506, '3138987438');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 507, '3146131299');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 508, '3180180638');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 509, '3171903459');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 510, '3182281157');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 511, '3116758068');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 512, '3151428430');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 513, '3175695125');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 514, '3171694526');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 515, '3171296980');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 516, '3111016646');
INSERT INTO `sadeDB`.`Telefono` (`idTelefono`, `idUsuario`, `telefono`) VALUES (DEFAULT, 517, '3199909184');

COMMIT;


-- -----------------------------------------------------
-- Data for table `sadeDB`.`GruposDocentes`
-- -----------------------------------------------------
START TRANSACTION;
USE `sadeDB`;
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (1003, 480);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (1003, 481);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (803, 482);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (402, 483);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (1101, 484);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (403, 485);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (601, 486);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (701, 487);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (801, 488);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (1103, 489);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (603, 490);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (802, 491);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (503, 492);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (603, 493);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (903, 494);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (503, 495);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (1003, 496);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (601, 497);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (802, 498);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (502, 499);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (402, 500);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (602, 501);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (1002, 502);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (703, 503);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (1002, 504);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (802, 505);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (603, 506);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (1001, 507);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (902, 508);
INSERT INTO `sadeDB`.`GruposDocentes` (`idGrupo`, `idDocente`) VALUES (1001, 509);

COMMIT;


-- -----------------------------------------------------
-- Data for table `sadeDB`.`Privacidad`
-- -----------------------------------------------------
START TRANSACTION;
USE `sadeDB`;
INSERT INTO `sadeDB`.`Privacidad` (`idPrivacidad`, `publico`, `directivos`, `docentes`, `estudiantes`) VALUES (DEFAULT, 1, 1, 1, 1);
INSERT INTO `sadeDB`.`Privacidad` (`idPrivacidad`, `publico`, `directivos`, `docentes`, `estudiantes`) VALUES (DEFAULT, 0, 1, 0, 0);
INSERT INTO `sadeDB`.`Privacidad` (`idPrivacidad`, `publico`, `directivos`, `docentes`, `estudiantes`) VALUES (DEFAULT, 0, 0, 1, 0);
INSERT INTO `sadeDB`.`Privacidad` (`idPrivacidad`, `publico`, `directivos`, `docentes`, `estudiantes`) VALUES (DEFAULT, 0, 0, 0, 1);
INSERT INTO `sadeDB`.`Privacidad` (`idPrivacidad`, `publico`, `directivos`, `docentes`, `estudiantes`) VALUES (DEFAULT, 0, 1, 1, 0);
INSERT INTO `sadeDB`.`Privacidad` (`idPrivacidad`, `publico`, `directivos`, `docentes`, `estudiantes`) VALUES (DEFAULT, 0, 0, 1, 1);
INSERT INTO `sadeDB`.`Privacidad` (`idPrivacidad`, `publico`, `directivos`, `docentes`, `estudiantes`) VALUES (DEFAULT, 0, 1, 0, 1);
INSERT INTO `sadeDB`.`Privacidad` (`idPrivacidad`, `publico`, `directivos`, `docentes`, `estudiantes`) VALUES (DEFAULT, 0, 1, 1, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `sadeDB`.`Publicaciones`
-- -----------------------------------------------------
START TRANSACTION;
USE `sadeDB`;
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Titulo-0', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 6:14:2', 383, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Titulo-1', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 21:16:38', 322, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Titulo-2', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 18:10:46', 426, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Titulo-3', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 15:0:44', 471, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Vivamus molestie felis eu orci ultricies, sit amet tempus nunc interdum. Pellentesque iaculis efficitur quam, ac vestibulum mauris hendrerit non-4', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 10:23:51', 462, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Vivamus molestie felis eu orci ultricies, sit amet tempus nunc interdum. Pellentesque iaculis efficitur quam, ac vestibulum mauris hendrerit non-5', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 15:4:3', 472, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit-6', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 2:49:8', 498, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Titulo-7', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 1:3:2', 408, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Vivamus molestie felis eu orci ultricies, sit amet tempus nunc interdum. Pellentesque iaculis efficitur quam, ac vestibulum mauris hendrerit non-8', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 6:28:33', 81, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit-9', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 7:29:11', 490, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Titulo-10', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 2:5:50', 142, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit-11', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 12:13:33', 436, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Titulo-12', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 16:6:37', 37, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Titulo-13', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 7:17:20', 27, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit-14', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 21:15:39', 252, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Titulo-15', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 13:41:54', 123, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Vivamus molestie felis eu orci ultricies, sit amet tempus nunc interdum. Pellentesque iaculis efficitur quam, ac vestibulum mauris hendrerit non-16', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 9:49:13', 132, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit-17', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 15:39:32', 486, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit-18', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 4:38:25', 314, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit-19', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 21:10:52', 145, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Vivamus molestie felis eu orci ultricies, sit amet tempus nunc interdum. Pellentesque iaculis efficitur quam, ac vestibulum mauris hendrerit non-20', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 6:27:24', 115, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit-21', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 2:11:27', 7, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Vivamus molestie felis eu orci ultricies, sit amet tempus nunc interdum. Pellentesque iaculis efficitur quam, ac vestibulum mauris hendrerit non-22', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 17:9:28', 150, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Vivamus molestie felis eu orci ultricies, sit amet tempus nunc interdum. Pellentesque iaculis efficitur quam, ac vestibulum mauris hendrerit non-23', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 8:59:44', 408, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Titulo-24', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 18:20:10', 135, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Vivamus molestie felis eu orci ultricies, sit amet tempus nunc interdum. Pellentesque iaculis efficitur quam, ac vestibulum mauris hendrerit non-25', 'Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.', '1986-5-7 15:38:24', 139, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Titulo-26', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 19:11:9', 126, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Vivamus molestie felis eu orci ultricies, sit amet tempus nunc interdum. Pellentesque iaculis efficitur quam, ac vestibulum mauris hendrerit non-27', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 11:11:14', 63, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Vivamus molestie felis eu orci ultricies, sit amet tempus nunc interdum. Pellentesque iaculis efficitur quam, ac vestibulum mauris hendrerit non-28', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 9:40:51', 247, DEFAULT);
INSERT INTO `sadeDB`.`Publicaciones` (`idPublicacion`, `titulo`, `contenido`, `fecha`, `idUsuario`, `idPrivacidad`) VALUES (DEFAULT, 'Vivamus molestie felis eu orci ultricies, sit amet tempus nunc interdum. Pellentesque iaculis efficitur quam, ac vestibulum mauris hendrerit non-29', 'Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ', '1986-5-7 11:44:31', 444, DEFAULT);

COMMIT;

