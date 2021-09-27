<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class LoginTest extends TestCase
{
    public function test_login()
    {   
        $usuario = 'miguelalejandro183@gmail.com'; 
        $password = 123456;

        $response = $this->getjson('login');
        
        $response->assertStatus(200);
    }
}
