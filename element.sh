#!/bin/bash
# This script retrieves element details from the periodic_table database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Search for element by atomic number, symbol, or name (fixes integer-string issue)
RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number::TEXT='$1' OR name='$1' OR symbol='$1'")

# If no element is found
if [[ -z "$RESULT" ]]; then
  echo "I could not find that element in the database."
  exit
fi

# Fetch element details
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number=$RESULT")
TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$RESULT")
MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$RESULT")
MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$RESULT")
BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$RESULT")
NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$RESULT")
SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$RESULT")

# Print result
echo  "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
