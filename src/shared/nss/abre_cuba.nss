void main()
{
  object oPC = GetLastOpenedBy();
  object oForja = OBJECT_SELF;
  object oBorrado;

  string sFundidor = GetLocalString(oForja, "PASO");
  if(sFundidor != "")
  {
      if(sFundidor != GetName(oPC))
      {
          //Nuevo Fundidor
          effect eFracaso = EffectVisualEffect(263);
          DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFracaso, GetLocation(oForja)));

          oBorrado = GetFirstItemInInventory(oForja);
          while(GetIsObjectValid(oBorrado))
          {
              DestroyObject(oBorrado);
              oBorrado = GetNextItemInInventory(oForja);
          }

          DelayCommand(0.1, FloatingTextStringOnCreature("*Las pieles que alguien estaba curtiendo se han echado a perder...*", oPC));
          DeleteLocalString(oForja, "PASO");
          SetLocalString(oForja, "PASO", GetName(oPC));
      }
  }




  // Animacion del PJ
  DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
  DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));

  //Plantas
  DelayCommand(0.8, FloatingTextStringOnCreature("*Coloca las pieles para curtir...*", oPC));
  SetLocalInt(oForja, "PASO", 1);
}
