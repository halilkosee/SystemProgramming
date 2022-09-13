#include <stdio.h> 
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <string.h>
#include <sys/stat.h>


#include "utils/structs.h"
#include "utils/lib.h"

distributor_command_argument argument;
void validateArguments(int);
void displayUsage();
char* estimateOptimalBounds(int i);
int sendDataWithFifo(char* data); 

void run();

int main(int argc, char *argv[]) {
  int opt;
  while(-1 != (opt = getopt(argc, argv, "d:s:r:p:"))) {
    switch(opt) {
      case 'd':
        argument.directoryPath=optarg;
        break;
      case 's':
        argument.numberOfServant = atoi(optarg);
        break;
      case 'r':
        argument.IP = optarg;
        break;
      case 'p':
        argument.portAsString = optarg;
        argument.PORT= atoi(argument.portAsString);
        break;
      default:
        displayUsage();
    }
  }
  validateArguments(argc);
  run();
}

void run() {
  writeOnTerminal("distributor is running...\n");
  for(int i = 0; i < argument.numberOfServant; i++) {
    sendDataWithFifo(estimateOptimalBounds(i));
    pid_t pid = fork();
    if(pid == 0) {
      char *args[]={"./servant", argument.directoryPath, estimateOptimalBounds(i), argument.IP, argument.portAsString, NULL};
      execv("./servant",args);
    }
  }
}

int sendDataWithFifo(char* data) {
   int fd;
   const char * myfifo = "/tmp/myfifo";
   mkfifo(myfifo, 0666);
   fd = open(myfifo, O_WRONLY|O_NONBLOCK);
   write(fd, &data, sizeof(data));    
   close(fd);
   return 0;
}

void displayUsage() {
  writeError(" Usage: ./distributor -d directoryPath(must be existing path) -s numberOfServants(must be numeric and at least 2) -r IP -p PORT(must be numeric) \n" );
  exit(EXIT_FAILURE);
}

char* estimateOptimalBounds(int i) {
  int lower = 1 + (i * (81/argument.numberOfServant));
  int upper = lower + (81/argument.numberOfServant);
  if ((i + 1) ==  argument.numberOfServant){
    upper = lower-1 + (81/argument.numberOfServant) + (81 % argument.numberOfServant);
  }
  char *bounds = malloc(5);
  sprintf(bounds,"%d-%d",lower,upper);
  return bounds;
}

void validateArguments(int argc) {
  if (argc != 9) {displayUsage();}
  if (!(checkIfFileExists(argument.directoryPath))) {displayUsage();}
  if (!(argument.PORT)) {displayUsage();}
  if (!(argument.numberOfServant)) {displayUsage();}
  if (argument.numberOfServant < 2) {displayUsage();}
}