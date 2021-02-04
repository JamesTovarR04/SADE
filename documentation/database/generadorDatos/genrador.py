# -*- coding: utf-8 -*-
"""
Created on Wed Feb  3 15:14:00 2021

@author: james
"""

import csv
import random
from random import choice

nombres = list()

with open('Nombres.csv', newline='') as File:  
    reader = csv.reader(File, delimiter=';')
    nombres = list(reader)
    print(type(nombres))


def generarUsuarios(id, tipo):
    registro = list()
    determinarSexo = random.randint(0,1)
    registro.append(i) #id
    nombre = choice(nombres)[determinarSexo].title()
    registro.append(nombre) #nombre
    registro.append(choice(nombres)[2].title()) #apellido1
    determinarApellido2 = random.randint(0,1)
    apellido2 = (choice(nombres)[2]).title() if (determinarApellido2 == 0) else ''
    registro.append(apellido2) #apellido2
    registro.append(tipo) #tipo
    email = nombre.lower().replace(" ", "") + str(random.randint(0, 1000)) + "@gmail.com"
    registro.append(email) #email
    sexo = 'M' if (determinarSexo == 1) else 'F'
    registro.append(sexo) #sexo
    ano = ''
    if tipo == 1:
        ano = str(random.randint(2004, 2015))
    else:
        ano = str(random.randint(1960, 2002))
    anoNacimiento = ano
    mesNacimiento = str(random.randint(1, 12))
    diaNacimiento = str(random.randint(1, 28))
    registro.append(anoNacimiento + '-' + mesNacimiento + '-' + diaNacimiento) #fechaNacimiento "yyyy-mm-dd"
    registro.append(0) #intentosConexion
    registro.append('') #fechaRegistro
    registro.append('') #contraseña
    registro.append('') #token
    registro.append('') #foto
    registro.append('') #delete
    return registro

def generarDireccion():
    calle =  ("Calle " + str(random.randint(1, 299)))
    carrera = ("Carrera " +  str( + random.randint (1, 70)))
    determinarCalle_Carrera = (random.randint(0, 1))
    Calle_Carrera = calle if (determinarCalle_Carrera == 1) else carrera  
    numeroUnoDireccion = str(random.randint(1, 99))
    numeroDosDireccion = str(random.randint(1, 99))
    direccion = (Calle_Carrera + " #" + numeroUnoDireccion +"-"+ numeroDosDireccion)
    return direccion

def registrarEstudiante(id, grado):
    registro = list()
    registro.append(id)
    registro.append(generarDireccion())
    TipoSangre = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', '0+', '0-']
    registro.append(choice(TipoSangre))
    registro.append(0)
    registro.append(grado)
    return registro

registrosUsuarios = list()
registrosEstudiantes = list()
registrosGrados = list()
registrosGradosDocentes = list()
registrosDocentes = list()
registrosDirectivos = list()
registrosDocumentos = list()
registrosTelefonos = list()
registrosPublicaciones = list()

grados = []
for i in range(4,12):
    for j in range(3):
        idGrado = (i*100)+(j+1)
        registroGrado = list()
        registroGrado.append(idGrado) #idGrupo
        registroGrado.append(idGrado) #nombre
        registroGrado.append(choice(['Mañana', 'Tarde', 'Nocturno', 'Mixto'])) #jornada
        registroGrado.append(random.randint(100, 300)) #salon
        registroGrado.append('') #delete
        registroGrado.append(i) #grado
        registroGrado.append('') #directorGrado
        registrosGrados.append(registroGrado)
        grados.append(idGrado)
        
indiceGrado = -1

# GENERAR REGISTROS USUARIOS
for i in range(1,518):
    
    if (i < 480):
        registroUsuario = generarUsuarios(i, 1)
        if((i % 20) == 0): # 0
            indiceGrado += 1 # 1
        registroEstudiante = registrarEstudiante(i,grados[indiceGrado])
        
        registrosEstudiantes.append(registroEstudiante)
    elif (i >= 480 and i < 510):
        registroUsuario = generarUsuarios(i, 2)
        
        rgDocenteGrupo = list()
        rgDocenteGrupo.append(choice(grados))
        rgDocenteGrupo.append(i)
        registrosGradosDocentes.append(rgDocenteGrupo)
        
        registroDocente = list()
        registroDocente.append(i) #idUsuario
        registroDocente.append(generarDireccion()) # direccion
        perfiles = ['Matematico','Biologo','Licenciado en literatura','Licenciado en ingles','Ingeniero en sistemas','Licenciado en geografía e historia']
        registroDocente.append(choice(perfiles)) #perfilAcademico
        registrosDocentes.append(registroDocente)
        
    else:
        registroUsuario = generarUsuarios(i, 3)
        
        registroDirectivo = list()
        registroDirectivo.append(i) #idUsuario
        cargos = ['Director','Coordinador','Psicologo','Secretari@','Consejero']
        registroDirectivo.append(choice(cargos)) #cargo
        registroDirectivo.append(generarDireccion()) # direccion
        email = 'directivo-' + str(i) + '@sade.edu'
        registroDirectivo.append(email) #EmailPublico
        registrosDirectivos.append(registroDirectivo)
    
    registrosUsuarios.append(registroUsuario)
    
    registroDocumento = list()
    registroDocumento.append(i) #idUsuario
    registroDocumento.append(choice(['CC', 'CE', 'RC', 'TI'])) #tipóDocumento
    registroDocumento.append(str(random.randint(10000000,2000000000))) #Numero
    anoExpedicion = str(random.randint(1978, 2015))
    mesExpedicion = str(random.randint(1, 12))
    diaExpedicion = str(random.randint(1, 28))
    registroDocumento.append(anoExpedicion + '-' + mesExpedicion + '-' + diaExpedicion)
    registroDocumento.append(choice(['Neiva - Huila', 'Campoalegre - Huila', 'Rivera - Huila', 'Pitalito - Huila'])) #lugar Expedicion
    registrosDocumentos.append(registroDocumento)
    
    registroTelefono = list()
    registroTelefono.append('') #idTelefono
    registroTelefono.append(i) #idUsuario
    telefono = random.randint(3100000000,3230000000)
    registroTelefono.append(telefono) #telefono
    registrosTelefonos.append(registroTelefono)
    
# Generar Publicaciones
for p in range(30):
    publicacion = list()
    publicacion.append(p) #idPublicacion
    titulos = ['Lorem ipsum dolor sit amet, consectetur adipiscing elit','Vivamus molestie felis eu orci ultricies, sit amet tempus nunc interdum. Pellentesque iaculis efficitur quam, ac vestibulum mauris hendrerit non','Titulo']
    publicacion.append(choice(titulos) + '-' + str(p))
    contenidos = ['Curabitur egestas mollis vehicula. Suspendisse ultrices ipsum urna, quis fermentum erat elementum ac. Suspendisse lacinia, sem a sagittis tincidunt, sem arcu eleifend erat, at convallis justo nibh nec ipsum. Praesent commodo dui sed mi rutrum gravida. Quisque ac blandit urna. Nullam tristique sapien ante, vitae fringilla nibh consequat ut.','Proin fermentum turpis vel quam laoreet, vitae rhoncus sapien tincidunt. Cras eget enim eu velit imperdiet tincidunt vitae eget tortor. Sed sit amet venenatis magna, ac suscipit ex. Pellentesque sagittis augue magna, nec sodales mauris consectetur in. Integer nibh velit, efficitur ut eleifend eget, varius eu leo. Maecenas sollicitudin mauris ac ullamcorper sagittis. Ut interdum molestie auctor. Sed nec justo eget velit tincidunt placerat. Pellentesque porta hendrerit porttitor. Aenean blandit, arcu a cursus sodales, orci sem consequat purus, nec lobortis velit velit et odio. Quisque scelerisque hendrerit ex eu bibendum. Donec ligula dolor, sodales at urna ac, sagittis fringilla ligula. Ut quis ante a quam consectetur blandit vitae sed ex. ']
    publicacion.append(choice(contenidos))
    anoPublicacion = str(random.randint(2019, 2020))
    mesPublicacion = str(random.randint(1, 12))
    diaPublicacion = str(random.randint(1, 28))
    horaPub = str(random.randint(0, 23))
    minutoPub = str(random.randint(0, 59))
    segundoPub = str(random.randint(0, 59))
    publicacion.append(anoExpedicion+'-'+mesExpedicion+'-'+diaExpedicion+' '+horaPub+':'+minutoPub+':'+segundoPub)
    publicacion.append(random.randint(0,517))
    publicacion.append(random.randint(1,5))
    registrosPublicaciones.append(publicacion)
    
# CREAR ARCHIVO TABLA USUARIOS
with open('usuarios.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(registrosUsuarios)
    
# CREAR ARCHIVO TABLA ESTUDIANTES
with open('estudiantes.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(registrosEstudiantes)
    
# CREAR ARCHIVO TABLA DOCENTES
with open('docentes.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(registrosDocentes)
    
# CREAR ARCHIVO TABLA DIRECTIVOS
with open('directivos.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(registrosDirectivos)
    
# CREAR ARCHIVO TABLA GRUPOS
with open('grupos.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(registrosGrados)
    
# CREAR ARCHIVO TABLA GRUPOS-DOCENTES
with open('gruposDocentes.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(registrosGradosDocentes)
    
# CREAR ARCHIVO TABLA DOCUMENTO
with open('documentoIdentidad.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(registrosDocumentos)

# CREAR ARCHIVO TABLA TELEFONO
with open('telefonos.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(registrosTelefonos)

# CREAR ARCHIVO TABLA PUBLICACIONES
with open('publicaciones.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(registrosPublicaciones)