# ­ƒº¬ PeriodicBash (PostgreSQL + Bash CLI + Normalizaci├│n)

*­ƒç║­ƒç© [Read this in English](README.md)*

Una aplicaci├│n Bash para buscar elementos de la tabla peri├│dica. El objetivo principal fue normalizar y corregir errores una base de datos ya existente `periodic_table_old.sql` para transformarlo en `periodic_table.sql`.
Evitando redundancia (duplicacion) de datos, garantizando atomicidad  de los datos (un campo, un dato), y la integridad de los datos

## ­ƒÜÇ Caracter├¡sticas Clave
  - **Volcado de la base de datos original (`periodic_table_old`):** La base de datos contiene datos inconsistentes
    - **S├¡mbolos en min├║scula:** Como `he` y `li`, y el elemento ficticio `moTanium`
    - **Falta de integridad referencial:** No existe `FOREIGN KEY` entre `properties` y `elements`, permitiendo registros hu├®rfanos.
    - **Restricciones Redundantes:** Restricciones `UNIQUE` redundantes sobre las claves primarias.
    - **Riesgo de datos incompletos y JOINs inconsistentes:** `melting_point` y `boiling_point` en `properties` permiten nulos, lo que puede causar p├®rdidas de informaci├│n o comportamiento inesperado al operar o filtrar dichos datos sin valor.
    - **Campos obligatorios expuestos en elements:** `symbol` y `name` permiten NULL, lo que posibilitar├¡a registrar elementos an├│nimos o sin s├¡mbolo en el cat├ílogo principal.
    - **Atributos repetidos y sobre-fragmentaci├│n:** `type` debe ser una tabla independiente (3FN) y la divisi├│n 1-a-1 entre `elements` y `properties` exige hacer `JOINs` innecesarios.
  - **Volcado de la base de datos normalizada (`periodic_table.sql`):** La nueva base de datos corrigue los errores de su antecesora `periodic_table_old`
    - **S├¡mbolos en mayuscula:** Todos los s├¡mbolos qu├¡micos tienen su primera o ├║nica letra en may├║scula (ej. `He`, `Li`).
    - **Integridad referencial:** Se agrego una `FOREIGN KEY` entre `properties` y `elements` garantizando la integridad referencial, conectar tablas y evitar datos err├│neos.
    - **Sin Restricciones Redundantes:** Si una restriccion no se necesita, no se implenta, beneficiando al mantenimiento de la base de datos.
    - **Imposibilidad de Datos Vacio:** Por dise├▒o ya no se aceptan datos vac├¡os en ningun campo
    - **Normalizacion:** Se separa el campo `type` de properties y se reemplaza por una Clave Foranea llamada `type_id`, que se relaciona con `type_id` de la tabla `type`, cumpliendo la Tercera Forma Normal (3FN)
  - **Script `element.sh`:** Un Script de Bash que permite consulta la informacion de un elemento de la tabla periodica registrado en la base de datps (`periodic_table.sql`).

## ­ƒôé Estructura del Proyecto
```text
.
Ôö£ÔöÇÔöÇ element.sh             # Script ejecutable principal de la CLI
Ôö£ÔöÇÔöÇ periodic_table.sql     # Dump de la base de datos normalizada
Ôö£ÔöÇÔöÇ periodic_table_old.sql # Dump de la base de datos original sin normalizar
ÔööÔöÇÔöÇ README.md              # Documentaci├│n del proyecto
```

## ­ƒøá´©Å Tecnolog├¡as Utilizadas
  - **Base de Datos:** PostgreSQL
  - **Lenguaje:** Bash / Shell Scripting (psql CLI)

## ­ƒÆ╗ Instalaci├│n y Ejecuci├│n
### Prerrequisitos
Tener instalado y configurado PostgreSQL en tu entorno local.  
### Pasos
1. **Clonar el repositorio:**
```bash
  git clone https://github.com/Akisolu/PeriodicBash.git
  cd PeriodicBash
```
2. **Crear e importar el esquema de la base de datos:**
```bash
  psql -U postgres < periodic_table.sql
```
> [!WARNING]  
> **Cuidado:**  
> Asegurate de ejecutar `psql -U postgres < periodic_table.sql` y no `psql -U postgres < periodic_table_old.sql`,
> sino importaras la base de datos sin los arreglos y normalizaciones que ejecute.

3. **Dar permisos a la aplicaci├│n:**
```bash
  chmod +x element.sh
```

## ­ƒæ¿ÔÇì­ƒÆ╗ Guia de uso 
- Si ejecutas directamente `./element.sh` obtendras un mensaje que dice `Please provide an element as an argument.`
- Para que se ejecute le debes dar un parametro, puede ser el numero atomico, un simbolo quimico o directamente el nombre
  ```bash
    # Ejemplos
    ./element.sh 1
    ./element.sh H
    ./element.sh Hydrogen
  ```
- Cualquier entrada de ejemplo generara la misma salida
  ```plaintext
    The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
  ```

## ­ƒô£ Cr├®ditos y Reconocimientos

* **Origen de la consigna / dataset:** Este proyecto es uno de los desaf├¡os requeridos para la obtenci├│n de la **Certificaci├│n de Bases de Datos Relacionales** de [freeCodeCamp](https://www.freecodecamp.org/).
* **Implementaci├│n:** La l├│gica de scripts en Bash (`element.sh`) y la estructuraci├│n del esquema PostgreSQL (`periodic_table.sql`) fueron desarrolladas por completo como resoluci├│n individual al problema planteado.
