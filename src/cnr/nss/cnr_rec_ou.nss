/// ----------------------------------------------------------------------------
/// @system  CNR Recycling
/// @file    cnr_rec_ou
/// @author  Dhraax
/// @brief   Opens the recycler preview after its inventory closes.
/// ----------------------------------------------------------------------------

#include "cnr_i_recycle"

void main()
{
    object oPC = GetLastUsedBy();
    object oMachine = OBJECT_SELF;
    if (!GetIsPC(oPC))
    {
        return;
    }
    if (GetLocalInt(oMachine, CNR_REC_LOCK))
    {
        DeleteLocalObject(oPC, CNR_REC_PENDING);
        return;
    }
    if (GetLocalObject(oPC, CNR_REC_PENDING) != oMachine)
    {
        SetLocalObject(oPC, CNR_REC_PENDING, oMachine);
        return;
    }
    DeleteLocalObject(oPC, CNR_REC_PENDING);
    DeleteLocalObject(oPC, CNR_REC_ITEM);
    DeleteLocalString(oPC, CNR_REC_PLAN);
    DeleteLocalInt(oPC, CNR_REC_QUANTITY);

    object oItem = CnrRec_Input(oMachine);
    string sText = "Introduce un solo objeto o pila fabricado en una mesa de oficio.";
    if (GetIsObjectValid(oItem))
    {
        string sPlan = CnrRec_Plan(oItem);
        if (sPlan == "")
        {
            sText = "No se pudo consultar la receta. No se ha gastado nada.";
        }
        else
        {
            SetLocalObject(oPC, CNR_REC_ITEM, oItem);
            SetLocalString(oPC, CNR_REC_PLAN, sPlan);
            SetLocalInt(oPC, CNR_REC_QUANTITY, GetItemStackSize(oItem));
            sText = "Reciclar " + IntToString(GetItemStackSize(oItem)) + " x "
                  + GetName(oItem) + ".\n\n" + CnrRec_Describe(sPlan)
                  + "\n\nSe destruira toda la pila. Confirma solo si quieres continuar.";
        }
    }
    SetCustomToken(CNR_REC_TOKEN, sText);
    SetLocalInt(oMachine, CNR_REC_LOCK, TRUE);
    DelayCommand(CNR_REC_SEAL_SECONDS, DeleteLocalInt(oMachine, CNR_REC_LOCK));
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC,
        ActionStartConversation(oMachine, "cnr_c_recycle", TRUE, FALSE));
}
