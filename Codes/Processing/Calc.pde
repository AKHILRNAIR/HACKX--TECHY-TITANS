class Calc {
  float a;
  float avg;
  Calc(float a) {
    this.a = a;
    reset();
  }
  void note(float x) {
    if(x == Float.POSITIVE_INFINITY)
      return;
    else
      avg = (avg * (1 - a)) + (x * a);
  }
  void reset() {
    avg = 0;
  }
}
