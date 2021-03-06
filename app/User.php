<?php

namespace App;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable
{
    use Notifiable, HasApiTokens;

    protected $table='Usuarios';
    protected $primaryKey = 'idUsuario';
    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'nombres', 'idUsuario', 'contrasenia',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'contrasenia', 
        'remember_token', 
        'delete', 
        'intentosConexion'
    ];

    // Cambiar el campo por defecto password a contrasenia
    public function getAuthPassword()
    {
      return $this->contrasenia;
    }

    /**
     * @return string rolTexto
     */
    public function rol(){
        switch ($this->tipo) {
            case 1:
                return 'estudiante';
            case 2:
                return 'profesor';
            case 3:
                return 'directivo';
            default:
                return 'error';
        }
    }

    /**
     * Determinar rol
     * 
     * @param string role
     * @return boolean
     */
    public function hasRole($role){
        return ($role == $this->rol());
    }

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    /*protected $casts = [
        'email_verified_at' => 'datetime',
    ];*/
}
