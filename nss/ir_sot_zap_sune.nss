void main()
{
object oPC = GetLastUsedBy();
object oTrampilla = GetObjectByTag("trampilla_sotano_sune");
object oEscalera = GetObjectByTag("escaleras_subida_bodega_sune");
location lLugar = GetLocation(GetWaypointByTag("hacia_sotano_zap"));

if(GetLocalInt(oTrampilla,"TRAMPILLA_SOT_SUNE") == 1)
{
    FloatingTextStringOnCreature("*La trampilla de piedra está abierta y te introduces en ella*", oPC);
    DelayCommand(1.4, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(1.5, AssignCommand(oPC, ActionJumpToLocation(lLugar)));
    return;
}

if(GetItemPossessedBy(oPC, "Llav_baj_cloac_esmel") != OBJECT_INVALID)
{
    FloatingTextStringOnCreature("*Subes or las escaleras y abres la trampilla y levantas la tapa de piedra. La trampilla ha quedado abierta", oPC);
    PlaySound("as_dr_stonmedop1");
    DelayCommand(0.1, AssignCommand(oTrampilla, PlayAnimation(ANIMATION_PLACEABLE_OPEN)));
    SetLocalInt(oTrampilla, "TRAMPILLA_SOT_SUNE", 1);
    DelayCommand(100.0, AssignCommand(oTrampilla, SpeakString("*¡La tapa de la trampilla se baja un poco debido a su peso!*")));
    DelayCommand(140.0, AssignCommand(oTrampilla, SpeakString("*¡La trampilla está a punto de cerrarse!*")));
    DelayCommand(180.0, AssignCommand(oTrampilla, SpeakString("*¡La tapa de piedra ha cedido por el peso y la tramilla se ha cerrado!*")));
    DelayCommand(180.0, AssignCommand(oEscalera, PlaySound("as_dr_stonmedcl1")));
    DelayCommand(180.0, AssignCommand(oTrampilla, PlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
    DelayCommand(180.0, DeleteLocalInt(oTrampilla, "TRAMPILLA_SOT_SUNE"));
    return;
}
else
{
    PlaySound("as_dr_locked2");
    FloatingTextStringOnCreature("*Subes por las escaleras y encuentras la trampilla cerrada con llave*", oPC);
    return;
}
}
