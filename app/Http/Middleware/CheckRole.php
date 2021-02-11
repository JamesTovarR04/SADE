<?php

namespace App\Http\Middleware;

use Closure;

class CheckRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next, $role)
    {
        if (! $request->user()->hasRole($role) ) {
            return response()->json([
                'message' => 'El usuario no tiene permisos para este recurso.'
            ], 403);
        }

        return $next($request);
    }
}
