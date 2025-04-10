//::///////////////////////////////////////////////
//:: Name  WHEELER PRIZE AWARD
//::    this is called on the conversation for the wheel of fortune operator
//:://////////////////////////////////////////////
/*
  when last we left our heroic script, it generated custom tokens
  for the wheeler to speak about prizes, and set local variables
  about those prizes on the npc.
  in this chapter, we're going to pay out the prizes.
*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//::   this swipes heavily from the slots script by steve hunter
//:://////////////////////////////////////////////

//-- local str: WHEELER  sPrize = prize name/type.
//-- local int: WHEELER payout = payout amount in gp.
//-- local int: WHEELER goodie = constant spell type
//-- blah blah beastie = polymorph type
//-- sPotionID = blueprint for potion creation
//-- sMPID = BAH! use sPotionID for these, too.
#include "inc_timelock"

void main()
{
    object oPC = GetPCSpeaker();
    string sPC = GetName(oPC);
    object oWheeler = GetObjectByTag("WHEELER");
    object oBouncer = GetObjectByTag("Bouncer");
    string sPrize = GetLocalString(oWheeler, "sPrize");
    int payout = GetLocalInt(oWheeler, "payout");

//---DEBUGGING-------------------------

   //int goodie = GetLocalInt(oWheeler, "goodie");
   //int beastie = GetLocalInt(oWheeler, "beastie");
   //string sPotionID = GetLocalString(oWheeler, "sPotionID");
//-- leave these in, it seems to work better
//------------------------------------------------

//-- step 1, if the payout is gold, just pay the fool.

   if (payout > 0 && payout < 10000)
    {
      GiveGoldToCreature(oPC, payout);
      PlaySound("it_coins");
      TakeGoldFromCreature(payout, oBouncer, FALSE);
      SetTimelock(oPC, 15, "Rueda de la Fortuna", 0, 0);
    }
    else if (payout == 10000)
    {
      GiveGoldToCreature(oPC, payout);
      PlaySound("it_coins");
      AssignCommand(oWheeler, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2));
      AssignCommand(oWheeler, ActionSpeakString(sPC + " Ganador del Bote!"));
      TakeGoldFromCreature(payout, oBouncer, FALSE);
      SetTimelock(oPC, 15, "Rueda de la Fortuna", 0, 0);
    }


    //-- now if it is 0, there's special stuff.
    else
     {


       if (sPrize == "Pierde")
        {
         sPrize = "Pierde";
         payout = 0;
         PlayVoiceChat(VOICE_CHAT_LAUGH, oWheeler);
         SetTimelock(oPC, 15, "Rueda de la Fortuna", 0, 0);
        }

       }




//-- at the end of everything, destroy the local variables on the wheeler

     DeleteLocalInt(oWheeler, "payout");
     DeleteLocalString(oWheeler, "sPrize");


//    DeleteLocalInt(oWheeler, "goodie");
//     DeleteLocalString(oWheeler, "sPotionID");
//     DeleteLocalString(oWheeler, "beastie");


}


