#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#define BUFFER_SIZE 10

/**
 * Autor: Kamil Breczko
 * 
 * Pracownia I, Systemy Operacyjne 2016/2017  
 * Temat: Problem Konsumenta i Producenta
 * Data: 04.01.2017
 */


pthread_mutex_t mutex;  
sem_t empty, full;  

int counter = 0;          
int buffer[BUFFER_SIZE];

int in = 0;
int out = 0; 


int put(int value){
	int tmp= buffer[in];
	buffer[in] = value;
	in = (in + 1) % BUFFER_SIZE;
	return tmp;
}

int get(){
	int tmp = buffer[out];
	buffer[out] = 0;
	out = (out + 1) % BUFFER_SIZE;
	return tmp;
}


void *consumer(void *arg) {
    while (1) {
        sem_wait(&full);
        pthread_mutex_lock(&mutex);

        counter--;
        printf("[counter=%d]Consumed! [ %d ] ====> \n",counter , get());
   
        pthread_mutex_unlock(&mutex);
        sem_post(&empty);
        sleep(2);
    }
}

void *producer(void *arg) {
    int i=0;
    while (1) {
        sem_wait(&empty); 
        pthread_mutex_lock(&mutex);

        counter++;
	i++;
        printf("[counter=%d]Produced! [ %d ] <====%d\n",counter ,put(i),i);

        pthread_mutex_unlock(&mutex);
        sem_post(&full);
        sleep(2);
    }
}

int main() {
    for (int i=0;i<BUFFER_SIZE;i++)
	buffer[i]=0;

    pthread_mutex_init(&mutex, NULL); 

    if(sem_init(&empty, 0, BUFFER_SIZE)) {
 	perror("empty");
	exit(0);
    }
    if(sem_init(&full, 0, 0)) {
 	perror("full");
	exit(0);
    }

    pthread_t threads[2];
    pthread_create(&threads[0], NULL, producer, NULL); 
    pthread_create(&threads[1], NULL, consumer, NULL); 
    pthread_join(threads[0], NULL);
    pthread_join(threads[1], NULL);

    sem_destroy(&empty);
    sem_destroy(&full);


    return 0;
}
