library cookies;

class Cookie {
  String key, value, path, domain, maxAge, expires;
  bool secure = false;
  Cookie(this.key, this.value, {this.path:'/', this.domain:'',this.maxAge:'',this.expires:'',this.secure:false });

  Cookie.fromString(String val) {
    val.split(';').every((s) {
       if (s == "secure") {
        this.secure = true;
        return true;
      }

      var kv = s.split('=').map((s) => s.trim());
      String k = kv.first, v = kv.last;

      switch (k) {
      case "path":
        this.path = v;
        break;
      case "domain":
        this.domain = v;
        break;
      case "max-age":
        this.maxAge = v;
        break;
      case "expires":
        this.expires = v;
        break;
      default:
        if (this.key != null) {
          return false;
        }
        this.key = k;
        this.value = v;
      }

      return true;
    });
  }

  String toString() {
    String ret = "${this.key}=${this.value}";
    if (this.path != null)
      ret = "$ret;path=${this.path}";
    if (this.domain != null)
      ret = "$ret;domain=${this.domain}";
    if (this.maxAge != null)
      ret = "$ret;max-age=${this.maxAge}";
    if (this.expires != null)
      ret = "$ret;expires=${this.expires}";
    if (this.secure)
      ret = "$ret;secure";
    return ret;
  }
}

class CookieJar implements Map<String, Cookie> {
  Map<String, Cookie> cookies;

  CookieJar.from(Map<String, Cookie> other) {
    this.cookies = new Map<String, Cookie>.from(other);
  }

  CookieJar(String cookies) {
    this.cookies = new Map<String, Cookie>();

    Iterable<String> parts = cookies.split(";").map((s) => s.trim());
    if (parts.isEmpty)
      return;

    String c;
    parts.fold([], (p,s) {
      if (s == "secure") {
        p[p.length-1] = "${p[p.length-1]};$s";
        return p;
      }

      var kv = s.split('=').map((s) => s.trim());
      String k = kv.first, v = kv.last;

      if (k == "path" || k == "domain" || k == "max-age" || k == "expires") {
        p[p.length-1] = "${p[p.length-1]};$k=$v";
        return p;
      }

      c = "$k=$v";
      p.add(c);
      return p;
    }).forEach((s) {
      Cookie c = new Cookie.fromString(s);
      this[c.key] = c;
    });
  }

  bool get isEmpty => this.cookies.isEmpty;
  bool get isNotEmpty => this.cookies.isNotEmpty;
  Iterable<String> get keys => this.cookies.keys;
  int get length => this.cookies.length;
  Iterable<Cookie> get values => this.cookies.values;

  void operator []=(String key, Cookie val) {
    this.cookies[key] = val;
  }

  Cookie operator [](Object key) => this.cookies[key];

  void addAll(Map<String, Cookie> other) => this.cookies.addAll(other);
  void clear() => this.cookies.clear();
  bool containsKey(Object key) => this.cookies.containsKey(key);
  bool containsValue(Object val) => this.cookies.containsValue(val);
  void forEach(void f(String key, Cookie val)) => this.cookies.forEach(f);
  Cookie putIfAbsent(String key, Cookie ifAbsent()) => this.cookies.putIfAbsent(key, ifAbsent);
  Cookie remove(Object key) => this.cookies.remove(key);
}
