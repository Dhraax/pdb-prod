//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guion:  wrap_on_acq_item                                  //:://
//::////////////////////////////////////////////////////////////////////////////
//:: GUION ON_ACQUIRE_ITEM PARA EL SERVIDOR PUERTA DE BALDUR              //:://
//:: Creado por Monti                                                     //:://
//::////////////////////////////////////////////////////////////////////////////

#include "corpse_functions"
#include "f_vampire_aquire"
#include "nw_i0_spells"
#include "pb_objilegales"
#include "inc_sqlite_time"
#include "sys_quest_acquir"

void main()
{
  object oPC = GetModuleItemAcquiredBy();
  object oAdquirido = GetModuleItemAcquired();
  string sAdquirido = GetTag(oAdquirido);

  // LAS TRAMPAS SE MARCAN COMO OBJETO ROBADO
  if((FindSubString(sAdquirido, "nw_it_trap")>-1) ||
     (FindSubString(sAdquirido, "NW_IT_TRAP")>-1)) SetPlotFlag(oAdquirido, TRUE);

  // LOS OBJETOS QUE PESAN MAS DE 5.0
  // Y LOS QUE VALEN MAS DE 2000PO, NO SE PUEDEN ROBAR
  if(GetGoldPieceValue(oAdquirido) >= 2000 ||
     GetWeight(oAdquirido) >= 50) SetPickpocketableFlag(oAdquirido, FALSE);

  // Desactivacion del modo carrera
  if(GetHasSpellEffect(984, oPC))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Carrera desactivado *</c>", oPC, FALSE);
      RemoveEffectsFromSpell(oPC, 984);
  }

  // Agacharse al saquear
  corpse_Looting(oPC, GetModuleItemAcquiredFrom(), oAdquirido);

  // LAS OFRENDAS DE AURIL TE MALDICEN
  if(sAdquirido == "OfrendaaAuril")
  {
      effect eEfecto1 = EffectCurse(1,1,1,1,1,1);
      effect eEfecto2 = EffectDisease(DISEASE_DEMON_FEVER);
      effect eEfecto3 = EffectDamage(d2() * GetHitDice(oPC));
      effect eEfecto4 = EffectVisualEffect(VFX_IMP_LIGHTNING_M);

      DelayCommand(1.5, FloatingTextStringOnCreature("La ira de Auril te ha maldito", oPC));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto1, oPC, 100.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto2, oPC, 100.0);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto3, oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto4, oPC);
      DestroyObject(oAdquirido);
  }

  // QUEST DE LA ANTIPODA OSCURA, EL CADAVER DE NEDRON DESAPARECE AL COGER EL CUERPO
  if(sAdquirido == "nedroncuerpo")
  {
      DestroyObject(GetObjectByTag("corpsenedron"));
      DelayCommand(800.0, DeleteLocalInt(GetModule(), "DESAPARECERCUERPO"));
  }

  //Evitar que los vampiros puedan tocar el agua bendita o un objeto de plata.
  VampireAcquireItem();

  // Sistema de seguridad ante el pasarse objetos
  ExecuteScript("pasarse_objetos",OBJECT_SELF);

 // Los PJ no pueden poseer pocines de sanar o sangre de vampiro

 if (sAdquirido == "NW_IT_MPOTION012" || sAdquirido == "sangrevampiro")
 {
    DestroyObject(oAdquirido);
    SendMessageToPC(oPC, "Upps! .... " + GetName(oAdquirido) + " se te ha roto. Objeto no legal.");
 }
/* int iCont=0, iContVar1=0,iContVar2=0, iContVar3;
 int iMax;
 if (GetBaseItemType(oAdquirido)==BASE_ITEM_ENCHANTED_WAND || sAdquirido == "x2_it_pcwand") // || GetBaseItemType(oAdquirido)==BASE_ITEM_MAGICWAND)//(sAdquirido=="x2_it_pcwand")
 {
    if (sAdquirido == "x2_it_pcwand" && GetItemCharges(oAdquirido)>16)
    {
        SetItemCharges(oAdquirido, 16);
    }
    iMax=10;


    if (GetBaseItemType(oAdquirido)==BASE_ITEM_ENCHANTED_WAND)
    {
        iContVar2 = ContarItem(BASE_ITEM_ENCHANTED_WAND, oPC);
    }

    iCont= iContVar1 + iContVar2;

    if (iCont>iMax) //10
    {

       AssignCommand(oPC, ActionPutDownItem(oAdquirido));
       SendMessageToPC(oPC, "Upps! .... " + GetName(oAdquirido) + " se te ha caido. Sabes que no puedes tener más de " + IntToString(iMax) + " varitas de crafteo.");


    }

 }
 iCont=0;
 if (GetBaseItemType(oAdquirido)==BASE_ITEM_ENCHANTED_SCROLL) // || GetBaseItemType(oAdquirido)==BASE_ITEM_SPELLSCROLL)//(sAdquirido=="x2_it_pcscroll" || GetLocalInt(oAdquirido, "PER_CRAFT")==TRUE || GetBaseItemType(oAdquirido)==BASE_ITEM_SCROLL))
 {
    iMax=50;


    if (GetBaseItemType(oAdquirido)==BASE_ITEM_ENCHANTED_SCROLL)
    {
        iContVar3 = ContarItem(BASE_ITEM_ENCHANTED_SCROLL, oPC);
    }

    iCont= iContVar1 + iContVar2 + iContVar3;

    if (iCont>iMax)//50
    {
       AssignCommand(oPC, ActionPutDownItem(oAdquirido));
       SendMessageToPC(oPC, "Upps! .... " + GetName(oAdquirido) + " se te ha caido. Sabes que no puedes tener más de " + IntToString(iMax) + " pergaminos de crafteo.");

    }

 }
 iCont=0;
 if (GetBaseItemType(oAdquirido)==BASE_ITEM_ENCHANTED_POTION)// || GetBaseItemType(oAdquirido)==BASE_ITEM_POTIONS)//(sAdquirido=="x2_it_pcwand")
 {
    iMax=50;

    if (GetBaseItemType(oAdquirido)==BASE_ITEM_ENCHANTED_POTION)
    {
        iContVar2 = ContarItem(BASE_ITEM_ENCHANTED_POTION, oPC);
    }

    iCont= iContVar1 + iContVar2;

    if (iCont>iMax) //50
    {
        AssignCommand(oPC, ActionPutDownItem(oAdquirido));
       SendMessageToPC(oPC, "Upps! .... " + GetName(oAdquirido) + " se te ha caido. Sabes que no puedes tener más de " + IntToString(iMax) + " pociones de crafteo.");
    }

 }  */
  //******************************************************************************
  //* Sistema Limpiador de Areas y Mercaderes
  //******************************************************************************
  if (GetIsPC(GetItemPossessor(oAdquirido)))
    {
    SetLocalInt(oAdquirido, "PCItem", 1);
    //DeleteLocalInt(oItem, "CT_DESTRUCT_TIME");
    }

    //Sistema de seguridad para rehechos.
    int iContenedor = ContarItemsInventario(oPC,CONTENEDOR_VARIABLES);
    if(iContenedor > 1 && GetIsPC(oPC) && !GetIsDM(oPC) && !GetIsDMPossessed(oPC))
    {
        SendMessageToAllDMs("!!ATENCIÓN!! EL PJ "+GetName(oPC,TRUE)+" HA RECIBIDO UN CONTENEDOR DE VARIABLES TENIENDO YA UNO ENCIMA, ACTUALMENTE TIENE "+IntToString(iContenedor)+" CONTENEDORES DE VARIABLES.");
    }

    //Sistema de quest: Obtención de un item.
    QuestAcquire (oPC, oAdquirido);
}
