//::///////////////////////////////////////////////
//:: FileName ukiconj_oro_3mil
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/07/2007 1:54:45
//:://////////////////////////////////////////////
int StartingConditional()
{
    int iOro = GetGold(GetPCSpeaker());
        if(iOro >= 15000)
            {
          TakeGoldFromCreature(15000, GetPCSpeaker(), TRUE);
              return TRUE;
            }
         else
            {
            return FALSE;
            }

}
