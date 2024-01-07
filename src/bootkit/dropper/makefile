CC = gcc
CFLAGS = -Wall -Wextra -g
SRC = dropper.c
OBJ = $(SRC:.c=.o)
EXEC = dropper

all: $(EXEC)

$(EXEC): $(OBJ)
	$(CC) $(CFLAGS) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(EXEC)