#include "strategy.h"

Strategy::Strategy()
{
	cout << "Strategy constructor \n";
	number_of_fractions = 0;
	tag = "Strategy";


}

Strategy ::~Strategy()
{
}



void Strategy::set_number_of_fractions(int new_number_of_fractions)
{
	if (new_number_of_fractions < 0)
	{
		cout << "set_number_of_fractions_error";
		return;
	}
	number_of_fractions = new_number_of_fractions;
}


void Strategy::set_unit_types(vector <string> new_unit_types)
{
	unit_types = new_unit_types;
}

int Strategy::get_number_of_fractions()
{
	return number_of_fractions;
}

string Strategy::get_unit_type(int i){
	if ((i < 0) && (i > unit_types.size())) {
		cout << "get_unit_types_error \n";
		return 0;
	}
	return unit_types[i];
}

void Strategy::del_unit_type(int i) {
	if ((i < 0) && (i > unit_types.size())) {
		cout << "del_unit_types_error \n";
		return;
	}
	unit_types.erase(unit_types.begin() + i);
}
void Strategy::add_unit_type(string new_unit_type) {
	if (new_unit_type == "") {
		cout << "add_unit_type_error \n";
		return;
	}
	unit_types.push_back(new_unit_type);
}

void Strategy::fill()
{
	Game::fill();

	int boof_int;
	string boof_string;

	cout << "Number of fractions: ";
	getline(cin, boof_string);
	try {
		boof_int = stoi(boof_string);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_int = 0;
	}
	set_number_of_fractions(boof_int);

	cout << "Unit types? 0 for stop \n";
	getline(cin, boof_string);
	while (boof_string != "0") {
		add_unit_type(boof_string);
		getline(cin, boof_string);
	}
}

string Strategy::to_string()
{
	string result_string = Game::to_string();
	result_string += "Number of fractions: ";
	result_string += std::to_string(number_of_fractions) + "\n";
	int i;


	if (unit_types.empty()) {
		result_string += "Unit types empty. \n";
	}
	else {
		result_string += "Unit types: ";
		for (i = 0; i < unit_types.size() - 1; i++) {
			result_string += unit_types[i];
			result_string += ", ";
		}
		result_string += unit_types[i] + "\n";
	}

	return result_string;
}

void Strategy::print()
{
	cout << to_string();
}

void Strategy::save_to_file(ofstream& File)
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

	File << std::to_string(number_of_fractions) << endl;

	File << "<Unit_types>\n";

	if (!unit_types.empty()) {
		for (string unit_type : unit_types) {
			File << unit_type << endl;
		}
	}

	File << "</Unit_types>\n";

	File << "</" + tag + ">\n";
}

int Strategy::load_from_tokens(vector<string> tokens)
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

	set_number_of_fractions(boof_int);
	i++;
	if (tokens[i] != "<Unit_types>") {
		cout << "Fail to load Unit_types \n";
		return 0;
	}
	i++;
	while (tokens[i] != "</Unit_types>") {
		add_unit_type(tokens[i]);
		i++;
	}
	return i;
}