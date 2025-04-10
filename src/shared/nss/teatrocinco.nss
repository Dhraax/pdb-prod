void main()
{
    ExecuteScript("fvex_area_inside",OBJECT_SELF);
  object oTeatre1 = GetObjectByTag("pb_ciclo1");
  object oTeatre2 = GetObjectByTag("pb_ciclo2");
  object oTeatre3 = GetObjectByTag("pb_ciclo3");
  SetObjectVisualTransform(oTeatre1,OBJECT_VISUAL_TRANSFORM_SCALE,2.00);
  SetObjectVisualTransform(oTeatre2,OBJECT_VISUAL_TRANSFORM_SCALE,2.00);
  SetObjectVisualTransform(oTeatre3,OBJECT_VISUAL_TRANSFORM_SCALE,2.00);
}
