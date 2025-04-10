//::///////////////////////////////////////////////
//:: inc_timelock
//:: Timelock Library
//:://////////////////////////////////////////////
/*
    Contains functions for creating and managing
    timelocks on spells and abilities. Timelocks
    prevent a character from using an ability
    until the timelock has expired.
*/
//:://////////////////////////////////////////////

//#include "inc_generic"
#include "inc_tempvars"
//#include "inc_time"
#include "nwnx_creature"
#include "nwnx_object"
#include "x3_inc_string"
#include "inc_sqlite_time"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Feedback messages for PCs.
// * %s = ability name
// * %t = time

// Message sent when a permanent timelock is enabled.
const string MESSAGE_PERMANENT_TIMELOCK_ACTIVATED = "<c´$$>%s</c> ha sido bloqueado y no podra ser utilizado de nuevo en este momento.";
// Message sent when a timelock is enabled.
const string MESSAGE_TIMELOCK_ACTIVATED = "<c´$$>%s</c> tiene una demora de %t. No podras utilizar nuevamente <c´$$>%s</c> durante ese periodo de tiempo.";
// Message sent when a timelock has expired.
const string MESSAGE_TIMELOCK_AVAILABLE = "<c´$$>%s</c> esta disponible nuevamente.";
// Message that floats above a PCs head when a timelock has expired.
const string MESSAGE_TIMELOCK_AVAILABLE_FLOATING = "*<c´$$>%s</c> Disponible*";
// Message sent when a PC attempts to use an ability on a permanent timelock.
const string MESSAGE_PERMANENT_TIMELOCK_UNAVAILABLE = "<c´$$>%s</c> esta en cooldown. Este efecto ha sido cancelado.";
// Messange sent when a PC attempts to use an ability on a timelock.
const string MESSAGE_TIMELOCK_UNAVAILABLE = "Has utilizado <c´$$>%s</c> muy recientemente. Este efecto ha sido cancelado. <c´$$>%s</c> estara disponible nuevamente en %t.";
// Message sent when timelock status is updated.
const string MESSAGE_TIMELOCK_UPDATE = "Tienes %t restantes aun en <c´$$>%s</c>.";

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Prefix to separate timelock variables from other libraries.
const string LIB_PREFIX_TIMELOCK = "Lib_Timelock_";

// Minimum update interval. This should never be set to less than one. Doing so could crash the module.
const int MINIMUM_UPDATE_INTERVAL = 3;

// The timestamp is invalid or has not been set.
const int TIMELOCK_TIMESTAMP_INVALID = 0;
// The timelock is permanent until rest.
const int TIMELOCK_TIMESTAMP_PERMANENT = 2147483647; // 32-bit maximum

// The maximum number of uses a feat can have.
// Current value = Monk Level + Extra Stunning Attacks (Feat) for Stunning Fist
const int FEAT_MAXIMUM_USES = 33;

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Adds an event to be executed when the given timelock expires.
void AddEventTimelockExpired(object oCreature, string sAbility, string sScript);
// Returns TRUE if the specified ability is still on a lock timer.
int GetIsTimelocked(object oCreature, string sAbility);
// Returns TRUE if the timelock has been set to muted status (i.e. update messages are not sent).
int GetIsTimelockMuted(object oCreature, string sAbility);
// Returns the duration of the timelock remaining.
int GetTimelockRemaining(object oCreature, string sAbility);
// Quietly removes the specified timelock from the creature. No status message will be displayed.
void RemoveTimelock(object oCreature, string sAbility);
// Sets whether the timelock is muted (i.e. whether update messages are sent).
void SetIsTimelockMuted(object oCreature, string sAbility, int bIsMuted);
// Sets a timelock on the creature.
// * nTime = Duration of the timelock. Use TIMELOCK_TIMESTAMP_PERMANENT for a cooldown
//     that does not end until rest.
// * sAbility = Name of the ability. Used as an identifier and will be sent in messages to the PC.
// * nUpdateInterval = How many seconds between update messages.
// * nPenultimateUpdateTime = How many seconds before the timelock expires to send an update message.
// * If set, the given feat will be set to zero charges, and then replenished to full
//   when it expires.
// * Use %s in the feedback string to include the ability name, and %t in the feedback string to include the time.
void SetTimelock(object oCreature, int nTime, string sAbility, int nUpdateInterval = 60, int nPenultimateUpdateTime = 6, int nFeat = -1, string sFeedback = MESSAGE_TIMELOCK_ACTIVATED);
// Sends an error message to the creature for attempting to use a timelocked ability.
void TimelockErrorMessage(object oCreature, string sAbility);
// Updates timelocks on the creature. Should be called whenever a PC logs in to reactivate
// and process previous timelocks.
void UpdateTimelocks(object oCreature);

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Retuns the current time on SQLite TimeStamp formart */
int nCurrentTime = SQLite_GetTimeStamp();
/* Returns the feat to be replenished when the timelock expires. */
int _GetTimelockFeat(object oCreature, string sAbility);
/* Returns the time of the penultimate timelock update. */
int _GetTimelockPenultimateUpdateTime(object oCreature, string sAbility);
/* Returns the interval on which the timelock will be updated. */
int _GetTimelockUpdateInterval(object oCreature, string sAbility);
/* Returns the last time a timelock update was scheduled for the given ability. */
int _GetTimelockUpdateScheduledTimestamp(object oCreature, string sAbility);
/* Returns the timestamp for the timelock. */
int _GetTimelockTimestamp(object oCreature, string sAbility);
/* Returns the last time a timelock update was scheduled for the given ability. */
int _GetIsTimelockUpdateScheduled(object oCreature, string sAbility);
/* Parses conversion characters from timelock status messages and returns the updated string. */
string _ParseTimelockString(string sString, string sAbility, int nTime = -1);
/* Runs events scheduled to be executed when the given timelock expires. */
void _RunEventTimelockExpired(object oCreature, string sAbility);
/* Schedules a timelock update (i.e. which sends status messages). */
void _ScheduleTimelockUpdate(object oCreature, string sAbility);
/* Sets the feat to be replenished when the timelock expires. */
void _SetTimelockFeat(object oCreature, string sAbility, int nFeat);
/* Sets the time of the penultimate timelock update. */
void _SetTimelockPenultimateUpdateTime(object oCreature, string sAbility, int nTime);
/* Sets a timestamp for the timelock. */
void _SetTimelockTimestamp(object oCreature, string sAbility, int nTimestamp);
/* Sets the onterval on which the timelock will be updated. */
void _SetTimelockUpdateInterval(object oCreature, string sAbility, int nInterval);
/* Flags the last time a timelock update was scheduled for the given ability. */
void _SetTimelockUpdateScheduledTimestamp(object oCreature, string sAbility, int nTimestamp);
/* Converts seconds into a more presentable fashion (e.g. "3 minute(s) and 30 second(s)") */
string _TimelockSecondsToPresentableTime(int nSeconds);
/* Sends timelock status messages and resets the timelock variable if the timelock has expired. */
void _UpdateTimelock(object oCreature, string sAbility);
// Sets the remaining uses per day for the given feat.
void SetRemainingFeatUses(object oCreature, int nFeat, int nUses);
/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: AddEventTimelockExpired
//:://////////////////////////////////////////////
/*
    Adds an event to be executed when the given
    timelock expires.
*/
//:://////////////////////////////////////////////

void AddEventTimelockExpired(object oCreature, string sAbility, string sScript)
{
    int i = 1;

    while(GetLocalString(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "Event" + IntToString(i)) != "")
    {
        i++;
    }
    SetLocalString(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "Event" + IntToString(i), sScript);
}

//::///////////////////////////////////////////////
//:: SetRemainingFeatUses
//:://////////////////////////////////////////////
/*
    Sets the remaining uses per day for the given
    feat.
*/
//:://////////////////////////////////////////////

void SetRemainingFeatUses(object oCreature, int nFeat, int nUses)
{
    int i;

    for(i = 0; i < FEAT_MAXIMUM_USES; i++)
    {
        DecrementRemainingFeatUses(oCreature, nFeat);
    }
    for(i = 0; i < nUses; i++)
    {
        IncrementRemainingFeatUses(oCreature, nFeat);
    }
}

//::///////////////////////////////////////////////
//:: GetIsTimelocked
//:://////////////////////////////////////////////
/*
    Returns TRUE if the specified ability is
    still on a lock timer.
*/
//:://////////////////////////////////////////////

int GetIsTimelocked(object oCreature, string sAbility)
{
    return nCurrentTime < _GetTimelockTimestamp(oCreature, sAbility);
}

//::///////////////////////////////////////////////
//:: GetIsTimelockMuted
//:://////////////////////////////////////////////
/*
    Returns TRUE if the timelock has been set
    to muted status (i.e. update messages are
    not sent).
*/
//:://////////////////////////////////////////////

int GetIsTimelockMuted(object oCreature, string sAbility)
{
    return _GetTimelockTimestamp(oCreature, sAbility) == TIMELOCK_TIMESTAMP_INVALID ||
        GetLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockMuted");
}

//::///////////////////////////////////////////////
//:: GetTimelockRemaining
//:://////////////////////////////////////////////
/*
    Returns the duration of the timelock
    remaining.
*/
//:://////////////////////////////////////////////

int GetTimelockRemaining(object oCreature, string sAbility)
{
    int nTimestamp = _GetTimelockTimestamp(oCreature, sAbility);
    int nSeconds = nTimestamp - nCurrentTime;

    if(nTimestamp == TIMELOCK_TIMESTAMP_PERMANENT) return nTimestamp;
    return (nSeconds > 0) ? nSeconds : 0;
}

//::///////////////////////////////////////////////
//:: RemoveTimelock
//:://////////////////////////////////////////////
/*
    Quietly removes the specified timelock from the
    creature. No status message will be
    displayed.
*/
//:://////////////////////////////////////////////

void RemoveTimelock(object oCreature, string sAbility)
{
    int nFeat = _GetTimelockFeat(oCreature, sAbility);

    if(!GetIsTimelockMuted(oCreature, sAbility))
    {
        SendMessageToPC(oCreature, _ParseTimelockString(MESSAGE_TIMELOCK_AVAILABLE, sAbility));
        FloatingTextStringOnCreature(_ParseTimelockString(MESSAGE_TIMELOCK_AVAILABLE_FLOATING, sAbility), oCreature, FALSE);
    }

    _SetTimelockFeat(oCreature, sAbility, 0);
    _SetTimelockPenultimateUpdateTime(oCreature, sAbility, 0);
    _SetTimelockTimestamp(oCreature, sAbility, TIMELOCK_TIMESTAMP_INVALID);
    _SetTimelockUpdateInterval(oCreature, sAbility, 0);
    _RunEventTimelockExpired(oCreature, sAbility);

    if(nFeat) SetRemainingFeatUses(oCreature, nFeat, 1);
}

//::///////////////////////////////////////////////
//:: SetIsTimelockMuted
//:://////////////////////////////////////////////
/*
    Sets whether the timelock is muted (i.e.
    whether update messages are sent).
*/
//:://////////////////////////////////////////////

void SetIsTimelockMuted(object oCreature, string sAbility, int bIsMuted)
{
    SetTempInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockMuted", bIsMuted, TEMP_VARIABLE_EXPIRATION_EVENT_REST);
}

//::///////////////////////////////////////////////
//:: SetTimelock
//:://////////////////////////////////////////////
/*
    Sets a timelock on the creature.
    * nTime = Duration of the timelock. Use
      TIMELOCK_TIMESTAMP_PERMANENT for a cooldown
      that does not end until rest.
    * sAbility = Name of the ability. Used as
      an identifier and will be sent in messages
      to the PC.
    * nUpdateInterval = How many seconds between
      update messages.
    * nPenultimateUpdateTime = How many seconds
      before the timelock expires to send an
      update message.
    * If set, the given feat will be set to zero
      charges, and then replenished to full
      when it expires.
    * Use %s in the feedback string to include
      the ability name, and %t in the feedback
      string to include the time.
*/
//:://////////////////////////////////////////////

void SetTimelock(object oCreature, int nTime, string sAbility, int nUpdateInterval = 60, int nPenultimateUpdateTime = 6, int nFeat = -1, string sFeedback = MESSAGE_TIMELOCK_ACTIVATED)
{
    // Do not add to a permanent timestamp, as this will result in overflow.
    if(nTime == TIMELOCK_TIMESTAMP_PERMANENT)
        nCurrentTime = 0;
    if(nUpdateInterval <= 0)
        nUpdateInterval = nTime;
    else if(nUpdateInterval < MINIMUM_UPDATE_INTERVAL)
        nUpdateInterval = MINIMUM_UPDATE_INTERVAL;

    _SetTimelockTimestamp(oCreature, sAbility, nCurrentTime + (nTime));
    SetIsTimelockMuted(oCreature, sAbility, TRUE);
    _SetTimelockPenultimateUpdateTime(oCreature, sAbility, nPenultimateUpdateTime);
    _SetTimelockUpdateInterval(oCreature, sAbility, nUpdateInterval);

    if(nFeat >= 0)
    {
        _SetTimelockFeat(oCreature, sAbility, nFeat);
        SetRemainingFeatUses(oCreature, nFeat, 0);
    }
    if(nTime == TIMELOCK_TIMESTAMP_PERMANENT)
    {
        if(sFeedback == MESSAGE_TIMELOCK_ACTIVATED)
            sFeedback = MESSAGE_PERMANENT_TIMELOCK_ACTIVATED;
    }
    else
    {
        _ScheduleTimelockUpdate(oCreature, sAbility);
    }
}

//::///////////////////////////////////////////////
//:: TimelockErrorMessage
//:://////////////////////////////////////////////
/*
    Sends an error message to the creature for
    attempting to use a timelocked ability.
*/
//:://////////////////////////////////////////////

void TimelockErrorMessage(object oCreature, string sAbility)
{
    if(GetTimelockRemaining(oCreature, sAbility) == TIMELOCK_TIMESTAMP_PERMANENT)
    {
        SendMessageToPC(oCreature, ParseFormatStrings(MESSAGE_PERMANENT_TIMELOCK_UNAVAILABLE, "%s", sAbility));
    }
    else
    {
        SendMessageToPC(oCreature, _ParseTimelockString(MESSAGE_TIMELOCK_UNAVAILABLE, sAbility, GetTimelockRemaining(oCreature, sAbility)));
    }
}

//::///////////////////////////////////////////////
//:: UpdateTimelocks
//:://////////////////////////////////////////////
/*
    Updates timelocks on the creature. Should be
    called whenever a PC logs in to reactivate
    and process previous timelocks.
*/
//:://////////////////////////////////////////////

void UpdateTimelocks(object oCreature)
{
    int nTime = nCurrentTime;
    string sAbility;
    int iVar = 0;
    int iVars = NWNX_Object_GetLocalVariableCount(oCreature);

    struct NWNX_Object_LocalVariable var = NWNX_Object_GetLocalVariable(oCreature, iVar);

    while (iVar < iVars)
    {
        if(GetStringLeft(var.key, GetStringLength(LIB_PREFIX_TIMELOCK)) == LIB_PREFIX_TIMELOCK && GetStringRight(var.key, 18) == "_TimelockTimestamp")
        {
            sAbility = GetStringLeft(var.key, GetStringLength(var.key) - 18);
            sAbility = GetStringRight(sAbility, GetStringLength(sAbility) - GetStringLength(LIB_PREFIX_TIMELOCK));
        }
        else
        {
            sAbility = "";
        }
        if(sAbility != "" && nTime > _GetTimelockUpdateScheduledTimestamp(oCreature, sAbility))
        {
            _ScheduleTimelockUpdate(oCreature, sAbility);
        }
        iVar = iVar + 1;
        var = NWNX_Object_GetLocalVariable(oCreature, iVar);
    }
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: _GetTimelockFeat
//:://////////////////////////////////////////////
/*
    Returns the feat to be replenished when the
    timelock expires.
*/
//:://////////////////////////////////////////////

int _GetTimelockFeat(object oCreature, string sAbility)
{
    return GetLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockFeat");
}

//::///////////////////////////////////////////////
//:: _GetTimelockPenultimateUpdateTime
//:://////////////////////////////////////////////
/*
    Returns the time of the penultimate timelock
    update.
*/
//:://////////////////////////////////////////////

int _GetTimelockPenultimateUpdateTime(object oCreature, string sAbility)
{
    return GetLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockPenultimateUpdateTime");
}

//::///////////////////////////////////////////////
//:: _GetTimelockTimestamp
//:://////////////////////////////////////////////
/*
    Returns the timestamp for the timelock.
*/
//:://////////////////////////////////////////////

int _GetTimelockTimestamp(object oCreature, string sAbility)
{
    return GetLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockTimestamp");
}

//::///////////////////////////////////////////////
//:: _GetTimelockUpdateInterval
//:://////////////////////////////////////////////
/*
    Returns the interval on which the timelock
    will be updated.
*/
//:://////////////////////////////////////////////

int _GetTimelockUpdateInterval(object oCreature, string sAbility)
{
    return GetLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockUpdateInterval");
}

//::///////////////////////////////////////////////
//:: _GetTimelockUpdateScheduledTimestamp
//:://////////////////////////////////////////////
/*
    Returns the last time a timelock update
    was scheduled for the given ability.
*/
//:://////////////////////////////////////////////

int _GetTimelockUpdateScheduledTimestamp(object oCreature, string sAbility)
{
    return GetLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockUpdateScheduled");
}

//::///////////////////////////////////////////////
//:: _ParseTimelockString
//:://////////////////////////////////////////////
/*
    Parses conversion characters from timelock
    status messages and returns the updated
    string.
*/
//:://////////////////////////////////////////////

string _ParseTimelockString(string sString, string sAbility, int nTime = -1)
{
    string sParsedString = sString;

    sParsedString = StringReplace(sParsedString, "%s", sAbility);
    sParsedString = StringReplace(sParsedString, "%t", _TimelockSecondsToPresentableTime(nTime));

    return sParsedString;
}

//::///////////////////////////////////////////////
//:: _RunEventTimelockExpired
//:://////////////////////////////////////////////
/*
    Runs events scheduled to be executed when
    the given timelock expires.
*/
//:://////////////////////////////////////////////

void _RunEventTimelockExpired(object oCreature, string sAbility)
{
    int i = 1;
    string sScript;

    do
    {
        sScript = GetLocalString(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "Event" + IntToString(i));
        ExecuteScript(sScript, oCreature);
        DeleteLocalString(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "Event" + IntToString(i));
        i++;
    } while(sScript != "");
}

//::///////////////////////////////////////////////
//:: _ScheduleTimelockUpdate
//:://////////////////////////////////////////////
/*
    Schedule a timelock update (i.e. which
    sends status messages).
*/
//:://////////////////////////////////////////////

void _ScheduleTimelockUpdate(object oCreature, string sAbility)
{
    if((nCurrentTime < _GetTimelockUpdateScheduledTimestamp(oCreature, sAbility)) || !GetIsObjectValid(oCreature))
        return;

    int nUpdateInterval = _GetTimelockUpdateInterval(oCreature, sAbility);
    int nPenultimateUpdateTime = _GetTimelockPenultimateUpdateTime(oCreature, sAbility);
    int nTimelockRemaining = GetTimelockRemaining(oCreature, sAbility);
    int nUpdateTime;
    int nSecondsUntilInterval = nTimelockRemaining % nUpdateInterval;

    // This function was not called on a proper update interval. The timelock was probably pushed back.
    // Schedule a timelock update at the new interval time.
    if(nSecondsUntilInterval && (nTimelockRemaining - nSecondsUntilInterval > nPenultimateUpdateTime || nPenultimateUpdateTime < 1))
    {
        DelayCommand(IntToFloat(nSecondsUntilInterval), _ScheduleTimelockUpdate(oCreature, sAbility));
        return;
    }
    // This is the penultimate update. Schedule the next for when the timelock expires.
    if(nPenultimateUpdateTime > 0 && nTimelockRemaining <= nPenultimateUpdateTime)
    {
        nUpdateTime = nTimelockRemaining;
    }
    // The next standard update is further out than our penultimate update should be. Schedule
    // the penultimate update.
    else if(nPenultimateUpdateTime > 0 && nTimelockRemaining - nUpdateInterval < nPenultimateUpdateTime)
    {
        nUpdateTime = nTimelockRemaining - nPenultimateUpdateTime;
    }
    // Standard update.
    else
    {
        nUpdateTime = nUpdateInterval;
    }

    _SetTimelockUpdateScheduledTimestamp(oCreature, sAbility, nCurrentTime + nUpdateTime);
    DelayCommand(IntToFloat(nUpdateTime), _UpdateTimelock(oCreature, sAbility));
}

//::///////////////////////////////////////////////
//:: _SetTimelockFeat
//:://////////////////////////////////////////////
/*
    Sets the feat to be replenished when the
    timelock expires.
*/
//:://////////////////////////////////////////////

void _SetTimelockFeat(object oCreature, string sAbility, int nFeat)
{
    if(nFeat == 0)
    {
        DeleteLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockFeat");
    }
    else
    {
        SetTempInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockFeat", nFeat, TEMP_VARIABLE_EXPIRATION_EVENT_REST);
    }
}

//::///////////////////////////////////////////////
//:: _SetTimelockPenultimateUpdateTime
//:://////////////////////////////////////////////
/*
    Sets the time of the penultimate timelock
    update.
*/
//:://////////////////////////////////////////////

void _SetTimelockPenultimateUpdateTime(object oCreature, string sAbility, int nTime)
{
    if(nTime == 0)
    {
        DeleteLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockPenultimateUpdateTime");
    }
    else
    {
        SetLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockPenultimateUpdateTime", nTime);
    }
}

//::///////////////////////////////////////////////
//:: _SetTimelockTimestamp
//:://////////////////////////////////////////////
/*
    Sets a timestamp for the timelock.
*/
//:://////////////////////////////////////////////

void _SetTimelockTimestamp(object oCreature, string sAbility, int nTimestamp)
{
    if(nTimestamp == 0)
    {
        DeleteLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockTimestamp");
    }
    else
    {
        SetTempInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockTimestamp", nTimestamp, TEMP_VARIABLE_EXPIRATION_EVENT_REST);
    }
}

//::///////////////////////////////////////////////
//:: _SetTimelockUpdateInterval
//:://////////////////////////////////////////////
/*
    Sets the interval on which the timelock
    will be updated.
*/
//:://////////////////////////////////////////////

void _SetTimelockUpdateInterval(object oCreature, string sAbility, int nInterval)
{
    if(nInterval == 0)
    {
        DeleteLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockUpdateInterval");
    }
    else
    {
        SetLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockUpdateInterval", nInterval);
    }
}

//::///////////////////////////////////////////////
//:: _SetTimelockUpdateScheduledTimestamp
//:://////////////////////////////////////////////
/*
    Flags the last time a timelock update
    was scheduled for the given ability.
*/
//:://////////////////////////////////////////////

void _SetTimelockUpdateScheduledTimestamp(object oCreature, string sAbility, int nTimestamp)
{
    if(nTimestamp == 0)
    {
        DeleteLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockUpdateScheduled");
    }
    else
    {
        SetLocalInt(oCreature, LIB_PREFIX_TIMELOCK + sAbility + "_TimelockUpdateScheduled", nTimestamp);
    }
}

//::///////////////////////////////////////////////
//:: _TimelockSecondsToPresentableTime
//:://////////////////////////////////////////////
/*
    Converts seconds into a more presentable
    fashion (e.g. "3 minute(s) and 30 second(s)").
*/
//:://////////////////////////////////////////////

string _TimelockSecondsToPresentableTime(int nSeconds)
{
    int nMinutes;
    // int nHours;
    string sPresentableTime = "";

    // nHours = (nSeconds / 360);
    // nSeconds = nSeconds % 360;
    nMinutes = (nSeconds / 60);
    nSeconds = nSeconds % 60;

    // if(nHours)
    // {
    //    sPresentableTime += IntToString(nHours) + " hour(s)";
    // }
    if(nMinutes)
    {
        // if(nHours)
        // {
        //    if(!nMinutes)
        //    {
        //        sPresentableTime += " and ";
        //    }
        //    else
        //    {
        //        sPresentableTime += ", ";
        //    }
        // }
        sPresentableTime += IntToString(nMinutes) + " minuto(s)";
    }
    // if(nSeconds || (!nHours && !nMinutes))
    if (nSeconds)
    {
        // if(nHours || nMinutes)
        if (nMinutes)
        {
            sPresentableTime += " y ";
        }
        sPresentableTime += IntToString(nSeconds) + " segundo(s)";
    }

    return sPresentableTime;
}

//::///////////////////////////////////////////////
//:: _UpdateTimelock
//:://////////////////////////////////////////////
/*
    Sends timelock status messages and resets
    the timelock variable if the timelock has
    expired.
*/
//:://////////////////////////////////////////////

void _UpdateTimelock(object oCreature, string sAbility)
{
    if(!GetIsObjectValid(oCreature))
        return;

    int nUpdateInterval = _GetTimelockUpdateInterval(oCreature, sAbility);
    int nPenultimateUpdateTime = _GetTimelockPenultimateUpdateTime(oCreature, sAbility);
    int nTimelockRemaining = GetTimelockRemaining(oCreature, sAbility);

    _SetTimelockUpdateScheduledTimestamp(oCreature, sAbility, 0);

    if(nTimelockRemaining == TIMELOCK_TIMESTAMP_PERMANENT)
        return;

    // The timelock has expired (or close enough to it). Flag the ability as available and exit.
    if(nTimelockRemaining <= 1)
    {
        RemoveTimelock(oCreature, sAbility);
        return;
    }
    // Update current timelock status for the PC and schedule a new update.
    if(!GetIsTimelockMuted(oCreature, sAbility))
    {
        SendMessageToPC(oCreature, _ParseTimelockString(MESSAGE_TIMELOCK_UPDATE, sAbility, nTimelockRemaining));
    }
    _ScheduleTimelockUpdate(oCreature, sAbility);
}
