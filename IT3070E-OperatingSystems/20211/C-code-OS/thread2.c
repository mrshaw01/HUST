#include <pthread.h> 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/syscall.h>
void *message_function ( void *ptr );

typedef struct str_thdata
{
    int thread_no;
    char message[100];
} thdata;   /* structs to be passed to threads */
/* this program creates two threads using the same function but with different arguments*/
int main(){
    pthread_t thread1, thread2;  /* thread variables */
    thdata data1, data2;        
    
    /* initialize data to pass to thread 1 */
    data1.thread_no = 1;
    strcpy(data1.message, "Hi prof!");

    /* initialize data to pass to thread 2 */
    data2.thread_no = 2;
    strcpy(data2.message, "Hi Students!");
    
    /* create threads 1 and 2 */    
    pthread_create (&thread1, NULL, message_function, (void *) &data1);
    pthread_create (&thread2, NULL, message_function, (void *) &data2);

    /* Main block waiting for both threads to terminate */ 
    pthread_join(thread2, NULL);
    pthread_join(thread1, NULL);
              
    pthread_exit(0);
} /* main() */



/* the message function is used as the start routine for the threads*/
void *message_function ( void *ptr )
{
    thdata *data;            
    data = (thdata *) ptr;  /* type cast to a pointer to thdata */
    pthread_t tid1 = syscall(SYS_gettid);

    /* do the work */
    printf("Thread %d with thread id %ld says %s \n", data->thread_no, tid1,  data->message);
    sleep(5);
    pthread_exit(0); 
} 
