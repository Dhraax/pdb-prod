#include "x2_inc_craft"

//------------------------------------------------------------------------------
//  Libreria para la generacion de pergaminos.
//  Creado por: cerril
//  Creado el: 10/01/2017
//..............................................................................

//--- Metodos publicos ---------------------------------------------------------

//Extraemos el ID del conjuro a partir de una propiedad "lanzar conjuro".
int iConjuro (object oObjetivo);
int iConjuro (object oObjetivo)
{
    int iSpell;
    itemproperty iSpellProperty = GetFirstItemProperty(oObjetivo);
    while (GetIsItemPropertyValid(iSpellProperty))
    {
        if (GetItemPropertyType(iSpellProperty) == ITEM_PROPERTY_CAST_SPELL)
        {
            iSpell = StringToInt(Get2DAString("iprp_spells","SpellIndex",GetItemPropertySubType(iSpellProperty)));
        }
        iSpellProperty = GetNextItemProperty(oObjetivo);
    }
    return iSpell;
}



//Metodo para dar un numero determinado de pergaminos dependiendo de los DG que
//posea la criatura
void addScroll(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=1);
//..............................................................................

//Metodo privado para sortear un pergamino
string getScroll(object oTarget, int nSpellLevel) {
    string sResref;

    switch(nSpellLevel){
        case 0:
            switch(Random(13)+1) {
                case 1:  sResref = "x1_it_sparscr002";break;
                case 2:  sResref = "x2_it_spdvscr001";break;
                case 3:  sResref = "nw_it_sparscr003";break;
                case 4:  sResref = "x1_it_sparscr003";break;
                case 5:  sResref = "x1_it_sparscr001";break;
                case 6:  sResref = "x1_it_spdvscr001";break;
                case 7:  sResref = "nw_it_sparscr004";break;
                case 8:  sResref = "nw_it_sparscr002";break;
                case 9:  sResref = "nw_it_sparscr001";break;
                case 10: sResref = "x2_it_spdvscr002";break;
                case 11: sResref = "perga_creagu3";break;
                case 12: sResref = "perga_agarre";break;
                case 13: sResref = "perga_crealla";break;
            }
            break;
        case 1:
            switch(Random(56)+1) {
                case 1:  sResref = "x2_it_spdvscr102";break; // Bendecir arma
                case 2:  sResref = "x2_it_spdvscr101";break; // Tañido ensordecedor
                case 3:  sResref = "x1_it_sparscr104";break; // Impacto verdadero
                case 4:  sResref = "x2_it_spdvscr103";break;
                case 5:  sResref = "nw_it_sparscr112";break;
                case 6:  sResref = "x1_it_spdvscr107";break;
                case 7:  sResref = "nw_it_sparscr107";break;
                case 8:  sResref = "nw_it_sparscr110";break;
                case 9:  sResref = "x2_it_spdvscr104";break;
                case 10: sResref = "x1_it_sparscr102";break;
                case 11: sResref = "x1_it_spdvscr102";break;
                case 12: sResref = "x2_it_spdvscr105";break;
                case 13: sResref = "x2_it_spdvscr106";break;
                case 14: sResref = "x1_it_spdvscr103";break;
                case 15: sResref = "x1_it_sparscr101";break;
                case 16: sResref = "nw_it_sparscr103";break;
                case 17: sResref = "x2_it_sparscr101";break;
                case 18: sResref = "x2_it_sparscr104";break;
                case 19: sResref = "nw_it_sparscr106";break;
                case 20: sResref = "x1_it_spdvscr104";break;
                case 21: sResref = "x2_it_sparscr102";break;
                case 22: sResref = "nw_it_sparscr218";break;
                case 23: sResref = "nw_it_sparscr104";break;
                case 24: sResref = "x1_it_spdvscr106";break;
                case 25: sResref = "nw_it_sparscr109";break;
                case 26: sResref = "x2_it_sparscr105";break;
                case 27: sResref = "nw_it_sparscr113";break;
                case 28: sResref = "nw_it_sparscr102";break;
                case 29: sResref = "x2_it_sparscral";break;
                case 30: sResref = "nw_it_sparscr111";break;
                case 31: sResref = "x2_it_spdvscr107";break;
                case 32: sResref = "x2_it_spdvscr108";break;
                case 33: sResref = "nw_it_sparscr210";break;
                case 34: sResref = "x2_it_sparscr103";break;
                case 35: sResref = "x1_it_sparscr103";break;
                case 36: sResref = "x1_it_spdvscr105";break;
                case 37: sResref = "nw_it_sparscr108";break;
                case 38: sResref = "nw_it_sparscr105";break;
                case 39: sResref = "x1_it_spdvscr101";break;
                case 40: sResref = "perga_lacidorb2";break;
                case 41: sResref = "perga_lcoldorb2";break;
                case 42: sResref = "perga_lelecorb2";break;
                case 43: sResref = "perga_lfireorb2";break;
                case 44: sResref = "perga_lsonicorb2";break;
                case 45: sResref = "perga_benitrans2";break;
                case 46: sResref = "perga_detmue2";break;
                case 47: sResref = "perga_psinrastr2";break;
                case 48: sResref = "perga_salto2";break;
                case 49: sResref = "perga_cmpidioma2";break;
                case 50: sResref = "perga_fuegofee2";break;
                case 51: sResref = "perga_detali2";break;
                case 52: sResref = "perga_nieblaobs2";break;
                case 53: sResref = "perga_disfrazar2";break;
                case 54: sResref = "perga_armafee";break;
                case 55: sResref = "perga_armacaza";break;
                case 56: sResref = "perga_armamal";break;
            }
            break;
        case 2:
            switch(Random(52)+1) {
                case 1:  sResref = "x2_it_sparscr205";break; // Arma flamigera
                case 2:  sResref = "x1_it_spdvscr204";break;
                case 3:  sResref = "x1_it_sparscr201";break;
                case 4:  sResref = "x2_it_spdvscr202";break;
                case 5:  sResref = "nw_it_sparscr211";break;
                case 6:  sResref = "x1_it_spdvscr202";break;
                case 7:  sResref = "nw_it_sparscr212";break;
                case 8:  sResref = "nw_it_sparscr213";break;
                case 9:  sResref = "x2_it_sparscr207";break;
                case 10: sResref = "nw_it_spdvscr202";break;
                case 11: sResref = "nw_it_sparscr217";break;
                case 12: sResref = "x2_it_sparscr206";break;
                case 13: sResref = "x2_it_sparscr201";break;
                case 14: sResref = "x2_it_spdvscr203";break;
                case 15: sResref = "nw_it_sparscr206";break;
                case 16: sResref = "x2_it_sparscr202";break;
                case 17: sResref = "nw_it_sparscr219";break;
                case 18: sResref = "nw_it_sparscr215";break;
                case 19: sResref = "nw_it_sparscr101";break;
                case 20: sResref = "x2_it_sparscr305";break;
                case 21: sResref = "x1_it_spdvscr205";break;
                case 22: sResref = "x2_it_spdvscr201";break;
                case 23: sResref = "nw_it_sparscr220";break;
                case 24: sResref = "x2_it_sparscr203";break;
                case 25: sResref = "nw_it_sparscr208";break;
                case 26: sResref = "nw_it_sparscr209";break;
                case 27: sResref = "x2_it_spdvscr204";break;
                case 28: sResref = "nw_it_sparscr308";break;
                case 29: sResref = "x1_it_spdvscr201";break;
                case 30: sResref = "nw_it_sparscr207";break;
                case 31: sResref = "nw_it_sparscr216";break;
                case 32: sResref = "nw_it_spdvscr201";break;
                case 33: sResref = "nw_it_sparscr202";break;
                case 34: sResref = "x1_it_spdvscr203";break;
                case 35: sResref = "nw_it_sparscr221";break;
                case 36: sResref = "nw_it_sparscr303";break;
                case 37: sResref = "x2_it_spdvscr205";break;
                case 38: sResref = "nw_it_sparscr201";break;
                case 39: sResref = "nw_it_sparscr205";break;
                case 40: sResref = "nw_it_spdvscr203";break;
                case 41: sResref = "nw_it_spdvscr204";break;
                case 42: sResref = "x2_it_sparscr204";break;
                case 43: sResref = "nw_it_sparscr203";break;
                case 44: sResref = "x1_it_sparscr202";break;
                case 45: sResref = "nw_it_sparscr214";break;
                case 46: sResref = "nw_it_sparscr204";break;
                case 47: sResref = "perga_baletrans3";break;
                case 48: sResref = "perga_agnazscor3";break;
                case 49: sResref = "perga_heroism3";break;
                case 50: sResref = "perga_aliind3";break;
                case 51: sResref = "perga_treparacn3";break;
                case 52: sResref = "perga_falsavida3";break;
            }
            break;
        case 3:
            switch(Random(52)+1) {
                case 1:  sResref = "x2_it_sparscr303";break; // Afiladura
                case 2:  sResref = "x2_it_sparscr304";break; // Arma magica mayor
                case 3:  sResref = "x2_it_spdvscr305";break; // Fuego oscuro
                case 4:  sResref = "x2_it_spdvscr303";break; // Hoja sedienta
                case 5:  sResref = "nw_it_sparscr405";break;
                case 6:  sResref = "nw_it_sparscr307";break;
                case 7:  sResref = "nw_it_sparscr406";break;
                case 8:  sResref = "nw_it_sparscr411";break;
                case 9:  sResref = "x1_it_spdvscr301";break;
                case 10: sResref = "nw_it_sparscr509";break;
                case 11: sResref = "nw_it_sparscr301";break;
                case 12: sResref = "x1_it_sparscr301";break;
                case 13: sResref = "x2_it_spdvscr309";break;
                case 14: sResref = "nw_it_sparscr413";break;
                case 15: sResref = "nw_it_sparscr309";break;
                case 16: sResref = "nw_it_sparscr304";break;
                case 17: sResref = "x2_it_spdvscr306";break;
                case 18: sResref = "x1_it_spdvscr303";break;
                case 19: sResref = "nw_it_sparscr414";break;
                case 20: sResref = "x1_it_sparscr303";break;
                case 21: sResref = "nw_it_sparscr312";break;
                case 22: sResref = "x2_it_spdvscr302";break;
                case 23: sResref = "x2_it_spdvscr301";break;
                case 24: sResref = "x1_it_spdvscr302";break;
                case 25: sResref = "x2_it_spdvscr310";break;
                case 26: sResref = "nw_it_sparscr314";break;
                case 27: sResref = "x2_it_spdvscr307";break;
                case 28: sResref = "nw_it_sparscr310";break;
                case 29: sResref = "nw_it_sparscr302";break;
                case 30: sResref = "x2_it_sparscrmc";break;
                case 31: sResref = "x2_it_spdvscr304";break;
                case 32: sResref = "x2_it_sparscr301";break;
                case 33: sResref = "nw_it_sparscr315";break;
                case 34: sResref = "x2_it_spdvscr311";break;
                case 35: sResref = "nw_it_spdvscr402";break;
                case 36: sResref = "x2_it_spdvscr407";break;
                case 37: sResref = "x2_it_spdvscr312";break;
                case 38: sResref = "x1_it_spdvscr305";break;
                case 39: sResref = "nw_it_spdvscr301";break;
                case 40: sResref = "nw_it_sparscr402";break;
                case 41: sResref = "nw_it_spdvscr302";break;
                case 42: sResref = "x2_it_sparscr302";break;
                case 43: sResref = "x2_it_spdvscr313";break;
                case 44: sResref = "nw_it_sparscr313";break;
                case 45: sResref = "x1_it_spdvscr304";break;
                case 46: sResref = "nw_it_sparscr305";break;
                case 47: sResref = "nw_it_sparscr306";break;
                case 48: sResref = "nw_it_sparscr311";break;
                case 49: sResref = "x1_it_sparscr302";break;
                case 50: sResref = "perga_volar5";break;
                case 51: sResref = "perga_suenyopro5";break;
                case 52: sResref = "perga_crecomagu5";break;
            }
            break;
        case 4:
            switch(Random(40)+1) {
                case 1:  sResref = "perga_zancada7";break;   // Zancada arborea
                case 2:  sResref = "perga_puertadim7";break; // Puerta dimensional
                case 3:  sResref = "x2_it_spdvscr401";break; // Espada sagrada
                case 4:  sResref = "nw_it_sparscr501";break;
                case 5:  sResref = "x2_it_spdvscr404";break;
                case 6:  sResref = "nw_it_sparscr503";break;
                case 7:  sResref = "nw_it_sparscr416";break;
                case 8:  sResref = "nw_it_sparscr412";break;
                case 9:  sResref = "nw_it_sparscr418";break;
                case 10: sResref = "x1_it_spdvscr403";break;
                case 11: sResref = "x2_it_spdvscr405";break;
                case 12: sResref = "x2_it_spdvscr406";break;
                case 13: sResref = "nw_it_sparscr505";break;
                case 14: sResref = "x2_it_spdvscr402";break;
                case 15: sResref = "x2_it_sparscr401";break;
                case 16: sResref = "nw_it_sparscr408";break;
                case 17: sResref = "x1_it_spdvscr401";break;
                case 18: sResref = "x1_it_sparscr401";break;
                case 19: sResref = "nw_it_sparscr417";break;
                case 20: sResref = "x1_it_spdvscr402";break;
                case 21: sResref = "nw_it_sparscr401";break;
                case 22: sResref = "nw_it_sparscr409";break;
                case 23: sResref = "nw_it_sparscr415";break;
                case 24: sResref = "nw_it_spdvscr401";break;
                case 25: sResref = "nw_it_sparscr410";break;
                case 26: sResref = "nw_it_sparscr403";break;
                case 27: sResref = "nw_it_sparscr404";break;
                case 28: sResref = "nw_it_sparscr407";break;
                case 29: sResref = "perga_ancdim7";break;
                case 30: sResref = "x2_it_spdvscr308";break;
                case 31: sResref = "perga_acidorb7";break;
                case 32: sResref = "perga_coldorb7";break;
                case 33: sResref = "perga_elecorb7";break;
                case 34: sResref = "perga_fireorb7";break;
                case 35: sResref = "perga_sonicorb7";break;
                case 36: sResref = "perga_multra7";break;
                case 37: sResref = "x2_it_spdvscr403";break;
                case 38: sResref = "perga_espaanti";break;
                case 39: sResref = "perga_espasacr";break;
                case 40: sResref = "perga_armaveng";break;
            }
            break;
        case 5:
            switch(Random(31)+1) {
                case 1:  sResref = "perga_teleport9";break;  // Teleportar
                case 2:  sResref = "nw_it_spdvscr501";break; // Revivir a los muertos
                case 3:  sResref = "nw_it_sparscr606";break; // Visión verdadera
                case 4:  sResref = "x2_it_spdvscr504";break;
                case 5:  sResref = "nw_it_sparscr502";break;
                case 6:  sResref = "nw_it_sparscr507";break;
                case 7:  sResref = "x2_it_sparscr503";break;
                case 8:  sResref = "nw_it_sparscr608";break;
                case 9:  sResref = "x2_it_spdvscr509";break;
                case 10: sResref = "nw_it_sparscr504";break;
                case 11: sResref = "x1_it_sparscr501";break;
                case 12: sResref = "nw_it_sparscr508";break;
                case 13: sResref = "x2_it_spdvscr505";break;
                case 14: sResref = "x1_it_spdvscr501";break;
                case 15: sResref = "nw_it_sparscr511";break;
                case 16: sResref = "nw_it_sparscr512";break;
                case 17: sResref = "nw_it_sparscr513";break;
                case 18: sResref = "x2_it_sparscr502";break;
                case 19: sResref = "nw_it_sparscr506";break;
                case 20: sResref = "x2_it_spdvscr502";break;
                case 21: sResref = "x1_it_spdvscr502";break;
                case 22: sResref = "x2_it_sparscr501";break;
                case 23: sResref = "x2_it_spdvscr506";break;
                case 24: sResref = "x2_it_spdvscr507";break;
                case 25: sResref = "nw_it_sparscr510";break;
                case 26: sResref = "x2_it_spdvscr501";break;
                case 27: sResref = "x2_it_spdvscr503";break;
                case 28: sResref = "x1_it_sparscr502";break;
                case 29: sResref = "perga_mcurelit9";break;
                case 30: sResref = "perga_inflgtwm9";break;
                case 31: sResref = "perga_gheroism9";break;
            }
            break;
        case 6:
        case 7:
        case 8:
        case 9:
    }
    return sResref;
}

void addScroll(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=1) {
    int nCantidad = 0;
    string sResref;
    int nLevel;

    if(nDG <= 9) {
        nCantidad = 0;
    } else if(nDG <= 19) {
        nCantidad = 2;
    } else if(nDG <= 29) {
        nCantidad = d4(1) + 1;
    } else if(nDG <= 39) {
        nCantidad = d4(1) + 2;
    } else {
        nCantidad = d4(2) + 1;
    }
    if (iAle==FALSE){nCantidad = iVal; }
    while(nCantidad > 0) {
        //Sorteamos un pergamino en funcion de los DG de la criatura.
        if(nDG <= 9) {

            sResref = getScroll(oTarget, 0);
        } else if(nDG <= 19) {
            sResref = getScroll(oTarget, d2(1));
        } else if(nDG <= 29) {
            sResref = getScroll(oTarget, d4(1));
        } else if(nDG <= 39) {
            sResref = getScroll(oTarget, d3(1)+2);
        } else {
            sResref = getScroll(oTarget, d2(1)+3);
        }

        object oPergamino = CreateItemOnObject(sResref, oTarget);
        SetDroppableFlag(oPergamino, TRUE);
        SetPlotFlag(oPergamino, FALSE);
        SetIdentified(oPergamino, FALSE);
        if (iTienda==TRUE){SetIdentified(oPergamino, TRUE);}
        SetLocalInt(oPergamino, "PCItem", 1);
        //Añadimos las clases que lo puedan usar.
        int iSpell = iConjuro(oPergamino);
        AplicarRestriccionesClaseas(oPergamino, iSpell);
        nCantidad--;
    }
}

//void main(){}
