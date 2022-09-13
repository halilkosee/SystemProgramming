TAGS=-lrt -lpthread -pthread -lm -Wall -g
SRVOBJ=utils/queue.o
CFILES=utils/structs.c utils/lib.c

run:
	gcc $(TAGS) distributor.c $(CFILES) -o distributor
	gcc $(TAGS) servant.c $(CFILES) -o servant
	gcc $(TAGS) server.c utils/queue.c $(CFILES) -o server
	gcc $(TAGS) client.c $(CFILES) -o client

clean:
	rm client distributor servant server

distributor:
	gcc $(TAGS) distributor.c $(CFILES) -o distributor

servant:
	gcc $(TAGS) servant.c $(CFILES) -o servant

server:
	gcc $(TAGS) utils/server.c utils/queue.c $(CFILES) -o server

client:
	gcc $(TAGS) client.c $(CFILES) -o client
	
