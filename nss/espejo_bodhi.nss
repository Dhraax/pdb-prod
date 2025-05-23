void main()
{
    object oPC = GetLastUsedBy();
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));

    // Obtener destino
    string sTargetWaypoint = GetLocalString(OBJECT_SELF, "TARGET_WAYPOINT");
    object oDestino = GetWaypointByTag(sTargetWaypoint);

    if (sSubraza == "vampiro" || sSubraza == "engendro" ||
        GetItemPossessedBy(oPC, "lugarteniente_mascaras") != OBJECT_INVALID ||
        GetItemPossessedBy(oPC, "mascara_nocturna") != OBJECT_INVALID)
    {
      effect eEfecto = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_CHEST, FALSE);
      SendMessageToPC(oPC, "<c  ó>*El pulido cristal se vuelve poco a poco líquido, atrayendote hacia él*</c>");
      ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto, oPC, 7.0));
      DelayCommand(9.0, AssignCommand(oPC, JumpToObject(oDestino)));
      DelayCommand(9.0, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
    }
    else
    {
      SendMessageToPC(oPC, "<c  ó>*El espejo devuelve tu reflejo.*</c>");
    }
}
