//::///////////////////////////////////////////////
//:: Alarm
//:: NW_S0_Alarm
//:: Copyright (c) 2024 Puerta de Baldur
//:://////////////////////////////////////////////
/*
    El conjuro de Alarma emite una alarma de tipo mental o audible cada vez que
    una criatura de tamaño diminuto o mayor entra en la zona vigilada y la toca.
*/
//:://////////////////////////////////////////////
//:: Created By: Puerta de Baldur
//:: Modified By: Mimiqp (mimiqp100@gmail.com)
//:: Modified On: Jun 02, 2024
//:: Modifications: MVP conversion from
//:: being a function called on object usage to
//:: a spell memorised from the spellbook and used
//:: as any other spell from the game.
//:://////////////////////////////////////////////



#include "x2_inc_switches"
#include "x2_inc_spellhook"
#include "mti_libreria"

void crearAlarma(object oPC, location lLugar){
   object oAlarma= CreateObject(OBJECT_TYPE_CREATURE, "sute_bicho_alarma", lLugar, FALSE);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectTrueSeeing(), oAlarma);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectEthereal(), oAlarma);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectInvisibility(INVISIBILITY_TYPE_IMPROVED), oAlarma);
   SetLocalObject(oAlarma, "PCCREADOR", oPC);
}

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
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


   object oPC=OBJECT_SELF;

   if (GetIsDM(oPC)==FALSE)
   {
        location lLugar= GetLocation(oPC);

        int nDuration = GetCasterLevel(OBJECT_SELF);
        int nMetaMagic = GetMetaMagicFeat();
        //Enter Metamagic conditions
        if (nMetaMagic == METAMAGIC_EXTEND)
        {
            nDuration = nDuration *2; //Duration is +100%
        }

        effect eVis = EffectVisualEffect(VFX_DUR_GLYPH_OF_WARDING);

        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lLugar, 30.0f);
        crearAlarma(oPC, lLugar);
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

