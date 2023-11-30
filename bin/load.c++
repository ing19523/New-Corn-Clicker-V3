#include <fstream>
#include <iostream>

using namespace std;

class MyClass
{
public:
    MyClass (int x) : m_x(x), m_y(x+1) {}

    friend istream& operator >> (istream& in, MyClass& obj);
    friend ostream& operator << (ostream& out, const MyClass& obj);

private:
    int m_x;
    int m_y;
};

istream& operator >> (istream& in, MyClass& obj)
{
    in >> obj.m_x;
    in >> obj.m_y;
    return in;
}

ostream& operator << (ostream& out, const MyClass& obj)
{
    out << obj.m_x << ' ';
    out << obj.m_y << endl;
    return out;
}

int main(int argc, char* argv[])
{
    MyClass myObj(10);
    MyClass other(1);
    cout << myObj;
    ofstream outFile ("serialized.txt");
    outFile << myObj;
    outFile.close();
    ifstream inFile ("serialized.txt");
    inFile >> other;
    inFile.close();
    cout << other;
    return 0;
}
