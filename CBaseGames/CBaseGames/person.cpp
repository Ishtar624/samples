#include "person.h"

Person::Person()
{

}

Person::~Person()
{

}

string Person::Full_Name()
{
	if (Surname == "")
	{
		return Name;
	}
	return Name + " " + Surname;
}