//::///////////////////////////////////////////////
//:: Mordenkainen's Sword
//:: NW_S0_MordSwrd.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Conjuro de septima esfera
    Invoca una espada planar
*/
//:://////////////////////////////////////////////
//:: Created By: Darth


#include "x2_inc_spellhook"
#include "conv_inc"
#include "pb_nivellanzador"


void BonosEspada(object oPC = OBJECT_SELF)
{
    int nCasterLevel = GetTotalCasterLevel(oPC);
    int nBono = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC) + nCasterLevel;

    //La Espada Planar
    object oCreature = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);

  //Hechicero
    if(GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0 )
    {
        nBono = GetAbilityModifier( ABILITY_CHARISMA, oPC) + nCasterLevel;
    }

       //Efectos
    effect eBonoAtaque = SupernaturalEffect(EffectAttackIncrease(nBono));

   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonoAtaque, oCreature);
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
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

// End of Spell Cast Hook


    //Declare major variables
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nDuration = (nCasterLevel/2);

    //La Espada Planar
    effect eSummon = EffectSummonCreature("espadaplanar");
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);

    if(nDuration < 5) nDuration = 5;

     //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));

    // Aumentar convocacion
    DelayCommand(2.0, BonosConvocarCriatura());
    DelayCommand(2.0, BonosEspada());
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

