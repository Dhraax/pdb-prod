void main()
{
//::////////////////////////////////////////////////////////////////////////:://
// MONTI: GUION PARA CERRAR PUERTAS CON LLAVE EN 'X' SEGUNDOS
// Modifica aqui los segundos que tardara la puerta en volverse a cerrar
float fSegundos = 15.0;
//::////////////////////////////////////////////////////////////////////////:://

DelayCommand(fSegundos, AssignCommand(OBJECT_SELF, ActionCloseDoor(OBJECT_SELF)));
//Elimina la linea de abajo si no kieres que se cierre con llave
DelayCommand(fSegundos + 0.1, SetLocked(OBJECT_SELF, TRUE));
}

//NOTA: la puerta se cerrara con la llave que esta configurada en Propiedades->
//Cerradura. Si esto no estuviera configurado, un picaro podria abrir la puerta
// con su habilidad.

//NOTA2: este guion te servira para cualkier puerta. Acuerdate de colocarlo en el
//OnOpen de la puerta en cuestion
