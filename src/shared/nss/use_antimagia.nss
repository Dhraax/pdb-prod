// modified by: Dhraax
#include "x2_inc_itemprop"
#include "cnr_i_prop"

void main()
{
  object oPC = GetLastUsedBy();
  object oPlataforma = GetNearestObjectByTag("plat_antimagic");
  object oPon = GetNearestObjectByTag("srponpaipa");
  object oItem1 = GetFirstItemInInventory(oPlataforma);
  object oCat1 = GetNearestObjectByTag("catalizador1");
  object oCat2 = GetNearestObjectByTag("catalizador2");
  object oCat3 = GetNearestObjectByTag("catalizador3");
  object oCat4 = GetNearestObjectByTag("catalizador4");
  object oCat1z = GetNearestObjectByTag("catalizador1x");
  object oCat2z = GetNearestObjectByTag("catalizador2x");
  object oCat3z = GetNearestObjectByTag("catalizador3x");
  object oCat4z = GetNearestObjectByTag("catalizador4x");
  effect eEfecto1 = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
  effect eEfecto3 = EffectVisualEffect(VFX_IMP_DISPEL);
  effect eParal = EffectCutsceneImmobilize();
  effect eBeam1 = EffectBeam(VFX_BEAM_COLD,oCat1,BODY_NODE_CHEST);
  effect eBeam2 = EffectBeam(VFX_BEAM_COLD,oCat2,BODY_NODE_CHEST);
  effect eBeam3 = EffectBeam(VFX_BEAM_COLD,oCat3,BODY_NODE_CHEST);
  effect eBeam4 = EffectBeam(VFX_BEAM_COLD,oCat4,BODY_NODE_CHEST);
  effect eBeam1x = EffectBeam(VFX_BEAM_COLD,oCat1,BODY_NODE_CHEST);
  effect eBeam2x = EffectBeam(VFX_BEAM_COLD,oCat1,BODY_NODE_CHEST);
  effect eBeam3x = EffectBeam(VFX_BEAM_COLD,oCat2,BODY_NODE_CHEST);
  effect eBeam4x = EffectBeam(VFX_BEAM_COLD,oCat3,BODY_NODE_CHEST);
  int Int = GetLocalInt(OBJECT_SELF, "AMNAGANTIMAGIA");
  int iPrecio = (GetGoldPieceValue(oItem1)*5)/100; // 5% del valor del objeto

  if(Int > 11)
  {
      AssignCommand(oPon,SpeakString("No no no, ¡la máquina no funciona! Prueba mejor después-pués."));
      return;
  }

  if(oItem1 == OBJECT_INVALID)
  {
      AssignCommand(oPon,SpeakString("No no no, ¡tienes que meter algún objeto dentro! Sino no funciona."));
      return;
  }

  if(GetLocalInt(OBJECT_SELF, "PRECIOANTIMAGIA") == FALSE)
  {
      AssignCommand(oPon,SpeakString("Explosionar este objeto te costará " + IntToString(iPrecio) + " monedas de oro, ¡voy a hacerme rico ja ja ja! Dale a la palanca en menos de 5 segundos para empezar, ¡sí sí sí!"));
      SetLocalInt(OBJECT_SELF, "PRECIOANTIMAGIA", TRUE);
      DelayCommand(5.0, DeleteLocalInt(OBJECT_SELF, "PRECIOANTIMAGIA"));
      return;
  }
  else if(GetGold(oPC) < iPrecio)
  {
      AssignCommand(oPon,SpeakString("No no no, ¡necesitas tener el oro que te pido! Sino no funciona."));
      return;
  }


  if(Int <= 10)
  {
      // Mensajes PNJ
      if(Int == 0) AssignCommand(oPon,SpeakString("¿A qué da gusto verla? Es mia."));
      else if(Int == 1) AssignCommand(oPon,SpeakString("Que bien funciona y que bonita es, sí."));
      else if(Int == 2) AssignCommand(oPon,SpeakString("La he hecho yo."));
      else if(Int == 3) AssignCommand(oPon,SpeakString("Se come toda la magia, ¡biieen!"));
      else if(Int == 4) AssignCommand(oPon,SpeakString("Soy un gnomo muy listo, sísí."));
      else if(Int == 5) AssignCommand(oPon,SpeakString("¿Sabias que la he hecho yo?"));
      else if(Int == 6) AssignCommand(oPon,SpeakString("Me caes bien aunque huelas tan mal."));
      else if(Int == 7) AssignCommand(oPon,SpeakString("Tutururú... Que bonita que es, yo la llamo 'Chispita'."));
      else if(Int == 8) AssignCommand(oPon,SpeakString("Me duele el brazo, ¡ah no! ¡¡si no tengo!!"));
      else if(Int == 9) AssignCommand(oPon,SpeakString("No deberías dar tanto a la palanca, como se rompa..."));
      else if(Int == 10) AssignCommand(oPon,SpeakString("Huele como a quemado y a gas... Yo no he sido."));

      // Immovilizar al jugador
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oPC, 14.0);

      // Animaciones de activar ubicados
      AssignCommand(OBJECT_SELF,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
      AssignCommand(oCat1,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
      AssignCommand(oCat2,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
      AssignCommand(oCat3,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
      AssignCommand(oCat4,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
      DelayCommand(2.0,AssignCommand(oCat1z,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
      DelayCommand(2.0,AssignCommand(oCat2z,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
      DelayCommand(2.0,AssignCommand(oCat3z,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
      DelayCommand(2.0,AssignCommand(oCat4z,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));

      // Efectos visuales
      DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEfecto1,oPC,9.0));
      DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam1x,oCat2,9.0));
      DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam2x,oCat3,9.0));
      DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam3x,oCat4,9.0));
      DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam4x,oCat4,9.0));
      DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam1,oCat1z,9.0));
      DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam2,oCat2z,9.0));
      DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam3,oCat3z,9.0));
      DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam4,oCat4z,9.0));
      DelayCommand(11.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEfecto3,oCat1z));
      DelayCommand(11.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEfecto3,oCat2z));
      DelayCommand(11.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEfecto3,oCat3z));
      DelayCommand(11.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEfecto3,oCat4z));

      // Animaciones de desactivar ubicados
      DelayCommand(14.0,AssignCommand(OBJECT_SELF,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
      DelayCommand(14.0,AssignCommand(oCat1,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
      DelayCommand(14.0,AssignCommand(oCat2,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
      DelayCommand(14.0,AssignCommand(oCat3,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
      DelayCommand(14.0,AssignCommand(oCat4,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
      DelayCommand(16.0,AssignCommand(oCat1z,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
      DelayCommand(16.0,AssignCommand(oCat2z,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
      DelayCommand(16.0,AssignCommand(oCat3z,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
      DelayCommand(16.0,AssignCommand(oCat4z,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));

      // Control de variables
      Int = Int + 1;
      SetLocalInt(OBJECT_SELF, "AMNAGANTIMAGIA", Int);

      // Quitar una propiedad valida y aleatoria al objeto de la plataforma
      int iNumeroPropiedades = IPGetNumberOfItemProperties(oItem1);
      if(iNumeroPropiedades == 0) return;

      int iPropiedadElegida = Random(iNumeroPropiedades) + 1;
      int iBuclePropiedades;
      itemproperty ipPropiedadElegida = GetFirstItemProperty(oItem1);
      while(GetIsItemPropertyValid(ipPropiedadElegida) && iBuclePropiedades != 5000)
      {
          iBuclePropiedades++;

          if(iBuclePropiedades == iPropiedadElegida)
          {
              if(GetItemPropertyType(ipPropiedadElegida) == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP ||
                 GetItemPropertyType(ipPropiedadElegida) == ITEM_PROPERTY_USE_LIMITATION_CLASS ||
                 GetItemPropertyType(ipPropiedadElegida) == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE ||
                 GetItemPropertyType(ipPropiedadElegida) == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT ||
                 GetItemPropertyType(ipPropiedadElegida) == 150)
              {
                  DelayCommand(16.0, AssignCommand(oPon,SpeakString("¡Chispita no funcionará esta vez! Limitación de uso no elimina. ¡No no no!")));
                  SetLocalInt(OBJECT_SELF, "AMNAGANTIMAGIA", Int - 1);
              }

              else
              {
                  AssignCommand(oPC, TakeGoldFromCreature(iPrecio, oPC, TRUE));
                  RemoveItemProperty(oItem1, ipPropiedadElegida);

                  // Back to three properties or fewer, the item is no longer
                  // reserved for level 17. Counted by the rule crafting and
                  // Arcano use to set the mark, which leaves out use
                  // limitations, light and quality, and counted after this
                  // script so the removal has certainly taken effect.
                  DelayCommand(0.5, CnrProp_ClearHighLevel(oItem1));
              }

              iBuclePropiedades = 5000;
          }

          ipPropiedadElegida = GetNextItemProperty(oItem1);
      }
  }

  else
  {
      // Control de variables
      Int = Int + 1;
      SetLocalInt(OBJECT_SELF, "AMNAGANTIMAGIA", Int);

      // Explosion
      int iVida = GetCurrentHitPoints(oPC);
      object oAnti = GetNearestObjectByTag("antimagiaxxx");
      effect eFuego = EffectVisualEffect(VFX_DUR_INFERNO_CHEST);
      effect ePum = EffectVisualEffect(VFX_FNF_FIREBALL);
      effect eDano = EffectDamage(iVida - 1,DAMAGE_TYPE_FIRE);
      object oDestruc1 = CreateObject(OBJECT_TYPE_PLACEABLE,"ZEP_BFLAME001",GetLocation(GetObjectByTag("WP_antimagia01")));
      object oDestruc2 = CreateObject(OBJECT_TYPE_PLACEABLE,"ZEP_BFLAME003",GetLocation(GetObjectByTag("WP_antimagia02")));

      AssignCommand(oPon,SpeakString("¡Chispita! ¡Noooooo!"));
      AssignCommand(oCat2,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
      AssignCommand(oCat3,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
      AssignCommand(oCat3z,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
      AssignCommand(oCat4z,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, ePum, oCat3);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam4x, oCat3z, 600.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam4x, oCat4, 600.0);

      DelayCommand(1.0,AssignCommand(oPC,SpeakString("Ups")));
      DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEfecto1,oPC));
      DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,ePum,oCat2));

      DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,ePum,OBJECT_SELF));
      DelayCommand(2.0,FadeToBlack(oPC,FADE_SPEED_FAST));
      DelayCommand(2.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK,1.0,10.0)));
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPon) - 1, DAMAGE_TYPE_FIRE), oPon));

      DelayCommand(6.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eFuego,oCat2z, 600.0));
      DelayCommand(6.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eFuego,oAnti, 600.0));
      DelayCommand(6.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDano,oPC));
      DelayCommand(6.0,FadeFromBlack(oPC,FADE_SPEED_MEDIUM));

      DelayCommand(7.0,AssignCommand(oPC,SpeakString("¡Auch!")));

      DestroyObject(oDestruc1, 600.0);
      DestroyObject(oDestruc2, 600.0);
      DelayCommand(600.0, AssignCommand(oCat2,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
      DelayCommand(600.0, AssignCommand(oCat3,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
      DelayCommand(600.0, AssignCommand(oCat3z,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
      DelayCommand(600.0, AssignCommand(oCat4z,PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
      DelayCommand(600.0, DeleteLocalInt(OBJECT_SELF, "AMNAGANTIMAGIA"));
  }
}
