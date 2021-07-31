boolean l = true;
float mD = 1, MD = 4;

class Stnd {
  float min, max;
  Stnd() {
    reset();
  }
  void note(float x) {
    if(x < min)
      min = x;
    if(x > max)
      max = x;
  }
  float Stnd(float x) {
    if(min == max || min == Float.POSITIVE_INFINITY)
      return 0;
    float n = map(x, min, max, 0, 1);
    return constrain(n, 0, 1);
  }
  float l(float x) {
    float Stndd = Stnd(x);
    if(Stndd == 0)
      return 1;
    float l = sqrt(1 / Stndd);
    l = map(l, mD, MD, 0, 1);
    
    return constrain(l, 0, 1);
  }
  float choose(float x) {
    return l ? l(x) : Stnd(x);
  }
  void reset() {
    min = Float.POSITIVE_INFINITY;
    max = Float.NEGATIVE_INFINITY;  
  }
}
