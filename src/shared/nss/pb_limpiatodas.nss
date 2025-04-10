string Tag_Tienda(int num)
{

    string sTag;
    switch (num)
    {
        case 0: sTag = "ko_bebidas"; break;
        case 1: sTag= "ko_comida_variada"; break;
        case 2: sTag= "ko_complementos"; break;
        case 3: sTag= "ko_floristeria";  break;
        case 4: sTag= "ko_fruteria"; break;
        case 5: sTag= "ko_panaderia"; break;
        case 6: sTag= "ko_pescaderia"; break;
        case 7: sTag= "ko_piedras_ioun"; break;
        case 8: sTag= "ko_posada_enana"; break;
        case 9: sTag= "ko_tienda_cascos"; break;
        case 10: sTag= "ko_tienda_magia"; break;
        case 11: sTag= "ko_tienda_templo_generico"; break;
        case 12: sTag="mercado_negro_1"; break;
        case 13: sTag="tienda_carpinteria"; break;
        case 14: sTag="tienda_equipo_basico"; break;
        case 15: sTag="tienda_equipo_basico_0"; break;
        case 16: sTag="tienda_escritura"; break;
        case 17: sTag="tienda_generia_utilidades"; break;
        case 18: sTag="tienda_herbologia"; break;
        case 19: sTag="tienda_ingredientesconjuro"; break;
        case 20: sTag="tienda_mercancias_basica"; break;
        case 21: sTag="tienda_orfebreria"; break;
        case 22: sTag="tienda_peleteria"; break;
        case 23: sTag="agujasboutique"; break;
        case 24: sTag="tirachinas"; break;
        case 25: sTag="ao_mercaderwaukin"; break;
        case 26: sTag="mercader_azotamentes"; break;
        case 27: sTag="mercader_contemplador"; break;
        case 28: sTag="mercader_duergar"; break;
        case 29: sTag="mercader_humano"; break;
        case 30: sTag="mercader_identificar"; break;
        case 31: sTag="zer_tiendaenm"; break;
        case 32: sTag="bhalstacktienda"; break;
        case 33: sTag="tienda_bryyaba"; break;
        case 34: sTag="anticurio_brinnley"; break;
        case 35: sTag="Bane_sastre_ebrio"; break;
        case 36: sTag="Brynnley_jack"; break;
        case 37: sTag="mtz_mercadocofradias"; break;
        case 38: sTag="tienda_Asim"; break;
        case 39: sTag="barmanmonovulgar"; break;
        case 40: sTag="mti_bryn_cleumberli"; break;
        case 41: sTag="DelandraXilas"; break;
        case 42: sTag="ko_atk_cmarick"; break;
        case 43: sTag="ko_atk_gruganrcn"; break;
        case 44: sTag="ko_atk_oshun"; break;
        case 45: sTag="Orlanth_Tech"; break;
        case 46: sTag="comerciante_merc_esmel_5"; break;
        case 47: sTag="Khora"; break;
        case 48: sTag ="Melkiadusvamp"; break;
        case 49: sTag="milcantes"; break;
        case 50: sTag="mirlac"; break;
        case 51: sTag="posada_zs_esmel"; break;
        case 52: sTag="tiendadepoemas"; break;
        case 53: sTag="instrumentos_musicales"; break;
        case 54: sTag="Funcionariodelaprision"; break;
        case 55: sTag="atk_elpulgar"; break;
        case 56: sTag="cofradia_tienda"; break;
        case 57: sTag="atk_mti_teiris1"; break;
        case 58: sTag="atk_sirdonaldus"; break;
        case 59: sTag="atk_ttsenyorada"; break;
        case 60: sTag="west_monjeoghma6"; break;
        case 61: sTag="sh_cuidadorestablosath"; break;
        case 62: sTag="tikal_merc_doblon"; break;
        case 63: sTag="mek_tiendaKalmPosada"; break;
        case 64: sTag="mek_tiendaKosmoPosada"; break;
        case 65: sTag="Asy_mercaderarcano"; break;
        case 66: sTag="atk_mti_pwcintos1"; break;
        case 67: sTag="objetos_poco_comunes"; break;
        case 68: sTag="Tenderowaukin2"; break;
        case 69: sTag="granillos"; break;
        case 70: sTag="grcomerc12"; break;
        case 71: sTag="grlibros"; break;
        case 72: sTag="Identificador"; break;
        case 73: sTag="magia_mda"; break;
        case 74: sTag="Ribald"; break;
        case 75: sTag="MagoRojo"; break;
        case 76: sTag="heroes"; break;
        case 77: sTag="wel_tiendaproyectiles"; break;
        case 78: sTag="BosqueEldat"; break;
        case 79: sTag="jgc_EstaElfo"; break;
        case 80: sTag="LithEowiewiel"; break;
        case 81: sTag="LithSalvya"; break;
        case 82: sTag="atk_mti_pwcinto1"; break;
        case 83: sTag="uri_urgdret"; break;
        case 84: sTag="wel_tiendaestablo"; break;
        case 85: sTag="atk_elpulgar"; break;
        case 86: sTag="mus_herbolario"; break;
        case 87: sTag="psk_herrero1"; break;
        case 88: sTag="psk_joyero1"; break;
        case 89: sTag="zapatera_purskul"; break;
        case 90: sTag="tienda_barhalden"; break;
        case 91: sTag="Cazadorlocal01"; break;
        case 92: sTag="mti_merc_lim_atk_1"; break;
        case 93: sTag="MirtupiSaltacharcos"; break;
        case 94: sTag="enano_merc_river_road"; break;
        case 95: sTag="GranCelrigodeEldat"; break;
        case 96: sTag="atk_llanos_he"; break;
        case 97: sTag="cervezas"; break;
        case 98: sTag="grombarbanieve"; break;
        case 99: sTag="uri_belina"; break;
        case 100: sTag="uri_belstar"; break;
        case 101: sTag="uri_caerdrath"; break;
        case 102: sTag="uri_marec"; break;
        case 103: sTag="uri_Medianocomerciante"; break;
        case 104: sTag="uri_tenderamercaderes32"; break;
        case 105: sTag="uri_Brainchua"; break;
        case 106: sTag="uri_Dineirith"; break;
        case 107: sTag="uri_Udum"; break;
        case 108: sTag="uri_vyatri"; break;
        case 109: sTag="ciudad_picohierro"; break;
        case 110: sTag="tienda_rastreador_2"; break;
        case 111: sTag="ko_nash_jasha"; break;
        case 112: sTag="codruma"; break;
        case 113: sTag="Taarin"; break;
        case 114: sTag="ko_tiendahospicio"; break;
        case 115: sTag="luc_crim_terrina"; break;
        case 116: sTag="comerciante_merc_esmel_4"; break;
        case 117: sTag="cuidadorestablos_crimmor"; break;
        case 118: sTag="estudioso_esmel_mago"; break;
        case 119: sTag="crim_hasband"; break;
        case 120: sTag="crim_mti_darvinalba1"; break;
        case 121: sTag="luc_crim_chyna"; break;
        case 122: sTag="VistoRilifarBarleman"; break;
        case 123: sTag="anticuario_brinnley"; break;
        case 124: sTag="qua_tienleg"; break;
        case 125: sTag="uri_domadorcaballos"; break;
        case 126: sTag="soldadolegionferreavend"; break;
        case 127: sTag="cuida_cuernotronante"; break;
        case 128: sTag="establos_gambitron"; break;
        case 129: sTag="Amg_medtiendajoyas"; break;
        case 130: sTag="cuidadorestablos_inmescar"; break;
        case 131: sTag="mti_rayhiel"; break;
        case 132: sTag="mti_dandristie"; break;
        case 133: sTag="emilse_imn_monti"; break;
        case 134: sTag="Kikri"; break;
        case 135: sTag="tienda_pergaschamus"; break;
        case 136: sTag="tyr_imnesposadero"; break;
        case 137: sTag="cuidadorestablos_rompe"; break;
        case 138: sTag="jj_toigan"; break;
        case 139: sTag="gof_mujerRunas"; break;
        case 140: sTag="gof_tiendapija"; break;
        case 141: sTag="jj_bunus"; break;
        case 142: sTag="gof_Glebur"; break;
        case 143: sTag="cuidadorestablos_edive"; break;
        case 144: sTag="tiendamagiaedive"; break;
        case 145: sTag="uri_asesinoarcano"; break;
        case 146: sTag="posadaedivevis"; break;
        case 147: sTag="afil_imzel"; break;
        case 148: sTag="bel_uthgard"; break;
        case 149: sTag="uri_cuidadorestablos_ideepton"; break;
        case 150: sTag="uri_urgdret"; break;
        case 151: sTag="cuidadorestablos_minsnor"; break;
        case 152: sTag="min_armeria"; break;
        case 153: sTag="General_almacenMinsor"; break;
        case 154: sTag="posada_misnor"; break;
        case 155: sTag="asyel_herreromurann"; break;
        case 156: sTag="asyel_murann_identificador"; break;
        case 157: sTag="asyel_murannposadero"; break;
        case 158: sTag="ko_templo_murann"; break;
        case 159: sTag="cuidad_carreteratezhyr"; break;
        case 160: sTag="cuidadorestablos_murann"; break;
        case 161: sTag="go_murann"; break;
        case 162: sTag="murann_comer"; break;
        case 163: sTag="trasgovendor"; break;
        case 164: sTag="cuidadorestablos_nashkel"; break;
        case 165: sTag="ko_torrealta_miller"; break;
        case 166: sTag="Mortimer"; break;
        case 167: sTag="ko_nash_salla"; break;
        case 168: sTag="ko_nash_laura_kensiddar"; break;
        case 169: sTag="Asyel_Layla"; break;
        case 170: sTag="Asyel_Troka"; break;
        case 171: sTag="bi_elurion"; break;
        case 172: sTag="mti_ele_edereth"; break;
        case 173: sTag="Vylmarius"; break;
        case 174: sTag="galdrim_mercanci"; break;
        case 175: sTag="cuidadorestablos_purskul"; break;
        case 176: sTag="BikinGranjarra"; break;
        case 177: sTag="darwi_merina"; break;
        case 178: sTag="EmeleeModista"; break;
        case 179: sTag="psk_herrero1"; break;
        case 180: sTag="psk_joyero1"; break;
        case 181: sTag="zapatera_purskul"; break;
        case 182: sTag="WP_esmel_t_epico"; break;
        case 183: sTag="almacenelfico"; break;
        case 184: sTag="almacenelfico02"; break;
        case 185: sTag="tienda_herreria";break;
        case 186: sTag="tienda_artarcana";break;
        case 187: sTag="tienda_turakIII";break;
        case 188: sTag="tienda_Shea";break;
        case 189: sTag="tienda_emnnesah";break;
        case 190: sTag="tienda_minarcano";break;
        case 191: sTag="tienda_monje";break;
        case 192: sTag="temp_polvora";break;
        case 193: sTag="eneno_armas_gambiton";break;
        case 194: sTag="tienda_arual";break;
        case 195: sTag="tienda_Ifalna2";break;
        case 196: sTag="mus_posada";break;
        case 197: sTag="bz_rak_tienda";break;
        case 198: sTag="kro_kraztemploGlebur";break;
        case 199: sTag="kro_aventureroEkmus";break;
        case 200: sTag="leti_selunemarSacerdotisa1";break;
        case 201: sTag="leti_selunemarSacerdotisa2";break;
    }
    return sTag;
}

void main()
{

     object oMod = GetModule();
     string sTagTienda;
     int i, iPCItem;
     SetLocalInt(oMod, "Limpieza", 1);
     object oTienda,oItem;
     SendMessageToAllDMs ("Se ha iniciado el proceso de limpieza de todas las tiendas del servidor.");
     for (i=0; i<201; i++)
     {
        sTagTienda = Tag_Tienda(i);
        oTienda= GetObjectByTag(sTagTienda);
        object oItem = GetFirstItemInInventory(oTienda);
        while(oItem != OBJECT_INVALID)
        {

            iPCItem = GetLocalInt(oItem, "PCItem");  //Objeto obtenido por jugador
            if (iPCItem==1) { DestroyObject(oItem);}
            oItem = GetNextItemInInventory(oTienda);
        }
        if (GetStoreMaxBuyPrice(oTienda)>1){
            if (GetLocalInt(oTienda,"tienda_basica")==1 && (GetStoreGold(oTienda)<10000)){
                SetStoreGold(oTienda, 100000000);
            }else{
                SetStoreGold(oTienda, 5000000);
            }
        }
    }
    DelayCommand(43200.0, SetLocalInt(oMod, "Limpieza", 0));  //43200 sg = 12horas reales.
    SendMessageToAllDMs ("Proceso de limpieza de todas las tiendas del servidor concluido.");

}
