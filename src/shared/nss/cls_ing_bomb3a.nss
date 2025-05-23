#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "inc_spells"
#include "cls_ing_lib"
#include "pb_nivellanzador"

void HeartBeat(object oCaster, object oTarget, effect eFuego, int nSpell, int iCD, int iDano, effect eVis);
void HeartBeat(object oCaster, object oTarget, effect eFuego, int nSpell, int iCD, int iDano, effect eVis)
{
    if(GetIsObjectValid(GetLocalObject(OBJECT_SELF,GetName(oTarget))) || GetLocalInt(oTarget, "VFX_PER_FUEGOALQUIMISTA") == 1)
    {
        //Hacemos tirada de reflejos.
        iDano = GetReflexAdjustedDamage(iDano, oTarget, iCD, SAVING_THROW_TYPE_FIRE);

        gsSPApplyEffect(oTarget, eFuego, nSpell, GS_SP_DURATION_INSTANT);
        gsSPApplyEffect(oTarget, eVis, nSpell, GS_SP_DURATION_INSTANT);

        //Tirada de fortaleza.
        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD))
        {
            if(GetIsPC(oTarget) && GetLocalInt(oTarget, "CLS_ING_IMPACTOS") == 0){DelayCommand(6.0,ImpactosSecundarios(oCaster, oTarget, DAMAGE_TYPE_FIRE, iDano, iCD, VFX_IMP_FLAME_S, GetSpellId()));}
            else if(!GetIsPC(oTarget) && GetLocalInt(oTarget, "CLS_ING_IMPACTOS") == 0){DelayCommand(6.0,ImpactosSecundarios(oCaster, oTarget, DAMAGE_TYPE_FIRE, iDano, iCD, VFX_IMP_FLAME_S, GetSpellId()));}
        }
        DelayCommand(6.0,HeartBeat(oCaster, oTarget, eFuego, nSpell, iCD, iDano, eVis));
    }
}

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nSpell = GetSpellId();
    int iCasterLevel = GetTotalCasterLevel(oCaster);

    //Calculo de CD.
    int iCD = iCDING (oCaster);

    //Calculo del daño.
    int iDano = iDANOING (oCaster);

    // No funciona en DMs.
    if(GetIsDM(oTarget) == TRUE && GetIsDMPossessed(oTarget) == FALSE)
    {
        return;
    }

    //Afecta a todo el que entra.
    if (!gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget)) return;

    //Lanzamos el evento.
    SignalEvent (oTarget, EventSpellCastAt(oCaster, GetSpellId()));

    //Hacemos chequeo de RC.
    if (gsSPResistSpell(oCaster, oTarget, nSpell)) return;

    //Enlistamos efectos.
    effect eFuego = EffectDamage(iDano, DAMAGE_TYPE_FIRE);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

    //Hacemos tirada de reflejos.
    iDano = GetReflexAdjustedDamage(iDano, oTarget, iCD, SAVING_THROW_TYPE_FIRE);

    gsSPApplyEffect(oTarget, eFuego, nSpell, GS_SP_DURATION_INSTANT);
    gsSPApplyEffect(oTarget, eVis, nSpell, GS_SP_DURATION_INSTANT);

    //Tirada de fortaleza.
    if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD))
    {
        if(GetIsPC(oTarget) && GetLocalInt(oTarget, "CLS_ING_IMPACTOS") == 0){DelayCommand(6.0,ImpactosSecundarios(oCaster, oTarget, DAMAGE_TYPE_FIRE, iDano, iCD, VFX_IMP_FLAME_S, GetSpellId()));}
        else if(!GetIsPC(oTarget) && GetLocalInt(oTarget, "CLS_ING_IMPACTOS") == 0){DelayCommand(6.0,ImpactosSecundarios(oCaster, oTarget, DAMAGE_TYPE_FIRE, iDano, iCD, VFX_IMP_FLAME_S, GetSpellId()));}
    }

    //Guardamos en el área de efecto al objetivo, para saber si aún está dentro.
    if(GetIsPC(oTarget)){SetLocalObject(OBJECT_SELF,GetName(oTarget),oTarget);}
    else if(!GetIsPC(oTarget)){SetLocalInt(oTarget, "VFX_PER_FUEGOALQUIMISTA",1);}

    //HeartBeat cada 6 segundos.
    DelayCommand(6.0,HeartBeat(oCaster, oTarget, eFuego, nSpell, iCD, iDano, eVis));
}



