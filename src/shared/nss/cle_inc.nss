#include "mti_libreria"

// Funcion para avisar al PJ de que el area es marcable
void cle_warning(object oPC);
// Obtiene el nombre del área que ha sido marcada en la posicion elegida
string ObtenerNombreAreaMemorizadaPalabraRegreso1(object oPC);
string ObtenerNombreAreaMemorizadaPalabraRegreso2(object oPC);
string ObtenerNombreAreaMemorizadaPalabraRegreso3(object oPC);

// Teleporta al PJ al lugar memorizado elegido
void AplicarTeleportPalabraRegreso(object oPC, string sNombreAreaMemorizada);

string ObtenerNombreAreaMemorizadaPalabraRegreso1(object oPC)
{
    return ObtenerStringPersistente(oPC, "PALABRA_REGRESO_LOC1_NOMBRE");
}
string ObtenerNombreAreaMemorizadaPalabraRegreso2(object oPC)
{
    return ObtenerStringPersistente(oPC, "PALABRA_REGRESO_LOC2_NOMBRE");
}
string ObtenerNombreAreaMemorizadaPalabraRegreso3(object oPC)
{
    return ObtenerStringPersistente(oPC, "PALABRA_REGRESO_LOC3_NOMBRE");
}

void cle_warning(object oPC)
{
  if(GetLocalInt(GetArea(oPC), "CLEREGRESABLE") == TRUE)
  {
      if(!GetIsPC(oPC) || GetIsDM(oPC)) return;

      int iNivelClerigo = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
      int iNivelDruida = GetLevelByClass(CLASS_TYPE_DRUID, oPC);

      if(iNivelClerigo >= 11 || iNivelDruida >= 15 ||
         GetIsObjectValid(GetItemPossessedBy(oPC, "perga_regreso11"))) SendMessageToPC(oPC,"<c´þd>Este lugar puede ser marcado como seguro para el conjuro 'Palabra de regreso'.</c>");
  }
}

void AplicarTeleportPalabraRegreso(object oPC, string sNombreAreaMemorizada)
{
    string sDestino;

    if(sNombreAreaMemorizada == "Athkatla - Exteriores - Agujas de Oro - Templo de Waukeen") sDestino = "salir_aguj_oro";

    else if(sNombreAreaMemorizada == "Caravasar - Templo de Waukeen") sDestino = "cle_regreso_caravasar_waukin";

    else if(sNombreAreaMemorizada == "Athkatla - Alcantarillas - Templo de Mâskhara") sDestino = "clr_templomascara";

    else if(sNombreAreaMemorizada == "Athkatla - Distrito del río - La Corona de Cobre") sDestino = "clr_atk_coronacobre";

    else if(sNombreAreaMemorizada == "Athkatla - Distrito de la guardia - Mancebía de los Siete Valles") sDestino = "clr_mancebiavalles";

    else if(sNombreAreaMemorizada == "Athkatla - Distrito de la guardia - Las Cinco Jarras") sDestino = "WP_entra_5jarras";

    else if(sNombreAreaMemorizada == "Athkatla - Distrito de la gema - Cúpula de la Rosa") sDestino = "WP_gemtolath";

    else if(sNombreAreaMemorizada == "Athkatla - Distrito portuario - Regalo del Mar") sDestino = "clr_atk_regalodelmar";

    else if(sNombreAreaMemorizada == "Athkatla - Distrito portuario - Templo de Oghma") sDestino = "WP_kro_oghma_to_muelles";

    else if(sNombreAreaMemorizada == "Athkatla - Distrito portuario - Cofradía de los Ladrones de Sombras") sDestino = "clr_atk_cofradialadrones";

    else if(sNombreAreaMemorizada == "Athkatla - Distrito del templo - Templo de Perdición") sDestino = "cle_bane";

    else if(sNombreAreaMemorizada == "Athkatla - Distrito del templo - Castillo del Guantelete") sDestino = "WP_min_encastillos";

    else if(sNombreAreaMemorizada == "Athkatla - Exteriores - Los Llanos - Hospicio de San Annur") sDestino = "clr_atk_hospicio";

    else if(sNombreAreaMemorizada == "Athkatla - Exteriores - Los Llanos - La Luz de Alandor") sDestino = "WP_AlandorPosadRegreso";

    else if(sNombreAreaMemorizada == "Caravasar - La Gema de los Deseos") sDestino = "WP_car_to_casino";

    else if(sNombreAreaMemorizada == "Bosque de Alandor II") sDestino = "clr_wel_nor";

    else if(sNombreAreaMemorizada == "Bosque de Alandor I - Claro de Eldat") sDestino = "clr_par_sedefaccion";

    else if(sNombreAreaMemorizada == "Crimmor - Encrucijada - Templo de Chauntea") sDestino = "cle_luc_crimmor_02";

    else if(sNombreAreaMemorizada == "Crimmor - Puerto - La Espiral de las Almas") sDestino = "Cleregresabletemplokelemvor";

    else if(sNombreAreaMemorizada == "Crimmor - Encrucijada - El Rastro de Tymora") sDestino = "cle_crimmor_tymora";

    else if(sNombreAreaMemorizada == "Camino del comercio - Sur de Imnescar - Templo de Khauntea") sDestino = "clr_imne_chauntea";

    else if(sNombreAreaMemorizada == "Imnescar - Alrededores - Abadía de Hydcont") sDestino = "wp_temp_selune";

    else if(sNombreAreaMemorizada == "Imnescar - Templo Loviatar") sDestino = "wp_templo_loviatar";

    else if(sNombreAreaMemorizada == "Kazad Gromdal - Templo del Morndinsamman") sDestino = "WP_ko_kazad_templo_entrada";

    else if(sNombreAreaMemorizada == "Athkatla - Distrito del templo - Salones Espumargéntea") sDestino = "WP_temtoposada";

    else if(sNombreAreaMemorizada == "Muranndin - Puerto - El Orco Feliz") sDestino = "WP_murport_to_orco";

    else if(sNombreAreaMemorizada == "Muranndin - Jotunheim - Palacio del Murkul") sDestino = "WP_palmurk_to_murann";

    else if(sNombreAreaMemorizada == "Muranndin - Túmulo - Interior") sDestino = "torre_invertida_tel";

    else if(sNombreAreaMemorizada == "Muranndin - Puerto - Templo de Umberlee") sDestino = "cle_umberlee";

    else if(sNombreAreaMemorizada == "Náshkel - Interiores") sDestino = "cle_nash_luznorte";

    else if(sNombreAreaMemorizada == "Náshkel - La Luz del Norte") sDestino = "ko_nash_int_03";

    else if(sNombreAreaMemorizada == "Púrskul - Encrucijada - El Grano Maduro") sDestino = "clr_purskul_posada";

    else if(sNombreAreaMemorizada == "Crimmor - Encrucijada - Teatro de la Alegría") sDestino = "cle_luc_crimmor_04";

    else if(sNombreAreaMemorizada == "Athkatla - Exteriores - Río de Alandor - Profundidades - Cripta de Bodhi - Interiores") sDestino = "cle_bodhi";

    else if(sNombreAreaMemorizada == "Enclave de Tethir - Interiores I") sDestino = "WP_elfitoposada";

    else if(sNombreAreaMemorizada == "Muranndin - Puerto - Torre de Shangalar") sDestino = "torre_invertida_tel";

    else if(sNombreAreaMemorizada == "Athkatla - Exteriores - Gambiton - La Gambitaberna") sDestino = "clr_gambi_posada";

    else if(sNombreAreaMemorizada == "Athkatla - Distrito portuario - Capilla de Cyric") sDestino = "clr_cyric";

    else if(sNombreAreaMemorizada == "Imnescar - Sede del Acero Argénteo") sDestino = "clr_acero";

    else if(sNombreAreaMemorizada == "Athkatla - Distrito del templo - Templo de Perdición") sDestino = "cle_bane";

    object oDestino = GetWaypointByTag(sDestino);
    int nivelpj = GetLevelByClass (CLASS_TYPE_CLERIC,oPC);
    int alineamientopj = GetAlignmentGoodEvil(oPC);
    effect eSummon1 = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    effect eSummon2 = EffectVisualEffect(VFX_FNF_WORD);
    effect eSummon3 = EffectVisualEffect(VFX_FNF_PWKILL);
    effect eSummon4 = EffectVisualEffect(VFX_FNF_TIME_STOP);
    location lTarget = GetLocation(oDestino);

    if(alineamientopj == ALIGNMENT_GOOD) ApplyEffectToObject(DURATION_TYPE_INSTANT,eSummon2,oPC);
    else if (alineamientopj == ALIGNMENT_EVIL) ApplyEffectToObject(DURATION_TYPE_INSTANT,eSummon3,oPC);
    else  ApplyEffectToObject(DURATION_TYPE_INSTANT,eSummon4,oPC);

    DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

    //Modificación 29/09/2024: Ya no tepea a todo el grupo, es individual.
    /*int iNumeroMaximoTeleportPJs;
    if(nivelpj >= 0 && nivelpj <= 11) iNumeroMaximoTeleportPJs = 3;
    else if(nivelpj >= 12 && nivelpj <= 14) iNumeroMaximoTeleportPJs = 4;
    else if(nivelpj >= 15 && nivelpj <= 17) iNumeroMaximoTeleportPJs = 5;
    else if(nivelpj >= 18 && nivelpj <= 20) iNumeroMaximoTeleportPJs = 6;
    else if(nivelpj >= 21 && nivelpj <= 23) iNumeroMaximoTeleportPJs = 7;
    else if(nivelpj >= 24) iNumeroMaximoTeleportPJs = 8;

    object oPJCercanoGrupo = GetFirstFactionMember(oPC, TRUE);
    while(GetIsObjectValid(oPJCercanoGrupo) == TRUE)
    {
        if(iNumeroMaximoTeleportPJs > 0                &&
           GetDistanceBetween(oPC, oPJCercanoGrupo) <= 3.0  &&
           GetDistanceBetween(oPC, oPJCercanoGrupo) >= 0.0  &&
           oPJCercanoGrupo != oPC &&
           GetIsDM(oPJCercanoGrupo) == FALSE)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon1, oPJCercanoGrupo);
            DelayCommand(1.9, AssignCommand(oPJCercanoGrupo, ClearAllActions()));
            DelayCommand(2.0, AssignCommand(oPJCercanoGrupo, ActionJumpToLocation(lTarget)));

            iNumeroMaximoTeleportPJs = iNumeroMaximoTeleportPJs - 1;
        }

        oPJCercanoGrupo = GetNextFactionMember(oPC, TRUE);
    }   */
}
