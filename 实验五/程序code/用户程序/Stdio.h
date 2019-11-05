
void putChar(char a,int h,int l);
void printf(const char*s);
void getC(char* dt);
void getline(char st[]);
void Clears();
int len(const char*s);
int cmp_equ(char*s,char* t);



int _COL = 0;
int _ROW = 0;
char _MESSEAGE;
extern void printChar();
extern void Set_Cursor();

char _GETM = 'A';
int _FLAG = 0;
extern void getChar();

extern void clear();



void set_cur(int h,int l)
{
	_COL = l;
	_ROW = h;
	Set_Cursor();
}


char ttt[100];
int _DISP_POS_ = 4;
void putChar(char a,int h,int l)
{
	_MESSEAGE = a;
	_COL = l;
	_ROW = h;
	printChar();
	_DISP_POS_ = _ROW;
}
void getC(char* dt)
{
	getChar();
	*dt = _GETM;
	
}
void getline(char st[])
{
	
	int i = 0;
	int cntt = 0;
	int init_col = _COL;

	while(1){
		_FLAG  = 0;
		getC(ttt+i);
		
		if(_FLAG  == 1){
			if(_COL>init_col){
				putChar(' ',_ROW,_COL);
				putChar(' ',_ROW,_COL+1);
				putChar('\b',_ROW,_COL);
				_COL--;
			}
			
			
			if(_COL>init_col){
				_COL--;
				i--;
			}
			continue;
		}
		i++;
		_COL++;
		if(ttt[i-1] == '\n'){
			break;
		}
		putChar(ttt[i-1],_ROW,_COL);
	}
	
	putChar('\0',++_DISP_POS_,0);
	for(cntt = 0;cntt<i;++cntt){
		st[cntt] = ttt[cntt];
	}
	st[i-1] = '\0';
}

void printf(const char*s)
{
	int i = 0;
	for(i=0;i<len(s);++i){
		
		if(s[i] == '\n'){
			_DISP_POS_++;
			putChar('\0',_DISP_POS_,0);
		}
		else{
			putChar(s[i],_DISP_POS_,i);
		}
	}
	
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

void Clears()
{
	clear();
	_DISP_POS_ = 0;
}