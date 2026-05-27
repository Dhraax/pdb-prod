
#include "pb_const_vfx"
#include "mti_libreria"

/////////////////////////////////////////////
/////////                        ////////////
/////////      CONSTANTES        ////////////
/////////                        ////////////
/////////////////////////////////////////////
const string VFX_TARGET = "VFX_TARGET";

/////////////////////////
//  HORN VFX CONSTANTS //
/////////////////////////

//VFX tags constants
const string HORNS_VFX_DM_TAG = "horns_permanent_DM";

//Variable names on container constants
const string HORNS_VARIABLE_NAME = "HORNS_VFX_DM";

//Color string constants
const string VFX_STRING_HORN_MEPH = "MEPH";
const string VFX_STRING_HORN_OX = "OX";
const string VFX_STRING_HORN_ROTHE = "ROTHE";
const string VFX_STRING_HORN_BALOR = "BALOR";
const string VFX_STRING_HORN_DRAGON = "DRAGON";
const string VFX_STRING_HORN_RAM = "RAM";
const string VFX_STRING_HORN_ANTLERS = "ANTLERS";
const string VFX_STRING_HORN_DEMON = "DEMON";

//Color int constants
const int VFX_INT_HORN_MEPH = 1;
const int VFX_INT_HORN_OX = 2;
const int VFX_INT_HORN_ROTHE = 3;
const int VFX_INT_HORN_BALOR = 4;
const int VFX_INT_HORN_DRAGON = 5;
const int VFX_INT_HORN_RAM = 6;
const int VFX_INT_HORN_ANTLERS = 7;
const int VFX_INT_HORN_DEMON = 8;

///////////////////////////
//  HELMS VFX CONSTANTS  //
///////////////////////////

//VFX tags constants
const string HELM_VFX_DM_TAG = "helm_permanent_DM";


//Variable names on container constants
const string HELM_VARIABLE_NAME = "HELM_VFX_DM";

//Helms string constants
const string VFX_STRING_HELM_05 = "HELM_05";
const string VFX_STRING_HELM_08 = "HELM_08";
const string VFX_STRING_HELM_09 = "HELM_09";
const string VFX_STRING_HELM_12 = "HELM_12";
const string VFX_STRING_HELM_13 = "HELM_13";
const string VFX_STRING_HELM_14 = "HELM_14";
const string VFX_STRING_HELM_16 = "HELM_16";
const string VFX_STRING_HELM_17 = "HELM_17";
const string VFX_STRING_HELM_20 = "HELM_20";
const string VFX_STRING_HELM_24 = "HELM_24";
const string VFX_STRING_HELM_28 = "HELM_28";
const string VFX_STRING_HELM_29 = "HELM_29";
const string VFX_STRING_HELM_30 = "HELM_30";
const string VFX_STRING_HELM_32 = "HELM_32";

//Helms int constants
const int VFX_INT_HELM_05 = 1;
const int VFX_INT_HELM_08 = 2;
const int VFX_INT_HELM_09 = 3;
const int VFX_INT_HELM_12 = 4;
const int VFX_INT_HELM_13 = 5;
const int VFX_INT_HELM_14 = 6;
const int VFX_INT_HELM_16 = 7;
const int VFX_INT_HELM_17 = 8;
const int VFX_INT_HELM_20 = 9;
const int VFX_INT_HELM_24 = 10;
const int VFX_INT_HELM_28 = 11;
const int VFX_INT_HELM_29 = 12;
const int VFX_INT_HELM_30 = 13;
const int VFX_INT_HELM_32 = 14;

/////////////////////////
//  HAIR VFX CONSTANTS //
/////////////////////////

//VFX tags constants
const string HAIR_VFX_DM_TAG = "hair_permanent_DM";

//Variable names on container constants
const string HAIR_VARIABLE_NAME = "HAIR_VFX_DM";

//Color string constants
const string VFX_STRING_HAIR_FIRE = "FIRE";

//Color int constants
const int VFX_INT_HAIR_FIRE = 1;

//VFX tags constants
const string EYES_VFX_DM_TAG = "eyes_permanent_DM";

//Variable names on container constants
const string EYES_VARIABLE_NAME = "EYES_VFX_DM";

/////////////////////////
//  EYES VFX CONSTANTS //
/////////////////////////

//Color string constants
const string VFX_STRING_COLOR_CYAN = "CYAN";
const string VFX_STRING_COLOR_GREEN = "GREEN";
const string VFX_STRING_COLOR_PURPLE = "PURPLE";
const string VFX_STRING_COLOR_ORANGE = "ORANGE";
const string VFX_STRING_COLOR_RED_FLAME = "RED_FLAME";
const string VFX_STRING_COLOR_YELLOW = "YELLOW";
const string VFX_STRING_COLOR_WHITE = "WHITE";
const string VFX_STRING_COLOR_BLUE = "BLUE";
const string VFX_STRING_COLOR_RED = "RED";
const string VFX_STRING_COLOR_BLACK = "BLACK";

//Color int constants
const int VFX_INT_COLOR_CYAN = 1;
const int VFX_INT_COLOR_GREEN = 2;
const int VFX_INT_COLOR_PURPLE = 3;
const int VFX_INT_COLOR_ORANGE = 4;
const int VFX_INT_COLOR_RED_FLAME = 5;
const int VFX_INT_COLOR_YELLOW = 6;
const int VFX_INT_COLOR_WHITE = 7;
const int VFX_INT_COLOR_BLUE = 8;
const int VFX_INT_COLOR_RED = 9;
const int VFX_INT_COLOR_BLACK = 10;

///////////////////////////////////////////////////////
/////////                                  ////////////
/////////      DEFINICION FUNCIONES        ////////////
/////////                                  ////////////
///////////////////////////////////////////////////////

/////////
///////////// FUNCIONES CUERNOS  //////////////////////////////////
/////////

//Quita el efecto visual de cuernos impuesto por un DM. No borra la variable persistente.
void RemoveHornsDMVFX(object oPC);

//Devuelve TRUE si el personaje tiene VFX de cuernos activo dado por DMs. FALSE en caso contrario.
int CheckHornsVFXOnCharacter(object oPC);

//Devuelve la constante numerica asignada al modelo de cuernos correspondiente según texto.
//Valores aceptados: MEPH,OX,ROTHE,BALOR,DRAGON,RAM,ANTLERS y DEMON.
//Devuelve 0 para valores no aceptados
int ConvertHornsStringModelConstantToIntModelConstant(string sHorns);

//Devuelve la constante correcta según raza y género del personaje para el VFX de los cuernos.
int GetCorrectHornsVFXConstantForCharacter(object oPC, int iHorns);

//Aplica un efecto VFX de cuernos elegido por el DM.
void ApplyHornsVFX_DM(object oPC, string sHorn);

/////////
///////////// FUNCIONES YELMOS  //////////////////////////////////
/////////

//Quita el efecto visual impuesto por un DM de yelmo. No borra la variable persistente.
void RemoveHelmDMVFX(object oPC);

//Devuelve TRUE si el personaje tiene VFX de yelmo activo dado por DMs. FALSE en caso contrario.
int CheckHelmVFXOnCharacter(object oPC);

//Devuelve la constante numerica asignada al yelmo correspondiente según texto.
//Valores aceptados: HELM_05,_08,_09,_12,_13,_14,_16,_17,_20,_24,_28,_29,_30,_32.
//Devuelve 0 para valores no aceptados
int ConvertHelmStringModelConstantToIntModelConstant(string sHelm);

//Devuelve la constante correcta según raza y género del personaje para el VFX de yelmo.
int GetCorrectHelmVFXConstantForCharacter(object oPC, int iHelm);

//Aplica un efecto VFX de yelmo elegido por el DM.
void ApplyHelmVFX_DM(object oPC, string sHelm);

/////////
///////////// FUNCIONES PELO  //////////////////////////////////
/////////

//Quita el efecto visual del pelo impuesto por un DM. No borra la variable persistente.
void RemoveHairDMVFX(object oPC);

//Devuelve TRUE si el personaje tiene VFX de pelo activo dado por DMs. FALSE en caso contrario.
int CheckHairVFXOnCharacter(object oPC);

//Devuelve la constante numerica asignada al modelo de pelo correspondiente según texto.
//Valores aceptados: FIRE.
//Devuelve 0 para valores no aceptados
int ConvertHairStringModelConstantToIntModelConstant(string sHair);

//Devuelve la constante correcta según raza y género del personaje para el VFX del pelo.
int GetCorrectHairVFXConstantForCharacter(object oPC, int iHair);

//Aplica un efecto VFX en el pelo elegido por el DM.
void ApplyHairVFX_DM(object oPC, string sHair);

/////////
///////////// FUNCIONES OJOS  //////////////////////////////////
/////////

//Quita el efecto visual impuesto por un DM en los ojos. No borra la variable persistente.
void RemoveEyesDMVFX(object oPC);

//Devuelve TRUE si el personaje tiene VFX en los ojos activo dado por DMs. FALSE en caso contrario.
int CheckEyesVFXOnCharacter(object oPC);

//Devuelve la constante numerica asignada al color de ojos correspondiente según texto.
//Valores aceptados: CYAN,GREEN,PURPLE,ORANGE,RED_FLAME,YELLOW,WHITE,BLUE,RED AND BLACK.
//Devuelve 0 para valores no aceptados
int ConvertEyesStringColorConstantToIntColorConstant(string sColor);

//Devuelve la constante correcta según raza y género del personaje para el VFX de los ojos.
int GetCorrectEyeVFXConstantForCharacter(object oPC, int iColor);

//Aplica un efecto VFX en los ojos elegido por el DM.
void ApplyEyesVFX_DM(object oPC, string sColor);



/////////////////////////
// Funciones genericas //
/////////////////////////

//Reaplica los VFX permanentes guardados una vez se entra en el servidor y no estan activos.
void LoadAllDMVFX(object oPC);

//Elimina todos VFX permanentes aplicados por un DM.(No elimina las variables guardadas)
void RemoveAllDMVFX(object oPC);

//Comprueba si el jugador se ha equipado un yelmo y elimina los VFX permanentes de DM de la cabeza si los hay. (No borra variables guardadas)
void OnEquipItemCheckIfHelmAndRemoveDMVFX(object oPC, object oItem);

//Comprueba si el jugador se ha desequipado un yelmo y aplica los VFX permanentes de DM de la cabeza si los hay.
void OnUnequipItemCheckIfHelmAndApplyDMVFX(object oPC, object oItem);

//Function to use on the OnActivate module event script.
void OnActivateItemScript(object oUser,object oTarget);

// Comprueba si el jugador tiene un casco equipado, y si este es visible
int CheckIfHasVisibleHelmet(object oPC);

///////////////////////////////////////////////////////
/////////                                  ////////////
/////////            FUNCIONES             ////////////
/////////                                  ////////////
///////////////////////////////////////////////////////

void RemoveHornsDMVFX(object oPC){
    effect eEffect = GetFirstEffect(oPC);
    string sEffectTag;

    while(GetIsEffectValid(eEffect)){

        sEffectTag = GetEffectTag(eEffect);
        if(sEffectTag == HORNS_VFX_DM_TAG){
            RemoveEffect(oPC,eEffect);
            return;
        }

        eEffect = GetNextEffect(oPC);

    }

}

int CheckHornsVFXOnCharacter(object oPC){
    effect eEffect = GetFirstEffect(oPC);
    string sEffectTag;

    while(GetIsEffectValid(eEffect)){

        sEffectTag = GetEffectTag(eEffect);
        if(sEffectTag == HORNS_VFX_DM_TAG){
            return TRUE;
        }

        eEffect = GetNextEffect(oPC);

    }

    return FALSE;
}

int ConvertHornsStringModelConstantToIntModelConstant(string sHorns)
{
    if(sHorns == VFX_STRING_HORN_MEPH){

        return VFX_INT_HORN_MEPH;

    } else if(sHorns == VFX_STRING_HORN_OX){

        return VFX_INT_HORN_OX;

    } else if(sHorns == VFX_STRING_HORN_ROTHE){

        return VFX_INT_HORN_ROTHE;

    } else if(sHorns == VFX_STRING_HORN_BALOR){

        return VFX_INT_HORN_BALOR;

    } else if(sHorns == VFX_STRING_HORN_DRAGON){

        return VFX_INT_HORN_DRAGON;

    } else if(sHorns == VFX_STRING_HORN_RAM){

        return VFX_INT_HORN_RAM;

    } else if(sHorns == VFX_STRING_HORN_ANTLERS){

        return VFX_INT_HORN_ANTLERS;

    } else if(sHorns == VFX_STRING_HORN_DEMON){

        return VFX_INT_HORN_DEMON;

    }else {
        return 0;
    }
}

int GetCorrectHornsVFXConstantForCharacter(object oPC, int iHorns)
{
    int iGender = GetGender(oPC);
    int iAppearance = GetAppearanceType(oPC);
    int iVFXconstant;

    switch (iAppearance)
    {
        case APPEARANCE_TYPE_DWARF:
        {
            if(iGender == GENDER_MALE)
            {
                switch(iHorns)
                {
                    case VFX_INT_HORN_MEPH:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_MEPH_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_OX:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_OX_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_ROTHE:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_ROTHE_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_BALOR:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_BALOR_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_DRAGON:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_DRAGON_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_RAM:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_RAM_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_ANTLERS:
                    {
                        iVFXconstant = IPPVFX_HEAD_ANTLERS_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_DEMON:
                    {
                        iVFXconstant = VFX_HORN_DEMON_1_DWARF_MALE_AENE;
                        break;
                    }

                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch(iHorns)
                {
                    case VFX_INT_HORN_MEPH:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_MEPH_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_OX:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_OX_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_ROTHE:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_ROTHE_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_BALOR:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_BALOR_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_DRAGON:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_DRAGON_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_RAM:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_RAM_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_ANTLERS:
                    {
                        iVFXconstant = IPPVFX_HEAD_ANTLERS_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_DEMON:
                    {
                        iVFXconstant = VFX_HORN_DEMON_1_DWARF_FEMALE_AENE;
                        break;
                    }

                }
            }
            break;
        }

        case APPEARANCE_TYPE_ELF:
        {
            if(iGender == GENDER_MALE)
            {
                switch(iHorns)
                {
                    case VFX_INT_HORN_MEPH:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_MEPH_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_OX:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_OX_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_ROTHE:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_ROTHE_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_BALOR:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_BALOR_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_DRAGON:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_DRAGON_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_RAM:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_RAM_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_ANTLERS:
                    {
                        iVFXconstant = IPPVFX_HEAD_ANTLERS_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HORN_DEMON:
                    {
                        iVFXconstant = VFX_HORN_DEMON_1_ELF_MALE_AENE;
                        break;
                    }

                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch(iHorns)
                {
                    case VFX_INT_HORN_MEPH:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_MEPH_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_OX:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_OX_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_ROTHE:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_ROTHE_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_BALOR:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_BALOR_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_DRAGON:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_DRAGON_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_RAM:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_RAM_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_ANTLERS:
                    {
                        iVFXconstant = IPPVFX_HEAD_ANTLERS_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_DEMON:
                    {
                        iVFXconstant = VFX_HORN_DEMON_1_ELF_FEMALE_AENE;
                        break;
                    }

                }
            }
            break;
        }

        case APPEARANCE_TYPE_GNOME:
        {
            if(iGender == GENDER_MALE)
            {
                switch(iHorns)
                {
                    case VFX_INT_HORN_MEPH:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_MEPH_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HORN_OX:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_OX_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HORN_ROTHE:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_ROTHE_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HORN_BALOR:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_BALOR_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HORN_DRAGON:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_DRAGON_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HORN_RAM:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_RAM_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HORN_ANTLERS:
                    {
                        iVFXconstant = IPPVFX_HEAD_ANTLERS_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HORN_DEMON:
                    {
                        iVFXconstant = VFX_HORN_DEMON_1_GNOME_MALE_AENE;
                        break;
                    }

                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch(iHorns)
                {
                    case VFX_INT_HORN_MEPH:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_MEPH_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_OX:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_OX_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_ROTHE:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_ROTHE_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_BALOR:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_BALOR_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_DRAGON:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_DRAGON_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_RAM:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_RAM_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_ANTLERS:
                    {
                        iVFXconstant = IPPVFX_HEAD_ANTLERS_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_DEMON:
                    {
                        iVFXconstant = VFX_HORN_DEMON_1_GNOME_FEMALE_AENE;
                        break;
                    }

                }
            }
            break;
        }

        case APPEARANCE_TYPE_HALFLING:
        {
            if(iGender == GENDER_MALE)
            {
                switch(iHorns)
                {
                    case VFX_INT_HORN_MEPH:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_MEPH_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HORN_OX:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_OX_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HORN_ROTHE:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_ROTHE_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HORN_BALOR:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_BALOR_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HORN_DRAGON:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_DRAGON_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HORN_RAM:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_RAM_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HORN_ANTLERS:
                    {
                        iVFXconstant = IPPVFX_HEAD_ANTLERS_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HORN_DEMON:
                    {
                        iVFXconstant = VFX_HORN_DEMON_1_HALFLING_MALE_AENE;
                        break;
                    }

                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch(iHorns)
                {
                    case VFX_INT_HORN_MEPH:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_MEPH_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_OX:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_OX_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_ROTHE:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_ROTHE_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_BALOR:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_BALOR_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_DRAGON:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_DRAGON_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_RAM:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_RAM_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_ANTLERS:
                    {
                        iVFXconstant = IPPVFX_HEAD_ANTLERS_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_DEMON:
                    {
                        iVFXconstant = VFX_HORN_DEMON_1_HALFLING_FEMALE_AENE;
                        break;
                    }

                }
            }
            break;
        }

        case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
        case APPEARANCE_TYPE_HALF_ORC:
        {
            if(iGender == GENDER_MALE)
            {
                switch(iHorns)
                {
                    case VFX_INT_HORN_MEPH:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_MEPH_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HORN_OX:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_OX_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HORN_ROTHE:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_ROTHE_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HORN_BALOR:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_BALOR_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HORN_DRAGON:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_DRAGON_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HORN_RAM:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_RAM_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HORN_ANTLERS:
                    {
                        iVFXconstant = IPPVFX_HEAD_ANTLERS_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HORN_DEMON:
                    {
                        iVFXconstant = VFX_HORN_DEMON_1_HALFORC_MALE_AENE;
                        break;
                    }

                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch(iHorns)
                {
                    case VFX_INT_HORN_MEPH:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_MEPH_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_OX:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_OX_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_ROTHE:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_ROTHE_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_BALOR:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_BALOR_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_DRAGON:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_DRAGON_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_RAM:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_RAM_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_ANTLERS:
                    {
                        iVFXconstant = IPPVFX_HEAD_ANTLERS_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_DEMON:
                    {
                        iVFXconstant = VFX_HORN_DEMON_1_HALFORC_FEMALE_AENE;
                        break;
                    }

                }
            }
            break;
        }

        case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
        case APPEARANCE_TYPE_HALF_ELF:
        case APPEARANCE_TYPE_HUMAN:
        {
            if(iGender == GENDER_MALE)
            {
                switch(iHorns)
                {
                    case VFX_INT_HORN_MEPH:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_MEPH_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HORN_OX:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_OX_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HORN_ROTHE:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_ROTHE_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HORN_BALOR:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_BALOR_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HORN_DRAGON:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_DRAGON_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HORN_RAM:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_RAM_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HORN_ANTLERS:
                    {
                        iVFXconstant = IPPVFX_HEAD_ANTLERS_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HORN_DEMON:
                    {
                        iVFXconstant = VFX_HORN_DEMON_1_HUMAN_MALE_AENE;
                        break;
                    }

                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch(iHorns)
                {
                    case VFX_INT_HORN_MEPH:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_MEPH_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_OX:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_OX_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_ROTHE:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_ROTHE_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_BALOR:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_BALOR_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_DRAGON:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_DRAGON_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_RAM:
                    {
                        iVFXconstant = IPPVFX_HEAD_HORNS_RAM_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_ANTLERS:
                    {
                        iVFXconstant = IPPVFX_HEAD_ANTLERS_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HORN_DEMON:
                    {
                        iVFXconstant = VFX_HORN_DEMON_1_HUMAN_FEMALE_AENE;
                        break;
                    }

                }
            }
            break;
        }
    }

    return iVFXconstant;
}

void RemoveHelmDMVFX(object oPC){
    effect eEffect = GetFirstEffect(oPC);
    string sEffectTag;

    while(GetIsEffectValid(eEffect)){

        sEffectTag = GetEffectTag(eEffect);
        if(sEffectTag == HELM_VFX_DM_TAG){
            RemoveEffect(oPC,eEffect);
            return;
        }

        eEffect = GetNextEffect(oPC);

    }

}

int CheckHelmVFXOnCharacter(object oPC){
    effect eEffect = GetFirstEffect(oPC);
    string sEffectTag;

    while(GetIsEffectValid(eEffect)){

        sEffectTag = GetEffectTag(eEffect);
        if(sEffectTag == HELM_VFX_DM_TAG){
            return TRUE;
        }

        eEffect = GetNextEffect(oPC);

    }

    return FALSE;
}

int ConvertHelmStringModelConstantToIntModelConstant(string sHelm)
{
    if(sHelm == VFX_STRING_HELM_05){

        return VFX_INT_HELM_05;

    } else if(sHelm == VFX_STRING_HELM_08){

        return VFX_INT_HELM_08;

    } else if(sHelm == VFX_STRING_HELM_09){

        return VFX_INT_HELM_09;

    } else if(sHelm == VFX_STRING_HELM_12){

        return VFX_INT_HELM_12;

    } else if(sHelm == VFX_STRING_HELM_13){

        return VFX_INT_HELM_13;

    } else if(sHelm == VFX_STRING_HELM_14){

        return VFX_INT_HELM_14;

    } else if(sHelm == VFX_STRING_HELM_16){

        return VFX_INT_HELM_16;

    }else if(sHelm == VFX_STRING_HELM_17){

        return VFX_INT_HELM_17;

    } else if(sHelm == VFX_STRING_HELM_20){

        return VFX_INT_HELM_20;

    }else if(sHelm == VFX_STRING_HELM_24){

        return VFX_INT_HELM_24;

    }else if(sHelm == VFX_STRING_HELM_28){

        return VFX_INT_HELM_28;

    }else if(sHelm == VFX_STRING_HELM_29){

        return VFX_INT_HELM_29;

    }else if(sHelm == VFX_STRING_HELM_30){

        return VFX_INT_HELM_30;

    }else if(sHelm == VFX_STRING_HELM_32){

        return VFX_INT_HELM_32;

    }else {
        return 0;
    }
}


int GetCorrectHelmVFXConstantForCharacter(object oPC, int iHelm)
{
    int iGender = GetGender(oPC);
    int iAppearance = GetAppearanceType(oPC);
    int iVFXconstant;

    switch (iAppearance){
        case APPEARANCE_TYPE_DWARF:
        {
            if(iGender == GENDER_MALE)
            {
                switch(iHelm)
                {
                    case VFX_INT_HELM_05:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_05_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_08:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_08_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_09:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_09_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_12:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_12_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_13:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_13_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_14:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_14_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_16:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_16_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_17:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_17_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_20:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_20_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_24:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_24_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_28:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_28_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_29:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_29_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_30:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_30_DWARF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_32:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_32_DWARF_MALE;
                        break;
                    }

                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch(iHelm)
                {
                    case VFX_INT_HELM_05:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_05_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_08:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_08_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_09:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_09_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_12:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_12_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_13:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_13_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_14:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_14_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_16:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_16_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_17:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_17_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_20:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_20_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_24:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_24_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_28:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_28_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_29:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_29_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_30:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_30_DWARF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_32:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_32_DWARF_FEMALE;
                        break;
                    }

                }
            }
            break;
        }

        case APPEARANCE_TYPE_ELF:
        {
            if(iGender == GENDER_MALE)
            {
                switch(iHelm)
                {
                    case VFX_INT_HELM_05:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_05_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_08:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_08_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_09:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_09_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_12:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_12_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_13:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_13_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_14:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_14_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_16:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_16_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_17:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_17_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_20:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_20_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_24:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_24_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_28:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_28_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_29:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_29_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_30:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_30_ELF_MALE;
                        break;
                    }

                    case VFX_INT_HELM_32:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_32_ELF_MALE;
                        break;
                    }

                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch(iHelm)
                {
                    case VFX_INT_HELM_05:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_05_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_08:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_08_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_09:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_09_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_12:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_12_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_13:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_13_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_14:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_14_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_16:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_16_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_17:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_17_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_20:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_20_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_24:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_24_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_28:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_28_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_29:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_29_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_30:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_30_ELF_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_32:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_32_ELF_FEMALE;
                        break;
                    }

                }
            }
            break;
        }

        case APPEARANCE_TYPE_GNOME:
        {
            if(iGender == GENDER_MALE)
            {
                switch(iHelm)
                {
                    case VFX_INT_HELM_05:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_05_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_08:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_08_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_09:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_09_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_12:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_12_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_13:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_13_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_14:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_14_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_16:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_16_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_17:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_17_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_20:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_20_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_24:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_24_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_28:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_28_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_29:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_29_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_30:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_30_GNOME_MALE;
                        break;
                    }

                    case VFX_INT_HELM_32:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_32_GNOME_MALE;
                        break;
                    }

                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch(iHelm)
                {
                    case VFX_INT_HELM_05:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_05_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_08:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_08_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_09:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_09_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_12:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_12_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_13:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_13_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_14:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_14_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_16:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_16_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_17:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_17_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_20:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_20_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_24:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_24_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_28:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_28_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_29:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_29_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_30:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_30_GNOME_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_32:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_32_GNOME_FEMALE;
                        break;
                    }

                }
            }
            break;
        }

        case APPEARANCE_TYPE_HALFLING:
        {
            if(iGender == GENDER_MALE)
            {
                switch(iHelm)
                {
                    case VFX_INT_HELM_05:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_05_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_08:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_08_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_09:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_09_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_12:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_12_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_13:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_13_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_14:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_14_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_16:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_16_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_17:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_17_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_20:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_20_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_24:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_24_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_28:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_28_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_29:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_29_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_30:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_30_HALFLING_MALE;
                        break;
                    }

                    case VFX_INT_HELM_32:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_32_HALFLING_MALE;
                        break;
                    }

                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch(iHelm)
                {
                    case VFX_INT_HELM_05:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_05_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_08:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_08_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_09:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_09_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_12:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_12_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_13:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_13_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_14:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_14_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_16:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_16_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_17:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_17_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_20:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_20_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_24:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_24_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_28:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_28_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_29:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_29_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_30:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_30_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_32:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_32_HALFLING_FEMALE;
                        break;
                    }

                }
            }
            break;
        }

        case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
        case APPEARANCE_TYPE_HALF_ORC:
        {
            if(iGender == GENDER_MALE)
            {
                switch(iHelm)
                {
                    case VFX_INT_HELM_05:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_05_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_08:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_08_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_09:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_09_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_12:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_12_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_13:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_13_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_14:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_14_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_16:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_16_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_17:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_17_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_20:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_20_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_24:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_24_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_28:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_28_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_29:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_29_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_30:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_30_HALFORC_MALE;
                        break;
                    }

                    case VFX_INT_HELM_32:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_32_HALFORC_MALE;
                        break;
                    }

                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch(iHelm)
                {
                    case VFX_INT_HELM_05:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_05_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_08:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_08_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_09:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_09_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_12:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_12_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_13:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_13_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_14:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_14_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_16:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_16_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_17:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_17_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_20:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_20_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_24:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_24_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_28:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_28_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_29:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_29_HALFLING_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_30:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_30_HALFORC_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_32:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_32_HALFORC_FEMALE;
                        break;
                    }

                }
            }
            break;
        }
        case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
        case APPEARANCE_TYPE_HALF_ELF:
        case APPEARANCE_TYPE_HUMAN:
        {
            if(iGender == GENDER_MALE)
            {
                switch(iHelm)
                {
                    case VFX_INT_HELM_05:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_05_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_08:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_08_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_09:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_09_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_12:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_12_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_13:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_13_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_14:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_14_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_16:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_16_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_17:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_17_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_20:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_20_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_24:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_24_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_28:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_28_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_29:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_29_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_30:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_30_HUMAN_MALE;
                        break;
                    }

                    case VFX_INT_HELM_32:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_32_HUMAN_MALE;
                        break;
                    }

                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch(iHelm)
                {
                    case VFX_INT_HELM_05:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_05_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_08:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_08_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_09:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_09_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_12:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_12_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_13:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_13_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_14:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_14_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_16:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_16_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_17:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_17_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_20:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_20_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_24:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_24_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_28:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_28_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_29:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_29_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_30:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_30_HUMAN_FEMALE;
                        break;
                    }

                    case VFX_INT_HELM_32:
                    {
                        iVFXconstant = IPPVFX_HEAD_HELM_32_HUMAN_FEMALE;
                        break;
                    }

                }
            }
            break;
        }

    }

    return iVFXconstant;
}

void RemoveHairDMVFX(object oPC){
    effect eEffect = GetFirstEffect(oPC);
    string sEffectTag;

    while(GetIsEffectValid(eEffect)){

        sEffectTag = GetEffectTag(eEffect);
        if(sEffectTag == HAIR_VFX_DM_TAG){
            RemoveEffect(oPC,eEffect);
            return;
        }

        eEffect = GetNextEffect(oPC);

    }

}

int CheckHairVFXOnCharacter(object oPC){
    effect eEffect = GetFirstEffect(oPC);
    string sEffectTag;

    while(GetIsEffectValid(eEffect)){

        sEffectTag = GetEffectTag(eEffect);
        if(sEffectTag == HAIR_VFX_DM_TAG){
            return TRUE;
        }

        eEffect = GetNextEffect(oPC);

    }

    return FALSE;
}

int ConvertHairStringModelConstantToIntModelConstant(string sHair)
{
    if(sHair == VFX_STRING_HAIR_FIRE){

        return VFX_INT_HAIR_FIRE;

    }else {
        return 0;
    }
}

int GetCorrectHairVFXConstantForCharacter(object oPC, int iHair)
{
    int iGender = GetGender(oPC);
    int iAppearance = GetAppearanceType(oPC);
    int iVFXconstant;

    switch (iAppearance)
    {
        case APPEARANCE_TYPE_DWARF:
        {
            if(iGender == GENDER_MALE)
            {
                switch (iHair)
                {
                    case VFX_INT_HAIR_FIRE:
                    {
                        iVFXconstant = VFX_HAIR_FIRE_O_DWARF_MALE_AENEA;
                    }
                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch (iHair)
                {
                    case VFX_INT_HAIR_FIRE:
                    {
                        iVFXconstant = VFX_HAIR_FIRE_O_DWARF_FEMALE_AENEA;
                    }
                }

            }
            break;
        }

        case APPEARANCE_TYPE_ELF:
        {
            if(iGender == GENDER_MALE)
            {
                switch (iHair)
                {
                    case VFX_INT_HAIR_FIRE:
                    {
                        iVFXconstant = VFX_HAIR_FIRE_O_ELF_MALE_AENEA;
                    }
                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch (iHair)
                {
                    case VFX_INT_HAIR_FIRE:
                    {
                        iVFXconstant = VFX_HAIR_FIRE_O_ELF_FEMALE_AENEA;
                    }
                }

            }
            break;
        }

        case APPEARANCE_TYPE_GNOME:
        {
            if(iGender == GENDER_MALE)
            {
                switch (iHair)
                {
                    case VFX_INT_HAIR_FIRE:
                    {
                        iVFXconstant = VFX_HAIR_FIRE_O_GNOME_MALE_AENEA;
                    }
                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch (iHair)
                {
                    case VFX_INT_HAIR_FIRE:
                    {
                        iVFXconstant = VFX_HAIR_FIRE_O_GNOME_FEMALE_AENEA;
                    }
                }

            }
            break;
        }

        case APPEARANCE_TYPE_HALFLING:
        {
            if(iGender == GENDER_MALE)
            {
                switch (iHair)
                {
                    case VFX_INT_HAIR_FIRE:
                    {
                        iVFXconstant = VFX_HAIR_FIRE_O_HALFLING_MALE_AENEA;
                    }
                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch (iHair)
                {
                    case VFX_INT_HAIR_FIRE:
                    {
                        iVFXconstant = VFX_HAIR_FIRE_O_HALFLING_FEMALE_AENEA;
                    }
                }

            }
            break;
        }

        case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
        case APPEARANCE_TYPE_HALF_ORC:
        {
            if(iGender == GENDER_MALE)
            {
                switch (iHair)
                {
                    case VFX_INT_HAIR_FIRE:
                    {
                        iVFXconstant = VFX_HAIR_FIRE_O_HALFORC_MALE_AENEA;
                    }
                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch (iHair)
                {
                    case VFX_INT_HAIR_FIRE:
                    {
                        iVFXconstant = VFX_HAIR_FIRE_O_HALFORC_FEMALE_AENEA;
                    }
                }

            }
            break;
        }
        case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
        case APPEARANCE_TYPE_HALF_ELF:
        case APPEARANCE_TYPE_HUMAN:
        {
            if(iGender == GENDER_MALE)
            {
                switch (iHair)
                {
                    case VFX_INT_HAIR_FIRE:
                    {
                        iVFXconstant = VFX_HAIR_FIRE_O_HUMAN_MALE_AENEA;
                    }
                }
            }
            else if( iGender == GENDER_FEMALE)
            {
                switch (iHair)
                {
                    case VFX_INT_HAIR_FIRE:
                    {
                        iVFXconstant = VFX_HAIR_FIRE_O_HUMAN_FEMALE_AENEA;
                    }
                }

            }
            break;
        }
    }

    return iVFXconstant;
}

void RemoveEyesDMVFX(object oPC){
    effect eEffect = GetFirstEffect(oPC);
    string sEffectTag;

    while(GetIsEffectValid(eEffect)){

        sEffectTag = GetEffectTag(eEffect);
        if(sEffectTag == EYES_VFX_DM_TAG){
            RemoveEffect(oPC,eEffect);
            return;
        }

        eEffect = GetNextEffect(oPC);

    }

}

int CheckEyesVFXOnCharacter(object oPC){
    effect eEffect = GetFirstEffect(oPC);
    string sEffectTag;

    while(GetIsEffectValid(eEffect)){

        sEffectTag = GetEffectTag(eEffect);
        if(sEffectTag == EYES_VFX_DM_TAG){
            return TRUE;
        }

        eEffect = GetNextEffect(oPC);

    }

    return FALSE;
}

int ConvertEyesStringColorConstantToIntColorConstant(string sColor)
{
    if(sColor == VFX_STRING_COLOR_CYAN){

        return VFX_INT_COLOR_CYAN;

    } else if(sColor ==VFX_STRING_COLOR_GREEN){

        return VFX_INT_COLOR_GREEN;

    } else if(sColor == VFX_STRING_COLOR_PURPLE){

        return VFX_INT_COLOR_PURPLE;

    } else if(sColor == VFX_STRING_COLOR_ORANGE){

        return VFX_INT_COLOR_ORANGE;

    } else if(sColor == VFX_STRING_COLOR_RED_FLAME){

        return VFX_INT_COLOR_RED_FLAME;

    } else if(sColor == VFX_STRING_COLOR_YELLOW){

        return VFX_INT_COLOR_YELLOW;

    } else if(sColor == VFX_STRING_COLOR_WHITE){

        return VFX_INT_COLOR_WHITE;

    } else if(sColor == VFX_STRING_COLOR_BLUE){

        return VFX_INT_COLOR_BLUE;

    }else if(sColor == VFX_STRING_COLOR_RED){

        return VFX_INT_COLOR_RED;

    }else if(sColor == VFX_STRING_COLOR_BLACK){

        return VFX_INT_COLOR_BLACK;

    }else {
        return 0;
    }
}

int GetCorrectEyeVFXConstantForCharacter(object oPC, int iColor)
{
    int iGender = GetGender(oPC);
    int iAppearance = GetAppearanceType(oPC);
    int iVFXconstant;

    switch (iColor){

        case VFX_INT_COLOR_CYAN:
        {

            switch (iAppearance)
            {
                case APPEARANCE_TYPE_DWARF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_CYN_DWARF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_CYN_DWARF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_ELF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_CYN_ELF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_CYN_ELF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_GNOME:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_CYN_GNOME_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_CYN_GNOME_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALFLING:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_CYN_HALFLING_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_CYN_HALFLING_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
                case APPEARANCE_TYPE_HALF_ORC:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_CYN_HALFORC_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_CYN_HALFORC_FEMALE;
                    }
                    break;
                case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
                case APPEARANCE_TYPE_HALF_ELF:
                case APPEARANCE_TYPE_HUMAN:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_CYN_HUMAN_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_CYN_HUMAN_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_KOBOLD_A:
                case APPEARANCE_TYPE_KOBOLD_B:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_A:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_B:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_A:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_B:


                    iVFXconstant = VFX_EYES_CYN_TROGLODYTE;

                    break;
            }
            break;

        }

        case VFX_INT_COLOR_GREEN:
        {

            switch (iAppearance)
            {
                case APPEARANCE_TYPE_DWARF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_GREEN_DWARF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_GREEN_DWARF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_ELF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_GREEN_ELF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_GREEN_ELF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_GNOME:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_GREEN_GNOME_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_GREEN_GNOME_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALFLING:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_GREEN_HALFLING_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_GREEN_HALFLING_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
                case APPEARANCE_TYPE_HALF_ORC:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_GREEN_HALFORC_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_GREEN_HALFORC_FEMALE;
                    }
                    break;
                case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
                case APPEARANCE_TYPE_HALF_ELF:
                case APPEARANCE_TYPE_HUMAN:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_GREEN_HUMAN_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_GREEN_HUMAN_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_KOBOLD_A:
                case APPEARANCE_TYPE_KOBOLD_B:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_A:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_B:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_A:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_B:

                    iVFXconstant = VFX_EYES_GREEN_TROGLODYTE;

                    break;
            }
            break;

        }

        case VFX_INT_COLOR_ORANGE:
        {

            switch (iAppearance)
            {
                case APPEARANCE_TYPE_DWARF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_ORG_DWARF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_ORG_DWARF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_ELF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_ORG_ELF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_ORG_ELF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_GNOME:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_ORG_GNOME_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_ORG_GNOME_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALFLING:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_ORG_HALFLING_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_ORG_HALFLING_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
                case APPEARANCE_TYPE_HALF_ORC:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_ORG_HALFORC_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_ORG_HALFORC_FEMALE;
                    }
                    break;
                case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
                case APPEARANCE_TYPE_HALF_ELF:
                case APPEARANCE_TYPE_HUMAN:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_ORG_HUMAN_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_ORG_HUMAN_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_KOBOLD_A:
                case APPEARANCE_TYPE_KOBOLD_B:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_A:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_B:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_A:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_B:


                    iVFXconstant = VFX_EYES_ORG_TROGLODYTE;

                    break;
            }
            break;

        }

        case VFX_INT_COLOR_PURPLE:
        {

            switch (iAppearance)
            {
                case APPEARANCE_TYPE_DWARF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_PUR_DWARF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_PUR_DWARF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_ELF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_PUR_ELF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_PUR_ELF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_GNOME:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_PUR_GNOME_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_PUR_GNOME_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALFLING:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_PUR_HALFLING_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_PUR_HALFLING_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
                case APPEARANCE_TYPE_HALF_ORC:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_PUR_HALFORC_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_PUR_HALFORC_FEMALE;
                    }
                    break;
                case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
                case APPEARANCE_TYPE_HALF_ELF:
                case APPEARANCE_TYPE_HUMAN:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_PUR_HUMAN_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_PUR_HUMAN_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_KOBOLD_A:
                case APPEARANCE_TYPE_KOBOLD_B:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_A:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_B:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_A:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_B:


                    iVFXconstant = VFX_EYES_PUR_TROGLODYTE;

                    break;
            }
            break;

        }

        case VFX_INT_COLOR_RED_FLAME:
        {

            switch (iAppearance)
            {
                case APPEARANCE_TYPE_DWARF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_RED_FLAME_DWARF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_RED_FLAME_DWARF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_ELF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_RED_FLAME_ELF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_RED_FLAME_ELF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_GNOME:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_RED_FLAME_GNOME_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_RED_FLAME_GNOME_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALFLING:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_RED_FLAME_HALFLING_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_RED_FLAME_HALFLING_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
                case APPEARANCE_TYPE_HALF_ORC:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_RED_FLAME_HALFORC_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_RED_FLAME_HALFORC_FEMALE;
                    }
                    break;
                case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
                case APPEARANCE_TYPE_HALF_ELF:
                case APPEARANCE_TYPE_HUMAN:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_RED_FLAME_HUMAN_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_RED_FLAME_HUMAN_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_KOBOLD_A:
                case APPEARANCE_TYPE_KOBOLD_B:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_A:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_B:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_A:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_B:


                    iVFXconstant = VFX_EYES_RED_FLAME_TROGLODYTE;

                    break;
            }
            break;

        }

        case VFX_INT_COLOR_YELLOW:
        {

            switch (iAppearance)
            {
                case APPEARANCE_TYPE_DWARF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_YEL_DWARF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_YEL_DWARF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_ELF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_YEL_ELF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_YEL_ELF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_GNOME:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_YEL_GNOME_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_YEL_GNOME_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALFLING:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_YEL_HALFLING_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_YEL_HALFLING_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
                case APPEARANCE_TYPE_HALF_ORC:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_YEL_HALFORC_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_YEL_HALFORC_FEMALE;
                    }
                    break;
                case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
                case APPEARANCE_TYPE_HALF_ELF:
                case APPEARANCE_TYPE_HUMAN:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_YEL_HUMAN_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_YEL_HUMAN_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_KOBOLD_A:
                case APPEARANCE_TYPE_KOBOLD_B:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_A:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_B:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_A:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_B:


                    iVFXconstant = VFX_EYES_YEL_TROGLODYTE;

                    break;
            }
            break;

        }


        case VFX_INT_COLOR_WHITE:
        {

            switch (iAppearance)
            {
                case APPEARANCE_TYPE_DWARF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_WHT_DWARF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_WHT_DWARF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_ELF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_WHT_ELF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_WHT_ELF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_GNOME:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_WHT_GNOME_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_WHT_GNOME_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALFLING:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_WHT_HALFLING_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_WHT_HALFLING_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
                case APPEARANCE_TYPE_HALF_ORC:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_WHT_HALFORC_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_WHT_HALFORC_FEMALE;
                    }
                    break;
                case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
                case APPEARANCE_TYPE_HALF_ELF:
                case APPEARANCE_TYPE_HUMAN:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_WHT_HUMAN_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_WHT_HUMAN_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_KOBOLD_A:
                case APPEARANCE_TYPE_KOBOLD_B:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_A:
                case APPEARANCE_TYPE_KOBOLD_CHIEF_B:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_A:
                case APPEARANCE_TYPE_KOBOLD_SHAMAN_B:


                    iVFXconstant = VFX_EYES_WHT_TROGLODYTE;

                    break;
            }
            break;

        }

        case VFX_INT_COLOR_BLUE:
        {

            switch (iAppearance)
            {
                case APPEARANCE_TYPE_DWARF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_BLUE_DWARF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_BLUE_DWARF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_ELF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_BLUE_ELF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_BLUE_ELF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_GNOME:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_BLUE_GNOME_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_BLUE_GNOME_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALFLING:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_BLUE_HALFLING_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_BLUE_HALFLING_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
                case APPEARANCE_TYPE_HALF_ORC:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_BLUE_HALFORC_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_BLUE_HALFORC_FEMALE;
                    }
                    break;
                case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
                case APPEARANCE_TYPE_HALF_ELF:
                case APPEARANCE_TYPE_HUMAN:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = VFX_EYES_BLUE_HUMAN_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = VFX_EYES_BLUE_HUMAN_FEMALE;
                    }
                    break;

            }
            break;

        }

        case VFX_INT_COLOR_RED:
        {

            switch (iAppearance)
            {
                case APPEARANCE_TYPE_DWARF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_RED_DWARF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_RED_DWARF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_ELF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_RED_ELF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_RED_ELF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_GNOME:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_RED_GNOME_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_RED_GNOME_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALFLING:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_RED_HALFLING_FEMALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_RED_HALFLING_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
                case APPEARANCE_TYPE_HALF_ORC:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_RED_HALFORC_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_RED_HALFORC_FEMALE;
                    }
                    break;
                case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
                case APPEARANCE_TYPE_HALF_ELF:
                case APPEARANCE_TYPE_HUMAN:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_RED_HUMAN_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_RED_HUMAN_FEMALE;
                    }
                    break;
            }
            break;

        }

        case VFX_INT_COLOR_BLACK:
        {

            switch (iAppearance)
            {
                case APPEARANCE_TYPE_DWARF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_BLACK_DWARF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_BLACK_DWARF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_ELF:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_BLACK_ELF_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_BLACK_ELF_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_GNOME:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_BLACK_GNOME_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_BLACK_GNOME_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALFLING:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_BLACK_HALFLING_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_BLACK_HALFLING_FEMALE;
                    }
                    break;

                case APPEARANCE_TYPE_HALF_ORC_SIZE_BIG://Semiorco grande
                case APPEARANCE_TYPE_HALF_ORC:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_BLACK_HALFORC_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_BLACK_HALFORC_FEMALE;
                    }
                    break;
                case APPEARANCE_TYPE_HUMAN_SIZE_BIG://Humano grande
                case APPEARANCE_TYPE_HALF_ELF:
                case APPEARANCE_TYPE_HUMAN:

                    if(iGender == GENDER_MALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_BLACK_HUMAN_MALE;
                    }
                    else if( iGender == GENDER_FEMALE)
                    {
                        iVFXconstant = IPPVFX_HEAD_EYES_BLACK_HUMAN_FEMALE;
                    }
                    break;

            }
            break;

        }

    }

    return iVFXconstant;

}

void ApplyEyesVFX_DM(object oPC, string sColor)
{

    int iColor = ConvertEyesStringColorConstantToIntColorConstant(sColor);
    int iVFXconstant =  GetCorrectEyeVFXConstantForCharacter(oPC,iColor);
    effect eDMVFX;

    if (!CheckIfHasVisibleHelmet(oPC)) {
        RemoveEyesDMVFX(oPC);
        eDMVFX = EffectVisualEffect(iVFXconstant,FALSE);
        eDMVFX = TagEffect(eDMVFX, EYES_VFX_DM_TAG);
        eDMVFX = UnyieldingEffect(eDMVFX);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDMVFX, oPC);
    }

    GuardarIntPersistente(oPC,EYES_VARIABLE_NAME,iVFXconstant);
}

void ApplyHelmVFX_DM(object oPC, string sHelm)
{


    int iHelm = ConvertHelmStringModelConstantToIntModelConstant(sHelm);
    int iVFXconstant =  GetCorrectHelmVFXConstantForCharacter(oPC,iHelm);
    effect eDMVFX;

    if (!CheckIfHasVisibleHelmet(oPC)) {
        RemoveHelmDMVFX(oPC);

        eDMVFX= EffectVisualEffect(iVFXconstant,FALSE);
        eDMVFX = TagEffect(eDMVFX,HELM_VFX_DM_TAG);
        eDMVFX = UnyieldingEffect(eDMVFX);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eDMVFX,oPC);
    }

    GuardarIntPersistente(oPC,HELM_VARIABLE_NAME,iVFXconstant);
}

void ApplyHornsVFX_DM(object oPC, string sHorn)
{

    int iHorn = ConvertHornsStringModelConstantToIntModelConstant(sHorn);
    int iVFXconstant =  GetCorrectHornsVFXConstantForCharacter(oPC,iHorn);
    effect eDMVFX;

    if (!CheckIfHasVisibleHelmet(oPC)) {
        RemoveHornsDMVFX(oPC);

        eDMVFX= EffectVisualEffect(iVFXconstant,FALSE);
        eDMVFX = TagEffect(eDMVFX,HORNS_VFX_DM_TAG);
        eDMVFX = UnyieldingEffect(eDMVFX);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eDMVFX,oPC);
    }

    GuardarIntPersistente(oPC,HORNS_VARIABLE_NAME,iVFXconstant);
}

void ApplyHairVFX_DM(object oPC, string sHair)
{

    int iHair = ConvertHairStringModelConstantToIntModelConstant(sHair);
    int iVFXconstant = GetCorrectHairVFXConstantForCharacter(oPC,iHair);
    effect eDMVFX;

    if (!CheckIfHasVisibleHelmet(oPC)){
        RemoveHairDMVFX(oPC);

        eDMVFX= EffectVisualEffect(iVFXconstant,FALSE);
        eDMVFX = TagEffect(eDMVFX,HAIR_VFX_DM_TAG);
        eDMVFX = UnyieldingEffect(eDMVFX);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eDMVFX,oPC);
    }

    GuardarIntPersistente(oPC,HAIR_VARIABLE_NAME,iVFXconstant);
}

void LoadAllDMVFX(object oPC)
{
    int iEyes = ObtenerIntPersistente(oPC,EYES_VARIABLE_NAME);
    int iHelm = ObtenerIntPersistente(oPC,HELM_VARIABLE_NAME);
    int iHorns = ObtenerIntPersistente(oPC,HORNS_VARIABLE_NAME);
    int iHair = ObtenerIntPersistente(oPC,HAIR_VARIABLE_NAME);

    effect eDMVFX;

    if (iEyes != 0 && CheckEyesVFXOnCharacter(oPC) == FALSE)
    {
        eDMVFX = EffectVisualEffect(iEyes, FALSE);
        eDMVFX = TagEffect(eDMVFX, EYES_VFX_DM_TAG);
        eDMVFX = UnyieldingEffect(eDMVFX);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDMVFX, oPC);
    }

    if (iHelm != 0 && CheckHelmVFXOnCharacter(oPC) == FALSE)
    {
        eDMVFX = EffectVisualEffect(iHelm,FALSE);
        eDMVFX = TagEffect(eDMVFX, HELM_VFX_DM_TAG);
        eDMVFX = UnyieldingEffect(eDMVFX);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDMVFX, oPC);
    }

    if (iHorns != 0 && CheckHornsVFXOnCharacter(oPC) == FALSE)
    {
        eDMVFX = EffectVisualEffect(iHorns,FALSE);
        eDMVFX = TagEffect(eDMVFX, HORNS_VFX_DM_TAG);
        eDMVFX = UnyieldingEffect(eDMVFX);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDMVFX, oPC);
    }

    if (iHair != 0 && CheckHairVFXOnCharacter(oPC) == FALSE)
    {
        eDMVFX = EffectVisualEffect(iHair,FALSE);
        eDMVFX = TagEffect(eDMVFX, HAIR_VFX_DM_TAG);
        eDMVFX = UnyieldingEffect(eDMVFX);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDMVFX, oPC);
    }
}

void RemoveAllDMVFX(object oPC)
{

    RemoveEyesDMVFX(oPC);
    RemoveHelmDMVFX(oPC);
    RemoveHornsDMVFX(oPC);
    RemoveHairDMVFX(oPC);

}

void OnEquipItemCheckIfHelmAndRemoveDMVFX(object oPC, object oItem)
{
    int iItemType = GetBaseItemType(oItem);

    if (iItemType == BASE_ITEM_HELMET && !GetHiddenWhenEquipped(oItem)) {
        RemoveAllDMVFX(oPC);
    }
}

void OnUnequipItemCheckIfHelmAndApplyDMVFX(object oPC, object oItem)
{
    int iItemType = GetBaseItemType(oItem);

    if (iItemType == BASE_ITEM_HELMET) {

        LoadAllDMVFX(oPC);
    }

}

void OnActivateItemScript(object oUser,object oTarget)
{


    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE || oTarget == OBJECT_INVALID)
    {
        SendMessageToPC(oUser,"No puedes usar este objeto en ese objetivo.");
        return;
    }

    SetLocalObject(oUser,VFX_TARGET,oTarget);

    AssignCommand(oUser, ActionStartConversation(oUser, "dm_vfx",TRUE,FALSE));
}

int CheckIfHasVisibleHelmet(object oPC) {
    object oHelmet = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);

    if (GetIsObjectValid(oHelmet) && !GetHiddenWhenEquipped(oHelmet)) return TRUE;
    else return FALSE;
}
