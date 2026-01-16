#!/bin/bash

#Salon appointment project

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "Welcome to My Salon, how can I help you?\n"
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  # Print the available services
  echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
}

REGISTER_APPOINTMENT(){
  SERVICE_ID=$1
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID")
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  #Check if the number is registered
  CHECK_PHONE=$($PSQL "SELECT * FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CHECK_PHONE ]]
  then
  # Get customer's name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
  # Add phone and name to the customers table
    ADD_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi
  # Ask for the time for the appointment
  echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?" 
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # Add appointment to the appointments table
  ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(time,customer_id,service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID,$SERVICE_ID)")
  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."

}

MAIN_MENU

case $SERVICE_ID_SELECTED in
  1) REGISTER_APPOINTMENT 1 ;;
  2) REGISTER_APPOINTMENT 2 ;;
  3) REGISTER_APPOINTMENT 3 ;;
  4) REGISTER_APPOINTMENT 4 ;;
  5) REGISTER_APPOINTMENT 5 ;;
  *) MAIN_MENU "I could not find that service. What would you like today?" ;;
esac