//sr 5.3
// use this script in a area on_enter event to allow rest in the area
// without timer resting restrictions. Can also do this when the module loads
// in the hc_setareavars script.
// note: this could be abused by players casting buffs on friends and reresting
//       use with caution or add time advance to remove buffs.
#include "hc_inc_pwdb_func"



void main()
{
object oPC = GetEnteringObject();
if (GetIsPC(oPC))
 {
    SetPersistentInt(GetArea(oPC), "ALLOWREST", TRUE);
 }
}
