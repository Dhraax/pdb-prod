//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guion:  hc_on_play_death                                  //:://
//::////////////////////////////////////////////////////////////////////////////
//:: GUION ORIGINAL HCR 3.3b                                              //:://
//:: Modificado para el servidor Puerta de Baldur                         //:://
//::////////////////////////////////////////////////////////////////////////////
#include "hc_inc_gods"
#include "x0_i0_petrify"
#include "dote_atenuado2"


void main()
{
  object oJugador = GetLastPlayerDied();
  object oKiller = GetLastAttacker(oJugador);
  string sName   = GetName(oJugador, TRUE);
  string sPCName = GetPCPlayerName(oJugador);
  string sID     = GetPlayerID(oJugador);
  effect eDesaparecer = EffectDisappear();

  // DAÑO ATENUADO
  if(CheckSubdual(oJugador)) return;
  DeleteLocalInt(oJugador, "BEATEN_TO_DEATH");
  DeleteLocalInt(oJugador, "nSubdued");

  // DESMONTAR TIENDA AL MORIR, (si la tiene)
  EliminarUbicadosTJ(oJugador);

  // REGENERACION EN ARENAS
  if(GetLocalInt(oJugador, "ARENA") > 0)
  {
      DelayCommand(2.5, PopUpDeathGUIPanel(oJugador, TRUE, FALSE, 0, "Has muerto dentro en una Arena. Regenera para resucitar en esta misma area sin penalización alguna."));
      return;
  }

    // REGENERACION EN CAMPO DE BATALLA
  if(GetLocalInt(oJugador, "CAMPOBATALLA") > 0)
  {
    if(GetIsObjectValid(GetMaster(oKiller)))
    {
        oKiller = GetMaster(oKiller);
    }
    if(GetIsPC(oKiller))
        {
         DelayCommand(0.5, SendMessageToPC(oJugador, "Has muerto dentro en un Campo de Batalla. Regenera para resucitar en la zona de inicio."));
        }
    else DeleteLocalInt(oJugador, "CAMPOBATALLA");
  }


  // AVISO DE CUANDO UN JUGADOR MATA A OTRO
  if(GetIsPC(oKiller)) SendMessageToAllDMs("MUERTE DE JUGADOR: " + sName + " fue asesinado por " + GetName(oKiller, TRUE));

  // TORRE DE AMNAGUA
  if(GetLocalInt(oJugador, "NIVELTORRE") > 0)
  {
       DeleteLocalInt(GetModule(), "TORREOCUPADA");
       DeleteLocalInt(oJugador, "NIVELTORRE");

       object oMonst1 = GetNearestObjectByTag("GETURAK", oJugador);
       object oMonst2 = GetNearestObjectByTag("DTURAK", oJugador);
       object oMonst3 = GetNearestObjectByTag("GATURAK", oJugador);
       object oMonst4 = GetNearestObjectByTag("ATURAK", oJugador);
       object oMonst5 = GetNearestObjectByTag("MTURAK", oJugador);
       object oMonst6 = GetNearestObjectByTag("GOTURAK", oJugador);

       DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oMonst1));
       DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oMonst2));
       DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oMonst3));
       DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oMonst4));
       DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oMonst5));
       DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oMonst6));
  }

  // MAGA ZAPATILLAS SUBE
  if(GetLocalInt(oJugador, "ESTOYENZAPSUNE") == 1)
  {
      DeleteLocalInt(oJugador, "ESTOYENZAPSUNE");
      object oArmario = GetObjectByTag("armario_entrada_zs");
      effect eArmarioEfecto = EffectVisualEffect(VFX_FNF_PWSTUN);
      RemoveEffectOfType(oArmario,EFFECT_TYPE_VISUALEFFECT);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eArmarioEfecto, oArmario);
      DeleteLocalInt(oArmario, "GUARDIA_SUNE_MAGA");
  }

  // DROWS, PLANO THORMALLEM
  if(GetLocalInt(oJugador, "ESTOYENTHORMALLEM") == 1)
  {
       DeleteLocalInt(GetModule(), "THORMALLEMOCUPAO");
       DeleteLocalInt(oJugador, "ESTOYENTHORMALLEM");
  }

  // DROWS, PLANO THORMALLEM 2
  if(GetLocalInt(oJugador, "ESTOYENTHORMALLEM2") == 1)
  {
       DeleteLocalInt(GetModule(), "THORMALLEMOCUPAO2");
       DeleteLocalInt(oJugador, "ESTOYENTHORMALLEM2");
  }

  // RESURRECCION POR DEIDAD (5% + 1/4 * Nivel)
  if(ObtenerIntPersistente(oJugador, "NORESDEIDAD") == 0)
  {if(ResurrecionDeidad(oJugador)) return;}

  // PANTALLA DE REGENERAR
  DelayCommand(2.5, PopUpDeathGUIPanel(oJugador, TRUE, TRUE, 0, "Ya no respiras y pronto serás enviado al otro mundo. Tu aventura acaba aquí a no ser que algún clérigo resucite tu cuerpo sin vida o pruebes suerte en el más allá."));

  // RESETEAR last recovery check time and last rest time.
  DeletePersistentInt(oMod, "LastRecCheck" + sID);
  DeletePersistentInt(oMod, "LastRest" + sID);

  // ELIMINAR LOS SERVICIOS DE LOS AYUDANTES AL MORIR
  object oAyudante1 = GetHenchman(oJugador, 1);
  object oAyudante2 = GetHenchman(oJugador, 2);
  object oAyudante3 = GetHenchman(oJugador, 3);
  object oAyudante4 = GetHenchman(oJugador, 4);
  if(oAyudante1 != OBJECT_INVALID)
  {
    RemoveHenchman(oJugador, oAyudante1); AssignCommand(oAyudante1, SetIsDestroyable(TRUE,FALSE,FALSE));
    if(GetLocalInt(oAyudante1, "Ayudante_NoBorrar") != 1){DestroyObject(oAyudante1, 0.5);}
  }
  if(oAyudante2 != OBJECT_INVALID)
  {
    RemoveHenchman(oJugador, oAyudante2); AssignCommand(oAyudante2, SetIsDestroyable(TRUE,FALSE,FALSE));
    if(GetLocalInt(oAyudante2, "Ayudante_NoBorrar") != 1){DestroyObject(oAyudante2, 0.5);}
  }
  if(oAyudante3 != OBJECT_INVALID)
  {
    RemoveHenchman(oJugador, oAyudante3); AssignCommand(oAyudante3, SetIsDestroyable(TRUE,FALSE,FALSE));
    if(GetLocalInt(oAyudante3, "Ayudante_NoBorrar") != 1){DestroyObject(oAyudante3, 0.5);}
  }
  if(oAyudante4 != OBJECT_INVALID)
  {
    RemoveHenchman(oJugador, oAyudante4); AssignCommand(oAyudante4, SetIsDestroyable(TRUE,FALSE,FALSE));
    if(GetLocalInt(oAyudante4, "Ayudante_NoBorrar") != 1){DestroyObject(oAyudante4, 0.5);}
  }
  // ELIMINAR EL INDETECTABILIDAD
  if (ObtenerIntPersistente(oJugador, "INDETECTABLE") == 1)
  {
        GuardarIntPersistente(oJugador, "INDETECTABLE",0);
  }

}
