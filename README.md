# NYTChallenge
![Jul-07-2024 23-32-19](https://github.com/matiasmansilla/NYTChallenge/assets/31162891/17c1fe23-0c40-491e-8709-a3f22728bb5b)


## Descripción

Este proyecto es una aplicación de noticias que utiliza una arquitectura MVP (Model-View-Presenter) para mostrar artículos del New York Times. Incluye funcionalidades de carga de artículos, manejo de estados de carga, estados vacíos, errores de servicio, manejo de conexión a internet, persistencia de datos con CoreData y UnitTesting.

## Arquitectura MVP

La arquitectura MVP divide la aplicación en tres componentes principales:

1. **Model**: Representa los datos y la lógica de negocio de la aplicación.
2. **View**: Responsable de la presentación de datos y la captura de las interacciones del usuario.
3. **Presenter**: Actúa como intermediario entre el Model y el View, gestionando la lógica de presentación.

## Features

### Listado con Filtros 

<img width="435" alt="Screenshot 2024-07-07 at 23 09 56" src="https://github.com/matiasmansilla/NYTChallenge/assets/31162891/0c9e5177-fa35-420f-aec6-10c5b98cbb2a">

### Detalle de Articulo

 <img width="479" alt="Screenshot 2024-07-07 at 23 20 12" src="https://github.com/matiasmansilla/NYTChallenge/assets/31162891/ac53dc27-f2ae-4f95-a713-74ea91947f67">


### Bookmarks de Articulos guardados offline

<img width="479" alt="Screenshot 2024-07-07 at 23 22 06" src="https://github.com/matiasmansilla/NYTChallenge/assets/31162891/414f80cd-d3b3-4518-9126-00be5ebe9ef7">

### Eliminacion del listado con gesto

<img width="479" alt="Screenshot 2024-07-07 at 23 23 09" src="https://github.com/matiasmansilla/NYTChallenge/assets/31162891/b46029d8-baa5-4e80-835c-484928cf0638">

### Manejo de estados empty, error y no internet

![image](https://github.com/matiasmansilla/NYTChallenge/assets/31162891/0eb97768-a4d5-4558-9d4d-2db83845fa6e)


