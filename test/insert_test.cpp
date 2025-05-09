#include <stdio.h> // puts()

//add a class called Car with x,y and speed
class Car {
public:
    int x;
    int y;
    int speed;
    Car(int x = 0, int y = 0, int speed = 0) : x(x), y(y), speed(speed) {}
    void move() {
        x += speed;
        y += speed;
    }
    void setSpeed(int s) {
        speed = s;
    }
};
//

class Apple
{
public:
    void AppleName()
    {
        puts( "りんご" ) ;
    }
    void AppleColor()
    {
        puts( "赤" ) ;
				std::cout
    }
		//Add function AppleNum which return 10
} ;

class Banana
{
public:
    void BananaName()
    {
        puts( "バナナ" ) ;
    }
    void BananaColor()
    {
        puts( "黄" ) ;
    }
} ;

// Adapter パターン

// 共通インターフェースを作る
class AdapterPtn
{
public:
    virtual void  NamePuts()  = 0 ;
    virtual void  ColorPuts() = 0 ;
} ;

// 共通インターフェースにあわせる
class Apple2 : public AdapterPtn
{
    Apple  m_apple ;

public:
    virtual void NamePuts()
    {
        m_apple.AppleName() ;
    }
    virtual void ColorPuts()
    {
        m_apple.AppleColor() ;
				cout <<
    }
} ;

class Banana2 : public AdapterPtn
{
    Banana  m_banana ;

public:
    virtual void NamePuts()
    {
        m_banana.BananaName() ;
    }
    virtual void ColorPuts()
    {
        m_banana.BananaColor() ;
    }
} ;

// 実装
// ポインタで受け取るのは好きじゃないんだけど
void sub( AdapterPtn * in )
{
    // 共通インターフェースで呼べる
    in->NamePuts() ;
    in->ColorPuts() ;
}

int main()
{
    Apple2   a2 ; sub( & a2 ) ;
    Banana2  b2 ; sub( & b2 ) ;

    return 0 ;
}
 
