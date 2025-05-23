//::////////////////////////////////////////////////////////////////////////////////
//:: PUERTA DE BALDUR (www.puertadebaldur.net)
//:: LIBRERIA: DAÑO ATENUADO
//::////////////////////////////////////////////////////////////////////////////////

#include "mti_libreria"

// Change these constants to set the maximum of 'knockout hits' that a PC can
// receive before moving to the next stage of unconsciousness.
// For example, if SUBDUE_WINDED = 3, a PC can receive 3 hits in a short period
// of time and remain winded. 4 hits will cause him to black out.
int SUBDUE_WINDED               = 7;
int SUBDUE_BLACKOUT             = 12;
int SUBDUE_KNOCKOUT             = 18;

// Main subdual check funciton. Call only in OnPlayerDeath and OnPlayerDying.
// Will return the degree of damage the player has incurred, or 0 if it was
// not subdual damage.
int CheckSubdual(object oPC);

// Only CheckSubdual is meant to be called, and then only from
// OnPlayerDeath and OnPlayerDying. The rest are internal functions.

void Resurreccion(object oPC);
void DanyoAtenuado(object oPC, int i);
void Muerte(object oPC);
void DisminuirGolpesRecibidos(object oPC, int lastValue);
void DisminuirGolpesRecibidosAguante(object oPC, int lastValue);
int GetSubdual(object oPC);

//::///////////////////////////////////////////////
//:: Implementation
//::///////////////////////////////////////////////

// Main subdual check funciton. Call only in OnPlayerDeath and OnPlayerDying.
// Will return the degree of damage the player has incurred, or 0 if it was
// not subdual damage.
int CheckSubdual(object oPC)
{
    if(GetSubdual(oPC))
    {
        if(GetLocalInt(oPC,"BEATEN_TO_DEATH")) return FALSE;    // Added this as a quick out in case the person was beaten to death THROUGH Subdual damage

        Resurreccion(oPC);

        int iVariableAguante = GetLocalInt(oPC, "PB_ATENUADO_AGUANTE");
        if(GetHasFeat(1204, oPC) && iVariableAguante < 4)
        {
            iVariableAguante++;
            SetLocalInt(oPC, "PB_ATENUADO_AGUANTE", iVariableAguante);
            DelayCommand(900.0, DisminuirGolpesRecibidosAguante(oPC, iVariableAguante));
            FloatingTextStringOnCreature("<c´þd>* Resistes el daño atenuado gracias a la dote 'Aguante' *</c>", oPC, FALSE);
            return FALSE;
        }

        int iGolpesAcumulados = GetLocalInt(oPC,"nSubdued");
        iGolpesAcumulados++;
        SetLocalInt(oPC, "nSubdued", iGolpesAcumulados);
        DanyoAtenuado(oPC, iGolpesAcumulados);

        return iGolpesAcumulados;
    }
    return FALSE;
}

void Resurreccion(object oPC)
{
    if(GetCurrentHitPoints(oPC) < -9) { ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPC); ReaplicarEfectosPB(oPC,TRUE); }
    else if(GetCurrentHitPoints(oPC) < 1) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(abs(GetCurrentHitPoints(oPC)) + 1), oPC);
}

void DanyoAtenuado(object oPC,int i)
{
    string sMes;
    float timeUnc;      // Time unconscious
    float timeDazed;    // Time Dazed
    int dropType;       // Qué equipamiento deberia ser soltado
    int moveDec;        // Reduccion de movimiento
    int acDec;          // Reduccion de CA
    if(i <= SUBDUE_WINDED)
    {
        sMes="<c!}þ>* Sin aliento *</c>";
        timeUnc=15.0;
        timeDazed=30.0;
        dropType=0;
        moveDec=20;
        acDec=2;
    }
    else if(i <= SUBDUE_BLACKOUT)
    {
        if(GetGender(oPC) == GENDER_MALE) sMes="<c!}þ>* Desmayado *</c>";
        else sMes="<c!}þ>* Desmayada *</c>";
        timeUnc=30.0;
        timeDazed=60.0;
        dropType=1;
        moveDec=35;
        acDec=5;
    }
    else if(i <= SUBDUE_KNOCKOUT)
    {
        if(GetGender(oPC) == GENDER_MALE) sMes="<c!}þ>* Desvanecido *</c>";
        else sMes="<c!}þ>* Desvanecida *</c>";
        timeUnc=45.0;
        timeDazed=120.0;
        dropType=2;
        moveDec=50;
        acDec=7;
    }
    else
    {
        if(GetGender(oPC) == GENDER_MALE) sMes="<c!}þ>* Contusionado *</c>";
        else sMes="<c!}þ>* Contusionada *</c>";
        timeUnc=60.0;
        timeDazed=240.0;
        dropType=3;
        moveDec=75;
        acDec=10;
    }

    // Apply the subdual effects
    AssignCommand(oPC,ClearAllActions());
    AssignCommand(oPC,ActionSpeakString(sMes));
    AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,1.0,timeUnc));
    AssignCommand(oPC,ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectMovementSpeedDecrease(moveDec),oPC,timeDazed)));
    AssignCommand(oPC,ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectACDecrease(acDec),oPC,timeDazed)));
    AssignCommand(oPC,ActionDoCommand(SetCommandable(TRUE,oPC)));
    AssignCommand(oPC,SetCommandable(FALSE,oPC));
    DelayCommand(timeUnc+timeDazed,DisminuirGolpesRecibidos(oPC,i));

    if(dropType > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectBlindness(),oPC,timeUnc);
        if(dropType >= 3) Muerte(oPC);
    }
}

// Returns type of subdual.
// GetLastAttacker, GetGoingToBeAttackedBy, GetLastHostileActor
// seem to work correctly in an ondeath script for a PC.
// To be safe, check everything for a possible subdual attack.
// If there is an incorrect positive, the attacker can always hit
// the PC again.
int GetSubdual(object oPC)
{
    int i = 0;
    object oKiller = GetLastAttacker(oPC);

    if(GetIsObjectValid(oKiller))
        if((GetLocalInt(oKiller,"SUBDUAL"))&&(oKiller!=oPC))
            i=GetLocalInt(oKiller,"SUBDUAL");
    oKiller=GetGoingToBeAttackedBy(oPC);
    if(GetIsObjectValid(oKiller))
        if((GetLocalInt(oKiller,"SUBDUAL"))&&(oKiller!=oPC))
            i=GetLocalInt(oKiller,"SUBDUAL");
    oKiller=GetLastDamager();
    if(GetIsObjectValid(oKiller))
        if((GetLocalInt(oKiller,"SUBDUAL"))&&(oKiller!=oPC))
            i=GetLocalInt(oKiller,"SUBDUAL");
    oKiller=GetLastKiller();
    if(GetIsObjectValid(oKiller))
        if((GetLocalInt(oKiller,"SUBDUAL"))&&(oKiller!=oPC))
            i=GetLocalInt(oKiller,"SUBDUAL");
    oKiller=GetLastHostileActor(oPC);
    if(GetIsObjectValid(oKiller))
        if((GetLocalInt(oKiller,"SUBDUAL"))&&(oKiller!=oPC))
            i=GetLocalInt(oKiller,"SUBDUAL");
    oKiller=GetLastSpellCaster();
    if(GetIsObjectValid(oKiller))
        if((GetLocalInt(oKiller,"SUBDUAL"))&&(oKiller!=oPC))
            i=GetLocalInt(oKiller,"SUBDUAL");
    return i;
}

void DisminuirGolpesRecibidos(object oPC, int lastValue)
{
    if(GetLocalInt(oPC,"nSubdued") == lastValue) DeleteLocalInt(oPC,"nSubdued");
}

void DisminuirGolpesRecibidosAguante(object oPC, int lastValue)
{
    if(GetLocalInt(oPC,"PB_ATENUADO_AGUANTE") == lastValue) DeleteLocalInt(oPC,"PB_ATENUADO_AGUANTE");
}

void Muerte(object oPC)
{
  // Concussion - Fortitude Save vs Death
  int nDC = GetLocalInt(oPC,"SUBDUAL_SAVE");
  // If not initialized, set the base save at 10
  if(!nDC) nDC = 10;
  if(FortitudeSave(oPC,nDC,SAVING_THROW_TYPE_DEATH))
  {
      nDC++;  // Save gets harder for next round
      SetLocalInt(oPC,"SUBDUAL_SAVE",nDC);
  }
  else
  {
      DelayCommand(10.0,DeleteLocalInt(oPC,"SUBDUAL_SAVE"));
      SetLocalInt(oPC,"BEATEN_TO_DEATH",TRUE);
  }
}
