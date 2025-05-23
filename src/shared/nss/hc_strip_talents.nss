// hcr3.1
// readded this script as no longer do spell tracking.
// if you want spell tracking and the overhead then download a addon.
void DecrementTalentIndex(int iIndex, object oPC);

void main()
{
    object oPC = OBJECT_SELF;
    SetLocalInt(GetModule(), GetName(oPC)+GetPCPlayerName(oPC)+"NOTRESTED", TRUE);
    int iIndex;

    for (iIndex = 1; iIndex < 1000; iIndex++)
    {
        DecrementTalentIndex(iIndex, oPC);
    }
}

void DecrementTalentIndex(int iIndex, object oPC)
{
    int iDecrementIndex;

    talent tSpell;
    talent tFeat;

/* create our talent */
    tSpell = TalentSpell(iIndex);
    tFeat = TalentFeat(iIndex);

/* check for all spells */
    if (GetIsTalentValid(tSpell))
    {
        if (GetHasSpell(GetIdFromTalent(tSpell), oPC))
        {
            for (iDecrementIndex = 1; iDecrementIndex < 20; iDecrementIndex++)
            {
                DecrementRemainingSpellUses(oPC, GetIdFromTalent(tSpell));
                if(!GetHasSpell(GetIdFromTalent(tSpell), oPC))
                    iDecrementIndex=20;
            }
        }
    }

/* check for all feats*/
    if (GetIsTalentValid(tFeat))
    {
        if (GetHasFeat(GetIdFromTalent(tFeat), oPC))
        {
            for (iDecrementIndex = 1; iDecrementIndex < 20; iDecrementIndex++)
            {
                DecrementRemainingFeatUses(oPC, GetIdFromTalent(tFeat));
                if(!GetHasFeat(GetIdFromTalent(tFeat), oPC))
                    iDecrementIndex=20;
            }
        }
    }
}

