/**
 * @author Dayun kang(20185280)
 */
#include "snake.h"

#define MAPWIDTH 60
#define MAPHEIGHT 30
#define SBWIDTH 30
#define SBHEIGHT 30

void snakeclass::createSB()
{
	//up-vertical
    for(int i=0;i<SBWIDTH-3;i++)
	{
		move(0,MAPWIDTH + i);
		addch(wall);
	}
	//left-horizontal
	for(int i=0;i<SBHEIGHT-1;i++)
	{
		move(i, MAPWIDTH);
		addch(wall);
	}
	//down-vertical
	for(int i=0;i<SBWIDTH-3;i++)
	{
		move(SBWIDTH-2,MAPWIDTH + i);
		addch(wall);
	}
	//right-horizontal
	for(int i=0;i<SBHEIGHT-1;i++)
	{
		move(i,MAPWIDTH + SBWIDTH-4);
		addch(wall);
	}

	move(2,MAPWIDTH + 1);
	printw("+++++++++++++++++++++++++");
	move(3,MAPWIDTH + 3);
	printw("Score Board");
	move(5,MAPWIDTH + 3);
	printw("B : %d / %d",curLength,maxLength);
	move(7,MAPWIDTH + 3);
	printw("+ : %d",cntfood);
	move(9,MAPWIDTH + 3);
	printw("- : %d",cntpoison);
	move(11,MAPWIDTH + 3);
	printw("G : %d", cntgate);
	move(13,MAPWIDTH + 3);
	printw("Mission");
	move(15,MAPWIDTH + 3);
	printw("B : 10 ( )");
	move(17,MAPWIDTH + 3);
	printw("+ : 3 ( )");
	move(19,MAPWIDTH + 3);
	printw("- : 2 ( )");
	move(21,MAPWIDTH + 3);
	printw("G : 1 ( )");
	move(22,MAPWIDTH + 1);
	printw("+++++++++++++++++++++++++");
	move(23,MAPWIDTH + 4);
	printw("Coin");
	move(24,MAPWIDTH + 3);
	printw(": %d", cntcoin);
	move(23,MAPWIDTH + 15);
	printw("~300 : +--");
	move(24,MAPWIDTH + 15);
	printw("~600 : +!!");
	move(25,MAPWIDTH + 15);
	printw("~900 : @~~");
	move(26,MAPWIDTH + 14);
	printw("~1200 : @==");
	move(27,MAPWIDTH + 14);
	printw("1200~ : HBB");
	move(23,MAPWIDTH + 12);
	printw("|");
	move(24,MAPWIDTH + 12);
	printw("|");
	move(25,MAPWIDTH + 12);
	printw("|");
	move(26,MAPWIDTH + 12);
	printw("|");
	move(27,MAPWIDTH + 12);
	printw("|");
}

