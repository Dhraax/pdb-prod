#include "cab_inc"

int StartingConditional()
{
  if(VerSiEsMascota() == TRUE &&
     GetMaster() == GetPCSpeaker()) return TRUE;

  return FALSE;
}
