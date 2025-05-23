// PELETERIA, VENDER CUEROS

void main()
{
  object oPC = GetPCSpeaker();
  int iContador100po, iContador80po, iContador40po, iContador30po, iContador10po;

  // Contador de cueros
  object oCueros = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oCueros) == TRUE)
  {
      // Cuero de piel de oso
      // Cuero de piel de draco
      if(GetTag(oCueros) == "sapo_cuero_oso" || GetTag(oCueros) == "sapo_cuero_wyrm")
      {
          iContador100po = iContador100po + 1;
          DestroyObject(oCueros);
      }

      // Cuero de piel de lobo invernal
      // Cuero de piel de can infernal
      // Cuero de piel de serpiente
      else if(GetTag(oCueros) == "sapo_cuero_loboi" || GetTag(oCueros) == "sapo_cuero_cani" || GetTag(oCueros) == "sapo_cuero_serpi")
      {
          iContador80po = iContador80po + 1;
          DestroyObject(oCueros);
      }

      // Cuero de piel de lobo
      // Cuero de piel de jabali
      // Cuero de piel de lagarto
      else if(GetTag(oCueros) == "sapo_cuero_lobo" || GetTag(oCueros) == "sapo_cuero_jabal" || GetTag(oCueros) == "sapo_cuero_lagar")
      {
          iContador40po = iContador40po + 1;
          DestroyObject(oCueros);
      }

      // Cuero de piel de ciervo
      // Cuero de piel de rothe
      else if(GetTag(oCueros) == "sapo_cuero_cierv" || GetTag(oCueros) == "sapo_cuero_rothe")
      {
          iContador30po = iContador30po + 1;
          DestroyObject(oCueros);
      }

      // Cuero de piel de rata
      // Cuero de piel de murcielago
      else if(GetTag(oCueros) == "sapo_cuero_rata" || GetTag(oCueros) == "sapo_cuero_murci")
      {
          iContador10po = iContador10po + 1;
          DestroyObject(oCueros);
      }

      oCueros = GetNextItemInInventory(oPC);
  }

  int iOro = (iContador100po * 100) + (iContador80po * 80) + (iContador40po * 40) +
             (iContador30po * 30) + (iContador10po * 10);

  if(iOro == 0) ActionSpeakString("¡No tienes cueros para mi! No me hagas perder el tiempo.");
  else
  {
      ActionSpeakString("Aquí tienes tu oro, un placer hacer tratos contigo.");
      GiveGoldToCreature(oPC, iOro);
  }
}
