//::///////////////////////////////////////////////
//:: Invisibility Sphere
//:: NW_S0_InvSph.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 15ft are rendered invisible.
    Modified by : Rabidness
             on : June 20 , 2004
    Changes:
        - Fixed an issue where the AOE would dispell if the CASTER left the AOE
            ...when the AOE was supposed to be centered ON the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "colors_inc"

//Function called to remove the AOE effect when it is dead, since the normal
//AOE onExit script is disabled against the creator of the effect
//VvVvV This whole function has been added by Rabidness VvVvV
void delayDispell( object oTarget )
{
    effect eAOE;
    if(GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            //If the effect was created by the AOE then remove it
            if(GetEffectSpellId(eAOE) == SPELL_INVISIBILITY_SPHERE)
            {
                RemoveEffect(oTarget, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    DeleteLocalObject( oTarget , "oInvisSphereSource" );
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
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

    object oTarget = OBJECT_SELF;
    // No funciona montado en montura
    if(ObtenerIntPersistente(oTarget, "CAB_MONTADO") > 0)
    {
        SendMessageToPC(OBJECT_SELF, ColorToken(254,60,60) + "Los conjuros de invisivilidad no ocultan a criaturas montadas en montura.</c>");
        return;
    }

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_INVIS_SPHERE);
    int nDuration = GetCasterLevel(oTarget);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, TurnsToSeconds(nDuration));

    //VvVvV Rabidness additions VvVvV
    SetLocalObject( oTarget , "oInvisSphereSource" , oTarget );
    DelayCommand( TurnsToSeconds(nDuration) , delayDispell( oTarget ) );
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
