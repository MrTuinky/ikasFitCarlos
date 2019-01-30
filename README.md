# ikasFitCarlos
Proyecto creado por Carlos Hernández (propuesto por Ion Jaureguialzo) como trabajo de fin de Grado 2019. El proyecto está realizado con Xcode en la versión de Swift 4.2 y consiste en una aplicación para el iPhone combinando Firebase con HealthKit.
Está diseñada para los diferentes tipos de pantalla de iPhone que actualmente hay en el mercado y soportan iOS 11.0 o posterior.

(aquí foto iP5S)

Esta aplicación está pensada para llevarla a cabo en un colegio, es decir, que está desarrollada para un único colegio, en este caso Egibide. En el futuro se puede actualizar y desarrollarla para varios colegios subiéndola a la AppStore. 

La aplicación consta de 3 pantallas diferentes:

En la primera pantalla debes escribir el nombre/numero de tu clase, por ejemplo “147FA” y darle al botón comenzar. En caso de que no escribas nada y le des al botón Comenzar, saltará un aviso por pantalla avisando que tienes que introducir el nombre/numero de tu clase.


Nada más le des al botón Comenzar, la aplicación se desplegará un menú para que des permisos para que la app pueda recoger la información de HelthKit.

La segunda pantalla muestra los pasos que has realizado hoy, la posición de tu clase (la que previamente has seleccionado) y la posición global (la posición de todo el colegio).


Debes darle el botón actualizar 1 vez para que muestre los pasos y un asegunda vez para que conecte con la base de datos y muestre estadísticas.

En caso de que al principio te hayas confundido de clase y luego introduzcas otra, no pasa nada, la aplicación está pensada para que solo puedas estar en una clase, así que cuando introduzcas la nueva clase y actualices, se borrarán tus registros de la otra.

El botón de ajustes redirige la aplicación a los ajustes del iPhone para que, en caso de no haber aceptado los permisos al principio, puedas hacerlo.

El botón de Ranking Colegio da acceso a una tabla con los registros de todo el colegio ordenados de mayor a menor, y en tu posición parece a la derecha --- Yo ---

