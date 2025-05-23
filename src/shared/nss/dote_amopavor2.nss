#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "inc_spells"
#include "cls_ing_lib"
#include "pb_nivellanzador"

void HeartBeat(object oTarget, effect eDano, effect eVis, int nSpell);
void HeartBeat(object oTarget, effect eDano, effect eVis, int nSpell)
{
    if(GetLocalInt(oTarget, "DOTE_AMOPAVOR") == 1)
    {
        gsSPApplyEffect(oTarget, eDano, nSpell, GS_SP_DURATION_INSTANT);
        gsSPApplyEffect(oTarget, eVis, nSpell, GS_SP_DURATION_INSTANT);
    }
    DelayCommand(6.0,HeartBeat(oTarget, eDano, eVis, nSpell));
}

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nSpell = GetSpellId();
    int iCasterLevel = GetTotalCasterLevel(oCaster);
    //Calculo de CD.
    int iCD = 10 + (GetLevelByClass(CLASS_TYPE_PALADIN, oCaster)/4) + GetAbilityModifier(ABILITY_CHARISMA,oCaster);

    //Calculo de daño.
    int iDano = 5;

    // No funciona en DMs.
    if(GetIsDM(oTarget) == TRUE && GetIsDMPossessed(oTarget) == FALSE)
    {
        return;
    }

    //Afecta a todo el que entra.
    if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, oCaster, oTarget)) return;

    //Lanzamos el evento.
    SignalEvent (oTarget, EventSpellCastAt(oCaster, GetSpellId()));

    //Hacemos chequeo de RC.
    //if (gsSPResistSpell(oCaster, oTarget, nSpell)) return;

    //Enlistamos efectos.
    effect eMiedo = EffectFrightened();
    effect eDano = EffectDamage(iDano, DAMAGE_TYPE_PSIQUICO);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_MIND);

    if(!MySavingThrow(SAVING_THROW_WILL, oTarget, iCD, SAVING_THROW_TYPE_FEAR, oCaster))
    {
        //Aplicamos los efectos.
        gsSPApplyEffect(oTarget, eMiedo, nSpell, RoundsToSeconds(2));
        gsSPApplyEffect(oTarget, eDano, nSpell, GS_SP_DURATION_INSTANT);
        gsSPApplyEffect(oTarget, eVis, nSpell, GS_SP_DURATION_INSTANT);
        DelayCommand(6.0, gsSPApplyEffect(oTarget, eDano, nSpell, GS_SP_DURATION_INSTANT));
        DelayCommand(6.0, gsSPApplyEffect(oTarget, eVis, nSpell, GS_SP_DURATION_INSTANT));
        DelayCommand(12.0, gsSPApplyEffect(oTarget, eDano, nSpell, GS_SP_DURATION_INSTANT));
        DelayCommand(12.0, gsSPApplyEffect(oTarget, eVis, nSpell, GS_SP_DURATION_INSTANT));
        //Guardamos en el área de efecto al objetivo, para saber si aún está dentro.
        if(GetIsPC(oTarget)){SetLocalObject(OBJECT_SELF,GetName(oTarget),oTarget);}
        else if(!GetIsPC(oTarget)){SetLocalInt(oTarget, "DOTE_AMOPAVOR",1);}

        //HeartBeat cada 6 segundos.
        //DelayCommand(6.0,HeartBeat(oTarget, eDano, eVis, nSpell));
    }
}


