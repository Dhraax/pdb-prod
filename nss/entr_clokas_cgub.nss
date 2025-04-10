void main()
{
object oPC = GetLastUsedBy();
object oTrampilla = OBJECT_SELF;
location lLugar = GetLocation(GetWaypointByTag("ir_clokas_cg"));

if(GetLocalInt(OBJECT_SELF, "TRAMPILLA_SOT_SUNE") == 1)
{
    FloatingTextStringOnCreature("*La trampilla de piedra está abierta y te introduces en ella*", oPC);
    DelayCommand(1.4, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(1.5, AssignCommand(oPC, ActionJumpToLocation(lLugar)));
    return;
}

if(GetItemPossessedBy(oPC, "Llav_baj_cloac_esmel") != OBJECT_INVALID)
{
    FloatingTextStringOnCreature("*Introduces la llave en la cerradura de la trampilla y levantas la tapa de piedra. La trampilla ha quedado abierta", oPC);
    DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
    SetLocalInt(OBJECT_SELF, "TRAMPILLA_SOT_SUNE", 1);
    DelayCommand(100.0, AssignCommand(oTrampilla, SpeakString("*¡La tapa de la trampilla se baja un poco debido a su peso!*")));
    DelayCommand(140.0, AssignCommand(oTrampilla, SpeakString("*¡La trampilla está a punto de cerrarse!*")));
    DelayCommand(180.0, AssignCommand(oTrampilla, SpeakString("*¡La tapa de piedra ha cedido por el peso y la tramilla se ha cerrado!*")));
    DelayCommand(180.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
    DelayCommand(180.0, DeleteLocalInt(OBJECT_SELF, "TRAMPILLA_SOT_SUNE"));
    return;
}
else
{
    PlaySound("as_dr_locked2");
    FloatingTextStringOnCreature("*Cerrada con llave*", oPC);
    return;
}
}
