/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_jeweler_anim
//
//  Desc:  This script animates the PC when crafting
//         at the jewelers bench.
//
//  Author: David Bobeck 13Mar03
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
    SetLocalFloat(oPC, "fCnrAnimationDelay", 8.0);
    int bSuccess = GetLocalInt(oPC, "bCnrCraftingResult");

    int nEnd = bSuccess ? ANIMATION_FIREFORGET_STEAL
                        : ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD;

    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 3.0));
    DelayCommand(3.0, AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED, 1.0, 1.0)));
    DelayCommand(4.0, AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 3.0)));
    DelayCommand(7.0, AssignCommand(oPC, PlayAnimation(nEnd, 1.0)));
    PlaySound("as_cv_ropepully1");
    DelayCommand(4.0, PlaySound("as_cv_chiseling2"));
  }
}
