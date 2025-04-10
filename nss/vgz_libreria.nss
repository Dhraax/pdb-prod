//GEOMETRIA PARA CHUPICONJUROS:

void pentagramahaciasi(location lTargetLoc, int nBeamFX=VFX_BEAM_EVIL, float fDuration=4.0, float fRate = 0.4, float nScale=0.3);
void pentaculo(location lTargetLoc, int nBeamFX=VFX_BEAM_EVIL, float fDuration=4.0, float fRate = 0.4, float nScale=0.3);
void pentaano(location lTargetLoc, float fRate = 0.4, float nScale=0.3);
void pentagramahaciasi(location lTargetLoc, int nBeamFX=VFX_BEAM_EVIL, float fDuration=4.0, float fRate = 0.4, float nScale=0.3)
{
        // Get center
        object oArea = GetAreaFromLocation(lTargetLoc);
        // Define vertices for pentagram
        vector v = GetPositionFromLocation(lTargetLoc);
        v = Vector(v.x,v.y+7.0*nScale,v.z);
        location l1= Location(oArea,v,0.0);
        v = Vector(v.x-4.0*nScale,v.y-12.5*nScale,v.z);
        location l2= Location(oArea,v,0.0);
        v = Vector(v.x+10.5*nScale,v.y+8.0*nScale,v.z);
        location l3= Location(oArea,v,0.0);
        v = Vector(v.x-13*nScale,v.y,v.z);
        location l4= Location(oArea,v,0.0);
        v = Vector(v.x+10.5*nScale,v.y-8.0*nScale,v.z);
        location l5= Location(oArea,v,0.0);
        location l6 = GetLocation(OBJECT_SELF);
        // Create verticies objects
        object oS1 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l1);
        object oS2 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l2);
        object oS3 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l3);
        object oS4 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l4);
        object oS5 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l5);
        object oS6 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l6);
        // Connect vertices with beams
        effect eVis1 = EffectBeam(nBeamFX,oS1,BODY_NODE_CHEST);
        effect eVis2 = EffectBeam(nBeamFX,oS2,BODY_NODE_CHEST);
        effect eVis3 = EffectBeam(nBeamFX,oS3,BODY_NODE_CHEST);
        effect eVis4 = EffectBeam(nBeamFX,oS4,BODY_NODE_CHEST);
        effect eVis5 = EffectBeam(nBeamFX,oS5,BODY_NODE_CHEST);
        effect eVis6 = EffectBeam(nBeamFX,oS6,BODY_NODE_CHEST);
        // Make pentagram visible
        //ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis1,oS2,fDuration);
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis2,oS6,fDuration));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis3,oS6,fDuration));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis4,oS6,fDuration));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis5,oS6,fDuration));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis6,oS1,fDuration));
        // Remove objects
        DelayCommand(fDuration,DestroyObject(oS1));
        DelayCommand(fDuration,DestroyObject(oS2));
        DelayCommand(fDuration,DestroyObject(oS3));
        DelayCommand(fDuration,DestroyObject(oS4));
        DelayCommand(fDuration,DestroyObject(oS5));
        DelayCommand(fDuration,DestroyObject(oS6));
}

void pentaculo(location lTargetLoc, int nBeamFX=VFX_BEAM_EVIL, float fDuration=4.0, float fRate = 0.4, float nScale=0.3)
{
        // Get center
        object oArea = GetAreaFromLocation(lTargetLoc);
        // Define vertices for pentagram
        vector v = GetPositionFromLocation(lTargetLoc);
        v = Vector(v.x,v.y+7.0*nScale,v.z);
        location l1= Location(oArea,v,0.0);
        v = Vector(v.x-4.0*nScale,v.y-12.5*nScale,v.z);
        location l2= Location(oArea,v,0.0);
        v = Vector(v.x+10.5*nScale,v.y+8.0*nScale,v.z);
        location l3= Location(oArea,v,0.0);
        v = Vector(v.x-13*nScale,v.y,v.z);
        location l4= Location(oArea,v,0.0);
        v = Vector(v.x+10.5*nScale,v.y-8.0*nScale,v.z);
        location l5= Location(oArea,v,0.0);

        // Create verticies objects
        object oS1 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l1);
        object oS2 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l2);
        object oS3 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l3);
        object oS4 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l4);
        object oS5 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l5);

        // Connect vertices with beams
        effect eVis1 = EffectBeam(nBeamFX,oS1,BODY_NODE_CHEST);
        effect eVis2 = EffectBeam(nBeamFX,oS2,BODY_NODE_CHEST);
        effect eVis3 = EffectBeam(nBeamFX,oS3,BODY_NODE_CHEST);
        effect eVis4 = EffectBeam(nBeamFX,oS4,BODY_NODE_CHEST);
        effect eVis5 = EffectBeam(nBeamFX,oS5,BODY_NODE_CHEST);

        // Make pentagram visible
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis1,oS4,fDuration));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis2,oS5,fDuration));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis3,oS1,fDuration));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis4,oS2,fDuration));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis5,oS3,fDuration));

        // Remove objects
        DelayCommand(fDuration,DestroyObject(oS1));
        DelayCommand(fDuration,DestroyObject(oS2));
        DelayCommand(fDuration,DestroyObject(oS3));
        DelayCommand(fDuration,DestroyObject(oS4));
        DelayCommand(fDuration,DestroyObject(oS5));
}
//ukichapuza
void pentaano(location lTargetLoc,float fRate = 0.4, float nScale=0.3)
{
        // Get center
        object oArea = GetAreaFromLocation(lTargetLoc);
        // Define vertices for pentagram
        vector v = GetPositionFromLocation(lTargetLoc);
        v = Vector(v.x,v.y+7.0*nScale,v.z);
        location l1= Location(oArea,v,0.0);
        v = Vector(v.x-4.0*nScale,v.y-12.5*nScale,v.z);
        location l2= Location(oArea,v,0.0);
        v = Vector(v.x+10.5*nScale,v.y+8.0*nScale,v.z);
        location l3= Location(oArea,v,0.0);
        v = Vector(v.x-13*nScale,v.y,v.z);
        location l4= Location(oArea,v,0.0);
        v = Vector(v.x+10.5*nScale,v.y-8.0*nScale,v.z);
        location l5= Location(oArea,v,0.0);

        // Create verticies objects
        object oS1 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l1);
        object oS2 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l2);
        object oS3 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l3);
        object oS4 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l4);
        object oS5 = CreateObject(OBJECT_TYPE_PLACEABLE,"nonstaticinvis",l5);

        // Connect vertices with beams
        effect eVis1 = EffectVisualEffect(VFX_IMP_DEATH_L);

        // Make pentagram visible
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis1,oS4));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis1,oS5));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis1,oS1));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis1,oS2));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis1,oS3));

        // Remove objects
        DelayCommand(5.0,DestroyObject(oS1));
        DelayCommand(5.0,DestroyObject(oS2));
        DelayCommand(5.0,DestroyObject(oS3));
        DelayCommand(5.0,DestroyObject(oS4));
        DelayCommand(5.0,DestroyObject(oS5));
}
