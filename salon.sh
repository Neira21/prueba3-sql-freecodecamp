#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon services ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "List of services, press 4 for exit"
  SERVICES_LIST=$($PSQL "select * from services")
  echo "$SERVICES_LIST" | while read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID)$SERVICE_NAME"  | sed 's/|//'
  done

  echo -e "\nSelect a option"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) FIRST_SERVICE ;;
    2) SECOND_SERVICE ;;
    3) THIRD_SERVICE ;;
    4) EXIT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

FIRST_SERVICE(){
  echo -e "\nFirst Service.\n"
  GET_DATA_USER
}

SECOND_SERVICE(){
  echo -e "\nSecond Service.\n"
  GET_DATA_USER
}

THIR_SERVICE(){
  echo -e "\nThird Service.\n"
  GET_DATA_USER
}

GET_DATA_USER(){
  SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    INSERT_CUSTOMER=$($PSQL "insert into customers (phone, name) values ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

    echo What time would you like your cut, $CUSTOMER_NAME?
    read SERVICE_TIME

    GET_NEW_ID_CUSTOMER=$($PSQL "select customer_id from customers where name = '$CUSTOMER_NAME'")

    INSERT_APPOINTMENT=$($PSQL "insert into appointments (time, customer_id, service_id) values ('$SERVICE_TIME', $GET_NEW_ID_CUSTOMER, $SERVICE_ID_SELECTED)")
    
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  else
    #GET NAME
    NAME_FINDER=$($PSQL "select name from customers where customer_id = '$CUSTOMER_ID'")
    echo What time would you like your cut, $NAME_FINDER?
    read SERVICE_TIME
    INSERT_APPOINTMENT=$($PSQL "insert into appointments (time, customer_id, service_id) values ('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $NAME_FINDER."
  fi
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU

