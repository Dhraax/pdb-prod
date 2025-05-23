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
        if(iOro >= 3000)
            {
          TakeGoldFromCreature(3000, GetPCSpeaker(), TRUE);
              return TRUE;
            }
         else
            {
            return FALSE;
            }

}
