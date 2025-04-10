//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guion:  wrap_on_uequip_i                                  //:://
//::////////////////////////////////////////////////////////////////////////////
//:: GUION ON_UNEQUIP_ITEM PARA EL SERVIDOR PUERTA DE BALDUR              //:://
//:: Creado por Monti                                                     //:://
//::////////////////////////////////////////////////////////////////////////////

#include "mti_libreria"
#include "f_vampire_h"
#include "dote_comp_armas"
#include "nostack_inc"
#include "lib_dm_vfx"
#include "pb_inc_mmf"

void RemoveAutoFrenzy(object oPC, object oArmor)
{
     IPRemoveMatchingItemProperties (oArmor, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, - 1, -1 );
}

void ReEquiparObjetoMaldito(object oPC, object oObjetoDesequipado)
{
  object oBrazales = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
  if(GetStringLeft(GetTag(oBrazales), 15) == "grillete_arcano") return;
  else AssignCommand(oPC, ActionEquipItem(oObjetoDesequipado, INVENTORY_SLOT_ARMS));
}

void EliminarCompetenciasArmaduras(object oPC)
{
  if(!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)))
  {
       ReaplicarEfectosPB(oPC, TRUE);
  }
}

void EliminarCompetenciasEscudos(object oPC)
{
  if(!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)))
    {
        ReaplicarEfectosPB(oPC, TRUE);
    }
}

void main()
{
  object oPC = GetPCItemLastUnequippedBy();
  object oObjetoDesquipado = GetPCItemLastUnequipped();
  string sObjetoDesEquipado = GetTag(oObjetoDesquipado);
  int iTipoObjetoDesequipado = GetBaseItemType(oObjetoDesquipado);

  //MAESTRO MULTIPLES FORMAS
  MMF_RemoveIP(oObjetoDesquipado);

  // COMPETENCIAS (Armas, armaduras y escudos)
  EliminarCompetenciaArmas(oObjetoDesquipado);
  if(iTipoObjetoDesequipado == BASE_ITEM_SMALLSHIELD || iTipoObjetoDesequipado == BASE_ITEM_LARGESHIELD ||
     iTipoObjetoDesequipado == BASE_ITEM_TOWERSHIELD ) DelayCommand(0.5, ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE));
  // QUITAR REDUCCION AL MOV. AL DESEQUIPARSE LA ARMADURA
  if(iTipoObjetoDesequipado == BASE_ITEM_ARMOR) DelayCommand(0.5, ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE));

  // No apilamiento de 3.5 en caracteristicas, habilidades, salvaciones y regeneracion
  NoSkillStackOnUnEquip(oPC, oObjetoDesquipado);
  NoAbilityStackOnUnEquip(oPC, oObjetoDesquipado);
  NoSavingThrowStackOnUnEquip(oPC, oObjetoDesquipado);
  NoRegStackOnUnEquip(oPC, oObjetoDesquipado, 1);


  //Desmarcamos que es de trama si no era ya de trama
  if (GetLocalInt(oObjetoDesquipado, "aQuitarTrama") == TRUE){
        SetPlotFlag(oObjetoDesquipado, FALSE);
        SetLocalInt(oObjetoDesquipado, "aQuitarTrama", FALSE);
  }

// LIMITADOR CA JOSE-G-C 13-6-15
//Restauramos la CA del objeto original, en caso de habersela bajado por equiparse mas CA de la permitida a su nivel
  itemproperty ip = GetFirstItemProperty(oObjetoDesquipado);
  int CA, CHA;
  while (GetIsItemPropertyValid(ip))
  {
     //Lo aplicamos solo a propiedades permanentes para evitar confundirla con temporales de clerigo
     if( (GetItemPropertyType(ip) == ITEM_PROPERTY_AC_BONUS) && (GetItemPropertyDurationType(ip)== DURATION_TYPE_PERMANENT ) )
     {
         // Restauramos la CA en caso de ser 3 y tener guardada una diferente
         if ( GetItemPropertyCostTableValue(ip) == 3 && GetLocalInt(oObjetoDesquipado, "BonoCA")!= 0 )
             {
                 CA = RemovePropertyAndReturnModifier(oObjetoDesquipado, ITEM_PROPERTY_AC_BONUS );
                 AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(GetLocalInt(oObjetoDesquipado, "BonoCA")), oObjetoDesquipado);
                 DeleteLocalInt(oObjetoDesquipado, "BonoCA");
                 SendMessageToPC(oPC,"<c´þd>* Restaurada la CA del objeto limitada por nivel *</c>");
             }
         // Restauramos la CA en caso de ser 4 y tener guardada una diferente
         if (GetItemPropertyCostTableValue(ip) == 4 && GetLocalInt(oObjetoDesquipado, "BonoCA")!= 0 )
             {
                 CA = RemovePropertyAndReturnModifier(oObjetoDesquipado, ITEM_PROPERTY_AC_BONUS );
                 AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(GetLocalInt(oObjetoDesquipado, "BonoCA")), oObjetoDesquipado);
                 DeleteLocalInt(oObjetoDesquipado, "BonoCA");
                 SendMessageToPC(oPC,"<c´þd>* Restaurada la CA del objeto limitada por nivel *</c>");
             }

     }
     if( (GetItemPropertyType(ip) == ITEM_PROPERTY_ABILITY_BONUS) && (GetItemPropertyDurationType(ip)== DURATION_TYPE_PERMANENT ) )
     {
        // Restauramos la variación de la característica en caso de ser 5 y tener guardada una diferente
        if (GetItemPropertyCostTableValue(ip) == 5 && GetLocalInt(oObjetoDesquipado, "BonoCHA")!= 0 )
        {
                 CHA = RemovePropertyAndReturnModifier(oObjetoDesquipado, ITEM_PROPERTY_ABILITY_BONUS);
                 AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(GetItemPropertySubType(ip), GetLocalInt(oObjetoDesquipado, "BonoCHA")), oObjetoDesquipado);
                 DeleteLocalInt(oObjetoDesquipado, "BonoCHA");
                 SendMessageToPC(oPC,"<c´þd>* Restaurada la variación a característica del objeto limitada por nivel *</c>");
        }
     }
     ip = GetNextItemProperty(oObjetoDesquipado);
  }

  // DESACTIVACON DE MODOS
  // 1. Ataque poderoso
  // 2. Disparo multiple
  // 3. Combate con dos armas mayor
  // 4. Defensa con dos armas
  // 5. Carrera
  // 6. Posición de Falange
  if(GetHasSpellEffect(898, oPC))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Ataque poderoso desactivado *</c>", oPC, FALSE);
      RemoveEffectsFromSpell(oPC, 898);
  }
  if(GetHasSpellEffect(980, oPC) || GetHasSpellEffect(981, oPC))
  {
    if( GetBaseItemType(oObjetoDesquipado) != BASE_ITEM_ARROW &&      //Flechas
        GetBaseItemType(oObjetoDesquipado) != BASE_ITEM_BULLET &&     //Balas
        GetBaseItemType(oObjetoDesquipado) != BASE_ITEM_BOLT          //Virotes
        ){
            FloatingTextStringOnCreature("<cþ<<>* Modo Disparo Múltiple desactivado *</c>", oPC, FALSE);
            RemoveEffectsFromSpell(oPC, 980);
            RemoveEffectsFromSpell(oPC, 981);
        }
  }
  if(GetHasSpellEffect(982, oPC))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Combate con dos armas Mayor desactivado *</c>", oPC, FALSE);
      RemoveEffectsFromSpell(oPC, 982);
  }
  if(GetHasSpellEffect(983, oPC))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Defensa con dos armas desactivado *</c>", oPC, FALSE);
      RemoveEffectsFromSpell(oPC, 983);
  }
  if(GetHasSpellEffect(984, oPC) && GetBaseItemType(oObjetoDesquipado) == BASE_ITEM_ARMOR)
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Carrera desactivado *</c>", oPC, FALSE);
      RemoveEffectsFromSpell(oPC, 984);
  }
  if(GetHasSpellEffect(1328, oPC))
  {
      FloatingTextStringOnCreature("<cþ<<>** Posición de Falange Desactivada **</c>", oPC, FALSE);
      RemoveEffectsFromSpell(oPC, 1328);
  }


  // HABILIDADES DEL TIRADOR DE LA ESPESURA
  if(GetLevelByClass(42, oPC))
  {
      if(iTipoObjetoDesequipado == BASE_ITEM_LIGHTCROSSBOW ||
         iTipoObjetoDesequipado == BASE_ITEM_HEAVYCROSSBOW ||
         iTipoObjetoDesequipado == BASE_ITEM_SHORTBOW      ||
         iTipoObjetoDesequipado == BASE_ITEM_LONGBOW       ||
         iTipoObjetoDesequipado == BASE_ITEM_ARROW         ||
         iTipoObjetoDesequipado == BASE_ITEM_BOLT)
     {
         IPRemoveMatchingItemProperties(oObjetoDesquipado, ITEM_PROPERTY_MASSIVE_CRITICALS, DURATION_TYPE_TEMPORARY);
         IPRemoveMatchingItemProperties(oObjetoDesquipado, ITEM_PROPERTY_KEEN, DURATION_TYPE_TEMPORARY);
         IPRemoveMatchingItemProperties(oObjetoDesquipado, ITEM_PROPERTY_ON_HIT_PROPERTIES, DURATION_TYPE_TEMPORARY);
     }
  }

  // LOS OBJETOS MALDITOS NO SE DESEQUIPAN POR MUCHO QUE LO INTENTES...
  if(GetStringLeft(GetTag(oObjetoDesquipado), 15) == "grillete_arcano")
  {
      effect eInmo = EffectCutsceneImmobilize();
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInmo, oPC, 2.0);
      DelayCommand(1.0, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(1.1, ReEquiparObjetoMaldito(oPC, oObjetoDesquipado));
      return;
  }

  // BARDOS BRUJOS Y MDL NO TIENEN FALLO DE CONJURO ARCANO EN ARMADURAS LIGERAS (desaparicion efectos)
  if(GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0 || GetLevelByClass(57, oPC) > 0 || GetLevelByClass(34, oPC) > 0)
  {
    if(iTipoObjetoDesequipado == BASE_ITEM_ARMOR) IPRemoveAllItemProperties(oObjetoDesquipado);
  }

  // Vampiretes, correcion de los monjes
  if(GetIsVampire(oPC) == TRUE)
  {
      if(GetAppearanceType(oPC) <=6)
      {
         if(GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0)
         {
            if(iTipoObjetoDesequipado == BASE_ITEM_BRACER || iTipoObjetoDesequipado == BASE_ITEM_GLOVES)
            {
                object oMordisco = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
                if(oMordisco != OBJECT_INVALID) DestroyObject(oMordisco);
                object oO = GetFirstItemInInventory(oPC);
                string sS;
                while(GetIsObjectValid(oO))
                {
                    sS = GetTag(oO);
                    if(sS == "NW_IT_CREWPS014" || sS == "NW_IT_CREWPS033"
                    || sS == "NW_IT_CREWPS011" || sS == "NW_IT_CREWPS007"
                    || sS == "asy_mordiscovampiro") DestroyObject(oO);

                    oO = GetNextItemInInventory(oPC);
                }

                ReaplicarEfectosPB(oPC,TRUE);
            }
         }
      }
  }

   //Berserker Frenetico, AutoFrenesy
   if(GetLevelByClass(56, oPC) > 0 )
     {
      object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
      if(oObjetoDesquipado == oArmor)
             {
                RemoveAutoFrenzy(oPC, oArmor);
             }
     }

   //Improved Crossbow Sniper
    if(GetHasFeat(1521, oPC))
        {
         if(iTipoObjetoDesequipado == BASE_ITEM_LIGHTCROSSBOW || iTipoObjetoDesequipado == BASE_ITEM_HEAVYCROSSBOW)
         DeleteLocalInt(oPC, "DOTE_FRANCOTIRADOR");
        }

    //Crossbow Sniper
    /*if(GetHasFeat(1522, oPC))
        {
         if(iTipoObjetoDesequipado == BASE_ITEM_LIGHTCROSSBOW || iTipoObjetoDesequipado == BASE_ITEM_HEAVYCROSSBOW)
         DeleteLocalInt(oPC, "DOTE_FRANCOTIRADOR");
        }    */

    //VENGADORA IMPIA
    if(GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) > 0 )
    {
      object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
      if(oObjetoDesquipado == oWeapon && GetLocalInt(oObjetoDesquipado, "Arma_Impia") == 1 )
        {
            IPRemoveMatchingItemProperties(oObjetoDesquipado, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP, DURATION_TYPE_TEMPORARY);
            IPRemoveMatchingItemProperties(oObjetoDesquipado, ITEM_PROPERTY_ENHANCEMENT_BONUS, DURATION_TYPE_TEMPORARY);
            IPRemoveMatchingItemProperties(oObjetoDesquipado, ITEM_PROPERTY_ON_HIT_PROPERTIES, DURATION_TYPE_TEMPORARY);
            IPRemoveMatchingItemProperties(oObjetoDesquipado, ITEM_PROPERTY_SPELL_RESISTANCE, DURATION_TYPE_TEMPORARY);
        }
    }

 ///SETS DE ARMADURAS ESPECIALES
    /*int PiezaAngel = 0;
    int PiezaInfernal = 0;
    int PiezaNirvana = 0;
    int PiezaCamino = 0;
    int PiezaArtifice = 0;
    int PiezaGigante = 0;
    int PiezaVaraNegra = 0;
    int PiezaLoco = 0;
    int PiezaInmortal = 0;
    int PiezaTierra = 0;*/
    object oCelestial = GetItemPossessedBy(oPC, "item_celestial");
    object oInfernal = GetItemPossessedBy(oPC, "item_infernal");
    object oNirvana = GetItemPossessedBy(oPC, "item_nirvana");
    object oCamino = GetItemPossessedBy(oPC, "item_camino");
    object oArtifice = GetItemPossessedBy(oPC, "item_artifice");
    object oGigante = GetItemPossessedBy(oPC, "item_gigante");
    object oVaranegra = GetItemPossessedBy(oPC, "item_varanegra");
    object oLoco = GetItemPossessedBy(oPC, "item_loco");
    object oInmortal = GetItemPossessedBy(oPC, "item_inmortal");
    object oTierra = GetItemPossessedBy(oPC, "item_tierra");

    //Pieza del Kit Celestial
    if(GetLocalInt(oObjetoDesquipado, "Kit_Celestial") == 1 )
    {
       // GuardarIntPersistente(oPC, "Pieza_Celestial", PiezaAngel - 1);

        //Si tenemos el poder activo, lo quitamos
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && GetLocalInt(oPC, "Poder_Celestial") == 1)
        {
            ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);
            GuardarIntPersistente(oPC, "Poder_activo", 0);
            SetLocalInt(oPC, "Poder_Celestial", 0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oPC);
            //Destruimos el item
            DestroyObject(oCelestial);

            //Si nos hemos cambiado las alas...
            if(ObtenerIntPersistente(oPC, "ALAS_CAMBIADAS") == TRUE)
            {
                SetCreatureWingType(ObtenerIntPersistente(oPC, "ALAS_MEMORIZADAS"), oPC);
                GuardarIntPersistente(oPC, "ALAS_CAMBIADAS", FALSE);
                GuardarIntPersistente(oPC, "ALAS_MEMORIZADAS", FALSE);
            }
            else SetCreatureWingType(0, oPC);
        }
    }

    //Pieza del Kit Infernal
    if(GetLocalInt(oObjetoDesquipado, "Kit_Infernal") == 1 )
    {
       // GuardarIntPersistente(oPC, "Pieza_Infernal", PiezaInfernal - 1);

        //Si tenemos el poder activo, lo quitamos
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && GetLocalInt(oPC, "Poder_Infernal") == 1)
        {
            ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);
            GuardarIntPersistente(oPC, "Poder_activo", 0);
            SetLocalInt(oPC, "Poder_Infernal", 0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oPC);
            //Destruimos el item
            DestroyObject(oInfernal);

            //Si nos hemos cambiado las alas...
            if(ObtenerIntPersistente(oPC, "ALAS_CAMBIADAS") == TRUE)
            {
                SetCreatureWingType(ObtenerIntPersistente(oPC, "ALAS_MEMORIZADAS"), oPC);
                GuardarIntPersistente(oPC, "ALAS_CAMBIADAS", FALSE);
                GuardarIntPersistente(oPC, "ALAS_MEMORIZADAS", FALSE);
            }
            else SetCreatureWingType(0, oPC);
        }
    }

    //Pieza del Kit Nirvana
    if(GetLocalInt(oObjetoDesquipado, "Kit_Nirvana") == 1 )
    {
        //GuardarIntPersistente(oPC, "Pieza_Nirvana", PiezaNirvana - 1);

        //Si tenemos el poder activo, lo quitamos
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && GetLocalInt(oPC, "Poder_Nirvana") == 1)
        {
            ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);
            GuardarIntPersistente(oPC, "Poder_activo", 0);
            SetLocalInt(oPC, "Poder_Nirvana", 0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oPC);
            //Destruimos el item
            DestroyObject(oNirvana);

            //Si nos hemos cambiado las alas...
            if(ObtenerIntPersistente(oPC, "ALAS_CAMBIADAS") == TRUE)
            {
                SetCreatureWingType(ObtenerIntPersistente(oPC, "ALAS_MEMORIZADAS"), oPC);
                GuardarIntPersistente(oPC, "ALAS_CAMBIADAS", FALSE);
                GuardarIntPersistente(oPC, "ALAS_MEMORIZADAS", FALSE);
            }
            else SetCreatureWingType(0, oPC);
        }
    }

    //Pieza del Kit Camino sin fin
    if(GetLocalInt(oObjetoDesquipado, "Kit_Camino") == 1 )
    {
        //GuardarIntPersistente(oPC, "Pieza_Camino", PiezaCamino - 1);

        //Si tenemos el poder activo, lo quitamos
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && GetLocalInt(oPC, "Poder_Camino") == 1)
        {
            ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);
            GuardarIntPersistente(oPC, "Poder_activo", 0);
            SetLocalInt(oPC, "Poder_Camino", 0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oPC);
            //Destruimos el item
            DestroyObject(oCamino);
        }
    }

    //Pieza del Kit Artifice
    if(GetLocalInt(oObjetoDesquipado, "Kit_Artifice") == 1 )
    {
        //GuardarIntPersistente(oPC, "Pieza_Artifice", PiezaArtifice - 1);

        //Si tenemos el poder activo, lo quitamos
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && GetLocalInt(oPC, "Poder_Artifice") == 1)
        {
            ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);
            GuardarIntPersistente(oPC, "Poder_activo", 0);
            SetLocalInt(oPC, "Poder_Artifice", 0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oPC);
            //Destruimos el item
            DestroyObject(oArtifice);
        }
    }

    //Pieza del Kit Gigante
    if(GetLocalInt(oObjetoDesquipado, "Kit_Gigante") == 1 )
    {
        //GuardarIntPersistente(oPC, "Pieza_Gigante", PiezaGigante - 1);

        //Si tenemos el poder activo, lo quitamos
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && GetLocalInt(oPC, "Poder_Gigante") == 1)
        {
            ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);
            if (ObtenerIntPersistente(oPC, "CAB_ALTURA")==TRUE)
                {
                    float fAltura = ObtenerFloatPersistente(oPC, "IND_ALTURA");
                    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fAltura);
                }
            else SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, 1.00);
            GuardarIntPersistente(oPC, "Poder_activo", 0);
            SetLocalInt(oPC, "Poder_Gigante", 0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oPC);
            //Destruimos el item
            DestroyObject(oGigante);
        }
    }

    //Pieza del Kit Vara Negra
    if(GetLocalInt(oObjetoDesquipado, "Kit_Varanegra") == 1 )
    {
        //GuardarIntPersistente(oPC, "Pieza_Varanegra", PiezaVaraNegra - 1);

        //Si tenemos el poder activo, lo quitamos
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && GetLocalInt(oPC, "Poder_VaraNegra") == 1)
        {
           ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);
            GuardarIntPersistente(oPC, "Poder_activo", 0);
            SetLocalInt(oPC, "Poder_VaraNegra", 0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oPC);
            //Destruimos el item
            DestroyObject(oVaranegra);
        }
    }

    //Pieza del Kit Loco
    if(GetLocalInt(oObjetoDesquipado, "Kit_Loco") == 1 )
    {
        //GuardarIntPersistente(oPC, "Pieza_Loco", PiezaLoco - 1);

        //Si tenemos el poder activo, lo quitamos
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && GetLocalInt(oPC, "Poder_Loco") == 1)
        {
            ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);
            GuardarIntPersistente(oPC, "Poder_activo", 0);
            SetLocalInt(oPC, "Poder_Loco", 0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oPC);
            //Destruimos el item
            DestroyObject(oLoco);
        }
    }

    //Pieza del Kit Rey Inmortal
    if(GetLocalInt(oObjetoDesquipado, "Kit_Inmortal") == 1 )
    {
        //GuardarIntPersistente(oPC, "Pieza_Inmortal", PiezaInmortal - 1);

        //Si tenemos el poder activo, lo quitamos
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && GetLocalInt(oPC, "Poder_Inmortal") == 1)
        {
            ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);
            GuardarIntPersistente(oPC, "Poder_activo", 0);
            SetLocalInt(oPC, "Poder_Inmortal", 0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oPC);
            //Destruimos el item
            DestroyObject(oInmortal);
        }
    }

    //Pieza del Kit Deber de Tierra
    if(GetLocalInt(oObjetoDesquipado, "Kit_Tierra") == 1 )
    {
        //GuardarIntPersistente(oPC, "Pieza_Tierra", PiezaTierra - 1);

        //Si tenemos el poder activo, lo quitamos
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && GetLocalInt(oPC, "Poder_Tierra") == 1)
        {
            ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);
            GuardarIntPersistente(oPC, "Poder_activo", 0);
            SetLocalInt(oPC, "Poder_Tierra", 0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oPC);
            //Destruimos el item
            DestroyObject(oTierra);
        }
    }

    // SISTEMA DE EFECTOS PERSISTENTES
    OnUnequipItemCheckIfHelmAndApplyDMVFX(oPC, oObjetoDesquipado);

    /*//Recuperamos la CA de un objeto, si la tenía eliminada por comando DM.
    if(GetLocalInt(oObjetoDesquipado,"RegeneracionEliminada") > 0)
    {
        int iCantidad = GetLocalInt(oObjetoDesquipado,"RegeneracionEliminada");
        IPSafeAddItemProperty(oObjetoDesquipado, ItemPropertyRegeneration(iCantidad));
    }*/
}


