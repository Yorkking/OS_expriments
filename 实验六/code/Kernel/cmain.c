
#include"Stdio.h"
#include "Sys1.h"


const int  OffSet_user = 0x100;
const int Seg_user = 0x900;
int Num_pro = 0;

char mess[20][50];
const char*temptemp = "welcome to kernel!\n";
char tempchar[20];
const char *sy = ">kernel$";
char command[20];
char A = 'a';
char com[][10] = {"ls","run","clear","help","init.cmd","int33"};
void DELAY();

int cntt = 0;
int m_cnt = 0;
int sec_num[11] = {1,1,1,1,1,1,1,1,1,1,1};

void cmain(){
	int i = 0;
	int teee = 0;
	int des_ad = OffSet_user;
	char tchar[40];
	_DISP_POS_ = 3;
	printf(temptemp);

	Timer_sector = 3;
	Load_Timer();

	there:
	printf(sy);
	

	getline(command);

	if(cmp_equ(command,com[0]) == 1){
		show_mem();
	}
	else if(cmp_equ(command,com[2]) == 1){
		Clears();
	}

	else if(cmp_equ(command,com[1]) == 1){
		getline(tempchar);
		printf(tempchar);

		
		for( i=0;i<len(tempchar);++i){
			if(i == len(tempchar)-1 || tempchar[i+1] == ','){

				teee = tempchar[i]-'0'+3;
				/*sector = tempchar[i]-'0'+3;
				Load();*/
				
				if(Num_pro>4) Num_pro = 0;
				safe_load(teee,1,Seg_user+Num_pro*0x100,OffSet_user);
				init(Seg_user+Num_pro*0x100,OffSet_user);
				Num_pro++;

				/*safe_load(teee,sec_num[tempchar[i]-'0'],des_ad);*/
				
			}
		}
		Clears();
		BEGIN();
		getline(tchar);
		ALL_INIT();
		Clears();
		printf("run done\n");

	}
	else if(cmp_equ(command,com[3]) == 1){
		printf("A list of commands:\n");
		printf("<ls        >Directory View\n");
		printf("<clear     >Clear screen\n");
		printf("<run       >The next line to input program to run\n");
		printf("<help      >Show the commands\n");
		printf("<int33     >Execute the int33 file\n");


	}
	else if(cmp_equ(command,com[4]) == 1){
		readInit();
		for(i=0;;i++){
			if(Initdes[i] == ';') break;
			if(Initdes[i+1] == ';' || Initdes[i+1] == ','){
				sector = Initdes[i]-'0'+5;
				Load();
				printf("run done\n");
			}


		}

	}
	else if(cmp_equ(command,com[5]) == 1){
		Clears();
		LOAD_for_INT();
	}
	else if(command[0] != '\0' && command[0] != ' '  ){
		printf("Invalid input! You can input 'help' for help!\n");
	}
	
	goto there;

}


void DELAY()
{
	int i = 0;
	int j = 0;
	printf("OK\n");
	for( i=0;i<30000;i++ )
		for( j=0;j<30000;j++ )
		{
			j++;
			j--;
			
		}
	printf("OK\n");
}