// DECORACION UST NATHA

void main()
{
  object oPC = GetEnteringObject();
  object oUstNatha = GetArea(oPC);
  int SoloDecorarUnaVez = GetLocalInt(oUstNatha, "UST_DECORACION");

  if(SoloDecorarUnaVez == TRUE) return;
  else
  {
      // Narbondel
      object oNarbondel1 = GetNearestObjectByTag("narbondel1", oPC);
      object oNarbondel2 = GetNearestObjectByTag("narbondel2", oPC);
      object oNarbondel3 = GetNearestObjectByTag("narbondel3", oPC);
      object oNarbondel4 = GetNearestObjectByTag("narbondel4", oPC);

      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(546), oNarbondel1);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(525), oNarbondel2);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(541), oNarbondel3);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(517), oNarbondel4);

      // Telaranyas
      effect eTelaranya = EffectAreaOfEffect(AOE_PER_WEB, "****", "****", "****");
      location lTelaranya1 = GetLocation(GetWaypointByTag("ust_telaranya1"));
      location lTelaranya2 = GetLocation(GetWaypointByTag("ust_telaranya2"));
      location lTelaranya3 = GetLocation(GetWaypointByTag("ust_telaranya3"));
      location lTelaranya4 = GetLocation(GetWaypointByTag("ust_telaranya4"));
      location lTelaranya5 = GetLocation(GetWaypointByTag("ust_telaranya5"));
      location lTelaranya6 = GetLocation(GetWaypointByTag("ust_telaranya6"));
      location lTelaranya7 = GetLocation(GetWaypointByTag("ust_telaranya7"));

      ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eTelaranya, lTelaranya1);
      ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eTelaranya, lTelaranya2);
      ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eTelaranya, lTelaranya3);
      ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eTelaranya, lTelaranya4);
      ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eTelaranya, lTelaranya5);
      ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eTelaranya, lTelaranya6);
      ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eTelaranya, lTelaranya7);

      // Raices negras
      effect eRaicesNegras = EffectAreaOfEffect(34, "****", "****", "****");
      location lRaicesNegras1 = GetLocation(GetWaypointByTag("ust_raicesnegras1"));

      ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eRaicesNegras, lRaicesNegras1);

      // Portones
      object oPorton1 = GetNearestObjectByTag("ust_porton1", oPC);
      object oPorton2 = GetNearestObjectByTag("ust_porton2", oPC);
      object oPorton3 = GetNearestObjectByTag("ust_porton3", oPC);
      string sGateBlock1 = GetLocalString(oPorton1, "CEP_L_GATEBLOCK");
      string sGateBlock2 = GetLocalString(oPorton2, "CEP_L_GATEBLOCK");
      string sGateBlock3 = GetLocalString(oPorton3, "CEP_L_GATEBLOCK");
      location lSelfLoc1 = GetLocation(oPorton1);
      location lSelfLoc2 = GetLocation(oPorton2);
      location lSelfLoc3 = GetLocation(oPorton3);
      AssignCommand(oPorton1, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
      AssignCommand(oPorton2, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
      AssignCommand(oPorton3, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
      SetLocalObject(oPorton1, "GateBlock", CreateObject(OBJECT_TYPE_PLACEABLE, sGateBlock1, lSelfLoc1));
      SetLocalObject(oPorton2, "GateBlock", CreateObject(OBJECT_TYPE_PLACEABLE, sGateBlock2, lSelfLoc2));
      SetLocalObject(oPorton3, "GateBlock", CreateObject(OBJECT_TYPE_PLACEABLE, sGateBlock3, lSelfLoc3));

      // Solo una vez
      SetLocalInt(oUstNatha, "UST_DECORACION", TRUE);
  }
}
