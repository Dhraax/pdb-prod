
//::///////////////////////////////////////////////
//:: FileName esmel_varatasco1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 26/01/2006 20:18:04
//:://////////////////////////////////////////////
int StartingConditional()
{
object oEscalera = GetNearestObjectByTag("escaleravariable");
    // Inspeccionar las variables locales
    if(!(GetLocalString(oEscalera, "Niveldeagua") == "2"))
        return FALSE;

    return TRUE;
}

