#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if there is no argument
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  # if there is an argument
  # if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]];
  then
    # get atomic_number and the rest
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo I could not find that element in the database.
    else
      ELEMENT=$($PSQL "SELECT name FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number WHERE properties.atomic_number=$1")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
      TYPE=$($PSQL "SELECT type FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$1")
      MASS=$($PSQL "SELECT atomic_mass FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$1")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$1")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$1")
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $ELEMENT has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  # if not a number
  else
    # get symbol from database
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
    if [[ -z $SYMBOL ]]
    # if not a symbol, then it should be the name:
    then
      # get the name from the database
      ELEMENT=$($PSQL "SELECT name FROM elements WHERE name='$1'")
      if [[ -z $ELEMENT ]]
      then
        echo I could not find that element in the database.
      else
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
        TYPE=$($PSQL "SELECT type FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
        MASS=$($PSQL "SELECT atomic_mass FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
        MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
        BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
        echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $ELEMENT has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      fi
    else
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
      ELEMENT=$($PSQL "SELECT name FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number WHERE symbol='$1'")
      TYPE=$($PSQL "SELECT type FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
      MASS=$($PSQL "SELECT atomic_mass FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $ELEMENT has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  fi
fi

