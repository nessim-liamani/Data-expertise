import itertools
import logging

logger = logging.getLogger(__name__)

class CoalitionCalculator:
    """
    Computes all possible coalitions that satisfy the minimum seat requirement
    and linguistic/community parity.
    """
    def __init__(self, election_data, min_seats_required=76):
        self.election_data = election_data
        self.min_seats_required = min_seats_required

    def is_valid_coalition(self, coalition):
        """
        Checks whether a coalition meets:
          - The minimum seat threshold.
          - Linguistic/community parity (at least one party representing each major community).
        """
        total_seats = sum(p.seats for p in coalition)
        if total_seats < self.min_seats_required:
            return False
        # Check that coalition includes at least one "Flemish" (or "Bilingual") and one "Francophone" (or "Bilingual")
        has_flemish = any(p.community in ["Flemish", "Bilingual"] for p in coalition)
        has_francophone = any(p.community in ["Francophone", "Bilingual"] for p in coalition)
        return has_flemish and has_francophone

    def compute_possible_coalitions(self):
        """
        Computes all combinations of parties that form valid coalitions.
        """
        parties = self.election_data.parties
        possible_coalitions = []
        # Iterate over all non-empty combinations of parties
        for r in range(1, len(parties) + 1):
            for coalition in itertools.combinations(parties, r):
                if self.is_valid_coalition(coalition):
                    possible_coalitions.append(coalition)
        logger.info(f"Found {len(possible_coalitions)} possible valid coalitions.")
        return possible_coalitions

    def rank_coalitions(self, coalitions):
        """
        Ranks coalitions by a simple stability metric: the excess seats over the minimum required.
        Fewer excess seats imply a more stable and efficient coalition.
        """
        def stability_score(coalition):
            total_seats = sum(p.seats for p in coalition)
            return total_seats - self.min_seats_required  # Lower is better

        ranked = sorted(coalitions, key=stability_score)
        logger.info("Coalitions ranked by stability (excess seats).")
        return ranked
