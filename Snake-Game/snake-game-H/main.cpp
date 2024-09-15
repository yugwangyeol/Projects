/**
 * @author Dayun kang(20185280)
 */
#include "snake.h"
#include <unistd.h>
int main()
{
	snakeclass s1;
	s1.start1();
	if(s1.gameover==false)
	{
		snakeclass s2;
		s2.start2();
		if(s2.gameover==false)
		{
			snakeclass s3;
			s3.start3();
			if(s3.gameover==false)
			{
			snakeclass s4;
			s4.start4();
			}
		}
	}
	return 0;
}
