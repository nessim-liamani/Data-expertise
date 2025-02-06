import logging

logger = logging.getLogger(__name__)

class InterimGovernment:
    """
    Forms a caretaker (interim) government from a pre-approved pool of technocrats,
    to be used if the coalition negotiation exceeds the allowed time.
    """
    def __init__(self, technocrat_pool):
        # 'technocrat_pool' is expected to be a dictionary mapping ministry names to technocrat names.
        self.technocrat_pool = technocrat_pool
        self.caretaker = {}

    def form_caretaker(self):
        """
        Forms the caretaker government by copying the pre-qualified technocrats.
        """
        self.caretaker = self.technocrat_pool.copy()
        logger.info("Caretaker government formed:")
        logger.info(self.caretaker)
        return self.caretaker
