// lab2.cpp : Этот файл содержит функцию "main". Здесь начинается и заканчивается выполнение программы.
//Даны две матрицы разного размера. Для той из матриц, в которой меньше среднее арифметическое положительных элементов,
//найти количество отрицательных элементов в каждой строке.



#include <cstdio>
#include <locale.h>

const int nmax = 100;

void Zeros(double x[][nmax], int m, int n, int z[]);   // Функция Zeros формирует одномерный массив,
                                                         // i-ый элемент которого равен 1,
                                                         // если в i-ой строке есть нулевые элементы, и 0 в противном случае 

void main(int argc, char* argv[])
{
    double a[nmax][nmax];
    int m, n, z[nmax];
    FILE* file;

    setlocale(LC_ALL, "rus");
    if (argc < 2)
    {
        printf("Недостаточно параметров!\n");
        return;
    }
    if ((file = fopen(argv[1], "r")) == NULL)
    {
        printf("Невозможно открыть файл '%s'\n", argv[1]);
        return;
    }
    if (fscanf(file, "%d%d", &m, &n) < 2)
    {
        printf("Ошибка чтения из файла '%s'\n", argv[1]);
        fclose(file);
        return;
    }
    if (m < 0 || m > nmax || n < 0 || n > nmax)
    {
        printf("Количество строк и столбцов матрицы должны быть от 1 до %d!\n", nmax);
        return;
    }
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            if (fscanf(file, "%lf", &a[i][j]) < 1)
            {
                printf("Ошибка чтения из файла '%s'\n", argv[1]);
                fclose(file);
                return    ;
            }
    fclose(file);

    Zeros(a, m, n, z);

    for (int i = 0; i < m; i++)
        if (z[i])
            printf("В %3d строке есть нулевые элементы\n", i + 1);
}

void Zeros(double x[][nmax], int m, int n, int z[])
{
    int i, j;

    for (i = 0; i < m; i++)
        for (z[i] = 0, j = 0; j < n; j++)
            if (x[i][j] == 0)
            {
                z[i] = 1;  break;
            }
}