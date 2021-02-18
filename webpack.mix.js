const mix = require('laravel-mix');

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */

mix.react('resources/js/publico/app.jsx', 'public/js/publico')
    .react('resources/js/directivos/app.jsx', 'public/js/directivo')
    .react('resources/js/estudiantes/app.jsx', 'public/js/estudiante')
    .react('resources/js/profesores/app.jsx', 'public/js/profesor')
    //.sass('resources/sass/app.scss', 'public/css');
