#include "mainmenu.h"
using namespace std;

main_menu::main_menu()
{

	cout << "Menu constructor\n";
}

main_menu::~main_menu()
{
	cout << "Menu destructor\n";
}

void main_menu::sort_menu() {
	string MenuDescriptor = " 1- sort by release year\n 2 - sort by rating\n";
	MenuDescriptor += " 3 - sort by name\n 4 - sort with filter \n 0 - exit\n";
	//cout MenuDescriptor;
	string boof_string;
	int boof_int;
	while (1) {
		cout << MenuDescriptor;
		getline(cin, boof_string);
		try {
			boof_int = stoi(boof_string);
		}
		catch (const exception& E) {
			cout << E.what() << endl;
			boof_int = -1;
		}
		switch (boof_int) {
		case 1:
			sort_by_year();
			break;
		case 2:
			sort_by_rating();
			break;
		case 3:
			sort_by_name();
			break;
		case 4:
			sort_filter();
			break;
		case 0:
			return;
		default:
			cout << "error";
			break;

		}
	}
}
void main_menu::sort_by_year() {
	vector <Game*> sorted_games;
	sorted_games.push_back(Games[0]);
	int i = 1;
	for (i; i < Games.size(); i++)
	{
		int j = 0;
		for (j; j < sorted_games.size(); j++)
			if (Games[i]->get_release_year()
				< sorted_games[j]->get_release_year()) break;
		if (j < sorted_games.size())
		{
			sorted_games.insert(sorted_games.begin() + j, Games[i]);

		}
		else {
			sorted_games.push_back(Games[i]);
		}

	}
	for (Game* game : sorted_games) {

		game->print();
		cout << "\n";
	}
}
void main_menu::sort_filter() {
	string boof_string;
	cout << "genre: ";
	getline(cin, boof_string);
	string type = "class " + boof_string;

	vector <Game*> filtered_games;
	int i = 0;

	for (i; i < Games.size(); i++)
	{
		if (typeid(*Games[i]).name() == type)
			filtered_games.push_back(Games[i]);

	}
	if (filtered_games.empty()) {
		cout << "Filtered games empty\n";
		return;
	}
	vector <Game*> sorted_games;
	sorted_games.push_back(filtered_games[0]);
	int k = 1;
	for (k; k < filtered_games.size(); k++)
	{
		int j = 0;
		for (j; j < sorted_games.size(); j++)
			if (filtered_games[k]->get_release_year()
				< sorted_games[j]->get_release_year()) break;
		if (j < sorted_games.size())
		{
			sorted_games.insert(sorted_games.begin() + j, filtered_games[k]);

		}
		else {
			sorted_games.push_back(filtered_games[k]);
		}

	}
	for (Game* game : sorted_games) {

		game->print();
		cout << "\n";
	}
}
void main_menu::sort_by_rating() {
	vector <Game*> sorted_games;
	sorted_games.push_back(Games[0]);
	int i = 1;
	for (i; i < Games.size(); i++)
	{
		int j = 0;
		for (j; j < sorted_games.size(); j++)
			if (Games[i]->get_rating()
				< sorted_games[j]->get_rating()) break;
		if (j < sorted_games.size())
		{
			sorted_games.insert(sorted_games.begin() + j, Games[i]);

		}
		else {
			sorted_games.push_back(Games[i]);
		}

	}
	for (Game* game : sorted_games) {

		game->print();
		cout << "\n";
	}

}
void main_menu::sort_by_name() {
	vector <Game*> sorted_games;
	sorted_games.push_back(Games[0]);
	int i = 1;
	for (i; i < Games.size(); i++)
	{
		int j = 0;
		for (j; j < sorted_games.size(); j++)
			if (Games[i]->get_game_name()
				< sorted_games[j]->get_game_name()) break;
		if (j < sorted_games.size())
		{
			sorted_games.insert(sorted_games.begin() + j, Games[i]);

		}
		else {
			sorted_games.push_back(Games[i]);
		}

	}
	for (Game* game : sorted_games) {

		game->print();
		cout << "\n";
	}

}

void main_menu::filter_menu() {
	string MenuDescriptor = " 1- filter by release year\n 2 - filter by rating\n";
	MenuDescriptor += " 3 - filter by genre\n 0 - exit\n";
	//cout MenuDescriptor;
	string boof_string;
	int boof_int;
	while (1) {
		cout << MenuDescriptor;
		getline(cin, boof_string);
		try {
			boof_int = stoi(boof_string);
		}
		catch (const exception& E) {
			cout << E.what() << endl;
			boof_int = -1;
		}
		switch (boof_int) {
		case 1:
			filter_by_year();
			break;
		case 2:
			filter_by_rating();
			break;
		case 3:
			filter_by_genre();
			break;
		case 0:
			return;
		default:
			cout << "error";
			break;

		}
	}
}
void main_menu::filter_by_rating() {
	string boof_string;
	float boof_float;
	cout << ">rating: ";
	getline(cin, boof_string);
	try {
		boof_float = stof(boof_string);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_float = -1;
	}

	vector <Game*> filtered_games;
	int i = 0;
	for (i; i < Games.size(); i++)
	{
		if (Games[i]->get_rating() >= boof_float)
			filtered_games.push_back(Games[i]);

	}
	for (Game* game : filtered_games) {

		game->print();
		cout << "\n";
	}
}

void main_menu::filter_by_year() {
	string boof_string;
	int boof_int;
	cout << "from year: ";
	getline(cin, boof_string);
	try {
		boof_int = stoi(boof_string);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_int = -1;
	}

	vector <Game*> filtered_games;
	int i = 0;
	for (i; i < Games.size(); i++)
	{
		if (Games[i]->get_release_year() >= boof_int)
			filtered_games.push_back(Games[i]);

	}
	for (Game* game : filtered_games) {

		game->print();
		cout << "\n";
	}
}

void main_menu::filter_by_genre() {
	string boof_string;
	cout << "genre: ";
	getline(cin, boof_string);
	string type = "class " + boof_string;

	vector <Game*> filtered_games;
	int i = 0;

	for (i; i < Games.size(); i++)
	{
		if (typeid(*Games[i]).name() == type)
			filtered_games.push_back(Games[i]);

	}
	for (Game* game : filtered_games) {

		game->print();
		cout << "\n";
	}
}


void main_menu::core_menu() {
	string MenuDescriptor = "\n 1 - print all\n 2 - add game\n 3 - delete game\n";
	MenuDescriptor += " 4 - edit game\n 5 - save to file\n 6 - sort \n 7 - filter \n 0 - exit\n";
	//cout MenuDescriptor;
	string boof_string;
	int boof_int;
	while (1) {
		cout << MenuDescriptor;
		getline(cin, boof_string);
		try {
			boof_int = stoi(boof_string);
		}
		catch (const exception& E) {
			cout << E.what() << endl;
			boof_int = -1;
		}
		switch (boof_int) {
		case 1:
			print_all();
			break;
		case 2:
			add();
			break;
		case 3:
			delete_game();
			break;
		case 4:
			edit_game();
			break;
		case 5:
			save_all();
			cout << "saved";
			break;
		case 6:
			sort_menu();
			break;
		case 7:
			filter_menu();
			break;
		case 0:
			return;
		default:
			cout << "error";
			break;

		}
	}


}
void main_menu::delete_game() {
	print_all();
	cout << "№ game to delete: ";
	string boof_string;
	int boof_int;
	getline(cin, boof_string);
	try {
		boof_int = stoi(boof_string);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		return;
	}
	if (boof_int <0 || boof_int > Games.size()) {
		cout << "index out of range\n";
		return;
	}
	Games.erase(Games.begin() + boof_int);
}

void main_menu::edit_game() {
	print_all();
	cout << "№ game to edit: ";
	string boof_string;
	int boof_int;
	getline(cin, boof_string);
	try {
		boof_int = stoi(boof_string);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		return;
	}
	if (boof_int <0 || boof_int > Games.size()) {
		cout << "index out of range\n";
		return;
	}
	Games[boof_int]->edit();
}
void main_menu::print_all() {
	int I = 0;
	if (Games.size() == 0)
	{
		cout << "list is empty";
		return;
	}
	for (I; I < Games.size(); I++)
	{
		cout << I << ". ";
		Games[I]->print();
		cout << endl;
	}

}

void main_menu::add_game() {
	Game* game = new Game();
	game->fill();
	Games.push_back(game);
}

void main_menu::add_strategy() {
	Strategy* strategy = new Strategy();
	strategy->fill();
	Games.push_back(strategy);
}

void main_menu::add_RPG() {
	RPG* rpg = new RPG();
	rpg->fill();
	Games.push_back(rpg);
}

void main_menu::add() {
	string MenuDescriptor = "\n 1 - add game\n 2 - add strategy\n 3 - add RPG\n 0 - exit\n";
	//cout MenuDescriptor;
	string boof_string;
	int boof_int;
	while (1) {
		cout << MenuDescriptor;
		getline(cin, boof_string);
		try {
			boof_int = stoi(boof_string);
		}
		catch (const exception& E) {
			cout << E.what() << endl;
			boof_int = -1;
		}


		switch (boof_int) {
		case 1:

			add_game();


			break;
		case 2:

			add_strategy();


			break;
		case 3:

			add_RPG();


			break;

		case 0:
			return;
		default:
			cout << "invalid command\n";



		}
	}
	//вызов метода fill, который заполняет весь фильм  
}
void main_menu::save_all() {
	int I = 0;
	if (Games.size() == 0)
	{
		cout << "list is empty";
		return;
	}
	ofstream File;
	File.open("test1.txt");
	for (I; I < Games.size(); I++)
	{
		Games[I]->save_to_file(File);
	}
	File.close();
}
void main_menu::load_from_file()
{
	ifstream File;
	File.open("test1.txt");
	string buff;
	vector <string> tokens;
	while (getline(File, buff)) {
		if (buff == "<Game>") {
			while (getline(File, buff)) {
				if (buff == "</Game>")
					break;
				string token = buff;
				tokens.push_back(token);

			}
			Game* newGame1 = new Game();
			newGame1->load_from_tokens(tokens);
			Games.push_back(newGame1);
		}
		else if (buff == "<Strategy>") {

			while (getline(File, buff)) {
				if (buff == "</Strategy>")
					break;
				string token = buff;
				tokens.push_back(token);

			}
			Strategy* newStrategy1 = new Strategy();
			newStrategy1->load_from_tokens(tokens);
			Games.push_back(newStrategy1);
		}
		else if (buff == "<RPG>") {

			while (getline(File, buff)) {
				if (buff == "</RPG>")
					break;
				string token = buff;
				tokens.push_back(token);

			}
			RPG* newRPG1 = new RPG();
			newRPG1->load_from_tokens(tokens);
			Games.push_back(newRPG1);
		}
		tokens.clear();
	}
	File.close();
}

