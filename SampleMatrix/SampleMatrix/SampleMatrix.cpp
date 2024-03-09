#include <iostream>
#include <windows.h>



using namespace std;
//(пункты с звёздочкой означают задачи повышенной сложности)
//1) Шаблоны на примере матриц
//1.1) Реализация матриц через шаблоны (любой тип данных в ячейках)
//1.2) Реализация перегрузки оператора [] - вызов элемента матрицы как элемента базового двумерного массива
//1.3)* Попытаться реализовать (или доказать невозможность) общий метод [] (n-мерная матрица)
//1.4) Реализация перегрузки операторов "==" (равенства), сложения (матрица+матрица) и умножения на число (можно только на 1 тип, разницы между int и float не особо много)
//1.5) Реализация перегрузки оператора умножения матрицы на матрицу
//1.6) Реализация перегрузки оператора "=" (присваивание - т.н. "Perfect Forwarding", ищите (move-) и копи-конструкторы)

template <typename T>
class Matrix {
private:
    int m; //строки
    int n; //столбцы
    T** M; //массив
public:
    //конструктор
    Matrix(int row, int column) {
        m = row;
        n = column;
        M = (T**) new T* [m];
        for (int i = 0; i < m; i++)
            M[i] = (T*) new T[n];

        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
                M[i][j] = NULL; //rand() % 50;
    };

    Matrix() {
        n = m = 0;
        M = nullptr;
    }
    ~Matrix() { //деструктор
        delete[] M;
    }
    

    void setMatrix() { //сеттер
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++) {
                T k;
                cin >> k;
                M[i][j] = k;
            }
    };
    T getMatrix(int i, int j) { //геттер
        if ((m > 0) && (n > 0))
            return M[i][j];
        else
            return 0;
        //for (int i = 0; i < n; i++) {
        //    for (int j = 0; j < m; j++)
        //        cout << M[i][j] << " ";
        //    cout << endl;
        //}
        //cout << endl;
    }

    void show() {
        cout << "---------------------" << endl << endl;
        for (int i = 0; i < m; i++)
        {
            cout << "[ ";
            for (int j = 0; j < n; j++)
                cout << "\t" << M[i][j] << "\t";
            cout << " ]" << endl;
        }
        cout << "---------------------" << endl << endl;
    }
    
    //перегрузка оператора []
    class CRow {
        friend class Matrix;
    public:
        T operator[](int n)
        {
            return parent.M[m][n];
        }
    private:
        CRow(Matrix& parent_, int m_) :
            parent(parent_),
            m(m_)
        {}

        Matrix& parent;
        int m;
    };

    CRow operator[](int m)
    {
        return CRow(*this, m);
    }
    
    //перегрузка оператора +
    Matrix operator+(const Matrix<T>& _M) {
        m = _M.m;
        n = _M.n;

        Matrix <T> C(m, n);
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
            {
                C.M[i][j] = M[i][j] + _M.M[i][j];
            }

        return C;
    }
    //перегрузка оператора -
    Matrix operator-(const Matrix& _M) {
        m = _M.m;
        n = _M.n;

        Matrix <T> C(m, n);
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
            {
                C.M[i][j] = M[i][j] - _M.M[i][j];
            }

        return C;
    };
    //перегрузка оператора * для int
    Matrix operator *(int k) {
        Matrix <T> C(m, n);
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
            {
                C.M[i][j] = M[i][j] * k;
            }

        return C;
    }
    //перегрузка оператора * для перемножения матриц
    Matrix operator *(const Matrix<T>& _M) {
        if (n == _M.m) {
            int x = m;
            int y = n;
            int z = _M.n;

            Matrix <T> C(x, z);
            for (int i = 0; i < x; i++) {
                for (int j = 0; j < z; j++) {
                    for (int k = 0; k < y; k++)
                        C.M[i][j] += M[i][k] * _M.M[k][j];
                }
            }
            return C;
        }
        else {
            return _M;
        }
        
    };

    bool operator ==(const Matrix<T>& _M) {
        m = _M.m;
        n = _M.n;
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
            {
                if (M[i][j] != _M.M[i][j]) {
                    return false;
                };
            }

        return true;
    }

    // Конструктор копирования - copy
    Matrix(const Matrix & _M) {
            // Создается новый объект для которого виделяется память
            // Копирование данных *this <= _M
            m = _M.m;
            n = _M.n;

            // Выделить память для M
            M = (T**) new T * [m]; // количество строк, количество указателей

            for (int i = 0; i < m; i++)
                M[i] = (T*) new T[n];

            // заполнить значениями
            for (int i = 0; i < m; i++)
                for (int j = 0; j < n; j++)
                    M[i][j] = _M.M[i][j];
        }

    // оператор копирования - copy
    Matrix operator=(const Matrix & _M)
        {
            if (n > 0)
            {
                // освободить память, выделенную ранее для объекта *this
                for (int i = 0; i < m; i++)
                    delete[] M[i];
            }

            if (m > 0)
            {
                delete[] M;
            }

            // Копирование данных M <= _M
            m = _M.m;
            n = _M.n;

            // Выделить память для M опять
            M = (T**) new T * [m]; // количество строк, количество указателей
            for (int i = 0; i < m; i++)
                M[i] = (T*) new T[n];

            // заполнить значениями
            for (int i = 0; i < m; i++)
                for (int j = 0; j < n; j++)
                    M[i][j] = _M.M[i][j];
            return *this;
        }
    
};

int main()
{
    setlocale(LC_ALL, "rus");
    cout << "Матрица A: \n";
    Matrix <int> A(3, 3);
    A.show();
    cout << A[1][2] << endl;
    
    int m, n;
    cout << "Введите количество строк: ";
    cin >> m;
    cout << "Введите количество столбцов: ";
    cin >> n;
    Matrix <int> B(m, n);
    B.setMatrix();
    cout << "B: " << endl;
    B.show();
    
    Matrix <int> C = B; //копирование
    cout << "C: " << endl;
    C.show();
    Matrix <int> D;
    D = B;
    cout << "D: " << endl;
    D.show();
    
    Matrix <int> K;
    K = D = C = B; //цепочка
    cout << "K: " << endl;
    K.show();

    Matrix <int> T; //- или +
    T = C - B;
    cout << "T: " << endl;
    T.show();


    int t, k; 
    cout << "Введите количество строк: ";
    cin >> t;
    cout << "Введите количество столбцов: ";
    cin >> k;
    Matrix <int> L(t, k);
    L.setMatrix();
    cout << "L: " << endl;
    L.show();
    Matrix <int> R = L * k; // матрица * int
    cout << "R = L * k: " << endl;
    R.show();
    Matrix <int> H = B * L; // матрица * матрица
    cout << "H = B * L или L, если операция невозможна: " << endl;
    H.show();


    cout << "Проверка операции умножения: " << endl;
    if (H == L) { // ==
        cout << "H и L равны." << endl;
    }
    else {
        cout << "H и L не равны." << endl;
    };
}
