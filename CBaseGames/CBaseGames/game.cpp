#include "game.h"
Game::Game()
{
	cout << "Game constructor \n";
	Game_name = "default_name";
	developer = "default developer";
	publisher = "default publisher";
	rating = 0;
	PG = 0;
	average_time_in_game = 0;
	release_year = 0;
	tag = "Game";
}

Game::~Game()
{
	cout << "Game destructor \n";
}

string Game::get_game_name() {
	return Game_name;
}
void Game::set_game_name(string new_game_name) {
	if (new_game_name == "") {
		cout << "set_game_name_error \n";
		return;
	}
	Game_name = new_game_name;
}

string Game::get_developer() {
	return developer;
}
void Game::set_developer(string new_developer) {
	if (new_developer == "") {
		cout << "set_developer_error \n";
		return;
	}
	developer = new_developer;
}

string Game::get_publisher() {
	return publisher;
}
void Game::set_publisher(string new_publisher) {
	if (new_publisher == "") {
		cout << "set_publisher_error \n";
		return;
	}
	publisher = new_publisher;
}

float Game::get_rating() {
	return rating;
}
void Game::set_rating(float new_rating) {
	if (new_rating <= 0) {
		cout << "set_rating_error \n";
		return;
	}
	rating = new_rating;
}
int Game::get_PG() {
	return PG;
}
void Game::set_PG(int new_PG) {
	if (new_PG < 0) {
		cout << "set_PG_error \n";
		return;
	}
	PG = new_PG;
}
int Game::get_average_time_in_game() {
	return average_time_in_game;
}
void Game::set_average_time_in_game(int new_average_time_in_game) {
	if (new_average_time_in_game < 0) {
		cout << "set_average_time_in_game_error \n";
		return;
	}
	average_time_in_game = new_average_time_in_game;
}
int Game::get_release_year() {
	return release_year;
}
void Game::set_release_year(int new_release_year) {
	if (new_release_year < 1800) {
		cout << "set_release_year_error \n";
		return;
	}
	release_year = new_release_year;
}

vector <Person> Game::get_directors() {
	return directors;
}
void Game::set_directors(vector <Person> new_directors) {
	directors = new_directors;
}
string Game::get_director(int i) {
	if ((i < 0) && (i > directors.size())) {
		cout << "get_directors_error \n";
		return 0;
	}
	return directors[i].Full_Name();
}
void Game::del_director(int i) {
	if ((i < 0) && (i > directors.size())) {
		cout << "del_director_error \n";
		return;
	}
	directors.erase(directors.begin() + i);
}
void Game::add_director(string new_director) {
	if (new_director == "") {
		cout << "add_director_error \n";
		return;
	}
	Person director;

	size_t separator = new_director.find(" ");
	if (separator == string::npos)
	{
		director.Name = new_director;
		director.Surname = "";
	}
	else
	{
		director.Name = new_director.substr(0, separator);
		director.Surname = new_director.substr(separator + 1);
	}
	directors.push_back(director);
}


vector <Person> Game::get_game_designers() {
	return game_designers;
}
void Game::set_game_designers(vector <Person> new_game_designers) {
	game_designers = new_game_designers;
}
string Game::get_game_designer(int i) {
	if ((i < 0) && (i > game_designers.size())) {
		cout << "get_game_designer_error \n";
		return 0;
	}
	return game_designers[i].Full_Name();
}
void Game::add_game_designer(string new_game_designer) {

	if (new_game_designer == "") {
		cout << "add_game_designer_error \n";
		return;
	}
	Person game_designer;

	size_t separator = new_game_designer.find(" ");
	if (separator == string::npos)
	{
		game_designer.Name = new_game_designer;
		game_designer.Surname = "";
	}
	else
	{
		game_designer.Name = new_game_designer.substr(0, separator);
		game_designer.Surname = new_game_designer.substr(separator + 1);
	}
	game_designers.push_back(game_designer);
}
void Game::del_game_designer(int i) {
	if ((i < 0) && (i > game_designers.size())) {
		cout << "del_game_designer_error \n";
		return;
	}
	game_designers.erase(game_designers.begin() + i);
}

vector <Person> Game::get_programmers() {
	return programmers;
}
void Game::set_programmers(vector <Person> new_programmers) {
	programmers = new_programmers;
}
string Game::get_programmer(int i) {
	if ((i < 0) && (i > programmers.size())) {
		cout << "get_programmer_error \n";
		return 0;
	}
	return programmers[i].Full_Name();
}
void Game::add_programmer(string new_programmer) {
	if (new_programmer == "") {
		cout << "add_programmer_error \n";
		return;
	}
	Person programmer;

	size_t separator = new_programmer.find(" ");
	if (separator == string::npos)
	{
		programmer.Name = new_programmer;
		programmer.Surname = "";
	}
	else
	{
		programmer.Name = new_programmer.substr(0, separator);
		programmer.Surname = new_programmer.substr(separator + 1);
	}
	programmers.push_back(programmer);
}
void Game::del_programmer(int i) {
	if ((i < 0) && (i > programmers.size())) {
		cout << "del_programmer_error \n";
		return;
	}
	programmers.erase(programmers.begin() + i);
}

vector <Person> Game::get_artists() {
	return artists;
}
void Game::set_artists(vector <Person> new_artists) {
	artists = new_artists;
}
string Game::get_artist(int i) {
	if ((i < 0) && (i > artists.size())) {
		cout << "get_artist_error \n";
		return 0;
	}
	return artists[i].Full_Name();
}
void Game::add_artist(string new_artist) {
	if (new_artist == "") {
		cout << "add_artist_error \n";
		return;
	}
	Person artist;

	size_t separator = new_artist.find(" ");
	if (separator == string::npos)
	{
		artist.Name = new_artist;
		artist.Surname = "";
	}
	else
	{
		artist.Name = new_artist.substr(0, separator);
		artist.Surname = new_artist.substr(separator + 1);
	}
	artists.push_back(artist);
}
void Game::del_artist(int i) {
	if ((i < 0) && (i > artists.size())) {
		cout << "del_artist_error \n";
		return;
	}
	artists.erase(artists.begin() + i);
}

vector <Person> Game::get_sound_designers() {
	return sound_designers;
}
void Game::set_sound_designers(vector <Person> new_sound_designers) {
	sound_designers = new_sound_designers;
}
string Game::get_sound_designer(int i) {
	if ((i < 0) && (i > sound_designers.size())) {
		cout << "get_sound_designer_error \n";
		return 0;
	}
	return sound_designers[i].Full_Name();
}
void Game::add_sound_designer(string new_sound_designer) {
	if (new_sound_designer == "") {
		cout << "add_sound_designer_error \n";
		return;
	}
	Person sound_designer;

	size_t separator = new_sound_designer.find(" ");
	if (separator == string::npos)
	{
		sound_designer.Name = new_sound_designer;
		sound_designer.Surname = "";
	}
	else
	{
		sound_designer.Name = new_sound_designer.substr(0, separator);
		sound_designer.Surname = new_sound_designer.substr(separator + 1);
	}
	sound_designers.push_back(sound_designer);
}
void Game::del_sound_designer(int i) {
	if ((i < 0) && (i > sound_designers.size())) {
		cout << "del_sound_designer_error \n";
		return;
	}
	sound_designers.erase(sound_designers.begin() + i);
}

vector <Person> Game::get_testers() {
	return testers;
}
void Game::set_testers(vector <Person> new_testers) {
	testers = new_testers;
}
string Game::get_tester(int i) {
	if ((i < 0) && (i > testers.size())) {
		cout << "get_tester_error \n";
		return 0;
	}
	return testers[i].Full_Name();
}
void Game::add_tester(string new_tester) {
	if (new_tester == "") {
		cout << "add_tester_error \n";
		return;
	}
	Person tester;

	size_t separator = new_tester.find(" ");
	if (separator == string::npos)
	{
		tester.Name = new_tester;
		tester.Surname = "";
	}
	else
	{
		tester.Name = new_tester.substr(0, separator);
		tester.Surname = new_tester.substr(separator + 1);
	}
	testers.push_back(tester);
}
void Game::del_tester(int i) {
	if ((i < 0) && (i > testers.size())) {
		cout << "del_tester_error \n";
		return;
	}
	testers.erase(testers.begin() + i);
}

void Game::edit() {
	string EditDescriptor = " Edit: \n 1 - game name\n 2 - developer\n 3 - publisher \n 4 - rating \n 5 - year\n";
	EditDescriptor += " 6 - PG \n 7 - average time in game \n 8 - directors\n 9 - game designers\n 10 - programmers\n 11 - artists\n";
	EditDescriptor += " 12 - sound designers\n 13 - testers\n 0 - exit\n";
	//cout EditDescriptor;
	string boof_string;
	int boof_int;
	float boof_float;
	while (1) {
		cout << EditDescriptor;
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
			getline(cin, boof_string);
			set_game_name(boof_string);
			break;
		case 2:
			getline(cin, boof_string);
			set_developer(boof_string);
			break;
		case 3:
			getline(cin, boof_string);
			set_publisher(boof_string);
			break;
		case 4:
			getline(cin, boof_string);
			try {
				boof_float = stof(boof_string);
			}
			catch (const exception& E) {
				cout << E.what() << endl;
				boof_float = -1;
			}
			set_rating(boof_float);
			break;
		case 5:
			getline(cin, boof_string);
			try {
				boof_int = stoi(boof_string);
			}
			catch (const exception& E) {
				cout << E.what() << endl;
				boof_int = -1;
			}
			set_release_year(boof_int);
			break;

		case 6:
			getline(cin, boof_string);
			try {
				boof_int = stoi(boof_string);
			}
			catch (const exception& E) {
				cout << E.what() << endl;
				boof_int = -1;
			}
			set_PG(boof_int);
			break;
		case 7:
			getline(cin, boof_string);
			try {
				boof_int = stoi(boof_string);
			}
			catch (const exception& E) {
				cout << E.what() << endl;
				boof_int = -1;
			}
			set_average_time_in_game(boof_int);
			break;
		case 8:
			edit_directors();

			break;
		case 9:
			edit_game_designers();

			break;
		case 10:
			edit_programmers();

			break;
		case 11:
			edit_artists();

			break;
		case 12:
			edit_sound_designers();

			break;
		case 13:
			edit_testers();

			break;
		case 0:
			return;
		default:
			cout << "error";
			break;


		}

	}
}

void Game::edit_directors() {
	if (directors.empty()) {
		cout << "Directors empty. \n";
	}
	else {
		cout << "Directors: ";
		for (int i = 0; i < directors.size(); i++) {
			cout << i << ". " << directors[i].Full_Name() << "\n";
		}
	}
	string EditDescriptor = "1 - Add new director\n 2 - Delete director\n 0 - Exit\n";
	string boof_string;
	int boof_int;
	while (1) {
		cout << EditDescriptor;
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
			add_directors();
			break;
		case 2:
			delete_element(directors);
			break;
		case 0:
			return;
		default:
			cout << "error";
			break;
		}
	}
}

void Game::edit_game_designers() {
	if (game_designers.empty()) {
		cout << "Game designers empty. \n";
	}
	else {
		cout << "Game designers: ";
		for (int i = 0; i < game_designers.size(); i++) {
			cout << i << ". " << game_designers[i].Full_Name() << "\n";
		}
	}
	string EditDescriptor = "1 - Add new game designer\n 2 - Delete game designer\n 0 - Exit\n";
	string boof_string;
	int boof_int;
	while (1) {
		cout << EditDescriptor;
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
			add_game_designers();
			break;
		case 2:
			delete_element(game_designers);
			break;
		case 0:
			return;
		default:
			cout << "error";
			break;
		}
	}
}

void Game::edit_programmers() {
	if (programmers.empty()) {
		cout << "Programmers empty. \n";
	}
	else {
		cout << "Programmers: ";
		for (int i = 0; i < programmers.size(); i++) {
			cout << i << ". " << programmers[i].Full_Name() << "\n";
		}
	}
	string EditDescriptor = "1 - Add new programmer\n 2 - Delete programmer\n 0 - Exit\n";
	string boof_string;
	int boof_int;
	while (1) {
		cout << EditDescriptor;
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
			add_programmers();
			break;
		case 2:
			delete_element(programmers);
			break;
		case 0:
			return;
		default:
			cout << "error";
			break;
		}
	}
}

void Game::edit_artists() {
	if (artists.empty()) {
		cout << "Artists empty. \n";
	}
	else {
		cout << "Artists: ";
		for (int i = 0; i < artists.size(); i++) {
			cout << i << ". " << artists[i].Full_Name() << "\n";
		}
	}
	string EditDescriptor = "1 - Add new artist\n 2 - Delete artist\n 0 - Exit\n";
	string boof_string;
	int boof_int;
	while (1) {
		cout << EditDescriptor;
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
			add_artists();
			break;
		case 2:
			delete_element(artists);
			break;
		case 0:
			return;
		default:
			cout << "error";
			break;
		}
	}
}

void Game::edit_sound_designers() {
	if (sound_designers.empty()) {
		cout << "Sound designers empty. \n";
	}
	else {
		cout << "Sound designers: ";
		for (int i = 0; i < sound_designers.size(); i++) {
			cout << i << ". " << sound_designers[i].Full_Name() << "\n";
		}
	}
	string EditDescriptor = "1 - Add new sound designer\n 2 - Delete sound designer\n 0 - Exit\n";
	string boof_string;
	int boof_int;
	while (1) {
		cout << EditDescriptor;
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
			add_sound_designers();
			break;
		case 2:
			delete_element(sound_designers);
			break;
		case 0:
			return;
		default:
			cout << "error";
			break;
		}
	}
}

void Game::edit_testers() {
	if (testers.empty()) {
		cout << "Testers empty. \n";
	}
	else {
		cout << "Testers: ";
		for (int i = 0; i < testers.size(); i++) {
			cout << i << ". " << testers[i].Full_Name() << "\n";
		}
	}
	string EditDescriptor = "1 - Add new tester\n 2 - Delete tester\n 0 - Exit\n";
	string boof_string;
	int boof_int;
	while (1) {
		cout << EditDescriptor;
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
			add_testers();
			break;
		case 2:
			delete_element(testers);
			break;
		case 0:
			return;
		default:
			cout << "error";
			break;
		}
	}
}

void Game::delete_element(vector <string>& vec) {
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
	if (boof_int <0 || boof_int > vec.size()) {
		cout << "index out of range\n";
		return;
	}
	vec.erase(vec.begin() + boof_int);

}

void Game::delete_element(vector <Person>& vec) {
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
	if (boof_int <0 || boof_int > vec.size()) {
		cout << "index out of range\n";
		return;
	}
	vec.erase(vec.begin() + boof_int);

}
void Game::add_directors() {
	string boof_string;
	getline(cin, boof_string);
	add_director(boof_string);

}

void Game::add_game_designers() {
	string boof_string;
	getline(cin, boof_string);
	add_game_designer(boof_string);
}
void Game::add_programmers() {
	string boof_string;
	getline(cin, boof_string);
	add_programmer(boof_string);
}
void Game::add_artists() {
	string boof_string;
	getline(cin, boof_string);
	add_artist(boof_string);
}
void Game::add_sound_designers() {
	string boof_string;
	getline(cin, boof_string);
	add_sound_designer(boof_string);
}

void Game::add_testers() {
	string boof_string;
	getline(cin, boof_string);
	add_tester(boof_string);
}

void Game::fill() {
	string boof_string;
	float boof_float;
	int boof_int;
	cout << "Game name: ";
	getline(cin, boof_string);
	set_game_name(boof_string);

	cout << "Developer: ";
	getline(cin, boof_string);
	set_developer(boof_string);

	cout << "Publisher: ";
	getline(cin, boof_string);
	set_publisher(boof_string);

	cout << "Rating: ";
	getline(cin, boof_string);
	try {
		boof_float = stof(boof_string);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_float = 0;
	}
	set_rating(boof_float);

	cout << "Release year: ";
	getline(cin, boof_string);
	try {
		boof_int = stoi(boof_string);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_int = 0;
	}
	set_release_year(boof_int);

	cout << "PG: ";
	getline(cin, boof_string);
	try {
		boof_int = stoi(boof_string);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_int = 0;
	}
	set_PG(boof_int);

	cout << "Average time in game: ";
	getline(cin, boof_string);
	try {
		boof_int = stoi(boof_string);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_int = 0;
	}
	set_average_time_in_game(boof_int);

	cout << "Directors? 0 for stop ";
	getline(cin, boof_string);
	while (boof_string != "0") {
		add_director(boof_string);
		getline(cin, boof_string);
	}

	cout << "Game designers? 0 for stop ";
	getline(cin, boof_string);
	while (boof_string != "0") {
		add_game_designer(boof_string);
		getline(cin, boof_string);
	}

	cout << "Programmers ? 0 for stop ";
	getline(cin, boof_string);
	while (boof_string != "0") {
		add_programmer(boof_string);
		getline(cin, boof_string);
	}

	cout << "Artists? 0 for stop ";
	getline(cin, boof_string);
	while (boof_string != "0") {
		add_artist(boof_string);
		getline(cin, boof_string);
	}

	cout << "Sound designers? 0 for stop ";
	getline(cin, boof_string);
	while (boof_string != "0") {
		add_sound_designer(boof_string);
		getline(cin, boof_string);
	}

	cout << "Testers? 0 for stop ";
	getline(cin, boof_string);
	while (boof_string != "0") {
		add_tester(boof_string);
		getline(cin, boof_string);
	}

}
string Game::to_string() {
	string result_string = "";
	int i = 0;
	result_string += "Game name: ";
	result_string += Game_name;
	result_string += "\n";

	result_string += "Developer: ";
	result_string += developer + "\n";
	result_string += "Publisher: ";
	result_string += publisher + "\n";
	result_string += "Rating: ";
	result_string += std::to_string(rating) + "\n";
	result_string += "Release year: ";
	result_string += std::to_string(release_year) + "\n";
	result_string += "PG: ";
	result_string += std::to_string(PG) + "\n";
	result_string += "Average time in game: ";
	result_string += std::to_string(average_time_in_game) + "\n";


	if (directors.empty()) {
		result_string += "Directors empty. \n";
	}
	else {
		result_string += "Directors: ";
		for (i = 0; i < directors.size() - 1; i++) {
			result_string += directors[i].Full_Name();
			result_string += ", ";
		}
		result_string += directors[i].Full_Name() + "\n";
	}

	if (game_designers.empty()) {
		result_string += "Game designers empty. \n";
	}
	else {
		result_string += "Game designers: ";
		for (i = 0; i < game_designers.size() - 1; i++) {
			result_string += game_designers[i].Full_Name();
			result_string += ", ";
		}
		result_string += game_designers[i].Full_Name() + "\n";
	}

	if (programmers.empty()) {
		result_string += "Programmers empty. \n";
	}
	else {
		result_string += "Programmers: ";
		for (i = 0; i < programmers.size() - 1; i++) {
			result_string += programmers[i].Full_Name();
			result_string += ", ";
		}
		result_string += programmers[i].Full_Name() + "\n";
	}

	if (artists.empty()) {
		result_string += "Artists empty. \n";
	}
	else {
		result_string += "Artists: ";
		for (i = 0; i < artists.size() - 1; i++) {
			result_string += artists[i].Full_Name();
			result_string += ", ";
		}
		result_string += artists[i].Full_Name() + "\n";
	}

	if (sound_designers.empty()) {
		result_string += "Sound designers empty. \n";
	}
	else {
		result_string += "Sound designers: ";
		for (i = 0; i < sound_designers.size() - 1; i++) {
			result_string += sound_designers[i].Full_Name();
			result_string += ", ";
		}
		result_string += sound_designers[i].Full_Name() + "\n";
	}

	if (testers.empty()) {
		result_string += "Testers empty. \n";
	}
	else {
		result_string += "Testers: ";
		for (i = 0; i < testers.size() - 1; i++) {
			result_string += testers[i].Full_Name();
			result_string += ", ";
		}
		result_string += testers[i].Full_Name() + "\n";
	}

	return result_string;
}

void Game::print() {
	cout << to_string();
}

void Game::save_to_file(ofstream& File) {
	string result_string = "";
	int i = 0;
	File << "<" + tag + ">\n";
	File << Game_name << endl;
	File << developer << endl;
	File << publisher << endl;

	/*File << std::to_string(developer) << endl;
	File << std::to_string(publisher) << endl;*/
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

	File << "</" + tag + ">\n";


}
int Game::load_from_tokens(vector <string> tokens)
{
	string boof_string;
	float boof_float;
	int boof_int, i = 0;

	set_game_name(tokens[i]);
	i++;
	set_developer(tokens[i]);
	i++;
	set_publisher(tokens[i]);
	i++;

	try {
		boof_float = stof(tokens[i]);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_float = 0;
	}
	set_rating(boof_float);
	i++;

	try {
		boof_int = stoi(tokens[i]);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_int = 0;
	}
	set_release_year(boof_int);
	i++;

	try {
		boof_int = stoi(tokens[i]);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_int = 0;
	}
	set_PG(boof_int);
	i++;

	try {
		boof_int = stoi(tokens[i]);
	}
	catch (const exception& E) {
		cout << E.what() << endl;
		boof_int = 0;
	}
	set_average_time_in_game(boof_int);
	i++;

	if (tokens[i] != "<Directors>") {
		cout << "Fail to load Directors";
		return 0;
	}
	i++;
	while (tokens[i] != "</Directors>") {
		add_director(tokens[i]);
		i++;
	}
	i++;

	if (tokens[i] != "<Game_designers>") {
		cout << "Fail to load Game_designers";
		return 0;
	}
	i++;
	while (tokens[i] != "</Game_designers>") {
		add_game_designer(tokens[i]);
		i++;
	}
	i++;


	if (tokens[i] != "<Programmers>") {
		cout << "Fail to load Programmers";
		return 0;
	}
	i++;
	while (tokens[i] != "</Programmers>") {
		add_programmer(tokens[i]);
		i++;
	}
	i++;

	if (tokens[i] != "<Artists>") {
		cout << "Fail to load Artists";
		return 0;
	}
	i++;
	while (tokens[i] != "</Artists>") {
		add_artist(tokens[i]);
		i++;
	}
	i++;

	if (tokens[i] != "<Sound_designers>") {
		cout << "Fail to load Sound_designers";
		return 0;
	}
	i++;
	while (tokens[i] != "</Sound_designers>") {
		add_sound_designer(tokens[i]);
		i++;
	}
	i++;

	if (tokens[i] != "<Testers>") {
		cout << "Fail to load Testers";
		return 0;
	}
	i++;
	while (tokens[i] != "</Testers>") {
		add_tester(tokens[i]);
		i++;
	}
	return i;

	
}