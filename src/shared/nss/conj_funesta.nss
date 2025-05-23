// Poliformar Funesto //

#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "X0_I0_SPELLS"

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


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect eFallo = EffectSpellFailure(100);
    effect eAttackDecrease = EffectAttackDecrease(20);
    effect eLink = EffectLinkEffects(eFallo, eAttackDecrease);
    effect ePoly;

   //Solo si no eres Constructo, nomuerto o cambiaformas. Ni a ti mismo!
   if(GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT || PB_Race_GetIsUndead(oTarget) ||
      GetRacialType(oTarget) == RACIAL_TYPE_SHAPECHANGER || GetLevelByClass(CLASS_TYPE_SHIFTER, oTarget) == 10 ||
      (oTarget == OBJECT_SELF) ) return;

    //Duracion
       int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    float fDuration = RoundsToSeconds(nCasterLevel);
       int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        fDuration = fDuration * 2.0;    //Duration is +100%
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT));

      int iAparienciaCriatura;
      switch(d4())
        {
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
           if(!MySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF))))
               {
                AssignCommand(oTarget, ClearAllActions()); // prevenimos cosas raras
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
               }
        }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}







