#include <iostream>
using namespace std;

class Cell {
public:
    int data;
    Cell* next;
    Cell(int d) : data(d), next(nullptr) {}
};

class Queue {
public:
    Queue() : front(nullptr), rear(nullptr) {}
    ~Queue() {
        while (!isEmpty()) {
            pop();
        }
    }
    bool isEmpty() {
        return front == nullptr;
    }
    void push(int data) {
        Cell* newRear = new Cell(data);
        if (isEmpty()) {
            front = rear = newRear;
        }
        else {
            rear->next = newRear;
            rear = newRear;
        }
    }
    int pop() {
        if (isEmpty()) {
            throw std::runtime_error("Queue is empty");
        }
        Cell* oldFront = front;
        int data = oldFront->data;
        front = front->next;
        if (front == nullptr) {
            rear = nullptr;
        }
        delete oldFront;
        return data;
    }
private:
    Cell* front;
    Cell* rear;
};

int main() {
    Queue q;
    q.push(5);
    q.push(4);
    cout << q.pop() << endl;
    cout << q.pop() << endl;
    return 0;
}