///////////////////////////////////////////////////////////////////////////////
//  VARIABLE DECLARATIONS
///////////////////////////////////////////////////////////////////////////////

//const string PRC_Rest_Generation = "PRC_Rest_Generation";
//const string PRC_Rest_Generation_Check = "PRC_Rest_Generation_Check";
//const string PRC_ForcedRestDetector_Generation = "PRC_ForcedRestDetector_Generation";

///////////////////////////////////////////////////////////////////////////////
//  INCLUDES
///////////////////////////////////////////////////////////////////////////////

//#include "prc_alterations"

///////////////////////////////////////////////////////////////////////////////
//  FUNCTION DECLARATIONS
///////////////////////////////////////////////////////////////////////////////

// Returns the number of henchmen a player has.
int GetNumHenchmen(object oPC);

// returns the float time in seconds to close the given distance
//float GetTimeToCloseDistance(float fMeters, object oPC, int bIsRunning = FALSE);

/* PRC ForceRest wrapper
 *
 * ForceRest does not trigger the module's OnRest event, nor will the targeted player show up
 * when GetLastPCRested is used. This wrapper can be used to ForceRest a target, while still
 * running the PRC's OnRest script.
 */
//void PRCForceRest(object oPC);
//void PRCForceRested(object oPC);

///////////////////////////////////////////////////////////////////////////////
//  FUNCTION DEFINITIONS
///////////////////////////////////////////////////////////////////////////////

int GetNumHenchmen(object oPC)
{
     if (!GetIsPC(oPC)) return -1;

     int nLoop, nCount;
     for (nLoop = 1; nLoop <= GetMaxHenchmen(); nLoop++)
     {
          if (GetIsObjectValid(GetHenchman(oPC, nLoop)))
          nCount++;
     }

     return nCount;
}


