void main()
{
  object oPC = GetPCSpeaker();

  if(GetLocalString(OBJECT_SELF, "IDENTIDADPJ") != GetName(oPC, TRUE))
  {
      FloatingTextStringOnCreature("* ¡No puedes recoger esta cuerda ya que no la has montado tú! *", oPC, FALSE);
      return;
  }

  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.0));

  object oCuerda = CreateItemOnObject("gz_it_rope", oPC);

  //Modificacin, para conservar cuerdas ligeras
  if(GetLocalInt(OBJECT_SELF, "CuerdaLigera"))
  {
    SetName(oCuerda, "Cuerda de seda con garfio");
    SetLocalInt(oCuerda, "CuerdaLigera", 1);
    DelayCommand(0.3, RemoveItemProperty(oCuerda ,ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_5_LBS)) );
  }

  string sIdentidadCuerda = GetLocalString(OBJECT_SELF, "IDENTIDADCUERDA");
  DestroyObject(GetLocalObject(oPC, "CUERDA1" + sIdentidadCuerda));
  DestroyObject(GetLocalObject(oPC, "CUERDA2" + sIdentidadCuerda));

  DeleteLocalObject(oPC, "CUERDA1" + sIdentidadCuerda);
  DeleteLocalObject(oPC, "CUERDA2" + sIdentidadCuerda);
}
