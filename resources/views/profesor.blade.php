<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>SADE - Profesor</title>
        <link rel="icon" href="{{ asset('images/favicon.png') }}">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css" integrity="sha384-B0vP5xmATw1+K9KRQjQERJvTumQW0nPEzvF6L/Z6nronJ3oUOFUFpCjEUQouq2+l" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-Piv4xVNRyMGpqkS2by6br4gNJ7DXjqk09RmUpJ8jgGtD7zP9yug3goQfGII0yAns" crossorigin="anonymous"></script>
        <link href="/css/fontawesome.min.css" rel="stylesheet">
        <link href="/css/brands.min.css" rel="stylesheet">
        <link href="/css/solid.min.css" rel="stylesheet">
        <link href="/css/profesor.css" rel="stylesheet">
    </head>
    <body>
        <noscript>Necesitas habilitar javascript en tu navegador.</noscript>
        <!-- Esta página esta realizada con react -->
        <div id="appSade"></div>
    </body>
    <script type="text/javascript" src="{{ asset('js/profesor/app.js') }}"></script>
</html>