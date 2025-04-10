//::///////////////////////////////////////////////
//:: BONO DE CARACTERISTICAS EN GRUPO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Fuerza de toro en grupo.
    Gracia felina en grupo.
    Aguante en grupo.
    Astucia de Zorro en grupo.
    Sabidura de lechuza en grupo.
    Esplendor de aguila en grupo.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 31 de Mayo de 2010
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "vgz_libreria"
#include "nostack_inc"
#include "pb_nivellanzador"
#include "colors_inc"

void DestruirComponente(string sComponente)
{
  object oComponente = GetItemPossessedBy(OBJECT_SELF, sComponente);
  DestroyObject(oComponente);
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
  /*
    Spellcast Hook Code
    Added 2003-07-07 by Georg Zoeller
    If you want to make changes to all spells,
    check x2_inc_spellhook.nss to find out more
  */

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }
  // End of Spell Cast Hook

  // Variables
  object oCaster = OBJECT_SELF;
  int nCasterLevel = GetTotalCasterLevel(oCaster);
  float fDuration = HoursToSeconds(nCasterLevel);
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  int nSpellId = GetSpellId();
  int nStat, iEfectoVisual;
  string sComponente, sNombreComponente;
  int nBuff = 4;
  float fDelay = 0.0;

  switch(nSpellId)
  {
      case 1043: nStat = ABILITY_STRENGTH;     iEfectoVisual =1263; sComponente = "extractofantasma"; sNombreComponente = "l fruto fantasma"; break;
      case 1044: nStat = ABILITY_DEXTERITY;    iEfectoVisual =1264; sComponente = "extractofantasma"; sNombreComponente = "l fruto fantasma"; break;
      case 1045: nStat = ABILITY_CHARISMA;     iEfectoVisual =1268; sComponente = "extractobaya";     sNombreComponente = " baya acuosa";     break;
      case 1046: nStat = ABILITY_CONSTITUTION; iEfectoVisual =1265; sComponente = "extractofantasma"; sNombreComponente = "l fruto fantasma"; break;
      case 1047: nStat = ABILITY_INTELLIGENCE; iEfectoVisual =1266; sComponente = "extractobaya";     sNombreComponente = " baya acuosa";     break;
      case 1048: nStat = ABILITY_WISDOM;       iEfectoVisual =1267; sComponente = "extractobaya";     sNombreComponente = " baya acuosa";     break;
  }

  // Metamagias
  if(nMetaMagic == METAMAGIC_EXTEND)
  {
      fDuration = fDuration * 2;
  }
  else if(nMetaMagic == METAMAGIC_EMPOWER)
  {
      nBuff = 6;
  }

  // Contador componentes
  // Mensajes y efectos visuales de la potenciacion
  object oComponente = GetFirstItemInInventory();
  int iContadorComponentes = 0;
  while(GetIsObjectValid(oComponente))
  {
      if(GetTag(oComponente) == sComponente) iContadorComponentes++;

      oComponente = GetNextItemInInventory();
  }

  if(GetSpellCastItem() == OBJECT_INVALID && iContadorComponentes > 0)
  {
      SendMessageToPC(OBJECT_SELF, ColorToken(33,33,180) + "¡El conjuro parece haberse potenciado con el extracto de"+sNombreComponente+"!</c>");
      pentagramahaciasi(GetLocation(OBJECT_SELF), VFX_BEAM_HOLY, 1.0);
  }

  location lTarget = GetSpellTargetLocation();
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
  while(GetIsObjectValid(oTarget))
  {
      if(GetFactionLeader(oCaster) == GetFactionLeader(oTarget) && !GetIsDead(oTarget))
      {
          // Disipaciones para que no se acumulen
          if(nSpellId == 1043) // Fueza de toro
          {
              RemoveEffectsFromSpell(oTarget, 9);
              RemoveEffectsFromSpell(oTarget, 360);
              RemoveEffectsFromSpell(oTarget, 614);
              RemoveEffectsFromSpell(oTarget, 1043);
              RemoveEffectsFromSpell(oTarget, 1082);
          }
          else if(nSpellId == 1044) // Gracia felina
          {
              RemoveEffectsFromSpell(oTarget, 13);
              RemoveEffectsFromSpell(oTarget, 361);
              RemoveEffectsFromSpell(oTarget, 481);
              RemoveEffectsFromSpell(oTarget, 1010);
              RemoveEffectsFromSpell(oTarget, 1044);
              RemoveEffectsFromSpell(oTarget, 1117);
          }
          else if(nSpellId == 1045) // Esplendor de aguila
          {
              RemoveEffectsFromSpell(oTarget, 354);
              RemoveEffectsFromSpell(oTarget, 357);
              RemoveEffectsFromSpell(oTarget, 482);
              RemoveEffectsFromSpell(oTarget, 1045);
              RemoveEffectsFromSpell(oTarget, 1116);
          }
          else if(nSpellId == 1046) // Aguante
          {
              RemoveEffectsFromSpell(oTarget, 49);
              RemoveEffectsFromSpell(oTarget, 362);
              RemoveEffectsFromSpell(oTarget, 1046);
          }
          else if(nSpellId == 1047) // Astucia de zorro
          {
              RemoveEffectsFromSpell(oTarget, 356);
              RemoveEffectsFromSpell(oTarget, 359);
              RemoveEffectsFromSpell(oTarget, 1008);
              RemoveEffectsFromSpell(oTarget, 1047);
          }
          else if(nSpellId == 1048) // Sabiduria de lechuza
          {
              RemoveEffectsFromSpell(oTarget, 355);
              RemoveEffectsFromSpell(oTarget, 358);
              RemoveEffectsFromSpell(oTarget, 1048);
          }

          // Efectos (potenciado)
          if(GetSpellCastItem() == OBJECT_INVALID && iContadorComponentes > 0)
          {
              ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(87), oTarget);
              DoNoStackAbilityBonus(OBJECT_SELF, oTarget, nBuff + d2(), nStat, fDuration);
              DelayCommand(fDelay, DestruirComponente(sComponente));
              fDelay = fDelay + 0.2;
              iContadorComponentes--;
          }
          else // Efectos normal
          {
              DoNoStackAbilityBonus(OBJECT_SELF, oTarget, nBuff, nStat, fDuration);
          }

          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, fDuration);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iEfectoVisual), oTarget);
          SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
      }

      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
     DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
  }
}
