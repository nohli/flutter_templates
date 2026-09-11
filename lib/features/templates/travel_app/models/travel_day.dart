enum TravelStopKind { arrival, coffee, culture, food, coast, stay }

class TravelStop {
  const TravelStop({
    required this.id,
    required this.time,
    required this.title,
    required this.place,
    required this.detail,
    required this.kind,
  });

  final String id;
  final String time;
  final String title;
  final String place;
  final String detail;
  final TravelStopKind kind;
}

class TravelDay {
  const TravelDay({required this.weekday, required this.date, required this.summary, required this.stops});

  final String weekday;
  final String date;
  final String summary;
  final List<TravelStop> stops;

  static const samples = <TravelDay>[
    TravelDay(
      weekday: 'Fri',
      date: '18',
      summary: 'Arrival and old-town glow',
      stops: <TravelStop>[
        TravelStop(
          id: 'flight',
          time: '09:20',
          title: 'Land in Funchal',
          place: 'Cristiano Ronaldo Airport',
          detail: 'Pick up the compact car at arrivals.',
          kind: TravelStopKind.arrival,
        ),
        TravelStop(
          id: 'coffee',
          time: '11:10',
          title: 'First bica by the market',
          place: 'Mercado dos Lavradores',
          detail: 'A slow coffee before checking in.',
          kind: TravelStopKind.coffee,
        ),
        TravelStop(
          id: 'old-town',
          time: '15:00',
          title: 'Painted doors walk',
          place: 'Zona Velha',
          detail: 'Wander Rua de Santa Maria at your own pace.',
          kind: TravelStopKind.culture,
        ),
        TravelStop(
          id: 'dinner',
          time: '19:30',
          title: 'Dinner above the harbour',
          place: 'Santa Catarina terrace',
          detail: 'Golden-hour table reserved outside.',
          kind: TravelStopKind.food,
        ),
      ],
    ),
    TravelDay(
      weekday: 'Sat',
      date: '19',
      summary: 'Cloud forest to the Atlantic',
      stops: <TravelStop>[
        TravelStop(
          id: 'pico',
          time: '07:10',
          title: 'Sunrise above the clouds',
          place: 'Pico do Arieiro',
          detail: 'Pack the warm layer and trail breakfast.',
          kind: TravelStopKind.coast,
        ),
        TravelStop(
          id: 'levada',
          time: '10:30',
          title: 'Levada forest walk',
          place: 'Ribeiro Frio',
          detail: 'An easy trail through laurel forest.',
          kind: TravelStopKind.culture,
        ),
        TravelStop(
          id: 'lunch',
          time: '14:00',
          title: 'Seaside lunch',
          place: 'Porto da Cruz',
          detail: 'Fresh fish, milho frito, and ocean air.',
          kind: TravelStopKind.food,
        ),
        TravelStop(
          id: 'hotel',
          time: '18:20',
          title: 'Pool and reset',
          place: 'Funchal',
          detail: 'Nothing scheduled after sunset.',
          kind: TravelStopKind.stay,
        ),
      ],
    ),
    TravelDay(
      weekday: 'Sun',
      date: '20',
      summary: 'Ocean roads and a quiet farewell',
      stops: <TravelStop>[
        TravelStop(
          id: 'cabo',
          time: '09:00',
          title: 'Clifftop glass walk',
          place: 'Cabo Girão',
          detail: 'Arrive before the day tours.',
          kind: TravelStopKind.coast,
        ),
        TravelStop(
          id: 'village',
          time: '11:40',
          title: 'Village lanes',
          place: 'Câmara de Lobos',
          detail: 'Sketch boats and stop for poncha.',
          kind: TravelStopKind.culture,
        ),
        TravelStop(
          id: 'last-lunch',
          time: '14:10',
          title: 'Long Sunday lunch',
          place: 'Funchal marina',
          detail: 'The final reservation of the trip.',
          kind: TravelStopKind.food,
        ),
      ],
    ),
  ];
}
