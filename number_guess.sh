#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

AZAR(){
  #Bienvenida
  echo "Enter your username:"
  read USERNAME
  CONSULT_USERNAME=$($PSQL "select user_id from users where username='$USERNAME'")
  PLAYED_GAMES=$($PSQL "select count (juego_id) from juegos where user_id=$CONSULT_USERNAME")
  BEST_GAME=$($PSQL "select min(intentos) from juegos where user_id=$CONSULT_USERNAME")
  if [[ -z $CONSULT_USERNAME ]]
  then
    #Para usuarios nuevos
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    INSERT_USER=$($PSQL "insert into users (username) values ('$USERNAME')")
    CONSULT_USERNAME=$($PSQL "select user_id from users where username='$USERNAME'")
  else
    #Para usuarios viejos
    echo "Welcome back, $USERNAME! You have played $PLAYED_GAMES games, and your best game took $BEST_GAME guesses."
  fi

  #Número random
  GUESS_NUMBER=$(RANDOM_NUMBER)


  #Inicia el juego
  echo "Guess the secret number between 1 and 1000:"
  read MI_NUMERO
  INTENTO=1
  while ! [[ $MI_NUMERO =~ ^[0-9]+$ ]]
      do
            echo "That is not an integer, guess again:"
            MI_NUMERO=$(LEER)
      done
  

  while [ $MI_NUMERO -ne $GUESS_NUMBER ]
  do
    if [ $MI_NUMERO -gt $GUESS_NUMBER ]
    then
      echo "It's lower than that, guess again:"
      read MI_NUMERO
      while ! [[ $MI_NUMERO =~ ^[0-9]+$ ]]
        do
            echo "That is not an integer, guess again:"
            MI_NUMERO=$(LEER)
        done
      let "INTENTO+=1"
    else 
      echo "It's higher than that, guess again:"
      read MI_NUMERO
      while ! [[ $MI_NUMERO =~ ^[0-9]+$ ]]
        do
            echo "That is not an integer, guess again:"
            MI_NUMERO=$(LEER)
        done
      let "INTENTO+=1"
    fi
  done
  if [ $MI_NUMERO -eq $GUESS_NUMBER ]
  then 
    echo "You guessed it in $INTENTO tries. The secret number was $GUESS_NUMBER. Nice job!"
    INSERT_RECORD=$($PSQL "insert into juegos (intentos, user_id) values ($INTENTO,$CONSULT_USERNAME)")
  fi

}

LEER(){
  read NUMERO
  echo $NUMERO
}

RANDOM_NUMBER(){
  R_NUMBER=0
  while [ $R_NUMBER -le 0 ]
  do 
    R_NUMBER=$RANDOM
    let "R_NUMBER %= 1000"
  done
  echo $R_NUMBER
}


AZAR
