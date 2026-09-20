/// ----------------------------------------------------------------------------
/// @system  CNR Almacen
/// @file    sapo_alma_migr
/// @author  Dhraax
/// @brief   One-shot conversion of what a character has stored in the material
///          store, from the old trade's materials to the CNR ones.
///
///          It runs when the store is opened, not on login: the store is the
///          only thing that owns this data, a character who never opens one
///          never needs it, and the login path stays untouched.
///
///          Two things guard it. The flag below is written once the conversion
///          has run, and the old keys are deleted in the same pass, so even a
///          lost flag cannot convert twice: there would be nothing left to
///          read.
///
///          Quantities are added, never replaced: five roedor hides already
///          stored plus twelve converted rat hides make seventeen.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "mti_libreria"

/// Written to the player's variable container once the store has been converted.
const string ALM_MIGRADO = "CNR_ALMACEN_MIGRADO";

/// Written once the essences and crystals have been moved to the short keys.
const string ALM_RENOMBRADO = "CNR_ALMACEN_RENOMBRADO";

/// Written once the gems have been moved to the short keys.
const string ALM_GEMAS = "CNR_ALMACEN_GEMAS";

/// Written once the materials, components and tools have been moved to the
/// short keys.
const string ALM_MATERIALES = "CNR_ALMACEN_MATERIALES";

/// How many essences and crystals exist, so the rename knows what to look for.
const int ALM_NUM_ESENCIAS = 129;
const int ALM_NUM_CRISTALES = 6;

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Add an old stored quantity to its replacement and remove the old key.
/// @param oPC Player whose variable container owns the quantities.
/// @param sVieja Old persistent key.
/// @param sNueva Replacement persistent key.
/// @param sNombre Player-facing material label.
/// @returns Quantity moved, or zero when the old key has no positive quantity.
int AlmMigraUno(object oPC, string sVieja, string sNueva, string sNombre);

/// @brief Remove a stored material that is no longer used.
/// @param oPC Player whose variable container owns the quantity.
/// @param sVieja Retired persistent key.
/// @param sNombre Player-facing material label.
/// @returns Quantity removed, or zero when the old key has no positive quantity.
int AlmRetiraUno(object oPC, string sVieja, string sNombre);

/// @brief Add a stored quantity to its renamed key without per-material messages.
/// @param oPC Player whose variable container owns the quantities.
/// @param sVieja Old persistent key.
/// @param sNueva Replacement persistent key.
/// @returns Quantity moved, or zero when the old key has no positive quantity.
int AlmMueveClave(object oPC, string sVieja, string sNueva);

/// @brief Rename stored CNR essences and crystals once.
/// @param oPC Player opening the material store.
void AlmRenombrar(object oPC);

/// @brief Rename stored rough and cut gems once.
/// @param oPC Player opening the material store.
void AlmRenombrarGemas(object oPC);

/// @brief Rename stored materials, components and tools once.
/// @param oPC Player opening the material store.
void AlmRenombrarMateriales(object oPC);

/// @brief Convert surviving legacy holdings and retire only unused materials.
/// @param oPC Player opening the material store.
void AlmMigrar(object oPC);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

/// @brief Move a stored quantity from an old key to its CNR equivalent.
/// @param oPC The player.
/// @param sVieja The old persistent key.
/// @param sNueva The CNR key that replaces it.
/// @param sNombre What to call it when telling the player.
/// @returns The quantity moved, 0 when there was nothing stored.
int AlmMigraUno(object oPC, string sVieja, string sNueva, string sNombre)
{
    int nCantidad = ObtenerIntPersistente(oPC, sVieja);
    if (nCantidad <= 0)
    {
        BorrarIntPersistente(oPC, sVieja);
        return 0;
    }

    GuardarIntPersistente(oPC, sNueva,
        ObtenerIntPersistente(oPC, sNueva) + nCantidad);
    BorrarIntPersistente(oPC, sVieja);
    SendMessageToPC(oPC, "Convertido: " + sNombre + IntToString(nCantidad));
    return nCantidad;
}

/// @brief Drop a stored quantity whose material no longer exists.
/// @param oPC The player.
/// @param sVieja The old persistent key.
/// @param sNombre What to call it when telling the player.
/// @returns The quantity dropped, 0 when there was nothing stored.
int AlmRetiraUno(object oPC, string sVieja, string sNombre)
{
    int nCantidad = ObtenerIntPersistente(oPC, sVieja);
    BorrarIntPersistente(oPC, sVieja);
    if (nCantidad <= 0)
    {
        return 0;
    }

    SendMessageToPC(oPC, "Se retira del oficio antiguo: " + sNombre
        + IntToString(nCantidad));
    return nCantidad;
}

/// @brief Move a stored quantity from one key to another, without saying so.
/// @param oPC The player.
/// @param sVieja The old persistent key.
/// @param sNueva The key that replaces it.
/// @returns The quantity moved, 0 when there was nothing stored.
int AlmMueveClave(object oPC, string sVieja, string sNueva)
{
    int nCantidad = ObtenerIntPersistente(oPC, sVieja);
    BorrarIntPersistente(oPC, sVieja);
    if (nCantidad <= 0)
    {
        return 0;
    }

    GuardarIntPersistente(oPC, sNueva,
        ObtenerIntPersistente(oPC, sNueva) + nCantidad);
    return nCantidad;
}

/// @brief Carry the stored essences and crystals over to the short CNR keys.
///
///        The store first accepted them as cnr_esen<n> and cnr_cristal<n>. The
///        naming normalisation renamed both families to cnr_e_<n> and
///        cnr_c_<n>, and the key a quantity lives under is the resref, so a
///        quantity stored under the old key would no longer be read. This pass
///        moves it. It is the same material either way, so it says nothing to
///        the player beyond the total.
///
///        It has its own flag because the old-trade conversion may already have
///        run under ALM_MIGRADO, and the old keys are deleted as they are read,
///        so a lost flag cannot move anything twice.
/// @param oPC The player who opened the store.
void AlmRenombrar(object oPC)
{
    if (ObtenerIntPersistente(oPC, ALM_RENOMBRADO) > 0)
    {
        return;
    }

    int nMovidas = 0;
    int i;

    for (i = 1; i <= ALM_NUM_ESENCIAS; i++)
    {
        nMovidas += AlmMueveClave(oPC, "cnr_esen" + IntToString(i),
                                       "cnr_e_" + IntToString(i));
    }

    for (i = 1; i <= ALM_NUM_CRISTALES; i++)
    {
        nMovidas += AlmMueveClave(oPC, "cnr_cristal" + IntToString(i),
                                       "cnr_c_" + IntToString(i));
    }

    GuardarIntPersistente(oPC, ALM_RENOMBRADO, 1);

    if (nMovidas > 0)
    {
        SendMessageToPC(oPC, "Almacen: " + IntToString(nMovidas)
            + " unidad(es) de esencias y cristales pasan al nombre nuevo.");
    }
}

/// @brief Carry the stored gems over to the short CNR keys.
///
///        Slice 3 of the naming normalisation renamed the 28 rough stones and
///        the 28 cut ones. The legacy suffixes did not agree with each other -
///        the rough amethyst was bru_per and the rough red tear bru_lagrimar
///        while the king's tear was bru_lagrey - so this is a table, not a
///        prefix rule, and it is written out one line per stone.
/// @param oPC The player who opened the store.
void AlmRenombrarGemas(object oPC)
{
    if (ObtenerIntPersistente(oPC, ALM_GEMAS) > 0)
    {
        return;
    }

    int nMovidas = 0;

    // The rough stones, out of a vein.
    nMovidas += AlmMueveClave(oPC, "bru_amar", "cnr_g_amar");
    nMovidas += AlmMueveClave(oPC, "bru_per", "cnr_g_amat");
    nMovidas += AlmMueveClave(oPC, "bru_aza", "cnr_g_aza");
    nMovidas += AlmMueveClave(oPC, "bru_barra", "cnr_g_barra");
    nMovidas += AlmMueveClave(oPC, "bru_bel", "cnr_g_bel");
    nMovidas += AlmMueveClave(oPC, "bru_cor", "cnr_g_cor");
    nMovidas += AlmMueveClave(oPC, "bru_cuarzo", "cnr_g_cuar");
    nMovidas += AlmMueveClave(oPC, "bru_diam", "cnr_g_diam");
    nMovidas += AlmMueveClave(oPC, "bru_esme", "cnr_g_esme");
    nMovidas += AlmMueveClave(oPC, "bru_jac", "cnr_g_jac");
    nMovidas += AlmMueveClave(oPC, "bru_jade", "cnr_g_jade");
    nMovidas += AlmMueveClave(oPC, "bru_lagrey", "cnr_g_lagrey");
    nMovidas += AlmMueveClave(oPC, "bru_lagrimar", "cnr_g_lagroj");
    nMovidas += AlmMueveClave(oPC, "bru_obs", "cnr_g_obs");
    nMovidas += AlmMueveClave(oPC, "bru_opalo", "cnr_g_opalo");
    nMovidas += AlmMueveClave(oPC, "bru_opaloa", "cnr_g_opaloa");
    nMovidas += AlmMueveClave(oPC, "bru_opalof", "cnr_g_opalof");
    nMovidas += AlmMueveClave(oPC, "bru_opalon", "cnr_g_opalon");
    nMovidas += AlmMueveClave(oPC, "bru_orblen", "cnr_g_orblen");
    nMovidas += AlmMueveClave(oPC, "bru_orlo", "cnr_g_orlo");
    nMovidas += AlmMueveClave(oPC, "bru_picara", "cnr_g_pic");
    nMovidas += AlmMueveClave(oPC, "bru_rubi", "cnr_g_rubi");
    nMovidas += AlmMueveClave(oPC, "bru_rubiestre", "cnr_g_rubie");
    nMovidas += AlmMueveClave(oPC, "bru_top", "cnr_g_top");
    nMovidas += AlmMueveClave(oPC, "bru_zaf", "cnr_g_zaf");
    nMovidas += AlmMueveClave(oPC, "bru_zafestre", "cnr_g_zafe");
    nMovidas += AlmMueveClave(oPC, "bru_zafnegro", "cnr_g_zafn");
    nMovidas += AlmMueveClave(oPC, "bru_zen", "cnr_g_zen");

    // The cut stones, off the jeweller's bench.
    nMovidas += AlmMueveClave(oPC, "cnr_amar", "cnr_q_amar");
    nMovidas += AlmMueveClave(oPC, "cnr_per", "cnr_q_amat");
    nMovidas += AlmMueveClave(oPC, "cnr_aza", "cnr_q_aza");
    nMovidas += AlmMueveClave(oPC, "cnr_barra", "cnr_q_barra");
    nMovidas += AlmMueveClave(oPC, "cnr_bel", "cnr_q_bel");
    nMovidas += AlmMueveClave(oPC, "cnr_cor", "cnr_q_cor");
    nMovidas += AlmMueveClave(oPC, "cnr_cuarzo", "cnr_q_cuar");
    nMovidas += AlmMueveClave(oPC, "cnr_diam", "cnr_q_diam");
    nMovidas += AlmMueveClave(oPC, "cnr_esme", "cnr_q_esme");
    nMovidas += AlmMueveClave(oPC, "cnr_jac", "cnr_q_jac");
    nMovidas += AlmMueveClave(oPC, "cnr_jade", "cnr_q_jade");
    nMovidas += AlmMueveClave(oPC, "cnr_lagrey", "cnr_q_lagrey");
    nMovidas += AlmMueveClave(oPC, "cnr_lagrimar", "cnr_q_lagroj");
    nMovidas += AlmMueveClave(oPC, "cnr_obs", "cnr_q_obs");
    nMovidas += AlmMueveClave(oPC, "cnr_opalo", "cnr_q_opalo");
    nMovidas += AlmMueveClave(oPC, "cnr_opaloa", "cnr_q_opaloa");
    nMovidas += AlmMueveClave(oPC, "cnr_opalof", "cnr_q_opalof");
    nMovidas += AlmMueveClave(oPC, "cnr_opalon", "cnr_q_opalon");
    nMovidas += AlmMueveClave(oPC, "cnr_orblen", "cnr_q_orblen");
    nMovidas += AlmMueveClave(oPC, "cnr_orlo", "cnr_q_orlo");
    nMovidas += AlmMueveClave(oPC, "cnr_picara", "cnr_q_pic");
    nMovidas += AlmMueveClave(oPC, "cnr_rubi", "cnr_q_rubi");
    nMovidas += AlmMueveClave(oPC, "cnr_rubiestre", "cnr_q_rubie");
    nMovidas += AlmMueveClave(oPC, "cnr_top", "cnr_q_top");
    nMovidas += AlmMueveClave(oPC, "cnr_zaf", "cnr_q_zaf");
    nMovidas += AlmMueveClave(oPC, "cnr_zafestre", "cnr_q_zafe");
    nMovidas += AlmMueveClave(oPC, "cnr_zafnegro", "cnr_q_zafn");
    nMovidas += AlmMueveClave(oPC, "cnr_zen", "cnr_q_zen");

    GuardarIntPersistente(oPC, ALM_GEMAS, 1);

    if (nMovidas > 0)
    {
        SendMessageToPC(oPC, "Almacen: " + IntToString(nMovidas)
            + " gema(s) pasan al nombre nuevo.");
    }
}

/// @brief Carry the stored materials and components over to the short CNR keys.
///
///        Slice 4 of the naming normalisation renamed nuggets, ingots, hides,
///        leathers, logs, planks, plants, reagents and the jeweller's and
///        carpenter's stock. Sixty-seven of the store's entries kept their
///        quantity under the old resref and move here, one line each because
///        the new names follow the displayed wood and the vein, not a prefix.
///        The entries whose key was never the resref (lenyo*, tablon*,
///        polvo*) keep that key and need nothing.
///
///        polvodia is one of them. It used to sit in the retirement list below,
///        because the store had no entry for diamond dust and a quantity under
///        a key nothing reads is a quantity nobody can take out. The store
///        accepts cnr_p_po_diam under that same key now, so retiring it would
///        delete a material the trade has. The line is gone.
/// @param oPC The player who opened the store.
void AlmRenombrarMateriales(object oPC)
{
    if (ObtenerIntPersistente(oPC, ALM_MATERIALES) > 0)
    {
        return;
    }

    int nMovidas = 0;

    nMovidas += AlmMueveClave(oPC, "ardordesertico", "cnr_p_ardor");
    nMovidas += AlmMueveClave(oPC, "bayaacuosa", "cnr_p_baya");
    nMovidas += AlmMueveClave(oPC, "brisasusurrante", "cnr_p_brisa");
    nMovidas += AlmMueveClave(oPC, "cuero_bestiag", "cnr_m_cu_bestiag");
    nMovidas += AlmMueveClave(oPC, "cuero_miticag", "cnr_m_cu_miticag");
    nMovidas += AlmMueveClave(oPC, "cuero_mitica", "cnr_m_cu_mitica");
    nMovidas += AlmMueveClave(oPC, "cuero_bestia", "cnr_m_cu_bestia");
    nMovidas += AlmMueveClave(oPC, "cuero_dragoa", "cnr_m_cu_dracoa");
    nMovidas += AlmMueveClave(oPC, "cuero_dragof", "cnr_m_cu_dracof");
    nMovidas += AlmMueveClave(oPC, "cuero_dragoh", "cnr_m_cu_dracoh");
    nMovidas += AlmMueveClave(oPC, "cuero_dragor", "cnr_m_cu_dracor");
    nMovidas += AlmMueveClave(oPC, "cuero_herbivoro", "cnr_m_cu_herbiv");
    nMovidas += AlmMueveClave(oPC, "cuero_roedor", "cnr_m_cu_roedor");
    nMovidas += AlmMueveClave(oPC, "esenciainvisible", "cnr_p_esencinv");
    nMovidas += AlmMueveClave(oPC, "especiasulfurosa", "cnr_p_especia");
    nMovidas += AlmMueveClave(oPC, "florluminosa", "cnr_p_flor");
    nMovidas += AlmMueveClave(oPC, "frutofantasma", "cnr_p_fruto");
    nMovidas += AlmMueveClave(oPC, "humogaseoso", "cnr_p_humo");
    nMovidas += AlmMueveClave(oPC, "limoputrefacto", "cnr_p_limo");
    nMovidas += AlmMueveClave(oPC, "lingoteaceroscur", "cnr_m_li_oscuro");
    nMovidas += AlmMueveClave(oPC, "lingoteadamantit", "cnr_m_li_adaman");
    nMovidas += AlmMueveClave(oPC, "lingoteArandur", "cnr_m_li_arandur");
    nMovidas += AlmMueveClave(oPC, "lingoteDlarun", "cnr_m_li_dlarun");
    nMovidas += AlmMueveClave(oPC, "lingoteDerretido", "cnr_m_li_enardec");
    nMovidas += AlmMueveClave(oPC, "lingotehierrofri", "cnr_m_li_frio");
    nMovidas += AlmMueveClave(oPC, "lingoteHizagkuur", "cnr_m_li_hizag");
    nMovidas += AlmMueveClave(oPC, "lingoteMetalvivo", "cnr_m_li_vivo");
    nMovidas += AlmMueveClave(oPC, "lingotePlatino", "cnr_m_li_platino");
    nMovidas += AlmMueveClave(oPC, "lingoteacero", "cnr_m_li_acero");
    nMovidas += AlmMueveClave(oPC, "lingotecobre", "cnr_m_li_cobre");
    nMovidas += AlmMueveClave(oPC, "lingotehierro", "cnr_m_li_hierro");
    nMovidas += AlmMueveClave(oPC, "lingotemithril", "cnr_m_li_mithril");
    nMovidas += AlmMueveClave(oPC, "lingoteoro", "cnr_m_li_oro");
    nMovidas += AlmMueveClave(oPC, "lingoteplata", "cnr_m_li_plata");
    nMovidas += AlmMueveClave(oPC, "pastaterrosa", "cnr_p_pasta");
    nMovidas += AlmMueveClave(oPC, "pepitaArandur", "cnr_m_pe_arandur");
    nMovidas += AlmMueveClave(oPC, "pepitaCarbon", "cnr_m_pe_carbon");
    nMovidas += AlmMueveClave(oPC, "pepitaDlarun", "cnr_m_pe_dlarun");
    nMovidas += AlmMueveClave(oPC, "pepitaAceroscuro", "cnr_m_pe_oscuro");
    nMovidas += AlmMueveClave(oPC, "pepitaHizagkuur", "cnr_m_pe_hizag");
    nMovidas += AlmMueveClave(oPC, "pepitaDerretido", "cnr_m_pe_enardec");
    nMovidas += AlmMueveClave(oPC, "pepitaMetalvivo", "cnr_m_pe_vivo");
    nMovidas += AlmMueveClave(oPC, "pepitaPlatino", "cnr_m_pe_platino");
    nMovidas += AlmMueveClave(oPC, "pepitaacero", "cnr_m_pe_acero");
    nMovidas += AlmMueveClave(oPC, "pepitaadamantita", "cnr_m_pe_adaman");
    nMovidas += AlmMueveClave(oPC, "pepitacobre", "cnr_m_pe_cobre");
    nMovidas += AlmMueveClave(oPC, "pepitahierro", "cnr_m_pe_hierro");
    nMovidas += AlmMueveClave(oPC, "pepitahierrofrio", "cnr_m_pe_frio");
    nMovidas += AlmMueveClave(oPC, "pepitamithril", "cnr_m_pe_mithril");
    nMovidas += AlmMueveClave(oPC, "pepitaoro", "cnr_m_pe_oro");
    nMovidas += AlmMueveClave(oPC, "pepitaplata", "cnr_m_pe_plata");
    nMovidas += AlmMueveClave(oPC, "picadarocosa", "cnr_p_picada");
    nMovidas += AlmMueveClave(oPC, "pielbestiag", "cnr_m_pi_bestiag");
    nMovidas += AlmMueveClave(oPC, "pielmiticag", "cnr_m_pi_miticag");
    nMovidas += AlmMueveClave(oPC, "pielmitica", "cnr_m_pi_mitica");
    nMovidas += AlmMueveClave(oPC, "pielbestia", "cnr_m_pi_bestia");
    nMovidas += AlmMueveClave(oPC, "pieldracoa", "cnr_m_pi_dracoa");
    nMovidas += AlmMueveClave(oPC, "pieldracof", "cnr_m_pi_dracof");
    nMovidas += AlmMueveClave(oPC, "pieldracoh", "cnr_m_pi_dracoh");
    nMovidas += AlmMueveClave(oPC, "pieldracor", "cnr_m_pi_dracor");
    nMovidas += AlmMueveClave(oPC, "pielherbivoro", "cnr_m_pi_herbiv");
    nMovidas += AlmMueveClave(oPC, "pielroedor", "cnr_m_pi_roedor");
    nMovidas += AlmMueveClave(oPC, "raizpetrea", "cnr_p_raiz");
    nMovidas += AlmMueveClave(oPC, "resinasubterrane", "cnr_p_resina");
    nMovidas += AlmMueveClave(oPC, "setanocturna", "cnr_p_seta");
    nMovidas += AlmMueveClave(oPC, "virutasresplande", "cnr_p_virutas");
    nMovidas += AlmMueveClave(oPC, "zumoacuoso", "cnr_p_zumo");

    GuardarIntPersistente(oPC, ALM_MATERIALES, 1);

    if (nMovidas > 0)
    {
        SendMessageToPC(oPC, "Almacen: " + IntToString(nMovidas)
            + " material(es) pasan al nombre nuevo.");
    }
}

/// @brief Convert this character's store, once.
/// @param oPC The player who opened the store.
void AlmMigrar(object oPC)
{
    AlmRenombrar(oPC);
    AlmRenombrarGemas(oPC);
    AlmRenombrarMateriales(oPC);

    if (ObtenerIntPersistente(oPC, ALM_MIGRADO) > 0)
    {
        return;
    }

    int nConv = 0;
    int nBaja = 0;

    // The old hides and leathers, by animal, into the ten CNR materials.
    // The four ingots and the resin whose resref was cut to sixteen
    // characters move to the corrected key, which is where the list now
    // reads them from.
    nConv += AlmMigraUno(oPC, "cuerocani", "cnr_m_cu_mitica", "Cueros de can infernal:");
    nConv += AlmMigraUno(oPC, "cuerocierv", "cnr_m_cu_herbiv", "Cueros de ciervo:");
    nConv += AlmMigraUno(oPC, "cuerojabal", "cnr_m_cu_bestia", "Cueros de jabalí:");
    nConv += AlmMigraUno(oPC, "cuerolagar", "cnr_m_cu_bestia", "Cueros de lagarto:");
    nConv += AlmMigraUno(oPC, "cueroloboi", "cnr_m_cu_mitica", "Cueros de lobo invernal:");
    nConv += AlmMigraUno(oPC, "cuerolobo", "cnr_m_cu_bestia", "Cueros de lobo:");
    nConv += AlmMigraUno(oPC, "cueromurci", "cnr_m_cu_roedor", "Cueros de murciélago:");
    nConv += AlmMigraUno(oPC, "cuerooso", "cnr_m_cu_bestiag", "Cueros de oso:");
    nConv += AlmMigraUno(oPC, "cuerorata", "cnr_m_cu_roedor", "Cueros de rata:");
    nConv += AlmMigraUno(oPC, "cuerorothe", "cnr_m_cu_herbiv", "Cueros de rothé:");
    nConv += AlmMigraUno(oPC, "cueroserpi", "cnr_m_cu_bestia", "Cueros de serpiente:");
    nConv += AlmMigraUno(oPC, "lingoteAceroscuro", "cnr_m_li_oscuro", "Lingote de aceroscuro:");
    nConv += AlmMigraUno(oPC, "lingoteadamantita", "cnr_m_li_adaman", "Lingotes de adamantita:");
    nConv += AlmMigraUno(oPC, "lingotehierrofrio", "cnr_m_li_frio", "Lingotes de hierrofrío:");
    nConv += AlmMigraUno(oPC, "pellejorata", "cnr_m_pi_roedor", "Pellejos de rata:");
    nConv += AlmMigraUno(oPC, "pielcani", "cnr_m_pi_mitica", "Pieles de can infernal:");
    nConv += AlmMigraUno(oPC, "pielcierv", "cnr_m_pi_herbiv", "Pieles de ciervo:");
    nConv += AlmMigraUno(oPC, "pieljabal", "cnr_m_pi_bestia", "Pieles de jabali:");
    nConv += AlmMigraUno(oPC, "piellagar", "cnr_m_pi_bestia", "Pieles de lagarto:");
    nConv += AlmMigraUno(oPC, "pielloboi", "cnr_m_pi_mitica", "Pieles de lobo invernal:");
    nConv += AlmMigraUno(oPC, "piellobo", "cnr_m_pi_bestia", "Pieles de lobo:");
    nConv += AlmMigraUno(oPC, "pielmurci", "cnr_m_pi_roedor", "Pieles de murcielago:");
    nConv += AlmMigraUno(oPC, "pieloso", "cnr_m_pi_bestiag", "Pieles de oso:");
    nConv += AlmMigraUno(oPC, "pielrata", "cnr_m_pi_roedor", "Pieles de rata:");
    nConv += AlmMigraUno(oPC, "pielrothe", "cnr_m_pi_herbiv", "Pieles de rothe:");
    nConv += AlmMigraUno(oPC, "pielserpi", "cnr_m_pi_bestia", "Pieles de serpiente:");
    nConv += AlmMigraUno(oPC, "virutasresplandecientes", "cnr_p_virutas", "Virutas resplandecientes:");

    // Preserve the Arcane materials still named by the current design.
    // Quimera and Leviatan crystals continue as Hada and Dragon.
    nConv += AlmMigraUno(oPC, "pb_artesa_sal201", "cnr_e_38", "Aleteos de sagifalco juvenil:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab32", "cnr_e_2", "Antenas de grilio:");
    nConv += AlmMigraUno(oPC, "pb_artesa_car3", "cnr_e_32", "Astucia de arpía:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab28", "cnr_e_62", "Astucia de márilith:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab00", "cnr_e_18", "Bellezas cegadoras de ninfa:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab21", "cnr_e_1", "Bolsas viscosas de bestia del caos:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal209", "cnr_e_39", "Brillos de magmino:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab03", "cnr_e_11", "Cabellos de ghaele:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab22", "cnr_e_24", "Cadenas de kiton:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal205", "cnr_e_44", "Calimas de zombi de bruma tirana:");
    nConv += AlmMigraUno(oPC, "pb_artesa_car2", "cnr_e_31", "Caparazones de ankheg:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal208", "cnr_e_45", "Carnes pegajosas de regresado:");
    nConv += AlmMigraUno(oPC, "pb_artesa_efe06", "cnr_e_84", "Carnes putrefactas del señor de las momias:");
    nConv += AlmMigraUno(oPC, "pb_artesa_rd", "cnr_e_91", "Carroñas de Xorn:");
    nConv += AlmMigraUno(oPC, "pb_artesa_dano08", "cnr_e_72", "Caspa de ibrandlin:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab29", "cnr_e_21", "Castigos de nálfeshni:");
    nConv += AlmMigraUno(oPC, "pb_artesa_dano13", "cnr_e_67", "Claridad de nyzh:");
    nConv += AlmMigraUno(oPC, "pb_artesa_dano01", "cnr_e_64", "Colmillos de abishái:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab09", "cnr_e_26", "Conchas de tojánida:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal212", "cnr_e_41", "Consunciones de incorpóreo aterrador:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab23", "cnr_e_4", "Corazones negro de pesadilla:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal102", "cnr_e_48", "Cornaduras de unicornio negro:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab36", "cnr_e_17", "Crestas de dragón tortuga:");
    nConv += AlmMigraUno(oPC, "pb_artesa_poten2", "cnr_c_2", "Cristales urdímbricos de Fénix:");
    nConv += AlmMigraUno(oPC, "pb_artesa_poten4", "cnr_c_4", "Cristales urdímbricos de Leviatán:");
    nConv += AlmMigraUno(oPC, "pb_artesa_poten1", "cnr_c_1", "Cristales urdímbricos de Nishruu:");
    nConv += AlmMigraUno(oPC, "pb_artesa_poten3", "cnr_c_3", "Cristales urdímbricos de Quimera:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal214", "cnr_e_42", "Deambulamientos de rávido:");
    nConv += AlmMigraUno(oPC, "pb_artesa_car1", "cnr_e_30", "Dentinas de bestia oscurecida:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal207", "cnr_e_35", "Descomposiciones de broza movediza:");
    nConv += AlmMigraUno(oPC, "pb_artesa_clas02", "cnr_e_51", "Devociones de mártir:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal200", "cnr_e_50", "Dádivas de archiliche:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab10", "cnr_e_15", "Elasticidad de fasmo:");
    nConv += AlmMigraUno(oPC, "pb_artesa_car5", "cnr_e_34", "Encantos de dríada:");
    nConv += AlmMigraUno(oPC, "pb_artesa_clas01", "cnr_e_52", "Encantos de lilenda:");
    nConv += AlmMigraUno(oPC, "pb_artesa_clas10", "cnr_e_53", "Enigmas de ginoesfinge:");
    nConv += AlmMigraUno(oPC, "pb_artesa_dano06", "cnr_e_69", "Escamas de asabi:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal204", "cnr_e_46", "Espectros de réprobo:");
    nConv += AlmMigraUno(oPC, "pb_artesa_dano10", "cnr_e_66", "Espolones de dragónido:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab33", "cnr_e_23", "Estragos de quimera:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal203", "cnr_e_40", "Eteriedad de serpiente de hielo:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab18", "cnr_e_5", "Excrecencias ósea de abolez mago:");
    nConv += AlmMigraUno(oPC, "pb_artesa_dano12", "cnr_e_74", "Faz de hybsil:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab38", "cnr_e_60", "Ferocidad de erinia:");
    nConv += AlmMigraUno(oPC, "pb_artesa_clas03", "cnr_e_54", "Fervores de ent:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab01", "cnr_e_7", "Firmeza de titán:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab11", "cnr_e_6", "Flautines de sátiro:");
    nConv += AlmMigraUno(oPC, "pb_artesa_refor", "cnr_e_89", "Galope de centauro:");
    nConv += AlmMigraUno(oPC, "pb_artesa_efe00", "cnr_e_81", "Gas de dragón de oropel:");
    nConv += AlmMigraUno(oPC, "pb_artesa_dano07", "cnr_e_70", "Gotas de ábalin:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab25", "cnr_e_27", "Gracia de sirénido:");
    nConv += AlmMigraUno(oPC, "pb_artesa_dano09", "cnr_e_68", "Hálitos de dragón del canto:");
    nConv += AlmMigraUno(oPC, "pb_artesa_clas07", "cnr_e_55", "Instintos de lobo terrible:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab20", "cnr_e_14", "Instrucciones telepáticas de formícida reina:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal213", "cnr_e_36", "Lenguas bífidas de Yuan-ti:");
    nConv += AlmMigraUno(oPC, "pb_artesa_peso", "cnr_e_92", "Levitaciones de lamparconte:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal103", "cnr_e_49", "Liviandad de béstia de Xvim:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab31", "cnr_e_90", "Luces cegadoras de bezekira:");
    nConv += AlmMigraUno(oPC, "pb_artesa_efe19", "cnr_e_76", "Mandíbulas de aranea:");
    nConv += AlmMigraUno(oPC, "pb_artesa_cm", "cnr_e_87", "Mordiscos de perro de guerra nessiano:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab13", "cnr_e_9", "Mudez de birlador etéreo:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab12", "cnr_e_25", "Músculos de planotáreo:");
    nConv += AlmMigraUno(oPC, "pb_artesa_clas06", "cnr_e_57", "Nobleza de grifo:");
    nConv += AlmMigraUno(oPC, "pb_artesa_dano05", "cnr_e_75", "Ojos de contemplador:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal101", "cnr_e_47", "Ojos oscuros carmesí de tritón de fuego:");
    nConv += AlmMigraUno(oPC, "pb_artesa_car4", "cnr_e_33", "Ojos rojos de medusa:");
    nConv += AlmMigraUno(oPC, "pb_artesa_lim01", "cnr_e_71", "Pelajes de araña subterránea:");
    nConv += AlmMigraUno(oPC, "pb_artesa_dano02", "cnr_e_63", "Pesuños de bestia de Málar:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab27", "cnr_e_20", "Pezuñas de pegaso:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab17", "cnr_e_12", "Picos de águila gigante:");
    nConv += AlmMigraUno(oPC, "pb_artesa_reg", "cnr_e_93", "Pieles correosas de troll cazador:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab30", "cnr_e_22", "Pigmentaciones de mimeto:");
    nConv += AlmMigraUno(oPC, "pb_artesa_efe25", "cnr_e_77", "Plagas de murciélagos:");
    nConv += AlmMigraUno(oPC, "pb_artesa_clas09", "cnr_e_56", "Plumas de couatl:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab14", "cnr_e_8", "Plumazón de roc:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab02", "cnr_e_28", "Podredumbres de babau:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab06", "cnr_e_13", "Presas de búho gigante:");
    nConv += AlmMigraUno(oPC, "pb_artesa_efe02", "cnr_e_78", "Presas de gusano púrpura:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab04", "cnr_e_10", "Protecciones de solar:");
    nConv += AlmMigraUno(oPC, "pb_artesa_efe15", "cnr_e_79", "Puños de trueno de marut:");
    nConv += AlmMigraUno(oPC, "pb_artesa_efe09", "cnr_e_88", "Púas afiladas de gelugón:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab16", "cnr_e_3", "Púas de salamandra:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal215", "cnr_e_37", "Resistencias de slaad:");
    nConv += AlmMigraUno(oPC, "pb_artesa_rv", "cnr_e_86", "Sangres de vampiro:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab37", "cnr_e_19", "Siluetas serpentiforme de behir:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab05", "cnr_e_16", "Siseos de ahogador:");
    nConv += AlmMigraUno(oPC, "pb_artesa_dano11", "cnr_e_73", "Tentáculos de yokhol:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal211", "cnr_e_43", "Tez de Fee'ri:");
    nConv += AlmMigraUno(oPC, "pb_artesa_hab08", "cnr_e_59", "Tinieblas de noctámbulo:");
    nConv += AlmMigraUno(oPC, "pb_artesa_mej", "cnr_e_61", "Tutelaje de deva astral:");
    nConv += AlmMigraUno(oPC, "pb_artesa_dano00", "cnr_e_65", "Vellosidades de alaghi:");
    nConv += AlmMigraUno(oPC, "pb_artesa_efe07", "cnr_e_85", "Verrugas de saga nocturna:");
    nConv += AlmMigraUno(oPC, "pb_artesa_sal206", "cnr_e_58", "Vuelos de semicelestial:");
    nConv += AlmMigraUno(oPC, "pb_artesa_efe05", "cnr_e_80", "Zarpas de can trasguero:");
    nConv += AlmMigraUno(oPC, "pb_artesa_car0", "cnr_e_29", "Ímpetu de gigante de la niebla:");
    nConv += AlmMigraUno(oPC, "pb_artesa_efe03", "cnr_e_82", "Óculos de bocón barbotante:");
    nConv += AlmMigraUno(oPC, "pb_artesa_efe14", "cnr_e_83", "Órganos sensoriales de hongo fantasmal:");

    // Materials the CNR does not use. Nothing replaces them, so they go,
    // and the player is told what was in there rather than finding it gone.
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC08", "Abdómenes de escarabajo:");
    nBaja += AlmRetiraUno(oPC, "AceiteSigilo", "Aceites de oliva:");
    nBaja += AlmRetiraUno(oPC, "sute_her_DM1", "Aguas puras:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_muni", "Aletas de locathah:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_lim02", "Armazones de siv:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC23", "Belladonas:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_inconj", "Bellezas sobrenaturales de clangarconte:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_rc", "Brasas de Azer:");
    nBaja += AlmRetiraUno(oPC, "Caracoldetierraof", "Caracoles de tierra:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_ca", "Cataclismos de tarasca:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe01", "Concentración de diablo astado:");
    nBaja += AlmRetiraUno(oPC, "basura_concha", "Conchas:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab35", "Contratos de kolyarut:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_lim05", "Cortezas de árbol oscuro:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC11", "Cristales de cuarzo:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe18", "Crueldades de lamia:");
    nBaja += AlmRetiraUno(oPC, "gz_it_rope", "Cuerdas con garfio:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_at", "Cuernos de behir:");
    nBaja += AlmRetiraUno(oPC, "cuerowyrm", "Cueros de draco:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_lim03", "Cáscaras de batraco:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_vo", "Derribos de sabueso yez:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC06", "Dientes de bodak:");
    nBaja += AlmRetiraUno(oPC, "dientetiburon", "Dientes de tiburón:");
    nBaja += AlmRetiraUno(oPC, "espejodemano", "Espejos de mano:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe20", "Estallidos de diablo de la sima:");
    nBaja += AlmRetiraUno(oPC, "estatuasirena", "Estatuas de sirena:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco2", "Fragmentos de gólem de amatista:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco5", "Fragmentos de gólem de citrino:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco6", "Fragmentos de gólem de diamante:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco4", "Fragmentos de gólem de esmeralda:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco3", "Fragmentos de gólem de rubí:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco1", "Fragmentos de gólem de topacio:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco0", "Fragmentos de gólem de zafiro:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC07", "Glándulas de seda de trácnido:");
    nBaja += AlmRetiraUno(oPC, "Guadelaventurero", "Guías comerciales:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab15", "Locura de derro:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab07", "Luces carmesí de liche:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_TRAP001", "Materiales de trampero menor, estacas:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC09", "Ojos de rakshasa:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab26", "Patas zancudas de aquerena:");
    nBaja += AlmRetiraUno(oPC, "x1_it_msmlmisc01", "Piedras frías:");
    nBaja += AlmRetiraUno(oPC, "pielwyrm", "Pieles de draco:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab24", "Pinzas de glabrezu:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_lim04", "Plumas de aarakocra:");
    nBaja += AlmRetiraUno(oPC, "nw_it_creitem201", "Plumas de gaviota:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_polvo1", "Polvos de abjuración:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_polvo3", "Polvos de adivinación:");
    nBaja += AlmRetiraUno(oPC, "polvoantiluzof", "Polvos de antiluz:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_polvo2", "Polvos de conjuración:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_polvo4", "Polvos de encantamiento:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_polvo5", "Polvos de evocación:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC19", "Polvos de hada:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_polvo6", "Polvos de ilusión:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_polvo7", "Polvos de nigromancia:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_polvo8", "Polvos de transmutación:");
    nBaja += AlmRetiraUno(oPC, "x2_it_dyel23", "Tintes de cuero negro:");
    nBaja += AlmRetiraUno(oPC, "x2_it_dyel48", "Tintes de cuero verde:");
    nBaja += AlmRetiraUno(oPC, "HC_Tinderbox", "Yesca y pedernal:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe16", "Órbitas oculares de grimórlock:");
    GuardarIntPersistente(oPC, ALM_MIGRADO, 1);

    if (nConv > 0 || nBaja > 0)
    {
        SendMessageToPC(oPC, "Almacen adaptado al oficio nuevo: "
            + IntToString(nConv) + " convertidas, "
            + IntToString(nBaja) + " retiradas.");
    }
}
