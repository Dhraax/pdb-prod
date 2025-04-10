void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("patio_cas_aband");
    object oMod = GetModule();
    object oCofre = GetObjectByTag("cofre_misnor");
    float fSegundos = 300.0;
    effect eEfecto2 = EffectVisualEffect(VFX_IMP_DISPEL);
    location lEfectos= GetLocation(GetWaypointByTag("efectos_relikias"));
    AssignCommand(oPC, JumpToObject(oTarget));
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "Llave_misnor");
    if(GetIsObjectValid(oItemToTake) != 0)
    DestroyObject(oItemToTake);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEfecto2, lEfectos);
    DestroyObject(oCofre);
    SetLocalInt(oMod, "entra_relikias", 1);
    DelayCommand(fSegundos, DeleteLocalInt(oMod,"entra_relikias"));
}
