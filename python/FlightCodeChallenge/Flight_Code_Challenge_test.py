from Flight_Code_Challenge import itinerary_builder

def test_route():
    flights = [('SFO', 'HKO'), ('YYZ', 'SFO'), ('YUL', 'YYZ'), ('HKO', 'ORD')]
    start = 'YUL'
    assert itinerary_builder(flights, start) == ['YUL', 'YYZ', 'SFO', 'HKO', 'ORD']


def test_lexicographically_shorter():
    flights = [('A', 'B'), ('A', 'C'), ('B', 'C'), ('C', 'A')]
    start = 'A'
    assert itinerary_builder(flights, start) == ['A', 'B', 'C', 'A', 'C']


def test_no_route():
    flights = [('SFO', 'COM'), ('COM', 'YYZ')]
    start = 'COM'
    assert itinerary_builder(flights, start) is None