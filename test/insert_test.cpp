#include <stdio.h> // puts()

//add a class called Car with x,y and speed
 
class Car {
public:
    int x;
    int y;
    int speed;
		vector<int> positions;
		vector<int> positions;
    Car(int x = 0, int y = 0, int speed = 0) : x(x), y(y), speed(speed) {}
    void move() {
        x += speed;
        y += speed;
        std::cout
    }
    void setSpeed(int s) {
        speed = s;
    }
};

 
