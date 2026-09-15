//::////////////////////////////////////////////////////////////////////////////
//:: GUION wrap_on_act_item
//:: Copyright (c) www.puertadebaldur.net
//::////////////////////////////////////////////////////////////////////////////
/*
  Regula todos los Poderes Unicos del modulo.
*/
//::////////////////////////////////////////////////////////////////////////////
//:: Creador por: Monti
//:: Ultima modificacion: 11/04/2012
//::////////////////////////////////////////////////////////////////////////////

//#include "zep_inc_phenos"
#include "x0_i0_petrify"
#include "tj_inc"
#include "escalar_inc"
#include "f_vampire_activa"
#include "nwnx_creature"
#include "lib_disguise"
#include "pb_potion_inc"
#include "mti_subrazas_inc"
#include "nw_i0_2q4luskan"
#include "x0_i0_spells"
#include "mti_libreria"
#include "q_inc_acp"
#include "pb_tesoros_inc"
#include "nwnx_object"
#include "lib_dm_vfx"
#include "inc_sum_golem"
#include "inc_timelock"
#include "pb_constantes"
#include "x3_inc_string"
#include "inc_spells"
#include "inc_generic"

void DevolverAltura(object oPC, float fAltura)
{
       SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fAltura);
}

void CreateItemOnObjectVoid(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1)
{
     CreateItemOnObject(sItemTemplate, oTarget, nStackSize);
}

void DesequiparObjetosTRansformacionesSubrazas(object oJugador)
{
  object oManoIzq = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oJugador);
  object oManoDer = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oJugador);
  object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST, oJugador);
  int iCABase = GetArmorType(oArmadura);

  if(oManoIzq != OBJECT_INVALID) AssignCommand(oJugador, ActionUnequipItem(oManoIzq));
  if(oManoDer != OBJECT_INVALID) AssignCommand(oJugador, ActionUnequipItem(oManoDer));
  if(!(oArmadura == OBJECT_INVALID) && (iCABase > 3)) AssignCommand(oJugador, ActionUnequipItem(oArmadura));

}

void DestruirMordisco(object oJugador)
{
  object oMordisco = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oJugador);
  if(oMordisco != OBJECT_INVALID) DestroyObject(oMordisco);
  object oO = GetFirstItemInInventory(oJugador);
  string sS;
  while(GetIsObjectValid(oO))
    {
    sS = GetTag(oO);
    if(sS == "NW_IT_CREWPS014" || sS == "NW_IT_CREWPS033"
       || sS == "NW_IT_CREWPS010" || sS == "NW_IT_CREWPS005"
       || sS == "asy_mordiscovampiro") DestroyObject(oO);

        oO = GetNextItemInInventory(oJugador);
    }
}

void EquiparMordisco(object oJugador, string sMordisco)
{
  if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_CREATURE,oJugador)==TRUE)
  {
      object oItem2 =  GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oJugador);
      if(oItem2==OBJECT_INVALID)
      {
          oItem2=CreateItemOnObject(sMordisco,oJugador,1);
          SetIdentified(oItem2, TRUE);
          DelayCommand(0.1,AssignCommand(oJugador, ClearAllActions(TRUE)));
          DelayCommand(0.3,AssignCommand(oJugador, ActionDoCommand(ActionEquipItem(oItem2, INVENTORY_SLOT_CWEAPON_B))));
      }
  }
}

void main()
{
    object oPC = GetItemActivator();

    object oItem       = GetItemActivated();
    object oActivator  = GetItemActivator();
    object oTarget     = GetItemActivatedTarget();
    location lLocation = GetItemActivatedTargetLocation();
    string sTagDelObjeto = GetTag(oItem);
    object area = GetArea(oPC);
    string nombrearea = GetName(area,TRUE);
    int iCasterLevel = GetCL(oPC);
    int iPlmLevel = GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC);
    string sSubRace = GetStringLowerCase(GetSubRace(oPC));

  //Limpieza de vampiros monje.
  if(GetTag(oItem) == "sf_limpieza_vamp") {
    object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
    object oLeft = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
    object oRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);

    DestroyObject(oBite);
    DestroyObject(oLeft);
    DestroyObject(oRight);
  }

  // OFICIOS
  if(GetStringLeft(sTagDelObjeto, 8) == "sute_her") { usarPocionHerboristeria(oPC, sTagDelObjeto); return; }
  // The seven objects of the old trade system. Their handlers are gone and
  // the objects stay in whatever inventory holds them, so activating one has
  // to end here: without this the tag would fall through to the generic
  // handlers below, which answer during Frenzy and run three unrelated
  // scripts. Doing nothing means doing nothing.
  if(sTagDelObjeto == "pb_ofi_varita_es"   || sTagDelObjeto == "libroHerboristeria" ||
     sTagDelObjeto == "libroHerreria"      || sTagDelObjeto == "carp_libro"         ||
     sTagDelObjeto == "orf_libro"          || sTagDelObjeto == "pb_ofi_man_artes"   ||
     sTagDelObjeto == "sapocuelib") return;

  //Bersker Frenetico
  if(GetHasFeatEffect(1443,oPC))
    {
     SendMessageToPC(oPC, "¡No puedes usar objetos estando en Frenesi!");
     return;
    }

  //Borrar Varitas de Brujo
    if(sTagDelObjeto == "var_borrar")
        {
           if(oTarget != OBJECT_INVALID)
            {
            if(GetLocalInt(oTarget, "DESTROYWAND") == 1 )
                {
                SetPlotFlag(oTarget, FALSE); DestroyObject(oTarget, 0.5);
                }
            else SendMessageToPC(oPC, "¡El objetivo no es una varita valida!");
            }
        }

  // VAMPIROS
  if(GetIsVampire(oPC)==TRUE)
  {
      // Transformaciones vampiricas
      if((GetStringLeft(sTagDelObjeto, 9)=="asy_forma") && (GetIsVampire(oPC)==TRUE))
      {
          if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
          {
              SendMessageToPC(oPC,ColorTexto("No puedes cambiar de forma estando montado. Desmóntate.",TXT_COLOR_ROJO));
              return;
          }
          int iAparienciaAGuardar = GetAppearanceType(oPC);
          int iAparienciaCambiada = ObtenerIntPersistente(oPC, "APA_CAMBIADA");
          int iAparienciaOriginal = ObtenerIntPersistente(oPC, "APA_MEMORIZADA");
          string sFormaVamp, sSonido;
          int rango,inc;
          effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

          int iFue = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_STRENGTH);
          int iDes = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_DEXTERITY);
          int iCon = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_CONSTITUTION);
          /*int iInt = GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE);
          int iSab = GetAbilityScore(oPC, ABILITY_WISDOM, TRUE);
          int iCar = GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE); */
          int iMovementRate = GetMovementRate(oPC);

          if(iAparienciaCambiada == 0)
          {
              GuardarIntPersistente(oPC, "APA_CAMBIADA", 1);
              GuardarIntPersistente(oPC, "APA_MEMORIZADA", iAparienciaAGuardar);
              Vampire_Remove_Stats(oPC);
              int iAparienciaCiatura;
              string sIndetidadHabilidad = GetStringRight(GetResRef(GetItemActivated()), 2);
              iAparienciaCiatura = 10;
              if(sIndetidadHabilidad == "01")
              {
                  iAparienciaCiatura = 10;//1892;       // Murcielago
                  sFormaVamp = "murcielago";
                  sSonido="as_an_x2cvbat2";
              }
              else
              {
                  if(sIndetidadHabilidad == "02")
                  {
                      sSonido="as_an_ratsqueak1";
                      iAparienciaCiatura = 386; // Rata
                      sFormaVamp= "rata";
                      if(Determine_Vampire_Level(oPC) >= DireWolfLevel)
                      {
                          iAparienciaCiatura = 387; //Rata Terrible
                          sFormaVamp= "rata terrible";
                      }
                  }
                  else
                  {
                      if(sIndetidadHabilidad == "03")
                      {
                          sSonido="as_an_wolfhowl1";
                          iAparienciaCiatura = 185; // Lobo
                          sFormaVamp= "lobo";
                          if(Determine_Vampire_Level(oPC) >= DireWolfLevel)
                          {
                              iAparienciaCiatura = 175; // 1827 Lobo Terrible
                              sFormaVamp= "lobo terrible";
                          }
                      }
                  }
              }

              effect ePoly = EffectVisualEffect(VFX_IMP_POLYMORPH);
              DelayCommand(5.6, DesequiparObjetosTRansformacionesSubrazas(oPC));
              DelayCommand(5.6,DestruirMordisco(oPC));
              ClearAllActions(TRUE);
              ActionWait(3.0);
              ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 4.0);
              SetCommandable(FALSE, oPC);
              DelayCommand(0.5, pentagram(GetLocation(oPC), VFX_BEAM_EVIL, 4.5));
              DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));
              DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
              DelayCommand(5.5,SetCreatureAppearanceType(oPC, iAparienciaCiatura));
              DelayCommand(5.5, SetCommandable(TRUE, oPC));
              DelayCommand(5.8, ClearAllActions());

              if(sFormaVamp == "murcielago")
              {
                  DelayCommand(5.1,SetPortraitResRef(oPC,"po_bat_"));
                  if(iAparienciaCiatura == 10) NWNX_Creature_SetMovementRate(oPC, 5);
              }
              else if(sFormaVamp == "rata")
              {
                  DelayCommand(5.1,SetPortraitResRef(oPC,"po_rat_"));
                  //if(iAparienciaCiatura == 386) NWNX_Creature_SetMovementRate(oPC, 5);
                  if(iAparienciaCiatura == 1112) NWNX_Creature_SetMovementRate(oPC, 5);
                  EquiparMordisco(oPC,"NW_IT_CREWPS014");
              }
              else if(sFormaVamp == "rata terrible")
              {
                  DelayCommand(5.1,SetPortraitResRef(oPC,"po_direrat_"));
                  //if(iAparienciaCiatura == 387) NWNX_Creature_SetMovementRate(oPC, 5);
                  if(iAparienciaCiatura == 1111) NWNX_Creature_SetMovementRate(oPC, 5);
                  EquiparMordisco(oPC,"NW_IT_CREWPS033");
              }
              else if(sFormaVamp == "lobo")
              {
                  DelayCommand(5.1,SetPortraitResRef(oPC,"po_worg_"));
                  //if(iAparienciaCiatura == 181) NWNX_Creature_SetMovementRate(oPC, 5);
                  if(iAparienciaCiatura == 185) NWNX_Creature_SetMovementRate(oPC, 5);
                  EquiparMordisco(oPC,"NW_IT_CREWPS005");
              }
              else if(sFormaVamp == "lobo terrible")
              {
                  DelayCommand(5.1,SetPortraitResRef(oPC,"po_worg_"));
                  //if(iAparienciaCiatura == 175) NWNX_Creature_SetMovementRate(oPC, 5);
                  if(iAparienciaCiatura == 175) NWNX_Creature_SetMovementRate(oPC, 5);
                  EquiparMordisco(oPC,"NW_IT_CREWPS033");
              }
              DelayCommand(5.5,AssignCommand(oPC, PlaySound(sSonido)));
              DelayCommand(6.0,Vampire_Apply_Stats(oPC));
          }
          else
          {
              SetPortraitResRef(oPC,GetLocalString(oPC,"RETRATO"));
              Vampire_Remove_Stats(oPC);
              DelayCommand(5.6,DestruirMordisco(oPC));
              //DelayCommand(6.0,EquiparMordisco(oPC,"NW_CREWPVBT"));

              GuardarIntPersistente(oPC, "APA_CAMBIADA", 0);
              effect ePoly = EffectVisualEffect(VFX_IMP_POLYMORPH);
              DelayCommand(5.6,DesequiparObjetosTRansformacionesSubrazas(oPC));

              ClearAllActions(TRUE);
              ActionWait(3.0);
              ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 4.0);
              SetCommandable(FALSE, oPC);
              DelayCommand(0.5, pentagram(GetLocation(oPC), VFX_BEAM_EVIL, 4.5));
              DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));
              DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
              DelayCommand(5.5,SetCreatureAppearanceType(oPC, iAparienciaOriginal));
              DelayCommand(5.5, SetCommandable(TRUE, oPC));
              DelayCommand(5.8, ClearAllActions());

              //SetMovementRate(oPC, iMovementRate);
              DelayCommand(6.2,Vampire_Apply_Stats(oPC));
              DelayCommand(6.2,DespoliformarRopasVisibles(oPC));

          }
      }

      //Volar/Trepar del Vampiro
      if(sTagDelObjeto == "asy_vuelo")
      {
          if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
          {
              SendMessageToPC(oPC,ColorTexto("No puedes volar estando montado. Desmóntate.",TXT_COLOR_ROJO));
              return;
          }
          if(GetLocalInt(GetArea(oPC), "NOTELEPORT") == 1)
          {
              SendMessageToPC(oPC, "Esta habilidad no se puede usar aquí, algo te lo impide.");
              return;
          }
          if((GetAppearanceType(oPC) >6) && !(GetAppearanceType(oPC)==10))
          {
              SendMessageToPC(oPC, "¡No puedes volar con esta apariencia!");
              //return;
          }

          SetImmortal(oPC, TRUE);
          DelayCommand(4.2, SetImmortal(oPC, FALSE));

          effect eVolar = EffectDisappearAppear(lLocation);
          DelayCommand(2.5, FadeToBlack(oPC, FADE_SPEED_FASTEST));
          DelayCommand(4.2, FadeFromBlack(oPC, FADE_SPEED_FASTEST));
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVolar, oPC, 4.0);
          //return;
      }

      //Hijos de la Noche
      if(sTagDelObjeto =="asy_llamarhijosnoche") AssignCommand(oPC,ActionStartConversation(oPC, "asy_hijosnoche", TRUE, FALSE));

      //Volar a Criptas
      if(sTagDelObjeto =="asy_obj_cemevuelo")
      {
         if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
         {
             SendMessageToPC(oPC,ColorTexto("No puedes volar estando montado. Desmóntate.",TXT_COLOR_ROJO));
             return;
         }
        if(GetLocalInt(GetArea(oPC), "NOTELEPORT") == 1)
        {
            SendMessageToPC(oPC, "Esta habilidad no se puede usar aquí, algo te lo impide.");
            return;
        }
        if(GetIsPC(oPC) == TRUE && (sSubRace == "engendro"))
        {
          AssignCommand(oPC,ActionStartConversation(oPC, "spawn_return", TRUE, FALSE));
        }
        else
        {
            /*if(GetAppearanceType(oPC)==10)*/ AssignCommand(oPC,ActionStartConversation(oPC, "asy_spk_cemetele", TRUE, FALSE));
            /*else  SendMessageToPC(oPC, "'No puedes volar largas distancias con la forma actual.");*/
        }
      }
  }

  VampireItemCheck();

  // LIBRO DE CONVOCACIONES
  if(sTagDelObjeto == "librodeconvocaci")
  {
      AssignCommand(oPC, ClearAllActions(TRUE));
      AssignCommand(oPC, ActionStartConversation(oPC, "convocaciones", TRUE, FALSE));
      return;
  }

  // VARITA DM "CREATURE WIZARD"
  if(sTagDelObjeto == "ZEP_CW_IT")
  {
      if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
      {
          FloatingTextStringOnCreature("El objetivo debe ser una criatura.", oPC, FALSE);
      }

      object oCW = CreateObject(OBJECT_TYPE_CREATURE, "zep_cw_cre", GetLocation(oPC));
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY)), oCW);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneGhost()), oCW);
      ChangeFaction(oCW, oTarget);
      SetLocalObject(oCW, "CW_Target", oTarget);
      SetPortraitResRef(oCW, GetPortraitResRef(oTarget));
      SetCustomToken(300, GetName(oTarget, TRUE));
      AssignCommand(oPC, ClearAllActions(TRUE));
      AssignCommand(oPC, ActionStartConversation(oCW, "", TRUE, FALSE));
  }

  // MONTURAS / MASCOTAS
  if(sTagDelObjeto == "cab_montura" || sTagDelObjeto == "cab_equitacion" || sTagDelObjeto == "cab_mascota")
  {
      if(nombrearea == "Mar de las Espadas" || nombrearea== "Mar Impenetrable")  //<- Modificacion de Nompho
      {
          SendMessageToPC(oPC, "¡No puedes hacerlo en el barco!");
          return;
      }

      ExecuteScript("cab_onactivate", OBJECT_SELF);
      return;
  }

  // PLUMA DE SISTEMA DE ESCRITURA
  if(sTagDelObjeto == "esc_pluma")
  {
      if(GetHasFeat(1324, oPC))
      {
          // Bono dote soltura hablar un idioma
          int iBonoSolturaIdioma = 0;
          if(GetHasFeat(1245, oPC)) iBonoSolturaIdioma = 10;      // Soltura epica
          else if(GetHasFeat(1233, oPC)) iBonoSolturaIdioma = 3;  // Soltura normal

          if(GetClassByPosition(2, oPC) == CLASS_TYPE_INVALID &&
             GetClassByPosition(3, oPC) == CLASS_TYPE_INVALID &&
            (GetSkillRank(34, oPC, TRUE) + iBonoSolturaIdioma) < 2)
          {
              SendMessageToPC(oPC, StringToRGBString("Eres [Analfabeto], no sabes leer ni escribir, por lo tanto no puedes usar la pluma. Si quisieras dejar de ser analfabeto deberías multiclasearte con cualquier otra clase o asignar 2 rangos a la habilidad 'Hablar un idioma'.","700"));
              return;
          }
      }

      if(GetTag(oTarget) != "esc_papel")
      {
          SendMessageToPC(oPC, StringToRGBString("No se puede escribir en el objetivo. Debe ser algún libro o nota en blanco.","700"));
          return;
      }

      SetItemCursedFlag(oTarget, TRUE);
      SetLocalObject(oPC, "ESC_PAPEL", oTarget);
      AssignCommand(oPC, ClearAllActions(TRUE));
      AssignCommand(oPC, ActionStartConversation(oPC, "esc_papel", TRUE, FALSE));
      return;
  }

  // ARMA: FURIA CELESTIAL
  if(sTagDelObjeto == "furia_celestial")
  {
      FloatingTextStringOnCreature("* Has liberado el poder del arma *", oPC, FALSE);
      SetDescription(oItem, "Activa el arma para liberar su poder durante 12 minutos. Podrï¿½s liberar su poder una vez al dï¿½a.");
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
      IPSafeAddItemProperty(oItem, ItemPropertyEnhancementBonus(3), 720.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
      IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus (IP_CONST_DAMAGETYPE_COLD, DAMAGE_BONUS_1d6),720.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
      IPSafeAddItemProperty(oItem, ItemPropertyVisualEffect (ITEM_VISUAL_COLD),720.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
      return;
  }

  //Con el nuevo sistema, mejor no añadir mas cosas a las prendas.
  // ROPAS REVERSIBLES (Delom)
  /*if(sTagDelObjeto == "RopasReversibles")
  {
      object revertida1, revertida2;
      int i, ropas0, ropas1, color0, color1;
      object Modelo=GetObjectByTag("TailoringModel"); //el recipiente para el cambio de ropa, el modelo sastre del cep en este caso
      int rType=GetBaseItemType(oItem);

      //copiamos las ropas a un modelo para hacer el cambio en su inventario evitando que se llene el del PJ
      revertida1=CopyItem(oItem, Modelo, TRUE);
      DestroyObject(oItem);

      //intercambiamos las variables a la vez que modificamos las ropas de apariencia en el modelo
      if(rType==BASE_ITEM_ARMOR)
      {
          for(i=0;i<=18;i++)
          {
              if((i%2)==0)
              {
                  ropas0=GetItemAppearance(revertida1, ITEM_APPR_TYPE_ARMOR_MODEL, i);
                  ropas1=GetLocalInt(revertida1, "ropas"+IntToString(i) );
                  DeleteLocalInt(revertida1, "ropas"+IntToString(i));
                  SetLocalInt(revertida1, "ropas"+IntToString(i), ropas0);
                  revertida2=CopyItemAndModify(revertida1, ITEM_APPR_TYPE_ARMOR_MODEL, i, ropas1, TRUE);
                  DestroyObject(revertida1);
              }
              else
              {
                  ropas0=GetItemAppearance(revertida2, ITEM_APPR_TYPE_ARMOR_MODEL, i);
                  ropas1=GetLocalInt(revertida2, "ropas"+IntToString(i) );
                  DeleteLocalInt(revertida2, "ropas"+IntToString(i));
                  SetLocalInt(revertida2, "ropas"+IntToString(i), ropas0);
                  revertida1=CopyItemAndModify(revertida2, ITEM_APPR_TYPE_ARMOR_MODEL, i, ropas1, TRUE);
                  DestroyObject(revertida2);
              }
          }
      }
      else if((rType==BASE_ITEM_CLOAK)||(rType==BASE_ITEM_HELMET))
      {
          ropas0=GetItemAppearance(revertida1, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
          ropas1=GetLocalInt(revertida1, "appsimple");
          DeleteLocalInt(revertida1, "appsimple");
          SetLocalInt(revertida1, "appsimple",ropas0);
          revertida2=CopyItemAndModify(revertida1, ITEM_APPR_TYPE_SIMPLE_MODEL,0, ropas1,TRUE);
          DestroyObject(revertida1);
      }
      else SendMessageToPC(oPC, "No es un objeto vï¿½lido.");

      //intercambiamos las variables a la vez que modificamos las ropas de color en el modelo
      for(i=0;i<=5;i++)
      {
          if((i%2)==0)
          {
              color0=GetItemAppearance(revertida2, ITEM_APPR_TYPE_ARMOR_COLOR, i);
              color1=GetLocalInt(revertida2, "color"+IntToString(i));
              DeleteLocalInt(revertida2, "color"+IntToString(i));
              SetLocalInt(revertida2, "color"+IntToString(i), color0);
              revertida1=CopyItemAndModify(revertida2, ITEM_APPR_TYPE_ARMOR_COLOR, i, color1, TRUE);
              DestroyObject(revertida2);
          }
          else
          {
              color0=GetItemAppearance(revertida1, ITEM_APPR_TYPE_ARMOR_COLOR, i);
              color1=GetLocalInt(revertida1, "color"+IntToString(i));
              DeleteLocalInt(revertida1, "color"+IntToString(i));
              SetLocalInt(revertida1, "color"+IntToString(i), color0);
              revertida2=CopyItemAndModify(revertida1, ITEM_APPR_TYPE_ARMOR_COLOR, i, color1, TRUE);
              DestroyObject(revertida1);
          }
      }

      //le devolvemos las ropas al PJ y se las equipamos
      revertida1=CopyItem(revertida2, oPC, TRUE);
      DestroyObject(revertida2);
      if(rType==BASE_ITEM_ARMOR) AssignCommand(oPC, ActionEquipItem(revertida1,INVENTORY_SLOT_CHEST) );
      if(rType==BASE_ITEM_CLOAK) AssignCommand(oPC, ActionEquipItem(revertida1,INVENTORY_SLOT_CLOAK) );
      if(rType==BASE_ITEM_HELMET) AssignCommand(oPC, ActionEquipItem(revertida1,INVENTORY_SLOT_HEAD) );

      return;
  }*/

  // SISTEMA DE MUERTE: Usar cadaveres en PNJs para resucitarlos
  if(GetStringLeft(sTagDelObjeto, 10) == "pg_cadaver")
  {
      if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
      {
          SendMessageToPC(oPC, "El objetivo no es una criatura vï¿½lida. Debe ser un PNJ clï¿½rigo de cualquier templo.");
          return;
      }
      if(GetIsPC(oTarget) == TRUE)
      {
          SendMessageToPC(oPC, "El objetivo no debe ser un jugador. Debe ser un PNJ clï¿½rigo de cualquier templo.");
          return;
      }
      if(GetIsEnemy(oTarget, oPC) == TRUE)
      {
          SendMessageToPC(oPC, "El PNJ objetivo no debe ser hostil.");
          return;
      }
      if(GetLocalInt(oTarget, "RESUCITADOR") == 0)
      {
          SendMessageToPC(oPC, "Este PNJ no puede resucitar el cadï¿½ver. Busca un PNJ clï¿½rigo de cualquier templo.");
          return;
      }

      SetLocalObject(oPC, "CAD_USADO", oItem);
      AssignCommand(oPC, ClearAllActions(TRUE));
      AssignCommand(oPC, ActionStartConversation(oTarget, "pg_resucitar", TRUE, FALSE));
      return;
  }

  // INTIMIDACION SALVAJE
  if(sTagDelObjeto == "ms_hlis")
  {
      int iIntimidar = GetSkillRank(SKILL_INTIMIDATE, oPC);
      // Evitamos cualquier problema de calculo
      if(iIntimidar > 2)
      {
          float duracionMiedo = RoundsToSeconds(iIntimidar/2);
          int DCTotal;
          effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
          effect eFear = EffectFrightened();
          effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
          effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
          effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
          float fDelay;
          //Link the fear and mind effects
          effect eLink = EffectLinkEffects(eFear, eMind);
          eLink = EffectLinkEffects(eLink, eDur);

          object oTarget;
          //Apply Impact
          ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(oPC));
          //Get first target in the spell cone
          oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC), TRUE);

          while(GetIsObjectValid(oTarget))
          {
              if(GetIsEnemy(oPC, oTarget)==TRUE)
              {
                  if((GetRacialType(oTarget)==RACIAL_TYPE_ANIMAL)||
                     (GetRacialType(oTarget)==RACIAL_TYPE_BEAST)||
                     (GetRacialType(oTarget)==RACIAL_TYPE_VERMIN)||
                     (GetRacialType(oTarget)==RACIAL_TYPE_MAGICAL_BEAST))
                  {
                      fDelay = GetRandomDelay();
                      //Fire cast spell at event for the specified target
                      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));

                      //Asignamos una DC dependiendo del tipo de animal a ahuyentar
                      if(GetRacialType(oTarget)==RACIAL_TYPE_ANIMAL)
                      {
                          DCTotal= 10+ iIntimidar;
                      }

                      if(GetRacialType(oTarget)==RACIAL_TYPE_BEAST)
                      {
                          DCTotal= 10+ iIntimidar- 5;
                      }

                      if(GetRacialType(oTarget)==RACIAL_TYPE_VERMIN)
                      {
                          DCTotal= 10+ iIntimidar- 10;
                      }

                      if(GetRacialType(oTarget)==RACIAL_TYPE_MAGICAL_BEAST)
                      {
                          DCTotal= 10+ iIntimidar- 15;
                      }

                      if(!MySavingThrow(SAVING_THROW_WILL, oTarget, DCTotal, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
                      {
                          //Apply the linked effects and the VFX impact
                          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, duracionMiedo));
                      }
                  }
              }
              //Get next target in the spell cone
              oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC), TRUE);
          }
      }
      else
      {
          SendMessageToPC(oPC, "Debes tener 2 puntos de habilidad en Intimidar como mï¿½nimo para poder usar esta habilidad.");
          return;
      }
  }

  // TRANSFORMACIONES LICANTROPO/LYTHARI/DISCIPULO DRAGON
  else if(sTagDelObjeto == "ms_hldd")
  {
  if(nombrearea == "Mar de las Espadas"||nombrearea == "Mar Impenetrable")  //<- Modificacion de Nompho
     {
     SendMessageToPC(oPC, "¡No puedes transformar tu barco!");
     return;
     }
  int iAparienciaAGuardar = GetAppearanceType(oPC);
  int iAparienciaCambiada = ObtenerIntPersistente(oPC, "APA_CAMBIADA");
  int iAparienciaOriginal = ObtenerIntPersistente(oPC, "APA_MEMORIZADA");
  int iColaAGuardar = GetCreatureTailType(oPC);
  int iColaCambiada = ObtenerIntPersistente(oPC, "COLA_CAMBIADA");
  int iColaOriginal = ObtenerIntPersistente(oPC, "COLA_MEMORIZADA");
  int iAlturaOriginal = ObtenerIntPersistente(oPC, "CAB_ALTURA");
  float fAlturaOriginal;
  if (iAlturaOriginal == TRUE)
  {
      fAlturaOriginal = ObtenerFloatPersistente(oPC, "IND_ALTURA");
  }
  else
  {
      fAlturaOriginal =  GetObjectVisualTransform (oPC,OBJECT_VISUAL_TRANSFORM_SCALE);

  }


  int iFue = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_STRENGTH);
  int iDes = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_DEXTERITY);
  int iCon = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_CONSTITUTION);

  int iVidaActual = GetCurrentHitPoints(oPC);
  int iVidaMaxima = GetMaxHitPoints(oPC);
  int iPreReferenciaVida = (iVidaActual*100)/iVidaMaxima;

  if(iAparienciaCambiada == 0)
  {
      int iAparienciaCiatura;
      int iColaCriatura;
      int iEstadoLicantropia; // 0=Humanoide, 1=Hibrida, 2=Animal
      string sIndetidadHabilidad = GetStringRight(GetResRef(oItem), 2);
      if(sIndetidadHabilidad == "01") {iAparienciaCiatura = 184;  iEstadoLicantropia = 2;}// lobo blanco terrible
      else if(sIndetidadHabilidad == "02") {iAparienciaCiatura = 984; iEstadoLicantropia = 1;}// hombre-lobo rojo 1828 , 2829 cambiada a 984
      else if(sIndetidadHabilidad == "03") {iAparienciaCiatura = 983; iEstadoLicantropia = 1;}// hombre-lobo negro 1790, 2791 cambiada a 983
      else if(sIndetidadHabilidad == "04") {iAparienciaCiatura = 7487; iEstadoLicantropia = 1;}// hombre-lobo alpha blanco
      else if(sIndetidadHabilidad == "05") {iAparienciaCiatura = 988; iEstadoLicantropia = 1;}// hombre-lobo chaman hielo 1831, 2832 cambiada a 988
      else if(sIndetidadHabilidad == "06") {iAparienciaCiatura = 7486; iEstadoLicantropia = 1;}// hombre-lobo blanco 1530, 2531 cambia a 7486
      else if(sIndetidadHabilidad == "07") {iAparienciaCiatura = 987; iEstadoLicantropia = 1;}// hombre-lobo chaman 1826, 2827 cambia 987
      else if(sIndetidadHabilidad == "08") {iAparienciaCiatura = 171; iEstadoLicantropia = 1;}// hombre-lobo alpha negro 1833, 2837 cambia 171
      else if(sIndetidadHabilidad == "09") {iAparienciaCiatura = 7485; iEstadoLicantropia = 1;}// hombre-lobo chaman de fuego 1825, 2826 cambia a 7485
      else if(sIndetidadHabilidad == "10") {iAparienciaCiatura = 175; iEstadoLicantropia = 2;}// lobo terrible 1827
      else if(sIndetidadHabilidad == "11") {iAparienciaCiatura = 2033; iEstadoLicantropia = 1;}// semidragï¿½n rojo 1032
      else if(sIndetidadHabilidad == "16") {iAparienciaCiatura = 2787; iEstadoLicantropia = 1;}// hombre-jabali 1786
      else if(sIndetidadHabilidad == "17") {iAparienciaCiatura = 22; iEstadoLicantropia = 2;}  // jabali
      else if(sIndetidadHabilidad == "20") {iAparienciaCiatura = 2954; iEstadoLicantropia = 1;} // hombre-gato Gris 1953
      else if(sIndetidadHabilidad == "21") {iAparienciaCiatura = 2409; iEstadoLicantropia = 2;} // gato marron   1408
      else if(sIndetidadHabilidad == "22") {iAparienciaCiatura = 914; iEstadoLicantropia = 1;}   // hombre-gato negro 99
      else if(sIndetidadHabilidad == "23") {iAparienciaCiatura = 7520; iEstadoLicantropia = 2;} // gato negro  1406
      else if(sIndetidadHabilidad == "25") {iAparienciaCiatura = 170; iEstadoLicantropia = 1;} // hombre-rata con capucha
      else if(sIndetidadHabilidad == "26") {iAparienciaCiatura = 386; iEstadoLicantropia = 2;} // rata
      else if(sIndetidadHabilidad == "30") {iAparienciaCiatura = 986; iEstadoLicantropia = 1;}// hombre-lobo alpha rojo
      else if(sIndetidadHabilidad == "31") {iAparienciaCiatura = 2037; iEstadoLicantropia = 1;}// semidragï¿½n azul         1036
      else if(sIndetidadHabilidad == "32") {iAparienciaCiatura = 2039; iEstadoLicantropia = 1;}// semidragï¿½n negro        1038
      else if(sIndetidadHabilidad == "33") {iAparienciaCiatura = 2041; iEstadoLicantropia = 1;}// semidragï¿½n blanco       1040
      else if(sIndetidadHabilidad == "34") {iAparienciaCiatura = 2043; iEstadoLicantropia = 1;}// semidragï¿½n prismatico   1042
      else if(sIndetidadHabilidad == "35") {iAparienciaCiatura = 2070; iEstadoLicantropia = 1;}// semidragï¿½n dorado       1069
      else if(sIndetidadHabilidad == "36") {iAparienciaCiatura = 2071; iEstadoLicantropia = 1;}// semidragï¿½n plateado     1070
      else if(sIndetidadHabilidad == "37") {iAparienciaCiatura = 2079; iEstadoLicantropia = 1;}// semidragï¿½n de sombra    1078
      else if(sIndetidadHabilidad == "38") {iAparienciaCiatura = 2081; iEstadoLicantropia = 1;}// semidragï¿½n de laton     1080
      else if(sIndetidadHabilidad == "39") {iAparienciaCiatura = 2083; iEstadoLicantropia = 1;}// semidragï¿½n de bronce    1082
      else if(sIndetidadHabilidad == "40") {iAparienciaCiatura = 2085; iEstadoLicantropia = 1;}// semidragï¿½n de cobre     1084
      else if(sIndetidadHabilidad == "41") {iAparienciaCiatura = 2035; iEstadoLicantropia = 1;}// semidragï¿½n verde        1034
      else if(sIndetidadHabilidad == "44") {iAparienciaCiatura = 2410; iEstadoLicantropia = 2;}// Gato blanco             1409
      else if(sIndetidadHabilidad == "45") {iAparienciaCiatura = 1274; iEstadoLicantropia = 1;}// Mujer liche
      else if(sIndetidadHabilidad == "46") {iAparienciaCiatura = 1275; iEstadoLicantropia = 1;}// Mujer liche coronada
      else if(sIndetidadHabilidad == "48") {iAparienciaCiatura = 181;  iEstadoLicantropia = 2;}// lobo
      else if(sIndetidadHabilidad == "49") {iAparienciaCiatura = 913; iEstadoLicantropia = 1;} // hombre-rata
      else if(sIndetidadHabilidad == "50") {iAparienciaCiatura = 1308; iEstadoLicantropia = 2;} // lobo blanco
      else if(sIndetidadHabilidad == "52") {iAparienciaCiatura = 7479; iEstadoLicantropia = 1; iColaCriatura =10526; iColaCambiada=TRUE;}// hombre-lobo Alpha negro terrible
      else if(sIndetidadHabilidad == "53") {iAparienciaCiatura = 7480; iEstadoLicantropia = 1; iColaCriatura =10527; iColaCambiada=TRUE;}// hombre-lobo Alpha blanco terrible
      else if(sIndetidadHabilidad == "55") {iAparienciaCiatura = 1368; iEstadoLicantropia = 2;} // Lince
      else if(sIndetidadHabilidad == "56") {iAparienciaCiatura = 7488; iEstadoLicantropia = 1; iColaCriatura =10528; iColaCambiada=TRUE;}// hombre-lobo Alpha rojo terrible
      else if(sIndetidadHabilidad == "57") {iAparienciaCiatura = 7481; iEstadoLicantropia = 1; iColaCriatura =10525; iColaCambiada=TRUE;}// hombre-tiburon
      else if(sIndetidadHabilidad == "58") {iAparienciaCiatura = 7526; iEstadoLicantropia = 1;}   // hombre-gato negro antiguo

      // Efectos visuales, apariencia y variables
      effect eSuspiro = EffectVisualEffect(36);
      effect eLuz = EffectVisualEffect(146);
      effect eGritoGuerra = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eSuspiro , oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eLuz , oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eGritoGuerra, oPC);
      SetCreatureAppearanceType(oPC, iAparienciaCiatura);
      GuardarIntPersistente(oPC, "APA_CAMBIADA", 1);
      GuardarIntPersistente(oPC, "APA_MEMORIZADA", iAparienciaAGuardar);
      GuardarIntPersistente(oPC, "ESTADOLICANTROPIA", iEstadoLicantropia);

      if (iColaCambiada=TRUE)
        {
            SetCreatureTailType(iColaCriatura,oPC);
            GuardarIntPersistente(oPC, "COLA_CAMBIADA", TRUE);
            GuardarIntPersistente(oPC, "COLA_MEMORIZADA", iColaAGuardar);
        }
      // Dotes generales que se ganan
      if(GetHasFeat(FEAT_KNOCKDOWN, oPC) == FALSE) NWNX_Creature_AddFeat(oPC, FEAT_KNOCKDOWN);
      else GuardarIntPersistente(oPC, "DOTEDERRIBO", TRUE);
      if(GetHasFeat(FEAT_IMPROVED_INITIATIVE, oPC) == FALSE) NWNX_Creature_AddFeat(oPC, FEAT_IMPROVED_INITIATIVE);
      else GuardarIntPersistente(oPC, "DOTEINICIATIVA", TRUE);
      if(GetHasFeat(FEAT_IMPROVED_UNARMED_STRIKE, oPC) == FALSE) NWNX_Creature_AddFeat(oPC, FEAT_IMPROVED_UNARMED_STRIKE);
      else GuardarIntPersistente(oPC, "DOTEIMPACTOSAM", TRUE);

      // Inmovilizar 2 segundos y desequipar objetos de las manos y torso, si es necesario
      effect eDerribo = SupernaturalEffect(EffectKnockdown());
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDerribo, oPC, 2.0);
      if(iEstadoLicantropia >= 1)
      {
          DelayCommand(1.0, AssignCommand(oPC, ClearAllActions()));
          DelayCommand(1.1, DestruirCopiarArmaduraTransformacionesSubrazas(oPC));
          if(iEstadoLicantropia == 2) DelayCommand(1.1, DestruirCopiarObjetosManosTransformacionesSubrazas(oPC));
      }

      // LICANTROPOS
      if(GetStringLowerCase(GetSubRace(oPC)) == "licantropo")
      {
          if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "gato")
          {
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue - 4);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes + 6);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon + 2);
          }
          if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "jabali")
          {
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue + 4);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon + 6);
          }
          if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "lobo")
          {
              DelayCommand(0.5, AssignCommand(oPC, PlaySound("as_an_wolfhowl1")));
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue + 2);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes + 4);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon + 4);
          }
          if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "rata")
          {
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes + 6);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon + 2);
          }
      }

      // LYTHARIS
      else if(GetStringLowerCase(GetSubRace(oPC)) == "lythari")
      {
          NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue + 2);
          NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes + 4);
          NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon + 6);
          DelayCommand(0.5, AssignCommand(oPC, PlaySound("as_an_wolfhowl1")));
      }
      //Hacemos la apariencia de los lobos blancos terribles más grandes.
      if(sIndetidadHabilidad == "01")
      {
            //Modificación 19/01/2025 por Vara: Los lobos blancos se escalan para que sean mas acordes a un cambiante.
          SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fAlturaOriginal+0.40);
      }
      ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);
      // Aumentar su altura un 0.2%. + 0.2;
      //float fAlturaTransf = GetObjectVisualTransform(oPC,OBJECT_VISUAL_TRANSFORM_SCALE)+0.2;
      //SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fAlturaTransf);
      GuardarIntPersistente(oPC, "CAB_ALTURA", TRUE);
      GuardarFloatPersistente(oPC, "IND_ALTURA", fAlturaOriginal);
  }

  else
  {
      // Efectos visuales, apariencias y variables
      effect eSuspiro = EffectVisualEffect(36);
      effect eLuz = EffectVisualEffect(146);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eSuspiro , oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eLuz , oPC);
      SetCreatureAppearanceType(oPC, iAparienciaOriginal);
      SetCreatureTailType(iColaOriginal,oPC);
      GuardarIntPersistente(oPC, "APA_CAMBIADA", FALSE);
      GuardarIntPersistente(oPC, "APA_MEMORIZADA", FALSE);
      GuardarIntPersistente(oPC, "COLA_CAMBIADA", FALSE);
      GuardarIntPersistente(oPC, "COLA_MEMORIZADA", FALSE);

      if(ObtenerIntPersistente(oPC, "ALAS_CAMBIADAS") == TRUE)
      {
          SetCreatureWingType(ObtenerIntPersistente(oPC, "ALAS_MEMORIZADAS"), oPC);
          GuardarIntPersistente(oPC, "ALAS_CAMBIADAS", FALSE);
          GuardarIntPersistente(oPC, "ALAS_MEMORIZADAS", FALSE);
      }



      int EstadoLicantropiaActual = ObtenerIntPersistente(oPC, "ESTADOLICANTROPIA");
      if(EstadoLicantropiaActual == 0) {return;} //Humanoide

      GuardarIntPersistente(oPC, "ESTADOLICANTROPIA", 0);

      // Dotes generales que se pierden
      if(ObtenerIntPersistente(oPC, "DOTEDERRIBO") == FALSE) NWNX_Creature_RemoveFeat(oPC, FEAT_KNOCKDOWN);
      if(ObtenerIntPersistente(oPC, "DOTEINICIATIVA") == FALSE) NWNX_Creature_RemoveFeat(oPC, FEAT_IMPROVED_INITIATIVE);
      if(ObtenerIntPersistente(oPC, "DOTEIMPACTOSAM") == FALSE) NWNX_Creature_RemoveFeat(oPC, FEAT_IMPROVED_UNARMED_STRIKE);

      // LICANTROPOS
      if(GetStringLowerCase(GetSubRace(oPC)) == "licantropo")
      {
          if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "gato")
          {
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue + 4);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes - 6);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 2);
          }
          if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "jabali")
          {
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue - 4);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 6);
          }
          if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "lobo")
          {
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue - 2);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes - 4);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 4);
          }
          if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "rata")
          {
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes - 6);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 2);
          }
      }

      // LYTHARIS
      else if(GetStringLowerCase(GetSubRace(oPC)) == "lythari")
      {
          NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue - 2);
          NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes - 4);
          NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 6);
      }

      ReaplicarEfectosPB(oPC, TRUE, FALSE, TRUE);
      //Devolver su altura original
      SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fAlturaOriginal);
  }

  // Bug de la constitucion
  int iVidaActual2 = GetCurrentHitPoints(oPC);
  int iVidaMaxima2 = GetMaxHitPoints(oPC);
  int iPostReferenciaVida = (iVidaActual2*100)/iVidaMaxima2;
  int iDiferenciaVida = iPreReferenciaVida - iPostReferenciaVida;
  if(iDiferenciaVida > 0) // Debo sanarme
  {
      int iPuntosSanacion = (iDiferenciaVida*iVidaActual2)/iPostReferenciaVida;
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(iPuntosSanacion), oPC);
  }
  else if(iDiferenciaVida < 0) // Debo danyarme
  {
      int iPuntosDanyo = (abs(iDiferenciaVida)*iVidaActual2)/iPostReferenciaVida;
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iPuntosDanyo), oPC);
  }

  }

  // VARITAS DMFI
  else if(GetStringLeft(sTagDelObjeto, 5) == "dmfi_")
  {
      ExecuteScript("dmfi_activate",oPC);
      return;
  }

  // IDIOMAS 1.69
  else if(GetStringLeft(sTagDelObjeto, 8) == "hlslang_")  ExecuteScript("pjr_activate", OBJECT_SELF);

  // VARITA METEO
  else if(sTagDelObjeto == "brouillard")
  {
      AssignCommand(oPC,ActionStartConversation(oPC,"meteo",TRUE,FALSE));
      SetLocalLocation(oPC,"location meteo",GetItemActivatedTargetLocation());
      return;
  }

  // VARITA Stage Manager
  else if(sTagDelObjeto == "mali_dm_stage") {ExecuteScript("mali_dm_stage", OBJECT_SELF); return;}

  // VARITA Placeable Attitude Adjuster
  else if(sTagDelObjeto == "Mali_DM_PAA") {ExecuteScript("mali_dm_paa", OBJECT_SELF); return;}

  // VARITA Encounter Spawn
  else if(sTagDelObjeto == "mali_enc") {ExecuteScript("mali_enc", OBJECT_SELF); return;}

  // VARITA Encounter Spawn (Objeto portatil)
  else if(sTagDelObjeto == "mali_mcs") {ExecuteScript("mali_mcs", OBJECT_SELF); return;}

  // VARITA Encounter Ditto
  else if(sTagDelObjeto == "mali_enc_ditto") {ExecuteScript("mali_enc_ditto", OBJECT_SELF); return;}

  // VARITA de Musica
  else if(sTagDelObjeto == "sly_musicwand") {AssignCommand(oPC, ActionStartConversation(oPC, "sly_music_conv", TRUE, FALSE)); return;}

  // TIENDAS DE JUGADORES
  else if(sTagDelObjeto == "tj_tienda")
  {
      if(nombrearea == "Mar de las Espadas"||nombrearea == "Mar Impenetrable")  //<- Modificacion de Nompho
      {
          SendMessageToPC(oPC, "¡No puedes montar la tienda en el barco!");
          return;
      }

      location lPC = GetLocation(oPC);
      location lTienda = GetLocalLocation(oPC, "TJLUGARPC");
      float fDistancia = GetDistanceBetweenLocations(lPC, lTienda);

      if(GetLocalInt(oPC, "TJACTIVADA") == 1)
      {
          if(fDistancia >= 0.0 && fDistancia <= 4.0)
          {
              AssignCommand(oPC, ClearAllActions(TRUE));
              AssignCommand(oPC, ActionJumpToLocation(lTienda));
              return;
          }
          else
          {
              FloatingTextStringOnCreature("*¡No puedes entrar en tu tienda desde tan lejos!*", oPC, FALSE);
              return;
          }
      }

      if(VerSiHayEnemigosEnRango(oPC, 30.0) == TRUE)
      {
          FloatingTextStringOnCreature("*¡No puedes montar una tienda mientras haya enemigos cerca!*", oPC, FALSE);
          return;
      }

      if(GetIsInCombat(oPC) == TRUE)
      {
          FloatingTextStringOnCreature("*¡No puedes montar una tienda mientras estés en combate!*", oPC, FALSE);
          return;
      }

      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.0));
      string sIdentidad = GetName(oPC, TRUE) + GetPCPublicCDKey(oPC);

      object oMostrador = CreateObject(OBJECT_TYPE_PLACEABLE, "tj_mostrador", PosicionMostrador(oPC));
      SetName(oMostrador, "Puesto de venta de " + PB_Disguise_GetNameOverride(oPC));
      SetLocalString(oMostrador, "TJIDENTIDAD", sIdentidad);

      object oCartelDer = CreateObject(OBJECT_TYPE_PLACEABLE, "tj_cartel", PosicionCartel(oPC));
      SetName(oCartelDer, "¡Bienvenidos a la tienda de " + PB_Disguise_GetNameOverride(oPC) + "!");
      SetLocalString(oCartelDer, "TJIDENTIDAD", sIdentidad);

      object oCajaIzq = CreateObject(OBJECT_TYPE_PLACEABLE, "tj_vasijas", PosicionCajaIzq(oPC));
      object oCajaPequenyaDer = CreateObject(OBJECT_TYPE_PLACEABLE, "tj_cpeq", PosicionCajaPequenyaDerecha(oPC));
      object oBarrilDer = CreateObject(OBJECT_TYPE_PLACEABLE, "tj_barril", PosicionBarril(oPC));
      object oVallaIzq = CreateObject(OBJECT_TYPE_PLACEABLE, "tj_valla1", PosicionVallaIzq(oPC));
      object oVallaDer = CreateObject(OBJECT_TYPE_PLACEABLE, "tj_valla1", PosicionVallaDer(oPC));

      SetLocalObject(oPC, "TJUBICADO1", oMostrador);
      SetLocalObject(oPC, "TJUBICADO2", oCartelDer);
      SetLocalObject(oPC, "TJUBICADO3", oCajaIzq);
      SetLocalObject(oPC, "TJUBICADO4", oCajaPequenyaDer);
      SetLocalObject(oPC, "TJUBICADO5", oBarrilDer);
      SetLocalObject(oPC, "TJUBICADO6", oVallaIzq);
      SetLocalObject(oPC, "TJUBICADO7", oVallaDer);
      SetLocalLocation(oPC, "TJLUGARPC", GetLocation(oPC));
      SetLocalLocation(oPC, "TJLUGARMOSTRADOR", PosicionMostrador(oPC));
      SetLocalInt(oPC, "TJACTIVADA", 1);
  }

  // YESCA Y PEDERNAL
  else if(sTagDelObjeto == "HC_Tinderbox")
  {
    if(GetIsAreaInterior(GetArea(oPC)) == TRUE)
    {
        SendMessageToPC(oPC, "¡No puedes encender una hoguera en areas de interior!");
        return;
    }

    SendMessageToPC(oPC, "Haces una pequeña fogata.");
    DelayCommand(0.1, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,5.0)));
    float fDir = GetFacing(oPC);
    object oFogata = CreateObject(OBJECT_TYPE_PLACEABLE,"campfr001", GenerateNewLocation(oPC, 1.7, fDir, fDir + 180.0));
    DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_20),oFogata));
    return;
  }

  // ELIXIRES
  else if(sTagDelObjeto == "uki_bebidaadelg") {ExecuteScript("uki_bebidaadelg", OBJECT_SELF); return;}
  else if(sTagDelObjeto == "uki_bebidaarbol") {ExecuteScript("uki_bebidaarbol", OBJECT_SELF); return;}
  else if(sTagDelObjeto == "uki_bebidaengor") {ExecuteScript("uki_bebidaengor", OBJECT_SELF); return;}
  else if(sTagDelObjeto == "uki_bebidalucha") {ExecuteScript("uki_bebidalucha", OBJECT_SELF); return;}
  else if(sTagDelObjeto == "uki_bebidarisa") {ExecuteScript("uki_bebidarisa", OBJECT_SELF); return;}
  else if(sTagDelObjeto == "uki_bebidasueno") {ExecuteScript("uki_bebidasueno", OBJECT_SELF); return;}
  else if(sTagDelObjeto == "uki_bebidaverdad") {ExecuteScript("uki_bebidaverdad", OBJECT_SELF); return;}

  // LLAMAR AL PASTOR DE ARBOLES
  else if(sTagDelObjeto == "entdeguerra") ExecuteScript("inv_entguerra", oPC);

  // SIDRA DE PERA
  else if(sTagDelObjeto == "SidradePera")
  {
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Sidra de Pera"))
    {
        TimelockErrorMessage(oPC, "Sidra de Pera");
        CreateItemOnObject(sTagDelObjeto, oPC, 1);
        return;
    }
      FloatingTextStringOnCreature("*Glup*", oPC);
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oPC);

      if(GetLocalInt(GetModule(), "SIDRAPERA" + GetName(oPC, TRUE)) == 0)
      {
          //No apilamos efectos que ya mete el acelerar, si tenemos estos conjuros activos.
          if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oPC) == FALSE && GetHasSpellEffect(647, oPC) == FALSE && GetHasSpellEffect(78, oPC) == FALSE && GetHasSpellEffect(113, oPC) == FALSE)
          {
            effect eSpeed = EffectMovementSpeedIncrease(30);
            effect eAtaques = EffectModifyAttacks(1);
            effect eLink = EffectLinkEffects(eLink, eSpeed);
                   eLink = EffectLinkEffects(eLink, eAtaques);
                   eLink = TagEffect(eLink, "POCION_SIDRAPERA");
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 60.0);
          }
          //Resto de efectos, sí que se añaden.
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(d20() + 10), oPC);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectRegenerate(2, 6.0), oPC, 60.0);

          SetLocalInt(GetModule(), "SIDRAPERA" + GetName(oPC, TRUE), 1);
          SetTimelock(oPC, 10, "Sidra de Pera", 0, 0);
          DelayCommand(60.0, DeleteLocalInt(GetModule(), "SIDRAPERA" + GetName(oPC, TRUE)));
      }

      return;
  }

  // SIDRA DE MANZANA
  else if(sTagDelObjeto == "SidradeManzana")
  {
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Sidra de Manzana"))
    {
        TimelockErrorMessage(oPC, "Sidra de Manzana");
        CreateItemOnObject(sTagDelObjeto, oPC, 1);
        return;
    }
      FloatingTextStringOnCreature("*Glup*", oPC);
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC);

      if (GetLocalInt(GetModule(), "SIDRAMANZANA" + GetName(oPC, TRUE)) == 0)
      {
          // Elimina veneno
          int iSalirBucle = FALSE;
          effect eVeneno = GetFirstEffect(oPC);
          while(GetIsEffectValid(eVeneno) && iSalirBucle == FALSE)
          {
              if(GetEffectType(eVeneno) == EFFECT_TYPE_POISON)
              {
                  RemoveEffect(oPC, eVeneno);
                  iSalirBucle = TRUE;
              }

              eVeneno = GetNextEffect(oPC);
          }

          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(d10() + 8), oPC);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(10), oPC, 60.0);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(d2()), oPC, 60.0);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(d2(), DAMAGE_TYPE_MAGICAL), oPC, 60.0);
          SetLocalInt(GetModule(), "SIDRAMANZANA" + GetName(oPC, TRUE), 1);
          SetTimelock(oPC, 10, "Sidra de Manzana", 0, 0);
          DelayCommand(60.0, DeleteLocalInt(GetModule(), "SIDRAMANZANA" + GetName(oPC, TRUE)));
      }

      return;
  }

  // VINOS PURSKUL: COSECHA DEL 1.300
  else if(sTagDelObjeto == "vinopurskulcosex")
  {
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Vino cosecha 1300"))
    {
        TimelockErrorMessage(oPC, "Vino cosecha 1300");
        CreateItemOnObject(sTagDelObjeto, oPC, 1);
        return;
    }
      FloatingTextStringOnCreature("*Eructo*", oPC);
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oPC);

      if(GetLocalInt(GetModule(), "VINOCOSEXA" + GetName(oPC, TRUE)) == 0)
      {
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(d20() + 10), oPC);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_INTELLIGENCE, 1), oPC, 60.0);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(2), oPC, 60.0);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectConcealment(20), oPC, 60.0);
          SetLocalInt(GetModule(), "VINOCOSEXA" + GetName(oPC, TRUE), 1);
          SetTimelock(oPC, 10, "Vino cosecha 1300", 0, 0);
          DelayCommand(60.0, DeleteLocalInt(GetModule(), "VINOCOSEXA" + GetName(oPC, TRUE)));
      }

      return;
  }

  // VINOS PURSKUL: LA ESPECIALIDAD DE PURSKUL
  else if(sTagDelObjeto == "vinopurskul")
  {
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Vino Especialiadad de Purskul"))
    {
        TimelockErrorMessage(oPC, "Vino Especialiadad de Purskul");
        CreateItemOnObject(sTagDelObjeto, oPC, 1);
        return;
    }
      FloatingTextStringOnCreature("*Eructo*", oPC);
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oPC);

      if(GetLocalInt(GetModule(), "VINOESPECIALIDAD" + GetName(oPC, TRUE)) == 0)
      {
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(d20() + 10), oPC);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_INTELLIGENCE, 1), oPC, 60.0);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(2), oPC, 60.0);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(5), oPC, 60.0);
          SetLocalInt(GetModule(), "VINOESPECIALIDAD" + GetName(oPC, TRUE), 1);
          SetTimelock(oPC, 10, "Vino Especialiadad de Purskul", 0, 0);
          DelayCommand(60.0, DeleteLocalInt(GetModule(), "VINOESPECIALIDAD" + GetName(oPC, TRUE)));
      }

      return;
  }

  // VINOS PURSKUL: LOCURA DEL CAMPESINADO
  else if(sTagDelObjeto == "vinopurskulocura")
  {
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Vino locura del camepsinado"))
    {
        TimelockErrorMessage(oPC, "Vino locura del camepsinado");
        CreateItemOnObject(sTagDelObjeto, oPC, 1);
        return;
    }
      FloatingTextStringOnCreature("*Eructo*", oPC);
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oPC);

      if(GetLocalInt(GetModule(), "VINOLOCURA" + GetName(oPC, TRUE)) == 0)
      {
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(d20() + 10), oPC);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_INTELLIGENCE, 1), oPC, 60.0);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(15), oPC, 60.0);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectRegenerate(4,10.0), oPC, 60.0);
          SetLocalInt(GetModule(), "VINOLOCURA" + GetName(oPC, TRUE), 1);
          SetTimelock(oPC, 10, "Vino locura del camepsinado", 0, 0);
          DelayCommand(60.0, DeleteLocalInt(GetModule(), "VINOLOCURA" + GetName(oPC, TRUE)));
      }

      return;
  }

  // LEVITAR DE LOS DROWS
  else if(sTagDelObjeto == "levitar")
  {
      // No funciona montado en montura
      if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
      {
          FloatingTextStringOnCreature(StringToRGBString("* Esta aptitud no se puede activar montado en montura *","700"), oPC, FALSE);
          return;
      }

      //Guardamos el fenotipo
      int eFenotipo = GetPhenoType(oPC);

      if(oTarget == oPC)
      {
          if(ObtenerIntPersistente(oPC, "LEVITAR") == FALSE)
          {
              GuardarIntPersistente(oPC, "LEVITAR", TRUE);
              //zep_Fly(oPC);
              string sText = "modo flying";
              Q_ACPCheckChat(oPC, sText);
              return;
          }
          else
          {
              GuardarIntPersistente(oPC, "LEVITAR", FALSE);
              //zep_Dismount(oPC);
              string sText = "modo normal";
              Q_ACPCheckChat(oPC, sText);
              return;
          }
      }
      else
      {
          if(ObtenerIntPersistente(oPC, "LEVITAR") == FALSE)
          {
              SendMessageToPC(oPC, "Clickea antes sobre ti mismo para empezar a levitar.");
              return;
          }

          int iUsos = GetLocalInt(oPC, "LEVITARUSOS");
          if(iUsos == 5)
          {
              SendMessageToPC(oPC, "Esta habilidad esta limitada a 5 'saltos'. Por favor descansa para volver a usarla.");
              return;
          }

          SetLocalInt(oPC, "LEVITARUSOS", iUsos + 1);

          SetImmortal(oPC, TRUE);
          DelayCommand(4.2, SetImmortal(oPC, FALSE));

          effect eVolar = EffectDisappearAppear(lLocation);
          DelayCommand(2.5, FadeToBlack(oPC, FADE_SPEED_FASTEST));
          DelayCommand(4.2, FadeFromBlack(oPC, FADE_SPEED_FASTEST));
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVolar, oPC, 4.0);
          return;
      }
  }

  // VARA DE SEGURIDAD
  else if(sTagDelObjeto == "pb_seg")
  {
      if(GetIsDM(oPC) == FALSE && GetIsDMPossessed(oPC) == FALSE)
      {
          SendMessageToPC(oPC, StringToRGBString("Solo los DMs pueden usar esta varita.","700"));
          DestroyObject(oItem);
          return;
      }

      if(GetIsPC(oTarget) == FALSE)
      {
          SendMessageToPC(oPC, StringToRGBString("<Solo se puede usar la varita sobre PJs.","700"));
          return;
      }

     SetLocalObject(oPC, "SEG_JUGADOR", oTarget);
     AssignCommand(oPC,ActionStartConversation(oPC, "seg", TRUE, FALSE));
     return;
  }

  // VARITA DE APARIENCIAS
  else if(sTagDelObjeto == "sf_wingwand")
  {
      if(GetIsDM(oPC) != TRUE && GetIsDMPossessed(oPC) != TRUE)
      {
          SendMessageToPC(oPC, "¡No puedes usar este objeto!");
          DestroyObject(oItem);
          return;
      }

      if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
      {
          SendMessageToPC(oPC, "*¡Activa la varita en una criatura leches!*");
          return;
      }

      SetLocalObject(oPC, "VCA_OBJETIVO", oTarget);
      AssignCommand(oPC,ActionStartConversation(oPC, "sf_wings", TRUE, FALSE));
      return;
  }

  // CUERDA
  else if(sTagDelObjeto == "gz_it_rope") CuerdasTrepar();

  // VARITA MULTI-DESBLOQUEOS
  else if(sTagDelObjeto == "mti_desbloqueos")
  {
     if(GetIsDM(oPC) == FALSE && GetIsDMPossessed(oPC) == FALSE)
     {
         SendMessageToPC(oPC, "¡No puedes usar este objeto!");
         DestroyObject(oItem);
         return;
     }

     if(GetIsPC(oTarget) != TRUE)
     {
         SendMessageToPC(oPC, "¡Activa la varita en un jugador joder!");
         return;
     }

      SetLocalObject(oPC, "VJDM_OBJETIVO", oTarget);
      AssignCommand(oPC,ActionStartConversation(oPC, "mti_desbloqueos", TRUE, FALSE));
      return;
  }

  // OBJETOS DE DOMINIO
  else if(GetStringLeft(sTagDelObjeto, 8) == "dominio_")
  {
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, ActionCastSpellAtObject(GetLocalInt(oItem, "CONJURO"), oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
      return;
  }

  // VARITA ACTIVADORA DE SUBRAZA 'DROW DE SUPERFICIE'
  else if(sTagDelObjeto == "act_drow_spf")
  {
      string sSubraza = GetStringLowerCase(GetSubRace(oTarget));
      if(sSubraza != "drow" || ObtenerIntPersistente(oTarget, "DROWSUPERFICIE") == 1)
      {
          SendMessageToPC(oPC, "Objetivo no vï¿½lido. No tiene subraza drow o bien ya es drow de superficie.");
          return;
      }

      GuardarIntPersistente(oTarget, "DROWSUPERFICIE", 1);
      FloatingTextStringOnCreature(ColorTexto("Un DM te ha otorgado el don de ser un drow de superficie.", TXT_COLOR_CELESTE), oTarget, FALSE);
      SendMessageToPC(oPC, "Le has otorgado a " + GetName(oTarget, TRUE) + " el don de ser drow de superficie.");
      return;
  }

  // PERGAMINO DE DESEO
  else if(sTagDelObjeto == "pergaminodedeseo")
  {
      effect eVisual1 = EffectVisualEffect(VFX_FNF_METEOR_SWARM);
      effect eVisual2 = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
      effect eVisual3 = EffectVisualEffect(VFX_FNF_FIRESTORM);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisual1, GetLocation(oPC));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisual2, GetLocation(oPC));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisual3, GetLocation(oPC));
      CreateObject(OBJECT_TYPE_CREATURE, "deseos_ifriti", GetLocation(oPC), TRUE);
      return;
  }

  // BEBIDAS QUE NO QUITAN SED
else if(sTagDelObjeto == "bebidanosed" || sTagDelObjeto == "bebidanosed2")
  {
      AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
      FloatingTextStringOnCreature("*Glup*", oPC);
      DelayCommand(1.0, SendMessageToPC(oPC, "*Bebes un poco*"));

      if(sTagDelObjeto == "bebidanosed2")
      {
          effect eDanyo = EffectDamage(d2());
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eDanyo, oPC);
      }
      else
      {
          effect eCurar = EffectHeal(d4());
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eCurar, oPC);
      }
      return;
  }

  // ORBE CATASTROFICO UKIAH
  else if(sTagDelObjeto == "orbecatastrofico")
  {
      effect e1 = EffectVisualEffect(VFX_IMP_DEATH_L);
      effect e2 = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
      effect e3 = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);
      effect e4 = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
      effect eK = EffectKnockdown();
      effect eM = EffectCurse(4,4,1,4,4,4);

      DelayCommand(1.0, SetCutsceneMode(oPC, TRUE));
      SetXP(oPC, GetXP(oPC) - 10000);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eK, oPC, 8.0);
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e4, oPC));
      DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e2, oPC));
      DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e1, oPC));
      DelayCommand(4.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, e2, oPC));
      DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e2, oPC));

      int iAhora = GetCurrentHitPoints(oPC);
      effect eDano = EffectDamage(iAhora - 20, DAMAGE_TYPE_MAGICAL);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDano, oPC);

      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eM, oPC);

      DelayCommand(8.0, SetCutsceneMode(oPC, FALSE));
      return;
  }

  // CIENLUCES UKIAH
else if(sTagDelObjeto == "cienluces")
  {
      effect ex1 = EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION);
      effect ex2 = EffectVisualEffect(VFX_FNF_FIREBALL);
      effect ex3 = EffectVisualEffect(VFX_FNF_ICESTORM);
      effect ex4 = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
      effect ex5 = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
      effect ex6 = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);

      SetCutsceneMode(oPC,TRUE);

      ApplyEffectToObject(DURATION_TYPE_INSTANT, ex4, oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, ex5, oPC);
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, ex1, oPC));
      DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, ex2, oPC));
      DelayCommand(0.7, ApplyEffectToObject(DURATION_TYPE_INSTANT, ex3, oPC));
      DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, ex6, oPC));

      DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, ex1, oPC));
      DelayCommand(2.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, ex2, oPC));
      DelayCommand(2.7, ApplyEffectToObject(DURATION_TYPE_INSTANT, ex3, oPC));
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, ex4, oPC));
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, ex5, oPC));
      DelayCommand(2.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, ex6, oPC));

      DelayCommand(5.5, SetCutsceneMode(oPC,FALSE));
      return;
  }

  // CIENLUCES IGNEO UKIAH
else if(sTagDelObjeto == "cienluigneo")
  {
      effect ex1 = EffectVisualEffect(VFX_FNF_FIRESTORM);
      effect ex2 = EffectVisualEffect(VFX_FNF_METEOR_SWARM);
      effect ex3 = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE);
      effect ex4 = EffectVisualEffect(VFX_FNF_UNDEAD_DRAGON);
      effect ex5 = EffectVisualEffect(VFX_COM_HIT_FIRE);
      effect ex6 = EffectVisualEffect(VFX_FNF_FIREBALL);
      effect aoe1 = EffectAreaOfEffect(AOE_PER_FOGFIRE,"*","*","*");

      SetCutsceneMode(oPC,TRUE);
      DelayCommand(4.0,SetCutsceneMode(oPC,FALSE));

      ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,aoe1,GetLocation(oPC),6.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex4,oPC,2.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex5,oPC,2.0);
      DelayCommand(0.3,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex6,oPC,2.0));
      DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex1,oPC,2.0));
      DelayCommand(0.6,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex2,oPC,2.0));
      DelayCommand(0.7,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex3,oPC,2.0));
      DelayCommand(0.9,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex6,oPC,2.0));
      DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex6,oPC,2.0));
      DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex5,oPC,2.0));
      DelayCommand(2.3,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex6,oPC,2.0));
      DelayCommand(2.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex1,oPC,2.0));
      DelayCommand(2.6,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex2,oPC,2.0));
      DelayCommand(2.7,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex3,oPC,2.0));
      DelayCommand(2.8,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ex6,oPC,2.0));
   }

  // ELEGIR FOCO DIVINO
  else if(sTagDelObjeto == "mti_elegfoco")
  {
      int iObjetoBaseObjetivo = GetBaseItemType(oTarget);
      if(iObjetoBaseObjetivo == BASE_ITEM_HELMET ||
         iObjetoBaseObjetivo == BASE_ITEM_CLOAK ||
         iObjetoBaseObjetivo == BASE_ITEM_GLOVES ||
         iObjetoBaseObjetivo == BASE_ITEM_BRACER ||
         iObjetoBaseObjetivo == BASE_ITEM_TORCH ||
         iObjetoBaseObjetivo == BASE_ITEM_AMULET ||
         iObjetoBaseObjetivo == BASE_ITEM_RING ||
         iObjetoBaseObjetivo == BASE_ITEM_ARMOR ||
         iObjetoBaseObjetivo == BASE_ITEM_BELT)
      {
          SendMessageToPC(oPC, StringToRGBString("Ahora tu foco divino personalizado elegido es: " + GetName(oTarget) + ".","070"));
          GuardarStringPersistente(oPC, "FOCODIVINO", GetName(oTarget));
      }
      else SendMessageToPC(oPC, StringToRGBString("El objetivo tomado no puede ser un foco divino! Por favor, toma como objetivo otro objeto base válido.","700"));


      return;
  }

  // TIENDA DE CAMPANYA
  else if(sTagDelObjeto == "tienda_camp")
  {
  if(nombrearea == "Mar de las Espadas"||nombrearea == "Mar Impenetrable")  //<- Modificacion de Nompho
     {
     SendMessageToPC(oPC, "¡No puedes montar la tienda en plano mar!");
     return;
     }
      if(GetLocalInt(oPC, "MONTANDOTIENDA") == 1)
      {
          FloatingTextStringOnCreature("*¡Ya estás montando una tienda!*", oPC, FALSE);
          return;
      }

      if(GetIsAreaNatural(GetArea(oPC)) == AREA_ARTIFICIAL)
      {
          FloatingTextStringOnCreature("¡Solo puedes montar una tienda en ï¿½reas naturales!", oPC);
          return;
      }

      if(GetDistanceBetweenLocations(GetLocation(oPC), lLocation) > 3.0)
      {
          FloatingTextStringOnCreature("*Necesitas acercarte mï¿½s*", oPC);
          return;
      }

      effect eImmobilizado = EffectCutsceneImmobilize();
      float fDuracion = 24.0;
      SetLocalInt(oPC, "MONTANDOTIENDA", 1);
      DelayCommand(fDuracion, DeleteLocalInt(oPC, "MONTANDOTIENDA"));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmobilizado, oPC, fDuracion);
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 23.0));
      FloatingTextStringOnCreature("*Montando la tienda de campaña*", oPC);
      DelayCommand(2.0, FloatingTextStringOnCreature("*Montar esta tienda te llevará 4 asaltos*", oPC));
      DelayCommand(fDuracion, FloatingTextStringOnCreature("*Tienda montada*", oPC));
      DestroyObject(oItem, 22.0);
      DelayCommand(22.0, CreateObjectVoid(OBJECT_TYPE_PLACEABLE, "tienda_aventurer", lLocation));
      return;
}

  // BOMBA DE HUMO/ESCONDERSE A SIMPLE VISTA
  else if(sTagDelObjeto == "bola_ladron")
  {
    int iRogueLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
    int iShadLevel = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC);
    int iAssaLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
    int iHarpLevel = GetLevelByClass(CLASS_TYPE_HARPER, oPC);

    if (iRogueLevel > 0 || iShadLevel > 0 || iAssaLevel > 0 || iHarpLevel > 0)
    {
        object oTarget;
        effect eBlind = EffectBlindness();
        effect eInvisivilidad = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
        effect eOcultacion = EffectConcealment(80);
        location lPC = GetLocation(oPC);
        string sResref = GetResRef(oItem);
        effect ePolvo = EffectVisualEffect(460);
        effect eNubes = EffectAreaOfEffect(39, "****", "****", "****");

        // Animacion de lanzamiento
        PlayVoiceChat(VOICE_CHAT_GOODBYE, oPC);
        DelayCommand(1.0, PlayVoiceChat(VOICE_CHAT_LAUGH, oPC));
        AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_STEAL));
        // Aplicar efecto en el área alrededor del objeto activador
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eNubes, lPC, 12.0f);
        DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePolvo, lPC));

        //Get the first target in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lPC);
        while (GetIsObjectValid(oTarget))
        {
            //Efecto de ceguera sin CD
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, 4.0f);
            //Get the next target in the spell area
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lPC);
        }
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvisivilidad, oPC, 10.0f);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOcultacion, oPC, 10.0f);
        DelayCommand(3.0f, SetActionMode(oPC, ACTION_MODE_STEALTH, TRUE));
        return;
    }else{
        SendMessageToPC(oPC, "No posees conocimientos para usar este artilugio.");
        return;
    }
  }

  // LLAMAR A LOS SIERVOS DEL HUESO
  else if(sTagDelObjeto == "siervosdehueso")
  {
    effect eSum = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
    effect eImplosion = EffectVisualEffect(VFX_FNF_IMPLOSION);
    effect eNiebla = EffectVisualEffect(1);
    object oPolvo = GetItemPossessedBy(oPC,"basura_urna");

    if(GetHasFeat(399, oPC) && iCasterLevel >= 13)
    {
        if(oPolvo == OBJECT_INVALID)
        {
            SendMessageToPC(oPC,"¡Necesitas una urna llena de cenizas para hacer eso!");
            return;
        }
        else
        {
            SetCommandable(FALSE,oPC);
            AssignCommand(oPC,ActionSpeakString("¡Acudid a mi, Hijos del Hueso!¡Ihiuvag Dinvath!"));
            SendMessageToPC(oPC,"Invocacion");
            AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1,2.0,2.0));

            DelayCommand(2.0,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eNiebla,lLocation,4.0));
            DelayCommand(1.5,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eImplosion,lLocation));

            DelayCommand(3.5,AddHenchman(oPC,CreateObject(OBJECT_TYPE_CREATURE,"guerreroesque3",lLocation)));
            DelayCommand(3.5,AddHenchman(oPC,CreateObject(OBJECT_TYPE_CREATURE,"guerreroesque1",lLocation)));
            DelayCommand(3.5,AddHenchman(oPC,CreateObject(OBJECT_TYPE_CREATURE,"guerreroesque2",lLocation)));
            DelayCommand(3.5,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eSum,lLocation));
            DelayCommand(4.0,SetCommandable(TRUE,oPC));
            DestroyObject(oPolvo);

        }
    }else{
        // Sin Soltura y sin niveles
        SendMessageToPC(oPC,"No posees conocimientos suficientes realizar este hechizo.");
        return;
    }
  }

  // POLVO HELADO DE UKIAH
  else if(sTagDelObjeto == "polvohelado")
  {
      if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
      {
          itemproperty iFrio = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,1);
          IPSafeAddItemProperty(oTarget,iFrio,300.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
          AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_COLD),oTarget,300.0);
      }

      else
      {
          FloatingTextStringOnCreature("¡No puedes usar eso ahi!",oPC);
      }
  }

  // POLVO ELECTRIZANTE DE UKIAH
else if(sTagDelObjeto == "polvoelectrizante")
  {
      if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
      {
          itemproperty iElectrico = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL,1);
          IPSafeAddItemProperty(oTarget,iElectrico,300.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
          AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_ELECTRICAL),oTarget,300.0);
      }

      else
      {
          FloatingTextStringOnCreature("¡No puedes usar eso ahi!",oPC);
      }
  }

  // POLVO ARDIENTE DE UKIAH
else if(sTagDelObjeto == "polvoardiente")
  {
      if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
      {
          itemproperty iFire = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,1);
          IPSafeAddItemProperty(oTarget,iFire,300.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
          AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_FIRE),oTarget,300.0);
      }

      else
      {
          FloatingTextStringOnCreature("¡No puedes usar eso ahi!",oPC);
      }
  }

  // VARITA DM DE AVERIGUAR DEIDAD
  else if(GetTag(oItem) == "varitadeidad")
  {
      string sDios = GetDeity(oTarget);
      string sNombre = GetName(oTarget, TRUE);

      if(sDios == "")
      {
          SendMessageToAllDMs(sNombre + " no tiene deidad.");
          return;
      }
      else
      {
          SendMessageToAllDMs("La deidad de " + sNombre + " es "+ sDios + ".");
          return;
      }
  }

  // JUEGO SUCIO
  if(sTagDelObjeto == "juegosucio")
  {
    // No funciona montado en montura
    if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
    {
        FloatingTextStringOnCreature(StringToRGBString("* Esta aptitud no se puede activar montado en montura *","700"), oPC, FALSE);
        return;
    }
    int iRogueLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
    int iAssaLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
    if (iRogueLevel >= 4 || iAssaLevel >= 1)
    {
        float fDistancia = GetDistanceBetween(oTarget,oPC);
        if(fDistancia > 5.0)
        {
            FloatingTextStringOnCreature(StringToRGBString("* Necesitas acercarte mas para tirarle el polvo *","700"), oPC, FALSE);
            return;
        }

        int iDC = GetSkillRank(SKILL_PICK_POCKET, oPC,FALSE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), oTarget, 6.0);

        object oPolvo = GetItemPossessedBy(oPC,"_polvo");
        if(oPolvo == OBJECT_INVALID)
        {
            iDC = iDC + 5;
            DestroyObject(oPolvo);
        }

        object oCasco = GetItemInSlot(INVENTORY_SLOT_HEAD,oTarget);
        if(oCasco == OBJECT_INVALID)
        {
            iDC = iDC + 5;
        }

        if(ReflexSave(oTarget,iDC,SAVING_THROW_TYPE_TRAP,oPC) == 0)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectBlindness(),oTarget,6.0);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectVisualEffect(VFX_IMP_BLIND_DEAF_M),oTarget,6.0);
            SendMessageToPC(oPC,"¡Le has cegado!");
            SendMessageToPC(oTarget,"¡Te han lanzado polvo a los ojos!");
        }
        else
        {
            AssignCommand(oTarget,PlayAnimation(ANIMATION_FIREFORGET_DODGE_DUCK,1.0));
            SendMessageToPC(oPC,"¡Ha esquivado el polvo!");
            SendMessageToPC(oTarget,"¡Te han lanzado polvo a los ojos pero lo has esquivado!");
        }
    }
    else
        SendMessageToPC(oPC,StringToRGBString("No posees la astucia suficiente para usar esta habilidad.","711"));
  }

  // ATRAER LA DESGRACIA
  else if(sTagDelObjeto == "atraerdesgracia")
  {
    if (iCasterLevel >= 15)
    {
        SendMessageToPC(oPC,StringToRGBString("No posees el nivel suficiente para utilizar este hechizo.","700"));
        return;
    }
    effect eSum = EffectVisualEffect(VFX_FNF_PWKILL);
    effect eImplosion = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    effect eHarm = EffectVisualEffect(VFX_IMP_HARM);
    effect eMaldecir = EffectCurse(1,1,1,1,1,1);
    effect eMomia = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);

    AssignCommand(oPC,PlaySound("as_pl_chantingm2"));
    AssignCommand(oPC,ActionCastFakeSpellAtObject(SPELL_GATE,oTarget,PROJECTILE_PATH_TYPE_DEFAULT));
    DelayCommand(0.1,SetCommandable(FALSE,oPC));
    object oMalditos = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC));
    DelayCommand(7.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eMomia,oPC));
    DelayCommand(7.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eHarm,oPC));
    DelayCommand(7.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSum,oPC));
    DelayCommand(7.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eImplosion,oPC));
    DelayCommand(7.5,SendMessageToPC(oPC,"¡Estas maldito!"));
    DelayCommand(7.5,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eMaldecir,oPC));

    while(GetIsObjectValid(oMalditos))
    {
        DelayCommand(7.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eMomia,oMalditos));
        DelayCommand(7.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eHarm,oMalditos));
        DelayCommand(7.5,SendMessageToPC(oMalditos,"¡Estas maldito!"));
        DelayCommand(7.5,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eMaldecir,oMalditos));
        oMalditos = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC));
    }

    DelayCommand(9.0,SetCommandable(TRUE,oPC));
  }

  // EXPLOTAR CADAVER
  else if(sTagDelObjeto == "explotarcadaver")
  {
    if (iPlmLevel < 4)
    {
        SendMessageToPC(oPC,StringToRGBString("No posees el dominio suficiente como Maestro de la Lividez para utilizar este hechizo.","511"));
        return;
    }
      if(GetIsDead(oTarget) == FALSE)
      {
          SendMessageToPC(oPC,"¡Debes lanzar el conjuro a un cadaver!");
          return;
      }

      if(GetIsPC(oTarget) == TRUE)
      {
          SendMessageToPC(oPC,"¡No puedes lanzar este conjuro sobre un jugador muerto!");
          return;
      }

      object oNudillo = GetItemPossessedBy(oPC,"NW_IT_MSMLMISC13");
      int iDanyoExtra = 0;
      if(oNudillo != OBJECT_INVALID)
      {
          SendMessageToPC(oPC,"¡Utilizas el nudillo de esqueleto para potenciar el conjuro!");
          DestroyObject(oNudillo);
          iDanyoExtra = iDanyoExtra + d10();
      }

      // Animaciones
      AssignCommand(oPC,ActionSpeakString("¡Ivressha Ivramahh!"));
      AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1,2.0,2.0));

      // Destruir el cadaver
      AssignCommand(oTarget,SetIsDestroyable(TRUE,FALSE,FALSE));
      DestroyObject(oTarget);

      // Efectos visuales
      effect e1 = EffectVisualEffect(VFX_COM_CHUNK_YELLOW_SMALL);
      effect e2 = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
      effect e3 = EffectVisualEffect(VFX_IMP_DESTRUCTION);
      effect eSangre = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e2,lLocation);
      DelayCommand(0.5,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eSangre,lLocation));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e1,lLocation);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e3,lLocation);

      // Calculando el danyo
      if(GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY,oPC)) iDanyoExtra = iDanyoExtra + 2;
      if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY,oPC)) iDanyoExtra = iDanyoExtra + 4;
      if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY,oPC)) iDanyoExtra = iDanyoExtra + 6;
      iDanyoExtra = iDanyoExtra + GetLevelByClass(CLASS_TYPE_PALEMASTER,oPC);
      iDanyoExtra = iDanyoExtra + GetLevelByClass(CLASS_TYPE_WIZARD,oPC)/2;
      int iDanyoTotal = GetHitDice(oTarget)* d4() + iDanyoExtra;
      effect eDanyoTotal = EffectDamage(iDanyoTotal, DAMAGE_TYPE_BLUDGEONING);

      // Bucle: danyo, mensajes y sangre
      object oMalditos = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(oTarget));
      while(GetIsObjectValid(oMalditos))
      {
          SendMessageToPC(oMalditos,"¡Los trozos de cadaver te han golpeado!");
          AssignCommand(oPC,ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDanyoTotal, oMalditos));
          ApplyEffectToObject(DURATION_TYPE_PERMANENT,eSangre,oMalditos);

          oMalditos = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(oTarget));
      }

      return;
  }

  // ANIMAR CALAVERA DE UKIAH
  else if(sTagDelObjeto == "animarcalavera" ||sTagDelObjeto == "crr_infer3" )
  {
    if (iPlmLevel < 4)
    {
        SendMessageToPC(oPC,StringToRGBString("No posees el dominio suficiente como Maestro de la Lividez para utilizar este hechizo.","511"));
        return;
    }
      string iCalav = GetTag(oTarget);
      if(iCalav == "_calavera")
      {
          if(GetItemPossessor(oTarget) == OBJECT_INVALID)
          {
              AssignCommand(oPC,ActionCastFakeSpellAtLocation(SPELL_CREATE_GREATER_UNDEAD,GetLocation(oTarget),PROJECTILE_PATH_TYPE_DEFAULT));
              DelayCommand(0.1,SetCommandable(FALSE,oPC));
              effect e1 = EffectVisualEffect(VFX_IMP_DEATH);
              effect e2 = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
              DestroyObject(oTarget);
              DelayCommand(7.3,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e2,lLocation));
              DelayCommand(7.7,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e2,lLocation));
              DelayCommand(7.7,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e1,lLocation));
              DelayCommand(8.1,AddHenchman(oPC,CreateObject(OBJECT_TYPE_CREATURE,"calaveraanimada",lLocation,FALSE,"calaveraanimada")));
              DelayCommand(9.0,SetCommandable(TRUE,oPC));
          }
          else
          {
              AssignCommand(oPC,ActionSpeakString("La calavera debe estar en el suelo..."));
              return;
          }
      }
      else
      {
          AssignCommand(oPC,ActionSpeakString("No puedo animar eso..."));
          return;
      }

      return;
  }

  // LIBRO EN BLANCO GENERICO (UKIAH)
  else if(sTagDelObjeto == "libroespecial")
  {
      AssignCommand(oPC,ActionStartConversation(oPC, GetResRef(oItem), TRUE));
      return;
  }

  // GOLEM DE ENTRANYAS
  else if(sTagDelObjeto == "golemdeentranas")
  {
    if (iPlmLevel < 4)
    {
        SendMessageToPC(oPC,StringToRGBString("No posees el dominio suficiente como Maestro de la Lividez para utilizar este hechizo.","511"));
        return;
    }
      if(GetIsDead(oTarget) == FALSE)
      {
          SendMessageToPC(oPC,"¡Debes lanzar el conjuro a un cadáver!");
          return;
      }

      if(GetIsPC(oTarget) == TRUE)
      {
          SendMessageToPC(oPC,"¡No puedes lanzar este conjuro sobre un jugador muerto!");
          return;
      }

      int iRacial = GetRacialType(oTarget);
      if(PB_Race_GetIsUndead(oTarget) || iRacial == RACIAL_TYPE_CONSTRUCT || iRacial == RACIAL_TYPE_VERMIN)
      {
          SendMessageToPC(oPC,"¡No puedes lanzar este conjuro sobre este tipo de criatura!");
          return;
      }

      object oAmputada = GetItemPossessedBy(oPC,"_parteamputada");
      int iNivelesExtra = 0;
      if(oAmputada != OBJECT_INVALID)
      {
          SendMessageToPC(oPC,"¡El golem será más poderoso gracias a la parte amputada que has usado!");
          DestroyObject(oAmputada);
          iNivelesExtra = d8();
      }

      // Animaciones
      AssignCommand(oPC,ActionSpeakString("¡Ohrum, Shier ah Taak!"));
      AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1,1.0,5.0));

      // Variable: nivel de la criatura muerta objetivo
      SetLocalInt(oPC,"Nivelentranyas", GetHitDice(oTarget) + iNivelesExtra);

      // Destruir cadaver
      DelayCommand(4.2,AssignCommand(oTarget,SetIsDestroyable(TRUE,FALSE,FALSE)));
      DelayCommand(4.3,DestroyObject(oTarget));

      // Efectos visuales
      effect e1 = EffectVisualEffect(VFX_COM_CHUNK_YELLOW_SMALL);
      effect e2 = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
      effect e3 = EffectVisualEffect(VFX_IMP_DESTRUCTION);
      effect eSangre = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL);
      effect eV2 = EffectVisualEffect(91);
      DelayCommand(0.1,SetCommandable(FALSE,oPC));
      DelayCommand(4.3,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e2,lLocation));
      DelayCommand(4.7,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eSangre,lLocation));
      DelayCommand(4.3,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e1,lLocation));
      DelayCommand(4.3,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e3,lLocation));
      DelayCommand(4.3,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eV2,lLocation));
      DelayCommand(6.0,SetCommandable(TRUE,oPC));

      // Ayudante
      DelayCommand(5.0,AddHenchman(oPC,CreateObject(OBJECT_TYPE_CREATURE,"golemdeentranas",lLocation,FALSE,"golemdeentranas")));

      return;
  }

  // MORTERO PARA INGREDIENTES
  else if(sTagDelObjeto == "mortero")
  {
      AssignCommand(oPC,PlaySound("as_na_grassmove3"));
      string sTagDelObjetivo = GetTag(oTarget);
      if(GetTag(oTarget) == "bayaAcuosa")
      {
          DestroyObject(oTarget);
          CreateItemOnObject("extractobaya",oPC);
          CreateItemOnObject("extractobaya",oPC);
          if(d2() == 1) CreateItemOnObject("extractobaya",oPC);
          if(d2() == 1) CreateItemOnObject("extractobaya",oPC);
          SendMessageToPC(oPC,"*Machacas una baya acuosa en el mortero.*");
          return;
      }
      else if(sTagDelObjetivo == "brisaSusurrante")
      {
          DestroyObject(oTarget);
          CreateItemOnObject("polvobrisa",oPC);
          CreateItemOnObject("polvobrisa",oPC);
          if(d2() == 1) CreateItemOnObject("polvobrisa",oPC);
          if(d2() == 1) CreateItemOnObject("polvobrisa",oPC);
          SendMessageToPC(oPC,"*Machacas una brisa susurrante en el mortero.*");
          return;
      }
      else if(sTagDelObjetivo == "resinaSubterranea")
      {
          DestroyObject(oTarget);
          CreateItemOnObject("arenillaresi",oPC);
          CreateItemOnObject("arenillaresi",oPC);
          if(d2() == 1) CreateItemOnObject("arenillaresi",oPC);
          if(d2() == 1) CreateItemOnObject("arenillaresi",oPC);
          SendMessageToPC(oPC,"*Machacas una resina subterranea en el mortero.*");
          return;
      }
      else if(sTagDelObjetivo == "ardorDesertico")
      {
          DestroyObject(oTarget);
          CreateItemOnObject("polvoardor",oPC);
          CreateItemOnObject("polvoardor",oPC);
          if(d2() == 1) CreateItemOnObject("polvoardor",oPC);
          if(d2() == 1) CreateItemOnObject("polvoardor",oPC);
          SendMessageToPC(oPC,"*Machacas un ardor desertico en el mortero.*");
          return;
      }
      else if(sTagDelObjetivo == "raizPetrea")
      {
          DestroyObject(oTarget);
          CreateItemOnObject("raizmolida",oPC);
          CreateItemOnObject("raizmolida",oPC);
          if(d2() == 1) CreateItemOnObject("raizmolida",oPC);
          if(d2() == 1) CreateItemOnObject("raizmolida",oPC);
          SendMessageToPC(oPC,"*Machacas una raiz petrea en el mortero.*");
          return;
      }
      else if(sTagDelObjetivo == "florLuminosa")
      {
          DestroyObject(oTarget);
          CreateItemOnObject("extractoflorlum",oPC);
          CreateItemOnObject("extractoflorlum",oPC);
          if(d2() == 1) CreateItemOnObject("extractoflorlum",oPC);
          if(d2() == 1) CreateItemOnObject("extractoflorlum",oPC);
          SendMessageToPC(oPC,"*Machacas una flor luminosa en el mortero.*");
          return;
      }
      else if(sTagDelObjetivo == "setaNocturna")
      {
          DestroyObject(oTarget);
          CreateItemOnObject("polvoseta",oPC);
          CreateItemOnObject("polvoseta",oPC);
          if(d2() == 1) CreateItemOnObject("polvoseta",oPC);
          if(d2() == 1) CreateItemOnObject("polvoseta",oPC);
          SendMessageToPC(oPC,"*Machacas una seta nocturna en el mortero.*");
          return;
      }
      else if(sTagDelObjetivo == "frutoFantasma")
      {
          DestroyObject(oTarget);
          CreateItemOnObject("extractofantasma",oPC);
          CreateItemOnObject("extractofantasma",oPC);
          if(d2() == 1) CreateItemOnObject("extractofantasma",oPC);
          if(d2() == 1) CreateItemOnObject("extractofantasma",oPC);
          SendMessageToPC(oPC,"*Machacas un fruto fantasma en el mortero.*");
          return;
      }
      else if(sTagDelObjetivo == "NW_IT_MSMLMISC23")
      {
          DestroyObject(oTarget);
          CreateItemOnObject("extractodebellad",oPC);
          CreateItemOnObject("extractodebellad",oPC);
          if(d2() == 1) CreateItemOnObject("extractodebellad",oPC);
          if(d2() == 1) CreateItemOnObject("extractodebellad",oPC);
          SendMessageToPC(oPC,"*Machacas una belladona en el mortero.*");
          return;
      }
      else if(sTagDelObjetivo == "raizpodridaitem")
      {
          DestroyObject(oTarget);
          CreateItemOnObject("serrin_negro",oPC);
          CreateItemOnObject("serrin_negro",oPC);
          if(d2() == 1) CreateItemOnObject("serrin_negro",oPC);
          if(d2() == 1) CreateItemOnObject("serrin_negro",oPC);
          SendMessageToPC(oPC,"*Machacas una raiz podrida en el mortero.*");
          return;
      }
      else
      {
          SendMessageToPC(oPC,"¡Eso no se puede machacar en el mortero!");
          return;
      }
  }

  // AURA CABALLERO DE LA MUERTE
  else if(sTagDelObjeto =="auradk")AssignCommand(oPC,ActionStartConversation(oPC, "auradk", TRUE, FALSE));

  // ACTIVAR VOLVER A LA NECRO
  else if(sTagDelObjeto =="volvernecro")AssignCommand(oPC,ActionStartConversation(oPC, "volvernecro", TRUE, FALSE));

  //MENSAJE EN UNA BOTELLA (Script totalmente cutre e insulso)
  else if(sTagDelObjeto == "vgz_botellamensaje")
  {
      int id4 = d4();
      string sMensaje = IntToString(id4);
      DestroyObject(oItem);
      CreateItemOnObject("vgz_mensajebot" + sMensaje, oPC);
      return;
  }

  ///PALA DE CAVAR: //Pintar desencadenante de Tesoro Enterrado y ponerle como variable string la ResRef del objeto que
  //hay enterrado ahi, en caso de ser tesoros genericos, usar la variable Tesoroarea y dejar en blanco la variable Tesoro.
  //en caso de ser tesoro unico, especificar aqui abajo.
if(sTagDelObjeto == "vgz_cs_palacavar")
  {
      // Solo areas exteriores naturales
      object oAreaJugador = GetArea(oPC);
      if(GetIsAreaNatural(oAreaJugador) != AREA_NATURAL)
      {
          FloatingTextStringOnCreature(StringToRGBString("¡Sólo puedes utilizar la pala en áreas exteriores naturales!","700"), oPC, FALSE);
          return;
      }

      // Animaciones, sonido, eliminar invisivilidad, crear y eliminar agujero
      AssignCommand(oPC,ClearAllActions());
      AssignCommand(oPC,PlaySound("as_cv_mineshovl" + IntToString(d3())));
      AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,5.0));
      DelayCommand(0.1,FadeToBlack(oPC));
      DelayCommand(0.2,SetCommandable(FALSE,oPC));
      DelayCommand(4.7,FadeFromBlack(oPC,FADE_SPEED_MEDIUM));
      DelayCommand(4.8,SetCommandable(TRUE,oPC));

      RemoveEffectOfType(oPC, EFFECT_TYPE_INVISIBILITY);
      RemoveEffectOfType(oPC, EFFECT_TYPE_IMPROVEDINVISIBILITY);
      RemoveEffectOfType(oPC, EFFECT_TYPE_SANCTUARY);

      float fDir = GetFacing(oPC);
      location lAgujero = GenerateNewLocation(oPC, 1.7, fDir, fDir + 180.0);
      object oAgujero = CreateObject(OBJECT_TYPE_PLACEABLE,"x2_plc_hole_s",lAgujero);
      DelayCommand(12.0,DestroyObject(oAgujero));

      // Si no se tiene la variable el area, no se encuentra nada
      if(GetLocalInt(oAreaJugador, "TESOROS_CAVAR") != 1)
      {
          DelayCommand(5.0, FloatingTextStringOnCreature(StringToRGBString("Abres un agujero en la tierra pero no encuentras nada.","700"), oPC, FALSE));
          return;
      }

      string sTesoro = GetLocalString(oPC, "vgz_tesoroenterrado");
      int iTesoroEspecialYaEncontrado = ObtenerIntPersistente(oPC, sTesoro);

      // OBJETOS ESPECIALES
      // Obj. especiales miscelaneos
      if(sTesoro == "vgz_tablilla1"    || sTesoro == "vgz_tablilla2"    || sTesoro == "vgz_tablilla3"    ||
         sTesoro == "cs_trozodeanill3" || sTesoro == "_muelaoro"        || sTesoro == "_doblon"          ||
         sTesoro == "warmcloak"        || sTesoro == "vgz_amutemplo"    || sTesoro == "vgz_escudotrasgo" ||
         sTesoro == "_cascooxidado"    || sTesoro == "vgz_notafalsa"    || sTesoro == "nw_it_mring006"   ||
         sTesoro == "nw_wbwmln008"     || sTesoro == "nw_it_contain002" || sTesoro == "oro500"           ||
         sTesoro == "nw_aarcl007"      || sTesoro == "vgz_cristalbrill" || sTesoro == "oro250"           ||
         sTesoro == "simboloantimagma")
      {
          if(iTesoroEspecialYaEncontrado == TRUE || d100() <= 70)
          {
              DelayCommand(5.0, FloatingTextStringOnCreature(StringToRGBString("Abres un agujero en la tierra pero no encuentras nada.","700"), oPC, FALSE));
              return;
          }
          else
          {
              GuardarIntPersistente(oPC, sTesoro, TRUE);
              DelayCommand(5.0, CreateItemOnObjectVoid(sTesoro, oPC));
              DelayCommand(5.0, AssignCommand(oPC, PlaySound("zelda2")));
              DelayCommand(5.0, FloatingTextStringOnCreature(StringToRGBString("¡Has encontrado un objeto enterrado!","070"), oPC, FALSE));
              return;
          }
      }

      // Botas de Kossut, Baston menor de canalizacion: necesitan mapa
      else if(sTesoro =="vgz_botaskossut" || sTesoro == "vgz_bastoncan1")
      {
          string sMapa;
          if(sTesoro =="vgz_botaskossut") sMapa = "vgz_mensajebot4";
          else "vgz_mensajebot3";
          object oMapa = GetItemPossessedBy(oPC, sMapa);
          if(iTesoroEspecialYaEncontrado == TRUE || oMapa == OBJECT_INVALID || d100() <= 70)
          {
              DelayCommand(5.0, FloatingTextStringOnCreature(StringToRGBString("Abres un agujero en la tierra pero no encuentras nada.","700"), oPC, FALSE));
              return;
          }
          else
          {
              DestroyObject(oMapa);
              GuardarIntPersistente(oPC, sTesoro, TRUE);
              DelayCommand(5.0, CreateItemOnObjectVoid(sTesoro, oPC));
              DelayCommand(5.0, AssignCommand(oPC, PlaySound("zelda2")));
              DelayCommand(5.0, FloatingTextStringOnCreature(StringToRGBString("¡Has encontrado un objeto enterrado!","070"), oPC, FALSE));
              return;
          }
      }

      // OBJETOS NUEVO SISTEMA
      else
      {
          int iProbabilidadCavar = d100();
          int iProbabilidadObjeto = d100();
          int iApilable = 0;
          int iApilableCantidad = d20();
          effect eDamage =  EffectDamage(d12()+1, DAMAGE_TYPE_BLUDGEONING);

          //Probalidad de encontrar algo del 30%
          if(iProbabilidadCavar > 70)
          {
              if(iProbabilidadObjeto < 2) //ï¿½Pifia cavando!
                {
                DestroyObject(oItem);
                DelayCommand(5.0, FloatingTextStringOnCreature(StringToRGBString("¡La pala se rompe y te golpea en la cara!","700"), oPC, TRUE));
                DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage, oPC ));
                return;
                }
              else if(iProbabilidadObjeto < 10) DelayCommand(2.0, CrearBasura(oPC, 1));
              else if(iProbabilidadObjeto < 12) DelayCommand(2.0,CrearBastonesMagicos(oPC, 1));
              else if(iProbabilidadObjeto < 33) DelayCommand(2.0,CrearBasura(oPC, 1));
              else if(iProbabilidadObjeto < 41) DelayCommand(2.0,CrearGemas(oPC, 1));
              else if(iProbabilidadObjeto < 57) DelayCommand(2.0,CrearBasura(oPC, 1));
              else if(iProbabilidadObjeto < 65) DelayCommand(2.0,CrearMiscelanea(oPC, 1));
              else if(iProbabilidadObjeto < 77) DelayCommand(2.0,CrearBasura(oPC, 1));
              else if(iProbabilidadObjeto < 85) DelayCommand(2.0,CrearPocion(oPC, 1));
              else if(iProbabilidadObjeto < 92) DelayCommand(2.0,CrearBasura(oPC, 1));
              else if(iProbabilidadObjeto < 94) DelayCommand(2.0,CrearArmaCuerpo(oPC, 1));
              else if(iProbabilidadObjeto < 96) DelayCommand(2.0,CrearArmaDistancia(oPC, 1));
              else if(iProbabilidadObjeto < 98) DelayCommand(2.0,CrearArmaCuerpo(oPC, 2));
              else if(iProbabilidadObjeto < 101) DelayCommand(2.0,CrearArmaDistancia(oPC, 2));

              DelayCommand(5.0, AssignCommand(oPC, PlaySound("zelda2")));
              DelayCommand(5.0, FloatingTextStringOnCreature(StringToRGBString("¡Has encontrado un objeto enterrado!","070"), oPC, FALSE));
              return;
          }

          else
          {
              DelayCommand(5.0, FloatingTextStringOnCreature(StringToRGBString("Abres un agujero en la tierra pero no encuentras nada.","700"), oPC, FALSE));
              return;
          }
      }
  }


    if(sTagDelObjeto == "savecreature")
    {
        //Recuperamos y liberamos la base de datos
        //oCreature = RetrieveCampaignDBObject(oPC, nName, lLocation);.
        //DelayCommand(0.5, DeleteCampaignDBVariable(oPC, nName));

        string sCreature = GetDescription(oItem);
        object oCreature = NWNX_Object_Deserialize(sCreature);
        NWNX_Object_AddToArea(oCreature, GetArea(oPC), GetPositionFromLocation(lLocation));

        if (GetIsObjectValid(oCreature)) //Reasignamos los datos guardados
        {
            FloatingTextStringOnCreature(StringToRGBString("¡Se ha recuperado la criatura!","070"), oPC, FALSE);
        }
        else SendMessageToPC(oPC, "No se ha podido restaurar la criatura.");
    }

  //ATRAVESAR PUERTAS Y PAREDES ETEREIDAD, EXCURSION ETEREA
  else if(sTagDelObjeto == "item_etereidad")
  {
      object oDust = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_dustplume", lLocation, FALSE);
      DelayCommand ( 2.0, DestroyObject ( oDust));
      location lPC = GetLocation(oPC);
      location lDestino = GetLocation(oDust);
      float fDistancia = GetDistanceBetweenLocations(lPC, lDestino);

      //Conteo de usos
      int iUsos = GetLocalInt(oPC, "ETEREIDAD_USOS");

          if(iUsos == 5)
          {
              SendMessageToPC(oPC, "Esta habilidad esta limitada a 5 'saltos' por conjuro.");
              return;
          }
    //Solo saltamos con Etereidad y Excursion Eterea
    if (GetHasSpellEffect(1370, oPC) == TRUE || GetHasSpellEffect(443, oPC) == TRUE)
    {
          //Solo 3 metros de nuestra posicion
          if(fDistancia >= 0.0 && fDistancia <= 4.0)
          {
              AssignCommand(oPC, ClearAllActions(TRUE));
              AssignCommand(oPC, ActionJumpToLocation(lDestino));
              SetLocalInt(oPC, "ETEREIDAD_USOS", iUsos + 1);
              return;
          }
          else
          {
              FloatingTextStringOnCreature("*¡No puedes materializarte tan lejos!*", oPC, FALSE);
              return;
          }
    }
    else
    {
        FloatingTextStringOnCreature("*¡No puedes materializarte desde el plano material!*", oPC, FALSE);
        return;
    }
  }

  //POCIONES DE ENERGIA NEGATIVA
  else if(sTagDelObjeto == "poti_negativa")
  {
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Pocion de Energia Negativa Menor"))
    {
        TimelockErrorMessage(oPC, "Pocion de Energia Negativa Menor");
        CreateItemOnObject(sTagDelObjeto, oPC);
        return;
    }
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_INFLICT_LIGHT_WOUNDS, FALSE));
    if (PB_Race_GetIsUndead(oPC))
    {
      if(GetLocalInt(oPC, "dm_nocurar") != 1)
      {
          effect eApp = EffectHeal(d8()+10);
          effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

          ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oPC);
          SetTimelock(oPC, 10, "Pocion de Energia Negativa Menor", 0, 0);
      }
      if(GetLocalInt(oPC, "dm_nocurar") == 1){CreateItemOnObject(sTagDelObjeto, oPC, 1);}
    }
    else
    {
      effect eApp = EffectDamage(d8()+10,DAMAGE_TYPE_NEGATIVE);
      effect eVis = EffectVisualEffect(VFX_IMP_HARM);

      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
      SetTimelock(oPC, 10, "Pocion de Energia Negativa Menor", 0, 0);
    }
   }

  else if(sTagDelObjeto == "poti_negativa2")
  {
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Pocion de Energia Negativa Moderada"))
    {
        TimelockErrorMessage(oPC, "Pocion de Energia Negativa Moderada");
        CreateItemOnObject(sTagDelObjeto, oPC, 1);
        CreateItemOnObject(sTagDelObjeto, oPC);
        return;
    }
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_INFLICT_MODERATE_WOUNDS, FALSE));
    if (PB_Race_GetIsUndead(oPC))
    {
      if(GetLocalInt(oPC, "dm_nocurar") != 1)
      {
        effect eApp = EffectHeal(d8(2)+15);
        effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oPC);
        SetTimelock(oPC, 10, "Pocion de Energia Negativa Moderada", 0, 0);
      }
      if(GetLocalInt(oPC, "dm_nocurar") == 1){CreateItemOnObject(sTagDelObjeto, oPC, 1);}
    }
    else
    {
      effect eApp = EffectDamage(d8(2)+15,DAMAGE_TYPE_NEGATIVE);
      effect eVis = EffectVisualEffect(VFX_IMP_HARM);

      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
      SetTimelock(oPC, 10, "Pocion de Energia Negativa Moderada", 0, 0);
    }
   }

   //Items de sets de armaduras
 if(sTagDelObjeto == "item_celestial"   ||
    sTagDelObjeto == "item_infernal"    ||
    sTagDelObjeto == "item_nirvana"     ||
    sTagDelObjeto == "item_camino"      ||
    sTagDelObjeto == "item_artifice"    ||
    sTagDelObjeto == "item_gigante"     ||
    sTagDelObjeto == "item_varanegra"   ||
    sTagDelObjeto == "item_loco"        ||
    sTagDelObjeto == "item_inmortal"    ||
    sTagDelObjeto == "item_tierra"  )
    {

    //Si ya tenemos uno, nada.
    if(GetLocalInt(oPC, "Poder_Especial") == 1 ) { SendMessageToPC(oPC, "Ya tienes un poder de set de armadura activo."); return; }

        int PiezaAngel = ObtenerIntPersistente(oPC, "Pieza_Celestial");
        int PiezaInfernal = ObtenerIntPersistente(oPC, "Pieza_Infernal");
        int PiezaNirvana = ObtenerIntPersistente(oPC, "Pieza_Nirvana");
        int PiezaCamino = ObtenerIntPersistente(oPC, "Pieza_Camino");
        int PiezaArtifice = ObtenerIntPersistente(oPC, "Pieza_Artifice");
        int PiezaGigante = ObtenerIntPersistente(oPC, "Pieza_Gigante");
        int PiezaVaraNegra = ObtenerIntPersistente(oPC, "Pieza_Varanegra");
        int PiezaLoco = ObtenerIntPersistente(oPC, "Pieza_Loco");
        int PiezaInmortal = ObtenerIntPersistente(oPC, "Pieza_Inmortal");
        int PiezaTierra = ObtenerIntPersistente(oPC, "Pieza_Tierra");
        int AlasGuardadas = GetCreatureWingType(oPC);

        //Tiempo que duran los poderes
        float nDuration = 240.0;

        effect eBonus = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
        effect eBonus1 = EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
        effect eBonus2 = EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
        effect eBonus3 = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 2);
        effect eBonus4 = EffectAbilityIncrease(ABILITY_WISDOM, 2);
        effect eBonus5 = EffectAbilityIncrease(ABILITY_CHARISMA, 2);

        effect eLinkBonus = EffectLinkEffects(eBonus, eBonus1);
        eLinkBonus = EffectLinkEffects(eLinkBonus, eBonus2);
        eLinkBonus = EffectLinkEffects(eLinkBonus, eBonus3);
        eLinkBonus = EffectLinkEffects(eLinkBonus, eBonus4);
        eLinkBonus = EffectLinkEffects(eLinkBonus, eBonus5);
        eLinkBonus = SupernaturalEffect(eLinkBonus);

        //Si tenemos el kit Celestial
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && PiezaAngel > 3)
        {
            if(AlasGuardadas == 0)
            {
                SetCreatureWingType(2, oPC);
            }
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBonus, oPC, nDuration);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_STRIKE_HOLY), GetLocation(oPC));
            SetLocalInt(oPC, "Poder_Especial", 1);

            return;
        }

        //Si tenemos el kit Infernal
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && PiezaInfernal > 3)
        {
            if(AlasGuardadas == 0)
            {
                SetCreatureWingType(1, oPC);
            }
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBonus, oPC, nDuration);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), oPC);
            SetLocalInt(oPC, "Poder_Especial", 1);

            return;
        }

        //Si tenemos el kit Nirvana
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && PiezaNirvana > 3)
        {
            if(AlasGuardadas == 0)
            {
                SetCreatureWingType(6, oPC);
            }
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBonus, oPC, nDuration);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_NATURES_BALANCE), GetLocation(oPC));
            SetLocalInt(oPC, "Poder_Especial", 1);

            return;
        }

        //Si tenemos el kit Camino sin fin
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && PiezaCamino > 3)
        {

            if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oPC) == TRUE) {
                RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, oPC, oPC);
            }
            if (GetHasSpellEffect(647, oPC) == TRUE) {
                RemoveSpellEffects(647, oPC, oPC);
            }
            if (GetHasSpellEffect(SPELL_MASS_HASTE, oPC) == TRUE) {
                RemoveSpellEffects(SPELL_MASS_HASTE, oPC, oPC);
            }

            effect eApp = EffectHaste();
            effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eLink = EffectLinkEffects(eApp, eDur);
            eLink = SupernaturalEffect(eLink);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, nDuration);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            SetLocalInt(oPC, "Poder_Especial", 1);

            return;
        }

        //Si tenemos el kit Artifice
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && PiezaArtifice > 3)
        {

            // Se disipan los siguientes conjuros por incompatibilidades... medida extrema antiabuso
            RemoveEffectsFromSpell(OBJECT_SELF, 996); // Cuerpo ferreo
            RemoveEffectsFromSpell(OBJECT_SELF, 62);  // Libertad
            RemoveEffectsFromSpell(OBJECT_SELF, 1022);// Libertad de asesino
            RemoveEffectsFromSpell(OBJECT_SELF, 1093);// Libertad de guardia negro
            RemoveEffectsFromSpell(OBJECT_SELF, 1124);// Libertad de agente arpista
            RemoveEffectsFromSpell(OBJECT_SELF, 125); // Proteccion contra energia negativa
            RemoveEffectsFromSpell(OBJECT_SELF, 444); // Undeaths_Eternal_Foe


            effect eLink = EffectDamageReduction(20, DAMAGE_POWER_PLUS_FIVE);
            eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
            eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
            eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
            eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
            eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
            eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));
            eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_STUN));
            eLink    = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_DROWN));
            eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100));
            eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100));
            eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100));
            eLink    = EffectLinkEffects(eLink, EffectVisualEffect(927));
            eLink    = EffectLinkEffects(eLink, EffectSpellFailure(50, SPELL_SCHOOL_GENERAL));
            eLink    = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(50));
            eLink    = EffectLinkEffects(eLink, EffectACDecrease(4));
            eLink    = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_DEXTERITY, 6));
            eLink    = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 6));
            eLink = SupernaturalEffect(eLink);

            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, nDuration));

            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC);
            SetLocalInt(oPC, "Poder_Especial", 1);

            return;
        }

        //Si tenemos el kit Gigante
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && PiezaGigante > 3)
        {
            float fAltura = ObtenerFloatPersistente(oPC, "IND_ALTURA");
            effect eLink = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
            eLink    = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_DEXTERITY, 2));
            eLink    = EffectLinkEffects(eLink, EffectAttackDecrease(1));
            eLink    = EffectLinkEffects(eLink, EffectACDecrease(1));
            eLink = SupernaturalEffect(eLink);

            if(ObtenerIntPersistente(oPC, "CAB_ALTURA")== FALSE) fAltura = 1.00;

            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC);
            SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, 2.50);
            DelayCommand(nDuration, DevolverAltura(oPC, fAltura));
            SetLocalInt(oPC, "Poder_Especial", 1);
            return;
        }

        //Si tenemos el kit Vara Negra
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && PiezaVaraNegra > 3)
        {
            effect eLink = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4);
            eLink    = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_CONSTITUTION, 2));
            eLink    = EffectLinkEffects(eLink, EffectSpellResistanceIncrease(20));
            eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));
            eLink = SupernaturalEffect(eLink);

            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, nDuration));
            SetLocalInt(oPC, "Poder_Especial", 1);
            return;
        }

        //Si tenemos el kit Arsenal del Loco
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && PiezaLoco > 3)
        {
            object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
            IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_CHAOSSHIELD, 21), nDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AssignCommand(oPC, ActionCastSpellAtObject(615, oPC, METAMAGIC_NONE, TRUE, 21, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(758), oPC, nDuration); //Esfera Prismatica
            SetLocalInt(oPC, "Poder_Especial", 1);
            return;

        }

        //Si tenemos el kit Deber de Tierra
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1 && PiezaTierra > 3)
        {

            effect eLink = EffectAbilityIncrease(ABILITY_WISDOM, 4);
            eLink    = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
            eLink    = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_DEXTERITY, 4));
            eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROT_BARKSKIN));
            eLink = SupernaturalEffect(eLink);

            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC);
            SetLocalInt(oPC, "Poder_Especial", 1);
            return;
        }


        else DestroyObject(oItem, 0.5);

    }

//////////////////////////////////////
//          Tipos de piel
//
// 1 Piel de roedor
// 2 Piel de herbívoro
// 3 Piel de bestia salvaje
// 4 Piel de bestia salvaje grande
// 5 Piel de bestia mítica
// 6 Piel de bestia mítica gruesa
// 7 Piel de dragón de fuego
// 8 Piel de dragón de hielo
// 9 Piel de dragón de ácido
// 10 Piel de dragón de rayo
//
/////////////////////////////////
    //HABILIDAD UMBRA: Pone un efecto visual.
    if(sTagDelObjeto == "krono_efeoscurid") { ExecuteScript("krono_efeoscurid", oPC); return;}
    //OBJETO: Efecto visual segun alineamiento.
    if(sTagDelObjeto == "asy_efectovisual") { ExecuteScript("asy_efectovisual", oPC); return;}
    //ELIMINAR DE LA BASE DE DATOS LOS ALIADOS CONVOCADOS BLOQUEADOS O BUGEADOS.
    if(sTagDelObjeto == "pb_elimconvocado") { AssignCommand(oPC,ActionStartConversation(oPC,"hench_del",TRUE,FALSE));  return;}
    //EXECUTES
    ExecuteScript("hc_on_act_item",OBJECT_SELF); // HCR estandar
    //VENDAS
    ExecuteScript("cerr_vendas", GetItemActivator());
    //VENENOS
    ExecuteScript("cerr_venom_activ",oPC);
    //Inspirar Frenesi
    if(sTagDelObjeto == "inspirarfrenesi") AssignCommand(oPC, ActionCastSpellAtObject(1329, oPC, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE) );
    //Invocaciones
    if(sTagDelObjeto == "Invocaciones") { AssignCommand(oPC,ActionStartConversation(oPC,"invocaciones",TRUE,FALSE));  return;}

    // SISTEMA DE EFECTOS PERSISTENTES
    if (sTagDelObjeto == "DM_VFX_ITEM" && (GetIsDM(oPC) || GetIsDMPossessed(oPC))) OnActivateItemScript(oPC, oTarget);
    //Golem System
    if(GetStringLeft(sTagDelObjeto, 6) == "pb_gs_") CreateOrDestroyGolemOnItemActive(oPC, oItem);

    //ITEM DE DISFRAZ
    if(GetTag(oItem) == "item_disfraz")
    {
        //CONDICIONANTES GLOBALES.
        /*// No polimorfado
        if(GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC) == TRUE || ObtenerIntPersistente(oPC,"POLYMORPHED"))
        {
            SendMessageToPC(oPC, StringToRGBString("No puede usarse estando poliformado.","711")); return;
            return;
        }*/

        /*// No funciona montado en montura
        if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
        {
            SendMessageToPC(oPC, StringToRGBString("No puede usarse estando montado.","711")); return;
            return;
        }*/

        /*//Si tenemos la apariencia cambiada nanay
        if(ObtenerIntPersistente(oPC, "APA_CAMBIADA") == TRUE)
        {
            SendMessageToPC(oPC, StringToRGBString("Vuelve a tu estado normal para poder usar esta herramienta.","711")); return;
            return;
        }*/

        //Si nos estamos disfrando nada
        if(ObtenerIntPersistente(oPC, "DISFRAZ_SPAM") > 0)
        {
            SendMessageToPC(oPC, StringToRGBString("¡Ya te estás disfrazando!","711")); return;
            return;
        }
        //Tiramos la conversación
        SetLocalObject(oPC, "DISFRAZ_ITEM", oTarget);
        AssignCommand(oPC, ActionStartConversation(oPC, "sys_disfraces", TRUE));
    }

    //OBJETO GUARDACONJUROS DEL ARTÍFICE
    if(GetTag(oItem) == "cls_ing_item5")
    {
        //Comprobamos que el objetivo del conjuro no sea otro si el conjuro no es de uso no personal.
        string sRango = Get2DAString("spells", "Range", GetLocalInt(oItem,"SPELL_ID"));
        if(sRango == "P" && oTarget != oPC)
        {
            FloatingTextStringOnCreature("El conjuro que intentas lanzar, es de rango personal, no puedes usar ese conjuro en otros.", oPC, FALSE);
            return;
        }

        NWNX_Creature_DoItemCastSpell(oPC, oTarget, lLocation, GetLocalInt(oItem,"SPELL_ID"), GetTotalCasterLevel(oPC, CLASS_TYPE_INGENIERO), 1.0);
    }

    //OBJETO APTITUD SORTILEGA DEL ARCHIMAGO
    if (GetTag(oItem) == "ArchmagesFocusofPower")
    {
        if (NWNX_Creature_GetKnowsFeat(oPC, 1432))
        {
            int iSpellId = GetLocalInt(oItem, "SPELL_ID");
            string sRango = Get2DAString("spells", "Range", iSpellId);

            if (sRango == "P" && oTarget != oPC)
            {
                FloatingTextStringOnCreature("El conjuro que intentas lanzar es de rango personal, no puedes usar ese conjuro en otros.", oPC, FALSE);
                return;
            }

            // Iniciar animación de conjuro (sin efectos reales)
            PlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_SPELLTURNING), oPC);
            SendMessageToPC(oPC, ColorTexto("Utilizas tu actitud sortilega.", TXT_COLOR_VERDE));

            // Guardar información temporal del hechizo para ejecutar más tarde si no hay interrupción
            SetLocalInt(oPC, "APTITUD_CONCENTRATING", TRUE);
            SetLocalInt(oPC, "APTITUD_SPELL_ID", iSpellId);
            SetLocalObject(oPC, "APTITUD_SPELL_TARGET", oTarget);
            SetLocalLocation(oPC, "APTITUD_SPELL_LOC", lLocation); // válido para target en lugar

            // Ejecutar chequeo de concentración tras el retardo
            DelayCommand(1.0, AssignCommand(oPC, CheckConcentrationAndCastSpell(oPC)));
        }
    }

    //OBJETOS SKIN MAESTRO MULTIPLES FORMAS
    if (GetTag(oItem)== "MMF_SKINS"){
        AssignCommand(oPC,ActionStartConversation(oPC,"pb_mmf_conv",TRUE));
    }

    //OBJETOS DE PREMIO DM: COFRES.
    if(GetTag(oItem) == "item_dmcofre3")
    {
        float fFacing = GetFacing(oPC);
        object oTesoro = CreateObject(OBJECT_TYPE_PLACEABLE, "cofreboss", lLocation);
        DelayCommand(0.3, SetLocalInt(oTesoro, "TIPOTESORO", 3));
        DelayCommand(0.3, SetLocalInt(oTesoro, "TESOROBOSS", 1));
        SetName(oTesoro, "Cofre poderoso de "+GetLocalString(oItem, "ITEMCOFRE_DM"));
        AssignCommand(oTesoro, SetFacing(fFacing));
        DestroyObject(oItem);
    }
    if(GetTag(oItem) == "item_dmcofre4")
    {
        float fFacing = GetFacing(oPC);
        object oTesoro = CreateObject(OBJECT_TYPE_PLACEABLE, "cofreboss", lLocation);
        DelayCommand(0.3, SetLocalInt(oTesoro, "TIPOTESORO", 4));
        DelayCommand(0.3, SetLocalInt(oTesoro, "TESOROBOSS", 1));
        SetName(oTesoro, "Cofre legendario de "+GetLocalString(oItem, "ITEMCOFRE_DM"));
        AssignCommand(oTesoro, SetFacing(fFacing));
        DestroyObject(oItem);
    }
    if(GetTag(oItem) == "item_dmcofre5")
    {
        float fFacing = GetFacing(oPC);
        object oTesoro = CreateObject(OBJECT_TYPE_PLACEABLE, "cofreboss", lLocation);
        DelayCommand(0.3, SetLocalInt(oTesoro, "TIPOTESORO", 5));
        DelayCommand(0.3, SetLocalInt(oTesoro, "TESOROBOSS", 1));
        SetName(oTesoro, "Cofre titánico de "+GetLocalString(oItem, "ITEMCOFRE_DM"));
        AssignCommand(oTesoro, SetFacing(fFacing));
        DestroyObject(oItem);
    }

    //LLAVE ARPISTA: CREACIÓN DE LA PUERTA MÁGICA ARPISTA.
    if(GetTag(oItem) == "pb_insigniarpist")
    {
        object oWP = GetObjectByTag("DOOR_ARPISTA");
        float fFacing = GetFacing(oWP);
        location lWP = GetLocation(oWP);
        float fDistanciaWP = GetDistanceBetweenLocations(GetLocation(oPC), lWP);
        //Si no estamos cerca, nanai.
        if(fDistanciaWP == -1.0 || fDistanciaWP > 15.0)
        {
            SendMessageToPC(oPC,ColorTexto("La llave solo funciona si estás cerca del lugar indicado.",TXT_COLOR_ROJO));
            return;
        }
        //Si hay una puerta ya creada, nanai.
        if(GetIsObjectValid(GetObjectByTag("ub_puertaarp")))
        {
            SendMessageToPC(oPC,ColorTexto("La puerta ya está invocada.",TXT_COLOR_ROJO));
            return;
        }
        //Creamos la puerta en el punto del WP.
        object oPuerta = CreateObject(OBJECT_TYPE_PLACEABLE, "ub_puertaarp", lWP);
        //Le hacemos mirar hacia el mismo lugar que el punto de ruta.
        AssignCommand(oPuerta, SetFacing(fFacing));
        //Ponemos efectos  visuales a la puerta.
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(9), oPuerta);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1857), lWP);
        //Destruimos la puerta.
        DestroyObject(oPuerta, 15.0);
        //Mensajito rolero.
        SendMessageToPC(oPC,ColorTexto("*Al activar el objeto, unas tenues y breves notas procedentes de un arpa que no existe resuenan por el lugar. Una puerta mágica aparece ante ti, espectral. No permanecerá mucho ahí.*",TXT_COLOR_AZUL));
    }

    //Varita de desencadenantes.
    if(GetTag(oItem) == "item_desen")
    {
        SetLocalLocation(oPC, "DM_DESEN_LTARGET", lLocation);
        AssignCommand(oPC, ActionStartConversation(oPC, "conv_desen", TRUE));
    }
}

