#include <iostream>
#include <thread> 
#include <vector> 

using namespace std;

void merge(vector<int>& v, int m, int s, int n) {
    int i, j, k;
    int n1 = s - m + 1;
    int n2 = n - s;

    std::vector<int> Lt(n1);
    std::vector<int> Rt(n2);

    for (i = 0; i < n1; i++) // временные массивы 
        Lt[i] = v[m + i];
    for (j = 0; j < n2; j++)
        Rt[j] = v[s + 1 + j];

    i = 0; // объединяем временные массивы обратно
    j = 0;
    k = m;
    while (i < n1 && j < n2) {
        if (Lt[i] <= Rt[j]) {
            v[k] = Lt[i];
            i++;
        }
        else {
            v[k] = Rt[j];
            j++;
        }
        k++;
    }

    while (i < n1) { // копируем оставшиеся элементы левой части
        v[k] = Lt[i];
        i++;
        k++;
    }

    while (j < n2) { // копируем оставшиеся элементы правой части
        v[k] = Rt[j];
        j++;
        k++;
    }
}
void mergeSort(vector<int>& v, int m, int n) {
    if (m < n) {
        int s = m + (n - m) / 2; //делим пополам
        thread th1(mergeSort, ref(v), m, s); //сортировка 1ой половины
        thread th2(mergeSort, ref(v), s + 1, m); //сортировка 2ой половины
        th1.join();
        th2.join();
        merge(v, m, s, n);
    }
}

int main() {
    setlocale(LC_ALL, "rus");
    vector<int> v = { 100, 40, 36, 5, 7, 21 };
    int n = v.size();

    mergeSort(v, 0, n - 1);

    cout << "Отсортированнный массив: " << endl;
    for (int i = 0; i < n; i++)
        cout << v[i] << " ";
    cout << endl;

    return 0;
}