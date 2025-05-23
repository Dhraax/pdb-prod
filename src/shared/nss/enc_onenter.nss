//::////////////////////////////////////////////////////////////////////////////
//:: Sistema de Generador de Encuentros aleatorios. By Darth
//:: Este Script debe colocarse en el Evento OnEnter del Area.
//::////////////////////////////////////////////////////////////////////////////
//::
//::    Instrucciones:
//::    Se deben insertar las variables tipo INT de nivel, tipo de encuentro y numero de spawns en las propiedades del area:
//::
//::    "NIVEL_ENCUENTRO" con un valor de 0 a 4
//::    "TIPO_ENCUENTRO" con un valor de 0 a 6
//::    "SPAWN_ENCUENTRO" un numero del 1 al 9 de waypoints creados (Salen aleatoriamente de 2 a 8 enemigos por spawn)
//::
//::    Posteriormente en el area se deben crear los waypoints correspondientes con el siguiente nombre;
//::
//::    "SP_ENC_0" "SP_ENC_1" "SP_ENC_2" "SP_ENC_3" "SP_ENC_4" "SP_ENC_5" "SP_ENC_6"...etc Dependiendo del numero asignado en la varible SPAWN_ENCUENTRO max. SP_ENC_9
//::
//::    Y uno para el boss:
//::    "SP_ENC_BOSS"
//::
//::////////////////////////////////////////////////////////////////////////////
//::    ENCUENTRO NIVEL 0 [pensado para niveles 8]
//::    ENCUENTRO NIVEL 1 [pensado para niveles 12]
//::    ENCUENTRO NIVEL 2 [pensado para niveles 16]
//::    ENCUENTRO NIVEL 3 [pensado para niveles 16 y 20]
//::    ENCUENTRO NIVEL 4 [pensado para niveles 20 y Epicos]
//::////////////////////////////////////////////////////////////////////////////
//::    TIPO ENCUENTRO 0: Humanos
//::    TIPO ENCUENTRO 1: Razas Antiguas
//::    TIPO ENCUENTRO 2: No-muertos
//::    TIPO ENCUENTRO 3: Reptiles
//::    TIPO ENCUENTRO 4: Criaturas Magicas
//::    TIPO ENCUENTRO 5: Constructors
//::    TIPO ENCUENTRO 6: Infraoscuridad
//::    TIPO ENCUENTRO 7: Random entre humanos y razas antiguas
//::////////////////////////////////////////////////////////////////////////////

#include "x0_i0_henchman"
#include "nwnx_creature"
#include "enc_apariencia"
#include "x0_i0_destroy"

void AsignarNombre(object oCreature, object oArea)
{
    string sNombre;
    string nRaza;
    string nBossName = GetLocalString(oArea, "NombreBoss");
    int nClass = GetLocalInt(oCreature, "ENC_CLASS");
    int iRaza = GetRacialType(oCreature);

    //Asignamos nombre según raza
        switch(iRaza) {
            case RACIAL_TYPE_ABERRATION: nRaza = "de la Antipoda"; break;
            case RACIAL_TYPE_CONSTRUCT: nRaza = "Constructo"; break;
            case RACIAL_TYPE_ELF: nRaza = "Drow"; break;
            case RACIAL_TYPE_GIANT: nRaza = "Gigante"; break;
            case RACIAL_TYPE_HUMAN: nRaza = "Bandido"; break;
            case RACIAL_TYPE_HUMANOID_GOBLINOID: nRaza = "Trasgo"; break;
            case RACIAL_TYPE_HUMANOID_MONSTROUS: nRaza = "Monstruoso"; break;
            case RACIAL_TYPE_HUMANOID_ORC: nRaza = "Orco"; break;
            case RACIAL_TYPE_HUMANOID_REPTILIAN: nRaza = "Escamoso"; break;
            case RACIAL_TYPE_MAGICAL_BEAST: nRaza = "Magico"; break;
            case RACIAL_TYPE_OUTSIDER: nRaza = "Planario"; break;
            case RACIAL_TYPE_SHAPECHANGER: nRaza = "Licantropo"; break;
            case RACIAL_TYPE_UNDEAD: nRaza = "No-Muerto"; break;
            case RACIAL_TYPE_VERMIN: nRaza = "Tracnido"; break;
            case RACIAL_TYPE_DWARF: nRaza = "Duergar"; break;
            case RACIAL_TYPE_DRAGON: nRaza = "Dragon"; break;
            default: nRaza = "";break;
            }

    //Si tenemos un Boss
    if(nBossName != "")
            {
        if(nClass == CLASS_TYPE_WIZARD) sNombre = "Arcano de "+nBossName;
        else if(nClass == CLASS_TYPE_ROGUE) sNombre = "Agente de "+nBossName;
        else if(nClass == CLASS_TYPE_FIGHTER) sNombre = "Guerrero de "+nBossName;
        else if(nClass == CLASS_TYPE_BARBARIAN) sNombre = "Furia de "+nBossName;
        else if(nClass == CLASS_TYPE_CLERIC) sNombre = "Sacerdote de "+nBossName;
        else if(nClass == CLASS_TYPE_DRUID) sNombre = "Druida de "+nBossName;
        else if(nClass == CLASS_TYPE_RANGER) sNombre = "Explorador de "+nBossName;
        else sNombre = "Siervo de "+nBossName;

        //Si es Esbirro de Elite
        if(GetLocalInt(oCreature, "ENC_ELITE") == 1) sNombre = "Guardian Elite de "+nBossName;
            }
    //Si no tenemos boss
    else
            {
        if(nClass == CLASS_TYPE_WIZARD) sNombre = "Arcano "+nRaza;
        else if(nClass == CLASS_TYPE_ROGUE) sNombre = "Agente "+nRaza;
        else if(nClass == CLASS_TYPE_FIGHTER || nClass == CLASS_TYPE_BARBARIAN) sNombre = "Combatiente "+nRaza;
        else if(nClass == CLASS_TYPE_CLERIC) sNombre = "Sacerdote "+nRaza;
        else if(nClass == CLASS_TYPE_DRUID) sNombre = "Druida "+nRaza;
        else if(nClass == CLASS_TYPE_RANGER) sNombre = "Explorador "+nRaza;
        else sNombre = nRaza;

        //Si es Esbirro de Elite
        if(GetLocalInt(oCreature, "ENC_ELITE") == 1) sNombre = "Jefe Patrulla "+nRaza;
            }

 SetName(oCreature, sNombre);
}

void AsignarNombreBoss(object oCreature, object oArea)
{
  string nName;
  string sNombre;
  int sTipoEncuentro = GetLocalInt(GetArea(oCreature), "TIPO_ENCUENTRO");

    //HUMANOS
    if(sTipoEncuentro == 0)
    {
        switch(d20(2))
        {
              case 1: nName = "Minvam"; break;
              case 2: nName = "Feishem"; break;
              case 3: nName = "Trarth"; break;
              case 4: nName = "Kavizoth"; break;
              case 5: nName = "Bilvosk"; break;
              case 6: nName = "Meber"; break;
              case 7: nName = "Chayne"; break;
              case 8: nName = "Dittmar"; break;
              case 9: nName = "Pierpont"; break;
              case 10: nName = "Bertrand"; break;
              case 11: nName = "Arian"; break;
              case 12: nName = "Miller"; break;
              case 13: nName = "Pawel"; break;
              case 14: nName = "Davin"; break;
              case 15: nName = "Dittmar"; break;
              case 16: nName = "Roddric"; break;
              case 17: nName = "Stedd"; break;
              case 18: nName = "Malark"; break;
              case 19: nName = "Gorstag"; break;
              case 20: nName = "Dorn"; break;
              case 21: nName = "Reshin"; break;
              case 22: nName = "Jazid"; break;
              case 23: nName = "Dallarn"; break;
              case 24: nName = "Tartiez "; break;
              case 25: nName = "Lenoth "; break;
              case 26: nName = "Vor"; break;
              case 27: nName = "Bibral"; break;
              case 28: nName = "Rhibeir"; break;
              case 29: nName = "Femum"; break;
              case 30: nName = "Santernriz"; break;
              case 31: nName = "Bachar"; break;
              case 32: nName = "Sidadild"; break;
              case 33: nName = "Sargam"; break;
              case 34: nName = "Vlaatvood"; break;
              case 35: nName = "Broth"; break;
              case 36: nName = "Derveascez"; break;
              case 37: nName = "Vojuk"; break;
              case 38: nName = "Griff"; break;
              case 39: nName = "Midar"; break;
              case 40: nName = "Zerzelmed"; break;
        }

        //APODOS
        switch(d20(2))
        {
              case 1: sNombre = nName+" Ciervoalto"; break;
              case 2: sNombre = nName+" Coronaherrumbrosa"; break;
              case 3: sNombre = nName+" Toronegro"; break;
              case 4: sNombre = nName+" Castillogris"; break;
              case 5: sNombre = nName+" Maderanegra"; break;
              case 6: sNombre = nName+" Piedra"; break;
              case 7: sNombre = nName+" Jinasqu"; break;
              case 8: sNombre = nName+" Espina"; break;
              case 9: sNombre = nName+" Buenamañana"; break;
              case 10: sNombre = nName+" Ruedaastillada"; break;
              case 11: sNombre = nName+" Zader"; break;
              case 12: sNombre = nName+" El Fuerte"; break;
              case 13: sNombre = nName+" El Grande"; break;
              case 14: sNombre = nName+" El Terrible"; break;
              case 15: sNombre = nName+" Nomegyathi"; break;
              case 16: sNombre = nName+" Clanlash"; break;
              case 17: sNombre = nName+" Avenallena"; break;
              case 18: sNombre = nName+" Monedabrillante"; break;
              case 19: sNombre = nName+" Gryaldeldivi"; break;
              case 20: sNombre = nName+" Vernusk"; break;
              case 21: sNombre = nName+" Altobuscador"; break;
              case 22: sNombre = nName+" Hachahendida"; break;
              case 23: sNombre = nName+" Molinodeviento"; break;
              case 24: sNombre = nName+" Vulmobitvo"; break;
              case 25: sNombre = nName+" Furiasangrienta"; break;
              case 26: sNombre = nName+" Ribera del Río"; break;
              case 27: sNombre = nName+" Glursk"; break;
              case 28: sNombre = nName+" Jummad"; break;
              case 29: sNombre = nName+" Grifo"; break;
              case 30: sNombre = nName+" Caballonegro"; break;
              case 31: sNombre = nName+" Forojahierros"; break;
              case 32: sNombre = nName+" Cerroblanco"; break;
              case 33: sNombre = nName+" Glursk"; break;
              case 34: sNombre = nName+" Musgoverde"; break;
              case 35: sNombre = nName+" Dilbeda"; break;
              case 36: sNombre = nName+" Dedz"; break;
              case 37: sNombre = nName+" Flordearaña"; break;
              case 38: sNombre = nName+" Bakho"; break;
              case 39: sNombre = nName+" Zuvat"; break;
              case 40: sNombre = nName+" El Tuerto"; break;
        }
   }
    //RAZAS ANTIGUAS
    if(sTipoEncuentro == 1)
    {
        switch(d20(2))
        {
            case 1: nName = "Trolgosh"; break;
              case 2: nName = "Drokurm"; break;
              case 3: nName = "Zohlo"; break;
              case 4: nName = "Thraklanam"; break;
              case 5: nName = "Thral’rero"; break;
              case 6: nName = "Krogtak"; break;
              case 7: nName = "Crukk"; break;
              case 8: nName = "Guzkoknagg"; break;
              case 9: nName = "Trog"; break;
              case 10: nName = "Bukk"; break;
              case 11: nName = "Garndug"; break;
              case 12: nName = "Thrunk"; break;
              case 13: nName = "Krurm"; break;
              case 14: nName = "Gurrahlmern"; break;
              case 15: nName = "Thokk"; break;
              case 16: nName = "Olath"; break;
              case 17: nName = "Zumakk"; break;
              case 18: nName = "Zorl"; break;
              case 19: nName = "Drel"; break;
              case 20: nName = "Gilrirggig"; break;
              case 21: nName = "Trozdhor"; break;
              case 22: nName = "Srulmalog"; break;
              case 23: nName = "Koffius"; break;
              case 24: nName = "Huxrym"; break;
              case 25: nName = "Glekrym"; break;
              case 26: nName = "Kuznus"; break;
              case 27: nName = "Tebom"; break;
              case 28: nName = "Trugant"; break;
              case 29: nName = "Rizrog"; break;
              case 30: nName = "Gerbor"; break;
              case 31: nName = "Klildus"; break;
              case 32: nName = "Vrudhor"; break;
              case 33: nName = "Zubbor"; break;
              case 34: nName = "Zulkaz"; break;
              case 35: nName = "Zengu"; break;
              case 36: nName = "Malak"; break;
              case 37: nName = "Iarrut"; break;
              case 38: nName = "Quivilt"; break;
              case 39: nName = "Ykx"; break;
              case 40: nName = "Thyxyx"; break;
        }
        //APODOS
        switch(d20(2))
        {
              case 1: sNombre = nName+" Cuerno de Guerra"; break;
              case 2: sNombre = nName+" Aullido Infernal"; break;
              case 3: sNombre = nName+" Hachafilada"; break;
              case 4: sNombre = nName+" Dientedraco"; break;
              case 5: sNombre = nName+" Rocadespeñada"; break;
              case 6: sNombre = nName+" El Violento"; break;
              case 7: sNombre = nName+" El Tuerto"; break;
              case 8: sNombre = nName+" El Ancestral"; break;
              case 9: sNombre = nName+" Pielnegra"; break;
              case 10: sNombre = nName+" El Furibundo"; break;
              case 11: sNombre = nName+" Dientemellado"; break;
              case 12: sNombre = nName+" Ojovigilante"; break;
              case 13: sNombre = nName+" Grito Abisal"; break;
              case 14: sNombre = nName+" Lanzapiedras"; break;
              case 15: sNombre = nName+" Colmillohuargo"; break;
              case 16: sNombre = nName+" Lobonegro"; break;
              case 17: sNombre = nName+" Martillhueco"; break;
              case 18: sNombre = nName+" El Trueno"; break;
              case 19: sNombre = nName+" Rugetruenos"; break;
              case 20: sNombre = nName+" Puñonegro"; break;
              case 21: sNombre = nName+" Cejapoblada"; break;
              case 22: sNombre = nName+" Alientofétido"; break;
              case 23: sNombre = nName+" Rompehuesos"; break;
              case 24: sNombre = nName+" Destripaelfos"; break;
              case 25: sNombre = nName+" Desplumaelfos"; break;
              case 26: sNombre = nName+" Mataenanos"; break;
              case 27: sNombre = nName+" Dientedraco"; break;
              case 28: sNombre = nName+" Mazaenorme"; break;
              case 29: sNombre = nName+" Cortaárboles"; break;
              case 30: sNombre = nName+" Escupeflemas"; break;
              case 31: sNombre = nName+" Dientesnegros"; break;
              case 32: sNombre = nName+" Aplastatontos"; break;
              case 33: sNombre = nName+" Arrancabezas"; break;
              case 34: sNombre = nName+" Parteflechas"; break;
              case 35: sNombre = nName+" Tresdedos"; break;
              case 36: sNombre = nName+" El Destructo"; break;
              case 37: sNombre = nName+" Montahuargos"; break;
              case 38: sNombre = nName+" Lechematerna"; break;
              case 39: sNombre = nName+" Puñoardiente"; break;
              case 40: sNombre = nName+" Sangreinfernal"; break;
        }
    }
    //NO-MUERTOS
    if(sTipoEncuentro == 2)
    {
        switch(d20(2))
        {
            case 1: nName = "Nikodemus"; break;
              case 2: nName = "Eric"; break;
              case 3: nName = "Ludovic"; break;
              case 4: nName = "Dimitri"; break;
              case 5: nName = "Stanford"; break;
              case 6: nName = "Kenyon"; break;
              case 7: nName = "Omari"; break;
              case 8: nName = "Tariq"; break;
              case 9: nName = "Judah"; break;
              case 10: nName = "Theoderic"; break;
              case 11: nName = "Alexander"; break;
              case 12: nName = "Mabel"; break;
              case 13: nName = "Lustig"; break;
              case 14: nName = "Dumont"; break;
              case 15: nName = "Vicq"; break;
              case 16: nName = "Destat"; break;
              case 17: nName = "Maik"; break;
              case 18: nName = "Ngoc"; break;
              case 19: nName = "Ermintrude"; break;
              case 20: nName = "Kane"; break;
              case 21: nName = "Lambert"; break;
              case 22: nName = "Severinus"; break;
              case 23: nName = "Sinan"; break;
              case 24: nName = "Aiken"; break;
              case 25: nName = "Dedrick"; break;
              case 26: nName = "Mekhi"; break;
              case 27: nName = "Bartholomaeus"; break;
              case 28: nName = "Acerballan"; break;
              case 29: nName = "Amir"; break;
              case 30: nName = "Baruch"; break;
              case 31: nName = "Dorkas"; break;
              case 32: nName = "Garon"; break;
              case 33: nName = "Nikolaus"; break;
              case 34: nName = "Syed"; break;
              case 35: nName = "Zane"; break;
              case 36: nName = "Mandred"; break;
              case 37: nName = "Torgal"; break;
              case 38: nName = "Gorgus"; break;
              case 39: nName = "Zakrias"; break;
              case 40: nName = "Acerballan"; break;
        }
        //APODOS
        switch(d20(2))
        {
              case 1: sNombre = nName+" Máscarapodrida"; break;
              case 2: sNombre = nName+" El Segador"; break;
              case 3: sNombre = nName+" Huesoespina"; break;
              case 4: sNombre = nName+" El Profanador"; break;
              case 5: sNombre = nName+" Dientespodridos"; break;
              case 6: sNombre = nName+" Cráneohendido"; break;
              case 7: sNombre = nName+" Sombratenebrosa"; break;
              case 8: sNombre = nName+" Carcomehuesos"; break;
              case 9: sNombre = nName+" El Adusto"; break;
              case 10: sNombre = nName+" El Corruptor"; break;
              case 11: sNombre = nName+" El Devorador de Esencias"; break;
              case 12: sNombre = nName+" El Loco"; break;
              case 13: sNombre = nName+" El Ermitaño"; break;
              case 14: sNombre = nName+" El Oscuro"; break;
              case 15: sNombre = nName+" Ojo Pérfido"; break;
              case 16: sNombre = nName+" Toquecorruptor"; break;
              case 17: sNombre = nName+" El acechador"; break;
              case 18: sNombre = nName+" Almanegra"; break;
              case 19: sNombre = nName+" Verdugo"; break;
              case 20: sNombre = nName+" Horror Andante"; break;
              case 21: sNombre = nName+" El Sombrío"; break;
              case 22: sNombre = nName+" Espumarajos"; break;
              case 23: sNombre = nName+" Caminatumbas"; break;
              case 24: sNombre = nName+" Danzatripas"; break;
              case 25: sNombre = nName+" Devoraalmas"; break;
              case 26: sNombre = nName+" El Guardián del Sepulcro"; break;
              case 27: sNombre = nName+" El Vigía del Foso"; break;
              case 28: sNombre = nName+" El Enterrador"; break;
              case 29: sNombre = nName+" El Abominable"; break;
              case 30: sNombre = nName+" El Decadente"; break;
              case 31: sNombre = nName+" Mnibetouc"; break;
              case 32: sNombre = nName+" Lengua Negra"; break;
              case 33: sNombre = nName+" Kirul"; break;
              case 34: sNombre = nName+" El Caído"; break;
              case 35: sNombre = nName+" El Olvidado"; break;
              case 36: sNombre = nName+" El Amo de las Mortajaa"; break;
              case 37: sNombre = nName+" Ponzoñavil"; break;
              case 38: sNombre = nName+" Pudrealmas"; break;
              case 39: sNombre = nName+" El Caníbal"; break;
              case 40: sNombre = nName+" Ponzoñavil"; break;
        }
    }
    //REPTILES
    if(sTipoEncuentro == 3)
    {
        switch(d20(2))
        {
            case 1: nName = "Traol"; break;
              case 2: nName = "Thadrass"; break;
              case 3: nName = "Thaggask"; break;
              case 4: nName = "Osrull"; break;
              case 5: nName = "Grugluss"; break;
              case 6: nName = "Thuolluyausk"; break;
              case 7: nName = "Tardsingem"; break;
              case 8: nName = "Cuolboyult"; break;
              case 9: nName = "Esdelere"; break;
              case 10: nName = "Vroten"; break;
              case 11: nName = "Svoboozh"; break;
              case 12: nName = "Droontezh"; break;
              case 13: nName = "Nikoz"; break;
              case 14: nName = "Ses"; break;
              case 15: nName = "Vroruj"; break;
              case 16: nName = "Vadroj"; break;
              case 17: nName = "Bejuzh"; break;
              case 18: nName = "Habus"; break;
              case 19: nName = "Oyuz"; break;
              case 20: nName = "Adron"; break;
              case 21: nName = "Hurnik"; break;
              case 22: nName = "Berdain"; break;
              case 23: nName = "Regtharm"; break;
              case 24: nName = "Magnur"; break;
              case 25: nName = "Darmek"; break;
              case 26: nName = "Rotmond"; break;
              case 27: nName = "Brumnir"; break;
              case 28: nName = "Urmgarn"; break;
              case 29: nName = "Ermkom"; break;
              case 30: nName = "Maleichar"; break;
              case 31: nName = "Gueris"; break;
              case 32: nName = "Meira"; break;
              case 33: nName = "Amrakir"; break;
              case 34: nName = "Hymn"; break;
              case 35: nName = "Oszihsas"; break;
              case 36: nName = "Etlus"; break;
              case 37: nName = "Yatstlotuss"; break;
              case 38: nName = "Shalia"; break;
              case 39: nName = "Shuihlush"; break;
              case 40: nName = "Ahtla"; break;
        }
        //APODOS
        switch(d20(2))
        {
              case 1: sNombre = nName+" El Destructor"; break;
              case 2: sNombre = nName+" Cornada mortal"; break;
              case 3: sNombre = nName+" Surcacielos"; break;
              case 4: sNombre = nName+" Lenguabífida"; break;
              case 5: sNombre = nName+" La Viperina"; break;
              case 6: sNombre = nName+" Lenguavenenosa"; break;
              case 7: sNombre = nName+" La Taimada"; break;
              case 8: sNombre = nName+" La Susurrante"; break;
              case 9: sNombre = nName+" Escamabrillante"; break;
              case 10: sNombre = nName+" Sierpeponzoñosa"; break;
              case 11: sNombre = nName+" Muertebreve"; break;
              case 12: sNombre = nName+" El Ofidio"; break;
              case 13: sNombre = nName+" La Gran Áspid"; break;
              case 14: sNombre = nName+" Ojos de Rubí"; break;
              case 15: sNombre = nName+" Sierpescamosa"; break;
              case 16: sNombre = nName+" Susurratraiciones"; break;
              case 17: sNombre = nName+" Tejehechizos"; break;
              case 18: sNombre = nName+" Quemaldeas"; break;
              case 19: sNombre = nName+" Garrafilada"; break;
              case 20: sNombre = nName+" Colmilloponzoñoso"; break;
              case 21: sNombre = nName+" Pupilarasgada"; break;
              case 22: sNombre = nName+" Dama del Fuego"; break;
              case 23: sNombre = nName+" La Oscura"; break;
              case 24: sNombre = nName+" La Sibilina"; break;
              case 25: sNombre = nName+" La Silenciosa"; break;
              case 26: sNombre = nName+" La Elegida"; break;
              case 27: sNombre = nName+" El Bravo"; break;
              case 28: sNombre = nName+" El Aterrador"; break;
              case 29: sNombre = nName+" Asesino de Héroes"; break;
              case 30: sNombre = nName+" Asesina de Héroes"; break;
              case 31: sNombre = nName+" Campeona Escamosa"; break;
              case 32: sNombre = nName+" La Magnificente"; break;
              case 33: sNombre = nName+" Colmilloraudo"; break;
              case 34: sNombre = nName+" Serpentino"; break;
              case 35: sNombre = nName+" La Damadragón"; break;
              case 36: sNombre = nName+" Largacola"; break;
              case 37: sNombre = nName+" Fuegorápido"; break;
              case 38: sNombre = nName+" Últimascadenas"; break;
              case 39: sNombre = nName+" Forjatraiciones"; break;
              case 40: sNombre = nName+" Terror Volador"; break;
        }
    }
    //BESTIAS MAGICAS
    if(sTipoEncuentro == 4)
    {
        switch(d20(2))
        {
            case 1: nName = "Quarris"; break;
              case 2: nName = "Drallmarauth"; break;
              case 3: nName = "Stratos"; break;
              case 4: nName = "Glacius"; break;
              case 5: nName = "Drol’gan"; break;
              case 6: nName = "Egmarok"; break;
              case 7: nName = "Ar’onith"; break;
              case 8: nName = "Agruuth"; break;
              case 9: nName = "Drumumog"; break;
              case 10: nName = "Azure"; break;
              case 11: nName = "Anaemis"; break;
              case 12: nName = "Zar’gennas"; break;
              case 13: nName = "Malis"; break;
              case 14: nName = "Dez’gadin"; break;
              case 15: nName = "Ozranuth"; break;
              case 16: nName = "Draz’goxoth"; break;
              case 17: nName = "Salgrumath"; break;
              case 18: nName = "Nrongroz"; break;
              case 19: nName = "Or’amach"; break;
              case 20: nName = "Xug’drirud"; break;
              case 21: nName = "Pyroc"; break;
              case 22: nName = "Xozzam"; break;
              case 23: nName = "Dar’arth"; break;
              case 24: nName = "Iglis"; break;
              case 25: nName = "Arkanoth"; break;
              case 26: nName = "Egonzu"; break;
              case 27: nName = "Dabrus"; break;
              case 28: nName = "Xurkamos"; break;
              case 29: nName = "Lanre"; break;
              case 30: nName = "Malov"; break;
              case 31: nName = "Beelguuth"; break;
              case 32: nName = "Gannazag"; break;
              case 33: nName = "Trar’gaz"; break;
              case 34: nName = "Cartos"; break;
              case 35: nName = "Glacis"; break;
              case 36: nName = "Thelmimon"; break;
              case 37: nName = "Loross"; break;
              case 38: nName = "Thoras"; break;
              case 39: nName = "Decess"; break;
              case 40: nName = "Xozgoz"; break;
        }
        //APODOS
        switch(d20(2))
        {
              case 1: sNombre = nName+" El Oráculo"; break;
              case 2: sNombre = nName+" El Ojo de Eirisis"; break;
              case 3: sNombre = nName+" El Pentáculo Mágico"; break;
              case 4: sNombre = nName+" La Corruptora"; break;
              case 5: sNombre = nName+" Sangreabisal"; break;
              case 6: sNombre = nName+" La Herética"; break;
              case 7: sNombre = nName+" Rasgacorazones"; break;
              case 8: sNombre = nName+" Tejemaleficios"; break;
              case 9: sNombre = nName+" La Pérfida"; break;
              case 10: sNombre = nName+" Devoracorazones"; break;
              case 11: sNombre = nName+" Encadenalmas"; break;
              case 12: sNombre = nName+" Presagiomaldito"; break;
              case 13: sNombre = nName+" Hija del Caos"; break;
              case 14: sNombre = nName+" Terrormaldito"; break;
              case 15: sNombre = nName+" Fuegoabisal"; break;
              case 16: sNombre = nName+" Ojos de hielo"; break;
              case 17: sNombre = nName+" Destruyealmas"; break;
              case 18: sNombre = nName+" Garrasafiladas"; break;
              case 19: sNombre = nName+" Púavenenosa"; break;
              case 20: sNombre = nName+" Serpientepétrea"; break;
              case 21: sNombre = nName+" Perdición de la Triada"; break;
              case 22: sNombre = nName+" Bebecráneos"; break;
              case 23: sNombre = nName+" Devorabebés"; break;
              case 24: sNombre = nName+" Perdición de elfos"; break;
              case 25: sNombre = nName+" Perdición de enanos"; break;
              case 26: sNombre = nName+" Purificalmas"; break;
              case 27: sNombre = nName+" La Plaga"; break;
              case 28: sNombre = nName+" La Peste"; break;
              case 29: sNombre = nName+" Hechizacorazones"; break;
              case 30: sNombre = nName+" Sierva del Abismo"; break;
              case 31: sNombre = nName+" Brecha de Sangre"; break;
              case 32: sNombre = nName+" La Desesperación"; break;
              case 33: sNombre = nName+" Reina del Erial"; break;
              case 34: sNombre = nName+" Reina de las Ruinas"; break;
              case 35: sNombre = nName+" Del Foso de Sangre"; break;
              case 36: sNombre = nName+" Del cráter negro"; break;
              case 37: sNombre = nName+" Lavaoscura"; break;
              case 38: sNombre = nName+" Fuegoscuro"; break;
              case 39: sNombre = nName+" Pérfida"; break;
              case 40: sNombre = nName+" Destruye Urdimbre"; break;
        }
    }
    //CONSTRUCTO
    if(sTipoEncuentro == 5)
    {
        switch(d20(2))
        {
            case 1: nName = "Chrono"; break;
              case 2: nName = "Plano"; break;
              case 3: nName = "Proyecto"; break;
              case 4: nName = "Zumbido"; break;
              case 5: nName = "Cachivache"; break;
              case 6: nName = "Crujido"; break;
              case 7: nName = "Chrono"; break;
              case 8: nName = "Golem"; break;
              case 9: nName = "G"; break;
              case 10: nName = "F"; break;
              case 11: nName = "I"; break;
              case 12: nName = "S"; break;
              case 13: nName = "Táctica"; break;
              case 14: nName = "Armado"; break;
              case 15: nName = "Prometeo"; break;
              case 16: nName = "Prime"; break;
              case 17: nName = "Secundus"; break;
              case 18: nName = "Cometa"; break;
              case 19: nName = "Engranaje"; break;
              case 20: nName = "Paragon"; break;
              case 21: nName = "A"; break;
              case 22: nName = "C"; break;
              case 23: nName = "P"; break;
              case 24: nName = "Calamidad"; break;
              case 25: nName = "Génesis"; break;
              case 26: nName = "Apéndice"; break;
              case 27: nName = "Central"; break;
              case 28: nName = "Código"; break;
              case 29: nName = "Élite"; break;
              case 30: nName = "Ominus"; break;
              case 31: nName = "Ensamblaje"; break;
              case 32: nName = "Cósmico"; break;
              case 33: nName = "Proyecto"; break;
              case 34: nName = "Error"; break;
              case 35: nName = "Montaje"; break;
              case 36: nName = "Z"; break;
              case 37: nName = "Y"; break;
              case 38: nName = "X"; break;
              case 39: nName = "Baratija"; break;
              case 40: nName = "Chisme"; break;
        }
        //APODOS
        switch(d20(2))
        {
              case 1: sNombre = nName+" - 3"; break;
              case 2: sNombre = nName+" - 10"; break;
              case 3: sNombre = nName+" - 11"; break;
              case 4: sNombre = nName+" - 21"; break;
              case 5: sNombre = nName+" - 18"; break;
              case 6: sNombre = nName+" - 1"; break;
              case 7: sNombre = nName+" PDB-01"; break;
              case 8: sNombre = nName+" PDB-02"; break;
              case 9: sNombre = nName+" B001"; break;
              case 10: sNombre = nName+" JK-45"; break;
              case 11: sNombre = nName+" XX-32"; break;
              case 12: sNombre = nName+" Cuasiperfecto"; break;
              case 13: sNombre = nName+" Erróneo"; break;
              case 14: sNombre = nName+" Animado"; break;
              case 15: sNombre = nName+" Exánime"; break;
              case 16: sNombre = nName+" Polvoriento"; break;
              case 17: sNombre = nName+" Forjado"; break;
              case 18: sNombre = nName+" Olvidado"; break;
              case 19: sNombre = nName+" Roto"; break;
              case 20: sNombre = nName+" Inacabado"; break;
              case 21: sNombre = nName+" Prototipo"; break;
              case 22: sNombre = nName+" Alpha"; break;
              case 23: sNombre = nName+" Omega"; break;
              case 24: sNombre = nName+" Beta"; break;
              case 25: sNombre = nName+" ZDR-00"; break;
              case 26: sNombre = nName+" Oxidado"; break;
              case 27: sNombre = nName+" – 72"; break;
              case 28: sNombre = nName+" – 42"; break;
              case 29: sNombre = nName+" – 39"; break;
              case 30: sNombre = nName+" – 55"; break;
              case 31: sNombre = nName+" De Gong"; break;
              case 32: sNombre = nName+" Invictus"; break;
              case 33: sNombre = nName+" Oracle"; break;
              case 34: sNombre = nName+" Truenoarmado"; break;
              case 35: sNombre = nName+" Andromeda"; break;
              case 36: sNombre = nName+" Némesis"; break;
              case 37: sNombre = nName+" Dreadnought"; break;
              case 38: sNombre = nName+" Destrucción"; break;
              case 39: sNombre = nName+" Galáctica"; break;
              case 40: sNombre = nName+" Discoveryr"; break;
        }
    }
    //INFRAOSCURIDAD
    if(sTipoEncuentro == 6)
    {
        switch(d20(2))
        {
            case 1: nName = "Traol"; break;
              case 2: nName = "Thadrass"; break;
              case 3: nName = "Thaggask"; break;
              case 4: nName = "Osrull"; break;
              case 5: nName = "Grugluss"; break;
              case 6: nName = "Thuolluyausk"; break;
              case 7: nName = "Tardsingem"; break;
              case 8: nName = "Cuolboyult"; break;
              case 9: nName = "Esdelere"; break;
              case 10: nName = "Vroten"; break;
              case 11: nName = "Svoboozh"; break;
              case 12: nName = "Droontezh"; break;
              case 13: nName = "Nikoz"; break;
              case 14: nName = "Ses"; break;
              case 15: nName = "Vroruj"; break;
              case 16: nName = "Vadroj"; break;
              case 17: nName = "Bejuzh"; break;
              case 18: nName = "Habus"; break;
              case 19: nName = "Oyuz"; break;
              case 20: nName = "Adron"; break;
              case 21: nName = "Hurnik"; break;
              case 22: nName = "Berdain"; break;
              case 23: nName = "Regtharm"; break;
              case 24: nName = "Magnur"; break;
              case 25: nName = "Darmek"; break;
              case 26: nName = "Rotmond"; break;
              case 27: nName = "Brumnir"; break;
              case 28: nName = "Urmgarn"; break;
              case 29: nName = "Ermkom"; break;
              case 30: nName = "Maleichar"; break;
              case 31: nName = "Gueris"; break;
              case 32: nName = "Meira"; break;
              case 33: nName = "Amrakir"; break;
              case 34: nName = "Hymn"; break;
              case 35: nName = "Oszihsas"; break;
              case 36: nName = "Etlus"; break;
              case 37: nName = "Yatstlotuss"; break;
              case 38: nName = "Shalia"; break;
              case 39: nName = "Shuihlush"; break;
              case 40: nName = "Ahtla"; break;
        }
        //APODOS
        switch(d20(2))
        {
              case 1: sNombre = nName+" El Reptante"; break;
              case 2: sNombre = nName+" El Engendro"; break;
              case 3: sNombre = nName+" El Acechante"; break;
              case 4: sNombre = nName+" El Devorador Cavernario"; break;
              case 5: sNombre = nName+" El Cazador de las Grutas"; break;
              case 6: sNombre = nName+" La Última Sombra"; break;
              case 7: sNombre = nName+" Rondador de las Grutas"; break;
              case 8: sNombre = nName+" El Sigiloso"; break;
              case 9: sNombre = nName+" El Taimado"; break;
              case 10: sNombre = nName+" Trepador pétreo"; break;
              case 11: sNombre = nName+" El Amo de las Sombras"; break;
              case 12: sNombre = nName+" Aullidoterrible"; break;
              case 13: sNombre = nName+" Amo de las Sombras"; break;
              case 14: sNombre = nName+" Foso de Oscuridad"; break;
              case 15: sNombre = nName+" Terror de la Mesoscuridad"; break;
              case 16: sNombre = nName+" Terror de la Supraoscuridad"; break;
              case 17: sNombre = nName+" Terror de la Bajoscuridad"; break;
              case 18: sNombre = nName+" La Bestia Cavernaria"; break;
              case 19: sNombre = nName+" Kakledh"; break;
              case 20: sNombre = nName+" Honrede"; break;
              case 21: sNombre = nName+" Grytri"; break;
              case 22: sNombre = nName+" El Hambriento"; break;
              case 23: sNombre = nName+" Ivgek"; break;
              case 24: sNombre = nName+" Vekbeezha"; break;
              case 25: sNombre = nName+" Zirkhakh"; break;
              case 26: sNombre = nName+" Vurd"; break;
              case 27: sNombre = nName+" Diahrakhzib"; break;
              case 28: sNombre = nName+" Bafralfee"; break;
              case 29: sNombre = nName+" Sharyu"; break;
              case 30: sNombre = nName+" Khoozad"; break;
              case 31: sNombre = nName+" Ehmanshuz"; break;
              case 32: sNombre = nName+" Zashkahr"; break;
              case 33: sNombre = nName+" Tezyurdaz"; break;
              case 34: sNombre = nName+" Jaguzuaz"; break;
              case 35: sNombre = nName+" El Hambriento"; break;
              case 36: sNombre = nName+" Nesssyss"; break;
              case 37: sNombre = nName+" Xylnar"; break;
              case 38: sNombre = nName+" El Morador Oscuro"; break;
              case 39: sNombre = nName+" Korax"; break;
              case 40: sNombre = nName+" El Incansable"; break;
        }
    }

    SetName(oCreature, sNombre);
    SetLocalString(oArea, "NombreBoss", nName);
}

void CrearEncuentroHumanos(int sEncuentro, object oArea, object oPC)
{
  object oCreated;
  int nNumMons, i;
  string creaturetype;
  string creatureboss;
  int nClass;
  int nPack;
  int nLevel;
  int nLevelBoss;
  int NUM_SPAWNPOINTS = GetLocalInt(oArea, "SPAWN_ENCUENTRO");
  int SP_cntr;
  string SP_Num;

    //Si quedan enemigos de otros encuentros no genero nuevos
  int SpamCount = CountAllObjectsInAreaByTag("ENC_0_HUMANO", oPC);
  if(SpamCount > 5) return;

    //Nivel de Encuentro
        switch(sEncuentro)
        {
        case 0:
                nLevel = 3; nLevelBoss = 9; creatureboss = "BOSS_0_HUMANO";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 1); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 2); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 3); break;
                }
                break;
        case 1:
                nLevel = 7; nLevelBoss = 15; creatureboss = "BOSS_1_HUMANO";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 1); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 2); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 3); break;
                }
                break;
        case 2:
                nLevel = 12; nLevelBoss = 21; creatureboss = "BOSS_2_HUMANO";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 4); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 5); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 6); break;
                }
                break;
        case 3:
                nLevel = 16; nLevelBoss = 30; creatureboss = "BOSS_3_HUMANO";
                switch(d2())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 7); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 8); break;
                }
                break;
        case 4:
                nLevel = 20; nLevelBoss = 40; creatureboss = "BOSS_4_HUMANO";
                switch(d2())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 73); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 74); break;
                }
                break;
        }

    //BOSS PRIMERO

    string sSpawnBoss = "SP_ENC_BOSS"; //El spawn del boss
    //object oBoss = GetWaypointByTag(sSpawnBoss);
    object oBoss = GetNearestObjectByTag(sSpawnBoss, oPC);
    location lBossLoc =  GetLocation(oBoss);
    if(oBoss != OBJECT_INVALID) {
    //Si quedan enemigos de otros encuentros no genero nuevos
    object NoSpam = GetNearestObjectByTag(creatureboss, oPC);
    if(NoSpam != OBJECT_INVALID) return;
    nNumMons = 1;
    for (i=0;i<nNumMons;i++)
    {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creatureboss, lBossLoc, FALSE);

        //Asignamos la clase para la apariencia
        switch(d20())
        {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12: nClass = CLASS_TYPE_CLERIC; break;
        case 13:
        case 14:
        case 15:
        case 16:
        case 17: nClass = CLASS_TYPE_WIZARD; break;
        case 18:
        case 19:
        case 20: nClass = CLASS_TYPE_BARBARIAN; break;
        }
        //Ajustamos el nivel, nombre y apariencia
        if(oCreated != OBJECT_INVALID){
        SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
        SetLocalInt(oCreated, "ENC_CLASS", nClass);
        //DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevelBoss, nClass, 40));
        AsignarNombreBoss(oCreated, oArea);
        DelayCommand(1.0, AsignarApariencia(nClass, oCreated, oArea));
        //DelayCommand(1.2, AjustarEquipo(oCreated));
        DelayCommand(3.0, ForceRest(oCreated)); }
    }
  }
  for ( SP_cntr=0; SP_cntr < NUM_SPAWNPOINTS; SP_cntr ++ )
  {
     string SP_Num = IntToString(SP_cntr);
     string sSpawnPoint = "SP_ENC_"+SP_Num;
     object oTarget = GetNearestObjectByTag(sSpawnPoint, oPC);
     location lTargLoc =  GetLocation(oTarget);


        //Plantilla de los esbirros
        creaturetype = "ENC_0_HUMANO";

        //ESBIRROS
        nNumMons = d2(2)+1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5: nClass = CLASS_TYPE_BARBARIAN; break;
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13: nClass = CLASS_TYPE_ROGUE; break;
            case 14:
            case 15:
            case 16:
            case 17:
            case 18: nClass = CLASS_TYPE_FIGHTER; break;
            case 19:
            case 20: nClass = CLASS_TYPE_CLERIC; nPack = 22; break;

            }

            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = Random(3)+1; break; //Niveles de 2 a 4
            case 1: nLevel = Random(4)+4; break; //Niveles de 5 a 8
            case 2: nLevel = Random(4)+10; break; //Niveles de 9 a 12
            case 3: nLevel = Random(4)+14; break;//Niveles de 13 a 16
            case 4: nLevel = Random(4)+16; break;//Niveles de 17 a 21
            }
            if(oCreated != OBJECT_INVALID){
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 76, nPack));
            DelayCommand(1.4, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.2, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.6, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            AssignCommand(oCreated, ActionRandomWalk());  }

        }

        //ELITE (Uno por spawn)
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7: nClass = CLASS_TYPE_BARBARIAN;break;
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14: nClass = CLASS_TYPE_WIZARD; nPack = 34; break;
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_CLERIC; nPack = 22; break;

            }

            //Ajustamos el nivel
            int iFue = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_STRENGTH);
            int iDes = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_DEXTERITY);
            int iSab = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_WISDOM);
            int iInt = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE);
            int iCar = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_CHARISMA);

            if(oCreated != OBJECT_INVALID){
            switch(nClass) {
                case CLASS_TYPE_ROGUE: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_DEXTERITY, iDes + 2); break;
                case CLASS_TYPE_FIGHTER: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
                case CLASS_TYPE_CLERIC: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_WISDOM, iSab + 2); break;
                case CLASS_TYPE_WIZARD: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE, iInt + 2); break;
                case CLASS_TYPE_BARBARIAN: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
            }
            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = 4; break;
            case 1: nLevel = 8; break;
            case 2: nLevel = 12; break;
            case 3: nLevel = 18; break;
            case 4: nLevel = 20; break;
            }

            SetLocalInt(oCreated, "ENC_ELITE", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 76, nPack));
            DelayCommand(1.4, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.6, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.6, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }

        }

    }
}

void CrearEncuentroOrcos(int sEncuentro, object oArea, object oPC)
{
  object oCreated;
  int nNumMons, i;
  string creaturetype;
  string creatureboss;
  int nClass;
  int nPack;
  int nLevel;
  int nLevelBoss;
  int NUM_SPAWNPOINTS = GetLocalInt(oArea, "SPAWN_ENCUENTRO");
  int SP_cntr;
  string SP_Num;

    //Si quedan enemigos de otros encuentros no genero nuevos
    int SpamCount = CountAllObjectsInAreaByTag("ENC_0_RAZAS", oPC);
  if(SpamCount > 5) return;

    //Nivel de Encuentro
        switch(sEncuentro)
        {
        case 0:
                nLevel = 3; nLevelBoss = 9; creatureboss = "BOSS_0_RAZAS";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 9); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 10); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 11); break;
                }
                break;
        case 1:
                nLevel = 7; nLevelBoss = 15; creatureboss = "BOSS_1_RAZAS";
                switch(d4())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 9); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 10); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 11); break;
                case 4: SetLocalInt(oArea, "AparienciaEncuentro", 12); break;
                }
                break;
        case 2:
                nLevel = 12; nLevelBoss = 21; creatureboss = "BOSS_2_RAZAS";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 12); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 13); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 14); break;
                }
                break;
        case 3:
                nLevel = 16; nLevelBoss = 30; creatureboss = "BOSS_3_RAZAS";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 15); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 16); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 17); break;
                }
                break;
        case 4:
                nLevel = 20; nLevelBoss = 40; creatureboss = "BOSS_4_RAZAS";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 18); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 19); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 20); break;
                }
                break;
        }

    //BOSS PRIMERO

    string sSpawnBoss = "SP_ENC_BOSS"; //El spawn del boss
    object oBoss = GetNearestObjectByTag(sSpawnBoss, oPC);
    location lBossLoc =  GetLocation(oBoss);
        if(oBoss != OBJECT_INVALID) {
        //Si quedan enemigos de otros encuentros no genero nuevos
        object NoSpam = GetNearestObjectByTag(creatureboss, oPC);
        if(NoSpam != OBJECT_INVALID) return;
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creatureboss, lBossLoc, FALSE);
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10: nClass = CLASS_TYPE_CLERIC; break;
            case 11:
            case 12:
            case 13:
            case 14:
            case 15: nClass = CLASS_TYPE_WIZARD; break;
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_BARBARIAN; break;

            }
            if(oCreated != OBJECT_INVALID){
            //Ajustamos el nivel, nombre y apariencia
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            //DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevelBoss, nClass, 40));
            AsignarNombreBoss(oCreated, oArea);
            DelayCommand(1.0, AsignarApariencia(nClass, oCreated, oArea));
            //DelayCommand(1.2, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }
        }
      }

  for ( SP_cntr=0; SP_cntr < NUM_SPAWNPOINTS; SP_cntr ++ )
  {
     string SP_Num = IntToString(SP_cntr);
     string sSpawnPoint = "SP_ENC_"+SP_Num;
     object oTarget = GetNearestObjectByTag(sSpawnPoint, oPC);
     location lTargLoc =  GetLocation(oTarget);


        //Plantilla de los esbirros
        creaturetype = "ENC_0_RAZAS";

        //ESBIRROS
        nNumMons = d2(2)+1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4: nClass = CLASS_TYPE_ROGUE;break;
            case 5:
            case 6:
            case 7: nClass = CLASS_TYPE_FIGHTER;break;
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18: nClass = CLASS_TYPE_BARBARIAN; break;
            case 19:
            case 20: nClass = CLASS_TYPE_CLERIC; nPack = 19; break;

            }

            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = Random(3)+1; break; //Niveles de 2 a 4
            case 1: nLevel = Random(4)+4; break; //Niveles de 4 a 8
            case 2: nLevel = Random(4)+10; break; //Niveles de 9 a 12
            case 3: nLevel = Random(4)+14; break;//Niveles de 13 a 18
            case 4: nLevel = Random(4)+16; break;//Niveles de 17 a 21
            }
            if(oCreated != OBJECT_INVALID){
            //Ajustamos el nivel
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 77, nPack));
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.4, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            AssignCommand(oCreated, ActionRandomWalk());
            }

        }

        //ELITE (Uno por spawn)
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5: nClass = CLASS_TYPE_BARBARIAN; break;
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12: nClass = CLASS_TYPE_WIZARD; nPack = 31; break;
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_CLERIC; nPack = 19; break;

            }

            //Ajustamos el nivel
            int iFue = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_STRENGTH);
            int iDes = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_DEXTERITY);
            int iSab = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_WISDOM);
            int iInt = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE);
            int iCar = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_CHARISMA);

            if(oCreated != OBJECT_INVALID){
            switch(nClass) {
                case CLASS_TYPE_ROGUE: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_DEXTERITY, iDes + 2); break;
                case CLASS_TYPE_FIGHTER: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
                case CLASS_TYPE_CLERIC: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_WISDOM, iSab + 2); break;
                case CLASS_TYPE_WIZARD: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE, iInt + 2); break;
                case CLASS_TYPE_BARBARIAN: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
            }
            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = 4; break;
            case 1: nLevel = 8; break;
            case 2: nLevel = 12; break;
            case 3: nLevel = 18; break;
            case 4: nLevel = 20; break;
            }

            SetLocalInt(oCreated, "ENC_ELITE", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 77, nPack));
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.4, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }

        }

    }
}

void CrearEncuentroNomuertos(int sEncuentro, object oArea, object oPC)
{
  object oCreated;
  int nNumMons, i;
  string creaturetype;
  string creatureboss;
  int nClass;
  int nLevel;
  int nPack;
  int nLevelBoss;
  int NUM_SPAWNPOINTS = GetLocalInt(oArea, "SPAWN_ENCUENTRO");
  int SP_cntr;
  string SP_Num;

  //Si quedan enemigos de otros encuentros no genero nuevos
   int SpamCount = CountAllObjectsInAreaByTag("ENC_0_MUERTOS", oPC);
  if(SpamCount > 5) return;

    //Nivel de Encuentro
        switch(sEncuentro)
        {
        case 0:
                nLevel = 3; nLevelBoss = 9; creatureboss = "BOSS_0_MUERTOS";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 21); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 22); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 23); break;
                }
                break;
        case 1:
                nLevel = 7; nLevelBoss = 15; creatureboss = "BOSS_1_MUERTOS";
                switch(d4())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 21); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 22); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 23); break;
                case 4: SetLocalInt(oArea, "AparienciaEncuentro", 24); break;
                }
                break;
        case 2:
                nLevel = 12; nLevelBoss = 21; creatureboss = "BOSS_2_MUERTOS";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 24); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 25); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 26); break;
                }
                break;
        case 3:
                nLevel = 16; nLevelBoss = 30; creatureboss = "BOSS_3_MUERTOS";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 27); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 28); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 29); break;
                }
                break;
        case 4:
                nLevel = 20; nLevelBoss = 40; creatureboss = "BOSS_4_MUERTOS";
                switch(d2())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 30); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 31); break;
                }
                break;
        }

    //BOSS PRIMERO
    string sSpawnBoss = "SP_ENC_BOSS"; //El spawn del boss
    object oBoss = GetNearestObjectByTag(sSpawnBoss, oPC);
    location lBossLoc =  GetLocation(oBoss);

    if(oBoss != OBJECT_INVALID) {
        //Si quedan enemigos de otros encuentros no genero nuevos
        object NoSpam = GetNearestObjectByTag(creatureboss, oPC);
        if(NoSpam != OBJECT_INVALID) return;
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creatureboss, lBossLoc, FALSE);
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10: nClass = CLASS_TYPE_CLERIC; break;
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_WIZARD; break;

            }
            if(oCreated != OBJECT_INVALID){
            //Ajustamos el nivel, nombre y apariencia
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            //DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevelBoss, nClass, 40));
            AsignarNombreBoss(oCreated, oArea);
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }
        }
   }
  for ( SP_cntr=0; SP_cntr < NUM_SPAWNPOINTS; SP_cntr ++ )
  {
     string SP_Num = IntToString(SP_cntr);
     string sSpawnPoint = "SP_ENC_"+SP_Num;
     object oTarget = GetNearestObjectByTag(sSpawnPoint, oPC);
     location lTargLoc =  GetLocation(oTarget);


        //Plantilla de los esbirros
        creaturetype = "ENC_0_MUERTOS";

        //ESBIRROS
        nNumMons = d2(2)+1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3: nClass = CLASS_TYPE_BARBARIAN; break;
            case 4:
            case 5:
            case 6:
            case 7: nClass = CLASS_TYPE_ROGUE; break;
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18: nClass = CLASS_TYPE_FIGHTER; break;
            case 19:
            case 20: nClass = CLASS_TYPE_CLERIC; nPack = 20; break;

            }

            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = Random(3)+1; break; //Niveles de 2 a 4
            case 1: nLevel = Random(4)+4; break; //Niveles de 4 a 8
            case 2: nLevel = Random(4)+10; break; //Niveles de 9 a 12
            case 3: nLevel = Random(4)+14; break;//Niveles de 13 a 18
            case 4: nLevel = Random(4)+16; break;//Niveles de 17 a 21
            }
            if(oCreated != OBJECT_INVALID){
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 81, nPack));
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.4, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            AssignCommand(oCreated, ActionRandomWalk());
            }
        }

        //ELITE (Uno por spawn)
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10: nClass = CLASS_TYPE_CLERIC; nPack = 20; break;
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_WIZARD; nPack = 33; break;

            }

            //Ajustamos el nivel
            int iFue = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_STRENGTH);
            int iDes = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_DEXTERITY);
            int iSab = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_WISDOM);
            int iInt = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE);
            int iCar = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_CHARISMA);

            if(oCreated != OBJECT_INVALID){
            switch(nClass) {
                case CLASS_TYPE_ROGUE: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_DEXTERITY, iDes + 2); break;
                case CLASS_TYPE_FIGHTER: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
                case CLASS_TYPE_CLERIC: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_WISDOM, iSab + 2); break;
                case CLASS_TYPE_WIZARD: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE, iInt + 2); break;
                case CLASS_TYPE_BARBARIAN: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
            }
            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = 4; break;
            case 1: nLevel = 8; break;
            case 2: nLevel = 12; break;
            case 3: nLevel = 18; break;
            case 4: nLevel = 20; break;
            }

            SetLocalInt(oCreated, "ENC_ELITE", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 81, nPack));
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.4, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }

        }

    }
}

void CrearEncuentroReptiles(int sEncuentro, object oArea, object oPC)
{
  object oCreated;
  int nNumMons, i;
  string creaturetype;
  string creatureboss;
  int nClass;
  int nLevel;
  int nPack;
  int nLevelBoss;
  int NUM_SPAWNPOINTS = GetLocalInt(oArea, "SPAWN_ENCUENTRO");
  int SP_cntr;
  string SP_Num;

    //Si quedan enemigos de otros encuentros no genero nuevos
  int SpamCount = CountAllObjectsInAreaByTag("ENC_0_REPTIL", oPC);
  if(SpamCount > 5) return;


    //Nivel de Encuentro
        switch(sEncuentro)
        {
        case 0:
                nLevel = 3; nLevelBoss = 9; creatureboss = "BOSS_0_REPTIL";
                switch(d2())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 32); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 33); break;
                }
                break;
        case 1:
                nLevel = 7; nLevelBoss = 15; creatureboss = "BOSS_1_REPTIL";
                switch(d4())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 32); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 33); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 34); break;
                case 4: SetLocalInt(oArea, "AparienciaEncuentro", 35); break;
                }
                break;
        case 2:
                nLevel = 12; nLevelBoss = 21; creatureboss = "BOSS_2_REPTIL";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 34); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 35); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 37); break;
                }
                break;
        case 3:
                nLevel = 16; nLevelBoss = 30; creatureboss = "BOSS_3_REPTIL";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 36); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 37); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 75); break;
                }
                break;
        case 4:
                nLevel = 20; nLevelBoss = 40; creatureboss = "BOSS_4_REPTIL";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 38); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 39); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 40); break;
                }
                break;
        }

    //BOSS PRIMERO
    string sSpawnBoss = "SP_ENC_BOSS"; //El spawn del boss
    object oBoss = GetNearestObjectByTag(sSpawnBoss, oPC);
    location lBossLoc =  GetLocation(oBoss);
    if(oBoss != OBJECT_INVALID) {
        //Si quedan enemigos de otros encuentros no genero nuevos
        object NoSpam = GetNearestObjectByTag(creatureboss, oPC);
        if(NoSpam != OBJECT_INVALID) return;
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creatureboss, lBossLoc, FALSE);
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10: nClass = CLASS_TYPE_CLERIC; break;
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_BARBARIAN; break;

            }
            if(oCreated != OBJECT_INVALID){
            //Ajustamos el nivel, nombre y apariencia
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            //DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevelBoss, nClass, 40));
            AsignarNombreBoss(oCreated, oArea);
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }
        }
      }
  for ( SP_cntr=0; SP_cntr < NUM_SPAWNPOINTS; SP_cntr ++ )
  {
     string SP_Num = IntToString(SP_cntr);
     string sSpawnPoint = "SP_ENC_"+SP_Num;
     object oTarget = GetNearestObjectByTag(sSpawnPoint, oPC);
     location lTargLoc =  GetLocation(oTarget);


        //Plantilla de los esbirros
        creaturetype = "ENC_0_REPTIL";

        //ESBIRROS
        nNumMons = d2(2)+1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6: nClass = CLASS_TYPE_RANGER; break;
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12: nClass = CLASS_TYPE_BARBARIAN; break;
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18: nClass = CLASS_TYPE_DRUID; break;
            case 19:
            case 20: nClass = CLASS_TYPE_CLERIC; nPack = 19; break;

            }

            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = Random(3)+1; break; //Niveles de 2 a 4
            case 1: nLevel = Random(4)+4; break; //Niveles de 4 a 8
            case 2: nLevel = Random(4)+10; break; //Niveles de 9 a 12
            case 3: nLevel = Random(4)+14; break;//Niveles de 13 a 18
            case 4: nLevel = Random(4)+16; break;//Niveles de 17 a 21
            }
            if(oCreated != OBJECT_INVALID){
            //Ajustamos el nivel
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 85, nPack));
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.4, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            AssignCommand(oCreated, ActionRandomWalk());
            }

        }

        //ELITE (Uno por spawn)
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8: nClass = CLASS_TYPE_BARBARIAN; break;
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14: nClass = CLASS_TYPE_CLERIC; nPack = 19; break;
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_DRUID; break;

            }

            //Ajustamos el nivel
            int iFue = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_STRENGTH);
            int iDes = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_DEXTERITY);
            int iSab = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_WISDOM);
            int iInt = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE);
            int iCar = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_CHARISMA);

            if(oCreated != OBJECT_INVALID){
            switch(nClass) {
                case CLASS_TYPE_ROGUE: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_DEXTERITY, iDes + 2); break;
                case CLASS_TYPE_FIGHTER: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
                case CLASS_TYPE_CLERIC: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_WISDOM, iSab + 2); break;
                case CLASS_TYPE_DRUID: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_WISDOM, iSab + 2); break;
                case CLASS_TYPE_RANGER: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_WISDOM, iSab + 2); break;
                case CLASS_TYPE_WIZARD: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE, iInt + 2); break;
                case CLASS_TYPE_BARBARIAN: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
            }
            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = 4; break;
            case 1: nLevel = 8; break;
            case 2: nLevel = 12; break;
            case 3: nLevel = 18; break;
            case 4: nLevel = 20; break;
            }

            SetLocalInt(oCreated, "ENC_ELITE", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 85, nPack));
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.4, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }

        }

    }
}

void CrearEncuentroMagico(int sEncuentro, object oArea, object oPC)
{
  object oCreated;
  int nNumMons, i;
  string creaturetype;
  string creatureboss;
  int nClass;
  int nLevel;
  int nPack;
  int nLevelBoss;
  int NUM_SPAWNPOINTS = GetLocalInt(oArea, "SPAWN_ENCUENTRO");
  int SP_cntr;
  string SP_Num;

  //Si quedan enemigos de otros encuentros no genero nuevos
  int SpamCount = CountAllObjectsInAreaByTag("ENC_0_MAGICO", oPC);
  if(SpamCount > 5) return;

   //Nivel de Encuentro
        switch(sEncuentro)
        {
        case 0:
                nLevel = 3; nLevelBoss = 9; creatureboss = "BOSS_0_MAGICO";
                switch(d2())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 41); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 43); break;
                }
                break;
        case 1:
                nLevel = 7; nLevelBoss = 15; creatureboss = "BOSS_1_MAGICO";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 41); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 42); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 43); break;
                }
                break;
        case 2:
                nLevel = 12; nLevelBoss = 21; creatureboss = "BOSS_2_MAGICO";
                switch(d4())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 44); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 42); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 45); break;
                case 4: SetLocalInt(oArea, "AparienciaEncuentro", 46); break;
                }
                break;
        case 3:
                nLevel = 16; nLevelBoss = 30; creatureboss = "BOSS_3_MAGICO";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 47); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 48); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 49); break;
                }
                break;
        case 4:
                nLevel = 20; nLevelBoss = 40; creatureboss = "BOSS_4_MAGICO";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 50); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 51); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 52); break;
                }
                break;
        }

    //BOSS PRIMERO
    string sSpawnBoss = "SP_ENC_BOSS"; //El spawn del boss
    object oBoss = GetNearestObjectByTag(sSpawnBoss, oPC);
    location lBossLoc =  GetLocation(oBoss);
     if(oBoss != OBJECT_INVALID) {
        //Si quedan enemigos de otros encuentros no genero nuevos
        object NoSpam = GetNearestObjectByTag(creatureboss, oPC);
        if(NoSpam != OBJECT_INVALID) return;
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creatureboss, lBossLoc, FALSE);
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10: nClass = CLASS_TYPE_CLERIC; break;
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17: nClass = CLASS_TYPE_FIGHTER; break;
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_WIZARD; break;

            }
            if(oCreated != OBJECT_INVALID){
            //Ajustamos el nivel, nombre y apariencia
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            //DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevelBoss, nClass, 40));
            AsignarNombreBoss(oCreated, oArea);
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }
        }
     }
  for ( SP_cntr=0; SP_cntr < NUM_SPAWNPOINTS; SP_cntr ++ )
  {
     string SP_Num = IntToString(SP_cntr);
     string sSpawnPoint = "SP_ENC_"+SP_Num;
     object oTarget = GetNearestObjectByTag(sSpawnPoint, oPC);
     location lTargLoc =  GetLocation(oTarget);


        //Plantilla de los esbirros
        creaturetype = "ENC_0_MAGICO";

        //ESBIRROS
        nNumMons = d2(2)+1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2: nClass = CLASS_TYPE_ROGUE; break;
            case 3:
            case 4:
            case 5: nClass = CLASS_TYPE_BARBARIAN; break;
            case 6:
            case 7:
            case 8:
            case 9: nClass = CLASS_TYPE_FIGHTER; break;
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15: nClass = CLASS_TYPE_WIZARD; nPack = 32; break;
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_CLERIC; nPack = 21; break;

            }

            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = Random(3)+1; break; //Niveles de 2 a 4
            case 1: nLevel = Random(4)+4; break; //Niveles de 5 a 8
            case 2: nLevel = Random(4)+10; break; //Niveles de 9 a 12
            case 3: nLevel = Random(4)+14; break;//Niveles de 13 a 16
            case 4: nLevel = Random(4)+16; break;//Niveles de 17 a 20
            }
            if(oCreated != OBJECT_INVALID){
            //Ajustamos el nivel
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 85, nPack));
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.4, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            AssignCommand(oCreated, ActionRandomWalk());
            }

        }

        //ELITE (Uno por spawn)
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8: nClass = CLASS_TYPE_FIGHTER; break;
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14: nClass = CLASS_TYPE_CLERIC; nPack = 21; break;
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_WIZARD; nPack = 32; break;

            }

            //Ajustamos el nivel
            int iFue = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_STRENGTH);
            int iDes = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_DEXTERITY);
            int iSab = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_WISDOM);
            int iInt = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE);
            int iCar = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_CHARISMA);

            if(oCreated != OBJECT_INVALID){
            switch(nClass) {
                case CLASS_TYPE_ROGUE: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_DEXTERITY, iDes + 2); break;
                case CLASS_TYPE_FIGHTER: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
                case CLASS_TYPE_CLERIC: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_WISDOM, iSab + 2); break;
                case CLASS_TYPE_WIZARD: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE, iInt + 2); break;
                case CLASS_TYPE_BARBARIAN: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
            }
            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = 4; break;
            case 1: nLevel = 8; break;
            case 2: nLevel = 12; break;
            case 3: nLevel = 18; break;
            case 4: nLevel = 20; break;
            }
;
            SetLocalInt(oCreated, "ENC_ELITE", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 85, nPack));
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.4, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }
        }

    }
}

void CrearEncuentroConstructo(int sEncuentro, object oArea, object oPC)
{
  object oCreated;
  int nNumMons, i;
  string creaturetype;
  string creatureboss;
  int nClass;
  int nLevel;
  int nPack;
  int nLevelBoss;
  int NUM_SPAWNPOINTS = GetLocalInt(oArea, "SPAWN_ENCUENTRO");
  int SP_cntr;
  string SP_Num;
  //Si quedan enemigos de otros encuentros no genero nuevos
  int SpamCount = CountAllObjectsInAreaByTag("ENC_0_CONST", oPC);
  if(SpamCount > 5) return;

     //Nivel de Encuentro
        switch(sEncuentro)
        {
        case 0:
                nLevel = 3; nLevelBoss = 9; creatureboss = "BOSS_0_CONST";
                switch(d2())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 53); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 54); break;
                }
                break;
        case 1:
                nLevel = 7; nLevelBoss = 15; creatureboss = "BOSS_1_CONST";
                switch(d2())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 53); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 54); break;
                }
                break;
        case 2:
                nLevel = 12; nLevelBoss = 21; creatureboss = "BOSS_2_CONST";
                switch(d2())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 55); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 56); break;
                }
                break;
        case 3:
                nLevel = 16; nLevelBoss = 30; creatureboss = "BOSS_3_CONST";
                switch(d2())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 57); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 58); break;
                }
                break;
        case 4:
                nLevel = 20; nLevelBoss = 40; creatureboss = "BOSS_4_CONST";
                switch(d2())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 59); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 60); break;
                }
                break;
        }

    //BOSS PRIMERO
    string sSpawnBoss = "SP_ENC_BOSS"; //El spawn del boss
    object oBoss = GetNearestObjectByTag(sSpawnBoss, oPC);
    location lBossLoc =  GetLocation(oBoss);
     if(oBoss != OBJECT_INVALID) {
        //Si quedan enemigos de otros encuentros no genero nuevos
        object NoSpam = GetNearestObjectByTag(creatureboss, oPC);
        if(NoSpam != OBJECT_INVALID) return;
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creatureboss, lBossLoc, FALSE);
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10: nClass = CLASS_TYPE_FIGHTER;break;
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_CLERIC; break;

            }
             if(oCreated != OBJECT_INVALID){
            //Ajustamos el nivel, nombre y apariencia
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            //DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevelBoss, nClass, 40));
            AsignarNombreBoss(oCreated, oArea);
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }
        }
      }
  for ( SP_cntr=0; SP_cntr < NUM_SPAWNPOINTS; SP_cntr ++ )
  {
     string SP_Num = IntToString(SP_cntr);
     string sSpawnPoint = "SP_ENC_"+SP_Num;
     object oTarget = GetNearestObjectByTag(sSpawnPoint, oPC);
     location lTargLoc =  GetLocation(oTarget);


        //Plantilla de los esbirros
        creaturetype = "ENC_0_CONST";

        //ESBIRROS
        nNumMons = d2(2)+1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18: nClass = CLASS_TYPE_CONSTRUCT; break;
            case 19:
            case 20: nClass = CLASS_TYPE_CLERIC; break;

            }

            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = Random(3)+1; break; //Niveles de 2 a 4
            case 1: nLevel = Random(4)+4; break; //Niveles de 4 a 8
            case 2: nLevel = Random(4)+10; break; //Niveles de 9 a 12
            case 3: nLevel = Random(4)+14; break;//Niveles de 13 a 18
            case 4: nLevel = Random(4)+16; break;//Niveles de 17 a 21
            }
            if(oCreated != OBJECT_INVALID){
            //Ajustamos el nivel
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22));
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.4, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            AssignCommand(oCreated, ActionRandomWalk());
            }

        }

        //ELITE (Uno por spawn)
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8: nClass = CLASS_TYPE_CONSTRUCT; break;
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_WIZARD; break;

            }

            //Ajustamos el nivel
            int iFue = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_STRENGTH);
            int iDes = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_DEXTERITY);
            int iSab = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_WISDOM);
            int iInt = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE);
            int iCar = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_CHARISMA);

            if(oCreated != OBJECT_INVALID){
            switch(nClass) {
                case CLASS_TYPE_ROGUE: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_DEXTERITY, iDes + 2); break;
                case CLASS_TYPE_FIGHTER: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
                case CLASS_TYPE_CLERIC: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_WISDOM, iSab + 2); break;
                case CLASS_TYPE_WIZARD: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE, iInt + 2); break;
                case CLASS_TYPE_BARBARIAN: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
            }

            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = 4; break;
            case 1: nLevel = 8; break;
            case 2: nLevel = 12; break;
            case 3: nLevel = 18; break;
            case 4: nLevel = 20; break;
            }

            SetLocalInt(oCreated, "ENC_ELITE", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22));
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.4, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }

        }

    }
}

void CrearEncuentroInfra(int sEncuentro, object oArea, object oPC)
{
  object oCreated;
  int nNumMons, i;
  string creaturetype;
  string creatureboss;
  int nClass;
  int nLevel;
  int nPack;
  int nLevelBoss;
  int NUM_SPAWNPOINTS = GetLocalInt(oArea, "SPAWN_ENCUENTRO");
  int SP_cntr;
  string SP_Num;

  //Si quedan enemigos de otros encuentros no genero nuevos
  int SpamCount = CountAllObjectsInAreaByTag("ENC_0_INFRA", oPC);
  if(SpamCount > 5) return;

        //Nivel de Encuentro
        switch(sEncuentro)
        {
        case 0:
                nLevel = 3; nLevelBoss = 9; creatureboss = "BOSS_0_INFRA";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 61); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 62); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 63); break;
                }
                break;
        case 1:
                nLevel = 7; nLevelBoss = 15; creatureboss = "BOSS_1_INFRA";
                switch(d4())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 61); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 62); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 63); break;
                case 4: SetLocalInt(oArea, "AparienciaEncuentro", 64); break;
                }
                break;
        case 2:
                nLevel = 12; nLevelBoss = 21; creatureboss = "BOSS_2_INFRA";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 64); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 65); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 66); break;
                }
                break;
        case 3:
                nLevel = 16; nLevelBoss = 30; creatureboss = "BOSS_3_INFRA";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 67); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 68); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 69); break;
                }
                break;
        case 4:
                nLevel = 20; nLevelBoss = 40; creatureboss = "BOSS_4_INFRA";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 70); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 71); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 72); break;
                }
                break;
        }

    //BOSS PRIMERO
    string sSpawnBoss = "SP_ENC_BOSS"; //El spawn del boss
    object oBoss = GetNearestObjectByTag(sSpawnBoss, oPC);
    location lBossLoc =  GetLocation(oBoss);
    if(oBoss != OBJECT_INVALID) {
        //Si quedan enemigos de otros encuentros no genero nuevos
        object NoSpam = GetNearestObjectByTag(creatureboss, oPC);
        if(NoSpam != OBJECT_INVALID) return;

        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creatureboss, lBossLoc, FALSE);
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5: nClass = CLASS_TYPE_ROGUE; break;
            case 6:
            case 7:
            case 8:
            case 9:
            case 10: nClass = CLASS_TYPE_FIGHTER;break;
            case 11:
            case 12:
            case 13:
            case 14:
            case 15: nClass = CLASS_TYPE_BARBARIAN; break;
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_WIZARD; break;

            }
            if(oCreated != OBJECT_INVALID){
            //Ajustamos el nivel, nombre y apariencia
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            //DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevelBoss, nClass, 40));
            AsignarNombreBoss(oCreated, oArea);
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }
        }
      }
  for ( SP_cntr=0; SP_cntr < NUM_SPAWNPOINTS; SP_cntr ++ )
  {
     string SP_Num = IntToString(SP_cntr);
     string sSpawnPoint = "SP_ENC_"+SP_Num;
     object oTarget = GetNearestObjectByTag(sSpawnPoint, oPC);
     location lTargLoc =  GetLocation(oTarget);


        //Plantilla de los esbirros
        creaturetype = "ENC_0_INFRA";

        //ESBIRROS
        nNumMons = d2(2)+1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2: nClass = CLASS_TYPE_CLERIC; nPack = 20; break;
            case 3:
            case 4:
            case 5:
            case 6:
            case 7: nClass = CLASS_TYPE_FIGHTER; break;
            case 8:
            case 9:
            case 10:
            case 11:
            case 12: nClass = CLASS_TYPE_BARBARIAN; break;
            case 13:
            case 14:
            case 15:
            case 16: nClass = CLASS_TYPE_ROGUE; break;
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_WIZARD; nPack = 38; break;

            }

            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = Random(3)+1; break; //Niveles de 2 a 4
            case 1: nLevel = Random(4)+4; break; //Niveles de 4 a 8
            case 2: nLevel = Random(4)+10; break; //Niveles de 9 a 12
            case 3: nLevel = Random(4)+14; break;//Niveles de 13 a 18
            case 4: nLevel = Random(4)+16; break;//Niveles de 17 a 21
            }
            if(oCreated != OBJECT_INVALID){
            //Ajustamos el nivel
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 73, nPack));
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.4, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            AssignCommand(oCreated, ActionRandomWalk());
            }

        }

        //ELITE (Uno por spawn)
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6: nClass = CLASS_TYPE_FIGHTER; break;
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13: nClass = CLASS_TYPE_CLERIC; nPack = 20; break;
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_WIZARD; nPack = 38; break;

            }
            if(oCreated != OBJECT_INVALID){
            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = 4; break;
            case 1: nLevel = 8; break;
            case 2: nLevel = 12; break;
            case 3: nLevel = 18; break;
            case 4: nLevel = 20; break;
            }

            //Ajustamos el nivel
            int iFue = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_STRENGTH);
            int iDes = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_DEXTERITY);
            int iSab = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_WISDOM);
            int iInt = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE);
            int iCar = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_CHARISMA);


            switch(nClass) {
                case CLASS_TYPE_ROGUE: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_DEXTERITY, iDes + 2); break;
                case CLASS_TYPE_FIGHTER: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
                case CLASS_TYPE_CLERIC: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_WISDOM, iSab + 2); break;
                case CLASS_TYPE_WIZARD: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE, iInt + 2); break;
                case CLASS_TYPE_BARBARIAN: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
            }

            SetLocalInt(oCreated, "ENC_ELITE", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 73, nPack));
            DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.4, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.4, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }
        }

    }
}

void CrearEncuentroRandom(int sEncuentro, object oArea, object oPC)
{
  object oCreated;
  int nNumMons, i;
  string creaturetype;
  string creatureboss;
  int nClass;
  int nPack;
  int nLevel;
  int nLevelBoss;
  string sPlantilla;
  int NUM_SPAWNPOINTS = GetLocalInt(oArea, "SPAWN_ENCUENTRO");
  int SP_cntr;
  int SpamCount;
  string SP_Num;
  switch(d2(1))
  {
     case 1: sPlantilla = "ENC_0_HUMANO"; SpamCount = CountAllObjectsInAreaByTag("ENC_0_HUMANO", oPC); break;
     case 2: sPlantilla = "ENC_0_RAZAS"; SpamCount = CountAllObjectsInAreaByTag("ENC_0_RAZAS", oPC); break;
  }
    //Si quedan enemigos de otros encuentros no genero nuevos
  if(SpamCount > 5 ) return;


    //Nivel de Encuentro
    if(sPlantilla == "ENC_0_HUMANO")
    {
        switch(sEncuentro)
        {
        case 0:
                nLevel = 3; nLevelBoss = 9; creatureboss = "BOSS_0_HUMANO";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 1); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 2); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 3); break;
                }
                break;
        case 1:
                nLevel = 7; nLevelBoss = 15; creatureboss = "BOSS_1_HUMANO";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 76); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 77); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 78); break;
                }
                break;
        case 2:
                nLevel = 12; nLevelBoss = 21; creatureboss = "BOSS_2_HUMANO";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 4); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 5); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 6); break;
                }
                break;
        case 3:
                nLevel = 16; nLevelBoss = 30; creatureboss = "BOSS_3_HUMANO";
                switch(d2())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 7); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 8); break;
                }
                break;
        case 4:
                nLevel = 20; nLevelBoss = 40; creatureboss = "BOSS_4_HUMANO";
                switch(d2())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 73); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 74); break;
                }
                break;
        }
    }
    else if(sPlantilla == "ENC_0_RAZAS")
    {
        switch(sEncuentro)
        {
        case 0:
                nLevel = 3; nLevelBoss = 9; creatureboss = "BOSS_0_RAZAS";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 9); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 10); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 11); break;
                }
                break;
        case 1:
                nLevel = 7; nLevelBoss = 15; creatureboss = "BOSS_1_RAZAS";
                switch(d4())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 9); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 10); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 11); break;
                case 4: SetLocalInt(oArea, "AparienciaEncuentro", 12); break;
                }
                break;
        case 2:
                nLevel = 12; nLevelBoss = 21; creatureboss = "BOSS_2_RAZAS";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 12); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 13); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 14); break;
                }
                break;
        case 3:
                nLevel = 16; nLevelBoss = 30; creatureboss = "BOSS_3_RAZAS";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 15); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 16); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 17); break;
                }
                break;
        case 4:
                nLevel = 20; nLevelBoss = 40; creatureboss = "BOSS_4_RAZAS";
                switch(d3())
                {
                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 18); break;
                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 19); break;
                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 20); break;
                }
                break;
        }
    }
    //BOSS PRIMERO

    string sSpawnBoss = "SP_ENC_BOSS"; //El spawn del boss
    //object oBoss = GetWaypointByTag(sSpawnBoss);
    object oBoss = GetNearestObjectByTag(sSpawnBoss, oPC);
    location lBossLoc =  GetLocation(oBoss);
    if(oBoss != OBJECT_INVALID) {
    //Si quedan enemigos de otros encuentros no genero nuevos
    object NoSpam = GetNearestObjectByTag(creatureboss, oPC);
    if(NoSpam != OBJECT_INVALID) return;
    nNumMons = 1;
    for (i=0;i<nNumMons;i++)
    {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creatureboss, lBossLoc, FALSE);

        //Asignamos la clase para la apariencia
        switch(d20())
        {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12: nClass = CLASS_TYPE_CLERIC; break;
        case 13:
        case 14:
        case 15:
        case 16:
        case 17: nClass = CLASS_TYPE_WIZARD; break;
        case 18:
        case 19:
        case 20: nClass = CLASS_TYPE_BARBARIAN; break;
        }
        //Ajustamos el nivel, nombre y apariencia
        if(oCreated != OBJECT_INVALID){
        SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
        SetLocalInt(oCreated, "ENC_CLASS", nClass);
        //DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevelBoss, nClass, 40));
        AsignarNombreBoss(oCreated, oArea);
        DelayCommand(1.0, AsignarApariencia(nClass, oCreated, oArea));
        //DelayCommand(1.2, AjustarEquipo(oCreated));
        DelayCommand(3.0, ForceRest(oCreated)); }
    }
  }
  for ( SP_cntr=0; SP_cntr < NUM_SPAWNPOINTS; SP_cntr ++ )
  {
     string SP_Num = IntToString(SP_cntr);
     string sSpawnPoint = "SP_ENC_"+SP_Num;
     object oTarget = GetNearestObjectByTag(sSpawnPoint, oPC);
     location lTargLoc =  GetLocation(oTarget);


        //Plantilla de los esbirros
        creaturetype = sPlantilla;

        //ESBIRROS
        nNumMons = d2(2)+1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5: nClass = CLASS_TYPE_BARBARIAN; break;
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13: nClass = CLASS_TYPE_ROGUE; break;
            case 14:
            case 15:
            case 16:
            case 17:
            case 18: nClass = CLASS_TYPE_FIGHTER; break;
            case 19:
            case 20: nClass = CLASS_TYPE_CLERIC; nPack = 22; break;

            }

            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = Random(2)+1; break; //Niveles de 2 a 4
            case 1: nLevel = Random(4)+4; break; //Niveles de 5 a 8
            case 2: nLevel = Random(4)+10; break; //Niveles de 9 a 12
            case 3: nLevel = Random(4)+14; break;//Niveles de 13 a 16
            case 4: nLevel = Random(4)+16; break;//Niveles de 17 a 21
            }
            if(oCreated != OBJECT_INVALID){
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 76, nPack));
            DelayCommand(1.4, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.2, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.6, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            AssignCommand(oCreated, ActionRandomWalk());  }

        }

        //ELITE (Uno por spawn)
        nNumMons = 1;
        for (i=0;i<nNumMons;i++) {
        object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
        nPack = nClass;
        switch(d20())
            {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7: nClass = CLASS_TYPE_BARBARIAN;break;
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14: nClass = CLASS_TYPE_WIZARD; nPack = 34; break;
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20: nClass = CLASS_TYPE_CLERIC; nPack = 22; break;

            }

            //Ajustamos el nivel
            int iFue = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_STRENGTH);
            int iDes = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_DEXTERITY);
            int iSab = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_WISDOM);
            int iInt = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE);
            int iCar = NWNX_Creature_GetRawAbilityScore(oCreated, ABILITY_CHARISMA);

            if(oCreated != OBJECT_INVALID){
            switch(nClass) {
                case CLASS_TYPE_ROGUE: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_DEXTERITY, iDes + 2); break;
                case CLASS_TYPE_FIGHTER: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
                case CLASS_TYPE_CLERIC: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_WISDOM, iSab + 2); break;
                case CLASS_TYPE_WIZARD: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_INTELLIGENCE, iInt + 2); break;
                case CLASS_TYPE_BARBARIAN: NWNX_Creature_SetRawAbilityScore(oCreated, ABILITY_STRENGTH, iFue + 2); break;
            }
            //Nivel de Encuentro
            switch(sEncuentro)
            {
            case 0: nLevel = 4; break;
            case 1: nLevel = 8; break;
            case 2: nLevel = 12; break;
            case 3: nLevel = 18; break;
            case 4: nLevel = 20; break;
            }

            SetLocalInt(oCreated, "ENC_ELITE", 1);
            SetLocalInt(oCreated, "ENC_CLASS", nClass);
            SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
            DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 76, nPack));
            DelayCommand(1.4, AsignarApariencia(nClass, oCreated, oArea));
            DelayCommand(1.6, AsignarNombre(oCreated, oArea));
            //DelayCommand(1.6, AjustarEquipo(oCreated));
            DelayCommand(3.0, ForceRest(oCreated));
            }

        }

    }
}

void main()
{
  // Solo desencadenado por jugadores
  object oPC = GetEnteringObject();
  object oArea = GetArea(oPC);
  if(!GetIsPC(oPC) || GetIsDM(oPC)) return;

  // Solo una vez cada 20 minutos
  object oMod = GetModule();
  string sArea = "NOENC_"+GetTag(oArea);
  if(GetLocalInt(oMod, sArea) == TRUE) return;
  SetLocalInt(oMod, sArea, TRUE);
  DelayCommand(900.0, DeleteLocalInt(oMod, sArea));

  // Buscamos el encuentro definido.
  int sEncuentro = GetLocalInt(oArea, "NIVEL_ENCUENTRO");
  int sTipoEncuentro = GetLocalInt(oArea, "TIPO_ENCUENTRO");

  //Creamos el encuentro segun el tipo
  switch(sTipoEncuentro)
    {
    case 0:CrearEncuentroHumanos(sEncuentro, oArea, oPC); break;
    case 1:CrearEncuentroOrcos(sEncuentro, oArea, oPC); break;
    case 2:CrearEncuentroNomuertos(sEncuentro, oArea, oPC); break;
    case 3:CrearEncuentroReptiles(sEncuentro, oArea, oPC);break;
    case 4:CrearEncuentroMagico(sEncuentro, oArea, oPC);break;
    case 5:CrearEncuentroConstructo(sEncuentro, oArea, oPC);break;
    case 6:CrearEncuentroInfra(sEncuentro, oArea, oPC);break;
    case 7:CrearEncuentroRandom(sEncuentro, oArea, oPC);break;
    }

}

