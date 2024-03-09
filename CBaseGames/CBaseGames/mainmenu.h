#include "strategy.h"
#include "RPG.h"

class main_menu
{
public:
	main_menu();
	~main_menu();
	void core_menu();
	void load_from_file();

private:
	vector <Game*> Games;
	void print_all();
	void add(); //TO DO: инициализация внутри кейса

	void save_all();
	void add_game();
	void add_RPG();
	void add_strategy();
	void sort_menu();
	void sort_by_year();
	void sort_by_rating();
	void sort_by_name();
	void delete_game();
	void edit_game();
	void filter_menu();
	void filter_by_rating();
	void filter_by_year();
	void filter_by_genre(); //TO DO
	void sort_filter();
};

