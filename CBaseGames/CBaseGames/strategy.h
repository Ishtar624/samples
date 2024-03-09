#pragma once
#include "game.h"

class Strategy : public Game
{
public:
	Strategy();
	~Strategy();

	vector <string> get_unit_types();
	void set_unit_types(vector <string> new_unit_types);
	string get_unit_type(int i);
	void del_unit_type(int i);
	void add_unit_type(string new_unit_type);
	int get_number_of_fractions();
	void set_number_of_fractions(int);
	void fill();
	string to_string();
	void print();
	void save_to_file(ofstream& File);
	int load_from_tokens(vector <string> tokens);

private:
	vector <string> unit_types;
	int number_of_fractions;

};