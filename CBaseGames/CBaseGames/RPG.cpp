#include "RPG.h"

RPG::RPG()
{
	cout << "RPG constructor \n";
	number_of_classes = 0;
	number_of_quests = 0;
	tag = "RPG";


}

RPG ::~RPG()
{
}



void RPG::set_number_of_classes(int new_number_of_classes)
{
	if (new_number_of_classes < 0)
	{
		cout << "number_of_classes_error";
		return;
	}
	number_of_classes = new_number_of_classes;
}

void RPG::set_number_of_quests(int new_number_of_quests)
{
	if (new_number_of_quests < 0)
	{
		cout << "number_of_quests_error";
		return;
	}
	number_of_quests = new_number_of_quests;
}

void RPG::set_quest_names(vector <string> new_quest_names)
{
	quest_names = new_quest_names;
}

int RPG::get_number_of_classes()
{
	return number_of_classes;
}

int RPG::get_number_of_quests()
{
	return number_of_quests;
}
string RPG::get_quest_name(int i) {
	if ((i < 0) && (i > quest_names.size())) {
		cout << "get_quest_name_error \n";
		return 0;
	}
	return quest_names[i];
}

void RPG::del_quest_name(int i) {
	if ((i < 0) && (i > quest_names.size())) {
		cout << "del_quest_name_error \n";
		return;
	}
	quest_names.erase(quest_names.begin() + i);
}
void RPG::add_quest_name(string new_quest_name) {
	if (new_quest_name == "") {
		cout << "add_quest_name_error \n";
		return;
	}
	quest_names.push_back(new_quest_name);
}

void RPG::fill()
{
	Game::fill();

	int boof_int;
	string boof_string;

	cout << "Number of classes: ";
	getline(cin, boof_string);
	try {
		boof_int = stoi(boof_string);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_int = 0;
	}
	set_number_of_classes(boof_int);

	cout << "Number of quests: ";
	getline(cin, boof_string);
	try {
		boof_int = stoi(boof_string);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_int = 0;
	}
	set_number_of_quests(boof_int);

	cout << "Quest names? 0 for stop ";
	getline(cin, boof_string);
	while (boof_string != "0") {
		add_quest_name(boof_string);
		getline(cin, boof_string);
	}
}

string RPG::to_string()
{
	string result_string = Game::to_string();
	result_string += "Number of classes: ";
	result_string += std::to_string(number_of_classes) + "\n";
	result_string += "Number of quests: ";
	result_string += std::to_string(number_of_quests) + "\n";
	int i;


	if (quest_names.empty()) {
		result_string += "Quest names empty. \n";
	}
	else {
		result_string += "Quest names: ";
		for (i = 0; i < quest_names.size() - 1; i++) {
			result_string += quest_names[i];
			result_string += ", ";
		}
		result_string += quest_names[i] + "\n";
	}

	return result_string;
}

void RPG::print()
{
	cout << to_string();
}

void RPG::save_to_file(ofstream& File)
{

	int i = 0;
	File << "<" + tag + ">\n";
	File << Game_name << endl;
	File << developer << endl;
	File << publisher << endl;

	File << std::to_string(rating) << endl;
	File << std::to_string(release_year) << endl;
	File << std::to_string(PG) << endl;
	File << std::to_string(average_time_in_game) << endl;


	File << "<Directors>\n";
	if (!directors.empty()) {
		for (Person director : directors) {
			File << director.Full_Name() << endl;
		}
	}
	File << "</Directors>\n";

	File << "<Game_designers>\n";

	if (!game_designers.empty()) {
		for (Person game_designer : game_designers) {
			File << game_designer.Full_Name() << endl;
		}
	}

	File << "</Game_designers>\n";

	File << "<Programmers>\n";

	if (!programmers.empty()) {
		for (Person programmer : programmers) {
			File << programmer.Full_Name() << endl;
		}
	}

	File << "</Programmers>\n";

	File << "<Artists>\n";

	if (!artists.empty()) {
		for (Person artist : artists) {
			File << artist.Full_Name() << endl;
		}
	}

	File << "</Artists>\n";

	File << "<Sound_designers>\n";

	if (!sound_designers.empty()) {
		for (Person sound_designer : sound_designers) {
			File << sound_designer.Full_Name() << endl;
		}
	}

	File << "</Sound_designers>\n";

	File << "<Testers>\n";

	if (!testers.empty()) {
		for (Person tester : testers) {
			File << tester.Full_Name() << endl;
		}
	}

	File << "</Testers>\n";

	File << std::to_string(number_of_classes) << endl;
	File << std::to_string(number_of_quests) << endl;

	File << "<Quest_names>\n";

	if (!quest_names.empty()) {
		for (string unit_type : quest_names) {
			File << unit_type << endl;
		}
	}

	File << "</Quest_names>\n";

	File << "</" + tag + ">\n";
}

int RPG::load_from_tokens(vector<string> tokens)
{
	int i = Game::load_from_tokens(tokens);
	i++;
	int boof_int;

	try {
		boof_int = stoi(tokens[i]);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_int = 0;
	}
	set_number_of_classes(boof_int);
	i++;

	try {
		boof_int = stoi(tokens[i]);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_int = 0;
	}
	set_number_of_quests(boof_int);
	i++;

	if (tokens[i] != "<Quest_names>") {
		cout << "Fail to load Quest_names \n";
		return 0;
	}
	i++;
	while (tokens[i] != "</Quest_names>") {
		add_quest_name(tokens[i]);
		i++;
	}
	return i;
}