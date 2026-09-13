/// ----------------------------------------------------------------------------
/// @system  (CNR DIALOGUE SYSTEM)
/// @file    (cnr_strt_journal.nss)
/// @author  Dhraax
/// @brief   Script to force start the conversation 'cnr_c_journal' on the speaker.
/// ----------------------------------------------------------------------------

#include "cnr_recipe_utils"
#include "mti_libreria"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Starts the conversation 'cnr_c_journal' on the triggering player.
/// @param oPC The player character who should receive the conversation.
/// @returns Nothing.
void StartCNRJournalConversation(object oPC);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

/// @brief Starts the conversation 'cnr_c_journal' on the triggering player.
/// @param oPC The player character who should receive the conversation.
/// @returns Nothing.
void StartCNRJournalConversation(object oPC)
{
    if (oPC == OBJECT_INVALID)
    {
        PrintString("DEBUG: oPC es INVALID en StartCNRJournalConversation");
        return;
    }
    object oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
    SetLocalInt(oPC, "nCnrMenuPage", 0);
    SetLocalObject(oPC, "CnrJournalInUse", oContainer);
    SetLocalObject(oPC, "oCnrJournalTarget", oPC);
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionStartConversation(oPC, "cnr_c_journal", TRUE));
}

void main()
{
    object oPC = GetPCSpeaker();
    if (oPC == OBJECT_INVALID)
    {
        PrintString("DEBUG: oPC es INVALID en main.");
        return;
    }
    else
    {
        PrintString("DEBUG: oPC es VALID en main.");
    }
    StartCNRJournalConversation(oPC);
}
