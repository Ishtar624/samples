#pragma once
#include <iostream>
#include <fstream>
#include "person.h"
//#include <nlohmann/json.hpp>
//#include <iostream>
//using json = nlohmann::json;

class Game
{
public:
	//конструкторы-деструкторы
	Game();
	~Game();

	//методы
	virtual void fill();
	virtual string to_string();
	virtual void print();
	virtual void save_to_file(ofstream& File);
	virtual int load_from_tokens(vector <string> tokens);
	//геттеры и сеттеры
	string get_game_name();
	void set_game_name(string new_game_name);
	string get_developer();
	void set_developer(string new_developer);
	string get_publisher();
	void set_publisher(string new_publisher);
	float get_rating();
	void set_rating(float new_rating);
	int get_PG();
	void set_PG(int new_PG);
	int get_average_time_in_game();
	void set_average_time_in_game(int new_average_time_in_game);
	int get_release_year();
	void set_release_year(int new_release_year);
	
	vector <Person> get_directors();
	void set_directors(vector <Person> new_directors);
	string get_director(int i);
	void del_director(int i);
	void add_director(string new_director);

	vector <Person> get_game_designers();
	void set_game_designers(vector <Person> new_gamedesigners);
	string get_game_designer(int i);
	void del_game_designer(int i);
	void add_game_designer(string new_game_designer);

	vector <Person> get_programmers();
	void set_programmers(vector <Person> new_programmers);
	string get_programmer(int i);
	void del_programmer(int i);
	void add_programmer(string new_programmer);

	vector <Person> get_artists();
	void set_artists(vector <Person> new_artists);
	string get_artist(int i);
	void del_artist(int i);
	void add_artist(string new_artist);

	vector <Person> get_sound_designers();
	void set_sound_designers(vector <Person> new_sound_designers);
	string get_sound_designer(int i);
	void del_sound_designer(int i);
	void add_sound_designer(string new_sound_designer);

	vector <Person> get_testers();
	void set_testers(vector <Person> new_testers);
	string get_tester(int i);
	void del_tester(int i);
	void add_tester(string new_tester);

	void edit();

protected:
	string Game_name;
	string developer;
	string publisher;
	vector <Person> directors; //TODO : превратить в класс human + friend
	vector <Person> game_designers;
	vector <Person> programmers;
	vector <Person> artists;
	vector <Person> sound_designers;
	vector <Person> testers;
	float rating;
	int PG;
	int average_time_in_game;
	int release_year;
	string tag;
	void edit_directors();
	void edit_game_designers();
	void edit_programmers();
	void edit_artists();
	void edit_sound_designers();
	void edit_testers();

private:
	void delete_element(vector <string>&);
	void delete_element(vector <Person>&);
	void add_directors();
	void add_game_designers();
	void add_programmers();
	void add_artists();
	void add_sound_designers();
	void add_testers();
};
