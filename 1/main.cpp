#include <iostream>
#include <fstream>
#include <cstring>

using namespace std;

class Hotel {
bool occupied[16] = {};

public:
Hotel();
bool is_occupied(int p);
void free_room(int p);
int count_free();
int find_room();
};

Hotel::Hotel() {
for (int i = 0; i < 16; ++i)
this->occupied[i] = false;
}

bool Hotel::is_occupied(int p) {
if (this->occupied[p] == 0) return(0);
else return(1);
}

void Hotel::free_room(int p) {
this->occupied[p] = 0;
}

int Hotel::count_free() {
int count = 0;
for (int i = 0; i < 16; ++i) {
if (this->occupied[i] == 0) count++;
}
return(count);
}

int Hotel::find_room() {
for(int i = 0; i < 16; i++) {
if(occupied[i] == false){
occupied[i] = true;
return i;
}
}
return -1;
}

int main() {

return 0;
}
