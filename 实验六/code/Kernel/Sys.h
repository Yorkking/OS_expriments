
void safe_load(int sec,int num,int seg,int addr);
void show_mem();
extern void LOAD_for_INT();


int sector = 0;
extern void Load();


char* _Des;
extern void read();

char* Initdes;
extern void readInit();

int Timer_sector;
extern void Load_Timer();

int s_sector;
int Num_sector;
int To_des_addr;
int Seg_addr;
extern void s_Load();




void show_mem()
{
	int i=0;
	int cnnt = 0;
    char temp_char[80];

	read();
	for(i=0;;++i){
		if(_Des[i] == ';'){
			temp_char[cnnt] = '\0';
			printf(temp_char);
			break;
		} 
		if(_Des[i] == '\n'){
			temp_char[cnnt] = '\n';
            temp_char[cnnt+1] = '\0';
			printf(temp_char);
			cnnt = 0;
			continue;
		}
		temp_char[cnnt] = _Des[i];
		cnnt++;
		
	}
}

int _NEW = 0;
int _PRE = 1;
int _RUN = 2;
int _DEL = 3;
/*int save_GS;
int save_FS;*/
int save_ES;
int save_DS;
int save_DI;
int save_SI;

int save_BP;
int save_SP;
int save_BX;
int save_DX;

int save_CX;
int save_AX;
int save_SS;
int save_IP;

int save_CS;
int save_Flags;

typedef struct RegisterImage{
	int SS;
	int ES;

	int DS;
	int DI;
	int SI;
	int BP;

	int SP;
	int BX;
	int DX;
	int CX;

	int AX;
	int IP;
	int CS;
	int Flags;

}RegisterImage;

typedef struct PCB{
	RegisterImage regImg;
	int status;
}PCB; 


PCB PCB_Table[4];
int Now_process = 0;
int Total_p = 1;
int P_main = 1;
int P_begin = 0;
void Save_Process()
{
	PCB_Table[Now_process].regImg.SS = save_SS;
	PCB_Table[Now_process].regImg.ES = save_ES;
	PCB_Table[Now_process].regImg.DS = save_DS;
	PCB_Table[Now_process].regImg.DI = save_DI;

	PCB_Table[Now_process].regImg.SI = save_SI;
	PCB_Table[Now_process].regImg.BP = save_BP;
	PCB_Table[Now_process].regImg.SP = save_SP;
	PCB_Table[Now_process].regImg.BX = save_BX;

	PCB_Table[Now_process].regImg.DX = save_DX;
	PCB_Table[Now_process].regImg.CX = save_CX;
	PCB_Table[Now_process].regImg.AX = save_AX;
	PCB_Table[Now_process].regImg.IP = save_IP;

	PCB_Table[Now_process].regImg.CS = save_CS;
	PCB_Table[Now_process].regImg.Flags = save_Flags;

}

/*PCB* Get_addr()
{
	return & (PCB_Table[Now_process]);
}
*/
void Scheduler()
{
	while(1){
		Now_process++;
		if(Now_process>=Total_p) Now_process = 0;
		if(PCB_Table[Now_process].status != _DEL) break;
	}
	
	save_AX = PCB_Table[Now_process].regImg.AX;
	save_BX = PCB_Table[Now_process].regImg.BX;
	save_CS = PCB_Table[Now_process].regImg.CS;
	save_CX = PCB_Table[Now_process].regImg.CX;

	save_DI = PCB_Table[Now_process].regImg.DI;
	save_DS = PCB_Table[Now_process].regImg.DS;
	save_DX = PCB_Table[Now_process].regImg.DX;
	save_ES = PCB_Table[Now_process].regImg.ES;

	save_Flags = PCB_Table[Now_process].regImg.Flags;
	save_IP = PCB_Table[Now_process].regImg.IP;
	save_SS = PCB_Table[Now_process].regImg.SS;
	save_SP = PCB_Table[Now_process].regImg.SP;

	save_ES = PCB_Table[Now_process].regImg.ES;
	save_Flags = PCB_Table[Now_process].regImg.Flags;


}

void Delete_p()
{
	PCB_Table[Now_process].status = _DEL;
	Total_p--;
}
void BEGIN()
{
	P_begin = 1;
}

void init(int segement,int offset)
{
	/*(PCB_Table[Total_p].regImg).GS = 0xb800;*/
	(PCB_Table[Total_p].regImg).SS = segement;
	(PCB_Table[Total_p].regImg).ES = segement;
	(PCB_Table[Total_p].regImg).DS = segement;
	(PCB_Table[Total_p].regImg).CS = segement;

	/*(PCB_Table[Total_p].regImg).FS = segement;*/
	(PCB_Table[Total_p].regImg).IP = offset;
	(PCB_Table[Total_p].regImg).SP = offset-4;
	(PCB_Table[Total_p].regImg).AX = 0;
	(PCB_Table[Total_p].regImg).BX = 0;

	(PCB_Table[Total_p].regImg).CX = 0;
	(PCB_Table[Total_p].regImg).DX = 0;
	(PCB_Table[Total_p].regImg).DI = 0;
	(PCB_Table[Total_p].regImg).SI = 0;

	(PCB_Table[Total_p].regImg).BP = 0;
	(PCB_Table[Total_p].regImg).Flags = 512;

	(PCB_Table[Total_p]).status = _NEW;

	Total_p++;
}

void ALL_INIT()
{
	Total_p = 1;
	P_begin = 0;
}


void safe_load(int sec,int num,int seg,int addr)
{
    s_sector = sec;
    Num_sector = num;
	Seg_addr = seg;
    To_des_addr = addr;
    s_Load();
	
}
void Inc_Num()
{
	Total_p++;
}

int getNum_p()
{
	return Total_p;
}