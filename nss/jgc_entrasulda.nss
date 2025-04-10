#include "lib_race"

void main()
{
    object oPC = GetEnteringObject();
    object oTarget = GetWaypointByTag("WP_SalidaElfosSulda");
    location lTarget = GetLocation(oTarget);
    int esAliado = FALSE;
    if (GetItemPossessedBy( oPC, "ExiliadoDeSuldanessalar") != OBJECT_INVALID ){
       FloatingTextStringOnCreature( "Eres un exiliado de la ciudad, tu entrada no esta permitida", oPC);
       return;
    }
    if(GetItemPossessedBy( oPC, "AliadodeSuldanessalar") != OBJECT_INVALID) esAliado=TRUE;
    else if(GetSubRace(oPC) == "drow" ||
       GetSubRace(oPC) == "Drow" ||
       GetSubRace(oPC) == "vampiro" ||
       GetSubRace(oPC) == "Vampiro" ||
       GetSubRace(oPC) == "ghul" ||
       GetSubRace(oPC) == "Ghul" ||
       GetSubRace(oPC) == "semidrow" ||
       GetSubRace(oPC) == "Semidrow"
       ){
          FloatingTextStringOnCreature( "No encuentras nada en el bosque, volviendo a donde estabas antes", oPC);
          return;
    }
    if (PB_Race_GetIsElf(oPC) || GetRacialType(oPC) == RACIAL_TYPE_HALFELF || GetRacialType(oPC) == RACIAL_TYPE_SEMIELFO2 || esAliado) {
        AssignCommand(oPC, ClearAllActions());
        FloatingTextStringOnCreature( "Llegas ante lo que parece un asentamiento elfico", oPC);
        DelayCommand(0.5, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
    } else {
           FloatingTextStringOnCreature( "No encuentras nada en el bosque, volviendo a donde estabas antes", oPC);
           return;
    }
}
