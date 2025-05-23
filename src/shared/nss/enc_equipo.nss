/////////////////////////////////////////////////////////////////
//
// Script de Asignar Equipo y Poderes según encuentro
//
/////////////////////////////////////////////////////////////////

#include "nwnx_creature"
#include "x2_inc_itemprop"

void AsignarPoderes(object oCreature)
{

object oGarraEquipadaR = GetItemInSlot(INVENTORY_SLOT_ARMS, oCreature);
object oPiel;
object oFakePiel = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
object oPielEquipar = GetLocalObject(oCreature, "PielEquipar");

int iPsionico = GetLocalInt(oCreature, "Psionico");
int iOculares = GetLocalInt(oCreature, "Beholder");
int iSlaad = GetLocalInt(oCreature, "Slaad");
int iDemonio = GetLocalInt(oCreature, "Demonio");
int iNaga = GetLocalInt(oCreature, "Naga");
int iGolem = GetLocalInt(oCreature, "Golem");
int iGiganteFuego = GetLocalInt(oCreature, "Gigante_Fuego");
int iGiganteFrio = GetLocalInt(oCreature, "Gigante_Frio");
int iZombie = GetLocalInt(oCreature, "Zombie");
int iGhoul = GetLocalInt(oCreature, "Ghoul");
int iSombra = GetLocalInt(oCreature, "Sombra");
int iMomia = GetLocalInt(oCreature, "Momia");
int iVampiro = GetLocalInt(oCreature, "Vampiro");
int iEspectro = GetLocalInt(oCreature, "Espectro");
int iLiche = GetLocalInt(oCreature, "Liche");
int iCromatico = GetLocalInt(oCreature, "Cromatico");
int iAboleth = GetLocalInt(oCreature, "Aboleth");
int iTracnido = GetLocalInt(oCreature, "Tracnido");
int iVeneno = GetLocalInt(oCreature, "PulsoVeneno");
int iManticora = GetLocalInt(oCreature, "Manticora");
int iHellcat = GetLocalInt(oCreature, "Hellcat");
int iArpia = GetLocalInt(oCreature, "Arpia");
int iMiconido = GetLocalInt(oCreature, "Miconido");

//PODERES Miconido
if(iMiconido == 1)
    {
    //Pulso Esporas
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 282;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Pulso Veneno
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 297;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    }

//PODERES Arpia
if(iArpia == 1)
    {
    //Cancion de Arpia
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 686;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Dominar
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 45;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    }

//PODERES Hellcat
if(iHellcat == 1)
    {
    //Krenshar Scare
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 276;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Efecto Gato Infernal
    effect eOculto = EffectConcealment(50);
    effect eVelocidad = EffectMovementSpeedIncrease(25);
    effect eFx1 = EffectVisualEffect(VFX_DUR_GLOW_WHITE);
    effect eFx2 = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
    effect eFx3 = EffectVisualEffect(VFX_DUR_ICESKIN);
    effect eLink = EffectLinkEffects(eOculto, eFx1);
    eLink = EffectLinkEffects(eLink, eFx2);
    eLink = EffectLinkEffects(eLink, eFx3);
    eLink = EffectLinkEffects(eLink, eVelocidad);
    eLink = SupernaturalEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCreature);
    //RD 10/+3
    effect eRD = SupernaturalEffect(EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRD, oCreature);
    }

//PODERES Manticora
if(iManticora == 1)
    {
    //Pulso Esporas
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 282;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Cono de Paralisis
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 261;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    }

//PODERES Veneno
if(iVeneno == 1)
    {
    //Pulso Veneno
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 297;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Inmunidad Veneno
    effect ePoison = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_POISON));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oCreature);
    }

//PODERES Tracnidos
if(iTracnido == 1)
    {
    //Tela de Araña
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 192;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Inmunidad telaraña
    effect eEntangle = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEntangle, oCreature);
    }

//PODERES Aboleth
if(iAboleth == 1)
    {
    //Pulso Stun
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 272;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 14;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Dominar
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 801;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 14;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    //Confusion al golpear
    IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyOnHitProps(IP_CONST_ONHIT_CONFUSION, IP_CONST_ONHIT_SAVEDC_24, IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS));
    //RC y Inmunidad Enajenación
    effect eResistenciaMagica = SupernaturalEffect(EffectSpellResistanceIncrease(10 + GetHitDice(oCreature)));
    effect eImmuConjurosEnajenadores = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistenciaMagica, oCreature);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuConjurosEnajenadores, oCreature);
    }

//PODERES Dragones Cromaticos
if(iCromatico == 1)
    {
    //Aliento Fuego
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 797;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 12;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //RC
    effect eResistenciaMagica = SupernaturalEffect(EffectSpellResistanceIncrease(10 + GetHitDice(oCreature)));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistenciaMagica, oCreature);
    if(GetLocalInt(oCreature, "JEFAZO") == 0 ){
    DestroyObject(oFakePiel);
    oPiel = CreateItemOnObject("NW_IT_CREITEMDRA", oCreature);
    SetIdentified(oPiel, TRUE);
    DelayCommand(1.0,AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    DelayCommand(2.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    }
    }

//PODERES Liche
if(iLiche == 1)
    {
    //Aura de Miedo
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 198;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 16;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Aullido de Muerte
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 267;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 12;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    //Ocultacion
    effect eFastHeal = SupernaturalEffect(EffectRegenerate(5, 6.0));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFastHeal, oCreature);
    if(GetLocalInt(oCreature, "JEFAZO") == 0 ){
    DestroyObject(oFakePiel);
    oPiel = CreateItemOnObject("NW_IT_CREITEM048", oCreature);
    SetIdentified(oPiel, TRUE);
    DelayCommand(1.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    DelayCommand(2.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    }
  }


//PODERES Espectro
if(iEspectro == 1)
    {
    //Aura de Miedo
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 198;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 16;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Asesino Fantasmal
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 127;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 16;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    //Garras de drenaje
    IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN, IP_CONST_ONHIT_SAVEDC_24, IP_CONST_ABILITY_STR));
    //Ocultacion
    effect eOcultacion1 = SupernaturalEffect(EffectConcealment(50));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eOcultacion1, oCreature);
    }

//PODERES Vampiro
if(iVampiro == 1)
    {
    //Invisibilidad de vampiro
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 800;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 12;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Dominar de Vampiro
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 801;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 12;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    if(GetLocalInt(oCreature, "JEFAZO") == 0 ){
    DestroyObject(oFakePiel);
    oPiel = CreateItemOnObject("NW_CREITEMVAM", oCreature);
    SetIdentified(oPiel, TRUE);
    DelayCommand(1.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    DelayCommand(2.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    }
  }

//PODERES MOMIA
if(iMomia == 1)
    {
    //Aura Miedo
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 198;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Fortalecer Undeads
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 280;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyOnHitProps(IP_CONST_ONHIT_FEAR, IP_CONST_ONHIT_SAVEDC_20, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS));
    if(GetLocalInt(oCreature, "JEFAZO") == 0 ){
    DestroyObject(oFakePiel);
    oPiel = CreateItemOnObject("NW_CREITEMMUM", oCreature);
    SetIdentified(oPiel, TRUE);
    DelayCommand(1.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    DelayCommand(2.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    }
  }

//PODERES SOMBRA
if(iSombra == 1)
    {
    //Ataque Sombra
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 769;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 5;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN, IP_CONST_ONHIT_SAVEDC_20, IP_CONST_ABILITY_STR));
    if(GetLocalInt(oCreature, "JEFAZO") == 0 ){
    DestroyObject(oFakePiel);
    oPiel = CreateItemOnObject("NW_IT_CREITEMUN4", oCreature);
    SetLocalObject(oCreature, "PielEquipar", oPiel);
    DelayCommand(1.0,AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    DelayCommand(2.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    }
  }

//PODERES NECROFAGO
if(iGhoul == 1)
    {
    //Toque del Necrofago
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 64;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Bruma Tumulario
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 306;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISEASE, IP_CONST_ONHIT_SAVEDC_20, DISEASE_GHOUL_ROT));
    }

//PODERES ZOMBIE
if(iZombie == 1)
    {
    //Bruma Tumulario
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 306;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 5;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    if(GetLocalInt(oCreature, "JEFAZO") == 0 ){
    DestroyObject(oFakePiel);
    oPiel = CreateItemOnObject("NW_IT_CREITEMUN9", oCreature);
    SetIdentified(oPiel, TRUE);
    DelayCommand(1.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    DelayCommand(2.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    }
  }

//PODERES GIGANTE FUEGO
if(iGiganteFuego == 1)
    {
    //Pulso de fuego
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 284;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Cono de fuego
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 232;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    //Resisitir Fuego
    effect eResistFire10 = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_FIRE, 100, 0));
    effect eVulnerableFrio = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, 50));
    effect eGoFast = SupernaturalEffect(EffectMovementSpeedIncrease(25));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistFire10, oCreature);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGoFast, oCreature);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVulnerableFrio, oCreature);
    }

//PODERES GIGANTE FRIO
if(iGiganteFrio == 1)
    {
    //Pulso de frio
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 286;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Cono de frio
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 230;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    //Resistir Frio
    effect eResistCold10 = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_COLD, 100, 0));
    effect eVulnerableFuego = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 50));
    effect eGoFast = SupernaturalEffect(EffectMovementSpeedIncrease(25));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGoFast, oCreature);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVulnerableFuego, oCreature);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistCold10, oCreature);
    }

//PODERES PSIONICOS
if(iPsionico == 1)
    {
    //Psionic Mass Confusion
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 763;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 16;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    // Barrera Psionica
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 741;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 12;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    // Mindflayer_Mindblast_10
    struct NWNX_Creature_SpecialAbility sSpecialAbility3;
    sSpecialAbility3.id = 713;
    sSpecialAbility3.ready = 1;
    sSpecialAbility3.level = 12;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility3);
    IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyOnHitProps(IP_CONST_ONHIT_CONFUSION, IP_CONST_ONHIT_SAVEDC_24, IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS));
    //RC y Inmunidad a Enajenación
    effect eResistenciaMagica = SupernaturalEffect(EffectSpellResistanceIncrease(10 + GetHitDice(oCreature)));
    effect eImmuConjurosEnajenadores = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistenciaMagica, oCreature);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuConjurosEnajenadores, oCreature);
    }

// BEHOLDER CONTEMPLADORES
if(iOculares == 1)
    {
    //Beholder_Special_Spell_AI
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 736;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    // Beholder_Anti_Magic_Cone
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 729;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    // EyeballRay1
    struct NWNX_Creature_SpecialAbility sSpecialAbility3;
    sSpecialAbility3.id = 711;
    sSpecialAbility3.ready = 1;
    sSpecialAbility3.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility3);
    //Rayo de Muerte
    struct NWNX_Creature_SpecialAbility sSpecialAbility4;
    sSpecialAbility4.id = 776;
    sSpecialAbility4.ready = 1;
    sSpecialAbility4.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility4);
    if(GetLocalInt(oCreature, "JEFAZO") == 0 ){
    DestroyObject(oFakePiel);
    oPiel = CreateItemOnObject("x2_it_beholprops", oCreature);
    SetIdentified(oPiel, TRUE);
    DelayCommand(1.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    DelayCommand(2.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    }
  }

//SLAADS
if(iSlaad == 1)
    {
    //Slaad_Chaos_Spittle
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 770;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 10;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Slaad_Summon
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 303;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 12;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    //Regeneracion Vampirica
    effect eFastHeal = SupernaturalEffect(EffectRegenerate(2, RoundsToSeconds(1)));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFastHeal, oCreature);
    }

//GOLEM
if(iGolem == 1)
    {
    //Aliento de Golem
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 263;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 16;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Palmada de Golem
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 715;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 12;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    //Resistencia Daño Fisico 20
    effect eRD = SupernaturalEffect(EffectDamageReduction(20, DAMAGE_POWER_PLUS_TWENTY));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRD, oCreature);
    }

//DEMONIOS
if(iDemonio == 1)
    {
    //Summon Baatezu
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 701;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 12;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Aura de miedo
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 198;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 16;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    if(GetLocalInt(oCreature, "JEFAZO") == 0 ){
    DestroyObject(oFakePiel);
    oPiel = CreateItemOnObject("X1_IT_CREITEM001", oCreature);
    SetIdentified(oPiel, TRUE);
    DelayCommand(1.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    DelayCommand(2.0, AssignCommand(oCreature, ActionEquipItem(oPiel, INVENTORY_SLOT_CARMOUR)));
    }
  }

//NAGAS
if(iNaga == 1)
    {
    //Aura Horripilante
    struct NWNX_Creature_SpecialAbility sSpecialAbility1;
    sSpecialAbility1.id = 804;
    sSpecialAbility1.ready = 1;
    sSpecialAbility1.level = 12;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility1);
    //Ojo de Naga
    struct NWNX_Creature_SpecialAbility sSpecialAbility2;
    sSpecialAbility2.id = 803;
    sSpecialAbility2.ready = 1;
    sSpecialAbility2.level = 12;
    NWNX_Creature_AddSpecialAbility(oCreature, sSpecialAbility2);
    effect eResistenciaMagica = SupernaturalEffect(EffectSpellResistanceIncrease(10 + GetHitDice(oCreature)));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistenciaMagica, oCreature);
    }

//No drop items por seguridad
     object oItem = GetFirstItemInInventory(oCreature);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        oItem = GetNextItemInInventory(oCreature);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)
     {
        oItem = GetItemInSlot(i, oCreature);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }

}


void AjustarEquipoGarras(object oCreature)
{

 object oGarraR;
 object oGarraL;
 object oArmor;
 int sTipoEncuentro = GetLocalInt(GetArea(oCreature), "TIPO_ENCUENTRO");
 int sEncuentro = GetLocalInt(GetArea(oCreature), "NIVEL_ENCUENTRO");
 int nClass = GetLocalInt(oCreature, "ENC_CLASS");
 int sCA = 0;
 int cCA = 0;

 //Equipo
 if(GetLocalInt(oCreature, "JEFAZO") == 1) return;

 string Garra1d4 = "nw_it_mglove008";
 string Garra1d6 = "nw_it_mglove008";
 string Garra1d8 = "nw_it_mglove008";
 string ArmorLigera = "nw_aarcl001";
 string ArmorMedia = "nw_aarcl004";
 string ArmorPesada = "nw_aarcl007";
 string ArmorRopas = "nw_mcloth013";

     //Ajustamos Stats
            int iFue = NWNX_Creature_GetRawAbilityScore(oCreature, ABILITY_STRENGTH);
            int iDes = NWNX_Creature_GetRawAbilityScore(oCreature, ABILITY_DEXTERITY);
            int iSab = NWNX_Creature_GetRawAbilityScore(oCreature, ABILITY_WISDOM);
            int iCon = NWNX_Creature_GetRawAbilityScore(oCreature, ABILITY_CONSTITUTION);
            int iInt = NWNX_Creature_GetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE);
            int iCar = NWNX_Creature_GetRawAbilityScore(oCreature, ABILITY_CHARISMA);


    //EQUIPAMIENTO POR CLASE Y NIVEL DE ENCUENTRO
    if(nClass == CLASS_TYPE_CLERIC) {
            switch(sEncuentro) {
                                case 0:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 4);
                                        break;
                                case 1:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 6);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 2:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 4);
                                        cCA += 8;
                                        break;
                                case 3:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 6);
                                        cCA += 10;
                                        break;
                                case 4:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 12);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 8);
                                        cCA += 10;
                                        break;
                                }

                        }

    if(nClass == CLASS_TYPE_ROGUE) {
            switch(sEncuentro) {
                                case 0:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 2);
                                        break;
                                case 1:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 2:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 8);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 4);
                                        break;
                                case 3:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 8);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 6);
                                        break;
                                case 4:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 8);
                                        break;
                                }

                        }
    if(nClass == CLASS_TYPE_FIGHTER || nClass == CLASS_TYPE_CONSTRUCT) {
            switch(sEncuentro) {
                                case 0:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes - 2);
                                        break;
                                case 1:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes - 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        cCA += 5;
                                        break;
                                case 2:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes - 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 4);
                                        cCA += 8;
                                        break;
                                case 3:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 6);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes - 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 6);
                                        cCA += 10;
                                        break;
                                case 4:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes - 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 8);
                                        cCA += 10;
                                        break;
                                }

                        }


    if(nClass == CLASS_TYPE_BARBARIAN) {
            switch(sEncuentro) {
                                case 0:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 2);
                                        break;
                                case 1:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 2:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        cCA += 4;
                                        break;
                                case 3:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 8);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        cCA += 4;
                                        break;
                                case 4:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 8);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        cCA += 6;
                                        break;
                                }

                        }

    if(nClass == CLASS_TYPE_WIZARD) {
            switch(sEncuentro) {
                                case 0:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE, iInt + 4);
                                        ActionCastSpellAtObject(SPELL_MAGE_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 4, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        break;
                                case 1:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE, iInt + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        ActionCastSpellAtObject(SPELL_MAGE_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 8, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_INVISIBILITY, oCreature, METAMAGIC_ANY, TRUE, 8, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        break;
                                case 2:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE, iInt + 6);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 4);
                                        ActionCastSpellAtObject(SPELL_MAGE_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 12, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_IMPROVED_INVISIBILITY, oCreature, METAMAGIC_ANY, TRUE, 12, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_HASTE, oCreature, METAMAGIC_ANY, TRUE, 12, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_DEATH_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 12, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        break;
                                case 3:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE, iInt + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 4);
                                        ActionCastSpellAtObject(SPELL_MAGE_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_IMPROVED_INVISIBILITY, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_HASTE, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_DEATH_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_SEE_INVISIBILITY, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        break;
                                case 4:
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE, iInt + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 4);
                                        ActionCastSpellAtObject(SPELL_MAGE_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_IMPROVED_INVISIBILITY, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_HASTE, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_DEATH_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_SEE_INVISIBILITY, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        ActionCastSpellAtObject(SPELL_GLOBE_OF_INVULNERABILITY, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
                                        break;
                                }

                        }



     int nDam1 = IP_CONST_DAMAGETYPE_SONIC;
     int nDam2 = IP_CONST_DAMAGETYPE_BLUDGEONING;

    object oGarraEquipadaR = GetItemInSlot(INVENTORY_SLOT_ARMS, oCreature);
    int iHellcat = GetLocalInt(oCreature, "Hellcat");

    //Si son nomuertos..
    if(sTipoEncuentro == 2) { nDam1 = IP_CONST_DAMAGETYPE_NEGATIVE; nDam2 = IP_CONST_DAMAGETYPE_SLASHING; }
    if(iHellcat == 1) { nDam1 = IP_CONST_DAMAGETYPE_FIRE; nDam2 = IP_CONST_DAMAGETYPE_SLASHING; }

if(oGarraEquipadaR != OBJECT_INVALID)
    {
        switch(sEncuentro)
        {
        case 0: IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyAttackBonus(1));
                IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyDamageBonus(nDam1, IP_CONST_DAMAGEBONUS_2));
                sCA = 5;
                break;
        case 1: IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyAttackBonus(2));
                IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyDamageBonus(nDam1, IP_CONST_DAMAGEBONUS_1d4));
                IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyDamageBonus(nDam2, IP_CONST_DAMAGEBONUS_1d4));
                sCA = 5;
                break;
        case 2: IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyAttackBonus(3));
                IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyDamageBonus(nDam1, IP_CONST_DAMAGEBONUS_1d6));
                IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyDamageBonus(nDam2, IP_CONST_DAMAGEBONUS_1d6));
                sCA = 15;
                break;
        case 3: IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyAttackBonus(4));
                IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyDamageBonus(nDam1, IP_CONST_DAMAGEBONUS_1d8));
                IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyDamageBonus(nDam2, IP_CONST_DAMAGEBONUS_1d8));
                sCA = 20;
                break;
        case 4: IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyAttackBonus(5));
                IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyDamageBonus(nDam1, IP_CONST_DAMAGEBONUS_1d10));
                IPSafeAddItemProperty(oGarraEquipadaR, ItemPropertyDamageBonus(nDam2, IP_CONST_DAMAGEBONUS_1d10));
                sCA = 20;
                break;
        }

    }

     //Aplicamos la CA a la criatura directamente
    effect eCA = SupernaturalEffect(EffectACIncrease(sCA, AC_DODGE_BONUS));
    effect oCA = SupernaturalEffect(EffectACIncrease(cCA, AC_NATURAL_BONUS));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCA, oCreature);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, oCA, oCreature);


    //No drop items por seguridad
     object oItem = GetFirstItemInInventory(oCreature);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        oItem = GetNextItemInInventory(oCreature);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)
     {
        oItem = GetItemInSlot(i, oCreature);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }

    //Hacemos que equipe todo
     AssignCommand(oCreature, ClearAllActions(TRUE));
     AssignCommand(oCreature,ActionRandomWalk());
}

void AjustarEquipo(object oCreature)
{
 if(GetLocalInt(oCreature, "JEFAZO") == 1) return;
 object oEscudo;
 object oArma;
 object oArma2;
 object oMunicion;
 object oArmor;
 int sTipoEncuentro = GetLocalInt(GetArea(oCreature), "TIPO_ENCUENTRO");
 int sEncuentro = GetLocalInt(GetArea(oCreature), "NIVEL_ENCUENTRO");
 int nClass = GetLocalInt(oCreature, "ENC_CLASS");
 int sCA = 0;

 //Equipo
 string EscudoPequeno = "nw_ashmsw002";
 string EscudoGrande = "nw_ashlw001";
 string Daga = "nw_wswdg001";
 string EspadaLarga = "nw_wswls001";
 string EspadaCorta = "nw_wswss001";
 string Maza = "nw_wblml001";
 string Cimitarra = "nw_wswsc001";
 string BastonMago = "nw_wmgst005";
 string GranHacha = "nw_waxgr001";
 string Hacha = "nw_waxhn001";
 string ArmorLigera = "nw_aarcl001";
 string ArmorMedia = "nw_aarcl004";
 string ArmorPesada = "nw_aarcl007";
 string ArmorRopas = "nw_mcloth013";
 string Arco = "nw_wbwmsh010";
 string Flechas = "NW_WAMAR001";

          //Ajustamos Stats
            int iFue = NWNX_Creature_GetRawAbilityScore(oCreature, ABILITY_STRENGTH);
            int iDes = NWNX_Creature_GetRawAbilityScore(oCreature, ABILITY_DEXTERITY);
            int iSab = NWNX_Creature_GetRawAbilityScore(oCreature, ABILITY_WISDOM);
            int iCon = NWNX_Creature_GetRawAbilityScore(oCreature, ABILITY_CONSTITUTION);
            int iInt = NWNX_Creature_GetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE);
            int iCar = NWNX_Creature_GetRawAbilityScore(oCreature, ABILITY_CHARISMA);

    //EQUIPAMIENTO POR CLASE Y NIVEL DE ENCUENTRO
    if(nClass == CLASS_TYPE_CLERIC) {
            switch(sEncuentro) {
                                case 0: oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oArma = CreateItemOnObject(Maza, oCreature);
                                        oArmor = CreateItemOnObject(ArmorMedia, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 4);
                                        break;
                                case 1: oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oArma = CreateItemOnObject(Maza, oCreature);
                                        oArmor = CreateItemOnObject(ArmorMedia, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 2: oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oArma = CreateItemOnObject(Maza, oCreature);
                                        oArmor = CreateItemOnObject(ArmorPesada, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 6);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 4);
                                        break;
                                case 3: oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oArma = CreateItemOnObject(Maza, oCreature);
                                        oArmor = CreateItemOnObject(ArmorPesada, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 6);
                                        break;
                                case 4: oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oArma = CreateItemOnObject(Maza, oCreature);
                                        oArmor = CreateItemOnObject(ArmorPesada, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 8);
                                        break;
                                }

                        }

    if(nClass == CLASS_TYPE_DRUID) {
            switch(sEncuentro) {
                                case 0: oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oArma = CreateItemOnObject(Cimitarra, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 4);
                                        break;
                                case 1: oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oArma = CreateItemOnObject(Cimitarra, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 2: oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oArma = CreateItemOnObject(Cimitarra, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 6);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 4);
                                        break;
                                case 3: oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oArma = CreateItemOnObject(Cimitarra, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 6);
                                        break;
                                case 4: oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oArma = CreateItemOnObject(Cimitarra, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 8);
                                        break;
                                }

                        }


    if(nClass == CLASS_TYPE_ROGUE) {
            switch(sEncuentro) {
                                case 0: oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oArma = CreateItemOnObject(Daga, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon - 2);
                                        break;
                                case 1: oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oArma = CreateItemOnObject(Daga, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon - 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 2: oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oArma = CreateItemOnObject(Daga, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 6);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon - 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 4);
                                        break;
                                case 3: oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oArma = CreateItemOnObject(Daga, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon - 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 6);
                                        break;
                                case 4: oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oArma = CreateItemOnObject(Daga, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon - 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 8);
                                        break;
                                }

                        }
    if(nClass == CLASS_TYPE_FIGHTER || nClass == CLASS_TYPE_CONSTRUCT) {
            switch(sEncuentro) {
                                case 0: oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oArma = CreateItemOnObject(EspadaCorta, oCreature);
                                        oArmor = CreateItemOnObject(ArmorMedia, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes - 2);
                                        break;
                                case 1: oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oArma = CreateItemOnObject(EspadaLarga, oCreature);
                                        oArmor = CreateItemOnObject(ArmorMedia, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes - 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 2: oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oArma = CreateItemOnObject(EspadaLarga, oCreature);
                                        oArmor = CreateItemOnObject(ArmorPesada, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes - 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 4);
                                        break;
                                case 3: oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oArma = CreateItemOnObject(EspadaLarga, oCreature);
                                        oArmor = CreateItemOnObject(ArmorPesada, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 6);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes - 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 6);
                                        break;
                                case 4: oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oArma = CreateItemOnObject(EspadaLarga, oCreature);
                                        oArmor = CreateItemOnObject(ArmorPesada, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 6);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes - 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 8);
                                        break;
                                }

                        }

    if(nClass == CLASS_TYPE_BARBARIAN ) {
            switch(sEncuentro) {
                                case 0: oArma = CreateItemOnObject(Hacha, oCreature);
                                        oArma2 = CreateItemOnObject(Arco, oCreature);
                                        oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oMunicion =  CreateItemOnObject(Flechas, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 2);
                                        break;
                                case 1: oArma = CreateItemOnObject(Hacha, oCreature);
                                        oArma2 = CreateItemOnObject(Arco, oCreature);
                                        oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oMunicion =  CreateItemOnObject(Flechas, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 2: oArma = CreateItemOnObject(GranHacha, oCreature);
                                        oArma2 = CreateItemOnObject(Arco, oCreature);
                                        oMunicion =  CreateItemOnObject(Flechas, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 3: oArma = CreateItemOnObject(GranHacha, oCreature);
                                        oArma2 = CreateItemOnObject(Arco, oCreature);
                                        oMunicion =  CreateItemOnObject(Flechas, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 8);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 4: oArma = CreateItemOnObject(GranHacha, oCreature);
                                        oArma2 = CreateItemOnObject(Arco, oCreature);
                                        oMunicion =  CreateItemOnObject(Flechas, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 8);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                }

                        }

    if(nClass == CLASS_TYPE_RANGER) {
            switch(sEncuentro) {
                                case 0: oArma = CreateItemOnObject(EspadaLarga, oCreature);
                                        oArma2 = CreateItemOnObject(Arco, oCreature);
                                        oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oMunicion =  CreateItemOnObject(Flechas, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 2);
                                        break;
                                case 1: oArma = CreateItemOnObject(EspadaLarga, oCreature);
                                        oArma2 = CreateItemOnObject(Arco, oCreature);
                                        oEscudo = CreateItemOnObject(EscudoPequeno, oCreature);
                                        oMunicion =  CreateItemOnObject(Flechas, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 2);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 2: oArma = CreateItemOnObject(EspadaLarga, oCreature);
                                        oArma2 = CreateItemOnObject(Arco, oCreature);
                                        oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oMunicion =  CreateItemOnObject(Flechas, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 3: oArma = CreateItemOnObject(EspadaLarga, oCreature);
                                        oArma2 = CreateItemOnObject(Arco, oCreature);
                                        oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oMunicion =  CreateItemOnObject(Flechas, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 6);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 8);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 4: oArma = CreateItemOnObject(EspadaLarga, oCreature);
                                        oArma2 = CreateItemOnObject(Arco, oCreature);
                                        oEscudo = CreateItemOnObject(EscudoGrande, oCreature);
                                        oMunicion =  CreateItemOnObject(Flechas, oCreature);
                                        oArmor = CreateItemOnObject(ArmorLigera, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, iSab + 8);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, iDes + 8);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                }

                        }


    if(nClass == CLASS_TYPE_WIZARD) {
            switch(sEncuentro) {
                                case 0: oArma = CreateItemOnObject(BastonMago, oCreature);
                                        oArmor = CreateItemOnObject(ArmorRopas, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE, iInt + 4);
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_MAGE_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 4, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        break;
                                case 1: oArma = CreateItemOnObject(BastonMago, oCreature);
                                        oArmor = CreateItemOnObject(ArmorRopas, oCreature);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE, iInt + 4);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_MAGE_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 8, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_INVISIBILITY, oCreature, METAMAGIC_ANY, TRUE, 8, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_HASTE, oCreature, METAMAGIC_ANY, TRUE, 8, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        break;
                                case 2: oArma = CreateItemOnObject(BastonMago, oCreature);
                                        oArmor = CreateItemOnObject(ArmorRopas, oCreature);
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_MAGE_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 12, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_IMPROVED_INVISIBILITY, oCreature, METAMAGIC_ANY, TRUE, 12, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_HASTE, oCreature, METAMAGIC_ANY, TRUE, 12, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_DEATH_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 12, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE, iInt + 6);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 3: oArma = CreateItemOnObject(BastonMago, oCreature);
                                        oArmor = CreateItemOnObject(ArmorRopas, oCreature);
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_MAGE_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_IMPROVED_INVISIBILITY, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_HASTE, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_DEATH_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_SEE_INVISIBILITY, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE, iInt + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                case 4: oArma = CreateItemOnObject(BastonMago, oCreature);
                                        oArmor = CreateItemOnObject(ArmorRopas, oCreature);
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_MAGE_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_IMPROVED_INVISIBILITY, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_HASTE, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_DEATH_ARMOR, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_SEE_INVISIBILITY, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        AssignCommand(oCreature,ActionCastSpellAtObject(SPELL_GLOBE_OF_INVULNERABILITY, oCreature, METAMAGIC_ANY, TRUE, 16, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE, iInt + 10);
                                        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 2);
                                        break;
                                }

                        }

     //Marcamos los items para aplicarles los bonos
     SetLocalObject(oCreature, "ArmaEquipada", oArma);
     SetLocalObject(oCreature, "ArmaEquipada2", oArma2);
     SetLocalObject(oCreature, "ArmaduraEquipada", oArmor);
     SetLocalObject(oCreature, "EscudoEquipado", oEscudo);

     object oArmaEquipada = GetLocalObject(oCreature, "ArmaEquipada");
     object oArmaEquipada2 = GetLocalObject(oCreature, "ArmaEquipada2");
     object oArmorEquipada = GetLocalObject(oCreature, "ArmaduraEquipada");
     object oEscudoEquipado = GetLocalObject(oCreature, "EscudoEquipado");

     //Ponemos otra apariencia al Escudo
     int nBaseType = GetBaseItemType(oEscudoEquipado);
     int nCurrApp;
     object oNew;

    if(nBaseType == BASE_ITEM_SMALLSHIELD) {
            switch (Random(5)) {
                case 0: nCurrApp = 123; break;
                case 1: nCurrApp = 124; break;
                case 2: nCurrApp = 59; break;
                case 3: nCurrApp = 102; break;
                case 4: nCurrApp = 43; break;
                        }
             oNew = CopyItemAndModify(oEscudoEquipado, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nCurrApp, TRUE);
                }
    if(nBaseType == BASE_ITEM_LARGESHIELD) {
             switch (Random(5)) {
                case 0: nCurrApp = 51; break;
                case 1: nCurrApp = 52; break;
                case 2: nCurrApp = 25; break;
                case 3: nCurrApp = 28; break;
                case 4: nCurrApp = 54; break;
                        }
             oNew = CopyItemAndModify(oEscudoEquipado, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nCurrApp, TRUE);
                }

           //Si se ha generado el escudo nuevo correctamente lo equipamos
           if(GetIsObjectValid(oNew))
                {
        DestroyObject(oEscudoEquipado);
                }

     //Equipamos y aplicamos bonificadores
     AssignCommand(oCreature, ClearAllActions(TRUE));
     AssignCommand(oCreature, ActionEquipItem(oNew, INVENTORY_SLOT_LEFTHAND));
     AssignCommand(oCreature, ActionEquipItem(oEscudo, INVENTORY_SLOT_LEFTHAND));
     AssignCommand(oCreature, ActionEquipItem(oArma, INVENTORY_SLOT_RIGHTHAND));
     AssignCommand(oCreature, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST));
     AssignCommand(oCreature, ActionEquipItem(oMunicion, INVENTORY_SLOT_ARROWS));

     int nDamFire = IP_CONST_DAMAGETYPE_FIRE;
     int nVisual = ITEM_VISUAL_FIRE;

    //Según tipo cambia el daño
    int iGiganteFrio = GetLocalInt(oCreature, "Gigante_Frio");
    int iVeneno = GetLocalInt(oCreature, "PulsoVeneno");
    int iRandom = Random(5);
    switch (iRandom)
    {
        case 0: nDamFire = IP_CONST_DAMAGETYPE_FIRE; nVisual = ITEM_VISUAL_FIRE; break;
        case 1: nDamFire = IP_CONST_DAMAGETYPE_COLD; nVisual = ITEM_VISUAL_COLD; break;
        case 2: nDamFire = IP_CONST_DAMAGETYPE_ELECTRICAL; nVisual = ITEM_VISUAL_ELECTRICAL; break;
        case 3: nDamFire = IP_CONST_DAMAGETYPE_SONIC; nVisual = ITEM_VISUAL_SONIC; break;
        case 4: nDamFire = IP_CONST_DAMAGETYPE_ACID; nVisual = ITEM_VISUAL_ACID; break;
        default: nDamFire = IP_CONST_DAMAGETYPE_FIRE; nVisual = ITEM_VISUAL_FIRE; break;
    }
    if(sTipoEncuentro == 2) { nDamFire = IP_CONST_DAMAGETYPE_NEGATIVE; nVisual = ITEM_VISUAL_EVIL; }
    if(iGiganteFrio == 1) { nDamFire = IP_CONST_DAMAGETYPE_COLD; nVisual = ITEM_VISUAL_COLD; }
    if(iVeneno == 1) { nDamFire = IP_CONST_DAMAGETYPE_ACID; nVisual = ITEM_VISUAL_ACID; }


if(oArmaEquipada != OBJECT_INVALID || oArmorEquipada != OBJECT_INVALID)
    {
        switch(sEncuentro)
        {
        case 0: IPSafeAddItemProperty(oArmaEquipada, ItemPropertyEnhancementBonus(1));
                sCA = 2;
                if(oArmaEquipada2 != OBJECT_INVALID)
                    {
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyEnhancementBonus(1));
                    }
                break;
        case 1: IPSafeAddItemProperty(oArmaEquipada, ItemPropertyEnhancementBonus(2));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyDamageBonus(nDamFire, IP_CONST_DAMAGEBONUS_1));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyVisualEffect(nVisual));
                sCA = 5;
                if(oArmaEquipada2 != OBJECT_INVALID)
                    {
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyEnhancementBonus(2));
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyDamageBonus(nDamFire, IP_CONST_DAMAGEBONUS_1));
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1));
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyVisualEffect(nVisual));
                    }
                break;
        case 2: IPSafeAddItemProperty(oArmaEquipada, ItemPropertyEnhancementBonus(3));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyDamageBonus(nDamFire, IP_CONST_DAMAGEBONUS_1d4));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyVisualEffect(nVisual));
                IPSafeAddItemProperty(oArmorEquipada, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_PHYSICAL, IP_CONST_DAMAGEIMMUNITY_5_PERCENT));
                sCA = 15;
                if(oArmaEquipada2 != OBJECT_INVALID)
                    {
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyEnhancementBonus(3));
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyDamageBonus(nDamFire, IP_CONST_DAMAGEBONUS_1d4));
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1));
                    }
                break;
        case 3: IPSafeAddItemProperty(oArmaEquipada, ItemPropertyEnhancementBonus(4));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyDamageBonus(nDamFire, IP_CONST_DAMAGEBONUS_1d4));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_1d4));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyVisualEffect(nVisual));
                IPSafeAddItemProperty(oArmorEquipada, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_PHYSICAL, IP_CONST_DAMAGEIMMUNITY_10_PERCENT));
                IPSafeAddItemProperty(oArmorEquipada, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEIMMUNITY_5_PERCENT));
                sCA = 20;
                if(oArmaEquipada2 != OBJECT_INVALID)
                    {
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyEnhancementBonus(4));
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyDamageBonus(nDamFire, IP_CONST_DAMAGEBONUS_1d4));
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_1d4));
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1));
                    }
                break;
        case 4: IPSafeAddItemProperty(oArmaEquipada, ItemPropertyEnhancementBonus(5));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyDamageBonus(nDamFire, IP_CONST_DAMAGEBONUS_1d6));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_1d6));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1));
                IPSafeAddItemProperty(oArmaEquipada, ItemPropertyVisualEffect(nVisual));
                IPSafeAddItemProperty(oArmorEquipada, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_PHYSICAL, IP_CONST_DAMAGEIMMUNITY_25_PERCENT));
                IPSafeAddItemProperty(oArmorEquipada, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEIMMUNITY_5_PERCENT));
                sCA = 20;
                if(oArmaEquipada2 != OBJECT_INVALID)
                    {
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyEnhancementBonus(5));
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyDamageBonus(nDamFire, IP_CONST_DAMAGEBONUS_1d6));
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_1d6));
                     IPSafeAddItemProperty(oArmaEquipada2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1));
                    }
                break;
        }

    }

    //Aplicamos la CA a la criatura directamente
    effect eCA = SupernaturalEffect(EffectACIncrease(sCA, AC_DODGE_BONUS));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCA, oCreature);

    //Bonos para Gigantes
    if(GetRacialType(oCreature) == RACIAL_TYPE_GIANT) {
        effect eGoFast = SupernaturalEffect(EffectMovementSpeedIncrease(25));
        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, iFue + 6);
        NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, iCon + 4);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGoFast, oCreature);
        }

    //No drop items por seguridad
     object oItem = GetFirstItemInInventory(oCreature);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        oItem = GetNextItemInInventory(oCreature);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)
     {
        oItem = GetItemInSlot(i, oCreature);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }

 //Paseamos!
 DelayCommand(5.0,AssignCommand(oCreature,ActionRandomWalk()));

}



