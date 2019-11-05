
#include"Stdio.h"
#include "Sys.h"


const int  OffSet_user = 0x9000;
const int Seg_user = 0x0000;
int Num_pro = 0;

char mess[20][50];
const char*temptemp = "welcome to kernel!\n";
char tempchar[20];
const char *sy = ">kernel$";
char command[20];
char A = 'a';
char com[][10] = {"ls","run","clear","help","init.cmd"};


int cntt = 0;
int m_cnt = 0;
int sec_num[11] = {1,1,1,1,1,1,1,1,1,1,1};

void cmain(){
	int i = 0;
	int teee = 0;
	int des_ad = OffSet_user;

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
				

				Clears();
				if(Num_pro>4) Num_pro = 0;
				safe_load(teee,1,Seg_user,OffSet_user+Num_pro* 0x1000);
				Num_pro++;	
				/*safe_load(teee,sec_num[tempchar[i]-'0'],des_ad);*/
				printf("run done\n");
			}
		}

	}
	else if(cmp_equ(command,com[3]) == 1){
		printf("A list of commands:\n");
		printf("<ls        >Directory View\n");
		printf("<clear     >Clear screen\n");
		printf("<run       >The next line to input program to run\n");
		printf("<help      >Show the commands\n");
		printf("<init.cmd  >Execute the file\n");


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

	else if(command[0] != '\0' && command[0] != ' '  ){
		printf("Invalid input! You can input 'help' for help!\n");
	}

	goto there;

}

