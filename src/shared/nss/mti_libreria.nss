#include "x2_inc_itemprop"

//::////////////////////////////////////////////////////////////////////////:://
//::// LIBRERIA PERSONALIZADA DE MONTI                                    //:://
//::////////////////////////////////////////////////////////////////////////:://

const string CONTENEDOR_VARIABLES = "dmfi_pc_emote";
const string TXT_COLOR_GRIS       = "<c°°°>";
const string TXT_COLOR_BLANCO     = "<cóóó>";
const string TXT_COLOR_CELESTE    = "<c óó>";
const string TXT_COLOR_MAGENTA    = "<có ó>";
const string TXT_COLOR_AMARILLO   = "<cóó >";
const string TXT_COLOR_ROJO       = "<có  >";
const string TXT_COLOR_VERDE      = "<c ó >";
const string TXT_COLOR_AZUL       = "<c  ó>";
const string TXT_COLOR_NINGUNO    = "";
const string TXT_COLOR_FINAL      = "</c>";
const string TXT_COLOR_ESTANDARD  = TXT_COLOR_CELESTE;

void Teletransporte(object oPC, location lLugar)
{
  DelayCommand(0.4, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC));
  DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC));
  DelayCommand(1.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC));
  DelayCommand(1.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC));
  DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC));
  DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC));
  DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC));
  DelayCommand(3.2, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(3.3, AssignCommand(oPC, ActionJumpToLocation(lLugar)));
}

void Teletransporte2(object oPC, location lLugar)
{
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(55), oPC);
  if(GetHasFeat(1366,oPC)){ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_DARKNESS), oPC);}
  DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(52), oPC));
  DelayCommand(0.5, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(0.6, AssignCommand(oPC, ActionJumpToLocation(lLugar)));
  if(GetLocalInt(oPC, "RUTASOMBRAS") == TRUE) //Curación Brujo Ruta de las Sombras
    {
      int nDG = (GetMaxHitPoints(oPC)/2);
      effect eHeal = EffectHeal(nDG);
      effect eVis = EffectVisualEffect(VFX_IMP_HEALING_G);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
      SetLocalInt(oPC, "RUTASOMBRAS", FALSE);
    }
}

void GuardarIntPersistente(object oJugador, string sVariable, int iValor)
{
  if(!GetIsPC(oJugador)) return;
  object oVarita = GetItemPossessedBy(oJugador, CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) SetLocalInt(oVarita, sVariable, iValor);
}

int ObtenerIntPersistente(object oJugador, string sVariable)
{
  if(!GetIsPC(oJugador)) return 0;
  int iValor = 0;
  object oVarita = GetItemPossessedBy(oJugador, CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) iValor = GetLocalInt(oVarita, sVariable);
  return iValor;
}

void BorrarIntPersistente(object oJugador, string sVariable)
{
  if(!GetIsPC(oJugador)) return;
  object oVarita = GetItemPossessedBy(oJugador, CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) DeleteLocalInt(oVarita, sVariable);
}

void GuardarStringPersistente(object oJugador, string sVariable, string sValor)
{
  if(!GetIsPC(oJugador)) return;
  object oVarita = GetItemPossessedBy(oJugador,CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) SetLocalString(oVarita, sVariable, sValor);
}

string ObtenerStringPersistente(object oJugador, string sVariable)
{
  if(!GetIsPC(oJugador)) return "";
  string sValor = "";
  object oVarita = GetItemPossessedBy(oJugador, CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) sValor = GetLocalString(oVarita, sVariable);
  return sValor;
}

void BorrarStringPersistente(object oJugador, string sVariable)
{
  if(!GetIsPC(oJugador)) return;
  object oVarita = GetItemPossessedBy(oJugador, CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) DeleteLocalString(oVarita, sVariable);
}

void GuardarFloatPersistente(object oJugador, string sVariable, float fValor)
{
  if(!GetIsPC(oJugador)) return;
  object oVarita = GetItemPossessedBy(oJugador, CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) SetLocalFloat(oVarita, sVariable, fValor);
}

float ObtenerFloatPersistente(object oJugador, string sVariable)
{
  if(!GetIsPC(oJugador)) return 0.0f;
  float fValor = 0.0f;
  object oVarita = GetItemPossessedBy(oJugador, CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) fValor = GetLocalFloat(oVarita, sVariable);
  return fValor;
}

void BorrarFloatPersistente(object oJugador, string sVariable)
{
  if(!GetIsPC(oJugador)) return;
  object oVarita = GetItemPossessedBy(oJugador, CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) DeleteLocalFloat(oVarita, sVariable);
}

void GuardarLocationPersistente(object oJugador, string sVariable, location lValor)
{
  if(!GetIsPC(oJugador)) return;
  object oVarita = GetItemPossessedBy(oJugador, CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) SetLocalLocation(oVarita, sVariable, lValor);
}

location ObtenerLocationPersistente(object oJugador, string sVariable) //Cuidado con esta, mejor asegurarse de que existe la posicion.
{
  location lValor;
  object oVarita = GetItemPossessedBy(oJugador, CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) lValor = GetLocalLocation(oVarita, sVariable);
  return lValor;
}

void BorrarLocationPersistente(object oJugador, string sVariable)
{
  if(!GetIsPC(oJugador)) return;
  object oVarita = GetItemPossessedBy(oJugador, CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) DeleteLocalLocation(oVarita, sVariable);
}

string ColorTexto(string sTexto, string sColor)
{
  return sColor + sTexto + TXT_COLOR_FINAL;
}

int ObtenerBonificadorMejoraPermanente(object oWeapon)
{
  itemproperty ip = GetFirstItemProperty(oWeapon);
  int nFound = 0;
  while(nFound == 0 && GetIsItemPropertyValid(ip))
  {
      if(GetItemPropertyType(ip) == ITEM_PROPERTY_AC_BONUS &&
         GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
      {
          nFound = GetItemPropertyCostTableValue(ip);
      }
      ip = GetNextItemProperty(oWeapon);
  }
  return nFound;
}

int GetArmorType(object oArmor)
{
    // Make sure the item is valid and is an armor.
    if (!GetIsObjectValid(oArmor))
        return -1;
    if (GetBaseItemType(oArmor) != BASE_ITEM_ARMOR)
        return -1;

    // Get the identified flag for safe keeping.
    int bIdentified = GetIdentified(oArmor);
    SetIdentified(oArmor,FALSE);
    int eraTrama=GetPlotFlag(oArmor);
    if(eraTrama) SetPlotFlag(oArmor, FALSE);
    int nType = -1;
    switch (GetGoldPieceValue(oArmor))
    {
        case    1: nType = 0; break; // None
        case    5: nType = 1; break; // Padded
        case   10: nType = 2; break; // Leather
        case   25: nType = 3; break; // Studded Leather / Hide
        case  100: nType = 4; break; // Chain Shirt / Scale Mail
        case  200: nType = 5; break; // Chainmail / Breastplate
        case  250: nType = 6; break; // Splint Mail / Banded Mail
        case  600: nType = 7; break; // Half-Plate
        case 1500: nType = 8; break; // Full Plate
    }
    // Restore the identified flag, and return armor type.
    SetIdentified(oArmor,bIdentified);
    if(eraTrama) SetPlotFlag(oArmor, TRUE);
    return nType;
}

void ManualHerboristeria(object oPC){
   SendMessageToPC(oPC, "<cþ>Puntuación en Recolección: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELRECOLECCION")) + "</c></c>");
   SendMessageToPC(oPC, "<cþ>Puntuación en Cocina: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELCOCINA")) + "</c></c>");
   SendMessageToPC(oPC, "<cþ>Puntuación en Herbología: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELHERBOLOGIA")) + "</c></c>");
   SendMessageToPC(oPC, "<cþ>Puntuación en Alquimia: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELALQUIMIA")) + "</c></c>");
}

void ManualHerreria(object oPC){
   SendMessageToPC(oPC, "<cþ>Puntuación en Minería: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELMINERIA")) + "</c></c>");
   SendMessageToPC(oPC, "<cþ>Puntuación en Fundición: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELFUNDICION")) + "</c></c>");
   SendMessageToPC(oPC, "<cþ>Puntuación en Herrería: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELHERRERIA")) + "</c></c>");
}

void ManualCarpinteria(object oPC){
   SendMessageToPC(oPC, "<cþ>Puntuación en Tala de árboles: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELLENYADOR")) + "</c></c>");
   SendMessageToPC(oPC, "<cþ>Puntuación en Serrería: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELSERRERIA")) + "</c></c>");
   SendMessageToPC(oPC, "<cþ>Puntuación en Carpintería: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELCARPINTERIA")) + "</c></c>");
}

void ManualOrfebreria(object oPC){
   SendMessageToPC(oPC, "<cþ>Puntuación en Tallado de gemas: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELTALLADOR")) + "</c></c>");
   SendMessageToPC(oPC, "<cþ>Puntuación en Engarce: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELENGARZADOR")) + "</c></c>");
}

int CalculoSiguienteNivelXPEsenciacion2(int iNivelArtesano)
{
  return iNivelArtesano * (iNivelArtesano + 1) * 50;
}

int CalculoSiguienteNivelXPInfusionamiento2(int iNivelArtesano)
{
  return iNivelArtesano * (iNivelArtesano + 1) * 75;
}

int CalculoSiguienteNivelXPArtesaniaUrdimbrica2(int iNivelArtesano)
{
  return iNivelArtesano * (iNivelArtesano + 1) * 100;
}

void ManualArtesaniaUrdimbrica(object oPC){
   SendMessageToPC(oPC, "<cþ>Puntuación en Esenciación: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "Profesion8")) + "</c></c>");
   SendMessageToPC(oPC,"<cÍþ>Experiencia en Esenciación: <c´þd>"+IntToString(ObtenerIntPersistente(oPC, "Profesion8XP"))+"/"+IntToString(CalculoSiguienteNivelXPEsenciacion2(ObtenerIntPersistente(oPC, "Profesion8")))+".</c></c>");
   SendMessageToPC(oPC, "<cþ>Puntuación en Infusión: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "Profesion11")) + "</c></c>");
   SendMessageToPC(oPC,"<cÍþ>Experiencia en Infusión: <c´þd>"+IntToString(ObtenerIntPersistente(oPC, "Profesion11XP"))+"/"+IntToString(CalculoSiguienteNivelXPInfusionamiento2(ObtenerIntPersistente(oPC, "Profesion11")))+".</c></c>");
   SendMessageToPC(oPC, "<cþ>Puntuación en Artesania Urdímbrica: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "Profesion15")) + "</c></c>");
   SendMessageToPC(oPC,"<cÍþ>Experiencia en Artesania Urdímbrica: <c´þd>"+IntToString(ObtenerIntPersistente(oPC, "Profesion15XP"))+"/"+IntToString(CalculoSiguienteNivelXPArtesaniaUrdimbrica2(ObtenerIntPersistente(oPC, "Profesion15")))+".</c></c>");
}

void ManualPeleteria(object oPC){
   SendMessageToPC(oPC, "<cþ>Puntuación en Despellejador: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "NIVELDESOLLADOR")) + "</c></c>");
   SendMessageToPC(oPC, "<cþ>Puntuación en Curtiduría: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "Profesion9")) + "</c></c>");
   SendMessageToPC(oPC, "<cþ>Puntuación en Marroquinería: <c´þd>"+ IntToString(ObtenerIntPersistente(oPC, "Profesion12")) + "</c></c>");

}

void EliminarEfectosSobrenaturales(object oPC)
{
  effect eEfecto = GetFirstEffect(oPC);
  while(GetIsEffectValid(eEfecto))
    {
        //Efectos sobrenaturales que no queremos eliminar, nivel negativo, ni maldito.
        if(GetEffectSubType(eEfecto) == SUBTYPE_SUPERNATURAL
            && GetEffectType(eEfecto) != EFFECT_TYPE_CURSE
            && GetEffectType(eEfecto) != EFFECT_TYPE_NEGATIVELEVEL)
        RemoveEffect(oPC, eEfecto);
        eEfecto = GetNextEffect(oPC);
    }

   //Antiapilamiento a 0
   GuardarIntPersistente(oPC, "bSubRaza", 0);
   SetLocalInt(oPC, "BONOS_ESCUDO", 0);
   GuardarIntPersistente(oPC, "bReduccion_Vel",0);
}

void ReaplicarEfectosPB(object oPC, int iEfectosSubraza = FALSE, int iEventoEquipar = FALSE, int iEquiparEscudo = TRUE, int iEsEscudo = FALSE)
{

  if(iEfectosSubraza == TRUE)
  EliminarEfectosSobrenaturales(oPC);

  if(iEventoEquipar == TRUE) SetLocalInt(oPC, "PB_EFECTOS_EVENTO_EQUIPAR", TRUE);

    // 1. Competencias con armaduras
    ExecuteScript("dote_comp_armadu", oPC);

    if(GetLocalInt(oPC, "PJ_SALIO")==0)
    {
        // 2. Velocidad de las armaduras (ANULADO EL EFECTO DE REDUCCION)
        if(ObtenerIntPersistente(oPC, "CAB_MONTADO") == 0 && iEsEscudo == FALSE)
        {
            ExecuteScript("pb_velarmadura", oPC);
        }
    }

    if (iEquiparEscudo==TRUE)
    // 3. Competencias con escudos
    ExecuteScript("dote_comp_escuds", oPC);

    // 4. Efectos de las monturas
    if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0 )
    {
     ExecuteScript("pb_monturas", oPC);
    }

    // 5. Efectos de las subrazas y Dotes Pasivas
    if(ObtenerIntPersistente(oPC, "bSubRaza") == 0)
    {
        ExecuteScript("pb_subrazas", oPC);
        ExecuteScript("pb_dotespas", oPC);
        if(ObtenerIntPersistente(oPC, "Poder_activo") == 1) ExecuteScript("pb_setpoderes", oPC);
        //8. Clase Cavalier
        if(GetLevelByClass(52, oPC) > 0 )
        ExecuteScript("ms_leto_cavalier", oPC);
    }

    // 6. Efectos de las subrazas (vampiro)
    if(GetStringLowerCase(GetSubRace(oPC)) == "vampiro" && iEfectosSubraza == TRUE)
    {
        ExecuteScript("pb_subvampiro", oPC);
    }

    // 7. Danyo atenuado (va por variable+efectos y mejor ponerlo aqui)
    if(GetLocalInt(oPC, "SUBDUAL")) ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(4)), oPC);
}

// /////////////////////////////////////////////////////////////////////////////
// ContarItemsInventario
// Devuelve el numero de items sItem en el inventario de oTarget, tiene en cuenta stacks
// Ripeado y modificado de nw_i0_plot
// Hacer que cuente todos o algunos, por tipo, etc
// /////////////////////////////////////////////////////////////////////////////
int ContarItemsInventario(object oTarget,string sItem, int iTipoBase = -1);
int ContarItemsInventario(object oTarget,string sItem, int iTipoBase = -1)
{
    int nNumItems = 0;object oItem = GetFirstItemInInventory(oTarget);
    while (oItem!=OBJECT_INVALID)
    {
        if (iTipoBase>0)
        {
            if (GetBaseItemType(oItem)==iTipoBase){nNumItems = nNumItems + GetNumStackedItems(oItem);}
        }
        else if (GetTag(oItem) == sItem)
        {
            nNumItems = nNumItems + GetNumStackedItems(oItem);
        }
        else if (sItem == "")
        {
            nNumItems = nNumItems + GetNumStackedItems(oItem);
        }
        oItem = GetNextItemInInventory(oTarget);
    }
    return nNumItems;
}

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// DestruirItemsInventario
// Destruye el inventario de un objeto.
// Opcion:
// 1 = Todo
// 2 = 1 Item sItem
// 3 = Todos los items sItem
// 4 = X Items sItem
// Tambien destruye por tipo de objeto (potis, anillos, armas, etc)
// Ejemplos:
// Destruir todo el inventario
// Destruir X potis del inventario, o todas, etc.
// /////////////////////////////////////////////////////////////////////////////
void DestruirItemsInventario(object oTarget = OBJECT_SELF, string sItem = "", int Opcion = 1, int NumItems = 1, int iTipoBase = BASE_ITEM_INVALID);
void DestruirItemsInventario(object oTarget = OBJECT_SELF, string sItem = "", int Opcion = 1, int NumItems = 1, int iTipoBase = BASE_ITEM_INVALID)
{
    int iNumItemsDestruidos = 0;
    int iConteoItems        = ContarItemsInventario(oTarget, sItem);
    object oItem            = GetFirstItemInInventory(oTarget);
    int iStackSize          = 0;
    int iTmp                = 0;
    int i=0;

    while (oItem!=OBJECT_INVALID)
    {
        switch(Opcion)
        {
            //Destruir todo el inventario ------------------------------
            case 1:
                    SetPlotFlag(oItem,FALSE);/*SetIsDestroyable(TRUE,FALSE,FALSE);*/
                    DestroyObject(oItem,0.0f);
                    break;
            //Destruir 1 item sItem y salir ----------------------------
            case 2:
                        if (GetTag(oItem) == sItem)
                        {
                            SetPlotFlag(oItem,FALSE);
                            if (GetNumStackedItems(oItem)>1){SetItemStackSize(oItem,GetNumStackedItems(oItem)-1);}else{DestroyObject(oItem,0.0f);}
                            return;
                        }
                    break;
            //Destruir todos los items sItem ---------------------------
            case 3:
                        //Contamos los items
                        if (iNumItemsDestruidos>=iConteoItems){return;}
                        if (GetTag(oItem) == sItem){SetPlotFlag(oItem,FALSE);DestroyObject(oItem,0.0f);iNumItemsDestruidos++;}
                    break;
            //Destruir NumItems sItem teniendo en cuenta stack. Me cago en los stacks. ----------------------------------
            case 4:
                    {
                        if (iNumItemsDestruidos>=NumItems){return;}
                        else
                        {
                            if (GetTag(oItem) == sItem)
                            {
                                i = i + 1;
                                SendMessageToPC(GetFirstPC(), "Recorriendo Objeto iNum: "+IntToString(i));
                                SetPlotFlag(oItem,FALSE);
                                iStackSize = GetNumStackedItems(oItem);
                                SendMessageToPC(GetFirstPC(), "StackSize: "+IntToString(iStackSize)+". Tag: "+sItem);
                                if (iStackSize==1 || iStackSize==0)
                                {
                                    DestroyObject(oItem,0.0f);
                                    iNumItemsDestruidos = iNumItemsDestruidos + 1;
                                    SendMessageToPC(GetFirstPC(), "ItemsDestruidos: "+IntToString(iNumItemsDestruidos));
                                }
                                else if (iStackSize==NumItems)
                                {
                                    DestroyObject(oItem,0.0f);
                                    iNumItemsDestruidos = iNumItemsDestruidos + iStackSize;
                                    SendMessageToPC(GetFirstPC(), "ItemsDestruidosFullStack: "+IntToString(iNumItemsDestruidos));
                                    return;
                                }
                                else if (iStackSize>NumItems)
                                {
                                    iTmp = iStackSize - (NumItems-iNumItemsDestruidos);
                                    SetItemStackSize(oItem, iTmp);
                                    iNumItemsDestruidos = iNumItemsDestruidos + NumItems;
                                    SendMessageToPC(GetFirstPC(), "ItemsDestruidosPlusStack: "+IntToString(iNumItemsDestruidos));
                                    return;
                                }
                                else if (iStackSize<NumItems)
                                {
                                    if (iStackSize>(NumItems-iNumItemsDestruidos)){SetItemStackSize(oItem, iStackSize-(NumItems-iNumItemsDestruidos));}
                                    else
                                    {
                                        DestroyObject(oItem,0.0f);
                                    }
                                    iNumItemsDestruidos = iNumItemsDestruidos + iStackSize;
                                    SendMessageToPC(GetFirstPC(), "ItemsDestruidosPartialStack: "+IntToString(iNumItemsDestruidos));
                                }
                             }
                        }
                    }
                    break;
            //Destruir todos los items de BASE_ITEM_* =  iTipoBase ----------------------------------
            case 5:
                    {
                        if (GetBaseItemType(oItem) == iTipoBase){SetPlotFlag(oItem,FALSE);DestroyObject(oItem,0.0f);}
                    }
                    break;
            //Destruir NumItems items de BASE_ITEM_* =  iTipoBase --ejemplo destruye random d3 potis bwahaha . util para TDHLevelUp, ya que suele inundar de potis ------
            case 6:
                    {
                        if (iNumItemsDestruidos>=NumItems){return;}
                        else
                        {
                        if (GetBaseItemType(oItem) == iTipoBase){SetPlotFlag(oItem,FALSE);DestroyObject(oItem,0.0f);iNumItemsDestruidos++;}
                        }
                    }
                    break;
         }//switch
        oItem = GetNextItemInInventory(oTarget);
    }
}

void DestruirItemEquipados (object oPC);
void DestruirItemEquipados (object oPC)
{
    //Miramos los Slots, copiamos el objeto a la nueva criatura y le equipamos la armadura.
    int iLoop = 0;
    while (iLoop < 14)
    {
        object oItemSlots = GetItemInSlot(iLoop, oPC);
        if(GetIsObjectValid(oItemSlots))
        {
            DestroyObject(oItemSlots);
        }
        iLoop++;
    }
}

//Busca si tiene el objeto en el inventario
int SiObjetoInventario(object oContainer, string sItemTag);
int SiObjetoInventario(object oContainer, string sItemTag)
{
object oItem;

if (GetHasInventory(oContainer))
{
    oItem = GetFirstItemInInventory(oContainer);
    while ( OBJECT_INVALID != oItem )
    {
        if (GetTag(oItem) == sItemTag)
        { return TRUE; }
        oItem = GetNextItemInInventory(oContainer);
    } // end while
} // endif
return FALSE;
} // end IsInInventory

//Apartado antiregeneración de DMs.
//Borramos la regeneración del item.
void BorrarReg(object oItem)
{
    itemproperty iprop = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(iprop))
    {
        if((GetItemPropertyType(iprop) == ITEM_PROPERTY_REGENERATION) && (GetItemPropertyDurationType(iprop)== DURATION_TYPE_PERMANENT ))
        {
            int iCantidad = GetItemPropertyCostTableValue(iprop);
            SetLocalInt(oItem,"RegeneracionEliminada",iCantidad);
            RemoveItemProperty(oItem, iprop);
        }
        iprop = GetNextItemProperty(oItem);
    }
}

//Devolvemos la regeneración de un item.
void AplicarReg(object oItem, int UnEquip = FALSE)
{
    if(GetLocalInt(oItem,"RegeneracionEliminada") > 0 && UnEquip == FALSE)
    {
        int iCantidad = GetLocalInt(oItem,"RegeneracionEliminada");
        IPSafeAddItemProperty(oItem, ItemPropertyRegeneration(iCantidad));
    }
}

//Aplicamos o desaplicamos la regeneración.
void NoRegeneracionEquip (object oObjetivo, int UnEquip = FALSE)
{
    object oItem;
    int nSlot;

    for (nSlot = INVENTORY_SLOT_HEAD; nSlot <= INVENTORY_SLOT_CWEAPON_R; nSlot++)
    {
        oItem = GetItemInSlot(nSlot, oObjetivo);
        if (GetIsObjectValid(oItem))
        {
            if(GetLocalInt(oObjetivo, "dm_noreg") == 1)
            {
                BorrarReg(oItem);
            }
            //if(GetLocalInt(oObjetivo, "dm_noreg") == 0)
            //{
            //    AplicarReg(oItem, UnEquip);
            //}
        }
    }
}

//void main(){}
