//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guion:  hc_defaults                                       //:://
//::////////////////////////////////////////////////////////////////////////////
//:: GUION ORIGINAL HCR 3.3b                                              //:://
//:: Modificado para el servidor Puerta de Baldur                         //:://
//::////////////////////////////////////////////////////////////////////////////
#include "hc_inc"

// Setting BLEEDSYSTEM to 0 will remove the bleed to death system.
int BLEEDSYSTEM = 1;

    // controls the time between each bleed check a PC must makes each while in
    // the DYING state. Reducing the number will accelerate the possibility of
    // a PC bleeding to death. Default is 1 round.
    float HC_BLEED_DYING_DELAY  = 12.0;

    // controls the time between each bleed check a PC must makes each while in
    // the STABLE state. Reducing the number will accelerate the possibility of
    // a PC bleeding to death or the rate at which they heal. Default is 1 hour.
    float HC_BLEED_STABLE_DELAY = 10.0;

    // the percentage chance of spontaneous self-stabalising.  Setting this to
    // 0 will prevent player's from spontaneously stabailing while dying forcing
    // them to bleed out or receive aid. Default is 10%.
    int HC_BLEED_STABLISE_CHANCE = 10;

    // the percentage chance of spontaneous self-recovery.  Setting this to 0
    // will prevent player's from spontaneously recovering while stable or in
    // recovery forcing to bleed out/heal naturally (respectively) or receive
    // aid. Default is 10%.
    int HC_BLEED_RECOVERY_CHANCE = 10;

// Setting DYINGSTRIP to 0 will stop stripping players of inventory on dying
int DYINGSTRIP = 1;

// Setting RESTSYSTEM to 0 will remove rest restrictions from play.
int RESTSYSTEM = 1;

// Controls how long between rests if RESTSYSTEM is used.
int RESTBREAK = 6;

// Set to 0 to turn off the penalty for resting in armor > 5.
int RESTARMORPEN = 1;

// Setting this to 0 will allow full healing on each rest.
int LIMITEDRESTHEAL = 1;

// Set to 0 to turn off the functioning of bedrolls and the requirement to have
// them to rest.
int BEDROLLSYSTEM = 1;

// Setting this to 0 will turn off the conversation to have to rest.
int RESTCONV = 1;

// Setting this to 1 will turn on the party rest to advance time on rest. Will
// only work when RESTCONV is set to 1. Also only for use with one party setting
// in Mod.
int PARTYREST = 0;

// Set to 1 if you want to allow pcs to rest while under certain bad effects.
int BADREST = 0;

// Setting FOODSYSTEM to 0 will turn off need for food to rest.
int FOODSYSTEM = 1;

// Setting HUNGERSYSTEM to 0 will turn off the need for PCs to regularly consume
// food and water to avoid death by starvation or dehydration.
// Setting this to 1 will IGNORE the FOODSYSTEM flag, and it will use its
// own food system instead.
int HUNGERSYSTEM = 1;

// Setting FATIGUESYSTEM to 0 will turn of the ill effects recieve by a PC that
// goes a time without resting. Note that if this is 0 it will NOT stop fatigue
// penalties resulting from RESTARMORPEN = 1.
int FATIGUESYSTEM = 0;

// GODCHANCE is the percent chance that a pc will be raised by thier god if they have one.
// defaults to 5%.
int GODCHANCE = 5;

void main()
{
  SetLocalInt(oMod, "RESTARMORPEN", RESTARMORPEN);
  SetLocalInt(oMod, "RESTSYSTEM", RESTSYSTEM);
  SetLocalInt(oMod, "RESTBREAK", RESTBREAK);
  SetLocalInt(oMod, "RESTCONV", RESTCONV);
  SetLocalInt(oMod, "PARTYREST", PARTYREST);
  SetLocalInt(oMod, "LIMITEDRESTHEAL", LIMITEDRESTHEAL);
  SetLocalInt(oMod, "BEDROLLSYSTEM", BEDROLLSYSTEM);
  SetLocalInt(oMod, "BADREST", BADREST);
  SetLocalInt(oMod, "BLEEDSYSTEM", BLEEDSYSTEM);
  if(BLEEDSYSTEM)
  {
      SetLocalFloat(oMod, "HC_Bleed_DyingDelay", HC_BLEED_DYING_DELAY);
      SetLocalFloat(oMod, "HC_Bleed_StableDelay", HC_BLEED_STABLE_DELAY);
      SetLocalInt(oMod, "HC_Bleed_StabliseChance", HC_BLEED_STABLISE_CHANCE);
      SetLocalInt(oMod, "HC_Bleed_RecoveryChance", HC_BLEED_RECOVERY_CHANCE);
  }
  SetLocalInt(oMod, "DYINGSTRIP", DYINGSTRIP);

  SetLocalInt(oMod, "FOODSYSTEM", FOODSYSTEM);
  SetLocalInt(oMod, "HUNGERSYSTEM", HUNGERSYSTEM);
  SetLocalInt(oMod, "FATIGUESYSTEM", FATIGUESYSTEM);
  SetLocalInt(oMod, "GODCHANCE", GODCHANCE);
}
