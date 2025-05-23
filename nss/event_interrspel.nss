#include "nwnx_events"
#include "x0_i0_match"
#include "nw_i0_spells"
#include "inc_spells"

/**********************************************************************
 * FUNCTION DEFINITIONS / MAESTRO MULTIPLES FORMAS
 **********************************************************************/
void main()
{
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();
    object oPC = OBJECT_SELF;
    int iSpell = StringToInt(NWNX_Events_GetEventData("SPELL_ID"));
    int iClass = GetLastSpellCastClass();

    if (sCurrentEvent == "NWNX_ON_SPELL_INTERRUPTED_AFTER")
    {
        //TRUCOS INFINITOS: MAGO, HECHICERO, BARDO, DRUIDA, CLERIGO
        if(iClass == CLASS_TYPE_WIZARD || iClass == CLASS_TYPE_SORCERER || iClass == CLASS_TYPE_BARD || iClass == CLASS_TYPE_DRUID || iClass == CLASS_TYPE_CLERIC || iClass == CLASS_TYPE_INGENIERO || GetLastSpellCastClass() == CLASS_TYPE_FAVORED_SOUL)
        {
            //Leemos la esfera del conjuro usado.
            int iEsfera = StringToInt(Get2DAString("spells", "Innate", iSpell));
            //Si es un truco, volvemos a darle el uso que ha gastado.
            if(iEsfera == 0)
            {
                if(iClass == CLASS_TYPE_WIZARD || iClass == CLASS_TYPE_CLERIC || iClass == CLASS_TYPE_DRUID)
                {
                    //Los conjuros de luz + color, regeneran el conjuro "padre" luz.
                    if(iSpell >= 1061 && iSpell <= 1065){iSpell =100;}
                    ReadySingleMemorizedSpell(oPC, iClass, iSpell, GetMetaMagicFeat());
                }
                if(iClass == CLASS_TYPE_BARD || iClass == CLASS_TYPE_SORCERER || GetLastSpellCastClass() == CLASS_TYPE_FAVORED_SOUL)
                {
                    ReadySpellLevel(oPC, iEsfera, iClass);
                }
            }
        }
        //SendMessageToPC(oPC,"Este es un mensaje de prueba para testear cuando un PJ ve interrumpido su conjuro, tu conjuro es el nº "+IntToString(iSpell)+" y tu clase lanzadora es "+IntToString(iClass)+".");
    }
}
