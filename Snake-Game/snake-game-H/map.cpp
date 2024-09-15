/**
 * @author Dayun kang(20185280)
 */
#include "snake.h"

#define MAPWIDTH 60
#define MAPHEIGHT 30

void snakeclass::createMap(int stage)
{
    switch (stage)
    {
	//Stage 1 map
    case (1):
    	//up-vertical
		for(int i=0;i<MAPWIDTH-3;i++)
		{
			mvaddch(0,i,wall);
        	partClassify(0, i, '1');
		}
		//left-horizontal
		for(int i=0;i<MAPHEIGHT-1;i++)
		{
			mvaddch(i,0,wall);
        	partClassify(i, 0, '1');
		}
		//down-vertical
		for(int i=0;i<MAPWIDTH-3;i++)
		{
			mvaddch(MAPHEIGHT-2,i,wall);
   	    	partClassify(MAPHEIGHT-2,i, '1');
		}
		//right-horizontal
		for(int i=0;i<MAPHEIGHT-1;i++)
		{
			mvaddch(i,MAPWIDTH-4,wall);
    	    partClassify(i,MAPWIDTH-4, '1');
		}
		mvaddch(0,0,immwall);
		partClassify(0, 0, '2');
		mvaddch(0,MAPWIDTH-4,immwall);
		partClassify(0, MAPWIDTH-4, '2');
		mvaddch(MAPHEIGHT-2,0,immwall);
		partClassify(MAPHEIGHT-2, 0, '2');
		mvaddch(MAPHEIGHT-2,MAPWIDTH-4,immwall);
		partClassify(MAPHEIGHT-2,MAPWIDTH-4, '2');
  	    break;
	
	//Stage 2 map
    case(2):
	   	for(int i=0;i<MAPWIDTH-3;i++)
		{
			mvaddch(0,i,wall);
  	    	partClassify(0, i, '1');
		}
		for(int i=0;i<MAPHEIGHT-1;i++)
		{
			mvaddch(i,0,wall);
    	    partClassify(i, 0, '1');
		}
		for(int i=0;i<MAPWIDTH-3;i++)
		{
			mvaddch(MAPHEIGHT-2,i,wall);
    	    partClassify(MAPHEIGHT-2,i, '1');
		}
		for(int i=0;i<MAPHEIGHT-1;i++)
		{
			mvaddch(i,MAPWIDTH-4,wall);
    	    partClassify(i,MAPWIDTH-4, '1');
		}
    	for(int i=0;i<MAPWIDTH/4-1;i++)
		{
			mvaddch(MAPHEIGHT/2,i,wall);
    	    partClassify(MAPHEIGHT/2,i,'1');
		}
    	for(int i=MAPWIDTH-4;i>MAPWIDTH-(MAPWIDTH/3);i--)
		{
			mvaddch(MAPHEIGHT/2,i,wall);
    	    partClassify(MAPHEIGHT/2,i, '1');
		}
    	mvaddch(0,0,immwall);
		partClassify(0, 0, '2');
		mvaddch(0,MAPWIDTH-4,immwall);
		partClassify(0, MAPWIDTH-4, '2');
		mvaddch(MAPHEIGHT-2,0,immwall);
		partClassify(MAPHEIGHT-2, 0, '2');
		mvaddch(MAPHEIGHT-2,MAPWIDTH-4,immwall);
		partClassify(MAPHEIGHT-2,MAPWIDTH-4, '2');
		mvaddch(MAPHEIGHT/2,0,immwall);
		partClassify(MAPHEIGHT/2, 0, '2');
		mvaddch(MAPHEIGHT/2,MAPWIDTH-4,immwall);
		partClassify(MAPHEIGHT/2,MAPWIDTH-4, '2');
        break;

	//Stage 3 map
    case(3):
    	for(int i=0;i<MAPWIDTH-3;i++)
		{
			mvaddch(0,i,wall);
        	partClassify(0, i, '1');
		}
		for(int i=0;i<MAPHEIGHT-1;i++)
		{
			mvaddch(i,0,wall);
        	partClassify(i, 0, '1');
		}
		for(int i=0;i<MAPWIDTH-3;i++)
		{
			mvaddch(MAPHEIGHT-2,i,wall);
       		partClassify(MAPHEIGHT-2,i, '1');
		}
		for(int i=0;i<MAPHEIGHT-1;i++)
		{
			mvaddch(i,MAPWIDTH-4,wall);
        	partClassify(i,MAPWIDTH-4, '1');
		}
    	for(int i=0;i<MAPWIDTH/4-1;i++)
		{
			mvaddch(MAPHEIGHT/2,i,wall);
    	    partClassify(MAPHEIGHT/2,i,'1');
		}
    	for(int i=MAPWIDTH-4;i>MAPWIDTH-(MAPWIDTH/3);i--)
		{
			mvaddch(MAPHEIGHT/2,i,wall);
  	    	partClassify(MAPHEIGHT/2,i, '1');
		}
   		for(int i=0;i<MAPHEIGHT/5-1;i++)
		{
			mvaddch(i,(MAPWIDTH-4)/2,wall);
			partClassify(i,(MAPWIDTH-4)/2, '1');
		}
    	for(int i=MAPHEIGHT-2;i>MAPHEIGHT-(MAPHEIGHT/5)-1;i--)
		{
			mvaddch(i,(MAPWIDTH-4)/2,wall);
			partClassify(i,(MAPWIDTH-4)/2, '1');
		}
		mvaddch(0,0,immwall);
		partClassify(0, 0, '2');
		mvaddch(0,MAPWIDTH-4,immwall);
		partClassify(0, MAPWIDTH-4, '2');
		mvaddch(MAPHEIGHT-2,0,immwall);
		partClassify(MAPHEIGHT-2, 0, '2');
		mvaddch(MAPHEIGHT-2,MAPWIDTH-4,immwall);
		partClassify(MAPHEIGHT-2,MAPWIDTH-4, '2');
		mvaddch(MAPHEIGHT/2,0,immwall);
		partClassify(MAPHEIGHT/2, 0, '2');
		mvaddch(MAPHEIGHT/2,MAPWIDTH-4,immwall);
		partClassify(MAPHEIGHT/2,MAPWIDTH-4, '2');
		mvaddch(0,(MAPWIDTH-4)/2,immwall);
		partClassify(0,(MAPWIDTH-4)/2, '2');
		mvaddch(MAPHEIGHT-2,(MAPWIDTH-4)/2,immwall);
		partClassify(MAPHEIGHT-2,(MAPWIDTH-4)/2, '2');
		break;

	//Stage 4 map
    case (4):
		for(int i=0;i<MAPWIDTH-3;i++)
		{
			mvaddch(0,i,wall);
			partClassify(0, i, '1');
		}
		for(int i=0;i<MAPHEIGHT-1;i++)
		{
			mvaddch(i,0,wall);
			partClassify(i,0, '1');
		}
		for(int i=0;i<MAPWIDTH-3;i++)
		{
			mvaddch(MAPHEIGHT-2,i,wall);
			partClassify(MAPHEIGHT-2,i, '1');
		}
		for(int i=0;i<MAPHEIGHT-1;i++)
		{
			mvaddch(i,MAPWIDTH-4,wall);
			partClassify(i,MAPWIDTH-4, '1');
		}
    	for(int i=MAPWIDTH/3;i<MAPWIDTH-(MAPWIDTH/3)-4;i++)
		{
			mvaddch(MAPHEIGHT/2,i,wall);
			partClassify(MAPHEIGHT/2,i, '1');
		}
    	for(int i=MAPHEIGHT/3;i<MAPHEIGHT-(MAPHEIGHT/4);i++)
		{
			mvaddch(i,(MAPWIDTH-4)/2,wall);
			partClassify(i,(MAPWIDTH-4)/2, '1');
		}
		mvaddch(0,0,immwall);
		partClassify(0, 0, '2');
		mvaddch(0,MAPWIDTH-4,immwall);
		partClassify(0, MAPWIDTH-4, '2');
		mvaddch(MAPHEIGHT-2,0,immwall);
		partClassify(MAPHEIGHT-2, 0, '2');
		mvaddch(MAPHEIGHT-2,MAPWIDTH-4,immwall);
		partClassify(MAPHEIGHT-2,MAPWIDTH-4, '2');
		mvaddch(MAPHEIGHT/2,(MAPWIDTH-4)/2,immwall);
		partClassify(MAPHEIGHT/2,(MAPWIDTH-4)/2, '2');
        break;

    default:
        break;
    }
}