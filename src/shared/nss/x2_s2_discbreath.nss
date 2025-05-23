//::///////////////////////////////////////////////
//:: Breath Weapon for Dragon Disciple Class
//:: x2_s2_discbreath
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*
  Damage Type y Saves segun el tipo de dragon que eres
  Shape is cone, 30' == 10m

  Level      Damage
  -------------------
  3          2d8
  7          4d8
  10         6d8

  after 10:
  damage: 6d8 + 2d6 per 3 levels after 10
  savedc: 10 + nivel discipulo de dragon + bonificador de con

  ID     Label                        Aliento / Inmunidad              Alas
  1330   DiscipuloDragonAzul         Electrico                        67
  1331   DiscipuloDragonBlanco       Frio                             64
  1332   DiscipuloDragonNegro        Acido                            65
  1333   DiscipuloDragonRojo         Fuego                            68
  1334   DiscipuloDragonVerde        Acido                            66
  1335   DiscipuloDragonArgenteo     Frio                             62
  1336   DiscipuloDragonBronce       Electrico                        60
  1337   DiscipuloDragonCobre        Acido                            61
  1338   DiscipuloDragonDorado       Fuego                            63
  1339   DiscipuloDragonOropel       Fuego                            59
  1343   DiscipuloDragonBatalla      Sonico                           61
  1344   DiscipuloDragonEsmeralda    Sonico                           66
  1345   DiscipuloDragonOceanico     Electricidad                     67
  1346   DiscipuloDragonPardo        Acido                            17
  1347   DiscipuloDragonAullador     Sonico                           18
  1348   DiscipuloDragonTopacio      Frio                             67
  1349   DiscipuloDragonZafiro       Sonido / Electricidad            67
  1350   DiscipuloDragonPiroclastico Fuego y Sonido / 50% a cada      68
  1351   DiscipuloDragonEstigio      Acido / Veneno y enfermedades    63
  1352   DiscipuloDragonAmatista     Linea de fuerza / enfermedades   18
  1353   DiscipuloDragonCristal      Linea de fuerza ceg. / frio      65

  DRACONIDO -> VARIABLES:
  DRACONIDO_TIPO // 1 = Tipo eléctrico, 2 = frío, 3 = fuego, 4 = ácido.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: June, 17, 2003
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "pb_constantes"
#include "mti_libreria"

void main()
{
  //Declare major variables
  int nType = GetSpellId();
  int nDamageDice, nPersonalDamage, iEfectoVisual, iEfectoVisual2, iTipoDanyo, iTipoDanyo2, iTipoSalvacion;
  int nLevel = GetLevelByClass(37,OBJECT_SELF);// 37 = red dragon disciple
  //Si el PJ sin embargo, es Dracónido, siempre usará las stats del dracónido (que será de más nivel).
  if(GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DRACONIDO){nLevel = GetHitDice(OBJECT_SELF);}
  int iTipoDraconido = ObtenerIntPersistente(OBJECT_SELF,"DRACONIDO_TIPO");
  int nSaveDC = 10 + nLevel + GetAbilityModifier(ABILITY_CONSTITUTION);
  float fDelay;
  object oTarget;
  effect eBreath;

  // Calculo dado
  if(nLevel < 7) nDamageDice = 2;
  else if(nLevel < 10) nDamageDice = 4;
  else if(nLevel == 10) nDamageDice = 6;
  else nDamageDice = 6 + (((nLevel - 10) / 3) * 2);
  int nDamage = d8(nDamageDice);

  // Calculos del efecto visual, tipo de danyo y de salvacion, segun el tipo de dragon que eres
  if(GetHasFeat(1330) || GetHasFeat(1336) || GetHasFeat(1345) || iTipoDraconido == 1) { iEfectoVisual = 459;  iEfectoVisual2 = VFX_IMP_LIGHTNING_S; iTipoDanyo = DAMAGE_TYPE_ELECTRICAL; iTipoSalvacion = SAVING_THROW_TYPE_ELECTRICITY; }
  else if(GetHasFeat(1331) || GetHasFeat(1335) || GetHasFeat(1348) || iTipoDraconido == 2) { iEfectoVisual = 1546; iEfectoVisual2 = VFX_IMP_FROST_L; iTipoDanyo = DAMAGE_TYPE_COLD; iTipoSalvacion = SAVING_THROW_TYPE_COLD; }
  else if(GetHasFeat(1332) || GetHasFeat(1334) || GetHasFeat(1337) || GetHasFeat(1346) || GetHasFeat(1351) || iTipoDraconido == 3) { iEfectoVisual = 1550; iEfectoVisual2 = VFX_IMP_ACID_S; iTipoDanyo = DAMAGE_TYPE_ACID; iTipoSalvacion = SAVING_THROW_TYPE_ACID; }
  else if(GetHasFeat(1343) || GetHasFeat(1344) || GetHasFeat(1347) || GetHasFeat(1349)) { iEfectoVisual = 1555; iEfectoVisual2 = VFX_IMP_SONIC; iTipoDanyo = DAMAGE_TYPE_SONIC; iTipoSalvacion = SAVING_THROW_TYPE_SONIC; }
  else if(GetHasFeat(1350)) { iEfectoVisual = 1551;  iEfectoVisual2 = VFX_IMP_FLAME_M; iTipoDanyo = DAMAGE_TYPE_FIRE; iTipoDanyo2 = DAMAGE_TYPE_SONIC; iTipoSalvacion = SAVING_THROW_TYPE_NONE; }
  else if(GetHasFeat(1352) || GetHasFeat(1353)) { iEfectoVisual = 1551;  iEfectoVisual2 = VFX_IMP_SUNSTRIKE ; iTipoDanyo = DAMAGE_TYPE_BLUDGEONING; iTipoSalvacion = SAVING_THROW_TYPE_NONE; }
  else if(iTipoDraconido == 4) { iEfectoVisual = 1548; iEfectoVisual2 = VFX_IMP_FLAME_M; iTipoDanyo = DAMAGE_TYPE_FIRE; iTipoSalvacion = SAVING_THROW_TYPE_FIRE; }
  else /*if(GetHasFeat(1333) || GetHasFeat(1338) || GetHasFeat(1339))*/ { iEfectoVisual = 1548; iEfectoVisual2 = VFX_IMP_FLAME_M; iTipoDanyo = DAMAGE_TYPE_FIRE; iTipoSalvacion = SAVING_THROW_TYPE_FIRE; }

  // Aplicacion de efectovisual
  if(iEfectoVisual2 == VFX_IMP_LIGHTNING_S) ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(iEfectoVisual), GetSpellTargetLocation());
  else ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iEfectoVisual), OBJECT_SELF);
  // ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(766), OBJECT_SELF);

  //Get first target in spell area
  location lFinalTarget = GetSpellTargetLocation();
  if ( lFinalTarget == GetLocation(OBJECT_SELF) )
  {
      // Since the target and origin are the same, we have to determine the
      // direction of the spell from the facing of OBJECT_SELF (which is more
      // intuitive than defaulting to East everytime).

      // In order to use the direction that OBJECT_SELF is facing, we have to
      // instead we pick a point slightly in front of OBJECT_SELF as the target.
      vector lTargetPosition = GetPositionFromLocation(lFinalTarget);
      vector vFinalPosition;
      vFinalPosition.x = lTargetPosition.x +  cos(GetFacing(OBJECT_SELF));
      vFinalPosition.y = lTargetPosition.y +  sin(GetFacing(OBJECT_SELF));
      lFinalTarget = Location(GetAreaFromLocation(lFinalTarget),vFinalPosition,GetFacingFromLocation(lFinalTarget));
  }

  oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lFinalTarget, TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE);
  while(GetIsObjectValid(oTarget))
  {
      nPersonalDamage = nDamage;
      if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
      {
          //Fire cast spell at event for the specified target
          SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
          //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
          //Determine effect delay
          fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
          if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, iTipoSalvacion))
          {
              nPersonalDamage  = nPersonalDamage/2;
              if(GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
              {
                  nPersonalDamage = 0;
              }
          }
          else
          {
              if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget)) nPersonalDamage = nPersonalDamage/2;
              if(GetHasFeat(1353)) DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(d4())));
          }

          if (nPersonalDamage > 0)
          {
              //Apply the VFX impact and effects
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iEfectoVisual2), oTarget));

              if(iTipoDanyo2 == DAMAGE_TYPE_SONIC) // Ajuste del piroclastico
              {
                  int iCalculoDanyo = nPersonalDamage / 2;
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iCalculoDanyo, iTipoDanyo), oTarget));
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iCalculoDanyo, iTipoDanyo2), oTarget));
              }
              else DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nPersonalDamage, iTipoDanyo), oTarget));
          }
      }
      //Get next target in spell area
      oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lFinalTarget, TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE);
  }
}
