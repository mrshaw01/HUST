#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/syscall.h>
/* the child thread exit with the exit() command causing the main thread to exit as well*/
int sum;
void *runner(void *param); 
int main(int argc, char *argv[]){
  pthread_t tid; 
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_t tid3 = syscall(SYS_gettid);
  pthread_create(&tid, &attr, runner, argv[1]);
  /* wait for the thread to exit */
  printf("The main thread sleep 10 seconds before executing join, main thread id is %ld\n", tid3);
  sleep(10);
  pthread_join(tid,NULL);
  printf("sum = %d\n",sum);
  exit(0);
}
/* The thread will execute in this function */
void *runner(void *param){
  pthread_t tid2 = syscall(SYS_gettid);
  int i, upper = atoi(param);
  sum = 0;
  sleep(6);
  for (i = 1; i <= upper; i++)
    sum += i;
  printf("Child thread exit with exit(), ID is %ld\n", tid2);
  pthread_exit(0);
}
