#include "sapo_inc_variab"

void CargarVariablesComunes(object oUbicado) {

    DanoHerramientaPorUso(oUbicado,"d3()");

    BonoAtributo(oUbicado, 1, ABILITY_DEXTERITY);
    //BonoAtributo(oUbicado, 2, ABILITY_DEXTERITY);
    BonoAtributo(oUbicado, 2, ABILITY_CONSTITUTION);

    AnimacionExito(oUbicado,1,72);
    AnimacionFracaso(oUbicado,1,123);
    AnimacionFracasoVisual(oUbicado,1,121);
    AnimacionPJ(oUbicado,1,ANIMATION_LOOPING_GET_MID);
    EjecutaTodosLosSonidosProcesado(oUbicado,TRUE);
    SonidoProcesado(oUbicado,1,"as_cv_ropecreak2");
    SonidoProcesado(oUbicado,2,"as_cv_woodframe1");
    SonidoProcesado(oUbicado,3,"as_cv_ropecreak2");
    SonidoProcesado(oUbicado,4,"as_cv_ropepully1");
    SonidoProcesado(oUbicado,5,"as_cv_woodframe2");


    BonoRacial(oUbicado, 1, RACIAL_TYPE_ELF, "d6");
    BonoRacial(oUbicado, 2, RACIAL_TYPE_HALFELF, "d4");
    BonoRacial(oUbicado, 3, RACIAL_TYPE_GNOME, "d4");
    BonoRacial(oUbicado, 4, RACIAL_TYPE_HUMAN, "d3");
    BonoRacial(oUbicado, 4, RACIAL_TYPE_DWARF, "d2");

    LesionesPorcentaje(oUbicado,3);

    LesionEfectoEspecial(oUbicado, 1,1,EFFECTO_ESPECIAL_MATERIAL_DESTRUIDO);
    LesionMensaje(oUbicado,1,"*¡Las pieles estaba podridas! Han quedado inservibles.*");

    LesionHabilidad(oUbicado, 2, 1, ABILITY_CONSTITUTION, 2);
    LesionHabilidad(oUbicado, 2, 2, ABILITY_INTELLIGENCE, 2);
    LesionEfectoEspecial(oUbicado, 2,1,EFFECTO_ESPECIAL_ATONTADO);
    LesionEfectoVisual(oUbicado, 2,1,VFX_COM_HIT_ELECTRICAL);
    LesionMensaje(oUbicado,2,"*¡Los vapores te atontan un poco!*");

    LesionHabilidad(oUbicado, 3, 1, ABILITY_CONSTITUTION, 4);
    LesionHabilidad(oUbicado, 3, 2, ABILITY_CHARISMA, 4);
    LesionDano(oUbicado, 3, 1, DAMAGE_TYPE_ACID, 6);
    LesionMensaje(oUbicado,3,"*¡El acido del tanino te quema!*");

}

