
void safe_load(int sec,int num,int addr);
void show_mem();



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

typedef struct RegisterImage{
	int SS;
	int GS;
	int FS;
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
	RegisterImage reImg;
	int status;
}PCB;


PCB PCB_Table[4];
int Now_process = 0;
int Total_p = 0;

void Save_Process(int SS,int GS,int FS,int ES,int DS,int DI,int SI,int BP,int SP,int BX,int DX,int CX,int AX,int IP,int CS,int Flags )
{
	PCB_Table[Now_process].reImg.SS = SS;
	PCB_Table[Now_process].reImg.GS = GS;
	PCB_Table[Now_process].reImg.FS = FS;
	PCB_Table[Now_process].reImg.ES = ES;
	PCB_Table[Now_process].reImg.DS = DS;
	PCB_Table[Now_process].reImg.DI = DI;
	PCB_Table[Now_process].reImg.SI = SI;
	PCB_Table[Now_process].reImg.BP = BP;
	PCB_Table[Now_process].reImg.SP = SP;
	PCB_Table[Now_process].reImg.BX = BX;
	PCB_Table[Now_process].reImg.DX = DX;
	PCB_Table[Now_process].reImg.CX = CX;
	PCB_Table[Now_process].reImg.AX = AX;
	PCB_Table[Now_process].reImg.IP = IP;
	PCB_Table[Now_process].reImg.CS = CS;
	PCB_Table[Now_process].reImg.Flags = Flags;
}

int Get_addr()
{
	return &PCB_Table[Now_process];
}

void Scheduler()
{
	for(i = 0;i<17;++i){
		Now_process++;
		if(Now_process>8) Now_process = 0;
		if(PCB_Table[Now_process].status == _DEL) continue;
		else{
			break;
		}
	}
}

void Delete_p()
{
	PCB_Table[Now_process].status = _DEL;
	Total_p--;
}


void init(PCB* pcb,int segement, int offset)
{
	pcb->regImg.GS = 0xb800;
	pcb->regImg.SS = segement;
	pcb->regImg.ES = segement;
	pcb->regImg.DS = segement;
	pcb->regImg.CS = segement;
	pcb->regImg.FS = segement;
	pcb->regImg.IP = offset;
	pcb->regImg.SP = offset - 4;
	pcb->regImg.AX = 0;
	pcb->regImg.BX = 0;
	pcb->regImg.CX = 0;
	pcb->regImg.DX = 0;
	pcb->regImg.DI = 0;
	pcb->regImg.SI = 0;
	pcb->regImg.BP = 0;
	pcb->regImg.FLAGS = 512;
	pcb->Process_Status = _NEW;
}




void safe_load(int sec,int num,int seg,int addr)
{
    s_sector = sec;
    Num_sector = num;
	Seg_addr = seg;
    To_des_addr = addr;
    s_Load();
	init(&PCB_Table[Total_p],seg,addr);
	Total_p++;
}