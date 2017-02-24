TARGET= ProducerAndConsumer
SRC= $(wildcard *.c)
OBJ= $(SRC:.c=.o)
CC= gcc
CFLAGS= -Wall -Wextra -g -std=gnu99
LDLIBS= -pthread

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET) $(LDLIBS) 

clean:
	@-rm -f $(TARGET) $(OBJ)

