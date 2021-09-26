<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;
use App\Models\User;


class AuthDirectivoTest extends TestCase
{
    public function test_pagina_login()
    {
        $response = $this->postJson('/api/directivo/publicaciones');
        
        $response->assertStatus(401);
    }
      /**
     * A basic feature test example.
     *
     * @return void
     */

    public function test_autenticacion()
    {
        $user = new User();
        $user->idUsuario = 516;
        $user->tipo = 3; 

        $response = $this->actingAs($user)->getJson('/api/directivo/publicaciones');

        $response->assertStatus(200);
    }
}
