/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_tailor_anim
//
//  Desc:  This script animates the PC when crafting
//         at the tailor's table.
//
//  Author: Gary Corcoran 21Mar03
//
//
//  modified by: Dhraax 19Aug26
//  The animation no longer goes through the action queue. ActionPlayAnimation
//  queues an action on the player, and a player queued full of actions while a
//  conversation is open leaves the menu half drawn: the client keeps showing
//  the last node it got and the clicks stop arriving. PlayAnimation is
//  immediate, so the same animation plays without the queue being involved,
//  and the steps are chained with DelayCommand instead.
/////////////////////////////////////////////////////////
void main()
{
  object oPC = GetLocalObject(OBJECT_SELF, "oCnrCraftingPC");

  if (GetIsPC(oPC))
  {
    // The animation delay should be set to the number of seconds it
    // takes to complete this animation.
    SetLocalFloat(oPC, "fCnrAnimationDelay", 5.0);
    int bSuccess = GetLocalInt(oPC, "bCnrCraftingResult");

    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.0));
    DelayCommand(2.0, AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0)));
    DelayCommand(3.0, AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.0)));
    PlaySound("as_sw_clothcl1");
    DelayCommand(1.5, PlaySound("as_sw_clothlk1"));
    DelayCommand(3.0, PlaySound("as_sw_clothcl1"));
  }
}

