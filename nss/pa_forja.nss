void main()
{
  object oPC = GetLastDisturbed();
  object oObjetoAlterado = GetInventoryDisturbItem();
  int iTipoDesturbio = GetInventoryDisturbType();
  string sEtiquetaObjetoAlterado = GetTag(oObjetoAlterado);

  if(iTipoDesturbio == INVENTORY_DISTURB_TYPE_ADDED)
  {
      // Contador
      int iFragmento1 = 0;
      int iFragmento2 = 0;
      int iFragmento3 = 0;
      int iFragmento4 = 0;

      // Bucle contador
      object oObjetosForja = GetFirstItemInInventory();
      while(GetIsObjectValid(oObjetosForja) == TRUE)
      {
          if(GetTag(oObjetosForja) == "pa_fragmento1") iFragmento1 = iFragmento1 + 1;
          else if(GetTag(oObjetosForja) == "pa_fragmento2") iFragmento2 = iFragmento2 + 1;
          else if(GetTag(oObjetosForja) == "pa_fragmento3") iFragmento3 = iFragmento3 + 1;
          else if(GetTag(oObjetosForja) == "pa_fragmento4") iFragmento4 = iFragmento4 + 1;

          oObjetosForja = GetNextItemInInventory();
      }

      // Objetos correctos en el inventario: se forja la llave
      if(iFragmento1 >= 1 && iFragmento2 >= 1 && iFragmento3 >= 1 && iFragmento4 >= 1)
      {
          // Borramos inventario de la forja
          object oObjetoABorrar = GetFirstItemInInventory();
          while(GetIsObjectValid(oObjetoABorrar) == TRUE)
          {
              DestroyObject(oObjetoABorrar);

              oObjetoABorrar = GetNextItemInInventory();
          }

          // Mensaje, xp, objeto y animaciones
          ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), GetLocation(OBJECT_SELF));
          ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), GetLocation(OBJECT_SELF));
          FloatingTextStringOnCreature("* La forja reacciona mágicamente juntando los fragmentos *", oPC);
          GiveXPToCreature(oPC, 100);
          CreateItemOnObject("pa_llaveboss");
          return;
      }

      // No se forja la llave
      else
      {
          if(sEtiquetaObjetoAlterado == "pa_fragmento1" ||
             sEtiquetaObjetoAlterado == "pa_fragmento2" ||
             sEtiquetaObjetoAlterado == "pa_fragmento3" ||
             sEtiquetaObjetoAlterado == "pa_fragmento4")
          {
              ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_MIND), GetLocation(OBJECT_SELF));
              FloatingTextStringOnCreature("* El fragmento parece reaccionar con la forja *", oPC);
              return;
          }
      }
  }
}
