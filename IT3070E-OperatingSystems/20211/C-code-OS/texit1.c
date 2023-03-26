#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/syscall.h>
/* the chid thread exit while the parent thread sleep before executing pthread_join. However on the terminal the child process id is removed*/
int sum;
void *runner(void *param); 
int main(int argc, char *argv[]){
  pthread_t tid; 
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_create(&tid, &attr, runner, argv[1]);
  /* wait for the thread to exit */
  printf("The main thread sleep 10 seconds before executing join, main thread id is %ld\n", (long) getpid());
  sleep(20);
  pthread_join(tid,NULL);
  printf("sum = %d\n",sum);
  pthread_exit(0);
}
/* The thread will execute in this function */
void *runner(void *param){
  int tid1 = pthread_self();
  pthread_t tid2 = syscall(SYS_gettid);  
  int i, upper = atoi(param);
  sum = 0;
  for (i = 1; i <= upper; i++)
    sum += i;
  sleep(10);
  printf("Child thread exit, ID is %ld\n", tid2);
  pthread_exit(0);
}
