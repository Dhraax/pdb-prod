/*PALANCA IMNESCAR XAVI*/
void ActivarMecanismo()
{
DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
DelayCommand(5.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
}

void main()
{
//Modifica aqui el texto que dira el jugador cuando active la palanca
string sTexto1 = "*Has accionado la palanca y se ha abierto el portón*";

//Modifica aqui el texto que dira el jugador cuando intente usar la palanca
//cuando no se tenga la pieza
string sTexto2 = "*Parece que se necesita alguna pieza para activar la palanca*";

//Modifica aqui la etiqueta de la pieza necesaria para activar la palanca
string sPieza = "Piezadehierro_pal_band";

//Modifica aqui la etiqueta de la puerta
string sPuerta = "puerta_band_final";

// Definimos los objetos
object oPC = GetLastUsedBy();
object oMod = GetModule();
object oPuerta = GetObjectByTag(sPuerta);
object oPieza = GetItemPossessedBy(oPC, sPieza);

if(GetLocalInt(oMod, "PALANCAFUNCIONANDO") == 0)
    {
      if(GetItemPossessedBy(oPC, sPieza)!= OBJECT_INVALID)
          {
           ActivarMecanismo();
           ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_KNOCK), OBJECT_SELF);
           DestroyObject(oPieza);
           FloatingTextStringOnCreature(sTexto1, oPC);
           SetLocked(oPuerta, FALSE);
           AssignCommand(oPuerta, ActionOpenDoor(oPuerta));
           SetLocalInt(oMod, "PALANCAFUNCIONANDO", 1);
           DelayCommand(120.0, DeleteLocalInt(oMod, "PALANCAFUNCIONANDO"));
          }
      else
          {
           FloatingTextStringOnCreature(sTexto2, oPC);
          }
    }
else
    {
      ActivarMecanismo();
      SetLocked(oPuerta, FALSE);
      AssignCommand(oPuerta, ActionOpenDoor(oPuerta));
    }
}
