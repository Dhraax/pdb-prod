// Main functions file for the HCR Helper
// Archaegeo 2002 June 27

#include "hc_inc"

object oMyTarget=GetLocalObject(OBJECT_SELF,"HCRHtarget");

int hcrh_istargetpc()
{
   if(GetIsObjectValid(oMyTarget) && GetIsPC(oMyTarget))
   {
      return TRUE;
   }
   return FALSE;
}

int hcrh_istargetnvalid()
{
   if(!GetIsObjectValid(oMyTarget))
   {
      return TRUE;
   }
   return FALSE;
}

