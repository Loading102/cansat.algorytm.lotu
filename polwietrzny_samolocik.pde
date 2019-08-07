PGraphics circles;

PGraphics my_line;

PGraphics mapa;



int c = 128;



//mapa rozmiar i położenie

int mapa_szer = 700;

int mapa_wys  = 700;

int mapa_pocz_x = 10;

int mapa_pocz_y = 10;

int ostatnio_na_planszy = 0;

int rog_pola_wiatru_1_x = 0;

int rog_pola_wiatru_1_y = 0;

int rog_pola_wiatru_2_x = 180;

int rog_pola_wiatru_2_y = 180;               //nasza ingerencja w wiatr

int ram = 0;                                 //tymczasowa zmienna - przdaje się do zamieniania zmiennych miejscami

int pole_wiatru_w_trakcie_zaznaczania = 0;   //czy pole wiatru jest teraz zaznaczane (0 lub 1)

int ponadczasowe_i = 0;                      //nie wiem czemu to działa, nie wiem czemu bez tego nie działa, ale jest to na tyle podstawowa częś że raczej nie będziemey musieli jej ruszać

int nerwowosc_wiatru = 5;                   //strowanie gwałtownością zmian wiatru - nie polecam stosować powyżej 50 (liczby całkowite, musi być powyżej 0)

int wiatr_realny_x = 0;

int wiatr_realny_y = 0;                      //włąściwy wiatr odziałujący na cansat'a

int czy_rysowac_sciezke = 1;                 //czy rysować ścieżkę wiatru (0 = nie, 1 = tak) (w celu uniknięcia spadków FPS)

float predkosc_zmiany_wiatru_x = 0;          //zmienne do obliczania losowego wiatru

float predkosc_zmiany_predkosci_zmiany_wiatru_x = 0;

float predkosc_zmiany_wiatru_y = 0;

float predkosc_zmiany_predkosci_zmiany_wiatru_y = 0;

float skala_wiatru_x = 3.888;                //zmienne do skalowania wiatru w celu częściowego panowania nad jego kierunkiem

float skala_wiatru_y = 3.888;

float kursor_pocz_x = random(100, 600);

float kursor_pocz_y = random(100, 600);

float cel_x = 350;

float cel_y = 350;

float x_do_celu;

float y_do_celu;

float linka_P = 1;  //więcej = bardziej pociągnięta linka

float linka_L = 1;

float wspolczynnik_predkosci = 1;

float wspolczynnik_obrotu = 1.2;

float rysowany_x = 0;

float rysowany_y = 0;                 //rysowane tymczasowe ostatnie punkty

float licznik = 0;                    //licznik ilości ruchów

float azymut_na_cel = 0;              //azymut kierunkowy na cel dla CanSat'a 

float azymut2;

float oczekiwany_azymut = 0;

float odwrotnosc_oczekiwanego_azymutu = 0; 

float wskaznik = 0;                   

float odleglosc_od_celu_x = 0;

float odleglosc_od_celu_y = 0;

float cwiartki = 0;

float kontrolka = 0;

float wysokosc = 1300;

float[] dane_azymut = {0};            //lista kątów obrotu z każdym krokiem

float[] dane_przesuniecie = {0};      //lista przesunięć w poszczególnych ruchach

float[] dane_x = {0};                 //tu zapisywane są kolejne wartości x wiatru (wartoość wiatru x w tym momencie:  dane_x[dane_x.length - 1]   )

float[] dane_y = {0};                 //tu zapisywane są kolejne wartości y wiatru (wartoość wiatru y w tym momencie:  dane_y[dane_y.length - 1]   )







//rozdielczość ekranu laptopa 1366 x 768





//tworzymy mapę

void mapa_ini(int szer, int wys)

{

  mapa = createGraphics(szer, wys); 

  

  //początek renderowania obiektu

  mapa.beginDraw();

  

  //tło 

  mapa.background(0, 0, 0, 255);

  

  //linie podziałki

  mapa.stroke(255, 0, 0, 80);

  //pionowe

  for(int x=0; x<szer; x+=20) mapa.line(x, 1, x, mapa_wys-2);

  //pioziome

  for(int y=0; y<wys; y+=20)  mapa.line(1, y, mapa_szer-2, y);



  //ramka

  mapa.stroke(255, 255, 255, 255);

  mapa.line(0, 0, szer-1, 0);

  mapa.line(0, 0, 0, wys-1);

  mapa.line(szer-1, 0, szer-1, wys-1);

  mapa.line(0, wys-1, szer-1, wys-1);  



  //koniec renderowania obiektu

  mapa.endDraw();

  

}







void setup() 

{

  



  

  size(1200, 780);

  

  frameRate(15);

  

  background(0);

  

  

  mapa_ini(mapa_szer, mapa_wys);

  

  /*

  //Przygotuj obiekt 

  circles = createGraphics(100, 100); 

  circles.beginDraw();

  circles.background(255, 0, 0, 255);

  circles.noStroke();    //bez obramowania

  circles.fill(0, 0, 255, 255); 

  circles.endDraw();

  

  

  //

  my_line = createGraphics(130, 130); 

  my_line.beginDraw();

  my_line.stroke(255);

  my_line.background(128, 255);

  my_line.fill(255, 0, 0, 255); 

  my_line.endDraw();

 */

} 



boolean kursor_jest_na_mapie(int x, int y)

{

  noCursor();

  //jeśli pozycja myszki mieści się na mapie

  if(  x > mapa_pocz_x 

    && x < mapa_pocz_x + mapa_szer 

    && y > mapa_pocz_y 

    && y < mapa_pocz_y + mapa_wys 

    )

      return true;

    else

      return false;

}

boolean kursor_jest_na_mapie_wiatru(int x, int y)

{

  //jeśli pozycja myszki mieści się na mapie wiatru

  if(  x > 720 

    && x < 900

    && y > 529

    && y < 709

    )

      return true;

    else

      return false;
      
}

void mapa_rysuj_kursor(int x, int y)

{

  //jeśli pozycja myszki mieści się na mapie

  if(kursor_jest_na_mapie(x, y))

  {

    line(mapa_pocz_x+1, y, mapa_pocz_x+mapa_szer-2, y);  //pozioma

    line(x, mapa_pocz_y+1, x, mapa_pocz_y+mapa_wys-2);   //pionowa

  }

  else 

    cursor();  //poza mapą - pokaż kursor myszki  noCursor();

    

}



void draw() {

  strokeWeight(2.5);

  //image(circles, 0, 0);

  //image(my_line, 50, 50);

  image(mapa, mapa_pocz_x, mapa_pocz_y);

  

  stroke(255);

  

  mapa_rysuj_kursor(mouseX, mouseY);

  

  //Prezentuj wsp X

  //wykasuj obszar na text

  noStroke();

  fill(0);

  rect(mapa_szer+20, 0, width, 33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("prędkość" + dane_przesuniecie[dane_przesuniecie.length - 1], mapa_szer+20, 30); 

  

  //Prezentuj wsp Y

  //wykasuj obszar na text

  noStroke();

  fill(0);

  rect(mapa_szer+20, 35, width, 35+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("wskaźnik " + wspolczynnik_obrotu, mapa_szer+20, 35+30); 



   noStroke();

  fill(0);

  rect(mapa_szer+20, 70, width, 70+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("azymut_cansata " + dane_azymut[dane_azymut.length - 1], mapa_szer+20, 70+30); 

 

  noStroke();

  fill(0);

  rect(mapa_szer+20, 105, width, 105+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("wiatr x " + wiatr_realny_x, mapa_szer+20, 105+30);  

  

  noStroke();

  fill(0);

  rect(mapa_szer+20, 140, width, 140+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("wiatr y " + wiatr_realny_y, mapa_szer+20, 140+30);

  

  noStroke();

  fill(0);

  rect(mapa_szer+20, 175, width, 175+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("różnica_y " + rysowany_y, mapa_szer+20, 175+30);

  

  noStroke();

  fill(0);

  rect(mapa_szer+20, 210, width, 210+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("azymut_od_środka " + oczekiwany_azymut, mapa_szer+20, 210+30);

  

  noStroke();

  fill(0);

  rect(mapa_szer+20, 245, width, 245+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("x_od_środka " + x_do_celu, mapa_szer+20, 245+30);

  

  noStroke();

  fill(0);

  rect(mapa_szer+20, 280, width, 280+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("y_do_środka " + y_do_celu, mapa_szer+20, 280+30);

  

  noStroke();

  fill(0);

  rect(mapa_szer+20, 315, width, 315+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("linka_P " + linka_P, mapa_szer+20, 315+30);

  

  noStroke();

  fill(0);

  rect(mapa_szer+20, 350, width, 350+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("linka_L " + linka_L, mapa_szer+20, 350+30);

  

  noStroke();

  fill(0);

  rect(mapa_szer+20, 385, width, 385+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("odwrotnosc " + odwrotnosc_oczekiwanego_azymutu, mapa_szer+20, 385+30);

  

  noStroke();

  fill(0);

  rect(mapa_szer+20, 420, width, 420+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("azymut2 " + azymut2, mapa_szer+20, 420+30);

  

  noStroke();

  fill(0);

  rect(mapa_szer+20, 455, width, 455+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("ćwiartki " + cwiartki, mapa_szer+20, 455+30);

  

  noStroke();

  fill(0);

  rect(mapa_szer+20, 490, width, 490+33);

  //pokaż wartość

  stroke(255);

  textSize(32);

  fill(0, 102, 153);

  text("wysokość " + wysokosc, mapa_szer+20, 490+30);



    //rysowanie linii

    stroke(155, 155, 155);

    pushMatrix();

    translate(kursor_pocz_x, kursor_pocz_y);

    rotate(radians(270));

    rysowany_x = 0;

    rysowany_y = 0;

    for(int i = 1; i < dane_azymut.length; i++)

    {

        rotate(radians(dane_azymut[i]));      //rysowanie matrixami

        line(0, 0, dane_przesuniecie[i], 0);

        translate(dane_przesuniecie[i], 0);

        rotate(radians(360 - dane_azymut[i]));

        stroke(255, 155, 155);

        //line(rysowany_x, rysowany_y, sin(radians(dane_azymut[dane_azymut.length - 1])) * dane_przesuniecie[dane_przesuniecie.length - 1], cos(radians(dane_azymut[dane_azymut.length - 1])) * dane_przesuniecie[dane_przesuniecie.length - 1]);//rysowanie trygonometrią

        rysowany_x = rysowany_x + sin(radians(dane_azymut[i])) * dane_przesuniecie[i];

        rysowany_y = rysowany_y + cos(radians(dane_azymut[i])) * dane_przesuniecie[i];

    }

    //rysowanie wektoru

    strokeWeight(4);

    stroke(102, 255, 102);

    rotate(radians(dane_azymut[dane_azymut.length - 1]));

    line(0, 0, dane_przesuniecie[dane_przesuniecie.length - 1] * 25, 0);

    line(dane_przesuniecie[dane_przesuniecie.length - 1] * 25 - 10, 10, dane_przesuniecie[dane_przesuniecie.length - 1] * 25, 0);

    line(dane_przesuniecie[dane_przesuniecie.length - 1] * 25 - 10, -10, dane_przesuniecie[dane_przesuniecie.length - 1] * 25, 0);

    rotate(radians(360 - dane_azymut[dane_azymut.length - 1]));

    popMatrix();



  

  //rysowanie punktu celu

  strokeWeight(10);

  stroke(255, 0, 0);

  point(cel_x, cel_y);

  

  //stroke(0, 0, 10, 20);

  //fill(204, 102, 0);

  //rect(30, 20, 55, 35);
  
  
  
  //rysowanie mapy wiatru
  
  strokeWeight(1);
  
  stroke(255, 255, 255, 255);

  line(720, 529, 900, 529);

  line(900, 529, 900, 709);

  line(900, 709, 720, 709);

  line(720, 709, 720, 529);  
  
  //linie podziałki

  stroke(255, 0, 0, 80);

  //pionowe

  for(int x=0; x<180; x+=20) line(x + 720, 530, x + 720, 710);

  //pioziome

  for(int y=0; y<180; y+=20)  line(720, y + 530, 900, y + 530);
  
  
  //zaznaczanie pola wiatru
  strokeWeight(2);
  
  stroke(100, 100, 100);

  point(rog_pola_wiatru_1_x + 720, rog_pola_wiatru_1_y + 530);

  if(kursor_jest_na_mapie_wiatru(mouseX, mouseY) && pole_wiatru_w_trakcie_zaznaczania == 1)
  {
    line(rog_pola_wiatru_1_x + 720, rog_pola_wiatru_1_y + 530, mouseX, rog_pola_wiatru_1_y + 530);  
    
    line(mouseX, rog_pola_wiatru_1_y + 530, mouseX, mouseY);  
    
    line(mouseX, mouseY, rog_pola_wiatru_1_x + 720, mouseY);  
    
    line(rog_pola_wiatru_1_x + 720, mouseY, rog_pola_wiatru_1_x + 720, rog_pola_wiatru_1_y + 529);  
  }
  else if(pole_wiatru_w_trakcie_zaznaczania == 0)
  {
    line(rog_pola_wiatru_1_x + 720, rog_pola_wiatru_1_y + 530, rog_pola_wiatru_2_x + 720, rog_pola_wiatru_1_y + 530);  
    
    line(rog_pola_wiatru_2_x + 720, rog_pola_wiatru_1_y + 530, rog_pola_wiatru_2_x + 720, rog_pola_wiatru_2_y + 530);  
    
    line(rog_pola_wiatru_2_x + 720, rog_pola_wiatru_2_y + 530, rog_pola_wiatru_1_x + 720, rog_pola_wiatru_2_y + 530);  
    
    line(rog_pola_wiatru_1_x + 720, rog_pola_wiatru_2_y + 530, rog_pola_wiatru_1_x + 720, rog_pola_wiatru_1_y + 530);  
  }
  
  //rysowanie trasy zmiany wiatru
  
  strokeWeight(1);
  
   for(int i = 1; i < dane_x.length / 4; i++){

  if(czy_rysowac_sciezke == 1)line(
  dane_x[i] / skala_wiatru_x + 720 + rog_pola_wiatru_1_x, 
  dane_y[i] / skala_wiatru_y + 530 + rog_pola_wiatru_1_y, 
  dane_x[i-1] / skala_wiatru_x + 720 + rog_pola_wiatru_1_x, 
  dane_y[i-1] / skala_wiatru_y + 530 + rog_pola_wiatru_1_y);

  ponadczasowe_i = i;

  }
  
  //rysowanie wektora wiatru
  
  stroke(0, 0, 255);
  
  strokeWeight(2);
  
  line(wiatr_realny_x + 810, wiatr_realny_y + 621, 810, 621);
  
  //powrót do ustawień wyjściowych
  
  strokeWeight(10);

  stroke(255, 0, 0);



}



void mousePressed() {


  
  if(kursor_jest_na_mapie(mouseX, mouseY))
  {
    
    //zaznaczanie celu
      
    cel_x = mouseX;
  
    cel_y = mouseY;
  }
  else if(kursor_jest_na_mapie_wiatru(mouseX, mouseY))
  {
    
    //zaznaczanie pola wiatru
    
    if(pole_wiatru_w_trakcie_zaznaczania == 0)
    {  
      rog_pola_wiatru_1_x = mouseX - 720;
  
      rog_pola_wiatru_1_y = mouseY - 530;
      
      pole_wiatru_w_trakcie_zaznaczania = 1;
    }
    else
    {
      rog_pola_wiatru_2_x = mouseX - 720;
  
      rog_pola_wiatru_2_y = mouseY - 530;
      
      pole_wiatru_w_trakcie_zaznaczania = 0;
      
      // ewentualne zamienienie rogów miejscami
      
      if(rog_pola_wiatru_2_x < rog_pola_wiatru_1_x)
      {
        ram = rog_pola_wiatru_2_x;
        
        rog_pola_wiatru_2_x = rog_pola_wiatru_1_x;
        
        rog_pola_wiatru_1_x = ram;
      }
      
      if(rog_pola_wiatru_2_y < rog_pola_wiatru_1_y)
      {
        ram = rog_pola_wiatru_2_y;
        
        rog_pola_wiatru_2_y = rog_pola_wiatru_1_y;
        
        rog_pola_wiatru_1_y = ram;
      }
      
      //ustalanie skali wiatru
      skala_wiatru_x = 700 / (rog_pola_wiatru_2_x - rog_pola_wiatru_1_x + 1);
      
      skala_wiatru_y = 700 / (rog_pola_wiatru_2_y - rog_pola_wiatru_1_y + 1);
    }
  }
  
  
  
} 





void mouseMoved() 

{

   

  //  rysowany_x  rysowany_y  dane_azymut  linka_P  linka_L  cel_x  cel_y  kursor_pocz_x  kursor_pocz_y  azymut_na_cel  



  

  x_do_celu = kursor_pocz_x + rysowany_x - cel_x;

  y_do_celu = kursor_pocz_y - rysowany_y - cel_y;

  

  oczekiwany_azymut = abs(degrees(atan(  y_do_celu / x_do_celu  )));

  

  

  

  

  

  

  /*

  if(x_do_celu <=  30 && x_do_celu >=  -30 && y_do_celu <=  30 && y_do_celu >= -30)

  {

    if(wysokosc > 0 && kontrolka == 0)

    {

      wspolczynnik_obrotu = 3;

      kontrolka = 1;

    }

  }

  else

  {

    wspolczynnik_obrotu = 1.2;

  }

  

  if(wysokosc == 0)

  {

    //koniec

  }*/

  if(x_do_celu <=  30 && x_do_celu >=  -30 && y_do_celu <=  30 && y_do_celu >= -30)

  {

    //nic

  }

  else

  {

    line(cel_x + x_do_celu, cel_y, cel_x + x_do_celu, cel_y + y_do_celu);

    line(cel_x, cel_y, cel_x + x_do_celu, cel_y);

    line(cel_x, cel_y, cel_x + x_do_celu, cel_y + y_do_celu);

    

    

    if(x_do_celu<=0 && y_do_celu<=0)

    {

      oczekiwany_azymut = (450 + oczekiwany_azymut) % 360;

      cwiartki = 4;

    }

    else if(x_do_celu>=0 && y_do_celu<=0)

    {

      oczekiwany_azymut = 270 - oczekiwany_azymut;

      cwiartki = 1;

    }

    else if(x_do_celu>=0 && y_do_celu>=0)

    {

      oczekiwany_azymut = 270 + oczekiwany_azymut;

      cwiartki = 2;

    }

    else if(x_do_celu<=0 && y_do_celu>=0)

    {

      oczekiwany_azymut = (450 - oczekiwany_azymut) % 360;

      cwiartki = 3;

    }

    

    if(oczekiwany_azymut <= 180)

    odwrotnosc_oczekiwanego_azymutu = 180 + oczekiwany_azymut;

    else

    odwrotnosc_oczekiwanego_azymutu = oczekiwany_azymut - 180;

    

    azymut2 = dane_azymut[dane_azymut.length - 1];

    if(azymut2 < oczekiwany_azymut && azymut2 > odwrotnosc_oczekiwanego_azymutu)

    {

      azymut2 = azymut2 + 360;

    }

    

    

  

    if(cwiartki == 1 || cwiartki == 2)

      {

        if(azymut2 > oczekiwany_azymut && azymut2 <= 360 || azymut2 < odwrotnosc_oczekiwanego_azymutu && azymut2 >= 0 )  

          {

            linka_L = linka_L + 0.2;

            linka_P = linka_P - 0.1;

            wskaznik = 1;

          }

          else

          {

            linka_P = linka_P + 0.2;

            linka_L = linka_L - 0.1;

            wskaznik = 2;

          }

      }

    else if(cwiartki == 3 || cwiartki == 4)

      {

        if(azymut2 > odwrotnosc_oczekiwanego_azymutu && azymut2 <= 360 || azymut2 < oczekiwany_azymut && azymut2 >= 0 )  

        {

          linka_P = linka_P + 0.2;

          linka_L = linka_L - 0.1;

          wskaznik = 2;

        }

        else

        {

          linka_L = linka_L + 0.2;

          linka_P = linka_P - 0.1;

          wskaznik = 1;

        }  

      }

      

    if(linka_P > 2)

    {

      linka_P = 2;

    }

    else if(linka_P < 0)

    {

      linka_P = 0;

    }

    

    if(linka_L > 2)

    {

      linka_L = 2;

    }

    else if(linka_L < 0)

    {

      linka_L = 0;

    }

    

    licznik++; 

    

      dane_azymut = append(dane_azymut, (dane_azymut[dane_azymut.length - 1] + (linka_P - linka_L) * wspolczynnik_obrotu) % 360);                //każdorazowa zmiana kąta w stopniach

      while(dane_azymut[dane_azymut.length - 1] < 0)

      {

      dane_azymut[dane_azymut.length - 1] = 360 + dane_azymut[dane_azymut.length - 1];

      }

      //dane_przesuniecie = append(dane_przesuniecie, (linka_P + linka_L) * wspolczynnik_predkosci);  //każdorazowe przesunięcie w pikselach

      dane_przesuniecie = append(dane_przesuniecie, 2 * wspolczynnik_predkosci); 

      if(wysokosc > 0)wysokosc = wysokosc - 2;
      
      
      // obliczanie losowego wiatru
      
      for(int in = 0; in < nerwowosc_wiatru; in++){
      //użyłem ,,in" , bo ,,i" było już zajęte
      
      
      //bezpiecznik - przy zbyt dużej skali wiatru skrypt był wykonywany zbyt wiele razy, więc program dzaiłał za wolno
      
      ram = int(skala_wiatru_x);
      if(skala_wiatru_x > 200)
      ram = 200;
      
      
      
      for(int i = 0; i < ram; i++){
              
          //zmiana parametrów x wiatru
        
          
        
          dane_x = append(dane_x, dane_x[dane_x.length - 1] + (350 - dane_x[dane_x.length - 1]) / 35 + predkosc_zmiany_wiatru_x / 1000); 
        
          predkosc_zmiany_wiatru_x = predkosc_zmiany_wiatru_x + (350 - dane_x[dane_x.length - 1]) / 50 + predkosc_zmiany_predkosci_zmiany_wiatru_x;
        
          if(predkosc_zmiany_wiatru_x > 10000)
        
          {
        
            predkosc_zmiany_wiatru_x = 10000;
        
          }
        
          else if(predkosc_zmiany_wiatru_x < -10000)
        
          {
        
           predkosc_zmiany_wiatru_x = -10000; 
        
          }
        
          predkosc_zmiany_predkosci_zmiany_wiatru_x = predkosc_zmiany_predkosci_zmiany_wiatru_x + random(-2, 2);
        
          if(predkosc_zmiany_predkosci_zmiany_wiatru_x > 20)
        
          {
        
            predkosc_zmiany_predkosci_zmiany_wiatru_x = 20;
        
          }
        
          else if(predkosc_zmiany_predkosci_zmiany_wiatru_x < -20)
        
          {
        
           predkosc_zmiany_predkosci_zmiany_wiatru_x = -20; 
        
          }
        
      }
      
      
      //bezpiecznik - przy zbyt dużej skali wiatru skrypt był wykonywany zbyt wiele razy, więc program dzaiłał za wolno
      
      ram = int(skala_wiatru_y);
      if(skala_wiatru_y > 200)
      ram = 200;      
      
      
      for(int i = 0; i < ram; i++){
      
          //zmiana parametrów y wiatru
        
          
        
          dane_y = append(dane_y, dane_y[dane_y.length - 1] + (350 - dane_y[dane_y.length - 1]) / 35 + predkosc_zmiany_wiatru_y / 1000); 
        
          predkosc_zmiany_wiatru_y = predkosc_zmiany_wiatru_y + (350 - dane_y[dane_y.length - 1]) / 50 + predkosc_zmiany_predkosci_zmiany_wiatru_y;
        
          if(predkosc_zmiany_wiatru_y > 10000)
        
          {
        
            predkosc_zmiany_wiatru_y = 10000;
        
          }
        
          else if(predkosc_zmiany_wiatru_y < -10000)
        
          {
        
           predkosc_zmiany_wiatru_y = -10000; 
        
          }
        
          predkosc_zmiany_predkosci_zmiany_wiatru_y = predkosc_zmiany_predkosci_zmiany_wiatru_y + random(-2, 2);
        
          if(predkosc_zmiany_predkosci_zmiany_wiatru_y > 20)
        
          {
        
            predkosc_zmiany_predkosci_zmiany_wiatru_y = 20;
        
          }
        
          else if(predkosc_zmiany_predkosci_zmiany_wiatru_y < -20)
        
          {
        
           predkosc_zmiany_predkosci_zmiany_wiatru_y = -20; 
        
          }
        
      }
     
      }
      
      //wyliczenie realnego i przeskalowanego wiatru
      
      wiatr_realny_x = rog_pola_wiatru_1_x + (rog_pola_wiatru_2_x - rog_pola_wiatru_1_x) / 2 + int( (dane_x[ponadczasowe_i] - 350) / skala_wiatru_x) - 90;
      
      wiatr_realny_y = rog_pola_wiatru_1_y + (rog_pola_wiatru_2_y - rog_pola_wiatru_1_y) / 2 + int( (dane_y[ponadczasowe_i] - 350) / skala_wiatru_y) - 90;
      
      
  }

}
