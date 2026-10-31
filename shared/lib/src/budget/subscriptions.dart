import '../forecast/recurrence.dart';

/// What a recurring amount costs per month, for the subscriptions total:
/// weekly × 52 / 12, yearly / 12, every [interval] periods divided by it.
/// Rounded to the nearest cent; a one-off amount counts for nothing.
int monthlyEquivalentCents(int amountCents, Frequency frequency, int interval) {
  if (interval < 1) throw ArgumentError('Interval must be at least 1');
  int div(int a, int b) {
    final q = (a.abs() * 2 + b) ~/ (2 * b);
    return a < 0 ? -q : q;
  }

  return switch (frequency) {
    Frequency.once => 0,
    Frequency.weekly => div(amountCents * 52, 12 * interval),
    Frequency.monthly => div(amountCents, interval),
    Frequency.yearly => div(amountCents, 12 * interval),
  };
}
