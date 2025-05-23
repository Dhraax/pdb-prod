int SiPC()
{
object oPC = GetFirstObjectInArea();
while(GetIsObjectValid(oPC))
    {
    if(GetIsPC(oPC))
        {
        return TRUE;
        break;
        }
    oPC = GetNextObjectInArea();
    }
return FALSE;
}
void main()
{
float fD = 0.1;
if (SiPC()==TRUE)return;
//============================================================================\\
//----------------------- # Limpia los Bichos # ------------------------------\\
//============================================================================\\
object oBicho = GetFirstObjectInArea();
while (GetIsObjectValid(oBicho) == TRUE)
    {
    if(GetObjectType(oBicho)==OBJECT_TYPE_CREATURE)
        {
        int iHostil = GetStandardFactionReputation(STANDARD_FACTION_HOSTILE, oBicho);
        if (iHostil)
            {
            DelayCommand(fD, DestroyObject(oBicho));
            fD=fD+0.1;
            }
        }
    oBicho = GetNextObjectInArea();
    }
//============================================================================\\
//-------- # Limpia los Soldados y pnj's con variable "DESTRUIBLE" # ---------\\
//============================================================================\\
object oSoldado = GetFirstObjectInArea();
while (GetIsObjectValid(oSoldado) == TRUE)
    {
    if(GetObjectType(oSoldado)==OBJECT_TYPE_CREATURE)
        {
        int iNoHostil = GetStandardFactionReputation(STANDARD_FACTION_DEFENDER ||STANDARD_FACTION_COMMONER||STANDARD_FACTION_MERCHANT, oSoldado);
        int iVariable = GetLocalInt (oSoldado, "DESTRUIBLE");
        if (iNoHostil && (iVariable == 1))
            {
            DelayCommand(fD, DestroyObject(oSoldado));
            fD=fD+0.1;
            }
        }
    oSoldado = GetNextObjectInArea();
    }
//============================================================================\\
//---------------------- # Limpia los Encuentros # ---------------------------\\
//============================================================================\\
object oEncuentro = GetFirstObjectInArea();
while (GetIsObjectValid(oEncuentro) == TRUE)
    {
    if(GetObjectType(oEncuentro)==OBJECT_TYPE_ENCOUNTER)
        {
        SetEncounterActive(TRUE, oEncuentro);
        }
    oEncuentro = GetNextObjectInArea();
    }

//============================================================================\\
//-------------- # Activador de Desencadenante de soldados #------------------\\
//============================================================================\\

object oDesencadenante = GetFirstObjectInArea();
while (GetIsObjectValid(oDesencadenante) == TRUE)
    {
    if(GetObjectType(oDesencadenante)==OBJECT_TYPE_TRIGGER)
        {int iVariableActivacion = GetLocalInt (oDesencadenante, "ACTIVADO");

            if (iVariableActivacion ==1){
            SetLocalInt(oDesencadenante, "ACTIVADO", 0);}
        }
    oDesencadenante = GetNextObjectInArea();
    }
}
