void main()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   int iCantidad = GetLocalInt(oContenedor, "AICantidad");
   if(iCantidad==1)
   {
   SpeakString("La cantidad no puede ser inferior a 1!");
   }
   else
   {
   SetLocalInt(oContenedor,"AICantidad",iCantidad+1);
   }
}
