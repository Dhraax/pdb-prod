#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "inc_spells"
#include "cls_ing_lib"
#include "pb_nivellanzador"

void HeartBeat(object oTarget, int iDuracion, effect eVeneno, int nSpell, int iCD, int iDano, effect eVis);
void HeartBeat(object oTarget, int iDuracion, effect eVeneno, int nSpell, int iCD, int iDano, effect eVis)
{
    if(GetIsObjectValid(GetLocalObject(OBJECT_SELF,GetName(oTarget))) || GetLocalInt(oTarget, "VFX_PER_BOMBAGAS") == 1)
    {
        //Tirada de fortaleza
        if(!MySavingThrow(SAVING_THROW_FORT, oTarget, iCD))
        {
            gsSPApplyEffect(oTarget, eVeneno, nSpell, RoundsToSeconds(iDuracion));
            gsSPApplyEffect(oTarget, EffectDamage(iDano/2, DAMAGE_TYPE_ACID), nSpell, GS_SP_DURATION_INSTANT);
            gsSPApplyEffect(oTarget, eVis, nSpell, GS_SP_DURATION_INSTANT);
        }
        else
        {
            gsSPApplyEffect(oTarget, EffectDamage(iDano, DAMAGE_TYPE_ACID), nSpell, GS_SP_DURATION_INSTANT);
            gsSPApplyEffect(oTarget, eVis, nSpell, GS_SP_DURATION_INSTANT);
        }
        DelayCommand(6.0,HeartBeat(oTarget, iDuracion, eVeneno, nSpell, iCD, iDano, eVis));
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

    //Calculo de daño.
    int iDano = iDANOING (oCaster);

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
    effect eVeneno;
    if(GetLevelByClass(CLASS_TYPE_INGENIERO,oCaster) <= 12 && GetLevelByClass(60,oCaster) < 16)
    {
        eVeneno = EffectPoison(45);
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oCaster) >= 13 && GetLevelByClass(60,oCaster) < 17)
    {
        eVeneno = EffectPoison(46);
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oCaster) >=17)
    {
        eVeneno = EffectPoison(47);
    }
    //effect eDano = EffectDamage(iDano, DAMAGE_TYPE_ACID);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

    //Duración de los efectos.
    int iDuracion = iCasterLevel / 2;
    if(iDuracion == 0){iDuracion = 1;}

    //Tirada de fortaleza.
    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, iCD))
    {
        if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON, GetAreaOfEffectCreator()) == FALSE)
        {
            gsSPApplyEffect(oTarget, eVeneno, nSpell, RoundsToSeconds(iDuracion));
        }
        gsSPApplyEffect(oTarget, EffectDamage(iDano/2, DAMAGE_TYPE_ACID), nSpell, GS_SP_DURATION_INSTANT);
        gsSPApplyEffect(oTarget, eVis, nSpell, GS_SP_DURATION_INSTANT);
    }
    else
    {
        gsSPApplyEffect(oTarget, EffectDamage(iDano, DAMAGE_TYPE_ACID), nSpell, GS_SP_DURATION_INSTANT);
        gsSPApplyEffect(oTarget, eVis, nSpell, GS_SP_DURATION_INSTANT);
    }

    //Guardamos en el área de efecto al objetivo, para saber si aún está dentro.
    if(GetIsPC(oTarget)){SetLocalObject(OBJECT_SELF,GetName(oTarget),oTarget);}
    else if(!GetIsPC(oTarget)){SetLocalInt(oTarget, "VFX_PER_BOMBAGAS",1);}

    //HeartBeat cada 6 segundos.
    DelayCommand(6.0,HeartBeat(oTarget, iDuracion, eVeneno, nSpell, iCD, iDano, eVis));
}



