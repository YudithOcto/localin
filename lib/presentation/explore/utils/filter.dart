const List<String> monthList = [
  'January',
  'February',
  'March',
  'April',
  'May',
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
  if (value == 'Closest date' || value == 'Asc') {
    return 'date-asc';
  } else if (value == 'Furthest Date') {
    return 'date-desc';
  } else if (value == 'Lowest Price') {
    return 'price-asc';
  } else if (value == 'Expensive Price') {
    return 'price-desc';
  } else {
    return '';
  }
}
