NAME = filter-a-cond.so filter-aaaa-cond.so
SRCS = filter-a-cond.c filter-aaaa-cond.c
LDFLAGS = -Wall -Wextra -Wwrite-strings -Wpointer-arith -Wno-missing-field-initializers -Wformat -Wshadow \
	-Werror=implicit-function-declaration -Werror=missing-prototypes \
	-Werror=format-security -Werror=parentheses -Werror=implicit -Werror=strict-prototypes -Werror=vla \
	-fno-strict-aliasing -fno-delete-null-pointer-checks -fdiagnostics-show-option \
	-g -O2 -pthread -shared -export-dynamic \
	-lpthread

CFLAGS = -Wall -Wextra -Wwrite-strings -Wpointer-arith -Wno-missing-field-initializers -Wformat \
	-Wshadow -Werror=implicit-function-declaration -Werror=missing-prototypes \
	-Werror=format-security -Werror=parentheses -Werror=implicit -Werror=strict-prototypes -Werror=vla \
	-fno-strict-aliasing -fno-delete-null-pointer-checks -fdiagnostics-show-option \
	-include config.h \
	-g -O2 -I/usr/include/x86_64-linux-gnu -pthread \
	-fPIC -DPIC -MD

OBJS = ${SRCS:.c=.o}
DEPS = ${SRCS:.c=.d}
CC		= gcc
%.o: %.c
		$(CC) -c $(CFLAGS) -o $@ $<
%.so: %.o
		${CC} ${LDFLAGS} -o $@ $<

all:	${NAME}
clean:
		rm -f ${OBJS}
		rm -f ${DEPS}
fclean:	clean
		rm ${NAME}
		
re:		fclean all
install: all
		sudo cp ${NAME} /usr/lib/x86_64-linux-gnu/bind
test: install
		sudo systemctl restart named
.PHONY : clean all fclean re
