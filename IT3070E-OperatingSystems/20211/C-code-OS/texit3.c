#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/syscall.h>
/* the main thread kills the child thread using pthread_cancel()*/
int sum;
void *runner(void *param); 
int main(int argc, char *argv[]){
  pthread_t tid; 
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_t tid3 = syscall(SYS_gettid);
  pthread_create(&tid, &attr, runner, argv[1]);
  /* wait for the thread to exit */
  printf("The parent thread will cancel the child thread that is sleeping for 10 seconds, parent id %ld\n", (long) getpid());
  sleep(4);
  pthread_cancel(tid);
  printf("Parent thread has canceled the child thread \n");
  sleep(5);
  pthread_join(tid,NULL);
  
  sleep(5);
  pthread_exit(0);
}
/* The thread will execute in this function */
void *runner(void *param)
{
  int tid1 = pthread_self();
  pthread_t tid2 = syscall(SYS_gettid);
  int i, upper = atoi(param);
  sum = 0;
  for (i = 1; i <= upper; i++)
    sum += i;
  sleep(10);
  printf("Child thread, ID is %ld\n",tid2);
  pthread_exit(0);
}
