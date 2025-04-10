#include "NW_I0_PLOT"
int StartingConditional()
{
  //Miramos si tiene 200 monedas
  if(HasGold(200, GetPCSpeaker())) return TRUE;

  return FALSE;
}
