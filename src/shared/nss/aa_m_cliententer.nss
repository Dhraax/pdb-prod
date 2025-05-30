////////////////////////////////////////////////////////////////////////////////
//                        ON CLIENT ENTER EVENT SCRIPT                        //
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  Script used to destroy the imbued arrows on an entering player.           //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//Created By  : Nailog                                                        //
//Last Edited : 7-26-2004                                                     //
////////////////////////////////////////////////////////////////////////////////

//Include required for Imbue Arrow functionality.
#include "aa_i_main"

void main()
{
  //Grab the entering player.
  object oPC = GetEnteringObject();

  //Destroy imbued arrows.
  AADestroyAllImbuedArrows(oPC);
  DestroyImbuedArrowsInContainer(oPC);
}
