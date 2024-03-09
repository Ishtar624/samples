#pragma once
#include<string>
#include<vector>
using namespace std;

class Person
{
public:
	Person();
	~Person();

private:
	string Name;
	string Surname;
	string Full_Name();
	friend class Game;
	friend class RPG;
	friend class Strategy;
};

