#include "dominios_inc"
#include "mti_libreria"
#include "lib_disguise"

void PenalizacionXP(object oCadaver, int iProcentage)
{
  int iTotalExp = GetXP(oCadaver);
  int iPenalizacion = (iProcentage * iTotalExp) / 100;
  int iNuevaExp = iTotalExp - iPenalizacion;

  if(iNuevaExp > 1000) SetXP(oCadaver, iNuevaExp);
  else SetXP(oCadaver, 1000);
}

void main()
{
  object oPC = GetPCSpeaker();
  object oCadaverObjetoInventario = GetLocalObject(oPC, "CAD_USADO");
  object oJugadorMuerto = GetLocalObject(oCadaverObjetoInventario, "CAD_JUGADOR");
  object oAreaJugadorMuerto = GetArea(oJugadorMuerto);
  string sAreaJugadorMuerto = GetTag(oAreaJugadorMuerto);
  int iAnimacionesPlanoFuga = GetLocalInt(oJugadorMuerto, "ANIMACIONES_PLANO_FUGA");

  // Mensajes de error
  if(sAreaJugadorMuerto != "plano_fuga" || oAreaJugadorMuerto == OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "<cþ>El jugador al que intentas resucitar no se encuentra en el Plano de la Fuga (está desconectado del servidor o cargando área). No puedes resucitarlo.</c>");
      return;
  }

  if(iAnimacionesPlanoFuga == TRUE)
  {
      SendMessageToPC(oPC, "<cþ>El jugador al que intentas resucitar se encuentra reproduciendo la secuencia cinematográfica de entrada al Plano de la Fuga (la cual dura 50 segundos). Por favor, intenta resucitarlo unos segundos más tarde.</c>");
      return;
  }

  // Calculo oro a pagar
  int iNivel = GetHitDice(oJugadorMuerto);
  int iOroRevivir = 250 * iNivel;
  string sRevivir = IntToString(iOroRevivir);

  if(GetGold(oPC) < iOroRevivir)
  {
      SendMessageToPC(oPC, "<cþ>¡No tienes las "+sRevivir+" monedas de oro necesarias para pagar el conjuro [Revivir a los muertos]!</c>");
      return;
  }

  // Obtener al clerigo de la conversacion y ejecutar sus animaciones
  object oClerigo = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oPC));
  int iUnaSolaVez = 0;
  while(GetIsObjectValid(oClerigo) == TRUE && iUnaSolaVez == 0)
  {
      if(GetLocalInt(oClerigo, "RESUCITADOR") == 1)
      {
          AssignCommand(oClerigo, ClearAllActions());
          AssignCommand(oClerigo, ActionCastFakeSpellAtObject(SPELL_RAISE_DEAD, oClerigo));
          AssignCommand(oClerigo, ActionSpeakString("¡Muy bien! Prepárate, tu amigo pronto estará de vuelta con nosotros."));
          iUnaSolaVez = 1;
      }

      oClerigo = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oPC));
  }

  // Funciones principales
  SendMessageToPC(oJugadorMuerto, "<c þ >¡"+PB_Disguise_GetNameOverride(oPC)+" ha pagado tu resurrección! Prepárate para volver al Mundo Material.</c>");
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), oJugadorMuerto);
  DelayCommand(0.4, AssignCommand(oJugadorMuerto, ClearAllActions()));
  DelayCommand(0.5, AssignCommand(oJugadorMuerto, JumpToObject(oPC)));

  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oJugadorMuerto) - 1), oJugadorMuerto);
  FloatingTextStringOnCreature("<cî>Pierdes un 3% de tu XP por la resurrección.</c>", oJugadorMuerto, FALSE);
  PenalizacionXP(oJugadorMuerto, 3);

  AssignCommand(oPC, TakeGoldFromCreature(iOroRevivir, oPC, TRUE));
  DestroyObject(oCadaverObjetoInventario);

  // Dominios de clerigo, dar o quitar objetos  segun sea el caso
  ConjurosDominios(oJugadorMuerto);

  // Reaplicar efectos
  ReaplicarEfectosPB(oJugadorMuerto,TRUE, FALSE, TRUE);

  // Evitar abuso resurreccion por deidad
  GuardarIntPersistente(oJugadorMuerto, "NORESDEIDAD", 0);
}
