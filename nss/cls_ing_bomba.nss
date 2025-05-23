#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "inc_spells"
#include "cls_ing_lib"
#include "pb_nivellanzador"

void HeartBeat(object oTarget, int iDuracion, effect eLink, int nSpell, int iCD);
void HeartBeat(object oTarget, int iDuracion, effect eLink, int nSpell, int iCD)
{
    if(GetIsObjectValid(GetLocalObject(OBJECT_SELF,GetName(oTarget))) || GetLocalInt(oTarget, "VFX_PER_BOMBARAICES") == 1)
    {
        //Tirada de reflejos.
        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD))
        {
            //Aplicamos los efectos.
            gsSPApplyEffect(oTarget, eLink, nSpell, RoundsToSeconds(iDuracion));
        }
        DelayCommand(6.0,HeartBeat(oTarget, iDuracion, eLink, nSpell, iCD));
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

    // No funciona en DMs.
    if(GetIsDM(oTarget) == TRUE && GetIsDMPossessed(oTarget) == FALSE)
    {
        return;
    }

    //Afecta a todo el que entra.
    if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget)) return;

    //Lanzamos el evento.
    SignalEvent (oTarget, EventSpellCastAt(oCaster, GetSpellId()));

    //Hacemos chequeo de RC.
    if (gsSPResistSpell(oCaster, oTarget, nSpell)) return;

    //Enlistamos efectos.
    effect eParal = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eDur, eParal);

    //Duración de los efectos.
    int iDuracion = iCasterLevel / 2;
    if(iDuracion == 0){iDuracion = 1;}

    //Tirada de fortaleza.
    if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD, IMMUNITY_TYPE_PARALYSIS))
    {
        if (GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS, GetAreaOfEffectCreator()) == FALSE)
        {
            gsSPApplyEffect(oTarget, eLink, nSpell, RoundsToSeconds(iDuracion));
        }
    }

    //Guardamos en el área de efecto al objetivo, para saber si aún está dentro.
    if(GetIsPC(oTarget)){SetLocalObject(OBJECT_SELF,GetName(oTarget),oTarget);}
    else if(!GetIsPC(oTarget)){SetLocalInt(oTarget, "VFX_PER_BOMBARAICES",1);}

    //HeartBeat cada 6 segundos.
    DelayCommand(6.0,HeartBeat(oTarget, iDuracion, eLink, nSpell, iCD));
}



