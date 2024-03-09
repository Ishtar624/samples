#include <cstdio>
#include <locale.h>

//В каждом варианте необходимо обработать три массива разного размера.
//Необходимо написать функцию, которая выполняет требуемые действия, применить её ко всем трём массивам и сравнить полученные результаты.
//Ввод осуществляется из файлов с использованием аргументов функции main.
//Вывод – на экран или в файл с обязательным выводом исходных данных.
//Определить в каком массиве больше сумма элементов, не попадающих в заданный диапазон.
//Если в двух или трёх массивах суммы совпадают, вывести соответствующее сообщение.

const int nmax = 100;

int ArrayInput(int* n, double x[], char* fname);        // Функция ввода массива из файла
double Sum(double x[], int n);                         // Функция поиска суммы элементов массива 

void main(int argc, char* argv[])
{
    double a[nmax], b[nmax], c[nmax];
    double sa, sb, sc, max;
    int na, nb, nc;

    setlocale(LC_ALL, "rus");

    if (argc < 4)
    {
        printf("Недостаточно параметров!\n");
        return;
    }
    if (!ArrayInput(&na, a, argv[1]))
        return;
    if (!ArrayInput(&nb, b, argv[2]))
        return;
    if (!ArrayInput(&nc, c, argv[3]))
        return;

    sa = Sum(a, na);
    sb = Sum(b, nb);
    sc = Sum(c, nc);

    max = sa;
    if (sb > max) max = sb;
    if (sc > max) max = sc;

    if (sa == max)
        printf("Массив А имеет максимальную сумму элементов: %9.3lf\n", max);
    if (sb == max)
        printf("Массив B имеет максимальную сумму элементов: %9.3lf\n", max);
    if (sc == max)
        printf("Массив C имеет максимальную сумму элементов: %9.3lf\n", max);
}

double Sum(double x[], int n)
{
    double s = 0;

    for (int i = 0; i < n; i++)
        if(x[i]<c || x[i]>d)
        s += x[i];

    return s;
}

int ArrayInput(int* n, double x[], char* fname)
{
    FILE* file;

    if ((file = fopen(fname, "r")) == NULL)
    {
        printf("Невозможно открыть файл '%s'\n", fname);
        return 0;
    }
    if (fscanf(file, "%d", n) < 1)
    {
        printf("Ошибка чтения из файла '%s'\n", fname);
        fclose(file);
        return 0;
    }
    if (*n < 0 || *n > nmax)
    {
        printf("Кол-во эл-тов массива должно быть от 1 до %d! (файл '%s')\n", nmax, fname);
        return 0;
    }
    for (int i = 0; i < *n; i++)
        if (fscanf(file, "%lf", &x[i]) < 1)
        {
            printf("Ошибка чтения из файла '%s'\n", fname);
            fclose(file);
            return 0;
        }
    fclose(file);
    return 1;
}