#include <string>

using namespace std;

struct Lista {
  bool sublista;
  string valorString;
  Lista* valorSublista;
  Lista* proximo;
};

Lista* geraLista() {
  Lista *p0, *p1, *p2, *p3, *p4, *p5, *p6, *p7, *p8, *p9, *p10, *p11, *p12;

  p0 = new Lista;
  p0->sublista = false;
  p0->valorString = "y";
  p0->valorSublista = nullptr;

  p0->proximo = nullptr;


  p1 = new Lista;
  p1->sublista = true;
  p1->valorString = "";
  p1->valorSublista = p0;

  p2 = new Lista;
  p2->sublista = false;
  p2->valorString = "i";
  p2->valorSublista = nullptr;

  p2->proximo = nullptr;


  p3 = new Lista;
  p3->sublista = true;
  p3->valorString = "";
  p3->valorSublista = p2;

  p4 = new Lista;
  p4->sublista = false;
  p4->valorString = "8";
  p4->valorSublista = nullptr;

  p4->proximo = nullptr;

  p3->proximo = p4;


  p5 = new Lista;
  p5->sublista = true;
  p5->valorString = "";
  p5->valorSublista = p3;


  p6 = new Lista;
  p6->sublista = true;
  p6->valorString = "";
  p6->valorSublista = nullptr;

  p6->proximo = nullptr;


  p7 = new Lista;
  p7->sublista = true;
  p7->valorString = "";
  p7->valorSublista = p6;


  p8 = new Lista;
  p8->sublista = true;
  p8->valorString = "";
  p8->valorSublista = );

  p9 = new Lista;
  p9->sublista = false;
  p9->valorString = "9";
  p9->valorSublista = nullptr;

  p9->proximo = nullptr;


  p10 = new Lista;
  p10->sublista = true;
  p10->valorString = "";
  p10->valorSublista = p9;

  p10->proximo = nullptr;

  p8->proximo = p10;

  p7->proximo = p8;


  p11 = new Lista;
  p11->sublista = true;
  p11->valorString = "";
  p11->valorSublista = p7;

  p12 = new Lista;
  p12->sublista = false;
  p12->valorString = "9.7";
  p12->valorSublista = nullptr;

  p12->proximo = nullptr;

  p11->proximo = p12;

  p5->proximo = p11;

  p1->proximo = p5;

  return p1;
}
