//:://////////////////////////////////////////////
//:: NW_CH_AC7.nss  Henchman Death Script
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
//:: Modified by:   Monti, familiares
//:: Modified On: 22 de Febrero de 2012
//:://///////////////////////////////////////////////

#include "mti_libreria"

void main()
{
    //PHB FAMILIAR CODE ADDITIONS
    object oMaster = GetMaster(OBJECT_SELF);
    // Test that the master is a valid object, and we are the master's familiar
    // Do not test that the master is a PC, because it STOPS being a PC when
    // the familiar is possessed!
    if(GetIsObjectValid(oMaster) &&
       GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == OBJECT_SELF &&
       GetLocalInt(oMaster, "ARENA") == FALSE)
    {
        // Variable de familiar muerto
        GuardarIntPersistente(oMaster, "FAMILIAR_VIVO", FALSE);

        // XP Penalty when the familiar dies, DC=15 fortitude save for 1/2 penalty.
        int iLevel = GetHitDice(oMaster);
        int iXPPen = 200 * iLevel;
        if (FortitudeSave(oMaster, 15)>0)
        {
            iXPPen = iXPPen / 2;
        }
        int iNewXP = GetXP(oMaster) - iXPPen;
        if (iNewXP <= 0) iNewXP = 1;

        AssignCommand(oMaster, SendMessageToPC(oMaster, "<cüGB>Pierdes " + IntToString(iXPPen) + " puntos de experiencia debido a la muerte de tu familiar.</c>"));
        AssignCommand(oMaster, SetXP(oMaster, iNewXP));

        // April 2002: Made it so that familiar death can never kill the player
        // only wound them.
        int nDam =d6();
        if (nDam >= GetCurrentHitPoints(oMaster))
        {
            nDam = GetCurrentHitPoints(oMaster) - 1;
        }
        effect eDam = EffectDamage(nDam);
        FloatingTextStrRefOnCreature(63489, oMaster, FALSE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oMaster);
    }

    //Para evitar el bug del oro infinito al morir, le quitamos el oro que tenga encima.
    TakeGoldFromCreature(GetGold(OBJECT_SELF), OBJECT_SELF, TRUE);
}
