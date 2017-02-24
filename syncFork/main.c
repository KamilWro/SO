#include <semaphore.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <sys/wait.h>



#define BUFFER_SIZE 10

/**
 * Autor: Kamil Breczko
 *
 * Pracownia I, Systemy Operacyjne 2016/2017 
 * Temat: Problem Konsumenta i Producenta
 * Data: 11.01.2017
 */

struct Data{
  int counter;
  int buffer[BUFFER_SIZE];
  sem_t empty;
  sem_t full;
  sem_t mutex;
  int in;
  int out;
} *shared_data;


int put(int value){
	int tmp= shared_data->buffer[shared_data->in];
	shared_data->buffer[shared_data->in] = value;
	shared_data->in = (shared_data->in + 1) % BUFFER_SIZE;
	return tmp;
}

int get(){
	int tmp = shared_data->buffer[shared_data->out];
	shared_data->buffer[shared_data->out] = 0;
	shared_data->out = (shared_data->out + 1) % BUFFER_SIZE;
	return tmp;
}


void consumer() {
    while (1) {
        sem_wait(&(shared_data->full));
        sem_wait(&(shared_data->mutex));

        shared_data->counter--;
        printf("[counter=%d]Consumed! [ %d ] ====> \n",shared_data->counter , get());

        sem_post(&(shared_data->mutex));
        sem_post(&(shared_data->empty));
        sleep(2);
    }
}

void producer() {
    int i=0;
    while (1) {
        sem_wait(&(shared_data->empty));
        sem_wait(&(shared_data->mutex));

        shared_data->counter++;
        i++;
        printf("[counter=%d]Produced! [ %d ] <====%d\n",shared_data->counter ,put(i),i);

        sem_post(&(shared_data->mutex));
        sem_post(&(shared_data->full));
        sleep(2);
    }
}


int main() {

    int pid;

    shared_data = mmap(0,sizeof(struct Data),PROT_READ|PROT_WRITE,MAP_SHARED| MAP_ANONYMOUS, -1, 0);
    if(shared_data == -1) {       
	perror("map");
        exit(-1);
    }
    shared_data->counter=0;
    shared_data->in=0;
    shared_data->out=0;

    if(sem_init(&(shared_data->mutex),1,1)){
 	perror("mutex");
	exit(0);
    }
    if(sem_init(&(shared_data->empty),1,BUFFER_SIZE)) {
 	perror("empty");
	exit(0);
    }
    if(sem_init(&(shared_data->full),1,0)) {
 	perror("full");
	exit(0);
    }

    for (int i=0;i<BUFFER_SIZE;i++)
	shared_data->buffer[i]=0;

    pid=fork ();
    switch (pid) {
	case -1:
		perror("fork error\n");
		exit(-1);
	case 0:
		consumer();
 		exit(0);
		break;
	default:
		producer();
		break;
    }

    
    int status;
    waitpid(pid, &status, 0);
    pid = wait(&status);
    sem_destroy(&(shared_data->mutex));
    sem_destroy(&(shared_data->empty));
    sem_destroy(&(shared_data->full));
    return 0;
}
