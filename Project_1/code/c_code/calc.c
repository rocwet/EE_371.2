/*
Ruchira Kulkarni
Minhhue Khuu
Denny Ly
2016.01.15
EE371 LAB 1
*/

/* imported libraries */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* define the cost of beer in dollars */
#define BEER_PRICE 2

/*
The priceOfBeer() function takes exchange rate and prints the foreign price
of beer, based on the default US price of beer.

@param exchange The exchange rate to convert the price of beer.
*/
void priceOfBeer(float exchange){
   float price = BEER_PRICE * exchange;
   printf("The value of a bottle of beer in foreign currency is : %f\n", price);
}

/*
The convertUStoForeign() function converts the a given amount and prints the 
amount in the foreign country based on the given exchange rate.

@param amount The given price to be converted.
@param exchange The exchange rate used to convert the given amount to a foreign currency.
*/
void convertUStoForeign(float amount, float exchange) {
  float new_value = amount * exchange;
  printf("The value in Foreign Currency is : %f\n" , new_value);
  priceOfBeer(exchange);
}

/*
The convertForeigntoUS() function converts a given foreign amount and prints the 
the US currency based on the exchange rate.

@param amt The foreign price.
@param exchange The exchange rate used to convert US to foreign currency.
*/
void convertForeigntoUS(float amt, float exchange) {
  float new_value = amt/exchange;
  printf("The value in US Dollars is : %f\n", new_value);
}

/*
The main() fucntion takes 3 command line arguments to convert to a foreign currency
or convert back to the US currency.

@param argc The amount of arguments.
@param argv The command-line arguments.
*/
int main(int argc, char **argv) {
  float amount = atof(argv[1]);
  float exchange_rate = atof(argv[2]);
  int conversion_type = atoi(argv[3]);
  if (conversion_type == 1) {
    convertUStoForeign(amount, exchange_rate);
  } else if (conversion_type == 2) {
    convertForeigntoUS(amount, exchange_rate);
  } else {
    printf("Please include valid arguments\n");
  }
  return 0;
}
