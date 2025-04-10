//::///////////////////////////////////////////////
//:: [Ressurection]
//:: [NW_S0_Ressurec.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Brings a character back to life with full
//:: health.
//:: When cast on placeables, you get a default error message.
//::   * You can specify a different message in
//::      X2_L_RESURRECT_SPELL_MSG_RESREF
//::   * You can turn off the message by setting the variable
//::     to -1
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Z on 2003-07-31
//:: VFX Pass By: Preston W, On: June 22, 2001
//:: MODIFICADO POR MONTI para que no salgan mensajes raros al lanzarlo sobre
//:: un ubicado, necesario para el sistema de muerte

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


    //Get the spell target
    object oTarget = GetSpellTargetObject();
    //Check to make sure the target is dead first
    //Fire cast spell at event for the specified target
    if (GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESURRECTION, FALSE));
        if(GetIsDead(oTarget))
        {
            //Declare major variables
            int nHealed = GetMaxHitPoints(oTarget);
            effect eRaise = EffectResurrection();
            effect eHeal = EffectHeal(nHealed + 10);
            effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
            //Apply the heal, raise dead and VFX impact effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));

            // ELIMINAR LAS VARIABLES DEL PUESTO DE VENTA (si lo tiene montado)
            DelayCommand(1.0, EliminarVariablesTJ(oTarget));

            //PENALIZACION DE EXPERIENCIA AL SER RESUCITADO
            FloatingTextStringOnCreature("<cî>Pierdes un 2% de tu XP por la resurrección.</c>", oTarget, FALSE);
            int Penalizacion = GetXP(oTarget) - ((GetXP(oTarget)*2)/100);
            SetXP(oTarget, Penalizacion);

            // DESMONTAR DEL CABALLO/PONY
            MorirEncimaDeMontura(oTarget);

            // APLICAMOS LOS EFECTOS DE LAS SUBRAZAS, MONTURAS Y ARMADURAS
            ReaplicarEfectosPB(oTarget, TRUE, FALSE, TRUE);

            // Dominios de clerigo, dar o quitar objetos  segun sea el caso
            ConjurosDominios(oTarget);

            //ELIMINAR VARIABLE PARA EVITAR EL ABUSO DE LA RESURRECCION POR DEIDAD
            GuardarIntPersistente(oTarget, "NORESDEIDAD", 0);
            DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        }
    }
}
