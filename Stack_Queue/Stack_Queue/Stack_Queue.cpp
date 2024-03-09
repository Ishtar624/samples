#include <iostream>

class Cell {
public:
    int data;
    Cell* next;
    Cell(int d) : data(d), next(nullptr) {}
};

class Stack {
public:
    Stack() : top(nullptr) {}
    ~Stack() {
        while (!isEmpty()) {
            pop();
        }
    }
    bool isEmpty() {
        return top == nullptr;
    }
    void push(int data) {
        Cell* newTop = new Cell(data);
        newTop->next = top;
        top = newTop;
    }
    int pop() {
        if (isEmpty()) {
            throw std::runtime_error("Stack is empty");
        }
        Cell* oldTop = top;
        int data = oldTop->data;
        top = top->next;
        delete oldTop;
        return data;
    }
private:
    Cell* top;
};

int main() {
    Stack s;
    s.push(5);
    s.push(4);
    std::cout << s.pop() << std::endl; // should print 4
    std::cout << s.pop() << std::endl; // should print 5
    return 0;
}