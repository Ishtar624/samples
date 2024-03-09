#pragma once
#include "game.h"

class RPG : public Game
{
public:
	RPG();
	~RPG();
	int get_number_of_classes();
	void set_number_of_classes(int);
	int get_number_of_quests();
	void set_number_of_quests(int);
	vector <string> get_quest_names();
	void set_quest_names(vector <string> new_quest_name);
	string get_quest_name(int i);
	void del_quest_name(int i);
	void add_quest_name(string new_quest_name);
	void fill();
	string to_string();
	void print();
	void save_to_file(ofstream& File);
	int load_from_tokens(vector <string> tokens);

private:
	int number_of_classes;
	int number_of_quests;
	vector <string> quest_names;
};
