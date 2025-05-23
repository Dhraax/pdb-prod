#include "f_vampire_onrest"
void main()
{
  if(Vampire_On_Rest()) return;

  ExecuteScript("hc_on_play_rest", OBJECT_SELF);
}
