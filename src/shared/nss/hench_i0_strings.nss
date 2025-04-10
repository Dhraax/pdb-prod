/*

    Henchman Inventory And Battle AI

    This file is used for strings for the henchman ai.

    This file contains all strings shown to the PC. (Useful for
    multilanguage support and customization.)

*/


// void main() {    }

// weapons equipping
const string sHenchCantUseShield = "No se como se usa este escudo!";
const string sHenchCantUseRanged = "No se usar armas a distancia!.";
const string sHenchSwitchToMissle = "Cambiare a mi arma a distancia!";
const string sHenchSwitchToRanged = "Cambiare a mi arma cuerpo a cuerpo!";
// generic
const string sHenchSomethingFishy = "Hay algo sospechoso cerca de esa puerta ...";
// hen shout
const string sHenchPeacefulModeCancel = "***Modo de seguimiento pacífico cancelado***";
const string sHenchHenchmanFollow = "Te seguiré pero no atacaré a nuestros enemigos hasta que me digas lo contrario..";
const string sHenchFamiliarFollow = "Estaré encantado de seguirte, evitando el combate hasta que me digas lo contrario!";
const string sHenchAnCompFollow = " El animal entiende que debe seguirte.>";
const string sHenchOtherFollow1 = "< ";
const string sHenchOtherFollow2 = " te seguirá esperando nuevas ordenes.>";
// hen util
const string sHenchUnableToEquip1 = "Soy incapaz de usar ";
const string sHenchUnableToEquip2 = "! Lo guardaré en mi mochila!";
const string sHenchUnableToEquip3 = "Creo que no me equiparé esto.. ";
const string sHenchUnableToEquip4 = ". Esto a la bolsa.";
const string sHenchAbleToEquip = "Creo que podré usar ";
const string sHenchSelectItem1 = "Realmente me gusta este ";
const string sHenchSelectItem2 = "Me encanta mi ";
const string sHenchSelectItem3 = " es mucho mejor que ";
const string sHenchDecisions = "Hmmm, decisiones, decisiones...";
const string sHenchEquipArmor = "armadura";
const string sHenchEquipShield = "Gracias por el escudo, lo usaré bien.";
const string sHenchEquipCloak = "capa";
const string sHenchEquipBoots = "par de botas";
const string sHenchEquipHandwear = "ropa";
const string sHenchEquipHelmet = "casco";
const string sHenchEquipBelt = "cinturon";
const string sHenchEquipRing = "anillo";
const string sHenchEquipAmulet = "amuleto";
const string sHenchEquipWeapon = "Gracias por las armas!";
const string sHenchEquipWait = "Espera, estoy ordenando mi equipo!";
const string sHenchEquipDecency = "¿Me daras algo de equipo decente alguna vez?";
// hench heartbeat
const string sHenchWaitTrapsCleared = "No voy a hacer nada hasta que se eliminen estas trampas.";
const string sHenchSomethingImportant = "Hay algo importante aquí que deberías mirar";
const string sHenchFoundSomething = "Mira que he encontrado";
const string sHenchGiveThings = "Aquí hay algunas cosas para ti";
const string sHenchGiveGold = "Aqui hay oro.";
// main ai
const string sHenchCantHealMaster = "Lo siento no puedo curarte!";
const string sHenchAskHealMaster = "¿Necesitas ayuda?";
const string sHenchHenchmanAskAttack = "¿Quieres que acabe con el?";
const string sHenchFamiliarAskAttack = "¡Cuidado!";
const string sHenchAnCompAskAttack = " está esperando que le des la orden de atacar.>";
const string sHenchOtherAskAttack = " espera tus ordenes";
const string sHenchWeakAttacker = "¡No me hagas reír!";
const string sHenchModAttacker = "¡Podemos ganar!";
const string sHenchStrongAttacker = "¡Cuidado con este!";
const string sHenchOverpoweringAttacker = "¡Dioses!";
const string sHenchFamiliarFlee1 = "¡Hora de largarse!";
const string sHenchFamiliarFlee2 = "Eeeeek!";
const string sHenchFamiliarFlee3 = "Vamonos de aqui!";
const string sHenchFamiliarFlee4 = "Ahora vuelvo!";
const string sHenchAniCompFlee = "<Peligro>";
const string sHenchHealMe = "¡Ayuda!";
// hen identify
const string sHenchIdentObject = "Objeto #";
const string sHenchIdentSuccess = ":Esto parece un ";
const string sHenchIdentFail = ":No estoy seguro de qué es.";
const string sHenchIdentNoItems = "¿Estas jugando conmigo?";
// hen show items
const string sHenchShowEquipKnown = ": equipado. Qty: ";
const string sHenchShowEquipUnknown = "Objeto no identificado: equipado. Qty: ";
const string sHenchShowInventoryKnown = ": en la mochila. Qty: ";
const string sHenchShowInventoryUnknown = "Objeto no identificado: en la mochila. Qty: ";
const string sHenchShowNoItems = "No tengo nada";
// hench heartbeat
const string sHenchGetOutofWay = "¿Puedes quitarte?";
// hench block
const string sHenchMonsterOnOtherSide = "Algo está al otro lado de esta puerta..";
// hench heal
const string sHenchCantSeeTarget = "No puedo verlo";


void HenchBattleCry()
{
    string sName = GetResRef(OBJECT_SELF);
    // Probability of Battle Cry. MUST be a number from 1 to at least 8
    int iSpeakProb = Random(125)+1;
    if(sName == "ow_sum_fght")
    switch (iSpeakProb) {
       case 1: SpeakString("¡Gloria al Murkul!"); break;
       case 2: SpeakString("¡Os destruiré a todos!"); break;
       case 3: SpeakString("¡Ja! ¡Siente mi acero!"); break;
       case 4: SpeakString("¡Ven aqui!"); break;
       case 5: SpeakString("¡No dejeis rastro de vida!"); break;
       case 6: SpeakString("¡Siente el verdadero dolor!"); break;
       case 7: SpeakString("Puedo oler tu miedo..."); break;
       case 8: SpeakString("Tu muerte esta cerca..."); break;

       default: break;
    }

    if(sName == "ow_sum_axe")
    switch (iSpeakProb) {
       case 1: SpeakString("¡Gloria al Murkul!"); break;
       case 2: SpeakString("¡Os destruiré a todos!"); break;
       case 3: SpeakString("¡Ja! ¡Siente mi acero!"); break;
       case 4: SpeakString("¡Ven aqui!"); break;
       case 5: SpeakString("¡No dejeis rastro de vida!"); break;
       case 6: SpeakString("¡Siente el verdadero dolor!"); break;
       case 7: SpeakString("Puedo oler tu miedo..."); break;
       case 8: SpeakString("Tu muerte esta cerca..."); break;

       default: break;
    }

    if(sName == "ow_sum_barb")
    switch (iSpeakProb) {
       case 1: SpeakString("¡Gloria al Murkul!"); break;
       case 2: SpeakString("¡Os destruiré a todos!"); break;
       case 3: SpeakString("¡Ja! ¡Siente mi acero!"); break;
       case 4: SpeakString("¡Ven aqui!"); break;
       case 5: SpeakString("¡No dejeis rastro de vida!"); break;
       case 6: SpeakString("¡Siente el verdadero dolor!"); break;
       case 7: SpeakString("Puedo oler tu miedo..."); break;
       case 8: SpeakString("Tu muerte esta cerca..."); break;

       default: break;
    }

    if(sName == "ow_sum_sham")
    switch (iSpeakProb) {
       case 1: SpeakString("¡Gloria al Murkul!"); break;
       case 2: SpeakString("¡Os destruiré a todos!"); break;
       case 3: SpeakString("¡Ja! ¡Siente mi acero!"); break;
       case 4: SpeakString("¡Ven aqui!"); break;
       case 5: SpeakString("¡No dejeis rastro de vida!"); break;
       case 6: SpeakString("¡Siente el verdadero dolor!"); break;
       case 7: SpeakString("Puedo oler tu miedo..."); break;
       case 8: SpeakString("Tu muerte esta cerca..."); break;

       default: break;
    }

    if(sName == "conj_ladsombras")
    switch (iSpeakProb) {
       case 1: SpeakString("¿Lo sientes?"); break;
       case 2: SpeakString("¿Vas a llamar a tu mamá?"); break;
       case 3: SpeakString("Eres muy lento.. ¡Y yo muy rapido!"); break;
       case 4: SpeakString("En boca cerrada no entran moscas!"); break;
       case 5: SpeakString("¡Haces bien en tener miedo!"); break;
       case 6: SpeakString("¡Sonrie a la muerte!"); break;
       case 7: SpeakString("¡Wow! ¡Eso ha debido doler!"); break;
       case 8: SpeakString("¡Lastima! Vuelve a intentarlo. ¡Ja!"); break;
       default: break;
    }

    if(sName == "conj_ladsombras2")
    switch (iSpeakProb) {
       case 1: SpeakString("¿Lo sientes?"); break;
       case 2: SpeakString("¿Vas a llamar a tu mamá?"); break;
       case 3: SpeakString("Eres muy lento.. ¡Y yo muy rapido!"); break;
       case 4: SpeakString("En boca cerrada no entran moscas!"); break;
       case 5: SpeakString("¡Haces bien en tener miedo!"); break;
       case 6: SpeakString("¡Sonrie a la muerte!"); break;
       case 7: SpeakString("¡Wow! ¡Eso ha debido doler!"); break;
       case 8: SpeakString("¡Lastima! Vuelve a intentarlo. ¡Ja!"); break;
       default: break;
    }

   if(sName == "conj_ladsombras3")
    switch (iSpeakProb) {
       case 1: SpeakString("¿Lo sientes?"); break;
       case 2: SpeakString("¿Vas a llamar a tu mamá?"); break;
       case 3: SpeakString("Eres muy lento.. ¡Y yo muy rapido!"); break;
       case 4: SpeakString("En boca cerrada no entran moscas!"); break;
       case 5: SpeakString("¡Haces bien en tener miedo!"); break;
       case 6: SpeakString("¡Sonrie a la muerte!"); break;
       case 7: SpeakString("¡Wow! ¡Eso ha debido doler!"); break;
       case 8: SpeakString("¡Lastima! Vuelve a intentarlo. ¡Ja!"); break;
       default: break;
    }

  if(sName == "conj_lider")
    switch (iSpeakProb) {
       case 1: SpeakString("El acero es frio..."); break;
       case 2: SpeakString(" Los cobardes agonizan muchas veces antes de morir… Los valientes ni se enteran de su muerte."); break;
       case 3: SpeakString("Veo el campo de batalla con la firme seguridad de la victoria."); break;
       case 4: SpeakString("Es mejor mantenerse peleando. Si corres, solo morirás cansado."); break;
       case 5: SpeakString("¡No huyas!"); break;
       case 6: SpeakString("¡Sonrie a la muerte!"); break;
       case 7: SpeakString("¡Siente mi frio acero!"); break;
       case 8: SpeakString("¡No puedo ser vencido!"); break;
       default: break;
    }

  if(sName == "conj_mdl")
    switch (iSpeakProb) {
       case 1: SpeakString("Pronto vivirás sin aliento..."); break;
       case 2: SpeakString("La muerte es solo la puerta a la eternidad."); break;
       case 3: SpeakString("Tu cuerpo pronto será nuestro..."); break;
       case 4: SpeakString("No puedes resistirte a la condena eterna."); break;
       case 5: SpeakString("¡Te arrancaré el alma!"); break;
       case 6: SpeakString("¡Sonrie a la muerte!"); break;
       case 7: SpeakString("¡Servirás a mi señor por toda la eternidad!"); break;
       case 8: SpeakString("¡No puedo ser vencido!"); break;
       default: break;
    }
}


void MonsterBattleCry()
{


}

