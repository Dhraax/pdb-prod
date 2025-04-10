const int TIPO_RAZA=1;
const int TIPO_TALENTO=2;
const int TIPO_HABILIDAD=3;
const int TIPO_CLASE=4;
const int TIPO_CONJURO=5;
const int TIPO_HERRAMIENTA=6;

const int TIPOVAR_INT=1;
const int TIPOVAR_STR=2;

const int CONST_ESPECIAL_ATRIBUTO_FUERZA=-1;
const int CONST_ESPECIAL_RAZA_ENANO=-1;
const int CONST_ESPECIAL_CLASE_BARBARO=-1;
const int CONST_ESPECIAL_TALENTO_ALERTA=-1;
const int CONST_ESPECIAL_HABILIDAD_EMPATIA_ANIMAL=-1;
const int CONST_ESPECIAL_CONJURO_NIEBLA_ACIDA=-1;

const int EFFECTO_ESPECIAL_CEGERA=1;
const int EFFECTO_ESPECIAL_ATONTADO=2;
const int EFFECTO_ESPECIAL_PETRIFICADO=3;
const int EFFECTO_ESPECIAL_ENERVADO=4;
const int EFFECTO_ESPECIAL_MATERIAL_DESTRUIDO=-100;
const int EFFECTO_ESPECIAL_HERRAMIENTA_DESTRUIDA=-101;
const int EFFECTO_ESPECIAL_ENCUENTRO=-102;

const int FUNCION_COMPROBAR_Y_CARGAR=1;
const int FUNCION_CREAR_OBJETO=2;

const int DEBUG=FALSE;
const int DEBUG_REQUISITOS=FALSE;
const int DEBUG_USO_HERRAMIENTAS=FALSE;
const int DEBUG_LESIONES=FALSE;
const int DEBUG_APRENDIZAJE=FALSE;
const int DEBUG_EXITO=FALSE;
const int DEBUG_FRACASO=FALSE;
const int DEBUG_CREAR=FALSE;
const int DEBUG_BORRAR_INVENTARIO=FALSE;
const int DEBUG_ANIMACIONES=FALSE;

const int PROFESIONES_CURTIDOR=9;
const int PROFESIONES_MARROQUINERIA=12;
const int PROFESIONES_GUARNICIONERIA=13;

const int MAXIMO_HABILIDAD_POR_DEFECTO=100;

const string SAPO_CONTENEDOR_CREAR="sapo_cont_crear";


string NombreProfesion(int iProfesion) {

    switch(iProfesion) {
    case PROFESIONES_MARROQUINERIA: return "marroquinería";
    case PROFESIONES_GUARNICIONERIA: return "guarnicionería";
    case PROFESIONES_CURTIDOR: return "curtidería";
    }

    return "Desconocido";
}

string NombreMaestro(int iProfesion) {

    switch(iProfesion) {
    case PROFESIONES_MARROQUINERIA: return "marroquinero";
    case PROFESIONES_GUARNICIONERIA: return "guarnicionador";
    case PROFESIONES_CURTIDOR: return "curtidor";
    }

    return "Desconocido";
}


int DevolverNumFormulas(int iProfesion) {

    switch (iProfesion) {
    case PROFESIONES_CURTIDOR: return 1;
    case PROFESIONES_MARROQUINERIA: return 1;
    case PROFESIONES_GUARNICIONERIA: return 1;
    }

    return 0;
}


int DevolverNivelMaximoProfesion(int iProfesion) {

    return MAXIMO_HABILIDAD_POR_DEFECTO;
}
