#include "x0_i0_petrify"

void InvertirPosicion(object oPlaca)
{
  if(GetLocalInt(oPlaca, "ACTIVADA"))
  {
      RemoveEffectOfType(oPlaca, EFFECT_TYPE_VISUALEFFECT);
      DeleteLocalInt(oPlaca, "ACTIVADA");
  }
  else
  {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_AURA_BLUE), oPlaca);
      SetLocalInt(oPlaca, "ACTIVADA", TRUE);
  }
}

void Reseteo()
{
  object oPlaca1 = GetNearestObjectByTag("mti_placa_quest_1");
  object oPlaca2 = GetNearestObjectByTag("mti_placa_quest_2");
  object oPlaca3 = GetNearestObjectByTag("mti_placa_quest_3");
  object oPlaca4 = GetNearestObjectByTag("mti_placa_quest_4");
  object oPlaca5 = GetNearestObjectByTag("mti_placa_quest_5");
  object oPlaca6 = GetNearestObjectByTag("mti_placa_quest_6");
  object oPlaca7 = GetNearestObjectByTag("mti_placa_quest_7");
  object oPlaca8 = GetNearestObjectByTag("mti_placa_quest_8");
  object oPlaca9 = GetNearestObjectByTag("mti_placa_quest_9");
  object oPedestal1 = GetNearestObjectByTag("mti_quest_sombras_ped1");
  object oPedestal2 = GetNearestObjectByTag("mti_quest_sombras_ped2");
  object oPedestal3 = GetNearestObjectByTag("mti_quest_sombras_ped3");
  object oPedestal4 = GetNearestObjectByTag("mti_quest_sombras_ped4");
  object Luz1 = GetNearestObjectByTag("mti_quest_sombras_luz1");
  object Luz2 = GetNearestObjectByTag("mti_quest_sombras_luz2");
  object Luz3 = GetNearestObjectByTag("mti_quest_sombras_luz3");
  object Luz4 = GetNearestObjectByTag("mti_quest_sombras_luz4");
  object oPuerta = GetNearestObjectByTag("mti_quest_sombras_puerta");

  RemoveEffectOfType(oPlaca1, EFFECT_TYPE_VISUALEFFECT);
  RemoveEffectOfType(oPlaca2, EFFECT_TYPE_VISUALEFFECT);
  RemoveEffectOfType(oPlaca3, EFFECT_TYPE_VISUALEFFECT);
  RemoveEffectOfType(oPlaca4, EFFECT_TYPE_VISUALEFFECT);
  RemoveEffectOfType(oPlaca5, EFFECT_TYPE_VISUALEFFECT);
  RemoveEffectOfType(oPlaca6, EFFECT_TYPE_VISUALEFFECT);
  RemoveEffectOfType(oPlaca7, EFFECT_TYPE_VISUALEFFECT);
  RemoveEffectOfType(oPlaca8, EFFECT_TYPE_VISUALEFFECT);
  RemoveEffectOfType(oPlaca9, EFFECT_TYPE_VISUALEFFECT);

  DeleteLocalInt(oPlaca1, "ACTIVADA");
  DeleteLocalInt(oPlaca2, "ACTIVADA");
  DeleteLocalInt(oPlaca3, "ACTIVADA");
  DeleteLocalInt(oPlaca4, "ACTIVADA");
  DeleteLocalInt(oPlaca5, "ACTIVADA");
  DeleteLocalInt(oPlaca6, "ACTIVADA");
  DeleteLocalInt(oPlaca7, "ACTIVADA");
  DeleteLocalInt(oPlaca8, "ACTIVADA");
  DeleteLocalInt(oPlaca9, "ACTIVADA");

  DeleteLocalInt(GetModule(), "QUEST_TEMPLO_SOMBRAS_NIVEL_PLACAS");

  AssignCommand(oPedestal1, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
  AssignCommand(oPedestal2, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
  AssignCommand(oPedestal3, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
  AssignCommand(oPedestal4, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));

  RemoveEffectOfType(oPedestal1, EFFECT_TYPE_VISUALEFFECT);
  RemoveEffectOfType(oPedestal2, EFFECT_TYPE_VISUALEFFECT);
  RemoveEffectOfType(oPedestal3, EFFECT_TYPE_VISUALEFFECT);
  RemoveEffectOfType(oPedestal4, EFFECT_TYPE_VISUALEFFECT);

  DestroyObject(Luz1);
  DestroyObject(Luz2);
  DestroyObject(Luz3);
  DestroyObject(Luz4);

  AssignCommand(oPuerta, ActionCloseDoor(oPuerta));
  DelayCommand(1.0, SetLocked(oPuerta, TRUE));
}

void PlacasAleatorias(object oPC)
{
  object oPlaca = GetFirstObjectInArea(GetArea(oPC));
  while(GetIsObjectValid(oPlaca))
  {
      if(GetStringLeft(GetTag(oPlaca), 16) == "mti_placa_quest_")
      {
          if(d3() <= 2)
          {
              RemoveEffectOfType(oPlaca, EFFECT_TYPE_VISUALEFFECT);
              DeleteLocalInt(oPlaca, "ACTIVADA");
          }
      }

      oPlaca = GetNextObjectInArea(GetArea(oPC));
  }
}

void main()
{
  object oPC = GetEnteringObject();
  object oMod = GetModule();

  // Restricciones: Solo PJs
  if(GetIsPC(oPC) == FALSE) return;

  // Restricciones: En Nivel 4 no, tampoco en ciertos momentos
  if(GetLocalInt(oMod, "QUEST_TEMPLO_SOMBRAS_NIVEL_PLACAS") == 4) return;
  if(GetLocalInt(oMod, "NO_PLACAS") == TRUE) return;

  // Mensaje de fallo
  if(!GetLocalInt(oPC, "QUEST_TS_AVISO_PLACAS"))
  {
      SendMessageToPC(oPC, "<cþ<<>// Si no ves correctamente la iluminación de las baldosas reentra al área. Es un pequeño fallo visual del juego que no se puede corregir.</c>");
      SetLocalInt(oPC, "QUEST_TS_AVISO_PLACAS", TRUE);
      DelayCommand(500.0, DeleteLocalInt(oPC, "QUEST_TS_AVISO_PLACAS"));
  }

  object oPlaca1 = GetNearestObjectByTag("mti_placa_quest_1");
  object oPlaca2 = GetNearestObjectByTag("mti_placa_quest_2");
  object oPlaca3 = GetNearestObjectByTag("mti_placa_quest_3");
  object oPlaca4 = GetNearestObjectByTag("mti_placa_quest_4");
  object oPlaca5 = GetNearestObjectByTag("mti_placa_quest_5");
  object oPlaca6 = GetNearestObjectByTag("mti_placa_quest_6");
  object oPlaca7 = GetNearestObjectByTag("mti_placa_quest_7");
  object oPlaca8 = GetNearestObjectByTag("mti_placa_quest_8");
  object oPlaca9 = GetNearestObjectByTag("mti_placa_quest_9");
  string sEtiquetaDesencadenante = GetTag(OBJECT_SELF);

  // Sonidos placas
  if(d2() == 1) AssignCommand(oPC, PlaySound("tns_draw_down"));
  else AssignCommand(oPC, PlaySound("tns_draw_up"));

  // Invertir posiciones
  if(sEtiquetaDesencadenante == "mti_desenc_quest_1")
  {
      InvertirPosicion(oPlaca1);
      InvertirPosicion(oPlaca2);
      InvertirPosicion(oPlaca4);
  }
  else if(sEtiquetaDesencadenante == "mti_desenc_quest_2")
  {
      InvertirPosicion(oPlaca1);
      InvertirPosicion(oPlaca2);
      InvertirPosicion(oPlaca3);
      InvertirPosicion(oPlaca5);
  }
  else if(sEtiquetaDesencadenante == "mti_desenc_quest_3")
  {
      InvertirPosicion(oPlaca2);
      InvertirPosicion(oPlaca3);
      InvertirPosicion(oPlaca6);
  }
  else if(sEtiquetaDesencadenante == "mti_desenc_quest_4")
  {
      InvertirPosicion(oPlaca1);
      InvertirPosicion(oPlaca4);
      InvertirPosicion(oPlaca5);
      InvertirPosicion(oPlaca7);
  }
  else if(sEtiquetaDesencadenante == "mti_desenc_quest_5")
  {
      InvertirPosicion(oPlaca2);
      InvertirPosicion(oPlaca4);
      InvertirPosicion(oPlaca5);
      InvertirPosicion(oPlaca6);
      InvertirPosicion(oPlaca8);
  }
  else if(sEtiquetaDesencadenante == "mti_desenc_quest_6")
  {
      InvertirPosicion(oPlaca3);
      InvertirPosicion(oPlaca5);
      InvertirPosicion(oPlaca6);
      InvertirPosicion(oPlaca9);
  }
  else if(sEtiquetaDesencadenante == "mti_desenc_quest_7")
  {
      InvertirPosicion(oPlaca4);
      InvertirPosicion(oPlaca7);
      InvertirPosicion(oPlaca8);
  }
  else if(sEtiquetaDesencadenante == "mti_desenc_quest_8")
  {
      InvertirPosicion(oPlaca5);
      InvertirPosicion(oPlaca7);
      InvertirPosicion(oPlaca8);
      InvertirPosicion(oPlaca9);
  }
  else if(sEtiquetaDesencadenante == "mti_desenc_quest_9")
  {
      InvertirPosicion(oPlaca6);
      InvertirPosicion(oPlaca8);
      InvertirPosicion(oPlaca9);
  }

  // Superacion de nivel
  object oPedestal1 = GetNearestObjectByTag("mti_quest_sombras_ped1");
  object oPedestal2 = GetNearestObjectByTag("mti_quest_sombras_ped2");
  object oPedestal3 = GetNearestObjectByTag("mti_quest_sombras_ped3");
  object oPedestal4 = GetNearestObjectByTag("mti_quest_sombras_ped4");
  object oPuerta = GetNearestObjectByTag("mti_quest_sombras_puerta");
  int iNivelPlacas = GetLocalInt(oMod, "QUEST_TEMPLO_SOMBRAS_NIVEL_PLACAS");
  int iActivadaPlaca1 = GetLocalInt(oPlaca1, "ACTIVADA");
  int iActivadaPlaca2 = GetLocalInt(oPlaca2, "ACTIVADA");
  int iActivadaPlaca3 = GetLocalInt(oPlaca3, "ACTIVADA");
  int iActivadaPlaca4 = GetLocalInt(oPlaca4, "ACTIVADA");
  int iActivadaPlaca5 = GetLocalInt(oPlaca5, "ACTIVADA");
  int iActivadaPlaca6 = GetLocalInt(oPlaca6, "ACTIVADA");
  int iActivadaPlaca7 = GetLocalInt(oPlaca7, "ACTIVADA");
  int iActivadaPlaca8 = GetLocalInt(oPlaca8, "ACTIVADA");
  int iActivadaPlaca9 = GetLocalInt(oPlaca9, "ACTIVADA");

  if(iActivadaPlaca1 == TRUE && iActivadaPlaca2 == TRUE && iActivadaPlaca3 == TRUE &&
     iActivadaPlaca4 == TRUE && iActivadaPlaca5 == TRUE && iActivadaPlaca6 == TRUE &&
     iActivadaPlaca7 == TRUE && iActivadaPlaca8 == TRUE && iActivadaPlaca9 == TRUE)
  {
      if(iNivelPlacas == 0)
      {
          SetLocalInt(oMod, "QUEST_TEMPLO_SOMBRAS_NIVEL_PLACAS", 1);
          SetLocalInt(oMod, "NO_PLACAS", TRUE);
          DelayCommand(2.0, DeleteLocalInt(oMod, "NO_PLACAS"));
          AssignCommand(oPedestal1, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
          ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_AURA_YELLOW), oPedestal1);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), oPC);
          FloatingTextStringOnCreature("<c´þd>* Un pedestal parece haberse activado *</c>", oPC);
          CreateObject(OBJECT_TYPE_PLACEABLE, "x3_plc_ylightm", GetLocation(oPedestal1), FALSE, "mti_quest_sombras_luz1");
          DelayCommand(2.0, PlacasAleatorias(oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("<c´þd>* La posición de las placas han cambiado *</c>", oPC));
      }
      else if(iNivelPlacas == 1)
      {
          SetLocalInt(oMod, "QUEST_TEMPLO_SOMBRAS_NIVEL_PLACAS", 2);
          SetLocalInt(oMod, "NO_PLACAS", TRUE);
          DelayCommand(2.0, DeleteLocalInt(oMod, "NO_PLACAS"));
          AssignCommand(oPedestal2, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
          ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_AURA_YELLOW), oPedestal2);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), oPC);
          FloatingTextStringOnCreature("<c´þd>* Un pedestal parece haberse activado *</c>", oPC);
          CreateObject(OBJECT_TYPE_PLACEABLE, "x3_plc_ylightm", GetLocation(oPedestal2), FALSE, "mti_quest_sombras_luz2");
          DelayCommand(2.0, PlacasAleatorias(oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("<c´þd>* La posición de las placas han cambiado *</c>", oPC));
      }
      else if(iNivelPlacas == 2)
      {
          SetLocalInt(oMod, "QUEST_TEMPLO_SOMBRAS_NIVEL_PLACAS", 3);
          SetLocalInt(oMod, "NO_PLACAS", TRUE);
          DelayCommand(2.0, DeleteLocalInt(oMod, "NO_PLACAS"));
          AssignCommand(oPedestal3, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
          ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_AURA_YELLOW), oPedestal3);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), oPC);
          FloatingTextStringOnCreature("<c´þd>* Un pedestal parece haberse activado *</c>", oPC);
          CreateObject(OBJECT_TYPE_PLACEABLE, "x3_plc_ylightm", GetLocation(oPedestal3), FALSE, "mti_quest_sombras_luz3");
          DelayCommand(2.0, PlacasAleatorias(oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("<c´þd>* La posición de las placas han cambiado *</c>", oPC));
      }
      else if(iNivelPlacas == 3)
      {
          SetLocalInt(oMod, "QUEST_TEMPLO_SOMBRAS_NIVEL_PLACAS", 4);
          AssignCommand(oPedestal4, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
          ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_AURA_YELLOW), oPedestal4);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), oPC);
          FloatingTextStringOnCreature("<c´þd>* Un pedestal parece haberse activado *</c>", oPC);
          CreateObject(OBJECT_TYPE_PLACEABLE, "x3_plc_ylightm", GetLocation(oPedestal4), FALSE, "mti_quest_sombras_luz4");
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_KNOCK), oPuerta);
          SetLocked(oPuerta, FALSE);
          DelayCommand(2.0, AssignCommand(oPuerta, ActionOpenDoor(oPuerta)));
          DelayCommand(2.0, FloatingTextStringOnCreature("<c´þd>* ¡La puerta central se ha abierto! *</c>", oPC));

          DelayCommand(100.0, Reseteo());
      }
  }
}
