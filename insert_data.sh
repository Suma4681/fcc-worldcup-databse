#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#removing first line which contains headings
  if [[ $YEAR != "year" ]]
  then
  #intiating insert by checking whether the team_id is present or not for winner it's for team table
     TEAM_ID1=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")
     if [[ -z $TEAM_ID1 ]]
     then
        INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        #STORING TEAM_ID winner
        TEAM_ID1=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")
      fi
      #intiating insert by checking whether the team_id is present or not for opponent
      TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")
        if [[ -z $TEAM_ID2 ]]
     then
        INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
         #STORING TEAM_ID opponent
        TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")
      fi
      #inserting data into game table by using game_id as a refrence
       GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_id=$TEAM_ID1 AND opponent_id=$TEAM_ID2")
      if [[ -z $GAME_ID ]]
      then
           INSERT_GAME_TAB=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id, winner_goals , opponent_goals) VALUES($YEAR,'$ROUND',$TEAM_ID1,$TEAM_ID2,$WINNER_GOALS,$OPPONENT_GOALS)")
      fi
  fi
done

    
         
