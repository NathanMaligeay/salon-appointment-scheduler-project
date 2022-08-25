#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e '\n~~Welcome to Hairy Salon~~\n'



MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWhat service do you want?\n"

  GET_SERVICE=$($PSQL "SELECT service_id, name FROM services")
  
  echo "$GET_SERVICE" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SERVICE ;;
    2) SERVICE ;;
    3) SERVICE ;;
    *) MAIN_MENU "Please enter a valid option."
  esac

}

SERVICE() {
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nYou chose$SERVICE_NAME. Please input your phone number."
  read CUSTOMER_PHONE
  CUSTOMER_PHONE_IN_DATA=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_PHONE_IN_DATA ]]
  then
    echo -e "\nSeems like you are not already one of our client. What is your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nAt what time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
  read SERVICE_TIME
  GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
}


MAIN_MENU