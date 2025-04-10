void main()
{
  object oPC = GetEnteringObject();

  int iTiradaReflejos = ReflexSave(oPC, 14, SAVING_THROW_TYPE_ACID, oPC);
  if(iTiradaReflejos == 0)
  {
      SendMessageToPC(oPC,"¡Parte de tu equipo se ha derretido por el ácido!");
      effect eDano = EffectDamage(50,DAMAGE_TYPE_ACID);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eDano,oPC);

      object oEquipo1 = GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);
      object oEquipo2 = GetItemInSlot(INVENTORY_SLOT_ARROWS,oPC);
      object oEquipo3 = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
      object oEquipo4 = GetItemInSlot(INVENTORY_SLOT_BOLTS,oPC);
      object oEquipo5 = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
      object oEquipo6 = GetItemInSlot(INVENTORY_SLOT_BULLETS,oPC);
      object oEquipo7 = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
      object oEquipo8 = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
      object oEquipo9 = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
      object oEquipo10 = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
      object oEquipo11 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
      object oEquipo12 = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
      object oEquipo13 = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
      object oEquipo14 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
      object oEquipo15 = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);

      int iMalaSuerte = Random(8);
      if(iMalaSuerte == 0) {DestroyObject(oEquipo1); DestroyObject(oEquipo2);}
      else if(iMalaSuerte == 1) {DestroyObject(oEquipo3); DestroyObject(oEquipo4);}
      else if(iMalaSuerte == 2) {DestroyObject(oEquipo5); DestroyObject(oEquipo6);}
      else if(iMalaSuerte == 3) {DestroyObject(oEquipo7); DestroyObject(oEquipo8);}
      else if(iMalaSuerte == 4) {DestroyObject(oEquipo9); DestroyObject(oEquipo10);}
      else if(iMalaSuerte == 5) {DestroyObject(oEquipo11); DestroyObject(oEquipo12);}
      else if(iMalaSuerte == 6) {DestroyObject(oEquipo13); DestroyObject(oEquipo14);}
      else if(iMalaSuerte == 7) {DestroyObject(oEquipo15);}
  }

  else if(iTiradaReflejos == 1)
  {
      SendMessageToPC(oPC,"¡Te proteges rápidamente del ácido sufriendo heridas leves!");
      effect eDano = EffectDamage(25,DAMAGE_TYPE_ACID);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eDano,oPC);
  }

  else SendMessageToPC(oPC,"¡Eres immune a este lago de ácido!");
}
