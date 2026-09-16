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
/// ----------------------------------------------------------------------------

#include "mti_libreria"

/// Written to the player's variable container once the store has been converted.
const string ALM_MIGRADO = "CNR_ALMACEN_MIGRADO";

/// Written once the essences and crystals have been moved to the short keys.
const string ALM_RENOMBRADO = "CNR_ALMACEN_RENOMBRADO";

/// How many essences and crystals exist, so the rename knows what to look for.
const int ALM_NUM_ESENCIAS = 129;
const int ALM_NUM_CRISTALES = 6;

/// @brief Move a stored quantity from an old key to its CNR equivalent.
/// @param oPC The player.
/// @param sVieja The old persistent key.
/// @param sNueva The CNR key that replaces it.
/// @param sNombre What to call it when telling the player.
/// @returns The quantity moved, 0 when there was nothing stored.
int AlmMigraUno(object oPC, string sVieja, string sNueva, string sNombre)
{
    int nCantidad = ObtenerIntPersistente(oPC, sVieja);
    BorrarIntPersistente(oPC, sVieja);
    if (nCantidad <= 0)
    {
        return 0;
    }

    GuardarIntPersistente(oPC, sNueva,
        ObtenerIntPersistente(oPC, sNueva) + nCantidad);
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

/// @brief Convert this character's store, once.
/// @param oPC The player who opened the store.
void AlmMigrar(object oPC)
{
    AlmRenombrar(oPC);

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
    nConv += AlmMigraUno(oPC, "cuerocani", "cuero_mitica", "Cueros de can infernal:");
    nConv += AlmMigraUno(oPC, "cuerocierv", "cuero_herbivoro", "Cueros de ciervo:");
    nConv += AlmMigraUno(oPC, "cuerojabal", "cuero_bestia", "Cueros de jabalí:");
    nConv += AlmMigraUno(oPC, "cuerolagar", "cuero_bestia", "Cueros de lagarto:");
    nConv += AlmMigraUno(oPC, "cueroloboi", "cuero_mitica", "Cueros de lobo invernal:");
    nConv += AlmMigraUno(oPC, "cuerolobo", "cuero_bestia", "Cueros de lobo:");
    nConv += AlmMigraUno(oPC, "cueromurci", "cuero_roedor", "Cueros de murciélago:");
    nConv += AlmMigraUno(oPC, "cuerooso", "cuero_bestiag", "Cueros de oso:");
    nConv += AlmMigraUno(oPC, "cuerorata", "cuero_roedor", "Cueros de rata:");
    nConv += AlmMigraUno(oPC, "cuerorothe", "cuero_herbivoro", "Cueros de rothé:");
    nConv += AlmMigraUno(oPC, "cueroserpi", "cuero_bestia", "Cueros de serpiente:");
    nConv += AlmMigraUno(oPC, "lingoteAceroscuro", "lingoteaceroscur", "Lingote de aceroscuro:");
    nConv += AlmMigraUno(oPC, "lingoteadamantita", "lingoteadamantit", "Lingotes de adamantita:");
    nConv += AlmMigraUno(oPC, "lingotehierrofrio", "lingotehierrofri", "Lingotes de hierrofrío:");
    nConv += AlmMigraUno(oPC, "pellejorata", "pielroedor", "Pellejos de rata:");
    nConv += AlmMigraUno(oPC, "pielcani", "pielmitica", "Pieles de can infernal:");
    nConv += AlmMigraUno(oPC, "pielcierv", "pielherbivoro", "Pieles de ciervo:");
    nConv += AlmMigraUno(oPC, "pieljabal", "pielbestia", "Pieles de jabali:");
    nConv += AlmMigraUno(oPC, "piellagar", "pielbestia", "Pieles de lagarto:");
    nConv += AlmMigraUno(oPC, "pielloboi", "pielmitica", "Pieles de lobo invernal:");
    nConv += AlmMigraUno(oPC, "piellobo", "pielbestia", "Pieles de lobo:");
    nConv += AlmMigraUno(oPC, "pielmurci", "pielroedor", "Pieles de murcielago:");
    nConv += AlmMigraUno(oPC, "pieloso", "pielbestiag", "Pieles de oso:");
    nConv += AlmMigraUno(oPC, "pielrata", "pielroedor", "Pieles de rata:");
    nConv += AlmMigraUno(oPC, "pielrothe", "pielherbivoro", "Pieles de rothe:");
    nConv += AlmMigraUno(oPC, "pielserpi", "pielbestia", "Pieles de serpiente:");
    nConv += AlmMigraUno(oPC, "virutasresplandecientes", "virutasresplande", "Virutas resplandecientes:");

    // Materials the CNR does not use. Nothing replaces them, so they go,
    // and the player is told what was in there rather than finding it gone.
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC08", "Abdómenes de escarabajo:");
    nBaja += AlmRetiraUno(oPC, "AceiteSigilo", "Aceites de oliva:");
    nBaja += AlmRetiraUno(oPC, "sute_her_DM1", "Aguas puras:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_muni", "Aletas de locathah:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal201", "Aleteos de sagifalco juvenil:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab32", "Antenas de grilio:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_lim02", "Armazones de siv:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_car3", "Astucia de arpía:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab28", "Astucia de márilith:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC23", "Belladonas:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab00", "Bellezas cegadoras de ninfa:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_inconj", "Bellezas sobrenaturales de clangarconte:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab21", "Bolsas viscosas de bestia del caos:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_rc", "Brasas de Azer:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal209", "Brillos de magmino:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab03", "Cabellos de ghaele:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab22", "Cadenas de kiton:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal205", "Calimas de zombi de bruma tirana:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_car2", "Caparazones de ankheg:");
    nBaja += AlmRetiraUno(oPC, "Caracoldetierraof", "Caracoles de tierra:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal208", "Carnes pegajosas de regresado:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe06", "Carnes putrefactas del señor de las momias:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_rd", "Carroñas de Xorn:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_dano08", "Caspa de ibrandlin:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab29", "Castigos de nálfeshni:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_ca", "Cataclismos de tarasca:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_dano13", "Claridad de nyzh:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_dano01", "Colmillos de abishái:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe01", "Concentración de diablo astado:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab09", "Conchas de tojánida:");
    nBaja += AlmRetiraUno(oPC, "basura_concha", "Conchas:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal212", "Consunciones de incorpóreo aterrador:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab35", "Contratos de kolyarut:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab23", "Corazones negro de pesadilla:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal102", "Cornaduras de unicornio negro:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_lim05", "Cortezas de árbol oscuro:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab36", "Crestas de dragón tortuga:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC11", "Cristales de cuarzo:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_poten2", "Cristales urdímbricos de Fénix:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_poten4", "Cristales urdímbricos de Leviatán:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_poten1", "Cristales urdímbricos de Nishruu:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_poten3", "Cristales urdímbricos de Quimera:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe18", "Crueldades de lamia:");
    nBaja += AlmRetiraUno(oPC, "gz_it_rope", "Cuerdas con garfio:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_at", "Cuernos de behir:");
    nBaja += AlmRetiraUno(oPC, "cuerowyrm", "Cueros de draco:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_lim03", "Cáscaras de batraco:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal214", "Deambulamientos de rávido:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_car1", "Dentinas de bestia oscurecida:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_vo", "Derribos de sabueso yez:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal207", "Descomposiciones de broza movediza:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_clas02", "Devociones de mártir:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC06", "Dientes de bodak:");
    nBaja += AlmRetiraUno(oPC, "dientetiburon", "Dientes de tiburón:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal200", "Dádivas de archiliche:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab10", "Elasticidad de fasmo:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_car5", "Encantos de dríada:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_clas01", "Encantos de lilenda:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_clas10", "Enigmas de ginoesfinge:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_dano06", "Escamas de asabi:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal204", "Espectros de réprobo:");
    nBaja += AlmRetiraUno(oPC, "espejodemano", "Espejos de mano:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_dano10", "Espolones de dragónido:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe20", "Estallidos de diablo de la sima:");
    nBaja += AlmRetiraUno(oPC, "estatuasirena", "Estatuas de sirena:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab33", "Estragos de quimera:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal203", "Eteriedad de serpiente de hielo:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab18", "Excrecencias ósea de abolez mago:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_dano12", "Faz de hybsil:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab38", "Ferocidad de erinia:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_clas03", "Fervores de ent:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab01", "Firmeza de titán:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab11", "Flautines de sátiro:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco2", "Fragmentos de gólem de amatista:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco5", "Fragmentos de gólem de citrino:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco6", "Fragmentos de gólem de diamante:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco4", "Fragmentos de gólem de esmeralda:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco3", "Fragmentos de gólem de rubí:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco1", "Fragmentos de gólem de topacio:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_gemco0", "Fragmentos de gólem de zafiro:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_refor", "Galope de centauro:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe00", "Gas de dragón de oropel:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC07", "Glándulas de seda de trácnido:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_dano07", "Gotas de ábalin:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab25", "Gracia de sirénido:");
    nBaja += AlmRetiraUno(oPC, "Guadelaventurero", "Guías comerciales:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_dano09", "Hálitos de dragón del canto:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_clas07", "Instintos de lobo terrible:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab20", "Instrucciones telepáticas de formícida reina:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal213", "Lenguas bífidas de Yuan-ti:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_peso", "Levitaciones de lamparconte:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal103", "Liviandad de béstia de Xvim:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab15", "Locura de derro:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab07", "Luces carmesí de liche:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab31", "Luces cegadoras de bezekira:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe19", "Mandíbulas de aranea:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_TRAP001", "Materiales de trampero menor, estacas:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_cm", "Mordiscos de perro de guerra nessiano:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab13", "Mudez de birlador etéreo:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab12", "Músculos de planotáreo:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_clas06", "Nobleza de grifo:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_dano05", "Ojos de contemplador:");
    nBaja += AlmRetiraUno(oPC, "NW_IT_MSMLMISC09", "Ojos de rakshasa:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal101", "Ojos oscuros carmesí de tritón de fuego:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_car4", "Ojos rojos de medusa:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab26", "Patas zancudas de aquerena:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_lim01", "Pelajes de araña subterránea:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_dano02", "Pesuños de bestia de Málar:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab27", "Pezuñas de pegaso:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab17", "Picos de águila gigante:");
    nBaja += AlmRetiraUno(oPC, "x1_it_msmlmisc01", "Piedras frías:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_reg", "Pieles correosas de troll cazador:");
    nBaja += AlmRetiraUno(oPC, "pielwyrm", "Pieles de draco:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab30", "Pigmentaciones de mimeto:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab24", "Pinzas de glabrezu:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe25", "Plagas de murciélagos:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_lim04", "Plumas de aarakocra:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_clas09", "Plumas de couatl:");
    nBaja += AlmRetiraUno(oPC, "nw_it_creitem201", "Plumas de gaviota:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab14", "Plumazón de roc:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab02", "Podredumbres de babau:");
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
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab06", "Presas de búho gigante:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe02", "Presas de gusano púrpura:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab04", "Protecciones de solar:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe15", "Puños de trueno de marut:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe09", "Púas afiladas de gelugón:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab16", "Púas de salamandra:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal215", "Resistencias de slaad:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_rv", "Sangres de vampiro:");
    nBaja += AlmRetiraUno(oPC, "polvodia", "Saquitos de arenilla de diamante:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab37", "Siluetas serpentiforme de behir:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab05", "Siseos de ahogador:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_dano11", "Tentáculos de yokhol:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal211", "Tez de Fee'ri:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_hab08", "Tinieblas de noctámbulo:");
    nBaja += AlmRetiraUno(oPC, "x2_it_dyel23", "Tintes de cuero negro:");
    nBaja += AlmRetiraUno(oPC, "x2_it_dyel48", "Tintes de cuero verde:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_mej", "Tutelaje de deva astral:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_dano00", "Vellosidades de alaghi:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe07", "Verrugas de saga nocturna:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_sal206", "Vuelos de semicelestial:");
    nBaja += AlmRetiraUno(oPC, "HC_Tinderbox", "Yesca y pedernal:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe05", "Zarpas de can trasguero:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_car0", "Ímpetu de gigante de la niebla:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe03", "Óculos de bocón barbotante:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe16", "Órbitas oculares de grimórlock:");
    nBaja += AlmRetiraUno(oPC, "pb_artesa_efe14", "Órganos sensoriales de hongo fantasmal:");
    GuardarIntPersistente(oPC, ALM_MIGRADO, 1);

    if (nConv > 0 || nBaja > 0)
    {
        SendMessageToPC(oPC, "Almacen adaptado al oficio nuevo: "
            + IntToString(nConv) + " convertidas, "
            + IntToString(nBaja) + " retiradas.");
    }
}
