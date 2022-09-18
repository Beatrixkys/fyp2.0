class LogicService {
  double goalToSave(String totalAmount, double months) {
    double total = double.parse(totalAmount);

    double amountToSave = (total / months).roundToDouble();

    if (months == 0) {
      return double.parse(totalAmount);
    } else {
      return amountToSave;
    }
  }

  double goalProgress(int totalamountSaved, int totalAmountToSave) {
    double newProgress = (totalamountSaved / totalAmountToSave) * 100;

    if (newProgress >= 100) {
      newProgress = 100;
    }
    return newProgress;
  }

  int newAmount(int total, int original, int newamt) {
    int newAmount = total - original + newamt;

    return newAmount;
  }
}
