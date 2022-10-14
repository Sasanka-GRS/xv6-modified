#include "../kernel/param.h"
#include "../kernel/types.h"
#include "../kernel/stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
  int priority, pid;
  
  if(argc != 3) 
  {
    printf(2,"Too less/many arguments\n");
    exit(1);
  }

  priority = atoi(argv[1]);
  pid = atoi(argv[2]);

  if (priority < 0 || priority > 100)
  {
    printf(2,"Error: Accepted Range is 0-100\n");
    exit(1);
  }
  set_priority(priority, pid);
  exit(1);
}