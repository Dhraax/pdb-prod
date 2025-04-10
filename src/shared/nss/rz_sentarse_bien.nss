void main()
{
    object oPlayer = GetLastUsedBy ();
    object oChair = OBJECT_SELF;
    object oArea = GetArea(oChair);
    //Esto evita que creemos sillas indefinidamente
    object oNullChair = GetLocalObject(oChair, "oNullChair");

    if(!GetIsObjectValid(oPlayer))return; //Uno nunca sabe

    //Posicion del ubicado original
    float fChair = GetFacing(oChair);
    vector vChair = GetPosition(oChair);
    vector vNullChair = vChair;

    //Las siguientes lineas aseguran que la posicion en el eje z sea correcta
    vNullChair.z = IntToFloat(FloatToInt(vChair.z));
    if(vChair.z < 0.0)
    {
        vNullChair.z -= 1.0;
    }

    //Una vez tenemos todos los datos, creamos una location en la posicion adecuada
    location lNullChair = Location(oArea,vNullChair,fChair);

    //Otra comprobacion, nunca se sabe
    if(!GetIsObjectValid(oNullChair))
    {
        //Creamos la silla fantasma como un ubicado invisible no seleccionable
        oNullChair = CreateObject(OBJECT_TYPE_PLACEABLE,"plc_invisobj",lNullChair,FALSE);
    }
    //Guardamos la silla por si alguien vuelve a usar el ubicado original
    SetLocalObject(oChair,"oNullChair",oNullChair);

    //Si ya hay alguien sentado, no dejamos que se sienten mas
    if(GetIsObjectValid(GetSittingCreature(oNullChair)))return;

    //Finalmente, sentamos a oPlayer en la silla de mentira
    AssignCommand(oPlayer, ActionSit(oNullChair));
}
