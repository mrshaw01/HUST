#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <sys/wait.h>
/*How to exec to make child execute a different program compared to the parent process*/
int main(void) {
	pid_t childpid;
	pid_t mypid = getpid();
	printf("I am parent with PID = %ld\n", (long)mypid);
	childpid = fork();
	if (childpid == 0) { /* child code */
	  printf("I am child with PID = %ld\n", (long)getpid());
	  execl("/bin/ls", "../ls","..", NULL);
	  printf("I am child with PID = %ld,  my parent PID is = %ld\n", (long)getpid(),(long)mypid);
		perror("Child failed to exec ls");
		return 1;
	}
	if (childpid != wait(NULL)) { /* parent code */
		perror("Parent failed to wait due to signal or error");
		return 1;
	}
	return 0;
}
