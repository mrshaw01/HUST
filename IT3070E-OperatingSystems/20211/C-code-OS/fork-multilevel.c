#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
/* Create a multilevel tree of processes*/
int main (int argc, char *argv[]) {
pid_t childpid = 0;
 int i,j, n;
n = atoi(argv[1]);
 for (i = 1; i < n; i++){
  childpid = fork();
  if (childpid != 0)fprintf(stderr, "tree: %d i:%d process ID:%ld parent ID:%ld child ID:%ld\n",
			    tree,i, (long)getpid(), (long)getppid(), (long)childpid);
 }
 sleep(10);
return 0;
}
