void main()
{
  SetMaxHenchmen(3);

  object oPC = OBJECT_SELF;
  object oMod = GetModule();
  int iDoteArpista, iVerAyudante;

   if(GetHasFeat(1354)) iDoteArpista++;

    if(iDoteArpista < 1)       { iDoteArpista = 1; iVerAyudante = 1;  }

   // Variables
   object oArpistaAntiguo1 = GetLocalObject(oPC, "REPUTACION_SEGUIDOR_1");
   object oArpistaAntiguo2 = GetLocalObject(oPC, "REPUTACION_SEGUIDOR_2");
   object oArpistaAntiguo3 = GetLocalObject(oPC, "REPUTACION_SEGUIDOR_3");

  // Despedir a los ayudantes
  if(GetTag(GetHenchman(oPC, 1)) == "conj_conarp"  ||
     GetTag(GetHenchman(oPC, 1)) == "conj_conarp2" ||
     GetTag(GetHenchman(oPC, 1)) == "conj_conarp3" ||
     GetTag(GetHenchman(oPC, 2)) == "conj_conarp"  ||
     GetTag(GetHenchman(oPC, 2)) == "conj_conarp2" ||
     GetTag(GetHenchman(oPC, 2)) == "conj_conarp3" ||
     GetTag(GetHenchman(oPC, 3)) == "conj_conarp"  ||
     GetTag(GetHenchman(oPC, 3)) == "conj_conarp2" ||
     GetTag(GetHenchman(oPC, 3)) == "conj_conarp3")
  {
      FloatingTextStringOnCreature("<c´þd>* Indicas a tus seguidores que se dispersen *</c>", oPC, FALSE);
      if(GetIsObjectValid(oArpistaAntiguo1)) { RemoveHenchman(GetMaster(oArpistaAntiguo1),oArpistaAntiguo1); AssignCommand(oArpistaAntiguo1,SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oArpistaAntiguo1, 0.5); }
      if(GetIsObjectValid(oArpistaAntiguo2)) { RemoveHenchman(GetMaster(oArpistaAntiguo2),oArpistaAntiguo2); AssignCommand(oArpistaAntiguo2,SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oArpistaAntiguo2, 0.5); }
      if(GetIsObjectValid(oArpistaAntiguo3)) { RemoveHenchman(GetMaster(oArpistaAntiguo3),oArpistaAntiguo3); AssignCommand(oArpistaAntiguo3,SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oArpistaAntiguo3, 0.5); }
      return;
  }

  // Si no te caben los ayudantes el script no sigue
  if(GetHenchman(oPC, iVerAyudante) != OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "<cþ<<>No te caben más ayudantes, sólo puedes tener un máximo de 3.</c>");
      return;
  }

  // Antisaturamiento, solo una vez cada 15 minutos
  if(GetLocalInt(oMod, "NOREPUTACION" + GetName(oPC)))
  {
      SendMessageToPC(oPC, "<cþ<<>No puedes reclamar a tus seguidores tan frecuentemente.</c>");
      return;
  }

  SetLocalInt(oMod, "NOREPUTACION" + GetName(oPC), TRUE);
  DelayCommand(900.0, DeleteLocalInt(oMod, "NOREPUTACION" + GetName(oPC)));

  // Mensaje
  FloatingTextStringOnCreature("<c´þd>* Llamas a tus seguidores arpistas *</c>", oPC, FALSE);

  // Destruimos los antiguos arpistas
  if(GetIsObjectValid(oArpistaAntiguo1)) { RemoveHenchman(GetMaster(oArpistaAntiguo1),oArpistaAntiguo1); AssignCommand(oArpistaAntiguo1,SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oArpistaAntiguo1, 0.5); }
  if(GetIsObjectValid(oArpistaAntiguo2)) { RemoveHenchman(GetMaster(oArpistaAntiguo2),oArpistaAntiguo2); AssignCommand(oArpistaAntiguo2,SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oArpistaAntiguo2, 0.5); }
  if(GetIsObjectValid(oArpistaAntiguo3)) { RemoveHenchman(GetMaster(oArpistaAntiguo3),oArpistaAntiguo3); AssignCommand(oArpistaAntiguo3,SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oArpistaAntiguo3, 0.5); }

  //Creamos las criaturas y las unimos al jugador
  object oArpista1 = CreateObject(OBJECT_TYPE_CREATURE, "conj_conarp", GetLocation(oPC));
  object oArpista2 = CreateObject(OBJECT_TYPE_CREATURE, "conj_conarp2", GetLocation(oPC));
  object oArpista3 = CreateObject(OBJECT_TYPE_CREATURE, "conj_conarp3", GetLocation(oPC));
  DelayCommand(2.5, AddHenchman(oPC, oArpista1));
  DelayCommand(2.5, AddHenchman(oPC, oArpista2));
  DelayCommand(2.5, AddHenchman(oPC, oArpista3));
  SetLocalObject(oPC, "REPUTACION_SEGUIDOR_1", oArpista1);
  SetLocalObject(oPC, "REPUTACION_SEGUIDOR_2", oArpista2);
  SetLocalObject(oPC, "REPUTACION_SEGUIDOR_3", oArpista3);
  SetLocalString(oArpista1, "AMO", GetName(oPC));
  SetLocalString(oArpista2, "AMO", GetName(oPC));
  SetLocalString(oArpista3, "AMO", GetName(oPC));
 }



