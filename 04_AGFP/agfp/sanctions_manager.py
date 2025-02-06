import logging

logger = logging.getLogger(__name__)

class SanctionsManager:
    """
    Imposes sanctions on parties that block or delay the government formation process.
    """
    def __init__(self):
        self.sanctions = {}  # Records the number of sanctions per party.

    def impose_sanctions(self, party):
        """
        Imposes a sanction on the given party and logs the penalty.
        """
        self.sanctions[party.name] = self.sanctions.get(party.name, 0) + 1
        logger.warning(f"Sanction imposed on {party.name}. Total sanctions: {self.sanctions[party.name]}")
        return self.sanctions[party.name]
