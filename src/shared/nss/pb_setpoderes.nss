
// Script de aplicacion de poderes de Sets de Armaduras
//


#include "mti_libreria"
#include "pb_ip_slots_inc"
#include "NW_I0_SPELLS"

void main()
{

    object oPC = OBJECT_SELF;

    /*/Sets de Armaduras.
    int PiezaAngel = ObtenerIntPersistente(oPC, "Pieza_Celestial");
    int PiezaInfernal = ObtenerIntPersistente(oPC, "Pieza_Infernal");
    int PiezaNirvana = ObtenerIntPersistente(oPC, "Pieza_Nirvana");
    int PiezaCamino = ObtenerIntPersistente(oPC, "Pieza_Camino");
    int PiezaArtifice = ObtenerIntPersistente(oPC, "Pieza_Artifice");
    int PiezaGigante = ObtenerIntPersistente(oPC, "Pieza_Gigante");
    int PiezaVaraNegra = ObtenerIntPersistente(oPC, "Pieza_Varanegra");
    int PiezaLoco = ObtenerIntPersistente(oPC, "Pieza_Loco");
    int PiezaInmortal = ObtenerIntPersistente(oPC, "Pieza_Inmortal");
    int PiezaTierra = ObtenerIntPersistente(oPC, "Pieza_Tierra");  */

    //Poderes set celestial
    if(GetLocalInt(oPC, "Poder_Celestial") == 1)
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_20), GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_NATURES_BALANCE), GetLocation(oPC));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(902)), oPC);
            if(GetItemPossessedBy(oPC, "item_celestial") == OBJECT_INVALID && GetLocalInt(oPC, "Poder_Especial") == 0 ) CreateItemOnObject("item_celestial", oPC);
            else if(GetLocalInt(oPC, "Poder_Especial") == 1 ) SendMessageToPC(oPC, "Ya has usado el item especial durante el dia de hoy. Descansa para reponerlo");
            GuardarIntPersistente(oPC, "Poder_activo", 1);
        }

    //poderes set infernal
    else if(GetLocalInt(oPC, "Poder_Infernal") == 1)
        {

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWKILL), GetLocation(oPC));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(939)), oPC);
            if(GetItemPossessedBy(oPC, "item_infernal") == OBJECT_INVALID && GetLocalInt(oPC, "Poder_Especial") == 0 ) CreateItemOnObject("item_infernal", oPC);
            else if(GetLocalInt(oPC, "Poder_Especial") == 1 ) SendMessageToPC(oPC, "Ya has usado el item especial durante el dia de hoy. Descansa para reponerlo");
            GuardarIntPersistente(oPC, "Poder_activo", 1);
        }

    //poderes set nirvana
    else if(GetLocalInt(oPC, "Poder_Nirvana") == 1)
        {

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_30), GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_NATURES_BALANCE), GetLocation(oPC));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(1851)), oPC);
            if(GetItemPossessedBy(oPC, "item_nirvana") == OBJECT_INVALID && GetLocalInt(oPC, "Poder_Especial") == 0 ) CreateItemOnObject("item_nirvana", oPC);
            else if(GetLocalInt(oPC, "Poder_Especial") == 1 ) SendMessageToPC(oPC, "Ya has usado el item especial durante el dia de hoy. Descansa para reponerlo");
            GuardarIntPersistente(oPC, "Poder_activo", 1);
        }

    //poderes set camino sin fin
    else if(GetLocalInt(oPC, "Poder_Camino") == 1)
        {

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_30), GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_NATURES_BALANCE), GetLocation(oPC));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedIncrease(5)), oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(28, 5)), oPC);
            if(GetItemPossessedBy(oPC, "item_camino") == OBJECT_INVALID && GetLocalInt(oPC, "Poder_Especial") == 0 ) CreateItemOnObject("item_camino", oPC);
            else if(GetLocalInt(oPC, "Poder_Especial") == 1 ) SendMessageToPC(oPC, "Ya has usado el item especial durante el dia de hoy. Descansa para reponerlo");
            GuardarIntPersistente(oPC, "Poder_activo", 1);
        }

    //poderes set artifice
    else if(GetLocalInt(oPC, "Poder_Artifice") == 1)
        {

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_30), GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), GetLocation(oPC));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(22, 4)), oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(18, 4)), oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(2, 4)), oPC);
            if(GetItemPossessedBy(oPC, "item_artifice") == OBJECT_INVALID && GetLocalInt(oPC, "Poder_Especial") == 0 ) CreateItemOnObject("item_artifice", oPC);
            else if(GetLocalInt(oPC, "Poder_Especial") == 1 ) SendMessageToPC(oPC, "Ya has usado el item especial durante el dia de hoy. Descansa para reponerlo");
            GuardarIntPersistente(oPC, "Poder_activo", 1);
        }

    //poderes set gigante
    //else if(ObtenerIntPersistente(oPC, "Pieza_Gigante") >= 4 )
    else if(GetLocalInt(oPC, "Poder_Gigante") == 1)
        {

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_30), GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), GetLocation(oPC));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(24, 5)), oPC);
            SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, 1.20);
            if(GetItemPossessedBy(oPC, "item_gigante") == OBJECT_INVALID && GetLocalInt(oPC, "Poder_Especial") == 0 ) CreateItemOnObject("item_gigante", oPC);
            else if(GetLocalInt(oPC, "Poder_Especial") == 1 ) SendMessageToPC(oPC, "Ya has usado el item especial durante el dia de hoy. Descansa para reponerlo");
            GuardarIntPersistente(oPC, "Poder_activo", 1);
        }

    //poderes set vara negra
    else if(GetLocalInt(oPC, "Poder_VaraNegra") == 1)
        {

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_30), GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_TIME_STOP), GetLocation(oPC));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(7, 5)), oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(16, 5)), oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE)), oPC);
            if(GetItemPossessedBy(oPC, "item_varanegra") == OBJECT_INVALID && GetLocalInt(oPC, "Poder_Especial") == 0 ) CreateItemOnObject("item_varanegra", oPC);
            else if(GetLocalInt(oPC, "Poder_Especial") == 1 ) SendMessageToPC(oPC, "Ya has usado el item especial durante el dia de hoy. Descansa para reponerlo");
            GuardarIntPersistente(oPC, "Poder_activo", 1);
        }

    //poderes set del loco
    else if(GetLocalInt(oPC, "Poder_Loco") == 1)
        {

            effect eLink = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 2);
            eLink    = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_WISDOM, 2));
            eLink = SupernaturalEffect(eLink);

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_30), GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), GetLocation(oPC));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(916)), oPC); //Capa del Caos
            if(GetItemPossessedBy(oPC, "item_loco") == OBJECT_INVALID && GetLocalInt(oPC, "Poder_Especial") == 0 ) CreateItemOnObject("item_loco", oPC);
            else if(GetLocalInt(oPC, "Poder_Especial") == 1 ) SendMessageToPC(oPC, "Ya has usado el item especial durante el dia de hoy. Descansa para reponerlo");
            GuardarIntPersistente(oPC, "Poder_activo", 1);
        }

    //poderes set del rey inmortal
    else if(GetLocalInt(oPC, "Poder_Inmortal") == 1)
        {

            int oDG = GetHitDice(oPC)/3;
            effect eLink    = EffectAbilityDecrease(ABILITY_CHARISMA, 2);
            eLink    = EffectAbilityDecrease(ABILITY_CONSTITUTION, 2);
            eLink    = EffectLinkEffects(eLink, EffectDamageShield(oDG, DAMAGE_BONUS_1d4, DAMAGE_TYPE_NEGATIVE));
            eLink    = EffectLinkEffects(eLink, EffectVisualEffect(463));
            eLink    = EffectLinkEffects(eLink, EffectVisualEffect(939));
            eLink = SupernaturalEffect(eLink);

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWKILL), GetLocation(oPC));
            if(GetItemPossessedBy(oPC, "item_inmortal") == OBJECT_INVALID && GetLocalInt(oPC, "Poder_Especial") == 0 ) CreateItemOnObject("item_inmortal", oPC);
            else if(GetLocalInt(oPC, "Poder_Especial") == 1 ) SendMessageToPC(oPC, "Ya has usado el item especial durante el dia de hoy. Descansa para reponerlo");
            GuardarIntPersistente(oPC, "Poder_activo", 1);
        }

    //poderes set Deber de Tierra
    else if(GetLocalInt(oPC, "Poder_Tierra") == 1)
        {

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(36, 4)), oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(18, 4)), oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(VFX_DUR_PIXIEDUST)), oPC);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_30), GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_NATURES_BALANCE), GetLocation(oPC));
            if(GetItemPossessedBy(oPC, "item_tierra") == OBJECT_INVALID && GetLocalInt(oPC, "Poder_Especial") == 0 ) CreateItemOnObject("item_tierra", oPC);
            else if(GetLocalInt(oPC, "Poder_Especial") == 1 ) SendMessageToPC(oPC, "Ya has usado el item especial durante el dia de hoy. Descansa para reponerlo");
            GuardarIntPersistente(oPC, "Poder_activo", 1);
        }
}
