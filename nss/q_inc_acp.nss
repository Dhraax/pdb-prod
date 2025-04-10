//::///////////////////////////////////////////////
//:: Name: Q ACP Function Library
//:: FileName: q_inc_acp
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.
*/
//:://////////////////////////////////////////////
//:: Created By: thurgood
//:: Created On: 17 August 2009
//:://////////////////////////////////////////////
/*
    Updated 12/21/11 by pstemarie Q v1.5 - added support for Vaei's animations and flying pheno

    Updated 7/2/12 by pstemarie Q v1.5 - added a work around for the demonblade robe issue, style now requires two weapons equipped

    Updated 5/19/13 by pstemarie Q v1.7 - implemented the module switch for the demonblade workaround allowing Builders to turn this OFF. Default is ON.
                                        - added a module switch that enables Builders to limit the unarmed styles to monks. Default is OFF.

    Updated 8/22/15 by pstemarie Q v2.1 - disabled jumping via chat command to fix an exploit that allowed PCs to jump through walls and locked doors.
                                          a generic trigger has been added that will enable jumping while the PC stands within the confines of the
                                          trigger.

    Updated 9/20/15 by pstemarie Q v2.1 - added ACP, Flying, and Social phenotype support for the Large phenotype versions of these animation sets

*/


//::////////////////////////:://
//::    Q_ACP CONSTANTS     :://
//::////////////////////////:://
#include "mti_libreria"
#include "x0_i0_position"
#include "q_inc_switches"

// style change keyword... must be the first word in the chatstring
const string Q_ACP_KEYWORD = "modo ";
const string Q_ANIM_KEYWORD = "anim ";

const string Q_ACP_ARCANE_STRING  = "arcane";
const string Q_ACP_ASSASIN_STRING = "assasin";
const string Q_ACP_DEMON_STRING   = "demon";
const string Q_ACP_FENCING_STRING = "fencing";
const string Q_ACP_HEAVY_STRING   = "heavy";
const string Q_ACP_KENSAI_STRING  = "kensai";
const string Q_ACP_HUNG_STRING    = "hung";
const string Q_ACP_MUAY_STRING    = "muay";
const string Q_ACP_SHAO_STRING    = "shao";
const string Q_ACP_SHOTO_STRING   = "shoto";
const string Q_ACP_WARRIOR_STRING = "warrior";
const string Q_ACP_NORMAL_STRING  = "normal";
const string Q_SOCIAL_STRING      = "social";
const string Q_FLYING_STRING      = "flying";

const string Q_VAEI_CUSTOM1_STRING  = "onward";
const string Q_VAEI_CUSTOM2_STRING  = "thought";
const string Q_VAEI_CUSTOM3_STRING  = "headache";
const string Q_VAEI_CUSTOM4_STRING  = "crossed";
const string Q_VAEI_CUSTOM5_STRING  = "jump";
const string Q_VAEI_CUSTOM6_STRING  = "follow";
const string Q_VAEI_CUSTOM7_STRING  = "crouch";
const string Q_VAEI_CUSTOM8_STRING  = "sleep";

// do not change these constants unless the phenotypes have
// actually been rearanged or moved
const int Q_ACP_ARCANE_PHENO    = 45;//5;//19;
const int Q_ACP_ASSASIN_PHENO   = 42;//2;//16;
const int Q_ACP_DEMON_PHENO     = 46;//6;//20;
const int Q_ACP_FENCING_PHENO   = 44;//4;//18;
const int Q_ACP_HEAVY_PHENO     = 43;//3;//17;
const int Q_ACP_KENSAI_PHENO    = 41;//1;//15;
const int Q_ACP_HUNG_PHENO      = 51;//19;//33; BearClaw
const int Q_ACP_MUAY_PHENO      = 48;//16;//30; TigerFang
const int Q_ACP_SHAO_PHENO      = 50;//18;//32; DragonPalm
const int Q_ACP_SHOTO_PHENO     = 49;//17;//31; SunFist
const int Q_ACP_WARRIOR_PHENO   = 47;//7;//21;
const int Q_ACP_NORMAL_PHENO    = 0;
const int Q_ACP_LARGE_PHENO     = 2;
const int Q_SOCIAL_PHENO        = 40;//26;//40;
const int Q_FLYING_PHENO        = 16;//32;//46;
const int Q_ACP_ARCANE_L_PHENO  = 65;//55;//69;
const int Q_ACP_ASSASIN_L_PHENO = 62;//52;//66;
const int Q_ACP_DEMON_L_PHENO   = 66;//56;//70;
const int Q_ACP_FENCING_L_PHENO = 64;//54;//68;
const int Q_ACP_HEAVY_L_PHENO   = 63;//53;//67;
const int Q_ACP_KENSAI_L_PHENO  = 61;//51;//65;
const int Q_ACP_HUNG_L_PHENO    = 71;//69;//83;
const int Q_ACP_MUAY_L_PHENO    = 68;//66;//80;
const int Q_ACP_SHAO_L_PHENO    = 70;//68;//82;
const int Q_ACP_SHOTO_L_PHENO   = 69;//67;//81;
const int Q_ACP_WARRIOR_L_PHENO = 67;//57;//71;
const int Q_SOCIAL_L_PHENO      = 72;//71;//85;
const int Q_FLYING_L_PHENO      = 25;//72;//86;

const int Q_ACP_MAXABASEPHENOTYPES = 73;//32;//26;//19;//11; //Número máximo de fenotipos de la tabla.
const int Q_ACP_MAXSUPPORTEDPHENOTYPES = 3; //3//58    //Número máximo de phenotipos soportados 0 ó 2.
const int Q_ACP_ANIMATIONOFFSET = 0;//14;//100;   Fenotipo vacio antes de los estilos para destactivar

//:://///////////////////////:://
//::  FUNCTION DECLARATIONS  :://
//:://///////////////////////:://

// Sets the phenotype of a PC based on spoken commands
// object oPC   - the PC that uttered the command
// string sText - the string that was spoken
void Q_ACPCheckChat(object oPC, string sText);

// Sets the phenotype of a PC to the given phenotype if it is in range
// object oPC    - the PC whose pheno type is to be modified
// int nPheno    - the phenotype to which the PC is being changed
// string sStyle - the style that was chosen by the PC
void Q_ACPSetStyle(object oPC, int nPheno, string sStyle = "");

//:://///////////////////////:://
//::  FUNCTION DEFINITIONS   :://
//:://///////////////////////:://

void Q_CleanJumpVariables(object oPC)
{
    DeleteLocalInt(oPC, "Q_JUMP_ALLOWED");
    DeleteLocalString(oPC, "Q_JUMP_FACING");
}

// Sets the phenotype of a PC to the given phenotype if it is in range
// object oPC    - the PC whose pheno type is to be modified
// int nPheno    - the phenotype to which the PC is being changed
// string sStyle - the style that was chosen by the PC
void Q_ACPSetStyle(object oPC, int nPheno, string sStyle = "")
{
    // make sure a valid phenotype was sent before changing it
    if ((nPheno != Q_ACP_ARCANE_PHENO) &&
        (nPheno != Q_ACP_ASSASIN_PHENO) &&
        (nPheno != Q_ACP_DEMON_PHENO) &&
        (nPheno != Q_ACP_FENCING_PHENO) &&
        (nPheno != Q_ACP_HEAVY_PHENO) &&
        (nPheno != Q_ACP_KENSAI_PHENO) &&
        (nPheno != Q_ACP_HUNG_PHENO) &&
        (nPheno != Q_ACP_MUAY_PHENO) &&
        (nPheno != Q_ACP_SHAO_PHENO) &&
        (nPheno != Q_ACP_SHOTO_PHENO) &&
        (nPheno != Q_ACP_WARRIOR_PHENO) &&
        (nPheno != Q_ACP_NORMAL_PHENO) &&
        (nPheno != Q_SOCIAL_PHENO) &&
        (nPheno != Q_FLYING_PHENO) &&
        (nPheno != Q_ACP_ARCANE_L_PHENO) &&
        (nPheno != Q_ACP_ASSASIN_L_PHENO) &&
        (nPheno != Q_ACP_DEMON_L_PHENO) &&
        (nPheno != Q_ACP_FENCING_L_PHENO) &&
        (nPheno != Q_ACP_HEAVY_L_PHENO) &&
        (nPheno != Q_ACP_KENSAI_L_PHENO) &&
        (nPheno != Q_ACP_HUNG_L_PHENO) &&
        (nPheno != Q_ACP_MUAY_L_PHENO) &&
        (nPheno != Q_ACP_SHAO_L_PHENO) &&
        (nPheno != Q_ACP_SHOTO_L_PHENO) &&
        (nPheno != Q_ACP_WARRIOR_L_PHENO) &&
        (nPheno != Q_ACP_LARGE_PHENO) &&
        (nPheno != Q_SOCIAL_L_PHENO) &&
        (nPheno != Q_FLYING_L_PHENO))
    {
        SendMessageToPC(oPC, "Estilo inválido: " + sStyle);
        return;
    }

    // get the base body type
    int nCurrPheno = GetPhenoType(oPC);
    int nBasePheno;
    if (nCurrPheno >= Q_FLYING_PHENO)nBasePheno = 0;
    else if (nCurrPheno >= Q_ACP_ANIMATIONOFFSET)
    {
        //int nStoredPheno = GetLocalInt(oPC, "Q_BASE_PHENOTYPE");
        if (nCurrPheno>0 && nCurrPheno!=3)// if (nStoredPheno > 0)
        {
            nBasePheno = 2;
        }
        else nBasePheno=0; //nBasePheno = (nCurrPheno - Q_ACP_ANIMATIONOFFSET - 1) / Q_ACP_MAXABASEPHENOTYPES;
    }
    else
    {
        nBasePheno = nCurrPheno;
    }
    // check that the base phenotype is actually supported
    if (nBasePheno >= Q_ACP_MAXSUPPORTEDPHENOTYPES)
    {
        SendMessageToPC(oPC, "Tu fenotipo actual no soporta animación de combate alternativo.");
        return;
    }
    // Optional - check that oPC has two weapons equipped if using demonblade style
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_REQUIRE_DEMONBLADE_MULTIWEAPON) == TRUE)
    {
        if (nPheno == Q_ACP_DEMON_PHENO)
        {
            int bValid = TRUE;
            object oSecondary = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
            if (oSecondary == OBJECT_INVALID)
            {
                bValid = FALSE;
            }
            else
            {
                int nBaseItemType = GetBaseItemType(oSecondary);
                if (nBaseItemType == BASE_ITEM_LARGESHIELD ||
                    nBaseItemType == BASE_ITEM_SMALLSHIELD ||
                    nBaseItemType == BASE_ITEM_TOWERSHIELD)
                {
                    bValid = FALSE;
                }
            }
            if (bValid == FALSE)
            {
                SendMessageToPC(oPC, "Debes tener dos armas cuerpo a cuerpo equipadas para usar el estilo demoniaco.");
                return;
            }
        }
    }
    // Optional - only monks can use unarmed fighting styles
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_UNARMED_STYLES_LIMITATION) == TRUE)
    {
        if (nPheno == Q_ACP_HUNG_PHENO || nPheno == Q_ACP_MUAY_PHENO || nPheno == Q_ACP_SHAO_PHENO || nPheno == Q_ACP_SHOTO_PHENO)
        {
            int bValid = FALSE;
            if (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0)
                bValid = TRUE;
            if (bValid == FALSE)
            {
                SendMessageToPC(oPC, "Sólo los monjes pueden usar estilos de lucha desarmados.");
                return;
            }
        }
    }
    // modify the style to be appropriate for the body type
    int nNewPheno;
    // the normal phenotype uses defualt animations
    if (nPheno == Q_ACP_NORMAL_PHENO || nPheno == Q_ACP_LARGE_PHENO)
    {
        nNewPheno = nBasePheno;
    }
    // these animations are offset
    else
    {
        if (nBasePheno == 2)
        {
            nNewPheno = (nBasePheno * Q_ACP_MAXABASEPHENOTYPES * 0) + Q_ACP_ANIMATIONOFFSET + nPheno;
        }
        else nNewPheno = nBasePheno * Q_ACP_MAXABASEPHENOTYPES + Q_ACP_ANIMATIONOFFSET + nPheno;
    }
    SetPhenoType(nNewPheno, oPC);
    SendMessageToPC(oPC, "Configurando el estilo de lucha: " + sStyle + " " + IntToString(nNewPheno));
    int nCambAlt = ObtenerIntPersistente(oPC, "CAB_ALTURA");
    if (nCambAlt ==TRUE)
    {
            float fAltura = ObtenerFloatPersistente(oPC, "IND_ALTURA");
            SetObjectVisualTransform (oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fAltura);
    }
}

// Returns the Phenotype corresponding to the input string
// Returns -1 on invaid input
int Q_ACPGetPhenoFromString(object oPC, string sText)
{
    // this should be passed in as lower case anyway
    // ... but make sure, just in case
    sText = GetStringLowerCase(sText);

    if (GetLocalInt(oPC, "Q_BASE_PHENOTYPE") > 0) //PC's base phenotype is Large
    {
        if (sText == GetStringLowerCase(Q_ACP_ARCANE_STRING))
        {
            return Q_ACP_ARCANE_L_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_ASSASIN_STRING))
        {
            return Q_ACP_ASSASIN_L_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_DEMON_STRING))
        {
            return Q_ACP_DEMON_L_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_FENCING_STRING))
        {
            return Q_ACP_FENCING_L_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_HEAVY_STRING))
        {
            return Q_ACP_HEAVY_L_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_KENSAI_STRING))
        {
            return Q_ACP_KENSAI_L_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_HUNG_STRING))
        {
            return Q_ACP_HUNG_L_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_MUAY_STRING))
        {
            return Q_ACP_MUAY_L_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_SHAO_STRING))
        {
            return Q_ACP_SHAO_L_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_SHOTO_STRING))
        {
            return Q_ACP_SHOTO_L_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_WARRIOR_STRING))
        {
            return Q_ACP_WARRIOR_L_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_NORMAL_STRING))
        {
            return Q_ACP_LARGE_PHENO;
        }

        if (sText == GetStringLowerCase(Q_SOCIAL_STRING))
        {
            return Q_SOCIAL_L_PHENO;
        }

        if (sText == GetStringLowerCase(Q_FLYING_STRING))
        {
            return Q_FLYING_L_PHENO;
        }
    }
    else // PC's base phenotype is Normal
    {
        if (sText == GetStringLowerCase(Q_ACP_ARCANE_STRING))
        {
            return Q_ACP_ARCANE_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_ASSASIN_STRING))
        {
            return Q_ACP_ASSASIN_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_DEMON_STRING))
        {
            return Q_ACP_DEMON_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_FENCING_STRING))
        {
            return Q_ACP_FENCING_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_HEAVY_STRING))
        {
            return Q_ACP_HEAVY_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_KENSAI_STRING))
        {
            return Q_ACP_KENSAI_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_HUNG_STRING))
        {
            return Q_ACP_HUNG_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_MUAY_STRING))
        {
            return Q_ACP_MUAY_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_SHAO_STRING))
        {
            return Q_ACP_SHAO_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_SHOTO_STRING))
        {
            return Q_ACP_SHOTO_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_WARRIOR_STRING))
        {
            return Q_ACP_WARRIOR_PHENO;
        }

        if (sText == GetStringLowerCase(Q_ACP_NORMAL_STRING))
        {
            return Q_ACP_NORMAL_PHENO;
        }

        if (sText == GetStringLowerCase(Q_SOCIAL_STRING))
        {
            return Q_SOCIAL_PHENO;
        }

        if (sText == GetStringLowerCase(Q_FLYING_STRING))
        {
            return Q_FLYING_PHENO;
        }
    }

    // if the string wasn't matched return -1 as an error code
    return -1;
}

// Returns the Phenotype corresponding to the input string
// Returns -1 on invaid input
int Q_VaeiGetAnimFromString(string sText)
{
    // this should be passed in as lower case anyway
    // ... but make sure, just in case
    sText = GetStringLowerCase(sText);

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM1_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM16;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM2_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM17;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM3_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM5;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM4_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM7;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM5_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM8;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM6_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM9;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM7_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM10;
    }

    if (sText == GetStringLowerCase(Q_VAEI_CUSTOM8_STRING))
    {
        return ANIMATION_LOOPING_CUSTOM18;
    }

    // if the string wasn't matched return -1 as an error code
    return -1;
}

void Q_AddnAnimWrapper(object oPC, int nAnimIndex, float fAnimSpeed, float fAnimDuration)
{
    SendMessageToPC(oPC, "Playing Animation"); // Debug Line
    DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(0.15, AssignCommand(oPC, ActionPlayAnimation(nAnimIndex, fAnimSpeed, fAnimDuration)));
    return;
}

float GetAppearanceModifierFromABAScaling(object oPC)
{
    int iRacialType = GetRacialType(oPC);

    if (GetGender(oPC) == GENDER_MALE)
    {
        if(iRacialType == IP_CONST_RACIALTYPE_HUMAN)
            return 1.0;
        else if(iRacialType == IP_CONST_RACIALTYPE_HALFLING)
            return 0.65;
        else if(iRacialType == IP_CONST_RACIALTYPE_ELF)
            return 0.895;
        else if(iRacialType == IP_CONST_RACIALTYPE_DWARF)
            return 0.68;
        else if(iRacialType == IP_CONST_RACIALTYPE_GNOME)
            return 0.63;
        else return 1.03;
    }
    else
    {
        if(iRacialType == IP_CONST_RACIALTYPE_HUMAN)
            return 0.988;
        else if(iRacialType == IP_CONST_RACIALTYPE_HALFLING)
            return 0.632;
        else if(iRacialType == IP_CONST_RACIALTYPE_ELF)
            return 0.883;
        else if(iRacialType == IP_CONST_RACIALTYPE_DWARF)
            return 0.648;
        else if(iRacialType == IP_CONST_RACIALTYPE_GNOME)
            return 0.63;
        else return 0.997;
    }
}

// Sets the phenotype of a PC based on spoken commands
// object oPC   - the PC that uttered the command
// string sText - the string that was spoken
void Q_ACPCheckChat(object oPC, string sText)
{
    // test if the first word is the specified keyword
    // just in case the keyword was changed and is not in lowercase, change it to lowercase
    if (GetStringLeft(sText, GetStringLength(Q_ACP_KEYWORD)) == GetStringLowerCase(Q_ACP_KEYWORD))
    {
        // get the remainder of the string following the keyword
        string sStyle = GetStringRight(sText, GetStringLength(sText) - GetStringLength(Q_ACP_KEYWORD));
        int nPheno = Q_ACPGetPhenoFromString(oPC, sStyle);
        if (nPheno != -1)
        {
            Q_ACPSetStyle(oPC, nPheno, sStyle);
            SetPCChatMessage();
        }
    }

    else if (GetStringLeft(sText, GetStringLength(Q_ANIM_KEYWORD)) == GetStringLowerCase(Q_ANIM_KEYWORD))
    {
        //get the remainder of the string following the keyword
        string sAnim = GetStringRight(sText, GetStringLength(sText) - GetStringLength(Q_ANIM_KEYWORD));
        int nAnim = Q_VaeiGetAnimFromString(sAnim);
        //SendMessageToPC(oPC, "Animation " +IntToString(nAnim)); // Debug Line
        if (nAnim != -1)
        {
            float fSpeed, fDuration;
            if (nAnim == ANIMATION_LOOPING_CUSTOM16) //Onward Adelante
            {
                fSpeed = 1.0;
                fDuration = 1.5;
            }
            else if (nAnim == ANIMATION_LOOPING_CUSTOM17 || //Thought Pensativo
                     nAnim == ANIMATION_LOOPING_CUSTOM5 ||  //Headache Dolor de cabeza
                     nAnim == ANIMATION_LOOPING_CUSTOM7 ||  //Crossed  Cruzado
                     nAnim == ANIMATION_LOOPING_CUSTOM10)   //Crouching tiger  Tigre en cuclillas
            {
                fSpeed = 1.0;
                fDuration = 30.0;
            }
            else if (nAnim == ANIMATION_LOOPING_CUSTOM8) //Jump    Saltar
            {
                fSpeed = 1.5;
                fDuration = 3.5;
            }
            else if (nAnim ==  ANIMATION_LOOPING_CUSTOM9) //Follow  Seguir
            {
                fSpeed = 2.0;
                fDuration = 2.0;
            }
            else if (nAnim == ANIMATION_LOOPING_CUSTOM18) //Sleep    Dormir
            {
                // This is to prevent PCs from holding a torch while sleeping.  It breaks the anim.
                object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
                if (oLeftHand != OBJECT_INVALID)
                    AssignCommand(oPC, ActionUnequipItem(oLeftHand));

                fSpeed = 1.0;
                fDuration = 60.0;
            }
            if (nAnim == ANIMATION_LOOPING_CUSTOM8) //Jump
            {
                // Hotfix - Disable if not in a jump trigger (fixes an exploit allowing PCs to jump through walls and locked doors)
                if (GetLocalInt(oPC, "Q_JUMP_ALLOWED") == 0)
                {
                    FloatingTextStringOnCreature("Tu no puedes saltar aqui.", oPC, FALSE);
                    return;
                }
                string sTag = GetLocalString(oPC, "Q_JUMP_FACING");
                object oFace = GetWaypointByTag(sTag);
                vector vFace = GetPosition(oFace);
                if (GetIsObjectValid(oFace))
                {
                    AssignCommand(oPC, SetFacingPoint(vFace));
                    float fDist = -3.974 * GetAppearanceModifierFromABAScaling(oPC);
                    location lTarget = GenerateNewLocationFromLocation(GetLocation(oPC), fDist, GetFacing(oFace), GetFacing(oFace));
                    SetFootstepType(FOOTSTEP_TYPE_NONE, oPC);
                    DelayCommand(1.4, Q_AddnAnimWrapper(oPC, nAnim, fSpeed, fDuration));
                    DelayCommand(5.80, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oPC, 0.63));
                    DelayCommand(5.82, AssignCommand(oPC, JumpToLocation(lTarget)));
                    DelayCommand(5.84, SetFootstepType(FOOTSTEP_TYPE_DEFAULT, oPC));
                    DelayCommand(5.86, AssignCommand(oPC, SetFacing(GetFacing(oPC)-180.0)));
                }
                else
                {
                    FloatingTextStringOnCreature("ERROR - Salto ha sido desactivado aqui. Por favor avise a un DM", oPC, FALSE);
                    WriteTimestampedLogEntry("ERROR - Salto del Tigre en Area - "+GetTag(GetArea(oPC))+" - no tiene punto de referencia de salto. Salto desactivado en esta entrada.");
                    return;
                }
            }
            else
            {
                Q_AddnAnimWrapper(oPC, nAnim, fSpeed, fDuration);
            }
            SetPCChatMessage();
        }
    }
}
