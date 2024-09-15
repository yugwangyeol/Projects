/**
 * @author Dayun kang(20185280), Gwangyeol Yu(20192780)
 */
#include <iostream>
#include <vector>
#include <ncurses.h>
#include <cstdlib>
#ifndef SNAKE_H
#define SNAKE_H
#define WIDTH 100
#define HEIGHT 100

struct snakepart{
	int x,y;
	snakepart(int col, int row);
	snakepart();
};

class snakeclass{
	int points,del;

	bool getFood;
	bool getPoison;
	bool getCoin;

	char direction;
	int maxwidth;
	int maxheight;
	int dg;
	int fg;
	char bodyChar;
	char wall;
	char immwall;
	char foodChar;
	char poisonChar;
	char coinChar;
	char head;
	char body;
	char gateChar;

	int cntfood;
	int cntpoison;
	int cntcoin;
	int cntgate;
	int curLength;
	int maxLength;

	int gtx1;
	int gty1;
	int gtx2;
	int gty2;
	
	snakepart food;
	snakepart poison;
	snakepart coin;
	snakepart gate1;
	snakepart gate2;
	std::vector<snakepart> snake;

	void putfood();
	void putpoison();
	void putgate1();
	void putgate2();
	void putcoin();
	bool collision();
	void movesnake();
	void gateopen();
	void newgate();

public:
	snakeclass();
	~snakeclass();
	void start1();
	void start2();
	void start3();
	void start4();
	void createMap(int stage);
	void createSB();
	void partClassify(int x, int y, char part);

	char data[WIDTH][HEIGHT] = {{'0'},};
	int gx1, gy1, gx2, gy2;

	bool gameover;
};

#endif
