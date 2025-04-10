//:://////////////////////////////////////////////////
//:: ScrewTape's Simple XP
//:: q_inc_SimpleXP.nss
//:://////////////////////////////////////////////////
/*
    Experience points rewards
*/
//:://////////////////////////////////////////////////

//::///////////////////////////////////////////////////////////////////////////
//:: DEFINE CONSTANTS
//::///////////////////////////////////////////////////////////////////////////

//* These are the tweaking modifiers, used to adjust the amount of XP awarded.

//* N_MODULE_XP_SLIDER -
//*  Use this just as you would use a module's xp slider
//*  Set to 10 for normal xp - when using 2da's this will be exactly the
//*  same, barring other considerations like henchmen, multiplayer, multiclass,
//*  etc. If your using the DMG tables, 10 equates to 10%, which will be
//*  slightly higher than the Bioware awards. 100 will match the DMG tables.
//*  Recommended N_MODULE_XP_SLIDER settings are 17 for 1st level modules, 10-15
//*  for 2nd-5th, and 7-10 for higher level modules. That should keep you in the
//*  ballpark of the Bioware awards.
//*  NOTE: Although the actual module slider has NO EFFECT on these awards, it
//*  DOES need to be set to zero or else the XP will be awarded twice.
const int N_MODULE_XP_SLIDER = 10;

//* B_USE_MULTICLASS_PENALTY -
//*  This is a boolean (set to TRUE (1) or FALSE (O)) to decide whether or not to
//*  enforce Bioware's multi class penalty.
//*  Idea taken from Bioware scripting forum post by Ima Dufus
//*  FALSE would be like the DMG
const int B_USE_MULTICLASS_PENALTY = FALSE;     // DMG accurate setting
//const int B_USE_MULTICLASS_PENALTY = TRUE;    // alternate setting

//* B_COUNT_ASSOCIATES -
//*  Per Trickster's request, I included an option to count the players' other
//*  associates, summoned/familiar/companion/dominated. In doing so, I realized
//*  I wasn't adhering to the DMG's notes regarding "creatures that enemies
//*  summon or otherwise add to their forces with magic powers. An ememy's
//*  ability to summon or add these creatures is a part of the enemy's CR
//*  already." pp 37, just below the steps to determine the XP award. So I
//*  included that in the option. These two options seemed to be tied together,
//*  that is, if I count the party's associate types when determining total
//*  party members to divide experience by, I should also award XP for enemies'
//*  associates and on the other hand, if I don't count the party's associates
//*  (except henchmen), I shouldn't award XP for enemies' associates.
const int B_COUNT_ASSOCIATES = FALSE;   // DMG accurate setting
//const int B_COUNT_ASSOCIATES = TRUE;  // alternate setting

//* B_COUNT_HENCHMEN -
//*  And why not allow the same option for henchmen
const int B_COUNT_HENCHMEN = TRUE;      // recommended setting
//const int B_COUNT_HENCHMEN = FALSE;   // alternate setting

//* B_AWARD_DEAD_PLAYERS
//*  Allow dead/dying players to receive awards (per DMG, pp 41 'DEATH AND
//*  EXPERIENCE POINTS') but leave the option to disable.
//* PW world users - I have this worked out pretty well to only award dead
//*  players for the last combat that the party was in, however, if you have
//*  a respawning encounter at the same location, the dead guy will continue
//*  to receive awards if he just sits there dead while the rest of the party
//*  keeps killing mobs. Use B_AWARD_DEAD_PLAYERS with caution on PWs. Otherwise,
//*  he will not receive awards until he rejoins the party (physically)
//const int B_AWARD_DEAD_PLAYERS = TRUE; // DMG accurate setting
const int B_AWARD_DEAD_PLAYERS = FALSE;  // alternate setting

//* See the included excel spreadsheet -
//*  I made an excel spreadsheet so you can play with all of these parameters
//*  and see the results.

//* N_ENCOUNTERS_PER_LEVEL
//*  exactly what it says - this is how many encounters, where CR = Level are
//*  required for the pc's to level. This is how the base awards are determined.
//const int N_ENCOUNTERS_PER_LEVEL = 13;    // DMG accurate setting
const int N_ENCOUNTERS_PER_LEVEL = 21;      // Bioware setting (sort of...)

//* N_ENC_INCREASE_SLIDER
//*  This allows the number of encounters per level to increase with each level.
//*  This is sort of what Bioware does (albeit, not very consistently).
//const int N_ENC_INCREASE_SLIDER = 0;  // DMG accurate setting
const int N_ENC_INCREASE_SLIDER = 10;   // Bioware setting

//* N_MAX_CR_GREATER_THAN_HD -
//* N_MAX_HD_GREATER_THAN_CR -
//*  I split these limits into two, so you can prevent higher level pc's from
//*  gaining xp from easy encounters while still gaining awards for very
//*  difficult or impossible encounters
//const int N_MAX_CR_GREATER_THAN_HD = 7;   // DMG accurate setting
const int N_MAX_CR_GREATER_THAN_HD = 200;   // Bioware setting
//const int N_MAX_HD_GREATER_THAN_CR = 7;   // DMG accurate setting
const int N_MAX_HD_GREATER_THAN_CR = 40;    // Bioware setting

//* N_CR_HD_PENALTY_SLIDER -
//*  Modify with care - at the base setting, equivalent encounters yield
//*  equivalent experience (4 CR 0 creatures, 2 CR 2 creatures or 1 CR 4
//*  creature will have the same total xp for example) Both Bioware and DMG
//*  vary slightly from this, Bioware on the down side and the DMG a little
//*  down, but mostly to retain nice even numbers (it's PnP after all).
//const int N_CR_HD_PENALTY_SLIDER = 10;    // DMG - CR equivalencies
const int N_CR_HD_PENALTY_SLIDER = 15;      // Bioware - CR equivalencies

//* N_MAX_AWARD_X_BASE -
//*  limits the maximum award a player can receive for a single creature
//*  modify with care (you could end up with 4 CR 4 creatures awarding
//*  significantly more than 1 CR 8 creature, since they each will be under
//*  the limit, but if N_MAX_AWARD_X_BASE is set very low, the CR 8 creature may
//*  be too high).
const int N_MAX_AWARD_X_BASE = 5;   // 5 = 5 times base xp is Max award

//* N_MEMBER_WEIGHT_SLIDER -
//*  Allows total party members to count for less than actual - requested by
//*  PW server builders - if the setting is at 50% and the number in the party
//*  is 4, total xp will be divided by 2
const int N_MEMBER_WEIGHT_SLIDER = 100; // 100 = 100%

//* PL Limits
//* N_MAX_PARTY_HD_DIFFERENCE is the maximum difference in levels between the
//*  highest and lowest level members
//*  if B_NO_AWARD_FOR_PARTY is TRUE, if party has too many levels of difference,
//*  no one receives an award. If it is FALSE, only those under
//*  N_MAX_PARTY_HD_DIFFERENCE from the highest level member will receive
//*  awards.
const int N_MAX_PARTY_HD_DIFFERENCE = 0;    // 0 = no check (no max)
const int B_NO_AWARD_FOR_PARTY = FALSE;

//::///////////////////////////////////////////////////////////////////////////
//:: DEFINE FUNCTIONS
//::///////////////////////////////////////////////////////////////////////////

// AwardXP, inputs: the killing object, output: none (returned)
void AwardXP(object oKiller);

//::///////////////////////////////////////////////////////////////////////////
//:: FUNCTION IMPLEMENTATION
//::///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// GetHitDiceByXP
//  Solve for hd from xp = hd * (hd - 1) * 500
//  hd = 1/50 * (sqrt(5) * sqrt(xp + 125) + 25)
int GetHitDiceByXP(float fXP)
{
   int nHD = FloatToInt(0.02 * (sqrt(5.0f) * sqrt(fXP + 125.0f) + 25.0f));
   if (nHD < 1) nHD = 1;
   else if (nHD > 40) nHD = 40;
   return nHD;
}

///////////////////////////////////////////////////////////////////////////////
// SetMaxMinLevels
void SetMinMaxHD(object oPlayer)
{
   int nMaxHD = 0;
   int nMinHD = 0;
   int nHD = 0;
   object oMember = GetFirstFactionMember(oPlayer);
   while (GetIsObjectValid(oMember))
   {
      nHD = GetHitDiceByXP(IntToFloat(GetXP(oMember)));

      // check versus max and min
      if (nMaxHD == 0 || nHD > nMaxHD)
         nMaxHD = nHD;

      if (nMinHD == 0 || nHD < nMinHD)
         nMinHD = nHD;

      oMember = GetNextFactionMember(oMember);
   }

   // Store our max an min (do this on self in case party changes between
   // battles, and also so it's independent for multiple parties).
   SetLocalInt(OBJECT_SELF, "nMaxHD", nMaxHD);
   SetLocalInt(OBJECT_SELF, "nMinHD", nMinHD);
}

///////////////////////////////////////////////////////////////////////////////
// IsPlayerEligible, input: player object, output: TRUE or FALSE
int IsPlayerEligible(object oPlayer, int bCountMembers = FALSE)
{
   string sMessage = "";
   int bReturn = TRUE;
   int nMaxHD = 0;
   int nMinHD = 0;
   int nHD    = GetHitDiceByXP(IntToFloat(GetXP(oPlayer)));;

   // Check eligibility requirements when awarding dead players (just distance)
   if (B_AWARD_DEAD_PLAYERS &&
      (GetCurrentHitPoints(oPlayer) > 0) &&
      ((GetArea(OBJECT_SELF) != GetArea(oPlayer)) ||
      (GetDistanceToObject(oPlayer) > 45.0f)))
   {
      sMessage = "Your are too far from combat and thus are ineligible for " +
                 "XP awards.";
      bReturn = FALSE;
   }

   // Otherwise check if player is alive
   else if (!B_AWARD_DEAD_PLAYERS && GetCurrentHitPoints(oPlayer) < 0)
   {
      sMessage = "Your are dead and thus are ineligible for XP awards.";
      bReturn = FALSE;
   }

   // Otherwise check distance to self (the killed creature) - if you have
   //  B_AWARD_DEAD_PLAYERS set to TRUE, it won't keep awarding dead players
   //  once the party moves on if they choose to stay dead. Caveat: if you have
   //  a respawning encounter at the same location, the dead guy will continue
   //  to receive awards if he just sits there dead while the rest of the party
   //  keeps killing mobs. Use B_AWARD_DEAD_PLAYERS with caution on PWs.
   else if ((GetArea(OBJECT_SELF) != GetArea(oPlayer)) ||
           (GetDistanceToObject(oPlayer) > 45.0f))
   {
      sMessage = "Your are too far away and thus are ineligible for XP awards.";
      bReturn = FALSE;
   }

   // Otherwise, check party level difference eligibility (no award for party)
   else if (B_NO_AWARD_FOR_PARTY && N_MAX_PARTY_HD_DIFFERENCE &&
           ((nMaxHD - nMinHD) > N_MAX_PARTY_HD_DIFFERENCE))
   {
      sMessage = "Your party has more than " +
                 IntToString(N_MAX_PARTY_HD_DIFFERENCE) +
                 " levels of difference and thus is ineligible for XP awards.";

      bReturn = FALSE;
   }

   // Otherwise, check party level difference eligibility (no award for low hd members)
   else if (!B_NO_AWARD_FOR_PARTY && N_MAX_PARTY_HD_DIFFERENCE &&
           (nMaxHD - nHD) > N_MAX_PARTY_HD_DIFFERENCE)
   {
      sMessage = "There is more than " +
                 IntToString(N_MAX_PARTY_HD_DIFFERENCE) +
                 " levels of difference between you and the most powerful " +
                 " party member and thus you are ineligible for XP awards.";

      bReturn = FALSE;
   }

   // Let 'em know why they didn't get the award
   if (!bReturn && !bCountMembers)
      SendMessageToPC(oPlayer, sMessage);
   return bReturn;
}

///////////////////////////////////////////////////////////////////////////////
// GetXPFromTable, inputs: level and CR, output: experience points
int GetXPFromTable(int nHD, float fCR)
{
   // Check our hit dice versus CR limits
   int nCR = FloatToInt(fCR);
   if (nCR - nHD > N_MAX_CR_GREATER_THAN_HD ||
       nHD - nCR > N_MAX_HD_GREATER_THAN_CR)
      return 1;

   int nAward = 0;
   int nMaxAward = 0;

   // Otherwise, determine XP

   // Convert to floats to minimize truncation error
   float fHD = IntToFloat(nHD);

   // Sanity check
   if (fHD < 1.0f)
      fHD = 1.0f;

   // Determine what it took to be this level
   float fXPLevel = fHD * (fHD - 1.0f) * 500.0f;

   // And what it takes to be the next level
   float fXPNextLevel = fHD * (fHD + 1.0f) * 500.0f;

   // And take the difference
   float fXPDifference = fXPNextLevel - fXPLevel;

   // Convert to floats to minimize truncation error
   float fEncPerLevel = IntToFloat(N_ENCOUNTERS_PER_LEVEL);

   // Check our increase slider and adjust encounters per level if need be
   if (N_ENC_INCREASE_SLIDER)
   {
      float fInc = IntToFloat(N_ENC_INCREASE_SLIDER);
      fEncPerLevel = fEncPerLevel + (fInc * (fHD - 1.0f) * 0.33f);
   }

   // Sanity check (it IS configurable...)
   if (fEncPerLevel < 1.0f)
      fEncPerLevel = 1.0f;

   // And use it to determine xp for this many encounters per level
   float fBaseXP = fXPDifference / fEncPerLevel;

   // Adjust for CR vs Level difference
   float fAdjust = IntToFloat(N_CR_HD_PENALTY_SLIDER) / 100.0f;

   if (FloatToInt(fCR) == nHD)
      nAward = FloatToInt(fBaseXP);
   else if (fCR > fHD)
      nAward = FloatToInt(fBaseXP * pow((1.5f - fAdjust), (fCR - fHD)));
   else // fHD > fCR
      nAward = FloatToInt(fBaseXP * pow((0.8f - fAdjust), (fHD - fCR)));

   // Adjust for maximum
   nMaxAward = N_MAX_AWARD_X_BASE * FloatToInt(fBaseXP);
   if (nAward > nMaxAward)
      nAward = nMaxAward;

   // Phew!
   return nAward;
}

///////////////////////////////////////////////////////////////////////////////
// AwardXP, inputs: the killing object, output: none (returned)
void AwardXP(object oKiller)
{
   // We'll start by declaring (and sometimes getting) our variables
   //  we received the killer as an argument (don't need to declare)
   float  fPartyMembers = 0.0f;
   int    nIndex = 0;
   int    nHD = 0;
   int    nXP = 0;
   int    nHoldXP = 0;
   int    nAssociateType = 0;
   float  fTotalXP = 0.0f;
   float  fScale = 1.0f;
   float  fCR = GetChallengeRating(OBJECT_SELF);
   object oMaster = GetMaster(oKiller);
   object oMember;

   // Update 8/29/10 - if OBJECT_SELF is a trap then get the CR from the
   //  variable stored on OBJECT_SELF.
   if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_DOOR ||
       GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE ||
       GetObjectType(OBJECT_SELF) == OBJECT_TYPE_TRIGGER)
   {
       fCR = GetLocalFloat(OBJECT_SELF, "ST_TRAP_CR");
   }

   // Update 5/19/04 - make sure we check the actual master in case we have a
   //  henchman or other associate who also has an associate (for example,
   //  henchman is a wizard and has a familiar or has summoned a creature).
   // Update 07/12/04 thanks to ***RodneyOrpheus*** fixed nasty bug here
   while (GetIsObjectValid(oMaster))
   {
      oKiller = oMaster;
      oMaster = GetMaster(oKiller);
   }

   // Sanity check - should only happen if creature is invalid
   //  No point in calculating any more if CR is less than or = to 0
   //  or if the script's module slider is set to 0
   if (fCR <= 0.0 || N_MODULE_XP_SLIDER == 0)
      return;

   // Before we start calculating XP, let's check to see if we are a controlled
   //  type* of someone else. * summoned/familiar/companion/dominated
   // Update 8/5/04 - thanks ***Belial Prime*** - we were hitting this check on
   //  DM controlled enemies, where we should still be awarding xp.
   //  Used GetAssociateType instead of GetMaster.
   if (B_COUNT_ASSOCIATES == FALSE &&
       GetAssociateType(OBJECT_SELF) != ASSOCIATE_TYPE_NONE)
      return;

   // This will also ensure we award XP for traps.
   //  Thanks to *** Sotae *** for this idea
   if (GetIsObjectValid(GetTrapCreator(oKiller)))
      oKiller = GetTrapCreator(oKiller);

   // Determine level differences if necessary
   if (N_MAX_PARTY_HD_DIFFERENCE)
      SetMinMaxHD(oKiller);

   // First let's determine the number of members in the party. The values of
   //  B_COUNT_HENCHMEN and B_COUNT_ASSOCIATES will determine whether or not
   //  we count henchman and other associates when determining the total number
   //  of party members to divide the Total XP award by. Although the DMG
   //  doesn't specify for players, the DMG does specify for that for enemies,
   //  we don't count xp separately for their creatures added to their forces.
   //  Since henchman can play such a big role, I recommend counting them.
   //  Note: I don't award XP to associates, I just use them in determining
   //  the factor to divide the total XP if specified.
   oMember = GetFirstFactionMember(oKiller); // this only returns PC's
   while (GetIsObjectValid(oMember))
   {
      // Sanity check - first let's see if the PC member is in the same area as
      //  the creature just killed  and if the member was in combat. This way,
      //  if the member's in the area, but not in combat - we won't include
      //  him. It should be noted, there's a delay after an enemy is killed and
      //  before a PC is no longer in combat. (Try resting immediately after
      //  you've killed an enemy, and also note the music). This delay is
      //  sufficient for us to count XP. Handy! Note: this delay does NOT occur
      //  if the player is dead, so dead members will NOT be awarded XP.
      if (IsPlayerEligible(oMember, TRUE))
      {
         // Add the PC him/herself
         fPartyMembers += IntToFloat(N_MEMBER_WEIGHT_SLIDER) / 100.0f;

         // We'll treat henchmen separately from the other associates, as,
         //  since version 1.59, you can have more than one henchman.
         if (B_COUNT_HENCHMEN)
         {
            // Loop through the available henchmen and see if he's got 'em
            //  Update 08/05/04 - fixed off by one error in the comparison
            for (nIndex = 1; nIndex <= GetMaxHenchmen(); nIndex++)
            {
               if (GetIsObjectValid(GetHenchman(oMember, nIndex)))
                  // Increment by number of henchmen
                  fPartyMembers +=
                     IntToFloat(N_MEMBER_WEIGHT_SLIDER) / 100.0f;
            }
         }

         // According to the lexicon, henchman is the only associate type
         //  that the PC's can have more than one of, so we'll make a simple
         //  check once for each type. I looked in the nwscript.nss file, and
         //  the associate types range from 0 - 5 (where 0 is none, 1 is
         //  henchmen and 2 - 5 are the one's we are interested in)
         if (B_COUNT_ASSOCIATES)
         {
            // Loop through each associate type, not including henchmen
            for (nAssociateType  = ASSOCIATE_TYPE_ANIMALCOMPANION;
                 nAssociateType <= ASSOCIATE_TYPE_DOMINATED; nAssociateType++)
            {
               if (GetIsObjectValid(GetAssociate(nAssociateType, oMember)))
                  // Increment by number of associates
                  fPartyMembers +=
                     IntToFloat(N_MEMBER_WEIGHT_SLIDER) / 100.0f;
            }
         }

      } // End if (IsPlayerEligible(oMember))

      // Get the next guy in the PC's party
      oMember = GetNextFactionMember(oMember);
   } // end while (GetIsObjectValid(oMember))

   // Minimum party members is 1
   if (fPartyMembers < 1.0f)
      fPartyMembers = 1.0f;

   // According to the DMG, there are 6 steps. The 6th step is a loop, so
   //  we'll start with that. (why didn't we start yet - because we needed to
   //  know the total party members first)
   oMember = GetFirstFactionMember(oKiller);
   while (GetIsObjectValid(oMember))
   {
      // Same check as before
      if (IsPlayerEligible(oMember))
      {
         // Step 1. determine character level
         // Update 08/05/04 - thanks ***Belial Prime*** We want to get level
         //  by xp, to discourage pcs from waiting to level
         nHD = GetHitDiceByXP(IntToFloat(GetXP(oMember)));

         // Step 2. get the monster's fCR
         //  fCR = GetChallengeRating(OBJECT_SELF); // we've already done this

         // Step 3. consult the table and adjust using N_MODULE_XP_SLIDER
         // Update 08/05/04 - go back to using rounding instead of truncation
         fScale = IntToFloat(N_MODULE_XP_SLIDER) / 10.0f;
         fTotalXP = IntToFloat(GetXPFromTable(nHD, fCR)) * fScale;

         // Step 4. divide the XP by the number of party members
         //  we did the sanity check above, so we can't get DIV/0
         nXP = FloatToInt((fTotalXP / fPartyMembers) + 0.5f);

         // Step 5. is taken care of by calling this script when each
         //  monster's OnDeath script gets called (this one)

         // Award the XP to the PC - always award at least 1 xp so we know the
         //  awards are working
         if (nXP <= 0)
            nXP = 1;

         // Use the standard bioware penalty for multi-class characters
         if (B_USE_MULTICLASS_PENALTY)
            GiveXPToCreature(oMember, nXP);

         // Or use get and set to bypass the multi-class penalty
         //  Thanks to *** Ima Dufus *** for this idea
         else
         {
            // We'll get the current xp
            nHoldXP = GetXP(oMember);

            // Add them to our newly calculated xp
            nXP += nHoldXP;

            // And re-assign the total,
            //  thus bypassing the multi-class penalty
            SetXP(oMember, nXP);
         }

      } // End if (IsPlayerEligible(oMember))

      // Step 6. get the next guy
      oMember = GetNextFactionMember(oMember);
   } // End while (GetIsObjectValid(oMember))
}


