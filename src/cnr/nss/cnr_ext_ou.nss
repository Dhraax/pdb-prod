/// ----------------------------------------------------------------------------
/// @system  CNR Arcane
/// @file    cnr_ext_ou
/// @author  Dhraax
/// @brief   OnUsed of cnrExtractor. Opens the machine's conversation.
///
///          A conversation and not a NUI window on purpose: the conversation
///          closes the container's inventory and holds the player still, so
///          between reading what is about to be destroyed and confirming it,
///          the contents cannot change.
///
///          Inventory placeables fire OnUsed twice - once opening and once
///          after closing - so this waits for the second, the way
///          cnr_device_ou does: the first leaves the inventory open for
///          loading items.
///
///          Two things keep that from turning into a loop. The use action is
///          cleared before the conversation starts, because otherwise the
///          engine finishes opening the container when the talk ends and the
///          pair of events starts the talk all over again. And a short lock on
///          the machine swallows anything that still arrives right afterwards.
/// ----------------------------------------------------------------------------

#include "cnr_i_extract"

/// Custom token the dialogue prints. 22400 is free; CNR uses 22000-22399.
const int CNR_EXT_TOKEN = 22400;

void main()
{
    object oPC = GetLastUsedBy();
    object oMachine = OBJECT_SELF;

    if (!GetIsPC(oPC))
    {
        return;
    }

    // Deaf right after a conversation: these are the engine's leftovers, and
    // the toggle must not keep half a cycle from them.
    if (GetLocalInt(oMachine, CNR_EXT_VAR_LOCK))
    {
        DeleteLocalObject(oPC, CNR_EXT_VAR_PENDING);
        return;
    }

    if (GetLocalObject(oPC, CNR_EXT_VAR_PENDING) != oMachine)
    {
        SetLocalObject(oPC, CNR_EXT_VAR_PENDING, oMachine);
        return;
    }
    DeleteLocalObject(oPC, CNR_EXT_VAR_PENDING);

    int iInside = CnrExt_CountItems(oMachine);
    int iBreakable = CnrExt_CountBreakable(oMachine);
    int iUnidentified = CnrExt_CountUnidentified(oMachine);

    string sText;
    if (iInside == 0)
    {
        sText = "La máquina está vacía. Mete objetos que hayas encontrado y "
              + "extraerá la esencia urdímbrica que guardan.";
    }
    else if (iBreakable == 0 && iUnidentified > 0)
    {
        sText = "El objeto está sin identificar. No puedes procesar esto.\n\n"
              + "Identifícalo primero y vuelve: la esencia sigue dentro.";
        if (iUnidentified > 1)
        {
            sText = "Hay " + IntToString(iUnidentified) + " objetos sin "
                  + "identificar. No puedes procesarlos.\n\nIdentifícalos "
                  + "primero y vuelve: la esencia sigue dentro.";
        }
    }
    else if (iBreakable == 0)
    {
        sText = "Nada de lo que hay dentro guarda esencia. Solo la conservan los "
              + "objetos que se encuentran, y lo que ya está encantado no "
              + "vuelve atrás.";
    }
    else
    {
        sText = "Dentro hay " + IntToString(iBreakable) + " objeto"
              + (iBreakable == 1 ? "" : "s") + " de los que puede extraer esencia";
        if (iInside > iBreakable)
        {
            sText += ", y " + IntToString(iInside - iBreakable) + " que no";
        }
        if (iUnidentified > 0)
        {
            sText += ". De esos, " + IntToString(iUnidentified)
                   + " solo esperan a que los identifiques";
        }
        sText += ".\n\nExtraerla los destruye. No hay vuelta atrás.";
        if (iBreakable > CNR_EXT_BATCH_CAP)
        {
            sText += "\n\nSon demasiados: la máquina solo admite "
                   + IntToString(CNR_EXT_BATCH_CAP) + " a la vez.";
        }
    }

    SetCustomToken(CNR_EXT_TOKEN, sText);

    SetLocalInt(oMachine, CNR_EXT_VAR_LOCK, TRUE);
    DelayCommand(CNR_EXT_SEAL_SECONDS,
                 DeleteLocalInt(oMachine, CNR_EXT_VAR_LOCK));

    // Dropping the queued use action first: with it still there the engine
    // reopens the container the moment the talk ends, and that reopening fires
    // the same pair of events that started the talk.
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC,
        ActionStartConversation(oMachine, "cnr_c_extract", TRUE, FALSE));
}
