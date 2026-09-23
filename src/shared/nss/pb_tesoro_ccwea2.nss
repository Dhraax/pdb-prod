//------------------------------------------------------------------------------
//  Libreria para la generacion de armas cuerpo a cuerpo, reutilizado codigo de
//  monti.
//  Creado por: cerril
//  Creado el: 10/01/2017
//  Modificado por: Kronos.
//  Modificación: 29/03/2019.
//..............................................................................

#include "pb_tesoro_sorteo"
#include "pb_tesoro_nombre"

#include "cnr_i_loot"
//--- Metodos publicos ---------------------------------------------------------
void crearArmaCC(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0);
void crearGuantesMonje(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0);
//..............................................................................

void crearArmaCC(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0) {
    string sResref;
    string sNombre;
    int bMale;
    int bAtVS = TRUE;
    int nCantidad = 0;
    int nTirada = Random(4);
    if (iAle==FALSE){nTirada = iVal; }

    switch(nTirada) {
        case 0: // Espadas largas
            bMale = FALSE;
            switch(Random(19))
            {
                case 0:  sResref = "nw_it_crewls00" + IntToString(Random(2)+5); break;
                case 1:  sResref = "nw_it_novel007"; break;
                case 2:  sResref = "nw_wswls001"; break;
                case 3:  sResref = "nw_wswmls002"; break;
                case 4:  sResref = "nw_wswmls00" + IntToString(Random(4)+4); break;
                case 5:  sResref = "nw_wswmls009"; break;
                case 6:  sResref = "nw_wswmls01" + IntToString(Random(4)); break;
                case 7:  sResref = "x0_wswmls001"; break;
                case 8:  sResref = "x"+IntToString(Random(2))+"_wswmls002"; break;
                case 9: sResref = "x2_it_frzdrowbld"; break;
                case 10: sResref = "x2_wdrowls00" + IntToString(Random(4)+1); break;
                case 11: sResref = "x2_wswmls00" + IntToString(Random(5)+3); break;
                case 12: sResref = "x3_it_coldironb"; break;
                case 13: sResref = "zep_unholysw"; break;
                case 14: sResref = "zep_jian"; break;
                case 15: sResref = "zep_planetarls"; break;
                case 16: sResref = "zep_unholysw"; break;
                case 17: sResref = "zep_brokenlongs"; break;
                case 18: sResref = "zep_xswml_001"; break;
            }

            switch(d6())
            {
                case 1: sNombre = "Espada larga"; break;
                case 2: sNombre = "Espada de caballero"; break;
                case 3: sNombre = "Excálibur"; break;
                case 4: sNombre = "Hoja de gladiador"; break;
                case 5: sNombre = "Espada de hierro"; break;
                case 6: sNombre = "Espada sagrada"; break;
            }
            break;
        case 1: // Espadas de dos hojas
            bMale = FALSE;
            switch(Random(16)+1)
            {
                case 1: sResref = "zep_xdbsc_00" + IntToString(Random(4)+1); break;
                case 2: sResref = "zep_wetbs_001"; break;
                case 3: sResref = "nw_wdbsw001"; break;
                case 4: sResref = "nw_wdbmsw002"; break;
                case 5: sResref = "nw_wdbmsw00" + IntToString(Random(5)+4); break;
                case 6: sResref = "nw_wdbmsw01" + IntToString(Random(2)); break;
                case 7: sResref = "x0_wdbmsw00" + IntToString(Random(2)+1); break;
                case 8: sResref = "x2_wdbmsw00" + IntToString(Random(2)+3); break;
                case 9: sResref = "item_maugcep"; break;
                case 10: sResref = "item_maugcep"; break;
                case 11: sResref = "item_maugcep"; break;
                case 12: sResref = "item_maugcep"; break;
                case 13: sResref = "item_maugcep"; break;
                case 14: sResref = "item_maugcep"; break;
                case 15: sResref = "item_maugcep"; break;
                case 16: sResref = "nw_wdbsw001"; break;
            }

            switch(d6()){
                case 1: sNombre = "Espada de dos hojas"; break;
                case 2: sNombre = "Cimitarra doble"; break;
                case 3: sNombre = "Espada ceremonial bárbara"; break;
                case 4: sNombre = "Hojas doble de gladiador"; break;
                case 5: sNombre = "Doble muerte"; break;
                case 6:
                    sNombre = "Doble sagrado destino";
                    bMale = TRUE;
                    break;
            }
            break;
        case 2: // Dagas
            bMale = FALSE;
            switch(Random(9)+1)
            {
                case 1:  sResref = "x0_wswmdg00" + IntToString(Random(2)+1); break;
                case 2:  sResref = "x2_wswmdg00" + IntToString(Random(2)+3); break;
                case 3:  sResref = "nw_wswmdg00" + IntToString(Random(2)+8); break;
                case 4:  sResref = "nw_wswmdg002"; break;
                case 5:  sResref = "ZEP_ASSASSINDAGG"; break;
                case 6:  sResref = "ZEP_ASSASSINDAGG"; break;
                case 7:  sResref = "ZEP_ASSASSINDAGG"; break;
                case 8:  sResref = "item_dagahechi"; break;
                case 9:  sResref = "item_dagahechi"; break;

            }

            switch(Random(5)) {
                case 0: sNombre = "Daga de asesino"; break;
                case 1:
                    sNombre = "Cuchillo";
                    bMale = TRUE;
                    break;
                case 2: sNombre = "Daga"; break;
                case 3: sNombre = "Lanza de fata"; break;
                case 4:
                    sNombre = "Puñal";
                    bMale = TRUE;
                    break;
            }
            break;
        case 3: // Espadones
            bMale = FALSE;
            switch(Random(17)) {
                case 0:  sResref = "nw_wswmgs01" + IntToString(Random(2)+1); break;
                case 1:  sResref = "x0_wswmgs00" + IntToString(Random(2)+1); break;
                case 2:  sResref = "x2_wswmgs00" + IntToString(Random(2)+3); break;
                case 3:  sResref = "nw_wswmgs002"; break;
                case 4:  sResref = "nw_wswmgs005"; break;
                case 5:  sResref = "nw_wswmgs009"; break;
                case 6:  sResref = "nw_wswgs001"; break;
                case 7:  sResref = "zep_xswgs_001"; break;
                case 8:  sResref = "zep_brokengreats"; break;
                case 9: sResref = "zep_wpngsw_001"; break;
                case 10: sResref = "zep_nodachi"; break;
                case 11: sResref = "item_espadonen"; break;
                case 12: sResref = "item_giantgsword"; break;
                case 13: sResref = "item_giantgsw002"; break;
                case 14: sResref = "item_giantgsw003"; break;
                case 15: sResref = "item_giantgsw004"; break;
                case 16: sResref = "item_giantgsw005"; break;
            }
            switch(d8()) {
                case 1:
                    sNombre = "Espadón";
                    bMale = TRUE;
                    break;
                case 2:
                    sNombre = "Mandoble";
                    bMale = TRUE;
                    break;
                case 3: sNombre = "Claymore"; break;
                case 4: sNombre = "Hoja rúnica";break;
                case 5: sNombre = "La Torre"; break;
                case 6: sNombre = "Espada de reyes"; break;
                case 7: sNombre = "Espada de cristal"; break;
                case 8: sNombre = "Nodachi"; break;
            }
            break;
        case 4: // Espadas cortas
            bMale = FALSE;
            switch(Random(13)) {
                case 0:  sResref = "zep_wpnssw_00" + IntToString(Random(2)+1); break;
                case 1:  sResref = "x0_wswmss00" + IntToString(Random(2)+1); break;
                case 2:  sResref = "x2_wswmss00" + IntToString(Random(2)+3); break;
                case 3:  sResref = "nw_wswmss011"; break;
                case 4:  sResref = "x2_wswmss006"; break;
                case 5:  sResref = "nw_wswmss009"; break;
                case 6:  sResref = "nw_wswmss002"; break;
                case 7:  sResref = "nw_wswss001"; break;
                case 8:  sResref = "zep_wakizashi"; break;
                case 9: sResref = "zep_ninjato"; break;
                case 10: sResref = "zep_brokenshorts"; break;
                case 11: sResref = "zep_browniesword"; break;
                case 12: sResref = "zep_baatjamdo"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Garra de ladrón"; break;
                case 2:  sNombre = "Apuñaladora"; break;
                case 3:  sNombre = "Espada de corta"; break;
                case 4:
                    sNombre = "Cuchillo jamonero";
                    bMale = TRUE;
                    break;
                case 5:
                    sNombre = "Triple filo";
                    bMale = TRUE;
                    break;
                case 6:  sNombre = "Defensora"; break;
            }
            break;
        case 5: // Espadas bastardas
            bMale = FALSE;
            switch(d8()) {
                case 1: sResref = "x0_wswmbs00" + IntToString(Random(2)+1); break;
                case 2: sResref = "x2_wswmbs00" + IntToString(Random(4)+3); break;
                case 3: sResref = "nw_wswmbs00" + IntToString(Random(3)+3); break;
                case 4: sResref = "nw_wswmbs010"; break;
                case 5: sResref = "nw_wswmbs002"; break;
                case 6: sResref = "nw_wswbs001"; break;
                case 7: sResref = "zep_wpnbsw_001"; break;
                case 8: sResref = "zep_bastardsw"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Valkiria"; break;
                case 2:  sNombre = "Castigadora"; break;
                case 3:
                    sNombre = "Sol naciente";
                    bMale = TRUE;
                    break;
                case 4:  sNombre = "Espada bastarda"; break;
                case 5:  sNombre = "Espada de cristal"; break;
                case 6:  sNombre = "Guardia real"; break;
            }
            break;
        case 6: // Cimitarras
            bMale = TRUE;
            switch(Random(5)) {
                case 0: sResref = "nw_wswmsc01" + IntToString(Random(2)); break;
                case 1: sResref = "x0_wswmsc00" + IntToString(Random(2)+1); break;
                case 2: sResref = "x2_wswmsc00" + IntToString(Random(2)+3); break;
                case 3: sResref = "nw_wswmsc00" + IntToString(Random(5)+4); break;
                case 4: sResref = "nw_wswsc001"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Sable"; break;
                case 2:  sNombre = "Sable pirata"; break;
                case 3:
                    sNombre = "Cimitarra";
                    bMale = FALSE;
                    break;
                case 4:  sNombre = "Ojos de Zehir"; break;
                case 5:
                    sNombre = "Hoja curvada";
                    bMale = FALSE;
                    break;
                case 6:  sNombre = "Quitapenas"; break;
            }
            break;
        case 7: // Alfanjes
            bMale = TRUE;
            switch(d3()) {
                case 1: sResref = "zep_xswfa_00" + IntToString(Random(5)+1); break;
                case 2: sResref = "zep_falchion"; break;
                case 3: sResref = "zep_planetarfal"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Alfanje"; break;
                case 2:  sNombre = "Alfanje pirata"; break;
                case 3:  sNombre = "Sable enorme"; break;
                case 4:  sNombre = "Sable serpentino"; break;
                case 5:  sNombre = "Alfanje de doble filo"; break;
                case 6:
                    sNombre = "Cimitarra ancha";
                    bMale = FALSE;
                    break;
            }
            break;
        case 8: // Katanas
            bMale = FALSE;
            switch(Random(7)) {
                case 0: sResref = "nw_wswmka01" + IntToString(Random(2)); break;
                case 1: sResref = "x0_wswmka00" + IntToString(Random(2)+1); break;
                case 2: sResref = "x2_wswmka00" + IntToString(Random(2)+3); break;
                case 3: sResref = "nw_wswmka00" + IntToString(Random(2)+6); break;
                case 4: sResref = "nw_wswka001"; break;
                case 5: sResref = "nw_wswmka004"; break;
                case 6: sResref = "x2_wswmka006"; break;
            }

            switch(Random(7)) {
                case 1:  sNombre = "Masamune"; break;
                case 2:  sNombre = "Uchigatana"; break;
                case 3:  sNombre = "Katana"; break;
                case 4:  sNombre = "Espada ninja"; break;
                case 5:  sNombre = "Apocalipsis"; break;
                case 6:  sNombre = "Kazekiri"; break;
                case 7:  sNombre = "Murasame"; break;
            }
            break;
        case 9: // Estoques
            bMale = TRUE;
            switch(d8()) {
                case 1: sResref = "nw_wswmrp01" + IntToString(Random(2)); break;
                case 2: sResref = "x0_wswmrp00" + IntToString(Random(2)+1); break;
                case 3: sResref = "x2_wswmrp00" + IntToString(Random(2)+3); break;
                case 4: sResref = "nw_wswmrp00" + IntToString(Random(2)+7); break;
                case 5: sResref = "zep_armandspoint"; break;
                case 6: sResref = "zep_keenrapier"; break;
                case 7: sResref = "nw_wswrp001"; break;
                case 8: sResref = "nw_wswmrp004"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Estoque"; break;
                case 2:  sNombre = "Florete"; break;
                case 3:  sNombre = "Brazo del duelista"; break;
                case 4:
                    sNombre = "Espada ropera";
                    bMale = FALSE;
                    break;
                case 5:
                    sNombre = "Demoledora";
                    bMale = FALSE;
                    break;
                case 6:  sNombre = "Gladius"; break;
            }
            break;
        case 10: // Picos
            bMale = TRUE;
            switch(d4()) {
                case 1: sResref = "zep_heavypick001"; break;
                case 2: sResref = "zep_heavypick"; break;
                case 3: sResref = "zep_lightpick"; break;
                case 4: sResref = "zep_lightpick001"; break;
            }

            switch(d4()) {
                case 1:  sNombre = "Pico de minero"; break;
                case 2:  sNombre = "Pico"; break;
                case 3:  sNombre = "Picapiedra"; break;
                case 4:
                    sNombre = "Voluntad del svirfneblin";
                    bMale = TRUE;
                    break;
            }
            break;
        case 11: // Tridentes
            bMale = TRUE;
            switch(Random(5))
            {
                case 1: sResref = "nw_wpltr00" + IntToString(Random(9)+1); break;
                case 2: sResref = "nw_wpltr010"; break;
                case 3: sResref = "item_tridentecep"; break;
                case 4: sResref = "item_tridentecep"; break;
            }

            switch(d4()) {
                case 1:  sNombre = "Tridente del Trueno"; break;
                case 2:  sNombre = "Tridente"; break;
                case 3:
                    sNombre = "Ira de Umberli";
                    bMale = FALSE;
                    break;
                case 4:  sNombre = "Surcamares"; break;
            }
            break;
        case 12: // Cachiporras
        {
            bMale = FALSE;
            sResref = "ZEP_SAP";
            sNombre = "Cachiporra";
        }break;
        case 13: // Nunchaku
        {
            bMale = TRUE;
            sResref = "ZEP_NUNCHAKU";
            sNombre = "Nunchaku";
        }break;
        case 14: // Sai
        {
            bMale = TRUE;
            sResref = "ZEP_XDBSC_001";
            sNombre = "Sai";
        }break;
        case 15: // Rueda
        {
            bMale = FALSE;
            sResref = "ZEP_WINDFIRE";
            sNombre = "Rueda del fuego y el viento";
        }break;
        case 16: // Doble-hacha
        case 17: // Hachas arrojadizas / Chakrams
            bMale = FALSE;
            switch(d20()) {
                case 1:  sNombre = "Hacha de mithril"; break;
                case 2:  sNombre = "Hacha de gigante"; break;
                case 3:  sNombre = "Rompetierra"; break;
                case 4:  sNombre = "Asaltante"; break;
                case 5:  sNombre = "Hacha del Señor Enano"; break;
                case 6:  sNombre = "Rompecráneos"; break;
                case 7:  sNombre = "Hacha ígnea"; break;
                case 8:  sNombre = "Hacha vorpalina"; break;
                case 9:  sNombre = "Hacha de leñador"; break;
                case 10: sNombre = "Furia destructora"; break;
                case 11: sNombre = "Hacha brutal"; break;
                case 12: sNombre = "Mano de Gruumsh"; break;
                case 13: sNombre = "Hacha gélida"; break;
                case 14: sNombre = "Centinela"; break;
                case 15: sNombre = "Hacha de Clangeddin"; break;
                case 16: sNombre = "Hacha fulminante"; break;
                case 17: sNombre = "Hacha de Velo Mortal"; break;
                case 18: sNombre = "Hacha del Tigre Rojo"; break;
                case 19: sNombre = "Demoledora"; break;
                case 20: sNombre = "Matagigantes"; break;
            }

            switch(Random(38)) {
                // Hachas ligeras
                case 0:  sResref = "nw_waxmhn00" + IntToString(Random(2)+2); break;
                case 1:  sResref = "nw_waxmhn00" + IntToString(Random(2)+5); break;
                case 2:  sResref = "nw_waxmhn00" + IntToString(Random(2)+8); break;
                case 3:  sResref = "nw_waxmhn01" + IntToString(Random(2)); break;
                case 4:  sResref = "x0_waxmhn00" + IntToString(Random(2)+1); break;
                case 5:  sResref = "x2_waxmhn00" + IntToString(Random(2)+3); break;

                // Hachas de batalla
                case 6:  sResref = "nw_waxbt001"; break;
                case 7:  sResref = "nw_waxmbt00" + IntToString(Random(4)+3); break;
                case 8:  sResref = "nw_waxmbt008"; break;
                case 9: sResref = "nw_waxmbt01" + IntToString(Random(2)); break;
                case 10: sResref = "x0_waxmbt00" + IntToString(Random(2)+1); break;

                // Hachas de guerra enana
                case 11: sResref = "x2_wdwraxe001"; break;
                case 12: sResref = "x2_wmdwraxe00" + IntToString(Random(4)+2); break;
                case 13: sResref = "x2_wmdwraxe00" + IntToString(Random(4)+6); break;
                case 14: sResref = "x2_wmdwraxe01" + IntToString(Random(2)); break;

                // Grandes hachas
                case 15: sResref = "nw_waxgr001"; break;
                case 16: sResref = "nw_waxmgr00" + IntToString(Random(5)+2); break;
                case 17: sResref = "nw_waxmgr00" + IntToString(Random(2)+8); break;
                case 18: sResref = "nw_waxmgr011"; break;
                case 19: sResref = "x0_waxmgr00" + IntToString(Random(2)+1); break;
                case 20: sResref = "x2_waxmgr00" + IntToString(Random(2)+3); break;

                // Hachas dobles
                case 21: sResref = "nw_wdbax001";  break;
                case 22: sResref = "nw_wdbmax002"; break;
                case 23: sResref = "nw_wdbmax00" + IntToString(Random(6)+4); break;
                case 24: sResref = "nw_wdbmax01" + IntToString(Random(2));   break;
                case 25: sResref = "x0_wdbmax00" + IntToString(Random(2)+1); break;
                case 26: sResref = "x2_wdbmax00" + IntToString(Random(2)+3); break;

                // Hachas arrojadizas / Chakram
                case 27:
                    nCantidad = 50;
                    sResref ="zep_chakram";
                    sNombre = "Chakram";
                    break;
                case 28:
                    nCantidad = 50;
                    sResref ="nw_wthax001";
                    break;
                case 29:
                    nCantidad = 50;
                    sResref = "nw_wthmax00" + IntToString(Random(8)+2);
                    break;
                case 30:
                    nCantidad = 50;
                    sResref = "x0_wthmax00" + IntToString(Random(2)+1);
                    break;
                case 31:
                    nCantidad = 50;
                    sResref = "x2_wthmax00" + IntToString(Random(2)+3);
                    break;

                //Gran hacha enorme
                case 32: sResref = "item_ghachaen"; break;
                case 33: sResref = "item_giantgaxe02"; break;
                case 34: sResref = "item_giantgaxe03"; break;
                case 35: sResref = "item_giantgaxe04"; break;
                case 36: sResref = "item_giantgaxe05"; break;
                case 37: sResref = "item_giantgaxe06"; break;

            }
            break;
        case 18: // Alabardas
            bMale = FALSE;
            switch(Random(11)) {
                case 0:  sResref = "zep_wpnhlb_001"; break;
                case 1:  sResref = "zep_kwandao"; break;
                case 2:  sResref = "zep_naginata"; break;
                case 3:  sResref = "zep_pudao"; break;
                case 4:  sResref = "nw_wplhb001"; break;
                case 5:  sResref = "nw_wplmhb00" + IntToString(Random(3)+2);    break;
                case 6:  sResref = "nw_wplmhb00" + IntToString(Random(4)+6);    break;
                case 7:  sResref = "nw_wplmhb01" + IntToString(Random(2));      break;
                case 8:  sResref = "x0_wplmhb00" + IntToString(Random(2)+1);    break;
                case 9: sResref = "x2_wplmhb00" + IntToString(Random(2)+3);     break;
                case 10: sResref = "x2_it_venomhb"; break;
            }

            switch(d8()) {
                case 1:  sNombre = "Alabarda"; break;
                case 2:  sNombre = "Aliento de Dragón"; break;
                case 3:  sNombre = "Asoladora"; break;
                case 4:  sNombre = "Alabarda de ponzoña"; break;
                case 5:  sNombre = "Voluntad de Atar"; break;
                case 6:  sNombre = "Partearco"; break;
                case 7:  sNombre = "Orilla del Agua"; break;
                case 8:  sNombre = "Naginata"; break;
            }
            break;
        case 19: // Lanzas
            bMale = FALSE;
            switch(Random(18)+1)
            {
                case 1:  sResref = "nw_wplmss002"; break;
                case 2:  sResref = "nw_wplmss004"; break;
                case 3:  sResref = "nw_wplmss00" + IntToString(Random(3)+6); break;
                case 4:  sResref = "nw_wplmss01" + IntToString(Random(2)); break;
                case 5:  sResref = "x0_wplmss00" + IntToString(Random(2)+1); break;
                case 6:  sResref = "x2_wplmss00" + IntToString(Random(2)+3); break;
                case 7: sResref = "item_lanzaen"; break;
                case 8: sResref = "item_lanzaen"; break;
                case 9: sResref = "item_lanzaen"; break;
                case 10: sResref = "item_lanzaen"; break;
                case 11: sResref = "item_lanzaen"; break;
                case 12: sResref = "item_lanzaen"; break;
                case 13: sResref = "item_lanzacorta"; break;
                case 14: sResref = "item_lanzacorta"; break;
                case 15: sResref = "item_lanzacorta"; break;
                case 16: sResref = "item_lanzacorta"; break;
                case 17: sResref = "item_lanzacorta"; break;
                case 18: sResref = "item_lanzacorta"; break;
            }

            switch(Random(7)) {
                case 0:  sNombre = "Lanza"; break;
                case 1:  sNombre = "Lanza eólica"; break;
                case 2:  sNombre = "Lanza de cristal"; break;
                case 3:  sNombre = "Lanza de aerodragón"; break;
                case 4:  sNombre = "Lanza sagrada"; break;
                case 5:  sNombre = "Gae Bolg"; break;
                case 6:  sNombre = "Gungnir"; break;
            }
            break;
        case 20: // Guadanyas
            bMale = FALSE;
            switch(d8()) {
                case 1: sResref = "crpi_reapr_scyth"; break;
                case 2: sResref = "zep_nagamaki"; break;
                case 3: sResref = "nw_wplsc001"; break;
                case 4: sResref = "nw_wplmsc00" + IntToString(Random(5)+2); break;
                case 5: sResref = "nw_wplmsc00" + IntToString(Random(2)+8); break;
                case 6: sResref = "nw_wplmsc01" + IntToString(Random(2)); break;
                case 7: sResref = "x0_wplmsc00" + IntToString(Random(2)+1); break;
                case 8: sResref = "x2_wplmsc00" + IntToString(Random(2)+3); break;
            }

            switch(d6()) {
                case 1:  sNombre = "Guadaña brutal"; break;
                case 2:  sNombre = "Locura del campesino"; break;
                case 3:  sNombre = "La Muerte"; break;
                case 4:  sNombre = "Furia de Khauntea"; break;
                case 5:  sNombre = "Masacre"; break;
                case 6:  sNombre = "Último filo"; break;
            }
            break;
        case 21: // Clavas
            bMale = FALSE;
            switch(d6())
            {
              case 1:  sResref = "x2_it_iwoodclub"; break;
              case 2:  sResref = "nw_wblmcl00" + IntToString(Random(5)+2); break;
              case 3:  sResref = "nw_wblmcl00" + IntToString(Random(2)+8); break;
              case 4:  sResref = "nw_wblmcl01" + IntToString(Random(2)); break;
              case 5:  sResref = "x0_wblmcl00" + IntToString(Random(2)+1); break;
              case 6: sResref = "x2_wblmcl00" + IntToString(Random(2)+3); break;
            }

            switch(d6()) {
                case 1:  sNombre = "Raspón"; break;
                case 2:  sNombre = "Cachiporra"; break;
                case 3:  sNombre = "Tronco de leñoscuro"; break;
                case 4:  sNombre = "Astilla de árbol nodal"; break;
                case 5:  sNombre = "Sueltamamporros"; break;
                case 6:  sNombre = "Rompemandíbulas"; break;
            }
            break;
        case 22: // Manguales ligeros
        case 23: // Manguales pesados
            bMale = TRUE;
            switch(d10()) {
                case 1:  sResref = "nw_wblmfl002"; break;
                case 2:  sResref = "nw_wblmfl00" + IntToString(Random(6)+4); break;
                case 3:  sResref = "nw_wblmfl01" + IntToString(Random(2)); break;
                case 4:  sResref = "x0_wblmfl00" + IntToString(Random(2)+1); break;
                case 5:  sResref = "x2_wblmfl00" + IntToString(Random(3)+3); break;
                case 6:  sResref = "nw_wblmfh00" + IntToString(Random(5)+2); break;
                case 7:  sResref = "nw_wblmfh00" + IntToString(Random(2)+8); break;
                case 8:  sResref = "nw_wblmfh01" + IntToString(Random(2)); break;
                case 9:  sResref = "x0_wblmfh00" + IntToString(Random(2)+1); break;
                case 10: sResref = "x2_wblmfh00" + IntToString(Random(3)+3); break;
            }

            switch(d6()) {
                case 1:  sNombre = "Mangual de aceroscuro"; break;
                case 2:  sNombre = "La Horda"; break;
                case 3:  sNombre = "Furia demoledora"; break;
                case 4:  sNombre = "Aplastaejércitos"; break;
                case 5:  sNombre = "Descanso seguro"; break;
                case 6:  sNombre = "Pulverizador"; break;
            }
            break;
        case 24: // Mazos
        {
          bMale = TRUE;
          int iTirada = Random(2)+1;
          switch(iTirada)
          {
              case 1:  sResref = "ZEP_XBLMA_001"; break;
              case 2:  sResref = "item_mazoen"; break;
          }

          iTirada = d8();
          switch(iTirada)
          {
              case 1:  sNombre = "Rompecráneos"; break;
              case 2:  sNombre = "Avalancha"; break;
              case 3:  sNombre = "Mazo infernal"; break;
              case 4:  sNombre = "Quebrahuesos"; break;
              case 5:  sNombre = "Gravilla"; break;
              case 6:  sNombre = "Machacamuros"; break;
              case 7:  sNombre = "Martillo de hierro"; break;
              case 8:  sNombre = "Lluvia brutal"; break;
          }
      }break;
        case 25: // Martillos de guerra
            bMale = TRUE;
            switch(d12()) {
                case 1:  sResref = "nw_wblmhw009"; break;
                case 2:  sResref = "zep_azerhammer"; break;
                case 3:  sResref = "nw_wblmhl00" + IntToString(Random(5)+2); break;
                case 4:  sResref = "nw_wblmhl00" + IntToString(Random(2)+8); break;
                case 5:  sResref = "nw_wblmhl01" + IntToString(Random(2)); break;
                case 6:  sResref = "x0_wblmhl00" + IntToString(Random(2)+1); break;
                case 7:  sResref = "x2_wblmhl00" + IntToString(Random(4)+3); break;
                case 8:  sResref = "nw_wblmhw00" + IntToString(Random(5)+2); break;
                case 9:  sResref = "nw_wblmhw01" + IntToString(Random(3)); break;
                case 10: sResref = "x0_wblmhw00" + IntToString(Random(2)+1); break;
                case 11: sResref = "x2_wblmhw00" + IntToString(Random(3)+3); break;
                case 12: sResref = "zep_xblma_00" + IntToString(Random(4)+1); break;
            }

            switch(d8()) {
                case 1:  sNombre = "Rompecráneos"; break;
                case 2:  sNombre = "Avalancha"; break;
                case 3:  sNombre = "Mazo infernal"; break;
                case 4:  sNombre = "Quebrahuesos"; break;
                case 5:  sNombre = "Gravilla"; break;
                case 6:  sNombre = "Machacamuros"; break;
                case 7:  sNombre = "Martillo de hierro"; break;
                case 8:  sNombre = "Lluvia brutal"; break;
            }
            break;
        case 26: // Mazas ligeras y pesadas
        case 27: // Mazas terribles
            bMale = FALSE;
            switch(Random(15)) {
                case 0:  sResref = "x1_wblmml001"; break;
                case 1:  sResref = "nw_wblmml00" + IntToString(Random(6)+4); break;
                case 2:  sResref = "nw_wblmml01" + IntToString(Random(3)); break;
                case 3:  sResref = "x0_wblmml00" + IntToString(Random(2)+1); break;
                case 4:  sResref = "x2_wblmml00" + IntToString(Random(3)+3); break;
                case 5:  sResref = "zep_xblmh_00" + IntToString(Random(5)+1); break;
                case 6:  sResref = "nw_wdbmma00" + IntToString(Random(5)+2); break;
                case 7:  sResref = "nw_wdbmma00" + IntToString(Random(2)+8); break;
                case 8:  sResref = "nw_wdbmma01" + IntToString(Random(2));   break;
                case 9: sResref = "x0_wdbmma00" + IntToString(Random(2)+1); break;
                case 10: sResref = "x2_wdbmma00" + IntToString(Random(3)+3); break;
                case 11:  sResref = "ZEP_XBLMH_001"; break;
                case 12:  sResref = "ZEP_XBLMH_001"; break;
                case 13:  sResref = "ZEP_XBLMH_001"; break;
                case 14:  sResref = "ZEP_XBLMH_001"; break;
            }

            switch(d10()) {
                case 1:  sNombre = "Único golpe"; break;
                case 2:  sNombre = "Maza de hierro frío"; break;
                case 3:  sNombre = "Castigo de Tyr"; break;
                case 4:  sNombre = "Embestida"; break;
                case 5:  sNombre = "Mazazo tremendo"; break;
                case 6:  sNombre = "Dolor de Ilmater"; break;
                case 7:  sNombre = "Barricada"; break;
                case 8:  sNombre = "Torbellino"; break;
                case 9:  sNombre = "La torre"; break;
                case 10: sNombre = "Defensora"; break;
            }
            break;
        case 28: // Mazas de armas
            bMale = FALSE;
            switch(Random(5)) {
                case 0:  sResref = "nw_wblmms00" + IntToString(Random(3)+2); break;
                case 1:  sResref = "nw_wblmms00" + IntToString(Random(4)+6); break;
                case 2:  sResref = "nw_wblmms01" + IntToString(Random(2)); break;
                case 3:  sResref = "x0_wblmms00" + IntToString(Random(2)+1); break;
                case 4:  sResref = "x2_wblmms00" + IntToString(Random(3)+3); break;
            }

            switch(d6()) {
                case 1:  sNombre = "Bola de pinchos"; break;
                case 2:  sNombre = "Maza de armas"; break;
                case 3:  sNombre = "Agrietacimientos"; break;
                case 4:  sNombre = "Destructor de escudos"; break;
                case 5:  sNombre = "Esfera de metal"; break;
                case 6:  sNombre = "Defensa rotatoria"; break;
            }
            break;
        case 29: // Bastones
            bMale = TRUE;
            switch(d6())
            {
                case 1:  sResref = "x2_it_iwoodstaff"; break;
                case 2:  sResref = "nw_wdbmqs00" + IntToString(Random(8)+2); break;
                case 3:  sResref = "x0_wdbmqs00" + IntToString(Random(2)+1); break;
                case 4:  sResref = "x2_wdbmqs00" + IntToString(Random(5)+3); break;
                case 5:  sResref = "x2_it_iwoodstaff"; break;
                case 6:  sResref = "x2_it_iwoodstaff"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Vara mortal"; break;
                case 2:  sNombre = "Corteza forestal"; break;
                case 3:  sNombre = "Bastón equilibrado"; break;
                case 4:  sNombre = "Báculo de huesos"; break;
                case 5:  sNombre = "Rompeespaldas"; break;
                case 6:  sNombre = "Cayado de anciano"; break;
            }
            break;
        case 30: // Hoces
            bMale = FALSE;
            switch(d6()) {
                case 1:  sResref = "nw_wspmsc00" + IntToString(Random(5)+2); break;
                case 2:  sResref = "nw_wspmsc00" + IntToString(Random(5)+2); break;
                case 3:  sResref = "nw_wspmsc00" + IntToString(Random(2)+8); break;
                case 4:  sResref = "nw_wspmsc01" + IntToString(Random(2)); break;
                case 5:  sResref = "x0_wspmsc00" + IntToString(Random(2)+1); break;
                case 6:  sResref = "x2_wspmsc00" + IntToString(Random(3)+3); break;
            }

            switch(d6()) {
                case 1:  sNombre = "Espiga dorada"; break;
                case 2:  sNombre = "Segador vital"; break;
                case 3:  sNombre = "Hoz de leñoscuro"; break;
                case 4:  sNombre = "Hocico de Oso"; break;
                case 5:  sNombre = "Malas hierbas"; break;
                case 6:  sNombre = "Garra de lince"; break;
            }
            break;
        case 31: // Kamas
            bMale = FALSE;
            switch(d3())
            {
                case 1:  sResref = "nw_wspmka00" + IntToString(Random(8)+2); break;
                case 2:  sResref = "x0_wspmka00" + IntToString(Random(2)+1); break;
                case 3:  sResref = "x2_wspmka00" + IntToString(Random(3)+3); break;
            }

            switch(d6()) {
                case 1:  sNombre = "Kama"; break;
                case 2:  sNombre = "Segadora"; break;
                case 3:  sNombre = "Descarga Ki"; break;
                case 4:  sNombre = "Filo oriental"; break;
                case 5:  sNombre = "Ráfaga de golpes"; break;
                case 6:  sNombre = "Kamón"; break;
            }
            break;
        case 32: // Kukirs y katares
            bMale = TRUE;
            switch(Random(8)) {
                case 1:  sResref = "nw_wspmku003"; break;
                case 2:  sResref = "x2_wspmku005"; break;
                case 3:  sResref = "nw_wspmku00" + IntToString(Random(3)+5); break;
                case 4:  sResref = "x2_kuk_storm"; break;
                case 5:  sResref = "zep_lokkukri"; break;
                case 6:  sResref = "zep_katar"; break;
                case 7:  sResref = "zep_katar"; break;
                case 8:  sResref = "zep_katar"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Puñal"; break;
                case 2:  sNombre = "Filo curvado"; break;
                case 3:  sNombre = "Pequeña amenaza"; break;
                case 4:  sNombre = "Sable pirata pequeño"; break;
                case 5:  sNombre = "Pezuña de felino"; break;
                case 6:  sNombre = "Velocidad"; break;
            }
            break;
        case 33: // Latigos
            bMale = TRUE;
            switch(d4()) {
                case 1:  sResref = "zep_kusari"; break;
                case 2:  sResref = "x2_whip_black"; break;
                case 3:  sResref = "zep_manriki"; break;
                case 4:  sResref = "x2_whip_black"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Látigo"; break;
                case 2:  sNombre = "Látigo devastador"; break;
                case 3:  sNombre = "Azote de infieles"; break;
                case 4:  sNombre = "Flagelo de Loviatar"; break;
                case 5:  sNombre = "Cuerda demoniaca"; break;
                case 6:  sNombre = "Las Siete Colas"; break;
            }
            break;
        case 34: // Guanteletes
            bMale = TRUE;
            bAtVS = FALSE;
            switch(Random(13)) {
                case 0: sResref = "nw_it_mglove021"; break;
                case 1: sResref = "nw_it_mglove026"; break;
                case 2: sResref = "nw_it_mglove016"; break;
                case 3: sResref = "x1_it_mglove001"; break;
                case 4: sResref = "x2_glove_bal"; break;
                case 5: sResref = "x2_it_mglove022"; break;
                case 6: sResref = "guanteletesapla"; break;
                case 7: sResref = "guanteletescurat"; break;
                case 8: sResref = "guanteletesmayor"; break;
                case 9: sResref = "guantescosidosel"; break;
                case 10: sResref = "guantesdecurande"; break;
                case 11: sResref = "guantesdelarte1"; break;
                case 12: sResref = "guantesdecuero"; break;
            }

            switch(Random(14)) {
                case 0:  sNombre = "Machacapiedras"; break;
                case 1:  sNombre = "Puños de acero"; break;
                case 2:  sNombre = "Guantes de batalla"; break;
                case 3:  sNombre = "Rompenarices"; break;
                case 4:  sNombre = "Guanteletes de monje"; break;
                case 5:  sNombre = "Manos férreas"; break;
                case 6:  sNombre = "Garras de tigre"; break;
                case 7:  sNombre = "Perforacorazones"; break;
                case 8:  sNombre = "Guantes de ninja"; break;
                case 9: sNombre = "Brazaletes de Ki"; break;
                case 10: sNombre = "Pulverizadores"; break;
                case 11: sNombre = "Pezuñas de dragón"; break;
                case 12: sNombre = "Cornadas sangrientas"; break;
                case 13: sNombre = "Guantes de batalla"; break;
            }
            break;
    }

    sNombre = nombrarObjeto(sNombre, nDG, bMale);
    object oCreado = CreateItemOnObject(sResref, oTarget);
    SetDroppableFlag(oCreado, TRUE);
    SetItemCursedFlag(oCreado, FALSE);
    SetIdentified(oCreado, TRUE);
    SetStolenFlag(oCreado, TRUE);
    SetPlotFlag(oCreado, FALSE);
    SetName(oCreado, sNombre);
    if(nCantidad > 0) {
        SetItemStackSize(oCreado, nCantidad);
    }
    SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos, pero no lleva el sello de ningún fabricante. Su historia y leyenda son aparentemente desconocidas, sólo conoces que lo rescataste de las garras de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto mágico.");

    limpiarObjeto(oCreado);
    sorteoArmasCC(oCreado, nDG, bAtVS);
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

void crearGuantesMonje(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0){
    string sResref;
    string sNombre;
    int bMale = TRUE;
    int bAtVS = FALSE;

    switch(Random(13)) {
        case 0: sResref = "nw_it_mglove021"; break;
        case 1: sResref = "nw_it_mglove026"; break;
        case 2: sResref = "nw_it_mglove016"; break;
        case 3: sResref = "x1_it_mglove001"; break;
        case 4: sResref = "x2_glove_bal"; break;
        case 5: sResref = "x2_it_mglove022"; break;
        case 6: sResref = "guanteletesapla"; break;
        case 7: sResref = "guanteletescurat"; break;
        case 8: sResref = "guanteletesmayor"; break;
        case 9: sResref = "guantescosidosel"; break;
        case 10: sResref = "guantesdecurande"; break;
        case 11: sResref = "guantesdelarte1"; break;
        case 12: sResref = "guantesdecuero"; break;
    }

    switch(Random(14)) {
        case 0:  sNombre = "Machacapiedras"; break;
        case 1:  sNombre = "Puños de acero"; break;
        case 2:  sNombre = "Guantes de batalla"; break;
        case 3:  sNombre = "Rompenarices"; break;
        case 4:  sNombre = "Guanteletes de monje"; break;
        case 5:  sNombre = "Manos férreas"; break;
        case 6:  sNombre = "Garras de tigre"; break;
        case 7:  sNombre = "Perforacorazones"; break;
        case 8:  sNombre = "Guantes de ninja"; break;
        case 9: sNombre = "Brazaletes de Ki"; break;
        case 10: sNombre = "Pulverizadores"; break;
        case 11: sNombre = "Pezuñas de dragón"; break;
        case 12: sNombre = "Cornadas sangrientas"; break;
        case 13: sNombre = "Guantes de batalla"; break;
    }

    sNombre = nombrarObjeto(sNombre, nDG, bMale);
    object oCreado = CreateItemOnObject(sResref, oTarget);
    SetDroppableFlag(oCreado, TRUE);
    SetItemCursedFlag(oCreado, FALSE);
    SetIdentified(oCreado, TRUE);
    SetStolenFlag(oCreado, TRUE);
    SetPlotFlag(oCreado, FALSE);
    SetName(oCreado, sNombre);
    SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos, pero no lleva el sello de ningún fabricante. Su historia y leyenda son aparentemente desconocidas, sólo conoces que lo rescataste de las garras de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto mágico.");

    limpiarObjeto(oCreado);
    sorteoArmasCC(oCreado, nDG, bAtVS);
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
