#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sched.h>
#include <signal.h>
#define FIBER_STACK 8192
int b = 0;
void * stack;
int do_something(){
    while (b<10){
      sleep(1);
        printf("pid : %d, b = %d\n", getpid(), b++);
    }
    exit(1);
}
int main() {
    void * stack;
    stack = malloc(FIBER_STACK);
    if(!stack) {
        printf("The stack failed\n");
        exit(0);
    }

    int a = 0;
    if (a == 0) {
      /*clone() creates a thread*/
       clone(&do_something, (char *)stack + FIBER_STACK, CLONE_VM|CLONE_VFORK, 0);
      /*clone() create a process*/
      //clone(&do_something, (char *)stack + FIBER_STACK,CLONE_VFORK, 0);
    }
    while (a<10){
      sleep(1);
      printf("pid : %d, a = %d, b = %d\n", getpid(), a++, b);
    }

    free(stack);
    exit(1);
}
