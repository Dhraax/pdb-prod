//------------------------------------------------------------------------------
//  Libreria para la generacion de objetos miscelaneos, reutilizado codigo de
//  monti.
//  Creado por: cerril
//  Creado el: 10/01/2017
//..............................................................................

#include "pb_tesoro_sorteo"
#include "pb_tesoro_nombre"

//--- Metodos publicos ---------------------------------------------------------
void crearMiscelaneo(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0);
//..............................................................................

void crearMiscelaneo(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0) {
    string sResref;
    string sNombre;
    int bMale;
    int iTirada;
    int nCA;
    int bDote = FALSE;
    int nAbility = 0;
    int nTirada = Random(7);
    if (iAle==FALSE){nTirada = iVal; }

    switch(nTirada) {
        case 0: // Amuletos
            bMale = TRUE;
            switch(Random(15)) {
                case 0:  sResref = "nw_it_mneck00" + IntToString(Random(2)+1); break;
                case 1:  sResref = "nw_it_mneck004"; break;
                case 2:  sResref = "nw_it_mneck00" + IntToString(Random(2)+6); break;
                case 3:  sResref = "nw_it_mneck024"; break;
                case 4:  sResref = "nw_it_mneck030"; break;
                case 5:  sResref = "nw_it_mneck035"; break;
                case 6:  sResref = "x0_it_mneck004"; break;
                case 7:  sResref = "x2_it_mneck001"; break;
                case 8:  sResref = "asy_amuletodrago"; break;
                case 9: sResref = "amuletodebolas1"; break;
                case 10: sResref = "vgz_amutemplo"; break;
                case 11: sResref = "amuletomgicodkal"; break;
                case 12: sResref = "amuletodeinflume"; break;
                case 13: sResref = "collarobsidiana"; break;
                case 14: sResref = "brochedelacapabr"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Amuleto"; break;
                case 2:
                    sNombre = "Cadena enjoyada";
                    bMale = FALSE;
                    break;
                case 3:  sNombre = "Talismán"; break;
                case 4:  sNombre = "Collar místico"; break;
                case 5:  sNombre = "Fetiche chamánico"; break;
                case 6:  sNombre = "Cordel de huesos"; break;
            }
            nCA = 70;  //90
            nAbility = 30; //70
            bDote = TRUE;
            break;
        case 1: // Anillos
            bMale = TRUE;
            switch(Random(19)) {
                case 0:  sResref = "nw_it_mring006"; break;
                case 1:  sResref = "nw_it_mring024"; break;
                case 2:  sResref = "nw_it_mring001"; break;
                case 3:  sResref = "nw_it_mring031"; break;
                case 4:  sResref = "nw_it_mring023"; break;
                case 5:  sResref = "x0_it_mring001"; break;
                case 6:  sResref = "nw_it_mring005"; break;
                case 7:  sResref = "x2_nash_ring"; break;
                case 8:  sResref = "x2_it_mring009"; break;
                case 9: sResref = "nw_it_novel001"; break;
                case 10: sResref = "anillodecusto002"; break;
                case 11: sResref = "anillodivinoma"; break;
                case 12: sResref = "smbolosagradotal"; break;
                case 13: sResref = "smbolosagradohel"; break;
                case 14: sResref = "anillodelasesipi"; break;
                case 15: sResref = "anillodecristal"; break;
                case 16: sResref = "anillodeacuida"; break;
                case 17: sResref = "anilloantivene"; break;
                case 18: sResref = "dedosagiles"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Anillo"; break;
                case 2:  sNombre = "Aro perfecto"; break;
                case 3:  sNombre = "Arete pequeño"; break;
                case 4:
                    sNombre = "Sortija divina";
                    bMale = FALSE;
                    break;
                case 5:
                    sNombre = "Argolla de hueso";
                    bMale = FALSE;
                    break;
                case 6:  sNombre = "Círculo chamánico"; break;
            }
            nCA = 30;  //50
            nAbility = 40;//70
            bDote = TRUE;
            break;
        case 2: // Botas
            bMale = FALSE;
            switch(d10()) {
                case 1:  sResref = "nw_it_mboots015"; break;
                case 2:  sResref = "nw_it_mboots010"; break;
                case 3:  sResref = "nw_it_mboots018"; break;
                case 4:  sResref = "x0_it_mboots001"; break;
                case 5:  sResref = "x1_it_mboots001"; break;
                case 6:  sResref = "nw_it_mboots00" + IntToString(Random(3)+1); break;
                case 7:  sResref = "saltarinas"; break;
                case 8:  sResref = "vgz_botaskossut"; break;
                case 9:  sResref = "_botasdelabuele2"; break;
                case 10: sResref = "pasofranco"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Botas"; break;
                case 2:  sNombre = "Gracia felina"; break;
                case 3:  sNombre = "Puntillas"; break;
                case 4:
                    sNombre = "Paso ligero";
                    bMale = TRUE;
                    break;
                case 5:
                    sNombre = "Sin rastro";
                    bMale = TRUE;
                    break;
                case 6:
                    sNombre = "Zapatos de cuero";
                    bMale = TRUE;
                    break;
            }
            nCA = 80;
            nAbility = 10;
            break;
        case 3: // Brazales
            bMale = TRUE;
            switch(d6()) {
                case 1:  sResref = "x0_it_mbracer001"; break;
                case 2:  sResref = "nw_it_mbracer00" + IntToString(Random(2)+1); break;
                case 3:  sResref = "bracersofk"; break;
                case 4:  sResref = "brazalesmalditos"; break;
                case 5:  sResref = "dreadbond"; break;
                case 6:  sResref = "magusguard"; break;
            }

            switch(d6()) {
                case 1:
                    sNombre = "Pulseras de la suerte";
                    bMale = FALSE;
                    break;
                case 2:  sNombre = "Brazaletes"; break;
                case 3:
                    sNombre = "Banda de Máscara";
                    bMale = FALSE;
                    break;
                case 4:  sNombre = "Bracil de la fe"; break;
                case 5:
                    sNombre = "Cinta oscura";
                    bMale = FALSE;
                    break;
                case 6:  sNombre = "Escudo de mano"; break;
            }
            nCA = 20;//0
            nAbility = 40; //70
            break;
        case 4: // Capas
            bMale = FALSE;
            switch(d8()) {
                case 1:  sResref = "zep_cloak"; break;
                case 2:  sResref = "zep_cloak001"; break;
                case 3:  sResref = "zep_cloak00" + IntToString(Random(7)+3); break;
                case 4:  sResref = "nw_maarcl0" + IntToString(Random(4)+88); break;
                case 5:  sResref = "nw_maarcl09" + IntToString(Random(4)+2); break;
                case 6:  sResref = "x0_maarcl02" + IntToString(Random(5)+5); break;
                case 7:  sResref = "nw_maarcl10" + IntToString(Random(3)+4); break;
                case 8:  sResref = "nw_maarcl09" + IntToString(Random(4)+6); break;
            }

            switch(d6()) {
                case 1:  sNombre = "Capa de tela"; break;
                case 2:
                    sNombre = "Manto de cuero";
                    bMale = TRUE;
                    break;
                case 3:  sNombre = "Capa reforzada"; break;
                case 4:  sNombre = "Toga de protección"; break;
                case 5:  sNombre = "Vestimentas de paladín"; break;
                case 6:
                    sNombre = "Manto del bufón";
                    bMale = TRUE;
                    break;
            }
            nCA = 20;//0
            nAbility = 40;//70
            break;
        case 5: // Cinturones
            bMale = TRUE;
            iTirada = Random(40)+1;

            if(iTirada <= 30) sResref = "loot_cintoesc" + IntToString(Random(4)+1);
            else if(iTirada == 31) sResref = "nw_it_mbelt010";
            else if(iTirada == 32) sResref = "nw_it_mbelt018";
            else if(iTirada == 33) sResref = "x0_it_mbelt002";
            else if(iTirada == 34) sResref = "x2_it_mbelt002";
            else if(iTirada == 35) sResref = "nw_it_mbelt00" + IntToString(Random(4)+3);
            else if(iTirada == 36) sResref = "cintodeurnst";
            else if(iTirada == 37) sResref = "cinturndefuertma";
            else if(iTirada == 38) sResref = "cinturndehechice";
            else if(iTirada == 39) sResref = "destructordelasc";
            else                   sResref = "fajnbendito";

            switch(d6()) {
                case 1:  sNombre = "Cinturón"; break;
                case 2:  sNombre = "Cinturón grueso"; break;
                case 3:  sNombre = "Cinto bárbaro"; break;
                case 4:  sNombre = "Tahalí protector"; break;
                case 5:  sNombre = "Fajín deflector"; break;
                case 6:
                    sNombre = "Abrazadera de cuero";
                    bMale = FALSE;
                    break;
            }
            nCA = 50;
            break;
        case 6: // Yelmos
            bMale = TRUE;
            switch(d12()) {
                case 1:  sResref = "zep_hlmcorm_001"; break;
                case 2:  sResref = "zep_chitinhelm"; break;
                case 3:  sResref = "nw_arhe005"; break;
                case 4:  sResref = "zep_shadowhood"; break;
                case 5:  sResref = "zep_thayvian"; break;
                case 6:  sResref = "zep_wingedhelm"; break;
                case 7:  sResref = "x2_arduerhe001"; break;
                case 8:  sResref = "x2_it_adahelm"; break;
                case 9:  sResref = "nw_arhe002"; break;
                case 10: sResref = "x3_it_pdhelmet"; break;
                case 11: sResref = "x2_helm_00" + IntToString(Random(2)+1); break;
                case 12: sResref = "x2_it_arhelm01"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Yelmo"; break;
                case 2:
                    sNombre = "Vanguardia";
                    bMale = FALSE;
                    break;
                case 3:  sNombre = "Casquete de ballestero"; break;
                case 4:  sNombre = "Casco agrietado"; break;
                case 5:  sNombre = "Morrión emplumado"; break;
                case 6:
                    sNombre = "Defensa aérea";
                    bMale = FALSE;
                    break;
            }
            nCA = 60; //90
            break;
    }

    object oCreado = CreateItemOnObject(sResref, oTarget);
    SetDroppableFlag(oCreado, TRUE);
    SetItemCursedFlag(oCreado, FALSE);
    SetIdentified(oCreado, TRUE);
    SetStolenFlag(oCreado, TRUE);
    SetPlotFlag(oCreado, FALSE);

    //Comprobamos si es parte del set
    int IsKitSet = Random(100);
    string NuevoNombre;
    if(nDG >= 30 && IsKitSet <= 1 && iTienda == FALSE)
    {
     //SendMessageToAllDMs("¡Pieza de Set generada!");
     switch(Random(10))
             {
             case 0: //Set Celestial
                       SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos de luz fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto angelical.");
                       SetLocalInt(oCreado, "Kit_Celestial", 1);
                       NuevoNombre = rgbColor(sNombre+" Celestial", 255, 255, 204);
                       SetName(oCreado, NuevoNombre);
                       break;
             case 1: //Set Infernal
                       SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos oscuros fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto oscuro.");
                       SetLocalInt(oCreado, "Kit_Infernal", 1);
                       NuevoNombre = rgbColor(sNombre+" Infernal", 255, 0, 0);
                       SetName(oCreado, NuevoNombre);
                       break;
             case 2: //Set Nirvana
                       SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos naturales fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto ancestral.");
                       SetLocalInt(oCreado, "Kit_Nirvana", 1);
                       NuevoNombre = rgbColor(sNombre+" del Nirvana", 0, 200, 0);
                       SetName(oCreado, NuevoNombre);
                       break;
            case 3: //Set Del camino
                       SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto ancestral.");
                       SetLocalInt(oCreado, "Kit_Camino", 1);
                       NuevoNombre = rgbColor(sNombre+" del Camino", 100, 0, 0);
                       SetName(oCreado, NuevoNombre);
                       break;
            case 4: //Set Artifice
                       SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto ancestral.");
                       SetLocalInt(oCreado, "Kit_Artifice", 1);
                       NuevoNombre = rgbColor(sNombre+" del Artifice", 100, 0, 0);
                       SetName(oCreado, NuevoNombre);
                       break;
            case 5: //Set Gigante
                       SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto ancestral.");
                       SetLocalInt(oCreado, "Kit_Gigante", 1);
                       NuevoNombre = rgbColor(sNombre+" del Gigante", 100, 0, 0);
                       SetName(oCreado, NuevoNombre);
                       break;
            case 6: //Set Vara Negra
                       SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto ancestral.");
                       SetLocalInt(oCreado, "Kit_Varanegra", 1);
                       NuevoNombre = rgbColor(sNombre+" de VaraNegra", 25, 0, 0);
                       SetName(oCreado, NuevoNombre);
                       break;
            case 7: //Set Loco
                       SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto ancestral.");
                       SetLocalInt(oCreado, "Kit_Loco", 1);
                       NuevoNombre = rgbColor(sNombre+" del Loco", 255, 0, 0);
                       SetName(oCreado, NuevoNombre);
                       break;
            case 8: //Set Rey Inmortal
                       SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto ancestral.");
                       SetLocalInt(oCreado, "Kit_Inmortal", 1);
                       NuevoNombre = rgbColor(sNombre+" del Inmortal", 255, 0, 0);
                       SetName(oCreado, NuevoNombre);
                       break;
            case 9: //Set Deber de Tierra
                       SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto ancestral.");
                       SetLocalInt(oCreado, "Kit_Tierra", 1);
                       NuevoNombre = rgbColor(sNombre+" de la Tierra", 255, 0, 0);
                       SetName(oCreado, NuevoNombre);
                       break;
             }
    }

    else
    {
        sNombre = nombrarObjeto(sNombre, nDG, bMale);
        SetName(oCreado, sNombre);
        SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos, pero no lleva el sello de ningún fabricante. Su historia y leyenda son aparentemente desconocidas, sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto mágico.");
    }

    limpiarObjeto(oCreado);
    sorteoMiscelaneas(oCreado, nDG, nCA, nAbility, bDote);
    if (iTienda==TRUE){SetIdentified(oCreado, TRUE);} else {SetIdentified(oCreado, FALSE);}
    SetLocalInt(oCreado, "PCItem", 1);

}

