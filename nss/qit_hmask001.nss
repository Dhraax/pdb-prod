//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: 5/9/2014
//:://////////////////////////////////////////////
#include "x2_inc_switches"

void main()
{
    int nEvent =GetUserDefinedItemEventNumber();
    object oPC, oItem;

    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        oPC       = GetItemActivator();
        oItem     = GetItemActivated();
        int iSex  = GetGender(oPC);
        int iRace = GetAppearanceType(oPC);
        int nEffect;
        string sItem;

        if(GetLocalInt(oPC,"USEDQITMASK") == 1)
        {
            SetLocalInt(oPC,"USEDQITMASK",0);
            sItem = GetLocalString(oPC, "QITMASK_ID");
            effect eEff = GetFirstEffect(oPC);
            while(GetIsEffectValid(eEff) == TRUE)
            {
                if(GetEffectType(eEff) == EFFECT_TYPE_VISUALEFFECT && GetEffectCreator(eEff) == OBJECT_SELF && GetEffectSpellId(eEff) == -1)
                {
                    RemoveEffect(oPC,eEff);
                }
                eEff = GetNextEffect(oPC);
            }
            DeleteLocalString(oPC,"USEDQITMASK");
            return;
        }

        SetLocalInt(oPC,"USEDQITMASK",1);

        switch (iSex)
        {
            case GENDER_MALE:
            {
                switch (iRace)
                {
                    case APPEARANCE_TYPE_HALFLING: nEffect = 738; break;
                    case APPEARANCE_TYPE_DWARF: nEffect = 740; break;
                    case APPEARANCE_TYPE_ELF: nEffect = 742; break;
                    case APPEARANCE_TYPE_GNOME: nEffect = 744; break;
                    case APPEARANCE_TYPE_HUMAN:
                    case APPEARANCE_TYPE_HALF_ELF: nEffect = 746; break;
                    case APPEARANCE_TYPE_HALF_ORC: nEffect = 748; break;
                }
            }
            break;

            case GENDER_FEMALE:
            {
                switch (iRace)
                {
                    case APPEARANCE_TYPE_HALFLING: nEffect = 739; break;
                    case APPEARANCE_TYPE_DWARF: nEffect = 741; break;
                    case APPEARANCE_TYPE_ELF: nEffect = 743; break;
                    case APPEARANCE_TYPE_GNOME: nEffect = 745; break;
                    case APPEARANCE_TYPE_HUMAN:
                    case APPEARANCE_TYPE_HALF_ELF: nEffect = 747; break;
                    case APPEARANCE_TYPE_HALF_ORC: nEffect = 749; break;
                }
            }
            break;
        }
        effect eVis = EffectVisualEffect(nEffect);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVis,oPC);
        /*Debug*/ //FloatingTextStringOnCreature("mask vfx spellID = "+IntToString(GetEffectSpellId(eVis)),oPC);
        return;
    }
}
