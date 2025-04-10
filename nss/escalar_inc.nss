// SISTEMA DE CUERDAS

void CuerdasTrepar()
{
  object oPC = GetItemActivator();
  int CuerdaLigera=0;

  // Solo se clickea en el suelo
  if(GetItemActivatedTarget() != OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "<cþ  >¡No puedes enganchar el garfio ahí!</c>");
      return;
  }

  location lLoc = GetItemActivatedTargetLocation();
  object oUbicadoInvisibleCuerda = GetFirstObjectInShape(SHAPE_SPHERE, 5.0f,lLoc,FALSE,OBJECT_TYPE_PLACEABLE);
  int iUbicaudoInvisbleCuerda = FALSE;

  while (oUbicadoInvisibleCuerda != OBJECT_INVALID && iUbicaudoInvisbleCuerda == FALSE)
  {
      // our string starts with "gz_rhook_" thus it is a ledge where the rope can be attached
      if(FindSubString(GetStringLowerCase(GetTag(oUbicadoInvisibleCuerda)), "gz_rhook_") == 0 )
      {
          iUbicaudoInvisbleCuerda = TRUE;  // gz_rhook_placeholder
      }

      oUbicadoInvisibleCuerda = GetNextObjectInShape(SHAPE_SPHERE, 5.0f,lLoc,FALSE,OBJECT_TYPE_PLACEABLE);
  }

  // No se encuentra ubicado invisible de cuerda
  if(iUbicaudoInvisbleCuerda == FALSE)
  {
      SendMessageToPC(oPC, "<cþ  >¡No puedes enganchar el garfio ahí!</c>");
      return;
  }

  // Tirada de Uso de Cuerdas...
  int iBono = 0;
  if(GetHasFeat(1249, oPC)) iBono = 10;      // Soltura epica
  else if(GetHasFeat(1237, oPC)) iBono = 3;  // Soltura normal

  int iTirada = GetSkillRank(38, oPC) + iBono + d20();
  int iDificultad = 10 + ((FloatToInt(GetDistanceBetweenLocations(GetLocation(oPC), lLoc)) / 3) * 2);

  // Fracaso
  if(iTirada < iDificultad)
  {
      SendMessageToPC(oPC, "<cþ  >Uso de cuerdas: "+IntToString(iTirada)+" vs CD "+IntToString(iDificultad)+": Fracaso. ¡No consigues enganchar la cuerda!</c>");
      return;
  }

  // Exito
  else SendMessageToPC(oPC, "<c þ >Uso de cuerdas: "+IntToString(iTirada)+" vs CD "+IntToString(iDificultad)+": éxito. ¡Has enganchado la cuerda!</c>");

  object oTarget = CreateObject(OBJECT_TYPE_PLACEABLE,"gz_obj_ropecont", GetItemActivatedTargetLocation());
  object oTarget2 = CreateObject(OBJECT_TYPE_PLACEABLE, "gz_obj_ropecont", GetLocation(oPC));
  string sIdentidadCuerda = IntToString(d100()) + IntToString(d100()) + IntToString(d100());

  if(GetName(GetItemActivated()) == "Cuerda de seda con garfio") CuerdaLigera=1;
  DestroyObject(GetItemActivated());
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBeam(VFX_BEAM_FIRE_W_SILENT,oTarget2,BODY_NODE_CHEST), oTarget);

  SetLocalString(oTarget, "IDENTIDADCUERDA", sIdentidadCuerda);
  SetLocalString(oTarget, "IDENTIDADPJ", GetName(oPC, TRUE));
  SetLocalObject(oTarget, "T1_TARGET_OBJECT", oTarget2);
  if(CuerdaLigera) SetLocalInt(oTarget, "CuerdaLigera", 1);

  SetLocalString(oTarget2, "IDENTIDADCUERDA", sIdentidadCuerda);
  SetLocalString(oTarget2, "IDENTIDADPJ", GetName(oPC, TRUE));
  SetLocalObject(oTarget2, "T1_TARGET_OBJECT", oTarget);
  if(CuerdaLigera) SetLocalInt(oTarget2, "CuerdaLigera", 1);

  SetLocalObject(oPC, "CUERDA1" + sIdentidadCuerda, oTarget);
  SetLocalObject(oPC, "CUERDA2" + sIdentidadCuerda, oTarget2);
}
