void main()
{
//::////////////////////////////////////////////////////////////////////////:://
/* Nada que tocar aqui                                                        */
//::////////////////////////////////////////////////////////////////////////:://

// Definimos al jugador que sale del desencadenante
object oPC = GetExitingObject();

// Eliminamos la variable TRAMPACIDO del jugador
DeleteLocalInt(oPC,"TRAMPACIDO");
}
