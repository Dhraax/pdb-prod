//::///////////////////////////////////////////////
//:: [Raise Dead]
//:: [NW_S0_RaisDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Brings a character back to life with 1 HP.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 22, 2001

#include "x2_inc_spellhook"
#include "tj_inc"
#include "cab_inc"
#include "dominios_inc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eRaise = EffectResurrection();
    effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAISE_DEAD, FALSE));
    if(GetIsDead(oTarget))
    {
        //Apply raise dead effect and VFX impact
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget);

        // ELIMINAR LAS VARIABLES DEL PUESTO DE VENTA (si lo tiene montado)
        DelayCommand(1.0, EliminarVariablesTJ(oTarget));

        //PENALIZACION DE EXPERIENCIA AL SER RESUCITADO
        int Penalizacion = GetXP(oTarget) - ((GetXP(oTarget)*3)/100);
        FloatingTextStringOnCreature("<cî>Pierdes un 3% de tu XP por la resurrección.</c>", oTarget, FALSE);
        SetXP(oTarget, Penalizacion);

        // DESMONTAR DEL CABALLO/PONY
        MorirEncimaDeMontura(oTarget);

        // APLICAMOS LOS EFECTOS DE LAS SUBRAZAS, MONTURAS Y ARMADURAS
        ReaplicarEfectosPB(oTarget, TRUE, FALSE, TRUE);

        // Dominios de clerigo, dar o quitar objetos  segun sea el caso
        ConjurosDominios(oTarget);

        //ELIMINAR VARIABLE PARA EVITAR EL ABUSO POR LA RESURRECCION POR DEIDAD
        GuardarIntPersistente(oTarget, "NORESDEIDAD", 0);
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    }
}
