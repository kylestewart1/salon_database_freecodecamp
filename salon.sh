#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n ~~~~~ S.Todd's Salon ~~~~~\n"

echo -e "\nWelcome to my salon. What can I do for you?\n"

SERVICES_MENU () {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "$($PSQL "SELECT * FROM services;")" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")

  if [[ -z $SERVICE_NAME ]]
  then
    SERVICES_MENU "I'm sorry, we don't offer that service."
  else
  
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")

    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nAh, a new vic- erm, customer. What's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name)
                                VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    else
      echo -e "\nHey, how did you escape...?"
    fi

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time)
                                VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}


SERVICES_MENU