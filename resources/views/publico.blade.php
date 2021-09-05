<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>SADE</title>
        <link rel="icon" href="{{ asset('images/favicon.png') }}">
        <link rel="stylesheet" href="{{ asset('css/public_styles.css') }}">
        <script src="https://use.fontawesome.com/releases/v5.15.4/js/all.js" data-mutate-approach="sync"></script>
    </head>
    <body>
        <noscript>Necesitas habilitar javascript en tu navegador.</noscript>
        <!-- Esta página esta realizada con react -->
        <div id="example"></div>
        <script src="{{ asset('js/app.js') }}" defer></script>
    </body>
</html>