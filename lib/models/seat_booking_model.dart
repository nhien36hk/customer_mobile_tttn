class SeatBookingModel {
  final Set<String> selectSeatFloor1;
  final Set<String> selectSeatFloor2;
  final int defaultPriceFloor1;
  final int defaultPriceFloor2;
  final int totalPrice;
  SeatBookingModel({
    required this.selectSeatFloor1,
    required this.selectSeatFloor2,
    required this.defaultPriceFloor1,
    required this.defaultPriceFloor2,
  }) : totalPrice = (selectSeatFloor1.length * defaultPriceFloor1 + selectSeatFloor2.length * defaultPriceFloor2);

  int get countTotalSeats => selectSeatFloor1.length + selectSeatFloor2.length;
}
