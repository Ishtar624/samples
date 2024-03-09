#include <iostream>
#include <string>
#include<set>
#include <windows.h>

using namespace std;

size_t counter(const string& s)
{
    set<char> c(s.begin(), s.end());
    return c.size();
}

bool CompareAdecuate(string s1, string s2) {
    int n1 = s1.size();
    int n2 = s2.size();
    int k = 0;
    bool t = false;
    //реализация "алфавита"
    int t1, t2;
    t1 = counter(s1);
    t2 = counter(s2);
    if (t1 == t2) {
       t = true;
       return t;
    }
        /*map<char, int> letters1;
        for (int i = 0; i < n1; ++i)
        {
            ++letters1[s1[i]];
        }
        map<char, int>::iterator i;
        map<char, int> letters2;
        for (int j = 0; j < n2; ++j)
        {
            ++letters2[s2[j]];
        }
        map<char, int>::iterator j;
        if (i == j) {
            t = true;
            return t;
        }
        else {
            return t;
        }*/

    if (n1 == n2) {
        for (int i = 1; i < n1; i++) {
            if (s1[i] != s2[i]) {
                k++;
                if (k > 1) {
                    return t;
                }
            }
        }
        if (k == 1) {
            t = true;
            return t;
        }
        else {
            return t;
        }
    }
    if (n1 == n2 + 1) {
        for (int i = 1; i < n1; i++) {
            if (s1[i] != s2[i]) {
                for (int j = i; j < n1; j++) {
                    if (s1[j + 1] != s2[j]) {
                        return t;
                    }
                }
            }
        }
        t = true;
        return t;
    }
    if (n1 == n2 - 1) {
        for (int i = 1; i < n1; i++) {
            if (s1[i] != s2[i]) {
                for (int j = i; j < n2; j++) {
                    if (s1[j] != s2[j + 1]) {
                        return t;
                    }
                }
            }
        }
        t = true;
        return t;
    }
}



int main()
{
    SetConsoleCP(1251); //для работы с русским языком в консоли
    SetConsoleOutputCP(1251);
    string str1;
    string str2;
    cout << "Введите первую строку: \n";
    cin >> str1;
    cout << "Введите вторую строку: \n";
    cin >> str2;
    if (CompareAdecuate(str1, str2) == true) {
        cout << "Строки различаются на одну букву.\n";
    }
    else {
        cout << "Строки различаются не на одну букву.\n";
    }
}