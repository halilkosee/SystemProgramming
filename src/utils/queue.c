#include <stdio.h>
#include <stdlib.h>

#include "queue.h"


void enqueue(node **head, int* data){

    node *new_node = (node*)calloc(sizeof(node), 1);
    new_node->data = data;
    new_node->next = NULL;

    if(*head == NULL){
        *head = new_node;
    }
    else{
        node *current = *head;
        while(current->next != NULL){
            current = current->next;
        }
        current->next = new_node;
    }

}

int* dequeue(node **head){

    if(*head == NULL){
        return NULL;
    }
    else{
        node *current = *head;
        *head = (*head)->next;
        int* data = current->data;
        free(current);
        return data;
    }

}



