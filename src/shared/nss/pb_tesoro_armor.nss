//------------------------------------------------------------------------------
//  Libreria para la generacion de armaduras, reutilizado código de Monti.
//  Creado por: cerril
//  Creado el: 10/01/2017
//  Modificado por: Kronos.
//  Modificación: 29/03/2019.
//..............................................................................

#include "pb_tesoro_sorteo"
#include "pb_tesoro_nombre"

#include "cnr_i_loot"
//--- Metodos publicos ---------------------------------------------------------
void crearArmadura(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0);
//..............................................................................

void crearArmadura(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0) {
    string sResref;
    string sNombre;
    int bMale;
    int nTirada = Random(4);
    if (iAle==FALSE){nTirada = iVal; }

    switch(nTirada) {
        case 0: // Armadura (Ropas)
            bMale = FALSE;
            switch(d10()) {
                case 1:  sResref = "x2_cus_robe1"; break;
                case 2:  sResref = "nw_mcloth017"; break;
                case 3:  sResref = "nw_mcloth015"; break;
                case 4:  sResref = "x2_it_pmrobe"; break;
                case 5:  sResref = "x3_it_robeeyes"; break;
                case 6:  sResref = "x2_cus_lastwords"; break;
                case 7:  sResref = "kimonodecombat"; break;
                case 8:  sResref = "nw_mcloth009"; break;
                case 9:  sResref = "nw_mcloth006"; break;
                case 10: sResref = "nw_cloth020"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Ropas"; break;
                case 2:  sNombre = "Túnica cómoda"; break;
                case 3:
                    sNombre = "Atuendos";
                    bMale = TRUE;
                    break;
                case 4:  sNombre = "Vestimentas arcanas"; break;
                case 5:
                    sNombre = "Ajuar felino";
                    bMale = TRUE;
                    break;
                case 6:
                    sNombre = "Ropaje maldito";
                    bMale = TRUE;
                    break;
            }
            break;
        case 1: // Armadura (Ligera)
            bMale = FALSE;
            switch(Random(17)) {
                case 0:  sResref = "nw_maarcl00" + IntToString(Random(2)+1); break;
                case 1:  sResref = "nw_maarcl007"; break;
                case 2:  sResref = "nw_maarcl04" + IntToString(Random(4)+3); break;
                case 3:  sResref = "nw_maarcl067"; break;
                case 4:  sResref = "nw_maarcl07" + IntToString(Random(2)+1); break;
                case 5:  sResref = "nw_maarcl075"; break;
                case 6:  sResref = "nw_maarcl079"; break;
                case 7:  sResref = "nw_maarcl08" + IntToString(Random(2)+3); break;
                case 8:  sResref = "nw_maarcl087"; break;
                case 9: sResref = "x0_maarcl00" + IntToString(Random(6)+1); break;
                case 10: sResref = "x0_maarcl009"; break;
                case 11: sResref = "x2_maarcl02" + IntToString(Random(5)+5); break;
                case 12: sResref = "x2_maarcl03" + IntToString(Random(2)+3); break;
                case 13: sResref = "x2_cus_bindingso"; break;
                case 14: sResref = "x2_cus_fletchers"; break;
                case 15: sResref = "zep_barbarianfur"; break;
                case 16: sResref = "zep_studdedleath"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Armadura de las sombras"; break;
                case 2:  sNombre = "Armadura élfica"; break;
                case 3:
                    sNombre = "Cueros de ladrón";
                    bMale = TRUE;
                    break;
                case 4:
                    sNombre = "Piel de oso";
                    bMale = TRUE;
                    break;
                case 5:  sNombre = "Vestimenta de bárbaro"; break;
                case 6:
                    sNombre = "Equilibrio de la naturaleza";
                    bMale = TRUE;
                    break;
            }
            break;
        case 2: // Armadura (Intermedia)
            bMale = FALSE;
            /*switch(Random(31)) {

                case 0: sResref = "nw_aarcl00" + IntToString(Random(2)+3); break;  //03,04
                case 1:  sResref = "aarcl004"; break;
                case 2:  sResref = "aarcl005"; break;
                case 3:  sResref = "aarcl013"; break;
                case 4:  sResref = "maarcl008"; break;
                case 5:  sResref = "maarcl009"; break;
                case 6:  sResref = "maarcl01" + IntToString(Random(7)+1); break; //11,12,13,14,15,16,17
                case 7:  sResref = "maarcl03" + IntToString(Random(2)+2) ; break; //32,33
                case 8:  sResref = "maarcl03" + IntToString(Random(2)+6) ; break; //36,37
                case 9:  sResref = "maarcl039"; break;
                case 10:  sResref = "maarcl040"; break;
                case 11:  sResref = "maarcl041"; break;
                case 12:  sResref = "maarcl04" + IntToString(Random(2)+8); break; //48,49
                case 13:  sResref = "maarcl050"; break;
                case 14:  sResref = "maarcl051"; break;
                case 15:  sResref = "maarcl059"; break;
                case 16:  sResref = "maarcl062"; break;
                case 17:  sResref = "maarcl06" + IntToString(Random(2)+6); break;  //66,67
                case 18:  sResref = "maarcl071"; break;
                case 19: sResref = "maarcl074"; break;
                case 20: sResref = "maarcl07" + IntToString(Random(2)+8); break;//78,79
                case 21: sResref = "maarcl083"; break;
                case 22: sResref = "maarcl086"; break;
                case 23: sResref = "mdrowar01" + IntToString(Random(4)+6); break; //16,17,18,19
                case 24: sResref = "mdrowar020"; break;
                case 25: sResref = "mdrowar02" + IntToString(Random(9)+1); break;  //21,22,23,24,25,26,27,28,29
                case 26: sResref = "mduerar00" + IntToString(Random(3)+5); break;//05,06,07
                case 27: sResref = "it_adachain001"; break;
                case 28: sResref = "armor_002"; break;
                case 29: sResref = "armor_004"; break;
                case 30: sResref = "it_mithralch001"; break;
                //case 17: sResref = "zep_chainbikini"; break;
                //case 18: sResref = "zep_aecm_001"; break;
                //case 19: sResref = "zep_chain"; break;
                //case 20: sResref = "zep_druidarmor"; break;
                //case 21: sResref = "zep_lamellar"; break;
                //case 22: sResref = "zep_tieflingchn"; break;

            }*/
            switch(Random(32)) {

                case 0: sResref = "nw_aarcl00" + IntToString(Random(2)+3); break;  //03,04
                case 1: sResref = "nw_aarcl008"; break;
                case 2: sResref = "nw_aarcl010"; break;
                case 3: sResref = "nw_maarcl010"; break;
                case 4: sResref = "nw_maarcl01" + IntToString(Random(3)+4); break; //14,15,16
                case 5:  sResref = "nw_maarcl03" + IntToString(Random(3)+5) ; break; //35,36,37
                case 6: sResref = "nw_maarcl039"; break;
                case 7: sResref = "nw_maarcl040"; break;
                case 8:  sResref = "nw_maarcl04" + IntToString(Random(3)+7); break; //47,48,49
                case 9: sResref = "nw_maarcl058"; break;
                case 10: sResref = "nw_maarcl061"; break;
                case 11:  sResref = "nw_maarcl06" + IntToString(Random(2)+5); break;  //65,66
                case 12:  sResref = "nw_maarcl070"; break;
                case 13:  sResref = "nw_maarcl073"; break;
                case 14:  sResref = "nw_maarcl07" + IntToString(Random(2)+7); break;  //77,78
                case 15:  sResref = "nw_maarcl082"; break;
                case 16:  sResref = "nw_maarcl085"; break;
                case 17:  sResref = "x0_maarcl00" + IntToString(Random(2)+7); break; //07,08
                case 18:  sResref = "x0_maarcl01" + IntToString(Random(6)+1); break;  //11,12,13,14,15,16
                case 19: sResref = "x2_maarcl03" + IntToString(Random(2)+1); break; //31,32
                case 20: sResref = "x2_maarcl03" + IntToString(Random(5)+5); break; //35,36,37,38,39
                case 21: sResref = "x2_maarcl040"; break;
                case 22: sResref = "x2_maarcl049"; break;
                case 23: sResref = "x2_maarcl050"; break;
                case 24: sResref = "x2_mdrowar01" + IntToString(Random(5)+5); break;  //15,16,17,18,19
                case 25: sResref = "x2_mdrowar020"; break;
                case 26: sResref = "x2_mdrowar02" + IntToString(Random(8)+1); break;  //21,22,23,24,25,26,27,28
                case 27: sResref = "x2_mduerar00" + IntToString(Random(3)+4); break;//04,05,06
                case 28: sResref = "x2_it_adachain"; break;
                case 29: sResref = "x2_armor_001"; break;
                case 30: sResref = "x2_armor_003"; break;
                case 31: sResref = "x2_it_mithralch"; break;

                //case 17: sResref = "zep_chainbikini"; break;
                //case 18: sResref = "zep_aecm_001"; break;
                //case 19: sResref = "zep_chain"; break;
                //case 20: sResref = "zep_druidarmor"; break;
                //case 21: sResref = "zep_lamellar"; break;
                //case 22: sResref = "zep_tieflingchn"; break;

            }
            switch(d6()) {
                case 1:  sNombre = "Coraza élfica"; break;
                case 2:  sNombre = "Cota de escamas sangrienta"; break;
                case 3:  sNombre = "Cota de mallas de mithril"; break;
                case 4:  sNombre = "Armadura de dragón"; break;
                case 5:  sNombre = "Voluntad divina"; break;
                case 6:  sNombre = "Cota férrea"; break;
            }
            break;
        case 3: // Armadura (Pesada)
            bMale = FALSE;
            switch(Random(14)) {//26
                case 0:  sResref = "nw_maarcl022"; break;
                //case 1:  sResref = "nw_maarcl025"; break;
                case 1:  sResref = "nw_maarcl02" + IntToString(Random(2)+7); break;
                case 2:  sResref = "nw_maarcl053"; break; //"nw_maarcl05" + IntToString(Random(4)); break;
                case 3:  sResref = "nw_maarcl062"; break;
                //case 5:  sResref = "nw_maarcl064"; break;
                case 4:  sResref = "nw_maarcl06" + IntToString(Random(2)+8); break;
                case 5:  sResref = "nw_maarcl074"; break;
                //case 8:  sResref = "nw_maarcl076"; break;
                case 6:  sResref = "nw_maarcl080"; break; //sResref = "nw_maarcl08" + IntToString(Random(2)); break;
                //case 10: sResref = "nw_maarcl086"; break;
                //case 11: sResref = "x0_maarcl01" + IntToString(Random(2)+7); break;
                case 7: sResref = "x0_maarcl02" + IntToString(Random(2)+2); break;//"x0_maarcl02" + IntToString(Random(4)+1); break;
                //case 13: sResref = "x2_mdrowar031"; break;
                case 8: sResref = "x2_mdrowar040"; break;
                case 9: sResref = "x2_mduerar002"; break;
                case 10: sResref = "x2_maarcl04" + IntToString(Random(2)+7); break;//"x2_maarcl04" + IntToString(Random(8)+1); break;
                case 11: sResref = "x2_c3_maarcl037"; break;
                case 12: sResref = "x2_cus_casielsso"; break;
                case 13: sResref = "x2_cus_armoroffa"; break;
                //case 20: sResref = "zep_aribeth"; break;
                //case 21: sResref = "crpi_reaper_armr"; break;
                //case 22: sResref = "aarcl007"; break;
                //case 23: sResref = "zep_knightarmor"; break;
                //case 24: sResref = "zep_goblin"; break;
                //case 25: sResref = "zep_knightarm" + IntToString(Random(5)+2); break;
            }

            switch(d6()) {
                case 1:
                    sNombre = "Baluarte";
                    bMale = TRUE;
                    break;
                case 2:
                    sNombre = "El defensor dorado";
                    bMale = TRUE;
                    break;
                case 3:  sNombre = "Alma de Tempus"; break;
                case 4:  sNombre = "Armadura completa"; break;
                case 5:  sNombre = "Armadura laminada de hierro"; break;
                case 6:  sNombre = "Cota de bandas élfica"; break;
            }
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
    if(nDG >= 30 && IsKitSet < 0 && iTienda == FALSE)
    {
         switch(Random(2))
         {
             case 0:
                    SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos de luz fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto angelical.");
                    SetLocalInt(oCreado, "Kit_Celestial", 1);
                    NuevoNombre = rgbColor(sNombre+" Celestial", 255, 255, 204);
                    SetName(oCreado, NuevoNombre);
                    break;
             case 1:
                    SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos oscuros fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto oscuro.");
                    SetLocalInt(oCreado, "Kit_Infernal", 1);
                    NuevoNombre = rgbColor(sNombre+" Infernal", 255, 255, 0);
                    SetName(oCreado, NuevoNombre);
                    break;
             case 2:
                    SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos naturales fuera de lo común que lo diferencian del resto. Sólo conoces que lo rescataste de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto ancestral.");
                    SetLocalInt(oCreado, "Kit_Nirvana", 1);
                    NuevoNombre = rgbColor(sNombre+" del Nirvana", 0, 200, 0);
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
    sorteoArmaduras(oCreado, nDG);
    if (iTienda==TRUE){SetIdentified(oCreado, TRUE);} else {SetIdentified(oCreado, FALSE);}
    SetLocalInt(oCreado, "PCItem", 1);
    // Boss-chest loot is marked like every other piece: the rank the
    // extractor reads is the same band that named and coloured it. Only what
    // lands in a flagged loot container is loot: shop stock and quest
    // rewards, which these same functions create on the player, stay unmarked.
    if (iTienda == FALSE && GetLocalInt(oTarget, CNR_LOOT_VAR_SOURCE) == TRUE)
    {
        CnrLoot_Mark(oCreado, CnrLoot_RankFromDG(nDG));
    }
}

