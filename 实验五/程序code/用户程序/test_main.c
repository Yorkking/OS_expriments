#include "Stdio.h"
char et[40];
void main()
{
    Clears();
    printf("this is a test!\n");

    getline(et);

    printf("return 0 ...........press any key to continue....\n");
    getline(et);

}