//::///////////////////////////////////////////////
//:: Tensor's Transformation
//:: NW_S0_TensTrans.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster the following bonuses:
        +1 Attack per 2 levels
        +4 Natural AC
        20 STR and DEX and CON
        1d6 Bonus HP per level
        +5 on Fortitude Saves
        -10 Intelligence
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////
//: Sep2002: losing hit-points won't get rid of the rest of the bonuses

#include "x2_inc_spellhook"
#include "mti_libreria"
#include "nw_i0_spells"
#include "pb_nivellanzador"
#include "colors_inc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

  //----------------------------------------------------------------------------
  // GZ, Nov 3, 2003
  // There is a serious problems with creatures turning into unstoppable killer
  // machines when affected by tensors transformation. NPC AI can't handle that
  // spell anyway, so I added this code to disable the use of Tensors by any
  // NPC.
  //----------------------------------------------------------------------------
  if (!GetIsPC(OBJECT_SELF))
  {
      WriteTimestampedLogEntry(GetName(OBJECT_SELF) + "[" + GetTag (OBJECT_SELF) +"] tried to cast Tensors Transformation. Bad! Remove that spell from the creature");
      return;
  }

  /*
    Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */

    if (!X2PreSpellCastCode())
    {
        return;
    }

    // End of Spell Cast Hook

    // NO NOS PODEMOS POLIMORFAR CUANDO YA LO ESTAMOS O ESTAMOS MONTADO A CABALLO
    if(ObtenerIntPersistente(OBJECT_SELF, "CAB_MONTADO") > 0)
    {
        SendMessageToPC(OBJECT_SELF, ColorToken(254,60,60) + "No puedes polimorfarte cuando estás montado a caballo.</c>");
        return;
    }
    if(ObtenerIntPersistente(OBJECT_SELF, "APA_CAMBIADA") == TRUE)
    {
        SendMessageToPC(OBJECT_SELF, ColorToken(254,60,60) + "Despolimórfate antes de usar este conjuro.</c>");
        return;
    }

    // No se apila
    RemoveEffectsFromSpell(OBJECT_SELF, 184);

    //Declare major variables
    int nLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nHP, nCnt, nDuration;
    nDuration = nLevel;
    //Determine bonus HP
    for(nCnt; nCnt <= nLevel; nCnt++)
    {
        nHP += d6();
    }

    int nMeta = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    //Metamagic
    if(nMeta == METAMAGIC_MAXIMIZE)
    {
        nHP = nLevel * 6;
    }
    else if(nMeta == METAMAGIC_EMPOWER)
    {
        nHP = nHP + (nHP/2);
    }
    else if(nMeta == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }
    //Declare effects
    effect eAttack = EffectAttackIncrease(nLevel/2);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect ePoly = EffectPolymorph(28);
    effect eSwing = EffectModifyAttacks(2);

    //Link effects
    effect eLink = EffectLinkEffects(eAttack, ePoly);

    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eSwing);

    effect eHP = EffectTemporaryHitpoints(nHP);

    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    //Signal Spell Event
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TENSERS_TRANSFORMATION, FALSE));

    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
