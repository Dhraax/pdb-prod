#include "nwnx_events"
#include "x0_i0_match"
#include "nw_i0_spells"
#include "pb_inc_mmf"


/**********************************************************************
 * FUNCTION DEFINITIONS / MAESTRO MULTIPLES FORMAS
 **********************************************************************/
 //----------------------------------------------------------------
int CheckIfSpellAbility(object oPC, int iSpell)
{
    string sSA_index = "MDF_SP_INDEX_";
    int iSACount = ObtenerIntPersistente(oPC,"MDF_SA_COUNT");
    int iIndex;
    int iCheck = FALSE;
    struct NWNX_Creature_SpecialAbility SpecialAbility;

    if(iSACount != 0)
    {
        for(iIndex = 0 ; iIndex < iSACount; iIndex++)
        {
            SpecialAbility = NWNX_Creature_GetSpecialAbility(oPC,iIndex);
            if(SpecialAbility.id == iSpell) iCheck = TRUE; break;

        }
    }
    return iCheck;

}
//----------------------------------------------------------------
int CheckIfPolymorphed(object oPC)
{
    effect eEffect = GetFirstEffect(oPC);

    while(GetIsEffectValid(eEffect)) {
        if(GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH) return TRUE;
        eEffect = GetNextEffect(oPC);
    }

    return FALSE;
}
//----------------------------------------------------------------
void main()
{
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();
    object oTarget = StringToObject(NWNX_Events_GetEventData("TARGET"));
    object oPC = OBJECT_SELF;
    int iEsFeat = StringToInt(NWNX_Events_GetEventData("FEAT"));
    int iSpell = StringToInt(NWNX_Events_GetEventData("SPELL_ID"));
    int iIsAbility = CheckIfSpellAbility(OBJECT_SELF,iSpell);

    if (sCurrentEvent == "NWNX_ON_INPUT_CAST_SPELL_BEFORE")
    {
        //------------------------------------------------------------------------------
        // MAESTRO MULTIPLES FORMAS
        //------------------------------------------------------------------------------
            if(ObtenerIntPersistente(OBJECT_SELF,"CAB_MONTADO") != 0 && (iSpell > 1433 && iSpell < 1504)){
                NWNX_Events_SkipEvent();
                SendMessageToPC(OBJECT_SELF,"No puedes transformarte mientras estás sobre tu montura.");
                return;
            }
            if(ObtenerIntPersistente(OBJECT_SELF,"POLYMORPHED") && (iSpell >= 387 && iSpell <= 405)) {
                NWNX_Events_SkipEvent();
                SendMessageToPC(OBJECT_SELF,"No puedes usar esta transformación ahora mismo.");
                return;
            }
            if((CheckIfPolymorphed(OBJECT_SELF) || ObtenerIntPersistente(oPC, "APA_CAMBIADA")) && (iSpell > 1433 && iSpell < 1504)){
                NWNX_Events_SkipEvent();
                SendMessageToPC(OBJECT_SELF,"No puedes usar las formas del Maestro de Múltiples Formas mientras estás en esta forma.");
                return;
            }

            if(ObtenerIntPersistente(OBJECT_SELF,"POLYMORPHED_FORM") == MDF_RACIALTYPE_MEDUSA)
            {
                if(iSpell == 497)  //Petrifying Gaze
                {
                    string sUUID_VarName = GetObjectUUID(OBJECT_SELF)+"MMF_MEDUSA_PETRY_USED";
                    PrintString(sUUID_VarName);
                    if(GetLocalInt(GetModule(),sUUID_VarName) == FALSE)
                    {
                        SetLocalInt(GetModule(),sUUID_VarName,TRUE);
                        DelayCommand(20.0,DeleteLocalInt(GetModule(),sUUID_VarName));
                    }
                    else
                    {
                        SendMessageToPC(OBJECT_SELF,"Solo puedes usar esta aptitud una vez cada 20 segundos.");
                        NWNX_Events_SkipEvent();
                    }
                }
                else if (iSpell == 129)  //Poison
                {
                    string sUUID_VarName = GetObjectUUID(OBJECT_SELF)+"MMF_MEDUSA_POISON_USED";
                    PrintString(sUUID_VarName);
                    if(GetLocalInt(GetModule(),sUUID_VarName) == FALSE)
                    {
                        SetLocalInt(GetModule(),sUUID_VarName,TRUE);
                        DelayCommand(20.0,DeleteLocalInt(GetModule(),sUUID_VarName));
                    }
                    else
                    {
                        SendMessageToPC(OBJECT_SELF,"Solo puedes usar esta aptitud una vez cada 20 segundos.");
                        NWNX_Events_SkipEvent();
                    }
                }
            }

            if(ObtenerIntPersistente(OBJECT_SELF,"POLYMORPHED") &&  iSpell == 412){

                effect eEffect = GetFirstEffect(OBJECT_SELF);
                 while(GetIsEffectValid(eEffect))
                {
                    if(GetEffectSpellId(eEffect)== 412 )
                    {
                        RemoveEffect(OBJECT_SELF,eEffect);NWNX_Events_SkipEvent();
                        SendMessageToPC(OBJECT_SELF,"Aura de miedo de Dragón desactivada.");
                        NWNX_Events_SkipEvent();
                        break;
                    }
                    eEffect = GetNextEffect(OBJECT_SELF);
                }
            }

            if(iIsAbility == TRUE) return;

            int iMergeA = StringToInt(Get2DAString("polymorph","MergeA",ObtenerIntPersistente(OBJECT_SELF,"POLYMORPHED_FORM")));

            if(ObtenerIntPersistente(OBJECT_SELF,"POLYMORPHED") && (iSpell < 1433 || iSpell > 1504) && (!iMergeA && GetLevelByClass(63,OBJECT_SELF) < 10) /*!GetHasFeat(1804)*/){
                NWNX_Events_SkipEvent();
                SendMessageToPC(OBJECT_SELF,"No puedes lanzar conjuros mientras estás en esta forma.");
                return;
            }
        //------------------------------------------------------------------------------
        //Artífice no puede lanzar infusiones sin tener su item puesto ni puede cambiar de invos tan rápido.
        //Magias del Artillero.
        if(iSpell == 1427 || iSpell == 1400 || iSpell == 1401 || iSpell == 1402 || iSpell == 1403 || iSpell == 1404 || iSpell == 1405 || iSpell == 1406 || iSpell == 1407 || iSpell == 1408)
        {
            if(GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC)) != "cls_ing_item1")
            {
                NWNX_Events_SkipEvent();
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
                SendMessageToPC(oPC, "<c´$$>¡No tienes tu ballesta de ingeniero equipada!</c>"); return;
            }
            //Si se ha usado una infusión diferente en menos de 20 segundos, cancelamos.
            if(GetLocalInt(oPC,"CLS_ING_SPELLUSADO") != 0 && GetLocalInt(oPC,"CLS_ING_SPELLUSADO") != iSpell)
            {
                NWNX_Events_SkipEvent();
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
                SendMessageToPC(oPC, "<c´$$>¡No puedes cambiar de infusión en menos de 8 segundos!</c>"); return;
            }
        }
        //Magias del Armero.
        if(iSpell == 1428 || iSpell == 1409 || iSpell == 1410 || iSpell == 1411 || iSpell == 1412 || iSpell == 1413 || iSpell == 1414 || iSpell == 1415 || iSpell == 1416 || iSpell == 1417)
        {
            if(GetTag(GetItemInSlot(INVENTORY_SLOT_CHEST,oPC)) != "cls_ing_item2")
            {
                NWNX_Events_SkipEvent();
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
                SendMessageToPC(oPC, "<c´$$>¡No tienes tu armadura de ingeniero equipada!</c>"); return;
            }
            //Si se ha usado una infusión diferente en menos de 20 segundos, cancelamos.
            if(GetLocalInt(oPC,"CLS_ING_SPELLUSADO") != 0 && GetLocalInt(oPC,"CLS_ING_SPELLUSADO") != iSpell)
            {
                NWNX_Events_SkipEvent();
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
                SendMessageToPC(oPC, "<c´$$>¡No puedes cambiar de infusión en menos de 8 segundos!</c>"); return;
            }
        }
        //Magias del Alquimista.
        if(iSpell == 1430 || iSpell == 1418 || iSpell == 1419 || iSpell == 1420 || iSpell == 1421 || iSpell == 1422 || iSpell == 1423 || iSpell == 1424 || iSpell == 1425 || iSpell == 1426)
        {
            /*if(GetLocalInt(GetModule(), "CLS_ING_ELIXIRBERS"+GetName(oPC,TRUE)) == 1)
            {
                RemoveSpellEffects(1421,oPC, oPC);
                DeleteLocalInt(GetModule(),"CLS_ING_ELIXIRBERS"+GetName(oPC,TRUE));
                NWNX_Events_SkipEvent();
                return;
            }  */
            if(GetTag(GetItemInSlot(INVENTORY_SLOT_BELT,oPC)) != "cls_ing_item4")
            {
                NWNX_Events_SkipEvent();
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
                SendMessageToPC(oPC, "<c´$$>¡No tienes tu cinturón de ingeniero equipada!</c>"); return;
            }
            //Si se ha usado una infusión diferente en menos de 20 segundos, cancelamos.
            if(GetLocalInt(oPC,"CLS_ING_SPELLUSADO") != 0 && GetLocalInt(oPC,"CLS_ING_SPELLUSADO") != iSpell)
            {
                NWNX_Events_SkipEvent();
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
                SendMessageToPC(oPC, "<c´$$>¡No puedes cambiar de infusión en menos de 8 segundos!</c>"); return;
            }
        }
    }
}
