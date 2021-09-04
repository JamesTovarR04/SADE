<p align="center"><a href="https://github.com/JamesTovarR04/SADE" target="_blank"><img src="https://github.com/JamesTovarR04/SADE/blob/main/documentation/logo/Image/Recurso%202.png" width="300"></a></p>

## About SADE

SADE es una plataforma web para escuelas y colegios que permite registrar usuarios, realizar publicaciones y eventos. Actualmente está desarrollado en el backend como servicio REST con sistema de autenticación por cookies y tokes con [laravel 8](https://laravel.com/) y el gestor de base de datos [MySQL](https://www.mysql.com/). El frontend se encuntra desarrollado como una SPA con [ReactJS](https://es.reactjs.org/).

### Usuarios Disponibles

- Directivos
- Profesores
- Estudiantes

### Funcionalidades

- Registro y control de usuarios
- Administracion de grupos (grados)
- Publicaciones
- Cronograma de eventos

## Instalar y correr (Local)

### Requerido

- [**PHP** *^7.3.0*](https://www.php.net/manual/es/index.php).
- [**MySQL** *^8.0*](https://www.mysql.com/downloads/).
- [**Composer**](https://getcomposer.org/download/).
- [**Git**](https://git-scm.com/downloads).

### Instalar

#### Clonar el Repositorio de git

```shell
git clone https://github.com/JamesTovarR04/SADE.git
```

- Moverse a la carpeta del proyecto:

```shell
cd SADE
```

#### Descargar las dependencias

```shell
composer install
```

#### Configurar Entorno
La configuración del entorno se hace en el archivo .env pero esé archivo no se puede versionar según las restricciones del archivo .gitignore, igualmente en el proyecto hay un archivo de ejemplo .env.example debes copiarlo con el siguiente comando:

```shell
cp .env.example .env
```

Luego es necesario modificar los valores de las variables de entorno para adecuar la configuración a nuestro entorno de desarrollo, por ejemplo los parámetros de **conexión a la base de datos**.

```shell
DB_USERNAME_DIREC=sade-directivo
DB_PASSWORD_DIREC=

DB_USERNAME_PROF=sade-profesor
DB_PASSWORD_PROF=

DB_USERNAME_ESTUD=sade-estudiante
DB_PASSWORD_ESTUD=

DB_USERNAME_PUBLIC=sade-publico
DB_PASSWORD_PUBLIC=
```

**Nota:** la contraseña de los usuarios por defecto al momento de crear la base de datos es '1234'.

#### Generar Clave de Seguridad de la Aplicación

```shell
php artisan key:generate
```

#### Crear la Base de Datos (Solo MySQL)
Para crear la base de datos puede ejecutar el archivo [sadeDB.sql](https://github.com/JamesTovarR04/SADE/blob/main/documentation/database/sadeDB.sql) que se encuentra en la carpeta **documentation/database** o realizar un 'Forward Engineering' con la herramienta MySQL Workbench usando el archivo [SADEDB.mwb](https://github.com/JamesTovarR04/SADE/blob/main/documentation/database/SADEDB.mwb) que se encuentra en la misma carpeta.

#### Correr
Una vez configurada la aplicación, puede iniciar el servidor de desarrollo **local** de Laravel utilizando el comando serve de Artisan CLI:

```shell
php artisan serve
```

## Developers
Para contribuir al desarrollo del proyecto lea la [guia de desarrollo](https://github.com/JamesTovarR04/SADE/blob/main/DEVELOP.md).

### Principales desarrolladores

- [James Tovar Rodriguez](https://github.com/JamesTovarR04)
- [Duvan Chavarro](https://github.com/DuvanChavarro13)
- [Jose Ortiz Rodriguez](https://github.com/jodaor)
- [Juan Bolivar Dussan](https://github.com/sebastiancdhf)