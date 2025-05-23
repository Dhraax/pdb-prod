// PELETERIA, VENDER PIELES

void main()
{
  object oPC = GetPCSpeaker();
  int iContador50po, iContador40po, iContador20po, iContador15po, iContador5po;

  // Contador de pieles
  object oPieles = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oPieles) == TRUE)
  {
      // Piel de oso
      // Piel de draco
      if(GetTag(oPieles) == "pieldeoso" || GetTag(oPieles) == "pieldewyrm")
      {
          iContador50po = iContador50po + 1;
          DestroyObject(oPieles);
      }

      // Piel de lobo invernal
      // Piel de can infernal
      // Piel de serpiente
      else if(GetTag(oPieles) == "pieldeloboinvern" || GetTag(oPieles) == "pieldecani" || GetTag(oPieles) == "pieldeserpiente")
      {
          iContador40po = iContador40po + 1;
          DestroyObject(oPieles);
      }

      // Piel de lobo
      // Piel de jabali
      // Piel de lagarto
      else if(GetTag(oPieles) == "pieldelobo" || GetTag(oPieles) == "pieldejabali" || GetTag(oPieles) == "pieldelagar")
      {
          iContador20po = iContador20po + 1;
          DestroyObject(oPieles);
      }

      // Piel de ciervo
      // Piel de rothe
      else if(GetTag(oPieles) == "pieldeciervo" || GetTag(oPieles) == "pielderothe")
      {
          iContador15po = iContador15po + 1;
          DestroyObject(oPieles);
      }

      // Piel de rata
      // Piel de murcielago
      else if(GetTag(oPieles) == "pielderata" || GetTag(oPieles) == "pellejoderata" || GetTag(oPieles) == "pieldemurci")
      {
          iContador5po = iContador5po + 1;
          DestroyObject(oPieles);
      }

      oPieles = GetNextItemInInventory(oPC);
  }

  int iOro = (iContador50po * 120) + (iContador40po * 70) + (iContador20po * 40) +
             (iContador15po * 25) + (iContador5po * 10);

  if(iOro == 0) ActionSpeakString("¡No tienes pieles para mi! No me hagas perder el tiempo.");
  else
  {
      ActionSpeakString("Aquí tienes tu oro, un placer hacer tratos contigo.");
      GiveGoldToCreature(oPC, iOro);
  }
}
