#include "hc_inc_htf"
#include "HC_Inc_TimeCheck"

void main()
{
  int nUser = GetUserDefinedEventNumber();

  if (nUser == HTFCHKEVENTNUM)
  {
      int nCheckTime;
      nCheckTime = SecondsSinceBegin();
      nCheckTime += (FloatToInt(HoursToSeconds(1)) / 60) * HTFCHKTIMER;
      SetLocalInt(oMod, "NEXTHTFCHECK", nCheckTime);
      LoopHTFSystemChk();
  }
}
