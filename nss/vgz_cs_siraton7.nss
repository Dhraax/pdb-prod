#include "mti_libreria"
int StartingConditional()
{
     object oPC = GetPCSpeaker();
    if(ObtenerIntPersistente(oPC,"cs_ratones") != 10)
    return FALSE;
    return TRUE;
}
