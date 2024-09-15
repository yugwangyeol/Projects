/**
 * @author Dayun kang(20185280), Gwangyeol Yu(20192780)
 */
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctime>
#include <cstdlib>
#include "snake.h"
#include <time.h>
using namespace std;

#define MAPWIDTH 60
#define MAPHEIGHT 30

static int cntmission=0;
static int stage = 1;

clock_t st_f, et_f, st_p, et_p, st_c, et_c,
        st_g1, et_g1, st_g2, et_g2, st_g3, et_g3, st_g4, et_g4;

snakepart::snakepart(int col,int row)
{
	x=col;
	y=row;
}

snakepart::snakepart()
{
	x=0;
	y=0;
}
snakeclass::snakeclass()
{
	initscr();
	nodelay(stdscr,true);
	keypad(stdscr,true);
	noecho();
	curs_set(0);		
	getmaxyx(stdscr,maxheight,maxwidth);
	bodyChar='x';
	wall='+';
	immwall = '#';
	foodChar='*';
	poisonChar='p';
	coinChar='C';
	gateChar='g';
	head = '+';
	body = '-';
	cntfood=0;
	cntpoison=0;
	cntgate=0;
	curLength=3;
	maxLength=3;
	cntcoin=0;
	food.x=0;
	food.y=0;
	poison.x=0;
	poison.y=0;
	gate1.x=0;
	gate1.y=0;
	gate2.x=0;
	gate2.y=0;
	coin.x=0;
	coin.y=0;
	gameover = true;
	points=0;
	del=110000;
	getFood=0;
	direction='l';

	//Fix the initial starting position.
	for(int i=0;i<3;i++)
		snake.push_back(snakepart(10+i,10));

	if(cntmission==4)
	{
		wclear(stdscr);
		createMap(2);
	}
	else if(cntmission==8)
	{
		wclear(stdscr);
		createMap(3);
	}
	else if(cntmission==12)
	{
		wclear(stdscr);
		createMap(4);
	}
	else
		createMap(1);

	move(1,MAPWIDTH + 3);
	printw("STAGE (%d/4)", stage);
	createSB();
	putfood();
	putpoison();
	putcoin();
	
	//draw the snake
	for(int i=0;i<snake.size();i++)
	{
		move(snake[i].y,snake[i].x);
		addch(bodyChar);
	}
	refresh();
}

snakeclass::~snakeclass()
{
	nodelay(stdscr,false);
	getch();
	endwin();
}

void snakeclass::partClassify(int x, int y, char part)
{
	data[x][y] = part;
}

void snakeclass::putfood()
{
	st_f = time(NULL);
	while(1)
	{
		int tmpx=rand()%MAPWIDTH+1;
		int tmpy=rand()%MAPHEIGHT+1;
		for(int i=0;i<snake.size();i++)
			if(snake[i].x==tmpx && snake[i].y==tmpy) continue;
		if(tmpx>=MAPWIDTH-4 || tmpy>=MAPHEIGHT-3) continue;
		if(data[tmpy][tmpx]=='1'||data[tmpy][tmpx]=='3'||data[tmpy][tmpx]=='4') continue;
		food.x=tmpx;
		food.y=tmpy;
		break;
	}
	mvaddch(food.y,food.x,foodChar);
	partClassify(food.y,food.x, '5');
	refresh();
}

void snakeclass::putpoison()
{
	st_p = time(NULL);
	while(1)
	{
		int px=rand()%MAPWIDTH+1;
		int py=rand()%MAPHEIGHT+1;
		for(int i=0;i<snake.size();i++)
			if(snake[i].x==px && snake[i].y==py) continue;
		if(px>=MAPWIDTH-4 || py>=MAPHEIGHT-3) continue;
		if(data[py][px]=='1'||data[py][px]=='3'||data[py][px]=='4') continue;
		poison.x=px;
		poison.y=py;
		break;
	}
	mvaddch(poison.y,poison.x,poisonChar);
	partClassify(poison.y,poison.x, '6');
	refresh();
}

void snakeclass::putcoin()
{
	st_c = time(NULL);
	while(1)
	{
		int cx=rand()%MAPWIDTH+1;
		int cy=rand()%MAPHEIGHT+1;
		for(int i=0;i<snake.size();i++)
			if(snake[i].x==cx && snake[i].y==cy) continue;
		if(cx>=MAPWIDTH-4 || cy>=MAPHEIGHT-3) continue;
		if(data[cy][cx]=='1'||data[cy][cx]=='3'||data[cy][cx]=='4') continue;
		coin.x=cx;
		coin.y=cy;
		break;
	}
	mvaddch(coin.y,coin.x,coinChar);
	partClassify(coin.y,coin.x, '8');
	refresh();
}

void snakeclass::putgate1()
{
	while(1)
	{
		gx1=rand()%MAPWIDTH+1;
		gy1=rand()%MAPHEIGHT+1;
		if(data[gy1][gx1]!='1')
		{
			gate1.x=gx1;
			gate1.y=gy1;
			continue;
		}
		gate1.x=gx1;
		gate1.y=gy1;
		break;
	}
	mvaddch(gate1.y,gate1.x,gateChar);
	partClassify(gate1.y,gate1.x, '7');
	refresh();
}

void snakeclass::putgate2(){
	while(1)
	{
		gx2=rand()%MAPWIDTH+1;
		gy2=rand()%MAPHEIGHT+1;
		if(data[gy2][gx2]!='1')
		{
			gate2.x=gx2;
			gate2.y=gy2;
			continue;
		}
		gate2.x=gx2;
		gate2.y=gy2;
		break;
	}
	mvaddch(gate2.y,gate2.x,gateChar);
	partClassify(gate2.y,gate2.x, '7');
	refresh();
}

bool snakeclass::collision()
{
	if(points<0)
		return true;
	if(data[snake[0].y][snake[0].x] == '1')
		return true;
	partClassify(snake[0].y, snake[0].x, '3');
	for(int i = 1; i<snake.size(); i++)
		partClassify(snake[i].y, snake[i].x, '4');
	for(int i=2;i<snake.size();i++)
		if(snake[0].x==snake[i].x && snake[0].y==snake[i].y) return true;

	//collision with the food
	if(snake[0].x==food.x && snake[0].y==food.y)
	{
		getFood=true;
		cntfood++;
		putfood();
		points+=10;
		curLength++;
		if(curLength>maxLength)
			maxLength=curLength;
		move(5,MAPWIDTH + 3);
		printw("B : %d / %d",curLength,maxLength);
		move(7,MAPWIDTH + 3);
		printw("+ : %d",cntfood);
		if (cntfood == 3)
		{
			move(17,MAPWIDTH + 3);
			printw("+ : 3 (V)");
			cntmission++;
		}
		if (curLength==10)
		{
			move(15,MAPWIDTH + 3);
			printw("B : 10 (V)");
			cntmission++;
		}
		if((points%100)==0)
			del-=10000;
	}
	else
		getFood=false;

	//collision with the poison
	if(snake[0].x==poison.x && snake[0].y==poison.y)
	{
		getPoison=true;
		cntpoison++;
		putpoison();
		points-=10;
		curLength--;
		move(5,MAPWIDTH + 3);
		printw("B : %d / %d",curLength,maxLength);
		if (cntpoison == 2)
		{
			move(19,MAPWIDTH + 3);
			printw("- : 2 (V)");
			cntmission++;
		}
		move(7,MAPWIDTH + 3);
		printw("+ : %d",cntfood);
		move(9,MAPWIDTH + 3);
		printw("- : %d",cntpoison);
		if((points%100)==0)
			del-=10000;
	}
	else
		getPoison=false;

	if(snake[0].x==coin.x && snake[0].y==coin.y)
	{
		getCoin=true;
		cntcoin += 100;
		move(24,MAPWIDTH + 3);
		printw(": %d", cntcoin);
		putcoin();
	} 
	else 
		getCoin=false;
	return false;
}

void snakeclass::gateopen()
{
	putgate1();
	putgate2();
}

void snakeclass::newgate()
{
	for (int i=0;i<MAPWIDTH+1;i++)
	{
		for (int j=0;j<MAPHEIGHT+1;j++)
		{
			if (data[j][i] == '7')
			{
				fg = 1;
				break;
			} 
			else
				fg = 0;
		}
	}
	if (fg == 0)
		gateopen();
}


void snakeclass::movesnake()
{
	//detect key
	int tmp=getch();
	switch(tmp)
	{
		case KEY_LEFT:
			if(direction!='r')
				direction='l';
			break;
		case KEY_UP:
			if(direction!='d')
				direction='u';
			break;
		case KEY_DOWN:
			if(direction!='u')
				direction='d';
			break;
		case KEY_RIGHT:
			if(direction!='l')
				direction='r';
			break;
		case KEY_BACKSPACE:
			direction='q';
			break;
	}
	//if there wasn't a collision with food, prevent tails from forming.
	if(!getFood)
	{
		move(snake[snake.size()-1].y,snake[snake.size()-1].x);
		partClassify(snake[snake.size()-1].y,snake[snake.size()-1].x, '0');
		printw(" ");
		refresh();
		snake.pop_back();
	}

	//if there was a collision with poison, cut tail.
	if(getPoison)
	{
		move(snake[snake.size()-1].y,snake[snake.size()-1].x);
		partClassify(snake[snake.size()-1].y,snake[snake.size()-1].x, '0');
		printw(" ");
		refresh();
		snake.pop_back();
	}

	//if there was a collision with coin, change shape.
	if(getCoin)
	{
		if(cntcoin >= 1200){
			head = 'H';
			body = 'B';
		} else if (cntcoin >= 900){
			head = '@';
			body = '=';
		} else if (cntcoin >= 600){
			head = '@';
			body = '~';
		} else if (cntcoin >= 300){
			head = '+';
			body = '!';
		}
	}

	if(snake[0].x == gate1.x && snake[0].y == gate1.y){
		snake[0].x = gate2.x;
		snake[0].y = gate2.y;
		if(gate2.x == 0){
			direction = 'r';
		} else if (gate2.x == MAPWIDTH-4){
			direction = 'l';
		} else if (gate2.y == 0){
			direction = 'd';
		} else if (gate2.y == MAPHEIGHT-2){
			direction = 'u';
		} else if (direction == 'l'){
			if (data[gate2.y+1][gate2.x] == '1'){
				direction = 'l';
			} else {
				direction = 'd';
			}
		} else if (direction == 'r'){
			if (data[gate2.y-1][gate2.x] == '1'){
				direction = 'r';
			} else {
				direction = 'u';
			}
		} else if (direction == 'u'){
			if (data[gate2.y][gate2.x+1] == '1'){
				direction = 'u';
			} else {
				direction = 'l';
			}
		} else if (direction == 'd') {
			if (data[gate2.y][gate2.x-1] == '1'){
				direction = 'd';
			} else {
				direction = 'r';
			}
		}
	} else if (snake[0].x == gate2.x && snake[0].y == gate2.y){
			snake[0].x = gate1.x;
			snake[0].y = gate1.y;
			if(gate1.x == 0){
				direction = 'r';
			} else if (gate1.x == MAPWIDTH-4){
				direction = 'l';
			} else if (gate1.y == 0){
				direction = 'd';
			} else if (gate1.y == MAPHEIGHT-2){
				direction = 'u';
			} else if (direction == 'l'){
				if (data[gate1.y+1][gate1.x] == '1'){
					direction = 'l';
				} else {
					direction = 'd';
				}
			} else if (direction == 'r'){
				if (data[gate1.y-1][gate1.x] == '1'){
					direction = 'r';
				} else {
					direction = 'u';
				}
			} else if (direction == 'u'){
				if (data[gate1.y][gate1.x+1] == '1'){
					direction = 'u';
				} else {
					direction = 'l';
				}
			} else if (direction == 'd') {
				if (data[gate1.y][gate1.x-1] == '1'){
					direction = 'd';
				} else {
					direction = 'r';
				}
			}
	}

	if(direction=='l')
	{
		snake.insert(snake.begin(),snakepart(snake[0].x-1,snake[0].y));
	}else if(direction=='r'){
		snake.insert(snake.begin(),snakepart(snake[0].x+1,snake[0].y));
	}else if(direction=='u'){
		snake.insert(snake.begin(),snakepart(snake[0].x,snake[0].y-1));
	}else if(direction=='d'){
		snake.insert(snake.begin(),snakepart(snake[0].x,snake[0].y+1));
	}
		move(snake[0].y,snake[0].x);
		for (int i=0;i<snake.size();i++){
			if(i==0){
				mvaddch(snake[i].y,snake[i].x,head);
			} else if (i == snake.size()-1){
				mvaddch(snake[i].y,snake[i].x,body);
				if((snake[i].x == gate1.x && snake[i].y == gate1.y)||
					 (snake[i].x == gate1.x && snake[i].y == gate1.y)||
				 	 (snake[i].x == gate1.x && snake[i].y == gate1.y)||
				   (snake[i].x == gate1.x && snake[i].y == gate1.y)){
						 gtx1 = gate1.x;
						 gty1 = gate1.y;
						 gtx2 = gate2.x;
						 gty2 = gate2.y;
						 partClassify(gty1,gtx1,'1');
						 partClassify(gty2,gtx2,'1');
						newgate();
						cntgate++;
						move(11,MAPWIDTH + 3);
						printw("G : %d",cntgate);
						if(cntgate == 1)
						{
							move(21,MAPWIDTH + 3);
							printw("G : 1 (V)");
							cntmission++;
						}
				} else if ((snake[i].x == gate2.x && snake[i].y == gate2.y)||
					 				 (snake[i].x == gate2.x && snake[i].y == gate2.y)||
				 	 		 		 (snake[i].x == gate2.x && snake[i].y == gate2.y)||
				   		 		 (snake[i].x == gate2.x && snake[i].y == gate2.y)){
										 gtx1 = gate1.x;
										 gty1 = gate1.y;
										 gtx2 = gate2.x;
										 gty2 = gate2.y;
										 partClassify(gty1,gtx1,'1');
										 partClassify(gty2,gtx2,'1');
										 newgate();
										 cntgate++;
										 move(11,MAPWIDTH + 3);
										 printw("G : %d",cntgate);
										 if(cntgate == 1)
										 {
											 move(21,MAPWIDTH + 3);
											 printw("G : 1 (V)");
											 cntmission++;
										 }
				} else {
					mvaddch(snake[i].y,snake[i].x,body);
					mvaddch(gty1,gtx1,wall);
					mvaddch(gty2,gtx2,wall);
					partClassify(gty1,gtx1,'1');
					partClassify(gty2,gtx2,'1');
				}
			} else {
				mvaddch(snake[i].y,snake[i].x,body);
				mvaddch(gty1,gtx1,wall);
				mvaddch(gty2,gtx2,wall);
				partClassify(gty1,gtx1,'1');
				partClassify(gty2,gtx2,'1');
			}
		}
	refresh();
	et_f = time(NULL);
	et_p = time(NULL);
	et_c = time(NULL);
	//if there wasn't a collision with food within 5sec, recreate food.
	if(et_f-st_f >= 5)
	{
		partClassify(food.y, food.x, '0');
		mvaddch(food.y, food.x, ' ');
		putfood();
	}
	//if there wasn't a collision with poison within 5sec, recreate poison.
	if(et_p-st_p >= 5)
	{
		partClassify(poison.y, poison.x, '0');
		mvaddch(poison.y, poison.x, ' ');
		putpoison();
	}
	//if there wasn't a collision with coin within 5sec, recreate coin.
	if(et_c-st_c >= 5)
	{
		partClassify(coin.y, coin.x, '0');
		mvaddch(coin.y,coin.x, ' ');
		putcoin();
	}
	//From the moment the length of the snake's size reaches 5, create gate.
	if(snake.size()==5 && getFood && dg == 0){
		if(dg == 0){
			newgate();
			dg = 1;
		} else {
			dg = 0;
		}
	}
}

//Start game, stage 1
void snakeclass::start1()
{
	st_g1 = time(NULL);
	while(1)
	{
		et_g1 = time(NULL);
		move(1,MAPWIDTH + 16);
		printw("Time : %d", et_g1-st_g1);
		if(collision())
		{
			move(15,20);
			printw("### GAME_OVER ###");
			break;
		}
		if(cntmission==4)
		{
			stage++;
			gameover = false;
			break;
		}
		movesnake();
		if(direction=='q')
			break;
		usleep(del);
	}
}

//Start game, stage 2
void snakeclass::start2()
{
	st_g2 = time(NULL);
	if(stage==2)
	{
		while(1)
		{
			et_g2 = time(NULL);
			move(1,MAPWIDTH + 16);
			printw("Time : %d", et_g2-st_g2);
			if(collision())
			{
				move(15,20);
				printw("### GAME_OVER ###");
				break;
			}
			if(cntmission==8)
			{
				stage++;
				gameover = false;
				break;
			}
			movesnake();
			if(direction=='q')
				break;
			usleep(del);
		}
	}
}

//Start game, stage 3
void snakeclass::start3()
{
	st_g3 = time(NULL);
	if(stage==3)
	{
		while(1)
		{
			et_g3 = time(NULL);
			move(1,MAPWIDTH + 16);
			printw("Time : %d", et_g3-st_g3);
			if(collision())
			{
				move(15,20);
				printw("### GAME_OVER ###");
				break;
			}
			if(cntmission==12)
			{
				stage++;
				gameover = false;
				break;
			}
			movesnake();
			if(direction=='q')
				break;
			usleep(del);
		}
	}
}

//Start game, stage 4
void snakeclass::start4()
{
	st_g4 = time(NULL);
	if(stage==4)
	{
		while(1)
		{
			et_g4 = time(NULL);
			move(1,MAPWIDTH + 16);
			printw("Time : %d", et_g4-st_g4);
			if(collision())
			{
				move(15,20);
				printw("### GAME_OVER ###");
				break;
			}
			if(cntmission==16)
			{
				move(17,20);
				printw("### YOU_WIN ###");
				break;
			}
			movesnake();
			if(direction=='q')
				break;
			usleep(del);
		}
	}
}
