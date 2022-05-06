class MathHelper {
  static double getCenterVal(val, double extendedSize) {
    val = val + extendedSize;
    return val < 0 ? -val : val;
  }
}
