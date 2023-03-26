#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
/*create a chain of processes. Take an integer as argument which is the lenght of the chain. On each iteration of the for loop, the parent process has a nonzero chilpid and hence break the loop. The child process has a zero valueof childpid and becomes a parent in the next iteration*/
int main (int argc, char *argv[]) {
pid_t childpid = 0;
int i, n;
if (argc != 2){ /* check for valid number of command-line arguments */
fprintf(stderr, "Usage: %s processes\n", argv[0]);
return 1;
}
n = atoi(argv[1]);
 for (i = 0; i < n; i++)
   if (childpid = fork()) break;
 
 //fprintf(stderr, "i:%d process ID:%ld child ID:%ld, parent ID:%ld\n",	i, (long)getpid(), (long)childpid,(long)getppid());
 wait(NULL);
 fprintf(stderr, "i:%d process ID:%ld child ID:%ld, parent ID:%ld\n",
	i, (long)getpid(), (long)childpid,(long)getppid());
return 0;
}
