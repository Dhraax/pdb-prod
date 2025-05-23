/////////////////////////////////////////////////
// viaje_onexit
////////////////////////////////////////////////
/*
Utilizado para abandonar el barco
Activadores de transición OnAreaTransitionClick / OnClick event del ubicado para salir del barco
*/

#include "viaje_inc"
#include "inc_sqlite_time"

void main()
{
    object oPC = GetLastUsedBy();

    // Contador: solo podemos salir del barco si ha pasado el tiempo de viaje.
    object oMod = GetModule();
    int iCurTime = SQLite_GetTimeStamp();
    int iCoolDown = GetLocalInt(oMod, "TIEMPO_VIAJE" + GetName(oPC));
    string sResto = IntToString(iCoolDown-iCurTime);

     if (iCurTime < iCoolDown) {

         FloatingTextStringOnCreature("<cþ<<>* ¡Aun no has llegado a tu destino! *</c>", oPC, FALSE);
         return;
        }

        //Continuamos el viaje
        AssignCommand(oPC, ClearAllActions());
        ContinueTravelAfterEncounter(oPC);

}
