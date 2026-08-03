#!/bin/bash

# If a parameter is entered for execution
if [[ -z $1 ]]; 
then
  echo "Please provide an element as an argument."
  exit
fi

# Database conection
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT=$1

# If is number
if [[ $INPUT =~ ^[0-9]+$ ]]; 
then
  # It obtains the data
  ID_ELEMENT=$INPUT
  DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $ID_ELEMENT;")
else
  # Get the ID
  ID_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT' or name = '$INPUT';")

  if [[ -z $ID_ELEMENT ]] ; then
    echo "I could not find that element in the database."
    exit
  fi

  # Then it obtains the data
  DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $ID_ELEMENT;")
fi

if [[ -z $DATA ]]; then
  echo "I could not find that element in the database."
  exit
fi

echo "$DATA" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done
