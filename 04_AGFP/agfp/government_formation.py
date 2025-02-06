import random
import logging
from datetime import datetime, timedelta

logger = logging.getLogger(__name__)

class GovernmentFormation:
    """
    Simulates the process of government formation:
      - Designates a formateur.
      - Negotiates to form a coalition.
      - Presents the government (team and common program).
      - Runs a confidence vote in Parliament.
    """
    def __init__(self, election_data, coalition_calculator, ranked_coalitions):
        self.election_data = election_data
        self.coalition_calculator = coalition_calculator
        self.ranked_coalitions = ranked_coalitions
        self.formateur = None      # The party designated to form a government.
        self.coalition = None      # The coalition that is eventually formed.
        self.negotiation_deadline = timedelta(days=90)  # Negotiation time limit.
        self.formateur_deadline = timedelta(days=30)    # Formateur mandate deadline.
        self.attempts = 0
        self.max_attempts = 3  # After three failures, new elections are called.

    def designate_formateur(self):
        """
        Designates the formateur. The first attempt selects the party with the most seats;
        subsequent attempts select the next highest if the previous formateur fails.
        """
        sorted_parties = sorted(self.election_data.parties, key=lambda p: p.seats, reverse=True)
        if self.attempts == 0:
            self.formateur = sorted_parties[0]
        else:
            # On subsequent failures, choose the next eligible party.
            if self.attempts < len(sorted_parties):
                self.formateur = sorted_parties[self.attempts]
            else:
                self.formateur = sorted_parties[-1]
        logger.info(f"Designated formateur: {self.formateur.name}")
        self.attempts += 1

    def negotiate_coalition(self):
        """
        Simulates the negotiation process by allowing the formateur to select a coalition
        from the ranked list that includes itself. A random chance models negotiation success.
        """
        negotiation_start = datetime.now()
        while datetime.now() - negotiation_start < self.negotiation_deadline:
            # The formateur looks for the best (top-ranked) coalition in which it is a member.
            for coalition in self.ranked_coalitions:
                if self.formateur in coalition:
                    # Simulate a probability that negotiations succeed (70% chance here).
                    if random.random() < 0.7:
                        self.coalition = coalition
                        coalition_names = [p.name for p in coalition]
                        logger.info(f"Coalition formed: {coalition_names}")
                        return True
            # If no coalition including the formateur can be agreed upon within the loop, break.
            break
        logger.warning("Negotiation failed within deadline.")
        return False

    def present_government(self):
        """
        Simulates the presentation of the government, including the appointment of a Prime Minister
        (the formateur), the coalition composition, and a common government program.
        """
        if self.coalition is None:
            logger.error("No coalition formed to present a government.")
            return None
        government = {
            "Prime Minister": self.formateur.name,
            "Coalition": [p.name for p in self.coalition],
            "Common Program": "A set of agreed policies among coalition parties."
        }
        logger.info("Government presented:")
        logger.info(government)
        return government

    def run_confidence_vote(self):
        """
        Simulates a mandatory confidence vote in Parliament. The chance of approval is higher
        if the coalition's total seats are closer to the required minimum (i.e., a more stable coalition).
        """
        if self.coalition is None:
            logger.error("No coalition available for a confidence vote.")
            return False
        total_seats = sum(p.seats for p in self.coalition)
        stability = total_seats - self.coalition_calculator.min_seats_required
        # For demonstration: less excess seats result in a higher probability of approval.
        approval_probability = max(0.5, 1.0 - (stability * 0.05))
        vote_result = random.random() < approval_probability
        logger.info(f"Confidence vote result: {'Approved' if vote_result else 'Rejected'} (Probability: {approval_probability:.2f})")
        return vote_result
