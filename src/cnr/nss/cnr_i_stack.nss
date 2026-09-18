/// ----------------------------------------------------------------------------
/// @system  CNR Tools
/// @file    cnr_i_stack
/// @author  Dhraax
/// @brief   Consume one broken tool while preserving the remaining stack.
/// ----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Remove one broken tool and reset wear for its successor, if present.
/// @param oTool The tool object whose current unit has broken.
/// @param sWearVariable Optional local integer holding current-unit wear.
void CnrStack_BreakTool(object oTool, string sWearVariable = "");

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void CnrStack_BreakTool(object oTool, string sWearVariable = "")
{
    int iCount = GetItemStackSize(oTool);
    if (iCount > 1)
    {
        SetItemStackSize(oTool, iCount - 1);
        if (sWearVariable != "")
        {
            DeleteLocalInt(oTool, sWearVariable);
        }
    }
    else
    {
        DestroyObject(oTool);
    }
}
