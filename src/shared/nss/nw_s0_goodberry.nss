//::///////////////////////////////////////////////
//:: Goodberry
//:: NW_S0_Goodberry
//:: Copyright (c) 2024 Puerta de Baldur
//:://////////////////////////////////////////////
/*
    El druida crea en su mano 2d4 bayas que pueden calmar el hambre si se
    ingieren o pueden curar rasguños si se frota su jugo sobre una herida.
*/
//:://////////////////////////////////////////////
//:: Created By: Puerta de Baldur
//:: Modified By: Mimiqp (mimiqp100@gmail.com)
//:: Modified On: May 20, 2024
//:: Modifications: MVP conversion from
//:: being a function called on object usage to
//:: a spell memorised from the spellbook and used
//:: as any other spell from the game.
//:://////////////////////////////////////////////


#include "x2_inc_spellhook"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

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

    object oPC = OBJECT_SELF;
    float fDuracion = IntToFloat(GetHitDice(oPC));
    int nMetaMagic = GetMetaMagicFeat();

    //Calculate the amount of berries to be created
    int iAmount = d4(2);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
          iAmount = 8;//Damage is at max
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
          iAmount = iAmount + iAmount / 2; //Empower
    }

    //Create as many berries as iAmount
    int iCount = iAmount;
    while(iCount > 0)
    {
        CreateItemOnObject("buenasbayas", oPC);
        iCount--;
    }
    SendMessageToPC(oPC,IntToString(iAmount)+" bayas creadas.");

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
