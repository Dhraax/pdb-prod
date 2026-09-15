/// ----------------------------------------------------------------------------
/// @system  CNR Oficios
/// @file    cnr_ofi_conv
/// @author  Dhraax
/// @brief   Conversation action: convert this trade's old progression into CNR.
///
///          The trade arrives as the action parameter "oficio", numbered the
///          way CnrSkill_* numbers them. Everything the conversion does, and
///          everything it refuses to do, is in cnr_i_legacy; this script only
///          carries the parameter across.
/// ----------------------------------------------------------------------------

#include "cnr_i_legacy"

void main()
{
    int nSkill = StringToInt(GetScriptParam("oficio"));
    if (nSkill < 1)
    {
        PrintString("[OFICIOS] cnr_ofi_conv sin parametro 'oficio'");
        return;
    }
    CnrLegacy_Convert(GetPCSpeaker(), nSkill);
}
