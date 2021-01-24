import 'package:flutter/material.dart';
// 17010011024 Mehmet Taşlı
// proje dosyaları ve APK'nın bulunduğu github :  
/* NOT
odevi flutter kullanarak hazırladım
* proje dosyası sistemin izin verdiği boyutları geçtiği için proje dosyasını ve apk dosyasını github hesabıma yüklüyorum .
herhangi bir emulator yardımı ile apk'yı çalıştırabilirsiniz.
* */
/*
* donusum yapılırken bazı yerlerde setState komutu kullandım, herhangi bir değerde değişim olduğu zaman değişimin gerçekleştiği değişkenin kullanıldığı widget i
* güncelliyor örneğin a = 4 ken ben a = 6 yaptığım zaman a değerinin 6 olduğunu ekranda görmek istiyorsam setState komutunu kullanıyorum yapmış olduğum
* infix postfix değişimini etkilemiyor sadece ekranda gösterebilmek için
* */

void main() {
  runApp(MaterialApp(
      routes: {
        "/": (context) => anaSayfa(),
      }
  ));
}

class anaSayfa extends StatefulWidget {
  @override
  _anaSayfaState createState() => _anaSayfaState();
}
// ekranı tasarlıyorum
class _anaSayfaState extends State<anaSayfa> {
  String girilenDeger;
  String sonuc = "Bos";
  String stackstring = " ";
  //stackte meydana gelen değişimleri ekranda cardlar ile gösteriyorum cardları ekranda gösrterebilmek için bir card listesi oluşturdum
  List<Card> cardList;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    cardList = List<Card>();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("17010011024")),
      body: Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //kullanıcının denklemini yazacağı TextField alanı
            TextField(decoration: InputDecoration(
              hintText: "Denkleminizi Giriniz : ",
            ),
              onChanged: (String deger) {
                setState(() {
                  girilenDeger = deger;
                });
              },),
            //Butona basıldığı zaman donustur fonksiyonu çağrılıyor
            RaisedButton(onPressed: () {
              setState(() {
                sonuc = donustur(girilenDeger);
              });
            },child: Text("Donustur"),),
            Text("Donusum Sonucu : $sonuc"),
            Container(height: 400,child: SingleChildScrollView(
              child: Column(
                children: cardList,
              ),
            ),)


          ],
        ),
      ),
    );
  }

  int isaret(String c) {
    if (c == '+' || c == '-')
      return 1;
    if (c == '*' || c == '/')
      return 2;
    return -1;
  }

  String donustur(String metin) {
    String sonuc = "";
    //yığını oluşturacağım liste
    List<String> stack = new List<String>();
    for (int i = 0; i < metin.length; ++i) {
      //gelen metinde bulunduğum karakterin sayı veya harf olduğunu kontrol ediyorum
      if ((48 <= metin.codeUnitAt(i) && metin.codeUnitAt(i) <= 57) ||
          (65 <= metin.codeUnitAt(i) && metin.codeUnitAt(i) <= 90) ||
          (97 <= metin.codeUnitAt(i) && metin.codeUnitAt(i) <= 122)) {
        sonuc += metin[i];
      }

      else if (metin[i] == '(') {
        if (stack.isNotEmpty) {
          //yıında en üste ekliyorum
          stack.insert(0, metin[i]);
          setState(() {
            //cardList stackte oluşan değişimleri ekranda göstermek için kullandığım Cardları(widget) tuttuğum bir liste dönüşüm işlemine bir etkisi yok
            // Card listesine yeni bir eleman eklendiği için setState ile ekranda güncelleme işlemi yapıyorum
            cardList.add(cardEKle(stack.toString(),sonuc));
          });
        }
        else {
          stack.add(metin[i]);
          setState(() {
            cardList.add(cardEKle(stack.toString(),sonuc));
          });
        }
      }
      else if (metin[i] == ')') {
        while (stack.length > 0 && stack.first != '(') {
          sonuc += stack.removeAt(0);
          setState(() {
            cardList.add(cardEKle(stack.toString(),sonuc));
          });
        }
        if (stack.isNotEmpty) {
          stack.removeAt(0);
          setState(() {
            cardList.add(cardEKle(stack.toString(),sonuc));
          });
        }
      }
      else {
        while (stack.length > 0 && (isaret(metin[i]) <= isaret(stack[0]))) {
          sonuc += stack.removeAt(0);
          setState(() {
            cardList.add(cardEKle(stack.toString(),sonuc));
          });
        }
        if (stack.isNotEmpty) {
          stack.insert(0, metin[i]);
          setState(() {
            cardList.add(cardEKle(stack.toString(),sonuc));
          });
        }
        else {
          stack.add(metin[i]);
          setState(() {
            cardList.add(cardEKle(stack.toString(),sonuc));
          });
        }
      }
    }
    while (stack.length > 0) {
      sonuc += stack.removeAt(0);
      setState(() {
        cardList.add(cardEKle(stack.toString(),sonuc));
      });
    }

    return sonuc;
  }
 // stackte her değişim olduğu zaman stack'in o halindeki değerlerini cardlar içerisinde ekrana bastırıyorum
  // cardları cardEkle adında oluşturudğum fonksiyon ile oluşturuyorum ve geri döndürüyorum
  Card cardEKle(String stack,String veri) {
    return Card(
      child: ListTile(
        title: Text("Stack : "+stack),
        subtitle: Text(veri),
      ),
    );
  }
}

