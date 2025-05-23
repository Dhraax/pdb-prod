////////////////////////////////////////////////////////////////////////////////
//                        ON PLAYER REST EVENT SCRIPT                         //
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  Script used to destroy all imbued arrows in the player's inventory.  Since//
//the temporary item properties wear out on resting, not destroying the arrows//
//would leave trash in the player's inventory.  If you choose to disable this //
//part of the system, know that a player will be able to re-enchant the arrow,//
//if they desire.                                                             //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//Created By  : Nailog                                                        //
//Last Edited : 7-26-2004                                                     //
////////////////////////////////////////////////////////////////////////////////

//Include required for Imbue Arrow functionality.
#include "aa_i_main"

void main()
{
  //Get the resting player.
  object oPC = GetLastPCRested();

  //Destroy imbued arrows.
  AADestroyAllImbuedArrows(oPC);
}
