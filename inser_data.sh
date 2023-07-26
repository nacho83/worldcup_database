#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner ]]
  then
   # get winner_name
   WINNER_NAME=$($PSQL "SELECT team_id from teams where name='$WINNER'")
   if [[ -z $WINNER_NAME ]]
      then 
      $($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
   fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $OPPONENT != opponent ]]
  then
   # get winner_name
   OPPONENT_NAME=$($PSQL "SELECT team_id from teams where name='$OPPONENT'")
   if [[ -z $OPPONENT_NAME ]]
      then 
      $($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
   fi
  fi
done
NUMTEAMS=$($PSQL "SELECT COUNT(*) from teams")
echo $NUMTEAMS

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id from teams where name=('$WINNER')")
    OPPONENT_ID=$($PSQL "SELECT team_id from teams where name=('$OPPONENT')")
    $($PSQL "INSERT INTO games(year, round,winner_id, opponent_id, winner_goals, opponent_goals) 
    VALUES ('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
  fi
done
NUMGAMES=$($PSQL "SELECT COUNT(*) from games")
echo $NUMGAMES
