/// A single OHLC candle.
class Candle {
  final DateTime time;
  final double open, high, low, close;

  const Candle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  bool get isBullish => close >= open;
}

/// One point on the Market Average / Reflection line comparison.
class CompositePoint {
  final DateTime time;
  final double marketAverage; // % move, equal-weighted composite
  final double priceReflection; // % move of raw US30 price
  const CompositePoint({
    required this.time,
    required this.marketAverage,
    required this.priceReflection,
  });
}

/// A single point on a session-behaviour sparkline.
class SessionPoint {
  final double value;
  const SessionPoint(this.value);
}

class SessionBehavior {
  final String name;
  final String timeRange;
  final List<SessionPoint> points;
  const SessionBehavior({
    required this.name,
    required this.timeRange,
    required this.points,
  });
}

/// Upcoming/live economic news event, mirrors the `economic_events` table.
class NewsEvent {
  final String name;
  final String countryCode;
  final String importance; // "High" | "Medium" | "Low"
  final DateTime scheduledTime;
  final String previous;
  final String forecast;
  final String? actual; // null until released
  final Duration? countdown;

  const NewsEvent({
    required this.name,
    required this.countryCode,
    required this.importance,
    required this.scheduledTime,
    required this.previous,
    required this.forecast,
    this.actual,
    this.countdown,
  });
}

/// A single component score feeding the Signal Engine gauge.
class ScoreComponent {
  final String label;
  final double percent; // 0-100
  const ScoreComponent(this.label, this.percent);
}

enum SignalAction { buy, wait, sell }

class SignalEngineState {
  final double confidencePercent;
  final SignalAction recommendation;
  final List<ScoreComponent> components;
  final int sampleSize; // how many historical events this is based on

  const SignalEngineState({
    required this.confidencePercent,
    required this.recommendation,
    required this.components,
    required this.sampleSize,
  });
}

/// A single oscillator bar (used for both AO and AC placeholders).
class OscillatorBar {
  final double value;
  final bool isBullish;
  const OscillatorBar(this.value, this.isBullish);
}

/// Top-level snapshot the dashboard renders from. One object, one source of truth.
class DashboardSnapshot {
  final List<Candle> candles;
  final List<CompositePoint> composite;
  final List<SessionBehavior> sessions;
  final NewsEvent? nextEvent;
  final SignalEngineState signalEngine;
  final List<OscillatorBar> ao;
  final List<OscillatorBar> ac;
  final double currentPrice;
  final bool isLiveData; // false = placeholder/mock, true = real MT5 feed

  const DashboardSnapshot({
    required this.candles,
    required this.composite,
    required this.sessions,
    required this.nextEvent,
    required this.signalEngine,
    required this.ao,
    required this.ac,
    required this.currentPrice,
    required this.isLiveData,
  });
}
