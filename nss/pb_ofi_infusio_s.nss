//::///////////////////////////////////////////////
//:: OFICIO DE INFUSIONAMIENTO, ON SPELL CAST
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
  2º Oficio de Artesania Urdimbrica.
  Se coloca en el evento OnSpellCast de la mesa de infusionamiento.
  Oficio especial para implementar cargas/uso de conjuros en el tercer
  oficio.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 19 de Agosto de 2013
//:://////////////////////////////////////////////

#include "sute_libreria"
#include "pb_ofi_artesa_i"
#include "lib_race"

int CalculoSiguienteNivelXPInfusionamiento(int iNivelArtesano)
{
  return iNivelArtesano * (iNivelArtesano + 1) * 75;
}

void AnimacionInfusionamiento(object oPC, string sMensaje, int iAnimacionFinal, int iEfectoFinal)
{
  object oArea = GetArea(OBJECT_SELF);
  vector vPosition = GetPosition(OBJECT_SELF);
  float fOrientation = GetFacing(OBJECT_SELF);

  location myLocation = Location(oArea, vPosition + Vector(0.0, 0.0, 1.0), fOrientation);
  object oUbicadoInvisible = CreateObject(OBJECT_TYPE_PLACEABLE, "nonstaticinvis", myLocation);

  SetLocked(OBJECT_SELF, TRUE);
  SetLockKeyRequired(OBJECT_SELF, TRUE);
  SetLockKeyTag(OBJECT_SELF, "xxxx");
  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 8.5));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 9.3);
  DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_FIRE_LASH, oUbicadoInvisible, BODY_NODE_CHEST), oPC, 8.5));
  DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(194 + Random(11)), myLocation));
  DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
  DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(194 + Random(11)), myLocation));
  DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
  DelayCommand(6.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
  DelayCommand(6.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(257 + Random(6)), myLocation));
  DelayCommand(8.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
  DelayCommand(8.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(257 + Random(6)), myLocation));
  DelayCommand(10.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(iEfectoFinal), myLocation));
  DelayCommand(10.0, AssignCommand(oPC, ActionPlayAnimation(iAnimacionFinal)));
  DelayCommand(10.0, DeleteLocalInt(OBJECT_SELF, "ANTI_SPAM"));
  DelayCommand(10.5, SendMessageToPC(oPC, sMensaje));
  DelayCommand(10.5, SetLockKeyTag(OBJECT_SELF, ""));
  DelayCommand(10.5, SetLockKeyRequired(OBJECT_SELF, FALSE));
  DelayCommand(10.5, SetLocked(OBJECT_SELF, FALSE));
  DestroyObject(oUbicadoInvisible, 7.6);
}

void DestruirTodo(object oAguaPuraGuardada, object oVialGuardado, object oPolvoGuardado)
{
  DestroyObject(oAguaPuraGuardada);
  DestroyObject(oVialGuardado);

  // Usos del polvo
  int iUsosPolvo = GetLocalInt(oPolvoGuardado, "USOS");
  if(iUsosPolvo == 0) SetLocalInt(oPolvoGuardado, "USOS", 2 + d4());
  else if(iUsosPolvo == 1) DestroyObject(oPolvoGuardado);
  else SetLocalInt(oPolvoGuardado, "USOS", iUsosPolvo - 1);
}

void main()
{
  object oPC = GetLastSpellCaster();
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "Profesion11");

  // Nivel 1 necesario
  if(iNivelHabilidad == 0)
  {
      SendMessageToPC(oPC, "<cþ<<>Deberías hablar con algún maestro de Artesanía Urdímbrica antes de usar esto.</c>");
      return;
  }

  // Solo 3ª esfera de conjuros
  if(ConjurosTerceraEsfera(oPC) == FALSE) return;

  // Ciertos conjuros no se pueden infusionar (Zancada arbórea)
  int iConjuro = GetLastSpell();
  if(iConjuro == 994)
  {
      SendMessageToPC(oPC, "<cþ<<>Este conjuro no es admitido por el oficio.</c>");
      return;
  }

  int iContadorAguaPura = 0;
  int iContadorViales  = 0;
  int iContadorPolvos  = 0;
  object oAguaPuraGuardada;
  object oVialGuardado;
  object oPolvoGuardado;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "sute_her_DM1") { iContadorAguaPura = iContadorAguaPura + 1; oAguaPuraGuardada = oComponente; }
      else if(sEtiquetaComponente == "pb_artesa_vial") { iContadorViales = iContadorViales + 1; oVialGuardado = oComponente; }
      else if(GetStringLeft(GetTag(oComponente), 15) == "pb_artesa_polvo") { iContadorPolvos = iContadorPolvos + 1; oPolvoGuardado = oComponente; }

      oComponente = GetNextItemInInventory();
  }

  // Si hay 0 o mas de un agua pura, nanay...
  if(iContadorAguaPura == 0 || iContadorAguaPura > 1)
  {
      SendMessageToPC(oPC, "<cþ<<>Debe de haber una única agua pura sobre la mesa.</c>");
      return;
  }

  // Si hay 0 o mas de un vial, nanay...
  if(iContadorViales == 0 || iContadorViales > 1)
  {
      SendMessageToPC(oPC, "<cþ<<>Debe de haber un único vial para conjuro sobre la mesa.</c>");
      return;
  }

  // Si hay 0 o mas de un polvo, nanay...
  if(iContadorPolvos == 0 || iContadorPolvos > 1)
  {
      SendMessageToPC(oPC, "<cþ<<>Debe de haber un único polvo de escuela de magia sobre la mesa.</c>");
      return;
  }

  /*if((iContadorAguaPura + iContadorViales + iContadorPolvos) > 3)
  {
      SendMessageToPC(oPC, "<cþ<<>Hay objetos de más que molestan en la mesa.</c>");
      return;
  } Redundante */

  // Datos del conjuro
  int iConjuroMaestro, iEsferaConjuro;
  string sIDNombreConjuro, sEscuelaMagiaConjuroLanzado;
  string sConjuroMaestro = Get2DAString("spells", "Master", iConjuro);
  if(sConjuroMaestro != "") // Fix para los subconjuros
  {
      iConjuroMaestro = StringToInt(sConjuroMaestro);
      iEsferaConjuro = StringToInt(Get2DAString("spells", "Innate", iConjuroMaestro));
      sIDNombreConjuro = Get2DAString("spells", "Name", iConjuroMaestro);
      sEscuelaMagiaConjuroLanzado = Get2DAString("spells", "School", iConjuroMaestro);
  }
  else
  {
      iEsferaConjuro = StringToInt(Get2DAString("spells", "Innate", iConjuro));;
      sIDNombreConjuro = Get2DAString("spells", "Name", iConjuro);
      sEscuelaMagiaConjuroLanzado = Get2DAString("spells", "School", iConjuro);
  }

  string sNombreConjuro = GetStringByStrRef(StringToInt(sIDNombreConjuro));

  // Si el conjuro lanzado no corresponde con la escuela de magia del polvo
  // A = Abjuration, C = Conjuration, D = Divination, E = Enchantment, V = Evocation, I = Illusion, N = Necromancy, T = Transmutation
  string sEscuelaMagiaPolvo = GetStringRight(GetTag(oPolvoGuardado), 1);
  int iErrorEscuela = FALSE;

       if(sEscuelaMagiaConjuroLanzado == "A" && sEscuelaMagiaPolvo != "1") iErrorEscuela = TRUE;
  else if(sEscuelaMagiaConjuroLanzado == "C" && sEscuelaMagiaPolvo != "2") iErrorEscuela = TRUE;
  else if(sEscuelaMagiaConjuroLanzado == "D" && sEscuelaMagiaPolvo != "3") iErrorEscuela = TRUE;
  else if(sEscuelaMagiaConjuroLanzado == "E" && sEscuelaMagiaPolvo != "4") iErrorEscuela = TRUE;
  else if(sEscuelaMagiaConjuroLanzado == "V" && sEscuelaMagiaPolvo != "5") iErrorEscuela = TRUE;
  else if(sEscuelaMagiaConjuroLanzado == "I" && sEscuelaMagiaPolvo != "6") iErrorEscuela = TRUE;
  else if(sEscuelaMagiaConjuroLanzado == "N" && sEscuelaMagiaPolvo != "7") iErrorEscuela = TRUE;
  else if(sEscuelaMagiaConjuroLanzado == "T" && sEscuelaMagiaPolvo != "8") iErrorEscuela = TRUE;

  if(iErrorEscuela == TRUE)
  {
      SendMessageToPC(oPC, "<cþ<<>El polvo de la mesa no corresponde a la escuela de magia del conjuro lanzado.</c>");
      return;
  }

  // No más conjuros de 5ª esfera
  if(iEsferaConjuro > 5)
  {
      SendMessageToPC(oPC, "<cþ<<>Los viales sólo admiten conjuros de 5ª esfera o inferior.</c>");
      return;
  }

  // Conjuros de 4ª esfera piden soltura con la escuela de magia correspondiente
  // Conjuros de 5ª esfera piden soltura mayor con la escuela de magia correspondiente
  // Ademas cada vial tiene una apariencia distintia segun la escuela
  int iSoltura, iSolturaMayor, iApariencia;
  int iErrorDote1 = FALSE;
  int iErrorDote2 = FALSE;
  switch(StringToInt(sEscuelaMagiaPolvo))
  {
      case 1: { iSoltura = FEAT_SPELL_FOCUS_ABJURATION;    iSolturaMayor = FEAT_GREATER_SPELL_FOCUS_ABJURATION;    iApariencia = 11; } break;
      case 2: { iSoltura = FEAT_SPELL_FOCUS_CONJURATION;   iSolturaMayor = FEAT_GREATER_SPELL_FOCUS_CONJURATION;   iApariencia = 8;  } break;
      case 3: { iSoltura = FEAT_SPELL_FOCUS_DIVINATION;    iSolturaMayor = FEAT_GREATER_SPELL_FOCUS_DIVINATION;    iApariencia = 12; } break;
      case 4: { iSoltura = FEAT_SPELL_FOCUS_ENCHANTMENT;   iSolturaMayor = FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT;   iApariencia = 16; } break;
      case 5: { iSoltura = FEAT_SPELL_FOCUS_EVOCATION;     iSolturaMayor = FEAT_GREATER_SPELL_FOCUS_EVOCATION;     iApariencia = 14; } break;
      case 6: { iSoltura = FEAT_SPELL_FOCUS_ILLUSION;      iSolturaMayor = FEAT_GREATER_SPELL_FOCUS_ILLUSION;      iApariencia = 13; } break;
      case 7: { iSoltura = FEAT_SPELL_FOCUS_NECROMANCY;    iSolturaMayor = FEAT_GREATER_SPELL_FOCUS_NECROMANCY;    iApariencia = 15; } break;
      case 8: { iSoltura = FEAT_SPELL_FOCUS_TRANSMUTATION; iSolturaMayor = FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION; iApariencia = 10; } break;
  }

       if(iEsferaConjuro == 4 && !GetHasFeat(iSoltura, oPC))      iErrorDote1 = TRUE;
  else if(iEsferaConjuro == 5 && !GetHasFeat(iSolturaMayor, oPC)) iErrorDote2 = TRUE;

  if(iErrorDote1 == TRUE)
  {
      SendMessageToPC(oPC, "<cþ<<>Necesitas la soltura a la escuela de magia correspondiente para infusionar este conjuro.</c>");
      return;
  }
  else if(iErrorDote2 == TRUE)
  {
      SendMessageToPC(oPC, "<cþ<<>Necesitas la soltura mayor a la escuela de magia correspondiente para infusionar este conjuro.</c>");
      return;
  }

  // Lesiones
  int iLesion = FALSE;
  int iDadoCien = d100();
  if(iDadoCien <= 3)
  {
      DelayCommand(10.0, DestruirTodo(oAguaPuraGuardada, oVialGuardado, oPolvoGuardado));

      if(iDadoCien == 1) // Toxicidad
      {
          DelayCommand(10.6, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POISON_L), GetLocation(oPC)));
          DelayCommand(10.7, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPC) - d20(), DAMAGE_TYPE_ACID), oPC));
          AnimacionInfusionamiento(oPC, "<cþ<<>¡La infusión expulsa un vapor tóxico mortal!</c>", ANIMATION_LOOPING_DEAD_BACK, 81);
          iLesion = TRUE;
      }
      else if(iDadoCien == 2) // Vapor somnoliento
      {
          DelayCommand(10.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oPC));
          DelayCommand(10.7, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSleep(), oPC, 60.0));
          AnimacionInfusionamiento(oPC, "<cþ<<>¡La infusión expulsa un vapor somnoliento!</c>", ANIMATION_FIREFORGET_TAUNT, 81);
          iLesion = TRUE;
      }
      else // Petrificacion
      {
          DelayCommand(10.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(80), oPC));
          DelayCommand(10.7, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPetrify(), oPC, 60.0));
          AnimacionInfusionamiento(oPC, "<cþ<<>¡La infusión explota provocando daños mágicos!</c>", ANIMATION_FIREFORGET_TAUNT, 81);
          iLesion = TRUE;
      }
  }

  // Tirada de exito
  string sCaracteristica = GetLocalString(oPC, "ARTESA_CARACTERISTICA");
  int iBonoCaracteristica = GetLocalInt(oPC, "ARTESA_CARACTERISTICA_PUNT");
  int iRaza = GetRacialType(oPC);
  int iDificultad = 50 + (iEsferaConjuro * 20);
  int iDificultadBase = iDificultad;
  int iXPExito = iNivelHabilidad + d10(iNivelHabilidad);
  int iXPFracaso = iXPExito / 10;
  int iBonusRacial, iXP;
  iDadoCien = d100();

  if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = 10;
  else if(PB_Race_GetIsElf(oPC)) iBonusRacial = 8;
  else if(PB_Race_GetIsUndead(oPC) || iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = 6;
  else if(iRaza == RACIAL_TYPE_HUMANOID_GOBLINOID || iRaza == RACIAL_TYPE_HUMANOID_REPTILIAN) iBonusRacial = 4;
  else if(iRaza == RACIAL_TYPE_OUTSIDER || iRaza == RACIAL_TYPE_SHAPECHANGER || iRaza == RACIAL_TYPE_HUMAN || PB_Race_GetIsHalfling(oPC)) iBonusRacial = 2;
  else if(iRaza == RACIAL_TYPE_DWARF || iRaza == RACIAL_TYPE_HALFORC) iBonusRacial = 1;

  int iSumaBonos =  iDadoCien + iBonoCaracteristica + iBonusRacial + iNivelHabilidad;
  int iPorcentaje =      (101 + iBonoCaracteristica + iBonusRacial + iNivelHabilidad) - iDificultad;

  if(iPorcentaje > 66) // Minimo 33% de resistencia
  {
      iDificultad = iDificultad + (iPorcentaje - 66);
      iPorcentaje = 66;
  }
  else if(iPorcentaje <= 0)
  {
      iXPFracaso = 0;
      iPorcentaje = 0;
  }

  SendMessageToPC(oPC, "<c›þþ>Creando infusión de "+sNombreConjuro+"...</c>");
  //SendMessageToPC(oPC, "<cþ>Dado:</c> <c´þd>" + IntToString(iDadoCien) + "</c>");
  SendMessageToPC(oPC, "<cþ>Tirada:</c> <cÍþ><c´þd>1d100 + " + IntToString(iBonoCaracteristica) + "</c> ("+sCaracteristica+") <c´þd>+ " + IntToString(iBonusRacial) + "</c> (Raza) <c´þd>+ " + IntToString(iNivelHabilidad) + "</c> (Nivel Oficio)</c>");
  SendMessageToPC(oPC, "<cþ>Dificultad:</c> <c´þd>" + IntToString(iDificultadBase) + "</c>");
  SendMessageToPC(oPC, "<cþ>Probabilidad de éxito:</c> <c´þd>" + IntToString(iPorcentaje) + "%</c>");

  if(iLesion == TRUE) return;

  if(iSumaBonos >= iDificultad)
  {
      AnimacionInfusionamiento(oPC, "<c´þd>¡ÉXITO! Infusión creada.", ANIMATION_FIREFORGET_VICTORY1, 55);
      iXP = iXPExito;

      // Creacion vial, nombre, descripcion y variables
      object oObjeto = CopyItemAndModify(oVialGuardado, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM, iApariencia);
      SetName(oObjeto,"Infusión de " + sNombreConjuro);
      SetDescription(oObjeto,"Infusión de " + sNombreConjuro +". Esta infusión puede ser usada para conferir habilidades a otros objetos relacionadas con el conjuro.",FALSE);
      SetDescription(oObjeto,"Infusión de " + sNombreConjuro +". Esta infusión puede ser usada para conferir habilidades a otros objetos relacionadas con el conjuro.",TRUE);
      SetLocalString(oObjeto, "OFI_INFUSION_ESCUELA", sEscuelaMagiaConjuroLanzado);
      SetLocalInt(oObjeto, "OFI_INFUSION_CONJURO", iConjuro);
      SetLocalInt(oObjeto, "OFI_INFUSION_ESFERA", iEsferaConjuro);

      // Calculo oro venta
      int iAumentoOroVenta = 100 * iEsferaConjuro;
      if(iAumentoOroVenta == 0) iAumentoOroVenta = 50;
      SetLocalInt(oObjeto, "ARTESANIA_VENTA", iAumentoOroVenta + iNivelHabilidad + d20());
  }
  else
  {
      AnimacionInfusionamiento(oPC, "<cþ<<>¡FRACASO! No lograste crear la infusión.</c>", ANIMATION_FIREFORGET_TAUNT, 81);
      iXP = iXPFracaso;
  }

  // XP y limitaciones
  int iNivelPJ = GetHitDice(oPC);
  if(iNivelPJ <= 5 && iNivelHabilidad == 25) DelayCommand(11.3, FloatingTextStringOnCreature("<cþ<<>No puedes subir más experiencia en este oficio siendo nivel 5 o menos.</c>", oPC, FALSE));
  else if(iNivelPJ <= 10 && iNivelHabilidad == 50) DelayCommand(11.3, FloatingTextStringOnCreature("<cþ<<>No puedes subir más experiencia en este oficio siendo nivel 10 o menos.</c>", oPC, FALSE));
  else if(iNivelPJ <= 15 && iNivelHabilidad == 75) DelayCommand(11.3, FloatingTextStringOnCreature("<cþ<<>No puedes subir más experiencia en este oficio siendo nivel 15 o menos.</c>", oPC, FALSE));
  else if(iPorcentaje < 60 && iNivelHabilidad < 100)
  {
      int iXPInfusion = ObtenerIntPersistente(oPC, "Profesion11XP");
      int iXPSigNivel = CalculoSiguienteNivelXPInfusionamiento(iNivelHabilidad);

      DelayCommand(11.0, AssignCommand(oPC, ClearAllActions(TRUE)));
      DelayCommand(11.1, AssignCommand(oPC, PlaySound("gui_journaladd")));
      DelayCommand(11.2, GuardarIntPersistente(oPC, "Profesion11XP", iXPInfusion + iXP));
      DelayCommand(11.3, FloatingTextStringOnCreature("<c´þd>+"+IntToString(iXP)+" XP de Infusión</c>", oPC, FALSE));

      if(iXPInfusion + iXP >= iXPSigNivel)
      {
          int iNivelesSubidosDeGolpe = 1;
          while(iXPInfusion + iXP > CalculoSiguienteNivelXPInfusionamiento(iNivelHabilidad+iNivelesSubidosDeGolpe))
          {
              iNivelesSubidosDeGolpe = iNivelesSubidosDeGolpe + 1;
          }

          int iNuevoNivelHabilidad = iNivelHabilidad + iNivelesSubidosDeGolpe;
          if(iNivelPJ <= 5 && iNuevoNivelHabilidad > 25) iNuevoNivelHabilidad = 25;
          else if(iNivelPJ <= 10 && iNuevoNivelHabilidad > 50) iNuevoNivelHabilidad = 50;
          else if(iNivelPJ <= 15 && iNuevoNivelHabilidad > 75) iNuevoNivelHabilidad = 75;
          else if(iNuevoNivelHabilidad > 100) iNuevoNivelHabilidad = 100;

          DelayCommand(13.9, AssignCommand(oPC, ClearAllActions(TRUE)));
          DelayCommand(14.0, AssignCommand(oPC, PlaySound("gui_level_up")));
          DelayCommand(14.1, FloatingTextStringOnCreature("<c þ >¡Has subido al nivel "+IntToString(iNuevoNivelHabilidad)+" de Infusión!</c>", oPC, FALSE));
          DelayCommand(14.3, GuardarIntPersistente(oPC, "Profesion11", iNuevoNivelHabilidad));

          int iXPReal = ((iNivelHabilidad + 1)/2) * iNivelesSubidosDeGolpe;
          DelayCommand(14.2, SetXP(oPC, GetXP(oPC) + iXPReal));
      }
  }

  // Destruir todo menos la infusion creada
  DelayCommand(10.0, DestruirTodo(oAguaPuraGuardada, oVialGuardado, oPolvoGuardado));
}
