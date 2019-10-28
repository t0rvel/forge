from collections import defaultdict

# https://www.manning.com/books/classic-computer-science-problems-in-python

def itinerary_builder(flights, start):

    travel_dict = defaultdict(list)

    # initial origin finds where the start index is, in order to swap
    initial_origin = next(enum for enum, (origin, destination) in enumerate(flights) if origin == start)

    # swap initial origin to the 0th element, swap 0th element to initial origins original index
    flights[0], flights[initial_origin] = flights[initial_origin], flights[0]

    itinerary = [start]

    # build the dict to search from
    for pair in flights:
        travel_dict[pair[0]].append(pair[1])

    for origin, destinations in travel_dict.items():

        for enum, destination in enumerate(destinations):

            if not travel_dict[start][enum] in travel_dict:
                return None
            else:
                itinerary.append(destination)

    return itinerary


l1 = [('SFO', 'COM'), ('COM', 'YYZ')]
l2 = [('SFO', 'HKO'), ('YYZ', 'SFO'), ('YUL', 'YYZ'), ('HKO', 'ORD')]
l3 = [('A', 'B'), ('A', 'C'), ('B', 'C'), ('C', 'A')]

print(itinerary_builder(l2, 'YUL'))


# ruud example 1

def itinerary(trips, depart):
   trip = trips.copy()  # to not affect the orginal trips
   route = [depart]
   while trips:
       trip = min((trip for trip in trips if trip[0] == route[-1]), default=False)
       if not trip:
           return None
       route.append(trip[1])
       trips.remove(trip)
   return route


# loic example

def build_graph(airports_list):
    """
    :param airports_list: list of (departure,destination) airports
    :return: (graph, #edges).
    The graph uses a dictionary to store adjacency list / edge number
    """
    graph = {route[0]: [] for route in airports_list}
    for trip_index,trip in enumerate(airports_list):
        depart, dest = trip
        graph[depart].append((dest,trip_index))
    return graph, len(airports_list)


def itinerary(graph, nedges, start_airport):
    visited = [False]*nedges

    def dfs(airport):
        nonlocal visited
        if airport not in graph:
             return [airport]

        print(f"visiting airport: ", airport)
        possible_dest = list(filter(lambda x: not visited[x[1]], graph[airport]))
        if not possible_dest:
            return [airport]

        print(f"possible_dest = {possible_dest}")
        dest, trip = min(possible_dest, key=lambda x:x[0])
        print(f"dest: {dest}, trip: {trip}")
        visited[trip] = True
        return [airport] + dfs(dest)

    route = dfs(start_airport)
    print(f"computed route: {route}")
    print(f"visited trip: {visited}")
    return route if all(visited) else []

print("--- test 1")
test1, nedges = build_graph([('SFO', 'HKO'), ('YYZ', 'SFO'), ('YUL', 'YYZ'), ('HKO', 'ORD')])
assert itinerary(test1, nedges, 'YUL') == ['YUL', 'YYZ', 'SFO', 'HKO', 'ORD']
print("\n--- test 2")
test2, nedges = build_graph([('SFO', 'COM'), ('COM', 'YYZ')])
assert itinerary(test2, nedges, 'COM') == []
print("\n--- test 3")
test3, nedges = build_graph([('A', 'B'), ('A', 'C'), ('B', 'C'), ('C', 'A')])
assert itinerary(test3, nedges, 'A') == ['A', 'B', 'C', 'A', 'C']