// Palabra de cambio Brujo //

#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "X0_I0_SPELLS"
#include "war_utilities"
#include "mti_libreria"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

     if (!CheckWarlockSpellCharisma()) return;

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect eFallo = EffectSpellFailure(100);
    effect eAttackDecrease = EffectAttackDecrease(20);
    effect eLink = EffectLinkEffects(eFallo, eAttackDecrease);
    effect ePoly;
    int nRacialType = GetRacialType(oTarget);
    int nDuration = GetLevelByClass(57, OBJECT_SELF);

    // El conjuro no funciona contra constructos, no muertos o contra el mismo lanzador
    if (PB_Race_GetIsUndead(oTarget) || nRacialType == RACIAL_TYPE_CONSTRUCT || oTarget == OBJECT_SELF) return;

    // El conjuro solo dura un asalto contra el subtipo SHAPECHANGER o cambiaformas de nivel 10
    if (nRacialType == RACIAL_TYPE_SHAPECHANGER || GetLevelByClass(CLASS_TYPE_SHIFTER, oTarget) == 10) nDuration = 1;

    int iAparienciaAGuardar = GetAppearanceType(oTarget);
    int iAparienciaCambiada = ObtenerIntPersistente(oTarget, "APA_CAMBIADA");
    int iAparienciaOriginal = ObtenerIntPersistente(oTarget, "APA_MEMORIZADA");

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_POLYMORPH_SELF, FALSE));

  if(iAparienciaCambiada == 0) //Solo si no estamos poliformados ya
   {
      int iAparienciaCriatura;
      switch(Random(5))
        {
        case 0: iAparienciaCriatura = 136; break;
        case 1: iAparienciaCriatura = 132; break;
        case 2: iAparienciaCriatura = 133; break;
        case 3: iAparienciaCriatura = 134; break;
        case 4: iAparienciaCriatura = 135; break;
        }

     ePoly = EffectPolymorph(iAparienciaCriatura, TRUE);
     eLink = EffectLinkEffects(eLink, ePoly);

    //Apply the VFX impact and effects
    if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
           if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetWarlockSpellDC(OBJECT_SELF)))
               {
                AssignCommand(oTarget, ClearAllActions()); // prevenimos cosas raras
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
               }
        }
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
