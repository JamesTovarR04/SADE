<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle(Request $request, Closure $next, $role)
    {
        if (!$request->user()->hasRole($role)) {

            if (!$request->expectsJson())
                return redirect($request->user()->rol());

            return response()->json([
                'message' => 'El usuario no tiene permisos para este recurso.'
            ], 403);
        }

        return $next($request);
    }
}
