#include <stdio.h> // puts()

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
    }
		//Add function AppleNum
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
 
