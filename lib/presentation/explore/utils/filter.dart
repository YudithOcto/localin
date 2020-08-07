const List<String> monthList = [
  'January',
  'February',
  'March',
  'April',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

const List<String> sortList = [
  'Closest date',
  'Furthest Date',
  'Lowest Price',
  'Expensive Price'
];

String getSorting(String value) {
  if (value == 'Closest date') {
    return 'date-asc';
  } else if (value == 'Furthest Date') {
    return 'date-desc';
  } else if (value == 'Lowest Price') {
    return 'price_asc';
  } else if (value == 'Expensive Price') {
    return 'price-desc';
  } else {
    return '';
  }
}
