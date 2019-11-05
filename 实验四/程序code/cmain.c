char FLAG_TO_JUMP = 'a';

int col = 0;
int row = 0;
char Message;
extern void printChar();

char GetM = 'A';
int Flag = 0;
extern void getChar();

int sector = 0;
extern void Load();
extern void clear();

char* des;
extern void read();

char* Initdes;
extern void readInit();


int Timer_sector;
extern void Load_Timer();

int len(const char*s);

char mess[20][50];
char ttt[30];
char tempchar[20] = "welcome to kernel!";
char *sy = ">kernel$";
char command[20];
char A = 'a';
char com[][10] = {"ls","run","clear","help","init.cmd"};

int disp_pos = 4;
int cntt = 0;
int m_cnt = 0;
char temp_char[80];
int ii=0;



void Clears()
{
	clear();
	disp_pos = 0;
}

void putChar(char a,int h,int l)
{
	Message = a;
	col = l;
	row = h;
	printChar();
	disp_pos = row;
	
}
void getC(char* dt)
{
	getChar();
	*dt = GetM;
	
}
void getline(char st[])
{
	
	int i = 0;
	int cntt = 0;
	int init_col = col;

	while(1){
		Flag = 0;
		getC(ttt+i);
		
		if(Flag == 1){
			if(col>init_col){
				putChar(' ',row,col);
				putChar(' ',row,col+1);
				putChar('\b',row,col);
				col--;
			}
			
			
			if(col>init_col){
				col--;
				i--;
			}
			continue;
		}
		i++;
		col++;
		if(ttt[i-1] == ' '|| ttt[i-1] == '\n'){
			break;
		}
		putChar(ttt[i-1],row,col);
	}
	
	putChar('$',++disp_pos,0);
	for(cntt = 0;cntt<i;++cntt){
		st[cntt] = ttt[cntt];
	}
	st[i-1] = '\0';
}

void printf(const char*s)
{
	int i = 0;
	
	for(i=0;i<len(s);++i){
		putChar(s[i],disp_pos,i);
	}
	disp_pos++;
}

int len(const char*s)
{
	int cnt = 0;
	while(s[cnt++]!='\0');
	cnt--;
	return cnt;
}

int cmp_equ(char*s,char* t)
{
	int i = 0;
	if(len(s)!=len(t)) return 0;
	
	for(i=0;i<len(s);++i){
		if(s[i] != t[i]) return 0;
	}

	return 1;
}
void show_mem()
{
	int i=0;
	int cnnt = 0;

	read();
	for(i=0;;++i){
		if(des[i] == ';'){
			temp_char[cnnt] = '\0';
			printf(temp_char);
			break;
		} 
		if(des[i] == '\n'){
			temp_char[cnnt] = '\0';
			printf(temp_char);
			cnnt = 0;
			continue;
		}
		temp_char[cnnt] = des[i];
		cnnt++;
		
	}
	


}



void cmain(){

	int i=0;
	
	


	printf(tempchar);

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

		for( ii=0;ii<len(tempchar);++ii){
			if(ii == len(tempchar)-1 || tempchar[ii+1] == ','){
				sector = tempchar[ii]-'0'+3;
				Load();
				there1:
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

