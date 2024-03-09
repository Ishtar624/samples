#include "mainmenu.h"
#include <windows.h>

int main()
{
    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);
    main_menu menu;
    menu.load_from_file();
    menu.core_menu();

}
