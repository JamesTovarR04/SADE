# SADE for developers
## Overview
La plataforma se encuentra desarrollada mediante el modelo de programación por capas (presentacion, negocio y datos).

Para contribuir a su desarrollo realice un fork al repositorio y use el flujo de trabajo GitFlow, por lo tanto, para realizar un pull request solo debe hacerlo en la rama de desarrollo o 'develop'.
## Capa de presentación (Front-end)
El front-end se esta desarrollando con las librería [ReactJS](https://es.reactjs.org/ "ReactJS"), [Axios](https://github.com/axios/axios "axios"), [Bootstrap](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiPgvWtz-TyAhWFRDABHWtADzAQFnoECAwQAw&url=https%3A%2F%2Fgetbootstrap.com%2F&usg=AOvVaw3s0qqZzEfHTiGFr9v0jCTN "Bootstrap") y otras tecnologias que puede ver el archivo [package.json](https://github.com/JamesTovarR04/SADE/blob/main/package.json "package.json").

El proyecto cuenta con una aplicación de página única (SPA) para cada tipo de usuario (publico, directivos, profesores y estudiantes) construidas con ReactJS usando como base alguna de las vistas o páginas que puedes ver en la carpeta [resources/views](https://github.com/JamesTovarR04/SADE/tree/develop/resources/views "resources/views"). Cada una de estas vistas usa el motor de plantillas [Blade](https://laravel.com/docs/8.x/blade#introduction "Blade") y su enrutamiento se encuentra controlado por el gestor de [rutas web](https://github.com/JamesTovarR04/SADE/blob/develop/routes/web.php "rutas") de laravel que se encuentra configurado para trabajar conjuntamente con la libreria de enrutamiento [react-router-dom](https://reactrouter.com/web/guides/quick-start "react-router-dom").

Los recursos y archivos como imagenes, iconos, fuentes de texto, y scripts puros deben ubicarse en la carpeta [public/](https://github.com/JamesTovarR04/SADE/tree/develop/public "public/"). ⚠ Tenga en cuenta que el contenido de esta carpeta puede ser accedido por cualquiera mediante la url del servidor donde se despliegue el proyecto.

Los scripts que necesiten ser preprocesados (.js, .jsx, .scss, .sass, etc.) y que son usados para desarrollo se encuentran en la carpeta [resources/](https://github.com/JamesTovarR04/SADE/tree/develop/public "resorces/"). Allí podra encontrar la carpeta [js/](https://github.com/JamesTovarR04/SADE/tree/develop/resources/js "js/") donde se encuentran los scripts de React. Explorando los archivos podrá encontrar una app de react distinta para cada usuario, que sin embargo comparten los componentes y scripts que tienen en común.
### Intrucciones de compilación
Para compilar los archivos que se encuentren en la carpeta [resources/](https://github.com/JamesTovarR04/SADE/tree/develop/public "resorces/") se recomienda usar el paquete [Mix](https://laravel.com/docs/8.x/mix#react "Mix") que nos proporciona laravel. Puede configurar los archivos que serán compilados y su ruta de destino mediante el archivo [webpack.mix.js](https://github.com/JamesTovarR04/SADE/blob/develop/webpack.mix.js "webpack.mix.js"). 

En el caso de los scripts que serán compilados a javascript es necesario tener instalado [NodeJS](https://nodejs.org/es/download/ "NodeJS") y [NPM](https://www.npmjs.com/ "NPM"):
```shell
node -v
npm -v
```
Ubiquese en la raiz del proyecto e instale las dependencias de node que se encuentran en el archivo [package.json](https://github.com/JamesTovarR04/SADE/blob/develop/package.json "package.json") mediante el siguiente comando:
```shell
npm install
```
Finalmente para iniciar el proceso de compilación puede usar uno de los siguientes comandos en la carpeta raiz del proyecto:
```shell
// Correr en modo desarrollo (rápido)
npm run dev

// Correr en modo producción (lento pero comprimido)
npm run prod
```
Puede compilar los archivos cada vez que modifique un script usando el siguiente comando:
```shell
npm run watch
```