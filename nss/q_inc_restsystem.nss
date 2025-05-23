//:: Project Q Rest System Funtion Library
/*
    Culled from NwnE
*/
//:://////////////////////////////////////////////

#include "x2_inc_restsys"


//::////////////////////////////////////////////////////////////////////////////
//:: FUNCTION DECLARATION
//::////////////////////////////////////////////////////////////////////////////

// Stores the spells memorized and uses available for oPC when they initiate a
// rest action
void rs_StoreMemorizedSpellUsage(object oPC);

// Restores the spells memorized and uses available for oPC when they finish or
// interrupt a rest action
void rs_ResetMemorizedSpellUsage(object oPC);

// Advance the game clock the amount indicated
// nHr = Hours
// nMin = Minutes
// nSec = Seconds
// nMil = Milliseconds
void rs_IndexGameClock(int nHr = 0, int nMin = 0, int nSec = 0, int nMil =0);


//::////////////////////////////////////////////////////////////////////////////
//:: IMPLENTATION
//::////////////////////////////////////////////////////////////////////////////

void rs_StoreMemorizedSpellUsage(object oPC)
{
    //Store pre-rest values for all memorized spells
    int nSpell, nUses;
    for (nSpell = 0; nSpell < 599; nSpell ++)
    {
        nUses = GetHasSpell(nSpell, oPC);
        if (nUses > 0)
        {
            SetLocalInt(oPC, IntToString(nSpell), nUses);
        }
    }
}

void rs_ResetMemorizedSpellUsage(object oPC)
{
    //Reset spells to their pre-rest values
    int nSpell, nUses, nStored;
    for (nSpell = 0; nSpell < 599; nSpell ++)
    {
        nUses = GetHasSpell(nSpell, oPC);
        nStored = GetLocalInt(oPC, IntToString(nSpell));
        nStored = nUses - nStored;
        for (nUses = 0; nUses < nStored; nUses ++)
        {
            DecrementRemainingSpellUses(oPC, nSpell);
        }
        DeleteLocalInt(oPC, IntToString(nSpell));
    }
}

// Internal function
int rs_ConvertRestIntervalToNextDay(int nTime)
{
    if (nTime > 23)
    {
        nTime -= 23;
    }
    return nTime;
}

////////////////////////////////////////////////////////////////////////////////
// HCR 2.0 FUNCTIONS

int rs_GetFeatUsesRemaining(object oPC, int nFeat, int nMaxUses)
{
    int nCount = 0;
    int i;
    for (i = 0; i <= nMaxUses; i++)
    {
        int bHasFeat = GetHasFeat(nFeat, oPC);
        if (bHasFeat)
        {
            nCount += 1;
            DecrementRemainingFeatUses(oPC, nFeat);
        }
        else
            break;
    }
    if (nCount == nMaxUses+1)
        nCount = -1;
    for (i = 0; i < nCount; i++)
    {
        IncrementRemainingFeatUses(oPC, nFeat);
    }
    return nCount;
}

void rs_SetFeatUsesRemaining(object oPC, int nFeat, int nUses)
{
    int i;
    for (i = 0; i < 50; i++)
    {
        int bHasFeat = GetHasFeat(nFeat, oPC);
        if (bHasFeat)
            DecrementRemainingFeatUses(oPC, nFeat);
        else
            break;
    }
    if (i < 50)
    {
        for (i = 0; i < nUses; i++)
            IncrementRemainingFeatUses(oPC, nFeat);
    }
}

void rs_SetAvailableFeatsToSavedValues(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    string sFeatTrack = GetLocalString(oPC, "rs_feat_track");
    if (sFeatTrack == "")
        return;
    sFeatTrack = GetStringRight(sFeatTrack, GetStringLength(sFeatTrack) - 1);
    while (sFeatTrack != "")
    {
        int nDivIndex = FindSubString(sFeatTrack, "|");
        int nValIndex = FindSubString(sFeatTrack, ":");
        int nFeat = StringToInt(GetStringLeft(sFeatTrack, nValIndex));
        int nUses = StringToInt(GetSubString(sFeatTrack,  nValIndex + 1, nDivIndex - nValIndex - 1));
        rs_SetFeatUsesRemaining(oPC, nFeat, nUses);
        sFeatTrack = GetStringRight(sFeatTrack, GetStringLength(sFeatTrack) - nDivIndex - 1);
    }
}

string rs_AppendToFeatTrack(string sFeatTrack, object oPC, int nFeat, int nMaxUses)
{
    int nFeatUses = rs_GetFeatUsesRemaining(oPC, nFeat, nMaxUses);
    if (nFeatUses > -1)
        return sFeatTrack + IntToString(nFeat) + ":" + IntToString(nFeatUses) + "|";
    return sFeatTrack;
}

void rs_SavePCAvailableFeats(object oPC)
{
    if (!GetIsObjectValid(oPC))
        return;
    int i;
    string sFeatTrack = "X";
    for (i = 1; i <= 3; i++)
    {
        int nClass = GetClassByPosition(i, oPC);
        switch (nClass)
        {
            case CLASS_TYPE_BARBARIAN:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_BARBARIAN_RAGE, 11);
                break;
            case CLASS_TYPE_BARD:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_BARD_SONGS, 44);
                break;
            case CLASS_TYPE_CLERIC:
            {
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TURN_UNDEAD, 24);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DEATH_DOMAIN_POWER, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PROTECTION_DOMAIN_POWER, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_STRENGTH_DOMAIN_POWER, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TRICKERY_DOMAIN_POWER, 1);
                break;
            }
            case CLASS_TYPE_DRUID:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_ANIMAL_COMPANION, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_WILD_SHAPE, 6);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_ELEMENTAL_SHAPE, 4);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_WILD_SHAPE_DRAGON, 3);
                break;
            case CLASS_TYPE_MONK:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_STUNNING_FIST, 43);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EMPTY_BODY, 2);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_QUIVERING_PALM, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_WHOLENESS_OF_BODY, 1);
                break;
            case CLASS_TYPE_PALADIN:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TURN_UNDEAD, 24);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_LAY_ON_HANDS, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_REMOVE_DISEASE, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SMITE_EVIL, 3);
                break;
            case CLASS_TYPE_RANGER:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_ANIMAL_COMPANION, 1);
                break;
            case CLASS_TYPE_ROGUE:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DEFENSIVE_ROLL, 1);
                break;
            case CLASS_TYPE_SORCERER:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_FAMILIAR, 1);
                break;
            case CLASS_TYPE_WIZARD:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_FAMILIAR, 1);
                break;
            case CLASS_TYPE_ARCANE_ARCHER:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_IMBUE_ARROW, 3);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_HAIL_OF_ARROWS, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_ARROW_OF_DEATH, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_SEEKER_ARROW_1, 2);
                break;
            case CLASS_TYPE_ASSASSIN:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_DARKNESS, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_INVISIBILITY_1, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_INVISIBILITY_2, 1);
                break;
            case CLASS_TYPE_BLACKGUARD:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TURN_UNDEAD, 24);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SMITE_GOOD, 3);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PRESTIGE_DARK_BLESSING, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_BULLS_STRENGTH, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_INFLICT_SERIOUS_WOUNDS, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_INFLICT_CRITICAL_WOUNDS, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_CONTAGION, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_INFLICT_LIGHT_WOUNDS, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_INFLICT_MODERATE_WOUNDS, 1);
                break;
            case CLASS_TYPE_HARPER:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HARPER_CATS_GRACE, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HARPER_EAGLES_SPLENDOR, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HARPER_INVISIBILITY, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HARPER_SLEEP, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_CRAFT_HARPER_ITEM, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_TYMORAS_SMILE, 1);
                break;
            case CLASS_TYPE_SHADOWDANCER:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_SHADOW, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SHADOW_DAZE, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SHADOW_EVADE, 3);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DEFENSIVE_ROLL, 1);
                break;
            case CLASS_TYPE_PALEMASTER:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_ANIMATE_DEAD, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_UNDEAD, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_UNDEAD_GRAFT_1, 9);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SUMMON_GREATER_UNDEAD, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DEATHLESS_MASTER_TOUCH, 3);
                break;
            case CLASS_TYPE_DRAGON_DISCIPLE:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DRAGON_DIS_BREATH, 1);
                break;
            case CLASS_TYPE_SHIFTER:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_GREATER_WILDSHAPE_1, 3);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_GREATER_WILDSHAPE_2, 3);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_GREATER_WILDSHAPE_3, 3);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_GREATER_WILDSHAPE_4, 3);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_HUMANOID_SHAPE, 3);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_CONSTRUCT_SHAPE, 3);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_OUTSIDER_SHAPE, 3);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_WILD_SHAPE_UNDEAD, 3);
                break;
            case CLASS_TYPE_DIVINE_CHAMPION:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_LAY_ON_HANDS, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_SMITE_EVIL, 3);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DIVINE_WRATH, 1);
                break;
            case CLASS_TYPE_WEAPON_MASTER:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_KI_DAMAGE, 30);
                break;
            case CLASS_TYPE_DWARVEN_DEFENDER:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE, 20);
                break;
            case CLASS_TYPE_PURPLE_DRAGON_KNIGHT:
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PDK_RALLY, 3);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PDK_FEAR, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PDK_INSPIRE_1, 2);
                //sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PDK_INSPIRE_2, 2);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PDK_STAND, 1);
                sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_PDK_WRATH, 1);
                break;
        }
    }
    if (GetHitDice(oPC) > 20)
    {
        sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_DRAGON_KNIGHT, 1);
        sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_HELLBALL, 1);
        sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_MAGE_ARMOUR, 1);
        sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_MUMMY_DUST, 1);
        sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_RUIN, 1);
        sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_SPELL_EPIC_WARDING, 1);
        sFeatTrack = rs_AppendToFeatTrack(sFeatTrack, oPC, FEAT_EPIC_BLINDING_SPEED, 1);
    }
    SetLocalString(oPC, "rs_feat_track", sFeatTrack);
}

// End HCR 2.0 Functions
////////////////////////////////////////////////////////////////////////////////

void rs_IndexGameClock(int nHr = 0, int nMin = 0, int nSec = 0, int nMil =0)
{
    int nHour        = GetTimeHour()        + nHr;
    int nMinute      = GetTimeMinute()      + nMin;
    int nSecond      = GetTimeSecond()      + nSec;
    int nMillisecond = GetTimeMillisecond() + nMil;
    SetTime(nHour, nMinute, nSecond, nMillisecond);
}
