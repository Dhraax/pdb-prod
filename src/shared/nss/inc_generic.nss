#include "nwnx_alts"

// Updates HiPS for rangers (i.e. applied in natural areas, not in artifical areas).
void UpdateRangerHiPS(object oPC);

void UpdateRangerHiPS(object oPC)
{
    if(GetLevelByClass(CLASS_TYPE_RANGER, oPC) == 16) {
        if (GetIsAreaNatural(GetArea(oPC)))
        {
            AddKnownFeat(oPC, FEAT_HIDE_IN_PLAIN_SIGHT, GetLevelByClassLevel(oPC, CLASS_TYPE_RANGER, 16));
            SendMessageToPC(oPC, "<c þ >Esconderse a simple vista esta disponible en este area.</c>");
        }
        else
        {
            NWNX_Creature_RemoveFeat(oPC, FEAT_HIDE_IN_PLAIN_SIGHT);
            SendMessageToPC(oPC, "<c´$$>Esconderse a simple vista esta no disponible en este area.</c>");
        }
    }

    if(GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 16) {
        if(!GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oPC))
        {
            AddKnownFeat(oPC, FEAT_HIDE_IN_PLAIN_SIGHT, GetLevelByClassLevel(oPC, CLASS_TYPE_RANGER, 16));
            return;
        }
        return;
    }   
}