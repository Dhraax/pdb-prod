//::///////////////////////////////////////////////
//:: OFICIO DE ESENCIACION, ON ACTIVATE
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
  1er Oficio de Artesania Urdimbrica.
  Extrae 120 esencias de criaturas y ubicados.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 19 de Agosto de 2013
//:://////////////////////////////////////////////

#include "sute_libreria"
#include "pb_ofi_artesa_i"
#include "lib_race"

int CalculoSiguienteNivelXPEsenciacion(int iNivelArtesano)
{
  return iNivelArtesano * (iNivelArtesano + 1) * 50;
}

void CristalesUrdimbricos(object oObjetivo, int iNivelOficio, int iValorDesafioCriatura)
{
  int iCreacion;
  string sCristal;

  if(iValorDesafioCriatura <= 5) sCristal = "pb_artesa_poten1";
  else if(iValorDesafioCriatura <= 10) sCristal = "pb_artesa_poten" + IntToString(Random(2)+1);
  else if(iValorDesafioCriatura <= 15) sCristal = "pb_artesa_poten" + IntToString(Random(3)+1);
  else if(iValorDesafioCriatura <= 20) sCristal = "pb_artesa_poten" + IntToString(Random(4)+1);
  else if(iValorDesafioCriatura <= 23) sCristal = "pb_artesa_poten" + IntToString(Random(3)+2);
  else if(iValorDesafioCriatura <= 26) sCristal = "pb_artesa_poten" + IntToString(Random(2)+3);
  else sCristal = "pb_artesa_poten4" ;

  if(sCristal == "pb_artesa_poten1")
  {
      if(iNivelOficio <= 15) iCreacion = 1;
      else if(iNivelOficio <= 50) iCreacion = d2();
      else iCreacion = d3();
  }
  else if(sCristal == "pb_artesa_poten2")
  {
      if(iNivelOficio <= 35) iCreacion = 1;
      else if(iNivelOficio <= 75) iCreacion = d2();
      else iCreacion = d3();
  }
  else if(sCristal == "pb_artesa_poten3")
  {
      if(iNivelOficio <= 60) iCreacion = 1;
      else if(iNivelOficio <= 90) iCreacion = d2();
      else iCreacion = d3();
  }
  else if(sCristal == "pb_artesa_poten4")
  {
      if(iNivelOficio <= 90) iCreacion = 1;
      else iCreacion = d2();
  }

  object oCristal;
  while(iCreacion > 0)
  {
      oCristal = CreateItemOnObject(sCristal, oObjetivo);
      SetDroppableFlag(oCristal, TRUE);
      iCreacion = iCreacion - 1;
  }
}

string ObtenerResrefEsencia(int iEstado)
{
  string sResRef;
  int iTirada;

  switch(iEstado)
  {
      case 1: // Luz, habilidad, Peso, Criticos masivos, Reforzado
      {
          iTirada = Random(63)+1;

          if(iTirada <= 15) sResRef = "pb_artesa_gemco" + IntToString(Random(7));
          else if(iTirada <= 40)
          {
              if(iTirada <= 22) sResRef = "pb_artesa_hab0" + IntToString(Random(10));
              else if(iTirada <= 28) sResRef = "pb_artesa_hab1" + IntToString(Random(9));
              else if(iTirada <= 38) sResRef = "pb_artesa_hab" + IntToString(Random(14)+20);
              else sResRef = "pb_artesa_hab3" + IntToString(Random(4)+5);
          }
          else if(iTirada <= 47) sResRef = "pb_artesa_peso";
          else if(iTirada <= 55) sResRef = "pb_artesa_cm";
          else sResRef = "pb_artesa_refor";
      } break;

      case 2: // [Limitacion de uso, Bonificador de CA contra alineamiento, Bonificador de ataque especifico, Bonificador de mejora especifico], Bonificador de salvacion especificos, Huecos de conjuro
      {
          iTirada = Random(55)+1;

          if(iTirada <= 15) sResRef = "pb_artesa_lim0" + IntToString(Random(5)+1);
          else if(iTirada <= 40)
          {
              if(iTirada <= 17) sResRef = "pb_artesa_sal201";
              else if(iTirada <= 25) sResRef = "pb_artesa_sal20" + IntToString(Random(7)+3);
              else sResRef = "pb_artesa_sal21" + IntToString(Random(5)+1);
          }
          else
          {
              if(iTirada <= 47) sResRef = "pb_artesa_clas0" + IntToString(Random(3)+1);
              else sResRef = "pb_artesa_clas0" + IntToString(Random(4)+6);
              if(sResRef == "pb_artesa_clas08") sResRef = "pb_artesa_clas10";
          }
      } break;

      case 3: // Bonificador de salvacion normales, [Resistencia al danyo, Bonificador de CA contra daño, Inmunidad al daño, Bonificador de daño], Reg.vampirica
      {
          iTirada = Random(47)+1;

          if(iTirada <= 15) sResRef = "pb_artesa_sal10" + IntToString(Random(3)+1);
          else if(iTirada <= 35)
          {
              if(iTirada <= 19) sResRef = "pb_artesa_dano0" + IntToString(Random(3));
              else if(iTirada <= 26) sResRef = "pb_artesa_dano0" + IntToString(Random(5)+5);
              else sResRef = "pb_artesa_dano1" + IntToString(Random(4));
          }
          else sResRef = "pb_artesa_rv";
      } break;

      case 4: // Vision en la oscuridad, Bonificador de ataque universal, Resistencia a conjuros,
      {
          iTirada = Random(26)+1;

          if(iTirada <= 6) sResRef = "pb_artesa_vo";
          else if(iTirada <= 16) sResRef = "pb_artesa_at";
          else sResRef = "pb_artesa_rc";

      } break;

      case 5: // Bonificador de CA, Bonificador de caracteristica, Reduccion de daño
      {
          iTirada = Random(32)+1;

          if(iTirada <= 10) sResRef = "pb_artesa_ca";
          else if(iTirada <= 22) sResRef = "pb_artesa_car" + IntToString(Random(6));
          else sResRef = "pb_artesa_rd";
      } break;

      case 6: // Bonificador de salvacion universal, Efectos al golpear, Bonificador de mejora universal
      {
          iTirada = Random(42)+1;

          if(iTirada <= 12) sResRef = "pb_artesa_sal200";
          else if(iTirada <= 30)
          {
              if(iTirada <= 17) sResRef = "pb_artesa_efe0" + IntToString(Random(4));
              else if(iTirada <= 21) sResRef = "pb_artesa_efe0" + IntToString(Random(3)+5);
              else if(iTirada <= 22) sResRef = "pb_artesa_efe09";
              else if(iTirada <= 25) sResRef = "pb_artesa_efe1" + IntToString(Random(3)+4);
              else if(iTirada <= 29) sResRef = "pb_artesa_efe" + IntToString(Random(3)+18);
              else sResRef = "pb_artesa_efe25";
          }
          else sResRef = "pb_artesa_mej";
      } break;

      case 7: // Lanzar conjuro, Inmunidad conjuro, Regeneracion
      {
          iTirada = Random(20)+1;

          if(iTirada <= 5) sResRef = "pb_artesa_reg";
          else sResRef = "pb_artesa_polvo" + IntToString(Random(8)+1);

      } break;

      case 8: // Inmunidad de conjuros por nivel, Municion infinita
      {
          iTirada = Random(10)+1;

          if(iTirada <= 5) sResRef = "pb_artesa_inconj";
          else sResRef = "pb_artesa_muni";
      } break;
  }

  return sResRef;
}

void Esencias(object oObjetivo, int iValorDesafioCriatura)
{
  string sEsencia;
  if(iValorDesafioCriatura <= 3) sEsencia = ObtenerResrefEsencia(1);
  else if(iValorDesafioCriatura <= 5) sEsencia = ObtenerResrefEsencia(d2());
  else if(iValorDesafioCriatura <= 8) sEsencia = ObtenerResrefEsencia(d3());
  else if(iValorDesafioCriatura <= 10) sEsencia = ObtenerResrefEsencia(d3()+1);
  else if(iValorDesafioCriatura <= 13) sEsencia = ObtenerResrefEsencia(d3()+2);
  else if(iValorDesafioCriatura <= 15) sEsencia = ObtenerResrefEsencia(d3()+3);
  else if(iValorDesafioCriatura <= 18) sEsencia = ObtenerResrefEsencia(d3()+4);
  else if(iValorDesafioCriatura <= 20) sEsencia = ObtenerResrefEsencia(d3()+5);
  else sEsencia = ObtenerResrefEsencia(d2()+6);

  object oEsencia = CreateItemOnObject(sEsencia, oObjetivo);
  SetDroppableFlag(oEsencia, TRUE);
}

void AnimacionEsenciacion(object oPC, object oObjetivo, string sMensaje, int iAnimacionFinal, int iEfectoFinal, int iRotura = FALSE)
{
  // Animaciones
  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 3.1));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 4.0);
  DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DESTRUCTION), oObjetivo));
  DelayCommand(2.0, AssignCommand(oPC, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamage(d2(), FloatToInt(pow(2.0, IntToFloat(d10())))), oObjetivo)));
  DelayCommand(2.0, AssignCommand(oObjetivo, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MIRV), oPC)));
  DelayCommand(2.5, AssignCommand(oObjetivo, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MIRV), oPC)));
  DelayCommand(3.0, AssignCommand(oObjetivo, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MIRV), oPC)));
  DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oPC));
  DelayCommand(3.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oPC));
  DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oPC));
  DelayCommand(4.4, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iEfectoFinal), oPC));
  if(iRotura == TRUE) DelayCommand(4.5, AssignCommand(OBJECT_SELF, PlaySound("as_cv_woodbreak2")));
  DelayCommand(4.6, AssignCommand(oPC, ActionPlayAnimation(iAnimacionFinal)));
  DelayCommand(5.0, SendMessageToPC(oPC, sMensaje));
}

void main()
{
  object oPC = GetItemActivator();
  object oObjeto = GetItemActivated();
  object oObjetivo = GetItemActivatedTarget();
  location lLocalizacionObjetivo = GetItemActivatedTargetLocation();
  int iValorDesafioCriatura = FloatToInt(GetChallengeRating(oObjetivo));

  // Nivel 1 necesario
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "Profesion8");
  if(iNivelHabilidad == 0)
  {
      SendMessageToPC(oPC, "<cþ<<>Deberías hablar con algún maestro de Artesanía Urdímbrica antes de usar esto.</c>");
      return;
  }

  // Solo 3ª esfera de conjuros
  if(ConjurosTerceraEsfera(oPC) == FALSE) return;

  // Objetivo ubicado (herencia de esencias)
  object oMaestro1 = GetMaster(oObjetivo);
  object oMaestro2 = GetMaster(GetMaster(oObjetivo));
  object oMaestro3 = GetMaster(GetMaster(GetMaster(oObjetivo)));
  int iEsUbicado, iEsencias;
  string sEsInfra;
  if(GetObjectType(oObjetivo) == OBJECT_TYPE_PLACEABLE)
  {
      iEsUbicado = GetLocalInt(oObjetivo, "Tipo");
      if(iEsUbicado > 0)
      {
          iEsencias = GetLocalInt(oObjetivo, "Esencias");
          if(iEsencias > 0) iValorDesafioCriatura = iEsUbicado * 2;
          else
          {
              sEsInfra = GetLocalString(oObjetivo, "EsInfra");
              if(sEsInfra == "S") AnimacionEsenciacion(oPC, oObjetivo, "<cþ<<>El nodo de tierra está agotado.</c>", ANIMATION_FIREFORGET_TAUNT, 81);
              else AnimacionEsenciacion(oPC, oObjetivo, "<cþ<<>La fuente de esencia está agotada.</c>", ANIMATION_FIREFORGET_TAUNT, 81);
              return;
          }
      }
      else
      {
          SendMessageToPC(oPC, "<cþ<<>El objetivo debe ser una criatura hostil o una fuente de esencias válida.</c>");
          return;
      }
  }

  // El objetivo debe ser una criatura valida
  else if(GetObjectType(oObjetivo) != OBJECT_TYPE_CREATURE || GetIsPC(oObjetivo) || GetPlotFlag(oObjetivo) || GetCurrentHitPoints(oObjetivo) < 1 || !GetIsEnemy(oObjetivo, oPC))
  {
      SendMessageToPC(oPC, "<cþ<<>El objetivo debe ser una criatura hostil, viva y que no sea de trama o una fuente de esencias válida.</c>");
      return;
  }

  // Criaturas convocadas no
  if(GetObjectType(oObjetivo) == OBJECT_TYPE_CREATURE)
  {
      if((GetIsObjectValid(oMaestro1) == TRUE && GetIsPC(oMaestro1) == TRUE) ||
         (GetIsObjectValid(oMaestro2) == TRUE && GetIsPC(oMaestro2) == TRUE) ||
         (GetIsObjectValid(oMaestro3) == TRUE && GetIsPC(oMaestro3) == TRUE))
      {
          SendMessageToPC(oPC, "<cþ<<>El objetivo no puede ser una criatura dependiente de un jugador.</c>");
          return;
      }
  }

  // El objetivo no se le puede extraer esencias dos veces
  if(GetLocalInt(oObjetivo, "OFI_ESENCIACION_NOSPAM"))
  {
      AnimacionEsenciacion(oPC, oObjetivo, "<cþ<<>El objetivo no tiene más esencias.</c>", ANIMATION_FIREFORGET_TAUNT, 81);
      return;
  }

  // Disipacion de la invisibilidad
  effect eBad = GetFirstEffect(oPC);
  while(GetIsEffectValid(eBad))
  {
      if(GetEffectType(eBad) == EFFECT_TYPE_ETHEREAL ||
         GetEffectType(eBad) == EFFECT_TYPE_IMPROVEDINVISIBILITY ||
         GetEffectType(eBad) == EFFECT_TYPE_INVISIBILITY ||
         GetEffectType(eBad) == EFFECT_TYPE_SANCTUARY)
      {
          RemoveEffect(oPC, eBad);
      }

      eBad = GetNextEffect(oPC);
  }

  // Usos de la varita esenciadora
  int iLesion = FALSE;
  int iUsosVarita = GetLocalInt(oObjeto, "USOS");
  if(iUsosVarita == 0)SetLocalInt(oObjeto, "USOS", 20 + d6());
  else if(iUsosVarita == 1)
  {
      AnimacionEsenciacion(oPC, oObjetivo, "<cþ<<>¡La varita esenciadora se rompió!</c>", ANIMATION_FIREFORGET_TAUNT, 81, TRUE);
      DelayCommand(5.5, PlayVoiceChat(VOICE_CHAT_CUSS, oPC));
      DestroyObject(oObjeto, 5.5);
      iLesion = TRUE;
  }
  else SetLocalInt(oObjeto, "USOS", iUsosVarita - 1);

  // Lesiones
  int iDadoCien = d100();
  if(iDadoCien <= 3 && iLesion == FALSE)
  {
      if(iDadoCien == 1) // Explosion de fuego
      {
          DelayCommand(5.1, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIREBALL), GetLocation(oPC)));
          DelayCommand(5.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d8(3), DAMAGE_TYPE_FIRE), oPC));
          AnimacionEsenciacion(oPC, oObjetivo, "<cþ<<>¡La esencia era muy inestable y explotó!</c>", ANIMATION_LOOPING_DEAD_BACK, 81);
          iLesion = TRUE;
      }
      else if(iDadoCien == 2) // Grito ensordecedor
      {
          DelayCommand(5.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_MIND), oPC));
          DelayCommand(5.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oPC, 200.0));
          DelayCommand(5.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSilence(), oPC, 200.0));
          DelayCommand(5.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 10.0));
          DelayCommand(5.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oPC, 30.0));
          AnimacionEsenciacion(oPC, oObjetivo, "<cþ<<>¡La esencia se resiste a ser extraída provocando un grito ensordecedor!</c>", ANIMATION_FIREFORGET_TAUNT, 81);
          iLesion = TRUE;
      }
      else // Debilitacion magica
      {
          DelayCommand(5.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(80), oPC));
          DelayCommand(5.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_INTELLIGENCE, d4(2)), oPC, 400.0));
          DelayCommand(5.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNegativeLevel(d2(), TRUE), oPC, 400.0));
          DelayCommand(5.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCurse(d3(), d3(), d3(), d3(), d3(), d3()), oPC, 400.0));
          AnimacionEsenciacion(oPC, oObjetivo, "<cþ<<>¡La esencia se resiste a ser extraída y drena tus energías!</c>", ANIMATION_FIREFORGET_TAUNT, 81);
          iLesion = TRUE;
      }
  }

  // Tirada de exito
  string sCaracteristica = GetLocalString(oPC, "ARTESA_CARACTERISTICA");
  int iBonoCaracteristica = GetLocalInt(oPC, "ARTESA_CARACTERISTICA_PUNT");
  int iRaza = GetRacialType(oPC);
  int iDificultad = 50 + (iValorDesafioCriatura * 20);
  int iDificultadBase = iDificultad;
  int iXPExito = iNivelHabilidad + d6(iNivelHabilidad);
  int iXPFracaso = iXPExito / 10;
  int iBonusRacial, iXP;
  iDadoCien = d100();

  if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = 10;
  else if(PB_Race_GetIsElf(oPC)) iBonusRacial = 8;
  else if(PB_Race_GetIsUndead(oPC) || iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = 6;
  else if(iRaza == RACIAL_TYPE_HUMANOID_GOBLINOID || iRaza == RACIAL_TYPE_HUMANOID_REPTILIAN) iBonusRacial = 4;
  else if(iRaza == RACIAL_TYPE_OUTSIDER || iRaza == RACIAL_TYPE_SHAPECHANGER || iRaza == RACIAL_TYPE_HUMAN || PB_Race_GetIsHalfling(oPC)) iBonusRacial = 2;
  else if(iRaza == RACIAL_TYPE_DWARF || iRaza == RACIAL_TYPE_HALFORC) iBonusRacial = 1;

  int iSumaBonos =          iDadoCien + iBonoCaracteristica + iBonusRacial + iNivelHabilidad*4;
  int iResistencia = iDificultad - (1 + iBonoCaracteristica + iBonusRacial + iNivelHabilidad*4);
  int iPorcentaje =              (101 + iBonoCaracteristica + iBonusRacial + iNivelHabilidad*4) - iDificultad;

  if(iPorcentaje > 66) // Minimo 33% de resistencia
  {
      iDificultad = iDificultad + (iPorcentaje - 66);
      iResistencia = 33;
      iPorcentaje = 66;
  }
  else if(iPorcentaje <= 0)
  {
      iXPFracaso = 0;
      iResistencia = 100;
      iPorcentaje = 0;
  }

  SendMessageToPC(oPC, "<c›þþ>Extrayendo esencia de " + GetName(oObjetivo) + "...</c>");
  //SendMessageToPC(oPC, "<cþ>Dado:</c> <c´þd>" + IntToString(iDadoCien) + "</c>");
  SendMessageToPC(oPC, "<cþ>Tirada:</c> <cÍþ><c´þd>1d100 + " + IntToString(iBonoCaracteristica) + "</c> ("+sCaracteristica+") <c´þd>+ " + IntToString(iBonusRacial) + "</c> (Raza) <c´þd>+ " + IntToString(iNivelHabilidad*4) + "</c> (Nivel Oficio)</c>");
  SendMessageToPC(oPC, "<cþ>Dificultad:</c> <c´þd>" + IntToString(iDificultadBase) + "</c>");
  SendMessageToPC(oPC, "<cþ>Resistencia a la esenciación:</c> <c´þd>" + IntToString(iResistencia) + "%</c>");

  if(iLesion == TRUE) return;

  if(iSumaBonos >= iDificultad)
  {
      AnimacionEsenciacion(oPC, oObjetivo, "<c´þd>¡ÉXITO! Esencia correctamente extraída.", ANIMATION_FIREFORGET_VICTORY1, 55);
      iXP = iXPExito;
      if(iEsUbicado == 0) SetLocalInt(oObjetivo, "OFI_ESENCIACION_NOSPAM", TRUE);

      if(iNivelHabilidad > (iValorDesafioCriatura * 5) || GetObjectType(oObjetivo) == OBJECT_TYPE_PLACEABLE)
      {
          DelayCommand(5.0, CristalesUrdimbricos(oPC, iNivelHabilidad, iValorDesafioCriatura));
          DelayCommand(5.0, Esencias(oPC, iValorDesafioCriatura));
      }
      else
      {
          DelayCommand(5.0, CristalesUrdimbricos(oObjetivo, iNivelHabilidad, iValorDesafioCriatura));
          DelayCommand(5.0, Esencias(oObjetivo, iValorDesafioCriatura));
      }
  }
  else
  {
      AnimacionEsenciacion(oPC, oObjetivo, "<cþ<<>¡FRACASO! No lograste extraer la esencia.</c>", ANIMATION_FIREFORGET_TAUNT, 81);
      iXP = iXPFracaso;
  }

  if(iEsUbicado > 0)
  {
      SetLocalInt(oObjetivo, "Esencias", iEsencias - 1);
      if((iEsencias - 1) == 0) DelayCommand(1800.0, SetLocalInt(oObjetivo, "Esencias", 4));
  }

  // XP y limitaciones
  int iNivelPJ = GetHitDice(oPC);
  if(iNivelPJ <= 5 && iNivelHabilidad == 25) DelayCommand(5.8, FloatingTextStringOnCreature("<cþ<<>No puedes subir más experiencia en este oficio siendo nivel 5 o menos.</c>", oPC, FALSE));
  else if(iNivelPJ <= 10 && iNivelHabilidad == 50) DelayCommand(5.8, FloatingTextStringOnCreature("<cþ<<>No puedes subir más experiencia en este oficio siendo nivel 10 o menos.</c>", oPC, FALSE));
  else if(iNivelPJ <= 15 && iNivelHabilidad == 75) DelayCommand(5.8, FloatingTextStringOnCreature("<cþ<<>No puedes subir más experiencia en este oficio siendo nivel 15 o menos.</c>", oPC, FALSE));
  else if(iPorcentaje < 60 && iNivelHabilidad < 100)
  {
      int iXPEsenciacion = ObtenerIntPersistente(oPC, "Profesion8XP");
      int iXPSigNivel = CalculoSiguienteNivelXPEsenciacion(iNivelHabilidad);

      DelayCommand(5.5, AssignCommand(oPC, ClearAllActions(TRUE)));
      DelayCommand(5.6, AssignCommand(oPC, PlaySound("gui_journaladd")));
      DelayCommand(5.7, GuardarIntPersistente(oPC, "Profesion8XP", iXPEsenciacion + iXP));
      DelayCommand(5.8, FloatingTextStringOnCreature("<c´þd>+"+IntToString(iXP)+" XP de Esenciación</c>", oPC, FALSE));

      if(iXPEsenciacion + iXP >= iXPSigNivel)
      {
          int iNivelesSubidosDeGolpe = 1;
          while(iXPEsenciacion + iXP > CalculoSiguienteNivelXPEsenciacion(iNivelHabilidad+iNivelesSubidosDeGolpe))
          {
              iNivelesSubidosDeGolpe = iNivelesSubidosDeGolpe + 1;
          }

          int iNuevoNivelHabilidad = iNivelHabilidad + iNivelesSubidosDeGolpe;
          if(iNivelPJ <= 5 && iNuevoNivelHabilidad > 25) iNuevoNivelHabilidad = 25;
          else if(iNivelPJ <= 10 && iNuevoNivelHabilidad > 50) iNuevoNivelHabilidad = 50;
          else if(iNivelPJ <= 15 && iNuevoNivelHabilidad > 75) iNuevoNivelHabilidad = 75;
          else if(iNuevoNivelHabilidad > 100) iNuevoNivelHabilidad = 100;

          DelayCommand(8.4, AssignCommand(oPC, ClearAllActions(TRUE)));
          DelayCommand(8.5, AssignCommand(oPC, PlaySound("gui_level_up")));
          DelayCommand(8.6, FloatingTextStringOnCreature("<c þ >¡Has subido al nivel "+IntToString(iNuevoNivelHabilidad)+" de Esenciación!</c>", oPC, FALSE));
          DelayCommand(8.8, GuardarIntPersistente(oPC, "Profesion8", iNuevoNivelHabilidad));

          int iXPReal = ((iNivelHabilidad + 1)/2) * iNivelesSubidosDeGolpe;
          DelayCommand(8.7, SetXP(oPC, GetXP(oPC) + iXPReal));
      }
  }
}
