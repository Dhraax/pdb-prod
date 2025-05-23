void main()
{
   int nCount = GetLocalInt(OBJECT_SELF,"DR_HBCount");
   if(nCount == 0){
      // hacer ke el npc se gire hacia el portal
      SetFacingPoint(GetPosition(GetNearestObjectByTag("tag_bodhi")));

      //todas las animaciones que se pueden hacer comienzan por ANIMATION_LOOPING_
        ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP,1.0,30.0);
//      ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE,1.0,60.0);
      nCount++;
   }
   else if(nCount < 5 && nCount > 0){
      nCount++;
   }
   else{
      nCount = 0;
   }
   SetLocalInt(OBJECT_SELF,"DR_HBCount",nCount);
}

