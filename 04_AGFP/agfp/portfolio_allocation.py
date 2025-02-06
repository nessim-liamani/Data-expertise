import random
import logging

logger = logging.getLogger(__name__)

class PortfolioAllocation:
    """
    Allocates ministerial portfolios among coalition parties proportionally based on their seat share.
    A predefined set of ministries with weighted importance is distributed.
    """
    def __init__(self, coalition):
        self.coalition = coalition
        # Define a sample set of ministerial portfolios with their relative weights (importance).
        self.portfolios = {
            "Finance": 3,
            "Foreign Affairs": 3,
            "Interior": 2,
            "Justice": 2,
            "Health": 1,
            "Education": 1,
            "Defense": 2,
            "Economy": 2
        }

    def allocate(self):
        """
        Allocates each portfolio to one of the coalition parties. The allocation uses a
        weighted random choice based on the number of seats held by each party.
        """
        allocation = {}
        # Initialize allocation dictionary for each party.
        for party in self.coalition:
            allocation[party.name] = {}

        # Allocate each portfolio.
        for portfolio, weight in self.portfolios.items():
            weights = [p.seats for p in self.coalition]
            chosen_party = random.choices(self.coalition, weights=weights, k=1)[0]
            allocation[chosen_party.name][portfolio] = weight
            logger.info(f"Allocated portfolio '{portfolio}' to {chosen_party.name}")
        return allocation
