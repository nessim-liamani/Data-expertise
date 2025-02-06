import logging

logger = logging.getLogger(__name__)

class Party:
    """
    Represents a political party with a name, number of seats, and community affiliation.
    """
    def __init__(self, name, seats, community):
        self.name = name
        self.seats = seats
        self.community = community  # e.g., "Flemish", "Francophone", "Bilingual"

    def __repr__(self):
        return f"{self.name}({self.seats}, {self.community})"

class ElectionData:
    """
    Handles election data including the list of parties and their seats.
    """
    def __init__(self, parties):
        self.parties = parties  # list of Party objects
        self.total_seats = sum(p.seats for p in parties)

    def publish_data(self):
        """
        Publishes election results to a public dashboard (here, simply logs the data).
        """
        logger.info("Election Results:")
        for party in self.parties:
            logger.info(f"Party: {party.name}, Seats: {party.seats}, Community: {party.community}")
