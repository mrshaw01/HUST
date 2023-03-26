#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/syscall.h>
/* this program takes in input an integer n, generates a thread, this thread adds the number from 0 to n*/
int sum; /* this data is shared by the thread(s) */
void *runner(void *param); /* threads call this function */
int main(int argc, char *argv[]){
  pthread_t tid; /* the thread identifier */
  pthread_attr_t attr; /* set of thread attributes */
  pthread_attr_init(&attr);/* set the default attributes of the thread */
  pthread_t tid3 = syscall(SYS_gettid); /*get the thread id of the main thread */
  printf("Main thread, process id is %d, and thread id is %ld\n", getpid(), tid3);
  pthread_create(&tid, &attr, runner, argv[1]);/* create a thread */
  pthread_join(tid,NULL);/* wait for the thread to exit */
  printf("sum = %d\n",sum); /* print the value computed by the thread */
  pthread_exit(0);
}
void *runner(void *param) { /* thread executes this function */
  pthread_t tid1 = pthread_self(); /* this function returns a value that is different from the ID of the child thread in the process table*/
  printf("This is the value returns by pthread_self() %ld\n",tid1);
  pthread_t tid2 = syscall(SYS_gettid);/*get the thread id of runner as it appears in the process table */
  printf("Entering child thread, process PID is %d, and child thread ID is %ld\n",getpid(), tid2);
  int i, upper = atoi(param);
  sum = 0;
  for (i = 1; i <= upper; i++)
    sum += i;
  sleep(5);
  pthread_exit(0);
}
