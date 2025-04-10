void CrearSimboloSolar()
{
  CreateObject(OBJECT_TYPE_ITEM, "quest_ts_simb1", GetLocation(GetNearestObjectByTag("mti_quest_sombras_lugar_luz")), FALSE);
}

void ReseteoObjetosQuest()
{
  object oAltar = GetNearestObjectByTag("mti_quest_sombras_altar");

  // Eliminar anteriores objetos del ubicado
  object oRemoveItem = GetFirstItemInInventory(oAltar);
  while(GetIsObjectValid(oRemoveItem))
  {
      DestroyObject(oRemoveItem);

      oRemoveItem = GetNextItemInInventory(oAltar);
  }

  CreateItemOnObject("quest_ts_obj1", oAltar);
  CreateItemOnObject("quest_ts_obj2", oAltar);
  CreateItemOnObject("quest_ts_obj3", oAltar);
  CreateItemOnObject("quest_ts_obj4", oAltar);
  CreateItemOnObject("quest_ts_obj5", oAltar);
  CreateItemOnObject("quest_ts_obj6", oAltar);
  CreateItemOnObject("quest_ts_obj7", oAltar);
  CreateItemOnObject("quest_ts_obj8", oAltar);
}

void main()
{
  object oPC = GetLastDisturbed();
  object oItem = GetInventoryDisturbItem();

  if(GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED)
  {
      // Solo 1 objeto en el inventario
      object oInv = GetFirstItemInInventory();
      oInv = GetNextItemInInventory();
      if(GetIsObjectValid(oInv) == TRUE)
      {
          CopyObject(oInv, GetLocation(OBJECT_SELF), oPC);
          DestroyObject(oInv);
      }

      object oEstatua1 = GetNearestObjectByTag("quest_ts_obj1", oPC);
      object oEstatua2 = GetNearestObjectByTag("quest_ts_obj2", oPC);
      object oEstatua3 = GetNearestObjectByTag("quest_ts_obj3", oPC);
      object oEstatua4 = GetNearestObjectByTag("quest_ts_obj4", oPC);
      object oEstatua5 = GetNearestObjectByTag("quest_ts_obj5", oPC);
      object oEstatua6 = GetNearestObjectByTag("quest_ts_obj6", oPC);
      object oEstatua7 = GetNearestObjectByTag("quest_ts_obj7", oPC);
      object oEstatua8 = GetNearestObjectByTag("quest_ts_obj8", oPC);

      object oObjeto1 = GetFirstItemInInventory(oEstatua1);
      object oObjeto2 = GetFirstItemInInventory(oEstatua2);
      object oObjeto3 = GetFirstItemInInventory(oEstatua3);
      object oObjeto4 = GetFirstItemInInventory(oEstatua4);
      object oObjeto5 = GetFirstItemInInventory(oEstatua5);
      object oObjeto6 = GetFirstItemInInventory(oEstatua6);
      object oObjeto7 = GetFirstItemInInventory(oEstatua7);
      object oObjeto8 = GetFirstItemInInventory(oEstatua8);

      string sTagEstatua1 = GetTag(oEstatua1);
      string sTagEstatua2 = GetTag(oEstatua2);
      string sTagEstatua3 = GetTag(oEstatua3);
      string sTagEstatua4 = GetTag(oEstatua4);
      string sTagEstatua5 = GetTag(oEstatua5);
      string sTagEstatua6 = GetTag(oEstatua6);
      string sTagEstatua7 = GetTag(oEstatua7);
      string sTagEstatua8 = GetTag(oEstatua8);

      string sTagObjeto1 = GetTag(oObjeto1);
      string sTagObjeto2 = GetTag(oObjeto2);
      string sTagObjeto3 = GetTag(oObjeto3);
      string sTagObjeto4 = GetTag(oObjeto4);
      string sTagObjeto5 = GetTag(oObjeto5);
      string sTagObjeto6 = GetTag(oObjeto6);
      string sTagObjeto7 = GetTag(oObjeto7);
      string sTagObjeto8 = GetTag(oObjeto8);

      // Si todas las estatuas tienen el objeto correcto...
      if(sTagEstatua1 == sTagObjeto1 &&
         sTagEstatua2 == sTagObjeto2 &&
         sTagEstatua3 == sTagObjeto3 &&
         sTagEstatua4 == sTagObjeto4 &&
         sTagEstatua5 == sTagObjeto5 &&
         sTagEstatua6 == sTagObjeto6 &&
         sTagEstatua7 == sTagObjeto7 &&
         sTagEstatua8 == sTagObjeto8)
      {

          object oEstatuas = GetFirstObjectInArea(GetArea(oPC));
          while(GetIsObjectValid(oEstatuas))
          {
              if(GetStringLeft(GetTag(oEstatuas), 12) == "quest_ts_obj")
              {
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_PULSE_MAGENTA_YELLOW), oEstatuas, 8.0);
                  DestroyObject(GetFirstItemInInventory(oEstatuas));
              }

              oEstatuas = GetNextObjectInArea(GetArea(oPC));
          }

          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), oPC);
          FloatingTextStringOnCreature("<c´þd>* Las estatuas parecen haberse activado *</c>", oPC);
          DelayCommand(5.0, AssignCommand(oPC, ClearAllActions(TRUE)));
          DelayCommand(5.1, AssignCommand(oPC, PlaySound("it_gem")));
          DelayCommand(5.2, FloatingTextStringOnCreature("<c´þd>* Escuchas un pequeño ruido, algo ha caído cerca *</c>", oPC));
          DelayCommand(5.0, CrearSimboloSolar());
          DelayCommand(1000.0, ReseteoObjetosQuest());
        }
  }
}
