//::///////////////////////////////////////////////
//:: Etereidad
//:://////////////////////////////////////////////
//:: Created By: Darth
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "nw_i0_spells"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    object oArea = GetArea(oTarget);
    effect eVis = EffectVisualEffect(VFX_DUR_SANCTUARY);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEAD_ACID);
    effect eVis3 = EffectCutsceneGhost();
    effect eDur = EffectVisualEffect(240); //240
    effect eDur2 = EffectVisualEffect(424); //424
    effect eSanc = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eSlowDown = EffectMovementSpeedDecrease(50);

    effect eLink = EffectEtereo();

    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    int iNumeroMaximoTeleportPJs = nDuration / 3;

    //Enter Metamagic conditions
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    if (GetHasSpellEffect(990, oTarget) == TRUE)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        SendMessageToPC(OBJECT_SELF,"*Te encuentras anclado y no puedes entrar al plano etereo!*");
        return;
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ETHEREALNESS, FALSE));

    //Apply the VFX impact and effects
    object oPJCercanoGrupo = GetFirstFactionMember(oTarget, TRUE);
    while(GetIsObjectValid(oPJCercanoGrupo) == TRUE)
        {
      if(iNumeroMaximoTeleportPJs > 0                &&
         GetDistanceBetween(oTarget, oPJCercanoGrupo) <= 5.0  &&
         GetDistanceBetween(oTarget, oPJCercanoGrupo) >= 0.1  &&
         GetIsDM(oPJCercanoGrupo) == FALSE || oTarget == oPJCercanoGrupo)
              {
              object oSalto = CreateItemOnObject("item_etereidad", oPJCercanoGrupo);
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPJCercanoGrupo, RoundsToSeconds(nDuration));
              SendMessageToPC(oPJCercanoGrupo, "Se te ha añadido el objeto de salto etereo en tu inventario");
              DeleteLocalInt(oPJCercanoGrupo, "ETEREIDAD_USOS");
              DelayCommand(RoundsToSeconds(nDuration), DestroyObject(oSalto));
              }
        oPJCercanoGrupo = GetNextFactionMember(oTarget, TRUE);
        }
     DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}


