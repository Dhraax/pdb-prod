// ANIMAR MESA
void main()
{
    object oPC = GetItemActivator();
    object oObjetoActivado = GetItemActivated();
    object oObjetivo = GetItemActivatedTarget();
    string sTagDelObjeto = GetTag(oObjetoActivado);
    location lLugarActivado = GetItemActivatedTargetLocation();
    object area = GetArea(oPC);
    string nombrearea = GetName(area,TRUE);

    if(nombrearea == "Mar de las Espadas"||nombrearea == "Mar Impenetrable")  //<- Modificacion de Nompho
    {
          SendMessageToPC(oPC, "¡La mesa se hunde!");
          return;
    }
    // Se lanza el conjuro sobre un objeto mesa o una mesa ubicado
    string sTagDelObjetivo = GetTag(oObjetivo);
    string sTagDelObjetivo4 = GetStringLeft(GetTag(oObjetivo), 4);
    string sTagDelObjetivo5 = GetStringLeft(GetTag(oObjetivo), 5);
    string sTagDelObjetivo13 = GetStringLeft(GetTag(oObjetivo), 13);
    string sTagDelObjetivo15 = GetStringLeft(GetTag(oObjetivo), 15);
    if(sTagDelObjetivo != "vgz_mesa" &&
         sTagDelObjetivo != "X2_PLC_TABLEDROW" &&
         sTagDelObjetivo4 != "mesa" &&
         sTagDelObjetivo5 != "Table")

     {
         SendMessageToPC(oPC,"¡Lanza este conjuro sobre una mesa!");
         return;
     }

      // Debe estar en el suelo
      if(GetItemPossessor(oObjetivo) != OBJECT_INVALID)
      {
          SendMessageToPC(oPC, "La mesa debe estar en el suelo.");
          return;
      }

      // Solo una mesa animada a la vez
      object oAyudante1 = GetHenchman(oPC,1);
      object oAyudante2 = GetHenchman(oPC,2);
      object oAyudante3 = GetHenchman(oPC,3);
      if(GetTag(oAyudante1) == "vgz_mesaanimado" ||
         GetTag(oAyudante2) == "vgz_mesaanimado" ||
         GetTag(oAyudante3) == "vgz_mesaanimado")
      {
          SendMessageToPC(oPC, "No puedes tener mas de una mesa animado al mismo tiempo.");
          return;
      }

      // Animaciones
      effect eVisual1 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
      effect eVisual2 = EffectVisualEffect(VFX_IMP_UNSUMMON);
      AssignCommand(oPC,ActionCastFakeSpellAtLocation(SPELL_GREATER_SPELL_MANTLE,lLugarActivado));
      DelayCommand(0.1,SetCommandable(FALSE,oPC));
      DelayCommand(7.4,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVisual1,lLugarActivado));
      DelayCommand(8.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2,1.0,1.0)));
      DelayCommand(9.3,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVisual2,lLugarActivado));
      DelayCommand(9.5,SetCommandable(TRUE,oPC));

      // Ayudante
      object mesa1 = CreateObject(OBJECT_TYPE_CREATURE,"vgz_mesaanimada",lLugarActivado,FALSE);
      SetLocalString(mesa1, "AMO", GetName(oPC));
      DelayCommand(9.0,AddHenchman(oPC,mesa1));
      DestroyObject(oObjetivo, 9.0);
      return;

  }
