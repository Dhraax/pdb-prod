//------------------------------------------------------------------------------
//  Libreria para la generacion de escudos, reutilizado codigo de
//  monti.
//  Creado por: cerril
//  Creado el: 10/01/2017
//..............................................................................

#include "pb_tesoro_sorteo"
#include "pb_tesoro_nombre"

//--- Metodos publicos ---------------------------------------------------------
void crearEscudo(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0);
//..............................................................................

void crearEscudo(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0) {
    string sResref;
    string sNombre;
    int bMale;
    int nTirada = Random(3);
    if (iAle==FALSE){nTirada = iVal; }

    switch(nTirada) {
        case 0: // Escudos pequenyos
            bMale = FALSE;
            switch(Random(14)) {
                case 0: sResref = "zep_buckler"; break;
                case 1: sResref = "zep_sshldem_001"; break;
                case 2: sResref = "zep_sshldsn_001"; break;
                case 3: sResref = "x2_smchaosshield"; break;
                case 4: sResref = "x2_it_ironwshlds"; break;
                case 5: sResref = "nw_ashmsw00" + IntToString(Random(8)+2); break;
                case 6: sResref = "nw_ashmsw01" + IntToString(Random(2)); break;
                case 7: sResref = "x0_ashmsw00" + IntToString(Random(2)+1); break;
                case 8: sResref = "x2_ashmsw00" + IntToString(Random(2)+3); break;
                case 9: sResref = "e009"; break;
                case 10: sResref = "escudopequeod"; break;
                case 11: sResref = "hen_esc_grant"; break;
                case 12: sResref = "vgz_escudotrasgo"; break;
                case 13: sResref = "e014"; break;
            }

            switch(d6()) {
                case 1:
                    sNombre = "Broquel";
                    bMale = TRUE;
                    break;
                case 2:
                    sNombre = "Escudete";
                    bMale = TRUE;
                    break;
                case 3:  sNombre = "Adarga";break;
                case 4:  sNombre = "Rodela";break;
                case 5:  sNombre = "Defensa del asesino"; break;
                case 6:  sNombre = "Guardacabeza"; break;
            }
            break;
        case 1: // Escudos grandes
            bMale = TRUE;
            switch(Random(19)) {
                case 0: sResref = "zep_azershield"; break;
                case 1: sResref = "zep_lshldek_001"; break;
                case 2: sResref = "x2_it_iwoodshldl"; break;
                case 3: sResref = "nw_ashmlw00" + IntToString(Random(8)+2); break;
                case 4: sResref = "x0_ashmlw00" + IntToString(Random(3)+1); break;
                case 5: sResref = "x2_ashmlw00" + IntToString(Random(4)+3); break;
                case 6: sResref = "x2_adrowshl00" + IntToString(Random(3)+1); break;
                case 7: sResref = "centinela4"; break;
                case 8: sResref = "escudodearmon"; break;
                case 9: sResref = "esm_escudo_mazm"; break;
                case 10: sResref = "escudodemithir"; break;
                case 11: sResref = "uri_soldadoamn"; break;
                case 12: sResref = "escudodeunbrion"; break;
                case 13: sResref = "escudodelperdi"; break;
                case 14: sResref = "escudograndede"; break;
                case 15: sResref = "escudohojanegra"; break;
                case 16: sResref = "escudozhentarim"; break;
                case 17: sResref = "graciaancestral"; break;
                case 18: sResref = "conv_escesq"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Escudo de madera"; break;
                case 2:  sNombre = "Protector"; break;
                case 3:  sNombre = "Escudo reforzado"; break;
                case 4:  sNombre = "Escudo de hierro"; break;
                case 5:  sNombre = "Escudo de recluta"; break;
                case 6:  sNombre = "Gloria de Amn"; break;
            }
            break;
        case 2: // Escudos paveses
            bMale = TRUE;
            switch(Random(16)) {
                case 0: sResref = "zep_dirganswall"; break;
                case 1: sResref = "zep_tshldwl_001"; break;
                case 2: sResref = "x2_it_ironwshldt"; break;
                case 3: sResref = "nw_ashmto00" + IntToString(Random(8)+2); break;
                case 4: sResref = "nw_ashmto01" + IntToString(Random(2)); break;
                case 5: sResref = "x0_ashmto00" + IntToString(Random(2)+1); break;
                case 6: sResref = "x2_ashmto00" + IntToString(Random(3)+3); break;
                case 7: sResref = "x3_it_pdshield"; break;
                case 8: sResref = "escudodrow"; break;
                case 9: sResref = "escudopavsdemit"; break;
                case 10: sResref = "siervoperdidaesc"; break;
                case 11: sResref = "escudopavsde"; break;
                case 12: sResref = "escudodelator"; break;
                case 13: sResref = "escudodeescama"; break;
                case 14: sResref = "item008"; break;
                case 15: sResref = "escudofortaleza"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Centurión"; break;
                case 2:  sNombre = "Defensor"; break;
                case 3:  sNombre = "Deflector"; break;
                case 4:
                    sNombre = "Muralla impenetrable";
                    bMale = FALSE;
                    break;
                case 5:  sNombre = "Escudo sagrado"; break;
                case 6:
                    sNombre = "Última defensa";
                    bMale = FALSE;
                    break;
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
    SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos, pero no lleva el sello de ningún fabricante. Su historia y leyenda son aparentemente desconocidas, sólo conoces que lo rescataste de las garras de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto mágico.");

    limpiarObjeto(oCreado);
    sorteoEscudos(oCreado, nDG);
    if (iTienda==TRUE){SetIdentified(oCreado, TRUE);} else {SetIdentified(oCreado, FALSE);}
    SetLocalInt(oCreado, "PCItem", 1);
}
