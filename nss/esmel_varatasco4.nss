//::///////////////////////////////////////////////
//:: FileName esmel_varatasco1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 26/01/2006 20:18:04
//:://////////////////////////////////////////////
int StartingConditional()
{
object oReja = GetNearestObjectByTag("rejavariabley");
    // Inspeccionar las variables locales
    if(!(GetLocalString(oReja, "Atascado") == "1"))
        return FALSE;

    return TRUE;
}
