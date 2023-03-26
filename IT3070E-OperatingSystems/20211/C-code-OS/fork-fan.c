#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
/*create a fan of processes (a tree of level 1). Take an integer as argument which is the # of root children . On each iteration of the for loop, the newly created process brakes from the loop while the parent process continues*/
int main (int argc, char *argv[]) {
pid_t childpid = 0;
int i, n;
if (argc != 2){ /* check for valid number of command-line arguments */
fprintf(stderr, "Usage: %s processes\n", argv[0]);
return 1;
}
n = atoi(argv[1]);
for (i = 1; i < n; i++)
  if ((childpid = fork()) <= 0) break;
fprintf(stderr, "i:%d process ID:%ld child ID:%ld, parent ID:%ld\n",
	i, (long)getpid(), (long)childpid,(long)getppid());
 wait(NULL);
return 0;
}
