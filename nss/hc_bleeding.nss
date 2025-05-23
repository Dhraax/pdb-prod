//  ----------------------------------------------------------------------------
//  hc_bleeding
//  ----------------------------------------------------------------------------
/*
    Hardcore Bleeding System

    If used, this system is called by the OnPlayerDying module event script. It
    is used to check and update a PC's player state periodically from the point
    they start are reduced to below 0hp until they have revived or died. Each
    time the script is called it stores the player's hit point after the
    comparing themt o the previously stored value. The difference between the
    value dictates any changes in state.

    This system does NOT replicate the PnP system exactly but is as close as is
    possible and practical for NWN.  As there is currently no DISABLED state
    this script monitors PCs who are DYING, STABLE or in RECOVERY.

    A PC is DYING if their current HP are between -9 and 0 (inclusive). While
    DYING a PC can be fully revived by another (any healing that increases
    HP > 0); be helped to recover by another (using heal skills or any healing
    that cures 1+ HP); spontaneously self-stabilise (default 10% chance each
    round); continue to bleed (default 1HP per round) or die.

    A PC is STABLE if their current HP are between -9 and 0 (inclusive) but they
    have spontaneously self-stabalised. While STABLE a PC can be fully revived
    by another (any healing that increases HP > 0); be helped to recover by
    another (using heal skills or any healing that cures 1+ HP); spontaneously
    regain consciousness and subsequently start to heal (default is 10% chance
    each hour); continue to bleed (default is 1HP per hour) or die.

    A PC is RECOVERING if HP are between -9 and 0 (inclusive) but they have
    stabalised and regained consciouness. While RECOVERING a PC can be fully
    revived by another (any healing that increases HP > 0); spontaneously
    recover (default 10% per hour); heal naturally (default 1HP per hour). In
    this state a PC will not continue to bleed and will only die if killed by
    another.

    Unsupported Features @ HCR 3.02
    -------------------------------

    - a DISABLED state is not included mainly because the game engine will kill
      a player when their HP falls to 0 rather than to -1.
    - a PC who damaged while in STABLE or RECOVERING will not currently start
      bleeding again though they will die if their HP fall below -9.
*/
//  ----------------------------------------------------------------------------
/*
    HCR 3.02
    - rewritten for HCR 3.02

    Credits:
    - Archaegeo
*/
//  ----------------------------------------------------------------------------
#include "hc_inc"
#include "hc_inc_remeff"
#include "hc_inc_timecheck"
#include "hc_text_bleed"


//  ----------------------------------------------------------------------------
//  CONSTANTS
//  ----------------------------------------------------------------------------

// the amount of periodic damage inflicted due to blood loss
const int HC_BLEED_BLOOD_LOSS       = 1;

// the amount of periodic healing gained due to natural healing
const int HC_BLEED_NATURAL_HEAL     = 1;

// name of attribute holding the player's last HP for the bleed system.  This
// attribute is and must remain different from the core attribute for storing
// the player's last HP.
const string HC_VAR_BLEED_LAST_HP           = "HC_Bleed_LastHP";

// name of the attribute holding the time of the player's last recovery check
const string HC_VAR_BLEED_RECOVERY_CHECK    = "LastRecCheck";

// name of global variable holding the time delay between dying checks
const string HC_VAR_BLEED_DYING_DELAY       = "HC_Bleed_DyingDelay";

// name of global variable holding the time delay between dying checks
const string HC_VAR_BLEED_STABLE_DELAY      = "HC_Bleed_StableDelay";

// name of global variable holding the % chance to spontaneously stabalise when
// DYING
const string HC_VAR_BLEED_STABLISE_CHANCE   = "HC_Bleed_StabliseChance";

// name of global variable holding the % chance to spontaneously recover when
// RECOVERING
const string HC_VAR_BLEED_RECOVERY_CHANCE   = "HC_Bleed_RecoveryChance";

// name of script used to help hostiles reacquire the revived PC as a target
const string HC_EXE_RENEW_HOSTILITIES       = "hc_attackpc";


//  ----------------------------------------------------------------------------
//  PROTOTYPES
//  ----------------------------------------------------------------------------

// Simulates blood loss by inflicting damage on oPC and causing them to cry
// out in pain.
//  - oPC:   a player
void HC_Bleed_BleedAndMoan(object oPC);

// Handles the HCR aspects of recovering from dying.  Updates the player state
// and encourages any hostiles to attack oPC.
//  - oPC:   a player
void HC_Bleed_DoFullRecovery(object oPC);

// Checks a DYING player to see if their condition has changed and reacts
// accordingly.
//  - oPC:   a player
void HC_Bleed_CheckStateDying(object oPC);

// Checks a STABLE player to see if their condition has changed and reacts
// accordingly.
//  - oPC:   a player
void HC_Bleed_CheckStateStable(object oPC);

// Checks a RECOVERING player to see if their condition has changed and reacts
// accordingly.
//  - oPC:   a player
void HC_Bleed_CheckStateRecovering(object oPC);


//  ----------------------------------------------------------------------------
//  FUNCTIONS
//  ----------------------------------------------------------------------------

void HC_Bleed_DoFullRecovery(object oPC)
{
    SendMessageToPC(oPC, HC_TEXT_BLEED_NOW_ALIVE);
    SPS(oPC, PWS_PLAYER_STATE_ALIVE);

    // help hostiles reacquire the revived PC as a target
    DelayExecuteScript(2.0, HC_EXE_RENEW_HOSTILITIES, oPC);
}


void HC_Bleed_BleedAndMoan(object oPC)
{
    SendMessageToPC(oPC, HC_TEXT_BLEED_STILL_BLEEDING);

    // inflict damage to simulate blood loss
    effect eBleed = EffectDamage(HC_BLEED_BLOOD_LOSS, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eBleed, oPC);

    // random moan
    switch(d6())
    {
        case 1: PlayVoiceChat(VOICE_CHAT_HELP, oPC); break;
        case 2: PlayVoiceChat(VOICE_CHAT_PAIN1, oPC); break;
        case 3: PlayVoiceChat(VOICE_CHAT_PAIN2, oPC); break;
        case 4: PlayVoiceChat(VOICE_CHAT_PAIN3, oPC); break;
        case 5: PlayVoiceChat(VOICE_CHAT_HEALME, oPC); break;
        case 6: PlayVoiceChat(VOICE_CHAT_NEARDEATH, oPC); break;
    }
}


void HC_Bleed_CheckStateDying(object oPC)
{
    // get HP data for comparison check
    int nCurHP = GetCurrentHitPoints(oPC);
    int nLastHP = HC_GetPersistantAttribute(oPC, HC_VAR_BLEED_LAST_HP);

    // Destroy familiars on dying to prevent exploits
    object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
    if (GetIsObjectValid(oFamiliar) && nCurHP < 1)
    {
        DestroyObject(oFamiliar);
    }

    // compare HP data to assess any changes in health
    if(nCurHP > 0)
    {
        // they have been revived by another, no further checks required
        // NOTE: this is to help trap healing using BW medkits
        HC_Bleed_DoFullRecovery(oPC);
        return;
    }
    else if(nCurHP > nLastHP)
    {
        // they cannot spontaneously heal in this state so for nCurHP to be
        // higher they must have recieved healing since the last check
        HC_SetPersistantAttribute(oPC, HC_VAR_BLEED_RECOVERY_CHECK, SecondsSinceBegin());
        SendMessageToPC(oPC, HC_TEXT_BLEED_NOW_RECOVERING);
        SPS(oPC, PWS_PLAYER_STATE_RECOVERING);
    }
    else if(nCurHP > -10)
    {
        // check to see if they spontaneously self-stablised or bleed
        if(d100() <= GetLocalInt(oMod, HC_VAR_BLEED_STABLISE_CHANCE))
        {
            // passed: have spontaneously self-stablised
            HC_SetPersistantAttribute(oPC, HC_VAR_BLEED_RECOVERY_CHECK, SecondsSinceBegin());
            SendMessageToPC(oPC, HC_TEXT_BLEED_NOW_STABLE);
            SPS(oPC, PWS_PLAYER_STATE_STABLE);
        }
        else if(nCurHP > -10)
        {
            // failed: they continue loose HP though blood loss
            HC_Bleed_BleedAndMoan(oPC);
        }
    }
    else
    {
        // they die due to blood loss or were killed, no further checks requried
        // NOTE: this is to help trap a bug where PC wouldn't die when HP < -9
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
        return;
    }

    // get delay and set up next check
    float fDelay = GetLocalFloat(oMod, HC_VAR_BLEED_DYING_DELAY);
    DelayExecuteScript(fDelay, "hc_bleeding", oPC);
}


void HC_Bleed_CheckStateStable(object oPC)
{
    // get HP data for comparison check
    int nCurHP = GetCurrentHitPoints(oPC);
    int nLastHP = HC_GetPersistantAttribute(oPC, HC_VAR_BLEED_LAST_HP);

    // assess HP changes since last check
    if(nCurHP > 0)
    {
        // they have been revived by another, no further checks required
        // NOTE: this is to help trap healing using BW medkits
        HC_Bleed_DoFullRecovery(oPC);
        return;
    }
    else if(nCurHP > nLastHP)
    {
        // they cannot spontaneously heal in this state so for nCurHP to be
        // higher they must have recieved healing since the last check
        SendMessageToPC(oPC, HC_TEXT_BLEED_NOW_RECOVERING);
        SPS(oPC, PWS_PLAYER_STATE_RECOVERING);
    }
    else if(nCurHP > -10)
    {
        // get relevant time data
        int nTime = SecondsSinceBegin();
        int nLastCheck = HC_GetPersistantAttribute(oPC, HC_VAR_BLEED_RECOVERY_CHECK);
        int nCheckDelay = FloatToInt(GetLocalFloat(oMod, HC_VAR_BLEED_STABLE_DELAY));

        // check if sufficient time has passed for the next check
        if(nTime > nLastCheck + nCheckDelay)
        {
            // update time of the last recovery check
            HC_SetPersistantAttribute(oPC, HC_VAR_BLEED_RECOVERY_CHECK, nTime);

            // check to see if they have spontaneously regained consciousness
            if(d100() <= GetLocalInt(oMod, HC_VAR_BLEED_RECOVERY_CHANCE))
            {
                // passed: they spontaneously regain consciousness and will
                // subsequently start to recover
                SendMessageToPC(oPC, HC_TEXT_BLEED_NOW_CONSCIOUS);
                SPS(oPC, PWS_PLAYER_STATE_RECOVERING);
            }
            else
            {
                // failed: they continue loose HP though blood loss
                HC_Bleed_BleedAndMoan(oPC);
            }
        }
    }
    else
    {
        // they die due to blood loss or were killed, no further checks requried
        // NOTE: this is to help trap a bug where PC wouldn't die when HP < -9
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
        return;
    }

    // set up the next check
    float fDelay = GetLocalFloat(oMod, HC_VAR_BLEED_DYING_DELAY);
    DelayExecuteScript(fDelay, "hc_bleeding", oPC);
}


void HC_Bleed_CheckStateRecovering(object oPC)
{
    // get HP data for comparison check
    int nCurHP = GetCurrentHitPoints(oPC);
    int nLastHP = HC_GetPersistantAttribute(oPC, HC_VAR_BLEED_LAST_HP);

    // assess HP changes since last check
    if(nCurHP > 0)
    {
        // they have been revived by another, no further checks required
        // NOTE: this is to help trap healing using BW medkits
        HC_Bleed_DoFullRecovery(oPC);
        return;
    }
    else if(nCurHP > -10)
    {
        // get relevant time data
        int nTime = SecondsSinceBegin();
        int nLastCheck = HC_GetPersistantAttribute(oPC, HC_VAR_BLEED_RECOVERY_CHECK);
        int nCheckDelay = FloatToInt(GetLocalFloat(oMod, HC_VAR_BLEED_STABLE_DELAY));

        // check if sufficient time has passed for the next check
        if(nTime > nLastCheck + nCheckDelay)
        {
            int nHeal;

            // update time of the last recovery check
            HC_SetPersistantAttribute(oPC, HC_VAR_BLEED_RECOVERY_CHECK, nTime);

            // check to see if they have spontaneously regained consciousness
            if(d100() <= GetLocalInt(oMod, HC_VAR_BLEED_RECOVERY_CHANCE))
            {
                // passed: they spontaneously revive, no further checks required
                HC_Bleed_DoFullRecovery(oPC);

                // NOTE: HP cannot be positive so (1 - nCurHP) will be correct
                effect eHeal = EffectHeal(1 - nCurHP);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);

                return;
            }
            else
            {
                // failed: they heal naturaly
                SendMessageToPC(oPC, HC_TEXT_BLEED_STILL_RECOVERING);

                effect eHeal = EffectHeal(HC_BLEED_NATURAL_HEAL);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
            }
        }
    }
    else
    {
        // they were killed, no further checks requried
        // NOTE: this is to help trap a bug where PC wouldn't die when HP < -9
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
        return;
    }

    // set up the next check
    float fDelay = GetLocalFloat(oMod, HC_VAR_BLEED_DYING_DELAY);
    DelayExecuteScript(fDelay, "hc_bleeding", oPC);
}


//  ----------------------------------------------------------------------------
//  MAIN
//  ----------------------------------------------------------------------------

void main()
{

    // PC is object executing this script
    object oPC = OBJECT_SELF;

    // abort if PC is a DM or has logged off
    if(GetIsDM(oPC) || GetIsObjectValid(oPC) == FALSE) return;

    // parse current player state and call the appropriate function
    switch(GPS(oPC))
    {
        case PWS_PLAYER_STATE_DYING: HC_Bleed_CheckStateDying(oPC); break;
        case PWS_PLAYER_STATE_RECOVERING: HC_Bleed_CheckStateRecovering(oPC); break;
        case PWS_PLAYER_STATE_STABLE: HC_Bleed_CheckStateStable(oPC); break;
    }

    // update HP for next time
    HC_SetPersistantAttribute(oPC, HC_VAR_BLEED_LAST_HP, GetCurrentHitPoints(oPC));
}

