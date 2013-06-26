import "package:unittest/unittest.dart";
import "package:cookies/cookies.dart";

main() {
  group('basic key/value', () {
    var single = "foo=bar";
    var multiple = "foo=bar;bar=foo;hi=bye";
    Map<String,Cookie> multShould = {
      "foo": new Cookie("foo", "bar"),
      "bar": new Cookie("bar", "foo"),
      "hi": new Cookie("hi", "bye"),
    };

    test('single key/value pair', () {
      CookieJar cj = new CookieJar(single);
      expect(cj.length, equals(1));
      expect(cj.containsKey("foo"), isTrue);
      expect(cj["foo"].key, equals("foo"));
      expect(cj["foo"].value, equals("bar"));
    });
    test('multiple key/value pair', () {
      CookieJar cj = new CookieJar(multiple);
      expect(cj.length, equals(3));
      multShould.forEach((k,v) {
        expect(cj.containsKey(k), isTrue);
        Cookie val = cj[k];
        expect(val.key, equals(v.key));
        expect(val.value, equals(v.value));
      });
    });
  });

  group('complex', () {
    var single = 'foo=bar;path=/hello;domain=example.com;max-age=35;secure';
    var singleShould = new Cookie("foo", "bar", path:"/hello", domain:"example.com", maxAge:"35", secure:true);

    var multiple = "foo=bar;path=/hello;domain=example.com;max-age=35;secure;bar=foo;path=/bye;domain=whatever.com;max-age=2";
    Map<String,Cookie> multShould = {
      "foo": new Cookie("foo", "bar", path:"/hello", domain:"example.com", maxAge:"35", secure:true),
      "bar": new Cookie("bar", "foo", path:"/bye", domain:"whatever.com", maxAge:"2")
    };

    test('single with all the fixins', () {
      CookieJar cj = new CookieJar(single);
      expect(cj.length, equals(1));
      expect(cj.containsKey(singleShould.key), isTrue);
      Cookie c = cj[singleShould.key];
      print("$c $singleShould");
      expect(c.key, equals(singleShould.key));
      expect(c.value, equals(singleShould.value));
      expect(c.path, equals(singleShould.path));
      expect(c.domain, equals(singleShould.domain));
      expect(c.maxAge, equals(singleShould.maxAge));
      expect(c.secure, equals(singleShould.secure));
    });

    test('multiple', () {
      CookieJar cj = new CookieJar(multiple);
      expect(cj.length, equals(2));
      multShould.forEach((k,v) {
        expect(cj.containsKey(k), isTrue);
        Cookie val = cj[k];
        expect(val.key, equals(v.key));
        expect(val.value, equals(v.value));
        expect(val.path, equals(v.path));
        expect(val.domain, equals(v.domain));
        expect(val.maxAge, equals(v.maxAge));
        expect(val.secure, equals(v.secure));
      });
    });
  });

  group('toString', () {
      test('simple cookie', () {
        var single = "foo=bar";
        Cookie c = new Cookie.fromString(single);
        expect(c.toString(), equals(single));
      });
  });
}
