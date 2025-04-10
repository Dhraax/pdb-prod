//::///////////////////////////////////////////////
//:: Spell Hook Additional Auxiliary functions
//:: x2_inc_spellaux
//:: Created By: Mimiqp (mimiqp100@gmail.com)
//:: Created On: Jun 03, 2024
//:://////////////////////////////////////////////
/*
    Libary of additional functions meant to be used from within x2_inc_spellhook
*/


#include "nw_s0_mgcconvlf"

//This function is meant to concentrate all the post hook calls related to
//spells.
//In this way we only need to modify this function and we leave x2_inc_spellhook
//clean and unchanged.
void X2PostSpellCastCode_Aux();


//------------------------------------------------------------------------------
//This function is meant to concentrate all the post hook calls related to
//spells.
//In this way we only need to modify this function and we leave x2_inc_spellhook
//clean and unchanged.
//------------------------------------------------------------------------------
void X2PostSpellCastCode_Aux()
{
    //Run the code for the Magic Convalescence script
    X2PostSpellCastCode_MagicConvalescence();
}
